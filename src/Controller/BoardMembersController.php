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
class BoardMembersController extends AppController
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
        $this->loadComponent('BoardUpload');
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['BoardMembers.id' => 'desc']];
            $this->loadModel('BoardMembers');
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM board_oppertunity_keywords as KY INNER JOIN board_members as SU ON FIND_IN_SET(KY.id, SU.board_oppertunity_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->BoardMembers->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BoardMembers.user_id !='=>$UserId, 'BoardMembers.status'=>1,

                                                                    'OR' =>[
                                                                                ['BoardMembers.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['BoardMembers.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->BoardMembers->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BoardMembers.user_id !='=>$UserId, 'BoardMembers.status'=>1,

                                                                    'OR' =>[
                                                                                ['BoardMembers.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists = $this->BoardMembers->find('all',['conditions'=>['BoardMembers.user_id !='=>$UserId,'BoardMembers.status'=>1]])->contain(['Users']);
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
    public function myBoardMember()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['BoardMembers.id' => 'desc']];
           $this->loadModel('BoardMembers');
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM board_oppertunity_keywords as KY INNER JOIN board_members as SU ON FIND_IN_SET(KY.id, SU.board_oppertunity_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->BoardMembers->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BoardMembers.user_id '=>$UserId, 'BoardMembers.status'=>1,

                                                                    'OR' =>[
                                                                                ['BoardMembers.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['BoardMembers.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->BoardMembers->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BoardMembers.user_id '=>$UserId, 'BoardMembers.status'=>1,

                                                                    'OR' =>[
                                                                                ['BoardMembers.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->BoardMembers->find('all',['conditions'=>['BoardMembers.user_id'=>$UserId,'BoardMembers.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10,'order' => ['BoardMembers.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);
           $this->loadModel('BoardMembers');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM board_oppertunity_keywords as KY INNER JOIN board_members as SU ON FIND_IN_SET(KY.id, SU.board_oppertunity_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->BoardMembers->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BoardMembers.user_id '=>$UserId, 'BoardMembers.status'=>2,

                                                                    'OR' =>[
                                                                                ['BoardMembers.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['BoardMembers.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->BoardMembers->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BoardMembers.user_id '=>$UserId, 'BoardMembers.status'=>2,

                                                                    'OR' =>[
                                                                                ['BoardMembers.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->BoardMembers->find('all',['conditions'=>['BoardMembers.user_id'=>$UserId,'BoardMembers.status'=>2]])->contain(['Users']);
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
           $this->paginate = [ 'limit' => 10,'order' => ['BoardMembers.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);
           $this->loadModel('BoardMembers');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM board_oppertunity_keywords as KY INNER JOIN board_members as SU ON FIND_IN_SET(KY.id, SU.board_oppertunity_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->BoardMembers->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BoardMembers.user_id '=>$UserId, 'BoardMembers.status'=>0,

                                                                    'OR' =>[
                                                                                ['BoardMembers.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['BoardMembers.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->BoardMembers->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BoardMembers.user_id '=>$UserId, 'BoardMembers.status'=>0,

                                                                    'OR' =>[
                                                                                ['BoardMembers.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->BoardMembers->find('all',['conditions'=>['BoardMembers.user_id'=>$UserId,'BoardMembers.status'=>0]])->contain(['Users']);
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
            $this->loadModel('BoardMembers');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->BoardMembers->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Board Member has been activated successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('The Board Member could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myBoardMember']);
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
            $this->loadModel('BoardMembers');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->BoardMembers->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Board Member has been archived successfully.');
                    $this->redirect(['action' => 'myBoardMember']);

                }else{

                    $this->Flash->error('The Early Adopter could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myBoardMember']);
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
            $this->loadModel('BoardMembers');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->BoardMembers->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Board Member has been deactivated successfully.');
                    $this->redirect(['action' => 'myBoardMember']);

                }else{

                    $this->Flash->error('The Board Member could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myBoardMember']);
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
            $this->loadModel('BoardMembers');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->BoardMembers->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Board Member has been deleted successfully.');
                    $this->redirect(['action' => 'myBoardMember']);

                }else{

                    $this->Flash->error('The Board Member could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myBoardMember']);
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
            $this->loadModel('BoardMembers');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->BoardMembers->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('BoardMemberDislikes');
                    $likeExists= $this->BoardMemberDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'board_member_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->BoardMemberDislikes->get($likeExists->id);
                        $this->BoardMemberDislikes->delete($entity);
                    }

                    $this->loadModel('BoardMemberLikes');
                    $likefunds = $this->BoardMemberLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['board_member_id']=$fundId;
                    $likefunds = $this->BoardMemberLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->BoardMemberLikes->find('all',['conditions'=>['like_by'=>$likeBy,'board_member_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->BoardMemberLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Board Member liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Board Member. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Board Member. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unlike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('BoardMembers');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->BoardMembers->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('BoardMemberLikes');
                    $likeExists= $this->BoardMemberLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'board_member_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->BoardMemberLikes->get($likeExists->id);
                        $this->BoardMemberLikes->delete($entity);
                    

                        $this->Flash->success('Board Member unliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->success('Could not unlike Board Member. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find Board Member.');
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
            $this->loadModel('BoardMembers');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->BoardMembers->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('BoardMemberFollowers');
                    $FundFollowers = $this->BoardMemberFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['board_member_id']=$fundId;
                    $likefunds = $this->BoardMemberFollowers->patchEntity($FundFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->BoardMemberFollowers->find('all',['conditions'=>['user_id'=>$followBy,'board_member_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->BoardMemberFollowers->save($likefunds);
                        if ($resultSave){
                            //Save Feeds
                            $this->Feeds->saveBoardMemberFeeds($followBy,'feeds_boardmember_following',$fundId);
                            
                            $this->Flash->success('Board Member followed successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Board Member. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Board Member.');
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
            $this->loadModel('BoardMembers');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->BoardMembers->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('BoardMemberFollowers');
                $likeExists= $this->BoardMemberFollowers->find('all',['conditions'=>['user_id'=>$followBy,'board_member_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->BoardMemberFollowers->get($likeExists->id);
                    $this->BoardMemberFollowers->delete($entity);
                }

                $this->Flash->success('Board Member unfollowed successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Board Member.');
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
            $this->loadModel('BoardMembers');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->BoardMembers->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('BoardMemberLikes');
                    $likeExists= $this->BoardMemberLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'board_member_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->BoardMemberLikes->get($likeExists->id);
                        $this->BoardMemberLikes->delete($entity);
                    }

                    $this->loadModel('BoardMemberDislikes');
                    $dislikefunds = $this->BoardMemberDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['board_member_id']=$fundId;
                    $dislikefunds = $this->BoardMemberDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->BoardMemberDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'board_member_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->BoardMemberDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Board Member disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Board Member. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Board Member.');
                    return $this->redirect($this->referer());
                }        
    }

    public function undisLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('BoardMembers');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->BoardMembers->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('BoardMemberDislikes');
                    $likeExists= $this->BoardMemberDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'board_member_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->BoardMemberDislikes->get($likeExists->id);
                        $this->BoardMemberDislikes->delete($entity);
                    

                        $this->Flash->success('Board Member undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Board Member. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Board Member. Please try again.');
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
            $this->loadModel('BoardMembers');
            $this->loadModel('BoardCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->BoardMembers->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['board_member_id']=$fundId;

                    $likefunds = $this->BoardCommitments->newEntity(); 
                    $likefunds = $this->BoardCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->BoardCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'board_member_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->BoardCommitments->save($likefunds);

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
            $this->loadModel('BoardMembers');
            $this->loadModel('BoardCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->BoardMembers->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->BoardCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'board_member_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->BoardCommitments->get($likeExists->id);
                        $this->BoardCommitments->delete($entity);
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
            $this->loadModel('BoardMembers');
            $this->loadModel('BoardOppertunityKeywords');
            $this->loadModel('BoardInterestKeywords');
            $this->loadModel('BoardMemberTargetMarkets');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->BoardInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->BoardMemberTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->BoardOppertunityKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->BoardMembers->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->BoardMembers->find('all',['conditions'=>['BoardMembers.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->BoardUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);


                $is_commited_by_user = $this->BoardUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);

            }else{

                $this->Flash->success('Could not find Board Member. Please, try again.');
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

            $this->loadModel('BoardMembers');
            $this->loadModel('BoardOppertunityKeywords');
            $this->loadModel('BoardInterestKeywords');
            $this->loadModel('BoardMemberTargetMarkets');


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->BoardInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->BoardMemberTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->BoardOppertunityKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->BoardMembers->newEntity(); 



            if($this->request->is('post'))
            {

                $target_market ='';
                if(!empty($this->request->data['target_market'])){
                  $target_market = implode(',', $this->request->data['target_market']);
                }
                $this->request->data['target_market']=$target_market;

                $interest_keywords_id ='';
                if(!empty($this->request->data['board_interest_keywords_id'])){
                  $interest_keywords_id = implode(',', $this->request->data['board_interest_keywords_id']);
                }
                $this->request->data['board_interest_keywords_id']=$interest_keywords_id;

                $keywords_id ='';
                if(!empty($this->request->data['board_oppertunity_keywords_id'])){
                  $keywords_id = implode(',', $this->request->data['board_oppertunity_keywords_id']);
                }
                $this->request->data['board_oppertunity_keywords_id']=$keywords_id;

                $uploadImgError='';
                $uploadimgName='';
                $flag=0;

                if(!empty($this->request->data['image']['name'])){
                 
                    $data = [];
                    $data = $this->request->data['image']; 
                    $uploadImg = $this->BoardUpload->uploadImage($data);

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
                    $uploadDoc = $this->BoardUpload->uploadDoc($data2);

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
                    $uploadAusio = $this->BoardUpload->uploadAudio($data3);

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
                    $uploadVideo = $this->BoardUpload->uploadVideo($data3);

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

                        $addfunds = $this->BoardMembers->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->BoardMembers->save($addfunds);
                        if ($resultSave){
                            //Save Feeds
                            $this->Feeds->saveBoardMemberFeeds($userId,'feeds_boardmember_added',$resultSave->id);

                             $this->Flash->success('Board Member saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myBoardMember']);

                        }else{

                             $this->Flash->error('Could not save Board Member. Please, try again.');
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
        
            $this->loadModel('BoardMembers');
            $this->loadModel('BoardOppertunityKeywords');
            $this->loadModel('BoardInterestKeywords');
            $this->loadModel('BoardMemberTargetMarkets');
            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->BoardInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->BoardMemberTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->BoardOppertunityKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->BoardMembers->newEntity(); 
            $this->BoardMembers->validator()->remove('start_date');

            $exists= $this->BoardMembers->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->BoardMembers->get($fundId);
                $this->set('fundDetails',$fundDetails);

                    if($this->request->is('post'))
                    {
                       
                        $target_market =$fundDetails->target_market;
                        if(!empty($this->request->data['target_market'])){
                          $target_market = implode(',', $this->request->data['target_market']);
                        }
                        $this->request->data['target_market']=$target_market;

                        $interest_keywords_id =$fundDetails->board_interest_keywords_id;
                        if(!empty($this->request->data['board_interest_keywords_id'])){
                          $interest_keywords_id = implode(',', $this->request->data['board_interest_keywords_id']);
                        }
                        $this->request->data['board_interest_keywords_id']=$interest_keywords_id;

                        $keywords_id =$fundDetails->board_oppertunity_keywords_id;
                        if(!empty($this->request->data['board_oppertunity_keywords_id'])){
                          $keywords_id = implode(',', $this->request->data['board_oppertunity_keywords_id']);
                        }
                        $this->request->data['board_oppertunity_keywords_id']=$keywords_id;


                        $uploadImgError='';
                        $uploadimgName=$fundDetails->image;
                        $flag=0;

                        if(!empty($this->request->data['image']['name'])){
                         
                            $data = [];
                            $data = $this->request->data['image']; 
                            $uploadImg = $this->BoardUpload->uploadImage($data);

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
                            $uploadDoc = $this->BoardUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->BoardUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->BoardUpload->uploadVideo($data3);

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

                            $addfunds = $this->BoardMembers->patchEntity($addfunds, $this->request->data);
                            $addfunds->id=$fundId;
                                $resultSave = $this->BoardMembers->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Board Member updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myBoardMember']);

                                }else{
                                     $this->Flash->error('Could not update Board Member. Please, try again.');
                                }   
                        }else{
                            $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                        }        

                    }
            }else{
                $this->Flash->error('You dont have access to edit this Board Member.');
                return $this->redirect(['action'=>'myBoardMember']);
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
            
            $this->loadModel('BoardMembers');
            $this->loadModel('BoardMemberLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->BoardMemberLikes->find('all',['conditions'=>['board_member_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('BoardMembers');
            $this->loadModel('BoardMemberDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->BoardMemberDislikes->find('all',['conditions'=>['board_member_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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

        $type= 'board_member';
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
