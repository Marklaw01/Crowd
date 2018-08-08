<?php
namespace App\Controller;

use App\Controller\AppController;
use Cake\ORM\TableRegistry;
use Cake\Filesystem\Folder;
use Cake\Filesystem\File;
use Cake\Database\Expression\QueryExpression;
use Cake\Mailer\Email;
use Cake\Routing\Router;
use Cake\Datasource\ConnectionManager;
/**
* Users Controller
*
*@property\App\Model\Table\Users table $users
**/ 
class ForumsController extends AppController{
    public $helpers = ['Custom'];

    public function initialize()
    {
    parent::initialize();
    $this->loadComponent('Upload');
    $this->loadComponent('UserImageWeb');
    $this->loadComponent('WebNotification');
    $this->loadComponent('Feeds');
    }

    
    /**
    * index Method for list messages
    *
    *
    */

    public function index()
    {
            return $this->redirect(['action' => 'startupForum']);
    }


    /**
    * archived Method for list messages
    *
    *
    */

    public function archivedForum()
    {
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 10];

            $forums = $this->Forums->find('all', ['conditions' => ['Forums.user_id' => $UserId,'Forums.status'=>1,'Forums.user_status'=>1] , 'order'=>['Forums.id DESC']]);

            /// NEED TO REPLACE THIS $campaigns WITH $this->Campaigns IN BELOW CODE TO GET LOGGED USER CAMPAIGNS
            $this->set('forums', $this->paginate($forums));
            $this->set('_serialize', ['forums']);     
    }

    /**
    * startupForum Method for list startupForum
    *
    *
    */

    public function startupForum()
    {
            $this->loadModel('Startups');
            $StartupTeamsTable = $this->loadModel('StartupTeams');
            $this->paginate = [ 'limit' => 10];
            $user = $this->Auth->user();
            if($user){

                    $UserId = $this->request->Session()->read('Auth.User.id');


                    $teamStartupIDs = $StartupTeamsTable->find('all',
                                                ['conditions'=>['StartupTeams.user_id'=>$UserId]])
                                                ->select(['startup_id']);   
                    
                    $CurrentStartupList='';

                        if($teamStartupIDs->toArray()){

                            $startupsIDsArray = $teamStartupIDs->toArray();
                                
                                foreach($startupsIDsArray as $singleStartupsIDsObject):
                                    if($singleStartupsIDsObject->startup_id!=''):
                                        $finalIDs[] = $singleStartupsIDsObject->startup_id;
                                    endif;
                                endforeach;

                            if(!empty($finalIDs)) 
                            {
                                $CurrentStartupList = $this->Startups->find('all')
                                                        ->where(['id IN'=>$finalIDs]);

                                $this->set('CurrentStartupLists', $this->paginate($CurrentStartupList));   

                            }else{
                                $this->set('CurrentStartupLists', $this->paginate($CurrentStartupList));
                            }   
                        }else{
                                $this->set('CurrentStartupLists', $this->paginate($CurrentStartupList));
                        }

                    $this->set('CurrentStartupLists', $CurrentStartupList);
            }                                         

    }


    /**
    * viewForumList Method for list myForum
    *
    *
    */

    public function viewForumList($id=null)
    {
            $startupId = base64_decode($id);
            $this->set('formId',$startupId); 
            $this->paginate = [ 'limit' => 10];

            $StartupTeamsTable = $this->loadModel('StartupTeams');

            $user = $this->Auth->user();
            if($user){

                     $UserId = $this->request->Session()->read('Auth.User.id');

                     $yesValidUser = $StartupTeamsTable->find('all',
                                                ['conditions'=>['StartupTeams.startup_id'=>$startupId, 'StartupTeams.user_id'=>$UserId]])->first(); 
     
                     if(!empty($yesValidUser)){ 

                        $forums = $this->Forums->find('all')->where(['Forums.startup_id'=>$startupId,'Forums.status'=>1]); 
                        $this->set('forums', $this->paginate($forums));

                     }else {

                        $this->Flash->error('Ops something wrong! Please try again.');
                        return $this->redirect(['action' => 'startupForum']);
                     }
                     
            }                      
    }

    /**
    * searchForum Method for list searchForum
    *
    *
    */

    public function searchForum()
    {
            $this->paginate = [ 'limit' => 10,'order' => ['Forums.id' => 'desc']];
            
            $ForumsTable = $this->loadModel('Forums');
            $UserFollowersTable = $this->loadModel('UserFollowers');

            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword =$this->request->query('search');
            $searchKeyword = str_replace("'","",$searchKeyword);
            $formLists='';
            if($searchKeyword==''){

                    $startup_ids = $this->UserFollowers->find('all',
                                                        ['conditions'=>['UserFollowers.followed_by'=>$UserId]])
                                                        ->select(['user_id'])->toArray();

                    if($startup_ids){
                        foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['user_id'])&&($SingleUser['user_id']!='')){
                                $userIDs[] = $SingleUser['user_id'];
                            }
                        endforeach;

                        if(!empty($userIDs)){

                            $formLists = $this->Forums->find('all')
                                                ->where(['Forums.user_id IN'=>$userIDs,
                                                         'Forums.user_id !='=>$UserId,
                                                         'Forums.status'=>1]);

                            //To search his own forums
                            /*$formLists = $this->Forums->find('all')
                                                ->where(['Forums.user_id IN'=>$userIDs,
                                                         'Forums.user_id '=>$UserId,
                                                         'Forums.status'=>1]);*/
                  
                            $this->set('formLists', $this->paginate($formLists));

                        }else{

                            $this->set('formLists', $formLists);
                        }
                    }else{

                        //To search his own forums
                        /*$formLists = $this->Forums->find('all')
                                                ->where(['Forums.user_id '=>$UserId,
                                                         'Forums.status'=>1]);
                        $this->set('formLists', $this->paginate($formLists));                                 */

                        $this->set('formLists', $formLists);
                    }
                    
            }else {

                    $connection = ConnectionManager::get('default');
                                             
                    $qq = "SELECT FO.id FROM keywords as KY INNER JOIN forums as FO
                            ON FIND_IN_SET(KY.id, FO.keywords) where KY.name like '%".$searchKeyword."%' GROUP BY FO.id
                            UNION SELECT FO.id FROM forums as FO where FO.title like '%".$searchKeyword."%' ";
                    
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');

                    if(!empty($startup_ids)){

                        foreach($startup_ids as $SingleUser):
                                    if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                        $startupIDs[] = $SingleUser['id'];
                                    }
                        endforeach;

                            if(!empty($startupIDs)){

                                $formLists = $this->Forums->find('all')
                                                        ->where(['Forums.id IN'=>$startupIDs,
                                                                 'Forums.user_id !='=>$UserId,
                                                                 'Forums.status'=>1]);
                                //To search his own forums                                 
                                /*$formLists = $this->Forums->find('all')
                                                        ->where(['Forums.id IN'=>$startupIDs,
                                                                 'Forums.user_id '=>$UserId,
                                                                 'Forums.status'=>1]);*/


                                $this->set('formLists', $this->paginate($formLists));                        
                            }else{
                               $this->set('formLists', $formLists); 
                            }
                    }else{

                        $this->set('formLists', $formLists);
                    }

            }

    }

    /**
    * myForum Method for list myForum
    *
    *
    */

    public function myForum()
    {   
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 10];

            $forums = $this->Forums->find('all', ['conditions' => ['Forums.user_id' => $UserId,'Forums.status'=>1,'Forums.user_status'=>0] , 'order'=>['Forums.id DESC']]);

            /// NEED TO REPLACE THIS $campaigns WITH $this->Campaigns IN BELOW CODE TO GET LOGGED USER CAMPAIGNS
            $this->set('forums', $this->paginate($forums));
            $this->set('_serialize', ['forums']);  
            
    }



    /**
    * viewForum Method for list myForum
    *
    *
    */

    public function viewForum($id=null,$allComm=null)
    {
         $formId = base64_decode($id);
         $this->set('formId',$formId);
         $this->paginate = ['limit' => 5];

         $this->loadModel('ForumComments');

         $forumDetails = $this->Forums->find('all',['conditions'=>['Forums.id'=>$formId,'Forums.status'=>1]])->contain(['ForumComments'])->first();
         $forumOwnerId= $forumDetails->user_id;
         $forumName= $forumDetails->title;

         /*$Keywords = $this->Forums->Keywords->find('list')->toArray();
         $this->set('Keywords',$Keywords);*/ 

         $this->loadModel('KeywordForums');
         $Keywords = $this->KeywordForums->find('list')->toArray();
         $this->set('Keywords',$Keywords);

        
        //Get comments list related to forum
        $allforumComments= $this->Forums->ForumComments->find('all',['conditions'=>['ForumComments.forum_id'=>$formId],'order'=>['ForumComments.id ASC']]);
        $this->set('allForumComments', $allforumComments);
        
        $this->set('commentcount', $allforumComments->count());
        //Get latest comments list related to forum
        $forumComments= $this->Forums->ForumComments->find('all',['conditions'=>['ForumComments.forum_id'=>$formId],'limit' => 5, 'order'=>['ForumComments.id DESC']]);

        $forumComments = array_reverse($forumComments->toArray());
        
        $this->set('forumComments', $forumComments);

         $UserId = $this->request->Session()->read('Auth.User.id');
         $this->set('UserId', $UserId);

        if(!empty($forumDetails)){
            $this->set('forumDetails', $forumDetails);
        }else{
            return $this->redirect(['action' => 'startupForum']);
        }

        $commentForm= $this->ForumComments->newEntity(); 
            if ($this->request->is(['patch', 'post', 'put'])) {
                $this->request->data['user_id']=$UserId;
                $this->request->data['forum_id']=$formId;

                $commentForm = $this->ForumComments->patchEntity($commentForm,$this->request->data); 

                        if ($this->ForumComments->save($commentForm)) {

                            //Save Feeds
                            $this->Feeds->saveForumFeeds($UserId,'feeds_foum_message',$formId);

                            if($forumDetails->user_id != $UserId){
                               //Save user notification
                               $values = ['forum_id'=>$formId,
                                         'forum_name'=>$forumName];
                               //,json_encode($values);
                                $link= Router::url(['controller' => 'Forums', 'action' => 'viewForum',$id]);
                                $this->WebNotification->sendNotification($UserId,$forumOwnerId,'Comment_Forum','has commented on your Forum <strong> '.$forumName.'.</strong>',$link,$values);
                            }    
                                     $this->Flash->success('Comment has been posted successfully.'); 
                                     return $this->redirect($this->referer()); 

          
                        }else {
                                $this->Flash->error('Unable to post your Comment.Please try again.');
                        }
            }
        $this->set('commentForm', $commentForm); 
    }

    /**
    * myForum Method for list myForum
    *
    *
    */

    public function addForum()
    {
            $user = $this->Auth->user();
            if($user){

                     $UserId = $this->request->Session()->read('Auth.User.id');
                     $forum = $this->Forums->newEntity(); 

                    /* $Keywords = $this->Forums->Keywords->find('list')->toArray();
                     $this->set('Keywords',$Keywords); */

                     $this->loadModel('KeywordForums');
                     $Keywords = $this->KeywordForums->find('list')->toArray();
                     $this->set('Keywords',$Keywords);

                     $startups = $this->Forums->Startups->find('list',['conditions' => ['Startups.user_id' => $UserId]]);  
                     $this->set('startups',$startups); 

                     if ($this->request->is(['patch', 'post', 'put'])) {

                        $keyword ='';
                        if(!empty($this->request->data['keywords'])){
                          $keyword = implode(',', $this->request->data['keywords']);
                        }
                        $this->request->data['keywords'] = $keyword;


                        $flag=0;
                        $forumImgName='';
                        if(!empty($this->request->data['image']['name'])){
                            $upload = $this->UserImageWeb->forumImageUpload($this->request->data['image']);

                            if(empty($upload['errors'])){
                                    $forumImgName=$upload['imgName'];
                            }else {
                                    $flag=1;
                                    $forumImgName='';
                            }
                        } 

                        if($flag==1){
                                $this->Flash->error('Invalid! Allowed extensions are .jpg, .jpeg, .gif, .png.. Max upload size 2MB.');
                        }else { 
                            $forum = $this->Forums->patchEntity($forum,$this->request->data); 
                            $forum->user_id=$UserId;
                            $forum->image=$forumImgName;
                            $resultSave = $this->Forums->save($forum);
                            if ($resultSave) {

                                //Save Feeds
                                $this->Feeds->saveForumFeeds($UserId,'feeds_forum_added',$resultSave->id);

                                $this->Flash->success('Forum has been saved successfully.'); 
                                return $this->redirect(['action' => 'myForum']);
                               // return $this->redirect($this->referer());  
                                
                            }else {
                                $this->Flash->error('Unable to save forum.Please try again.');
                            }
                        }    
                     }

                     $this->set('forum',$forum);
             }        
    }

    /**
    * viewForum Method for list myForum
    *
    *
    */

    public function editForum($id = null)
    {
            $formId = base64_decode($id);
            $this->set('formId',$id); 

            $user = $this->Auth->user();
            if($user){

                     $UserId = $this->request->Session()->read('Auth.User.id');
                     $forum = $this->Forums->newEntity(); 

                     /*$Keywords = $this->Forums->Keywords->find('list')->toArray();
                     $this->set('Keywords',$Keywords); */

                     $this->loadModel('KeywordForums');
                     $Keywords = $this->KeywordForums->find('list')->toArray();
                     $this->set('Keywords',$Keywords);

                     $startups = $this->Forums->Startups->find('list',['conditions' => ['Startups.user_id' => $UserId]]);  
                     $this->set('startups',$startups);  

                //Check is form created by login
                $forum = $this->Forums->find('all',['conditions'=>['Forums.id'=>$formId,'Forums.user_id'=>$UserId,'Forums.status'=>1]])->first();

                if(!empty($forum)){
                        $flag=0;
                        $forumImgName=$forum->image;
                        $userStatus= $forum->user_status;
                        if(!empty($this->request->data['image']['name'])){
                            $upload = $this->UserImageWeb->forumImageUpload($this->request->data['image']);

                            if(empty($upload['errors'])){
                                    $forumImgName=$upload['imgName'];
                            }else {
                                    $flag=1;
                                    $forumImgName='';
                            }
                        } 

                        if($flag==1){

                                $this->Flash->error('Invalid! Allowed extensions are .jpg, .jpeg, .gif, .png.. Max upload size 2MB.');

                        }else { 

                            if ($this->request->is(['patch', 'post', 'put'])) {

                                $keyword ='';
                                if(!empty($this->request->data['keywords'])){
                                  $keyword = implode(',', $this->request->data['keywords']);
                                }
                                $this->request->data['keywords'] = $keyword;

                                $forum = $this->Forums->patchEntity($forum,$this->request->data); 
                                $forum->user_id=$UserId;
                                $forum->image=$forumImgName;
                                $forum->user_status=$userStatus;

                                if ($this->Forums->save($forum)) {

                                      $this->Flash->success('Forum has been updated successfully.'); 
                                      if($userStatus == 1){
                                        return $this->redirect(['action' => 'archivedForum']);
                                      }else {
                                        return $this->redirect($this->referer());  
                                      }
                                }else {
                                    $this->Flash->error('Unable to update forum.Please try again.');
                                }
                            }   
                        }


                }else{

                    $this->Flash->error('You are not allowed to access that page.');
                    return $this->redirect(['action' => 'myForum']);
                }

                $this->set('forum',$forum);      
            }         
    }

    
    /**
    * archiveForum Method for list messages
    *
    *
    */
    public function archiveForum($id = null)
    {
        $formId = base64_decode($id);
        $this->request->allowMethod(['post', 'archiveForum']);
        $Forums = $this->Forums->get($formId);

        if ($Forums) {

            $query = $this->Forums->query();

            $suucess = $query->update()->set(['user_status'=>1])->where(['id' => $formId])->execute();
            if($suucess){

                $this->Flash->success('Forum has been archived successfully.');
            
            }else{
                $this->Flash->error('Forum could not be archived. Please, try again.');
            }
        } else {
            $this->Flash->error('Forum could not be archived. Please, try again.');
        }
        return $this->redirect(['action' => 'myForum']);
    }

    /**
    * closeForum Method for list messages
    *
    *
    */
    public function closeForum($id = null)
    {
        $formId = base64_decode($id);
        $this->request->allowMethod(['post', 'closeForum']);
        $Forums = $this->Forums->get($formId);

        if ($Forums) {

            $query = $this->Forums->query();

            $suucess = $query->update()->set(['user_status'=>2])->where(['id' => $formId])->execute();
            if($suucess){

                $this->Flash->success('Forum has been closed successfully.');
            
            }else{
                $this->Flash->error('Forum could not be closed. Please, try again.');
            }
        } else {
            $this->Flash->error('Forum could not be closed. Please, try again.');
        }
        return $this->redirect(['action' => 'myForum']);
    }

    /**
    * closeForum Method for list messages
    *
    *
    */
    public function openForum($id = null)
    {
        $formId = base64_decode($id);
        $this->request->allowMethod(['post', 'closeForum']);
        $Forums = $this->Forums->get($formId);

        if ($Forums) {

            $query = $this->Forums->query();

            $suucess = $query->update()->set(['user_status'=>0])->where(['id' => $formId])->execute();
            if($suucess){

                $this->Flash->success('Forum has been opened successfully.');
            
            }else{
                $this->Flash->error('Forum could not be opened. Please, try again.');
            }
        } else {
            $this->Flash->error('Forum could not be opened. Please, try again.');
        }
        return $this->redirect(['action' => 'myForum']);
    }


    /**
    * deleteForum Method for list messages
    *
    *
    */
    public function deleteForum($id = null)
    {
        $formId = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $Forums = $this->Forums->get($formId);
        if ($this->Forums->delete($Forums)) {
            $this->Flash->success('Forum has been deleted successfully.');
        } else {
            $this->Flash->error('Forum could not be deleted. Please, try again.');
        }
        return $this->redirect(['action' => 'myForum']);
    }



    /**
    * reportForum Method for Basic Profile edit
    *
    *
    */
    public function reportForum($id=null)
    {       
            $formId = base64_decode($id);
            $this->set('formId',$formId);
            $this->paginate = [ 'limit' => 10];

            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId',$UserId);

            $this->loadModel('ForumComments');

            $forumDetails = $this->Forums->find('all',['conditions'=>['Forums.id'=>$formId,'Forums.status'=>1]])->contain(['ForumComments'])->first();
            
            //Get comments list related to forum
            $forumCommentUsers= $this->Forums->ForumComments->find('all',['conditions'=>['ForumComments.forum_id'=>$formId,'ForumComments.user_id !='=>$UserId]])->distinct('user_id');

            $this->set('forumCommentUsers', $this->paginate($forumCommentUsers));

            
            

            if(!empty($forumDetails)){
                $this->set('forumDetails', $forumDetails);
            }else{
                return $this->redirect(['action' => 'startupForum']);
            }

            $reportForm= $this->Forums->ForumReports->newEntity(); 
                if ($this->request->is(['patch', 'post', 'put'])) {


                    if(empty($this->request->data['reported_users']) && empty($this->request->data['is_form_reported'])){

                            $this->Flash->error('Please select reported users.');

                    }else{

                            $reported_users ='';
                            $accArray= [];
                            if(!empty($this->request->data['reported_users'])){
                                $accArray= $this->request->data['reported_users'];
                                $reported_users = implode(',', $this->request->data['reported_users']);
                            }
                            $this->request->data['reported_users']=$reported_users;


                            $is_form_reported =0;
                            $own_forum = 'false';
                            if(!empty($this->request->data['is_form_reported'])){
                                $own_forum = 'true';
                                $is_form_reported =1;
                            }
                            $this->request->data['is_form_reported']=$is_form_reported;

                            $this->request->data['user_id']=$UserId;
                            $this->request->data['forum_id']=$formId;
                            $this->request->data['status']=0;

                            $reportForm = $this->Forums->ForumReports->patchEntity($reportForm,$this->request->data); 

                                    if ($this->Forums->ForumReports->save($reportForm)) {
                                         
                                         $forumOwnerId= $forumDetails->user_id;
                                         $forumName= $forumDetails->title;     
                                        // send notification to selected users
                                        $link= Router::url(['controller' => 'Forums', 'action' => 'viewForum',$id]);

                                        //Send notification to forum owner
                                        
                                        $values = ['forum_id'=>$forumOwnerId,
                                                    'forum_name'=>$forumName,
                                                    'own_forum'=>$own_forum
                                                   ];
                                        //,json_encode($values);
                                        if($is_form_reported==1){
                                            $this->WebNotification->sendNotification($UserId,$forumOwnerId,'Report_Abuse_Forum','has reported your forum <strong> '.$forumName.'</strong>',$link,$values);
                                        }else{           
                                            $this->WebNotification->sendNotification($UserId,$forumOwnerId,'Report_Abuse_Forum','has reported user on your forum <strong> '.$forumName.'</strong>',$link,$values);
                                        }

                                        if(!empty($accArray)){
                                            $coun= count($accArray);
                                            for($v=0;$v<$coun; $v++){
                                                //echo $accArray[$v];
                                                $this->WebNotification->sendNotification($UserId,$accArray[$v],'Report_Abuse_User','has reported you on forum <strong> '.$forumName.'</strong>',$link,$values);  
                                            }
                                        }
                                        

                                            $this->Flash->success('Report has been sent successfully.'); 
                                            return $this->redirect($this->referer());  
                                            
                                    }else {
                                            $this->Flash->error('Unable to send your report.Please try again.');
                                    }
                    }                
                }
            $this->set('reportForm', $reportForm);        
        }


}
?>