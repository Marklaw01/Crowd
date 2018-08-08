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
class GroupsController extends AppController
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
        $this->loadComponent('GroupUpload');
        $this->loadComponent('Feeds');

    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['Groups.id' => 'desc']];
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM group_keywords as KY INNER JOIN groups as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Groups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Groups.user_id !='=>$UserId, 'Groups.status'=>1,

                                                                    'OR' =>[
                                                                                ['Groups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Groups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Groups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Groups.user_id !='=>$UserId, 'Groups.status'=>1,

                                                                    'OR' =>[
                                                                                ['Groups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists = $this->Groups->find('all',['conditions'=>['Groups.user_id !='=>$UserId,'Groups.status'=>1]])->contain(['Users']);
            }

                
                $this->set('myFundsLists',$this->paginate($myFundsLists));
    }


     /**
     *
     *
     * My Campaigns method
     *
     * 
     ***/
    public function myGroup()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['Groups.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM group_keywords as KY INNER JOIN groups as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Groups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Groups.user_id '=>$UserId, 'Groups.status'=>1,

                                                                    'OR' =>[
                                                                                ['Groups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Groups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Groups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Groups.user_id '=>$UserId, 'Groups.status'=>1,

                                                                    'OR' =>[
                                                                                ['Groups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Groups->find('all',['conditions'=>['Groups.user_id'=>$UserId,'Groups.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10,'order' => ['Groups.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM group_keywords as KY INNER JOIN groups as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Groups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Groups.user_id '=>$UserId, 'Groups.status'=>2,

                                                                    'OR' =>[
                                                                                ['Groups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Groups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Groups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Groups.user_id '=>$UserId, 'Groups.status'=>2,

                                                                    'OR' =>[
                                                                                ['Groups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Groups->find('all',['conditions'=>['Groups.user_id'=>$UserId,'Groups.status'=>2]])->contain(['Users']);
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
            $this->paginate = [ 'limit' => 10,'order' => ['Groups.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM group_keywords as KY INNER JOIN groups as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Groups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Groups.user_id '=>$UserId, 'Groups.status'=>0,

                                                                    'OR' =>[
                                                                                ['Groups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Groups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Groups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Groups.user_id '=>$UserId, 'Groups.status'=>0,

                                                                    'OR' =>[
                                                                                ['Groups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Groups->find('all',['conditions'=>['Groups.user_id'=>$UserId,'Groups.status'=>0]])->contain(['Users']);
            }

           
           
           $this->set('myFundsLists', $this->paginate($myFundsLists));

     }


    /**
    * archiveFund Method
    *
    *
    ***/
    public function activate($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Groups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Groups->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Group has been activated successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('Group could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myGroup']);
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
            $this->loadModel('Groups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Groups->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Group has been archived successfully.');
                    $this->redirect(['action' => 'myGroup']);

                }else{

                    $this->Flash->error('Group could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myGroup']);
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
            $this->loadModel('Groups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Groups->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Group has been deactivated successfully.');
                    $this->redirect(['action' => 'myGroup']);

                }else{

                    $this->Flash->error('Group could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myGroup']);
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
            $this->loadModel('Groups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Groups->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Group has been deleted successfully.');
                    $this->redirect(['action' => 'myGroup']);

                }else{

                    $this->Flash->error('Group could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myGroup']);
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
            $this->loadModel('Groups');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Groups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('GroupDislikes');
                    $likeExists= $this->GroupDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->GroupDislikes->get($likeExists->id);
                        $this->GroupDislikes->delete($entity);
                    }

                    $this->loadModel('GroupLikes');
                    $likefunds = $this->GroupLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['group_id']=$fundId;
                    $likefunds = $this->GroupLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->GroupLikes->find('all',['conditions'=>['like_by'=>$likeBy,'group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->GroupLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Group liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Group. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Group. Please try again.');
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
            $this->loadModel('Groups');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Groups->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('GroupFollowers');
                    $GroupFollowers = $this->GroupFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['group_id']=$fundId;
                    $likefunds = $this->GroupFollowers->patchEntity($GroupFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->GroupFollowers->find('all',['conditions'=>['user_id'=>$followBy,'group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->GroupFollowers->save($likefunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveGroupFeeds($followBy,'feeds_group_following',$fundId);
                            
                            $this->Flash->success('Followed Group successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Group. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Group.');
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
            $this->loadModel('Groups');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->Groups->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('GroupFollowers');
                $likeExists= $this->GroupFollowers->find('all',['conditions'=>['user_id'=>$followBy,'group_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->GroupFollowers->get($likeExists->id);
                    $this->GroupFollowers->delete($entity);
                }

                $this->Flash->success('Unfollowed Group successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Group.');
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
            $this->loadModel('Groups');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Groups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('GroupLikes');
                    $likeExists= $this->GroupLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->GroupLikes->get($likeExists->id);
                        $this->GroupLikes->delete($entity);
                    }

                    $this->loadModel('GroupDislikes');
                    $dislikefunds = $this->GroupDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['group_id']=$fundId;
                    $dislikefunds = $this->GroupDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->GroupDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'group_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->GroupDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Group Disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Group. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Group.');
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
            $this->loadModel('Groups');
            $this->loadModel('GroupCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Groups->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['group_id']=$fundId;

                    $likefunds = $this->GroupCommitments->newEntity(); 
                    $likefunds = $this->GroupCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->GroupCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'group_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->GroupCommitments->save($likefunds);

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
            $this->loadModel('Groups');
            $this->loadModel('GroupCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Groups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->GroupCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'group_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->GroupCommitments->get($likeExists->id);
                        $this->GroupCommitments->delete($entity);
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
            $this->loadModel('Groups');
            $this->loadModel('GroupKeywords');
            $this->loadModel('GroupInterestKeywords');
            $this->loadModel('GroupTargetMarkets');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->GroupInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->GroupTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->GroupKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->Groups->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->Groups->find('all',['conditions'=>['Groups.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->GroupUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->GroupUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);
            }else{

                $this->Flash->success('Could not find Group. Please, try again.');
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

        $this->loadModel('Groups');
        $this->loadModel('GroupKeywords');
        $this->loadModel('GroupInterestKeywords');
        $this->loadModel('GroupTargetMarkets');


        $userId = $this->request->Session()->read('Auth.User.id');
        $this->set('userId', $userId);

        $intrestKeywordLists = $this->GroupInterestKeywords->find('list')->toArray();
        $this->set('intrestKeywordLists',$intrestKeywordLists);

        $targetMarketLists = $this->GroupTargetMarkets->find('list')->toArray();
        $this->set('targetMarketLists',$targetMarketLists);

        $keywordsLists = $this->GroupKeywords->find('list')->toArray();
        $this->set('keywordsLists',$keywordsLists);


        $addfunds = $this->Groups->newEntity(); 



        if($this->request->is('post'))
        {
           // pr($this->request->data());die;

            $target_market ='';
            if(!empty($this->request->data['target_market'])){
              $target_market = implode(',', $this->request->data['target_market']);
            }
            $this->request->data['target_market']=$target_market;

            $interest_keywords_id ='';
            if(!empty($this->request->data['interest_keywords_id'])){
              $interest_keywords_id = implode(',', $this->request->data['interest_keywords_id']);
            }
            $this->request->data['interest_keywords_id']=$interest_keywords_id;

            $keywords_id ='';
            if(!empty($this->request->data['keywords_id'])){
              $keywords_id = implode(',', $this->request->data['keywords_id']);
            }
            $this->request->data['keywords_id']=$keywords_id;

            $uploadImgError='';
            $uploadimgName='';
            $flag=0;

            if(!empty($this->request->data['image']['name'])){
             
                $data = [];
                $data = $this->request->data['image']; 
                $uploadImg = $this->GroupUpload->uploadImage($data);

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
                $uploadDoc = $this->GroupUpload->uploadDoc($data2);

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
                $uploadAusio = $this->GroupUpload->uploadAudio($data3);

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
                $uploadVideo = $this->GroupUpload->uploadVideo($data3);

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

                    $addfunds = $this->Groups->patchEntity($addfunds, $this->request->data);

                    $resultSave = $this->Groups->save($addfunds);
                    if ($resultSave){
                        //Save Feeds
                        $this->Feeds->saveGroupFeeds($userId,'feeds_group_added',$resultSave->id);

                         $this->Flash->success('Group saved successfully.');
                         //return $this->redirect($this->referer());
                         return $this->redirect(['action'=>'myGroup']);

                    }else{
                         $this->Flash->error('Could not save Group. Please, try again.');
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
        
            $this->loadModel('Groups');
            $this->loadModel('GroupKeywords');
            $this->loadModel('GroupInterestKeywords');
            $this->loadModel('GroupTargetMarkets');
            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->GroupInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->GroupTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->GroupKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->Groups->newEntity(); 
            $this->Groups->validator()->remove('start_date');

            $exists= $this->Groups->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->Groups->get($fundId);
                $this->set('fundDetails',$fundDetails);

                    if($this->request->is('post'))
                    {
                       // pr($this->request->data());die;

                        //$managers_id =$fundDetails->managers_id;
                        $target_market =$fundDetails->target_market;
                        if(!empty($this->request->data['target_market'])){
                          $target_market = implode(',', $this->request->data['target_market']);
                        }
                        $this->request->data['target_market']=$target_market;

                        $interest_keywords_id =$fundDetails->interest_keywords_id;
                        if(!empty($this->request->data['interest_keywords_id'])){
                          $interest_keywords_id = implode(',', $this->request->data['interest_keywords_id']);
                        }
                        $this->request->data['interest_keywords_id']=$interest_keywords_id;

                        $keywords_id =$fundDetails->keywords_id;
                        if(!empty($this->request->data['keywords_id'])){
                          $keywords_id = implode(',', $this->request->data['keywords_id']);
                        }
                        $this->request->data['keywords_id']=$keywords_id;


                        $uploadImgError='';
                        $uploadimgName=$fundDetails->image;
                        $flag=0;

                        if(!empty($this->request->data['image']['name'])){
                         
                            $data = [];
                            $data = $this->request->data['image']; 
                            $uploadImg = $this->GroupUpload->uploadImage($data);

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
                            $uploadDoc = $this->GroupUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->GroupUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->GroupUpload->uploadVideo($data3);

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

                                $addfunds = $this->Groups->patchEntity($addfunds, $this->request->data);
                                $addfunds->id=$fundId;
                                $resultSave = $this->Groups->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Group updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myGroup']);

                                }else{
                                     $this->Flash->error('Could not update Group. Please, try again.');
                                } 
                            }else{
                                $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                            }  
                        }
                    }
            }else{
                $this->Flash->error('You dont have access to edit this.');
                return $this->redirect(['action'=>'myGroup']);
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
            
            $this->loadModel('Groups');
            $this->loadModel('GroupLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->GroupLikes->find('all',['conditions'=>['group_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('Groups');
            $this->loadModel('GroupDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->GroupDislikes->find('all',['conditions'=>['group_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $likelists->count();

            if(!empty($TotalItems))
            {     
                $this->set('users', $this->paginate($likelists));

            }else{
                return $this->redirect(['action'=>'index']);
            }

    }












}
