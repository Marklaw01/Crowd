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
 * Campaigns Controller
 *
 * @property \App\Model\Table\CampaignsTable $Campaigns
 */
class FocusGroupsController extends AppController
{
    public $helpers = ['Custom'];

    /**
     * Index method
     *
     * @return void
     */
    public function initialize()
    {
        parent::initialize();
        $this->loadComponent('Multiupload');
        $this->loadComponent('UserImageWeb');
        $this->loadComponent('WebNotification');
        $this->loadComponent('FocusGroupUpload');
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['FocusGroups.id' => 'desc']];
            $this->loadModel('FocusGroups');
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM focus_group_keywords as KY INNER JOIN focus_groups as SU ON FIND_IN_SET(KY.id, SU.focus_group_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->FocusGroups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'FocusGroups.user_id !='=>$UserId, 'FocusGroups.status'=>1,

                                                                    'OR' =>[
                                                                                ['FocusGroups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['FocusGroups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->FocusGroups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'FocusGroups.user_id !='=>$UserId, 'FocusGroups.status'=>1,

                                                                    'OR' =>[
                                                                                ['FocusGroups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists = $this->FocusGroups->find('all',['conditions'=>['FocusGroups.user_id !='=>$UserId,'FocusGroups.status'=>1]])->contain(['Users']);
            }

                
                $this->set('myFundsLists',$this->paginate($myFundsLists));
    }


     /**
     *
     *
     * My myBetaTest method
     *
     * 
     ***/
    public function myFocusGroup()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['FocusGroups.id' => 'desc']];
           $this->loadModel('FocusGroups');
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM focus_group_keywords as KY INNER JOIN focus_groups as SU ON FIND_IN_SET(KY.id, SU.focus_group_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->FocusGroups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'FocusGroups.user_id '=>$UserId, 'FocusGroups.status'=>1,

                                                                    'OR' =>[
                                                                                ['FocusGroups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['FocusGroups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->FocusGroups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'FocusGroups.user_id '=>$UserId, 'FocusGroups.status'=>1,

                                                                    'OR' =>[
                                                                                ['FocusGroups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->FocusGroups->find('all',['conditions'=>['FocusGroups.user_id'=>$UserId,'FocusGroups.status'=>1]])->contain(['Users']);
            }

           
           
           $this->set('myFundsLists', $this->paginate($myFundsLists));
    }

     /******
     * myArchived method
     *
     * 
     *
     *
     *****/

    public function myArchived()
    {         
         $this->paginate = [ 'limit' => 10,'order' => ['FocusGroups.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);
           $this->loadModel('FocusGroups');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM focus_group_keywords as KY INNER JOIN focus_groups as SU ON FIND_IN_SET(KY.id, SU.focus_group_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->FocusGroups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'FocusGroups.user_id '=>$UserId, 'FocusGroups.status'=>2,

                                                                    'OR' =>[
                                                                                ['FocusGroups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['FocusGroups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->FocusGroups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'FocusGroups.user_id '=>$UserId, 'FocusGroups.status'=>2,

                                                                    'OR' =>[
                                                                                ['FocusGroups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->FocusGroups->find('all',['conditions'=>['FocusGroups.user_id'=>$UserId,'FocusGroups.status'=>2]])->contain(['Users']);
            }

           
           
           $this->set('myFundsLists', $this->paginate($myFundsLists));      
        
    }


    /**
     * myDeactivated Following method
     *
     * 
     */
     public function myDeactivated()
     {  
           $this->paginate = [ 'limit' => 10,'order' => ['FocusGroups.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);
           $this->loadModel('FocusGroups');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM focus_group_keywords as KY INNER JOIN focus_groups as SU ON FIND_IN_SET(KY.id, SU.focus_group_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->FocusGroups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'FocusGroups.user_id '=>$UserId, 'FocusGroups.status'=>0,

                                                                    'OR' =>[
                                                                                ['FocusGroups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['FocusGroups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->FocusGroups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'FocusGroups.user_id '=>$UserId, 'FocusGroups.status'=>0,

                                                                    'OR' =>[
                                                                                ['FocusGroups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->FocusGroups->find('all',['conditions'=>['FocusGroups.user_id'=>$UserId,'FocusGroups.status'=>0]])->contain(['Users']);
            }

           
           
           $this->set('myFundsLists', $this->paginate($myFundsLists));

     }


    /**
    * archive Method
    *
    *
    ***/
    public function activate($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->FocusGroups->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Focus Group has been activated.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('The Focus Group could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myFocusGroup']);
                }
          
    }

     /**
    * archiveFund Method
    *
    *
    ***/
    public function archive($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->FocusGroups->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Focus Group has been archived successfully.');
                    $this->redirect(['action' => 'myFocusGroup']);

                }else{

                    $this->Flash->error('The Focus Group could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myFocusGroup']);
                }
          
    }

     /**
    * archiveFund Method
    *
    *
    ***/
    public function deactivate($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->FocusGroups->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Focus Group has been deactivated.');
                    $this->redirect(['action' => 'myFocusGroup']);

                }else{

                    $this->Flash->error('The Focus Group could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myFocusGroup']);
                }
          
    }


     /**
    * archiveFund Method
    *
    *
    ***/
    public function delete($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->FocusGroups->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Focus Group has been deleted successfully.');
                    $this->redirect(['action' => 'myFocusGroup']);

                }else{

                    $this->Flash->error('The Focus Group could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myFocusGroup']);
                }
          
    }


    /*
     *  likeFund method 
     *
     *
     *
     *
     ***/
    public function like($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->FocusGroups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('FocusGroupDislikes');
                    $likeExists= $this->FocusGroupDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'focus_group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->FocusGroupDislikes->get($likeExists->id);
                        $this->FocusGroupDislikes->delete($entity);
                    }

                    $this->loadModel('FocusGroupLikes');
                    $likefunds = $this->FocusGroupLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['focus_group_id']=$fundId;
                    $likefunds = $this->FocusGroupLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->FocusGroupLikes->find('all',['conditions'=>['like_by'=>$likeBy,'focus_group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->FocusGroupLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Focus Group liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Focus Group. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Focus Group. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unlike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->FocusGroups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('FocusGroupLikes');
                    $likeExists= $this->FocusGroupLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'focus_group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->FocusGroupLikes->get($likeExists->id);
                        $this->FocusGroupLikes->delete($entity);
                    

                        $this->Flash->success('Focus Group unliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->success('Could not unlike Focus Group. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find Focus Group.');
                    return $this->redirect($this->referer());
                }        
    }

    /*
     *  followFund method 
     *
     *
     *
     *
     ***/
    public function follow($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->FocusGroups->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('FocusGroupFollowers');
                    $FundFollowers = $this->FocusGroupFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['focus_group_id']=$fundId;
                    $likefunds = $this->FocusGroupFollowers->patchEntity($FundFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->FocusGroupFollowers->find('all',['conditions'=>['user_id'=>$followBy,'focus_group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->FocusGroupFollowers->save($likefunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveFocusGroupFeeds($followBy,'feeds_focusgroup_following',$fundId);
                            
                            $this->Flash->success('Focus Group followed successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Focus Group. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Endorser.');
                    return $this->redirect($this->referer());
                }           
    }

    /*
     *  unfollowFund method 
     *
     *
     *
     *
     ***/
    public function unfollow($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->FocusGroups->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('FocusGroupFollowers');
                $likeExists= $this->FocusGroupFollowers->find('all',['conditions'=>['user_id'=>$followBy,'focus_group_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->FocusGroupFollowers->get($likeExists->id);
                    $this->FocusGroupFollowers->delete($entity);
                }

                $this->Flash->success('Focus Group unfollowed successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Focus Group.');
                return $this->redirect($this->referer());
            }        
    }

    /***
     *  
     * disLikeFund method 
     *
     *
     *
     ***/
    public function disLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->FocusGroups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('FocusGroupLikes');
                    $likeExists= $this->FocusGroupLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'focus_group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->FocusGroupLikes->get($likeExists->id);
                        $this->FocusGroupLikes->delete($entity);
                    }

                    $this->loadModel('FocusGroupDislikes');
                    $dislikefunds = $this->FocusGroupDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['focus_group_id']=$fundId;
                    $dislikefunds = $this->FocusGroupDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->FocusGroupDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'focus_group_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->FocusGroupDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Focus Group disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Focus Group. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Focus Group.');
                    return $this->redirect($this->referer());
                }        
    }

    public function undisLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->FocusGroups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('FocusGroupDislikes');
                    $likeExists= $this->FocusGroupDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'focus_group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->FocusGroupDislikes->get($likeExists->id);
                        $this->FocusGroupDislikes->delete($entity);
                    

                        $this->Flash->success('Focus Group undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Focus Group. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Focus Group. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

     /*  21>
     *  focusCommitment method 
     *
     *
     *
     *
     ***/
    public function commit($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');
            $this->loadModel('FocusCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->FocusGroups->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['focus_group_id']=$fundId;

                    $likefunds = $this->FocusCommitments->newEntity(); 
                    $likefunds = $this->FocusCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->FocusCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'focus_group_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->FocusCommitments->save($likefunds);

                        if ($resultSave){

                            $this->Flash->success('Registered your interest successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not register your interest. Please try again.');
                            return $this->redirect($this->referer()); 
                        }
  
                }else{
                    $this->Flash->error('Could not register your interest or no record found. Please try again.');
                    return $this->redirect($this->referer());
                }        
    }

    /*  22>
     *  focusUncommitment method 
     *
     *
     *
     *
     ***/
    public function uncommit($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('FocusGroups');
            $this->loadModel('FocusCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->FocusGroups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->FocusCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'focus_group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->FocusCommitments->get($likeExists->id);
                        $this->FocusCommitments->delete($entity);
                    }


                            $this->Flash->success('Un Registered your interest successfully.');
                            return $this->redirect($this->referer());

                }else{
                    $this->Flash->error('Could not Un Registered your interest or no record found. Please try again.');
                    return $this->redirect($this->referer());
                    
                }        

    }


    /**
    * view Method
    *
    *
    ***/
    public function view($id=null)
    {
            $this->loadModel('FocusGroups');
            $this->loadModel('FocusGroupKeywords');
            $this->loadModel('FocusGroupInterestKeywords');
            $this->loadModel('FocusGroupTargetMarkets');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->FocusGroupInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->FocusGroupTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->FocusGroupKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->FocusGroups->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->FocusGroups->find('all',['conditions'=>['FocusGroups.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->FocusGroupUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->FocusGroupUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);
            }else{

                $this->Flash->success('Could not find Focus Group. Please, try again.');
                return $this->redirect($this->referer());
            } 

    }


    /*
     *  addFunds method
     *
     *
     *
     *
     ***/
    public function add()
    {
        $userTimeZone = $this->WebNotification->getUserTimeZoneByIp();
        date_default_timezone_set($userTimeZone);

            $this->loadModel('FocusGroups');
            $this->loadModel('FocusGroupKeywords');
            $this->loadModel('FocusGroupInterestKeywords');
            $this->loadModel('FocusGroupTargetMarkets');


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->FocusGroupInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->FocusGroupTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->FocusGroupKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->FocusGroups->newEntity(); 



            if($this->request->is('post'))
            {

                $target_market ='';
                if(!empty($this->request->data['target_market'])){
                  $target_market = implode(',', $this->request->data['target_market']);
                }
                $this->request->data['target_market']=$target_market;

                $interest_keywords_id ='';
                if(!empty($this->request->data['focus_group_interest_keywords_id'])){
                  $interest_keywords_id = implode(',', $this->request->data['focus_group_interest_keywords_id']);
                }
                $this->request->data['focus_group_interest_keywords_id']=$interest_keywords_id;

                $keywords_id ='';
                if(!empty($this->request->data['focus_group_keywords_id'])){
                  $keywords_id = implode(',', $this->request->data['focus_group_keywords_id']);
                }
                $this->request->data['focus_group_keywords_id']=$keywords_id;

                $uploadImgError='';
                $uploadimgName='';
                $flag=0;

                if(!empty($this->request->data['image']['name'])){
                 
                    $data = [];
                    $data = $this->request->data['image']; 
                    $uploadImg = $this->FocusGroupUpload->uploadImage($data);

                    if(empty($uploadImg['errors'])){
                        $uploadimgName=$uploadImg['imgName'];
                    }else{
                        $flag=1;
                        $uploadImgError=$uploadImg['errors'];
                    }
                }

                $uploaddocError='';
                $uploaddocName='';
                if(!empty($this->request->data['document']['name'])){
                 
                    $data2 = [];
                    $data2 = $this->request->data['document']; 
                    $uploadDoc = $this->FocusGroupUpload->uploadDoc($data2);

                    if(empty($uploadDoc['errors'])){
                        $uploaddocName=$uploadDoc['imgName'];
                    }else{
                        $flag=1;
                        $uploaddocError=$uploadDoc['errors'];
                    }
                }

                $uploadAudioError='';
                $uploadAudioName='';
                if(!empty($this->request->data['audio']['name'])){
                 
                    $data3 = [];
                    $data3 = $this->request->data['audio']; 
                    $uploadAusio = $this->FocusGroupUpload->uploadAudio($data3);

                    if(empty($uploadAusio['errors'])){
                        $uploadAudioName=$uploadAusio['imgName'];
                    }else{
                        $flag=1;
                        $uploadAudioError=$uploadAusio['errors'];
                    }
                }


                $uploadVideoError='';
                $uploadVideoName='';
                if(!empty($this->request->data['video']['name'])){
                 
                    $data3 = [];
                    $data3 = $this->request->data['video']; 
                    $uploadVideo = $this->FocusGroupUpload->uploadVideo($data3);

                    if(empty($uploadVideo['errors'])){
                        $uploadVideoName=$uploadVideo['imgName'];
                    }else{
                        $flag=1;
                        $uploadVideoError=$uploadVideo['errors'];
                    }
                }

                
                if(!empty($flag)){

                    if(!empty($uploadImgError)){
                        $this->Flash->error($uploadImgError);
                    }

                    if(!empty($uploaddocError)){
                        $this->Flash->error($uploaddocError);
                    }
                    if(!empty($uploadAudioError)){
                        $this->Flash->error($uploadAudioError);
                    }

                    if(!empty($uploadVideoError)){
                        $this->Flash->error($uploadVideoError);
                    }
                }else{

                    $DateBegin = date('Y-m-d', strtotime($this->request->data['start_date']));
                    $DateEnd = date('Y-m-d', strtotime($this->request->data['end_date']));
                    
                    if($DateBegin <= $DateEnd)
                    {
                        $this->request->data['image']=$uploadimgName;
                        $this->request->data['document']=$uploaddocName;
                        $this->request->data['audio']=$uploadAudioName;
                        $this->request->data['video']=$uploadVideoName;
                        $this->request->data['user_id']=$userId;

                        $addfunds = $this->FocusGroups->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->FocusGroups->save($addfunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveFocusGroupFeeds($userId,'feeds_focusgroup_added',$resultSave->id);

                             $this->Flash->success('Focus Group saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myFocusGroup']);

                        }else{

                             $this->Flash->error('Could not save Focus Group. Please, try again.');
                        } 
                    }else{
                        $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                    }     
                }     

            }

            $this->set('fund',$addfunds);
    }


    /*
     *  edit method
     *
     *
     *
     *
     ***/
    public function edit($id=null)
    {
        $userTimeZone = $this->WebNotification->getUserTimeZoneByIp();
        date_default_timezone_set($userTimeZone);
        
            $this->loadModel('FocusGroups');
            $this->loadModel('FocusGroupKeywords');
            $this->loadModel('FocusGroupInterestKeywords');
            $this->loadModel('FocusGroupTargetMarkets');
            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->FocusGroupInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->FocusGroupTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->FocusGroupKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->FocusGroups->newEntity(); 
            $this->FocusGroups->validator()->remove('start_date');

            $exists= $this->FocusGroups->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->FocusGroups->get($fundId);
                $this->set('fundDetails',$fundDetails);

                    if($this->request->is('post'))
                    {
                       
                        $target_market =$fundDetails->target_market;
                        if(!empty($this->request->data['target_market'])){
                          $target_market = implode(',', $this->request->data['target_market']);
                        }
                        $this->request->data['target_market']=$target_market;

                        $interest_keywords_id =$fundDetails->focus_group_interest_keywords_id;
                        if(!empty($this->request->data['focus_group_interest_keywords_id'])){
                          $interest_keywords_id = implode(',', $this->request->data['focus_group_interest_keywords_id']);
                        }
                        $this->request->data['focus_group_interest_keywords_id']=$interest_keywords_id;

                        $keywords_id =$fundDetails->focus_group_keywords_id;
                        if(!empty($this->request->data['focus_group_keywords_id'])){
                          $keywords_id = implode(',', $this->request->data['focus_group_keywords_id']);
                        }
                        $this->request->data['focus_group_keywords_id']=$keywords_id;


                        $uploadImgError='';
                        $uploadimgName=$fundDetails->image;
                        $flag=0;

                        if(!empty($this->request->data['image']['name'])){
                         
                            $data = [];
                            $data = $this->request->data['image']; 
                            $uploadImg = $this->FocusGroupUpload->uploadImage($data);

                            if(empty($uploadImg['errors'])){
                                $uploadimgName=$uploadImg['imgName'];
                            }else{
                                $flag=1;
                                $uploadImgError=$uploadImg['errors'];
                            }
                        }

                        $uploaddocError='';
                        $uploaddocName=$fundDetails->document;
                        if(!empty($this->request->data['document']['name'])){
                         
                            $data2 = [];
                            $data2 = $this->request->data['document']; 
                            $uploadDoc = $this->FocusGroupUpload->uploadDoc($data2);

                            if(empty($uploadDoc['errors'])){
                                $uploaddocName=$uploadDoc['imgName'];
                            }else{
                                $flag=1;
                                $uploaddocError=$uploadDoc['errors'];
                            }
                        }

                        $uploadAudioError='';
                        $uploadAudioName=$fundDetails->audio;
                        if(!empty($this->request->data['audio']['name'])){
                         
                            $data3 = [];
                            $data3 = $this->request->data['audio']; 
                            $uploadAusio = $this->FocusGroupUpload->uploadAudio($data3);

                            if(empty($uploadAusio['errors'])){
                                $uploadAudioName=$uploadAusio['imgName'];
                            }else{
                                $flag=1;
                                $uploadAudioError=$uploadAusio['errors'];
                            }
                        }


                        $uploadVideoError='';
                        $uploadVideoName=$fundDetails->video;
                        if(!empty($this->request->data['video']['name'])){
                         
                            $data3 = [];
                            $data3 = $this->request->data['video']; 
                            $uploadVideo = $this->FocusGroupUpload->uploadVideo($data3);

                            if(empty($uploadVideo['errors'])){
                                $uploadVideoName=$uploadVideo['imgName'];
                            }else{
                                $flag=1;
                                $uploadVideoError=$uploadVideo['errors'];
                            }
                        }

                        
                        if(!empty($flag)){

                            if(!empty($uploadImgError)){
                                $this->Flash->error($uploadImgError);
                            }

                            if(!empty($uploaddocError)){
                                $this->Flash->error($uploaddocError);
                            }

                            if(!empty($uploadAudioError)){
                                $this->Flash->error($uploadAudioError);
                            }

                            if(!empty($uploadVideoError)){
                                $this->Flash->error($uploadVideoError);
                            }
                        }

                        $DateBegin = date('Y-m-d', strtotime($this->request->data['start_date']));
                        $DateEnd = date('Y-m-d', strtotime($this->request->data['end_date']));
                        
                        if($DateBegin <= $DateEnd)
                        {
                            $this->request->data['image']=$uploadimgName;
                            $this->request->data['document']=$uploaddocName;
                            $this->request->data['audio']=$uploadAudioName;
                            $this->request->data['video']=$uploadVideoName;
                            $this->request->data['user_id']=$userId;

                            $addfunds = $this->FocusGroups->patchEntity($addfunds, $this->request->data);
                            $addfunds->id=$fundId;
                                $resultSave = $this->FocusGroups->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Focus Group updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myFocusGroup']);

                                }else{
                                     $this->Flash->error('Could not update Focus Group. Please, try again.');
                                } 
                        }else{
                            $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                        }          

                    }
            }else{
                $this->Flash->error('You dont have access to edit this Focus Group.');
                return $this->redirect(['action'=>'myFocusGroup']);
            }        

            $this->set('fund',$addfunds);
    }

    /* 
     *  likeList method 
     *
     *
     *
     *
     ***/
    public function likeList($id=null)
    {
            $this->paginate = [ 'limit' => 10];
            
            $this->loadModel('FocusGroups');
            $this->loadModel('FocusGroupLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->FocusGroupLikes->find('all',['conditions'=>['focus_group_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $likelists->count();

            if(!empty($TotalItems))
            {     
                $this->set('users', $this->paginate($likelists));

            }else{
                return $this->redirect(['action'=>'index']);
            }
    }

    /*  
     *  dislikeList method 
     *
     *
     *
     *
     ***/
    public function dislikeList($id=null)
    {
            
            $this->paginate = [ 'limit' => 10];
            
            $this->loadModel('FocusGroups');
            $this->loadModel('FocusGroupDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->FocusGroupDislikes->find('all',['conditions'=>['focus_group_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $likelists->count();

            if(!empty($TotalItems))
            {     
                $this->set('users', $this->paginate($likelists));

            }else{
                return $this->redirect(['action'=>'index']);
            }

    }



    public function searchRecommendedContacts()
    {       

        $this->paginate = [ 'limit' => 10];

        $this->loadModel('BetaSignups');

        $user_id = $this->request->Session()->read('Auth.User.id');
        $this->set('userId', $user_id);

        $type= 'focus_group';
        $page_no= 1;


        $searchKeyword=$this->request->query('search');    
        $searchKeyword=trim($searchKeyword);
        //$searchKeyword=trim($this->request->query('search'));
        $aa= explode(' ', $searchKeyword);
        if(!empty($aa)){
            $searchKeyword=$aa[0];
        }
        $searchKeyword = str_replace("'","",$searchKeyword);   


        if(!empty($searchKeyword)){

            $ss = explode(' ', $searchKeyword);
            if(!empty($ss)){
              $searchKeyword =$ss[0];
            }
                    
            $connection = ConnectionManager::get('default');
            $qq = "SELECT CP.user_id FROM keywords as KY INNER JOIN contractor_professionals as CP
            ON FIND_IN_SET(KY.id, CP.keywords) where KY.name like '%".$searchKeyword."%' GROUP BY CP.user_id
            UNION SELECT CB.id FROM users as CB where CB.first_name like '%".$searchKeyword."%'
            OR CB.last_name like '%".$searchKeyword."%' GROUP BY CB.id";
            $sql = $connection->execute ($qq);
            $user_ids = $sql->fetchAll('assoc');

            if(!empty($user_ids)){

                foreach($user_ids as $SingleUser):
                    if(isset($SingleUser['user_id'])&&($SingleUser['user_id']!='')){
                        $contractorIds[] = $SingleUser['user_id'];
                    }
                endforeach; 
                
                $conditions = ['BetaSignups.user_id IN'=>$contractorIds,
                'BetaSignups.user_id !='=>$user_id,'BetaSignups.type' => $type];

                $betalists= $this->BetaSignups->find('all',['conditions'=>$conditions])->contain(['Users'=>['ContractorBasics']]);

                $TotalItems= $betalists->count();

                $this->set('users', $this->paginate($betalists));

            }else{
                $this->set('users', '');
            }                                                        

        }else{

            $betalists= $this->BetaSignups->find('all',['conditions'=>['BetaSignups.user_id !=' => $user_id,'BetaSignups.type' => $type]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $betalists->count();

            $this->set('users', $this->paginate($betalists));
        }

    }








}
