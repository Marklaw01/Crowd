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
class EndorsersController extends AppController
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
        $this->loadComponent('EndorsorUpload');
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['Endorsors.id' => 'desc']];
            $this->loadModel('Endorsors');
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM endorsor_keywords as KY INNER JOIN endorsors as SU ON FIND_IN_SET(KY.id, SU.endorsor_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Endorsors->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Endorsors.user_id !='=>$UserId, 'Endorsors.status'=>1,

                                                                    'OR' =>[
                                                                                ['Endorsors.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Endorsors.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Endorsors->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Endorsors.user_id !='=>$UserId, 'Endorsors.status'=>1,

                                                                    'OR' =>[
                                                                                ['Endorsors.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists = $this->Endorsors->find('all',['conditions'=>['Endorsors.user_id !='=>$UserId,'Endorsors.status'=>1]])->contain(['Users']);
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
    public function myEndorser()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['Endorsors.id' => 'desc']];
           $this->loadModel('Endorsors');
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM endorsor_keywords as KY INNER JOIN endorsors as SU ON FIND_IN_SET(KY.id, SU.endorsor_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Endorsors->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Endorsors.user_id '=>$UserId, 'Endorsors.status'=>1,

                                                                    'OR' =>[
                                                                                ['Endorsors.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Endorsors.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Endorsors->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Endorsors.user_id '=>$UserId, 'Endorsors.status'=>1,

                                                                    'OR' =>[
                                                                                ['Endorsors.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Endorsors->find('all',['conditions'=>['Endorsors.user_id'=>$UserId,'Endorsors.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10,'order' => ['Endorsors.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);
           $this->loadModel('Endorsors');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM endorsor_keywords as KY INNER JOIN endorsors as SU ON FIND_IN_SET(KY.id, SU.endorsor_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Endorsors->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Endorsors.user_id '=>$UserId, 'Endorsors.status'=>2,

                                                                    'OR' =>[
                                                                                ['Endorsors.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Endorsors.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Endorsors->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Endorsors.user_id '=>$UserId, 'Endorsors.status'=>2,

                                                                    'OR' =>[
                                                                                ['Endorsors.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Endorsors->find('all',['conditions'=>['Endorsors.user_id'=>$UserId,'Endorsors.status'=>2]])->contain(['Users']);
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
           $this->paginate = [ 'limit' => 10,'order' => ['Endorsors.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);
           $this->loadModel('Endorsors');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM endorsor_keywords as KY INNER JOIN endorsors as SU ON FIND_IN_SET(KY.id, SU.endorsor_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Endorsors->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Endorsors.user_id '=>$UserId, 'Endorsors.status'=>0,

                                                                    'OR' =>[
                                                                                ['Endorsors.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Endorsors.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Endorsors->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Endorsors.user_id '=>$UserId, 'Endorsors.status'=>0,

                                                                    'OR' =>[
                                                                                ['Endorsors.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Endorsors->find('all',['conditions'=>['Endorsors.user_id'=>$UserId,'Endorsors.status'=>0]])->contain(['Users']);
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
            $this->loadModel('Endorsors');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Endorsors->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Endorser has been activated successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('The Endorser could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myEndorser']);
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
            $this->loadModel('Endorsors');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Endorsors->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Endorser has been archived successfully.');
                    $this->redirect(['action' => 'myEndorser']);

                }else{

                    $this->Flash->error('The Endorser could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myEndorser']);
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
            $this->loadModel('Endorsors');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Endorsors->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Endorser has been deactivated successfully.');
                    $this->redirect(['action' => 'myEndorser']);

                }else{

                    $this->Flash->error('The Endorser could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myEndorser']);
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
            $this->loadModel('Endorsors');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Endorsors->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Endorser has been deleted successfully.');
                    $this->redirect(['action' => 'myEndorser']);

                }else{

                    $this->Flash->error('The Endorser could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myEndorser']);
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
            $this->loadModel('Endorsors');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Endorsors->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('EndorsorDislikes');
                    $likeExists= $this->EndorsorDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'endorsor_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->EndorsorDislikes->get($likeExists->id);
                        $this->EndorsorDislikes->delete($entity);
                    }

                    $this->loadModel('EndorsorLikes');
                    $likefunds = $this->EndorsorLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['endorsor_id']=$fundId;
                    $likefunds = $this->EndorsorLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->EndorsorLikes->find('all',['conditions'=>['like_by'=>$likeBy,'endorsor_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->EndorsorLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Endorser liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Endorser. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Endorser. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unlike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Endorsors');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Endorsors->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('EndorsorLikes');
                    $likeExists= $this->EndorsorLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'endorsor_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->EndorsorLikes->get($likeExists->id);
                        $this->EndorsorLikes->delete($entity);
                    

                        $this->Flash->success('Endorser unliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->success('Could not unlike Endorser. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find Eandorser.');
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
            $this->loadModel('Endorsors');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Endorsors->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('EndorsorFollowers');
                    $FundFollowers = $this->EndorsorFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['endorsor_id']=$fundId;
                    $likefunds = $this->EndorsorFollowers->patchEntity($FundFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->EndorsorFollowers->find('all',['conditions'=>['user_id'=>$followBy,'endorsor_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->EndorsorFollowers->save($likefunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveEndorsorFeeds($followBy,'feeds_endorser_following',$fundId);

                            $this->Flash->success('Endorser followed successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Endorser. Please try again.');
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
            $this->loadModel('Endorsors');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->Endorsors->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('EndorsorFollowers');
                $likeExists= $this->EndorsorFollowers->find('all',['conditions'=>['user_id'=>$followBy,'endorsor_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->EndorsorFollowers->get($likeExists->id);
                    $this->EndorsorFollowers->delete($entity);
                }

                $this->Flash->success('Endorser unfollowed successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Endorser.');
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
            $this->loadModel('Endorsors');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Endorsors->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('EndorsorLikes');
                    $likeExists= $this->EndorsorLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'endorsor_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->EndorsorLikes->get($likeExists->id);
                        $this->EndorsorLikes->delete($entity);
                    }

                    $this->loadModel('EndorsorDislikes');
                    $dislikefunds = $this->EndorsorDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['endorsor_id']=$fundId;
                    $dislikefunds = $this->EndorsorDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->EndorsorDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'endorsor_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->EndorsorDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Endorser disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Endorser. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Eandorser.');
                    return $this->redirect($this->referer());
                }        
    }

    public function undisLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Endorsors');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Endorsors->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('EndorsorDislikes');
                    $likeExists= $this->EndorsorDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'endorsor_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->EndorsorDislikes->get($likeExists->id);
                        $this->EndorsorDislikes->delete($entity);
                    

                        $this->Flash->success('Endorser undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Endorser. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Endorser. Please try again.');
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
            $this->loadModel('Endorsors');
            $this->loadModel('EndorsorCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Endorsors->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['endorsor_id']=$fundId;

                    $likefunds = $this->EndorsorCommitments->newEntity(); 
                    $likefunds = $this->EndorsorCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->EndorsorCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'endorsor_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->EndorsorCommitments->save($likefunds);

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
            $this->loadModel('Endorsors');
            $this->loadModel('EndorsorCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Endorsors->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->EndorsorCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'endorsor_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->EndorsorCommitments->get($likeExists->id);
                        $this->EndorsorCommitments->delete($entity);
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
            $this->loadModel('Endorsors');
            $this->loadModel('EndorsorKeywords');
            $this->loadModel('EndorsorInterestKeywords');
            $this->loadModel('EndorsorTargetMarkets');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->EndorsorInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->EndorsorTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->EndorsorKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->Endorsors->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->Endorsors->find('all',['conditions'=>['Endorsors.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->EndorsorUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->EndorsorUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);
            }else{

                $this->Flash->success('Could not find Endorser. Please, try again.');
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

            $this->loadModel('Endorsors');
            $this->loadModel('EndorsorKeywords');
            $this->loadModel('EndorsorInterestKeywords');
            $this->loadModel('EndorsorTargetMarkets');


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->EndorsorInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->EndorsorTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->EndorsorKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->Endorsors->newEntity(); 



            if($this->request->is('post'))
            {

                $target_market ='';
                if(!empty($this->request->data['target_market'])){
                  $target_market = implode(',', $this->request->data['target_market']);
                }
                $this->request->data['target_market']=$target_market;

                $interest_keywords_id ='';
                if(!empty($this->request->data['endorsor_interest_keywords_id'])){
                  $interest_keywords_id = implode(',', $this->request->data['endorsor_interest_keywords_id']);
                }
                $this->request->data['endorsor_interest_keywords_id']=$interest_keywords_id;

                $keywords_id ='';
                if(!empty($this->request->data['endorsor_keywords_id'])){
                  $keywords_id = implode(',', $this->request->data['endorsor_keywords_id']);
                }
                $this->request->data['endorsor_keywords_id']=$keywords_id;

                $uploadImgError='';
                $uploadimgName='';
                $flag=0;

                if(!empty($this->request->data['image']['name'])){
                 
                    $data = [];
                    $data = $this->request->data['image']; 
                    $uploadImg = $this->EndorsorUpload->uploadImage($data);

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
                    $uploadDoc = $this->EndorsorUpload->uploadDoc($data2);

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
                    $uploadAusio = $this->EndorsorUpload->uploadAudio($data3);

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
                    $uploadVideo = $this->EndorsorUpload->uploadVideo($data3);

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

                        $addfunds = $this->Endorsors->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->Endorsors->save($addfunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveEndorsorFeeds($userId,'feeds_endorser_added',$resultSave->id);

                             $this->Flash->success('Endorser saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myEndorser']);

                        }else{

                             $this->Flash->error('Could not save Endorser. Please, try again.');
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
        
            $this->loadModel('Endorsors');
            $this->loadModel('EndorsorKeywords');
            $this->loadModel('EndorsorInterestKeywords');
            $this->loadModel('EndorsorTargetMarkets');
            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->EndorsorInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->EndorsorTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->EndorsorKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->Endorsors->newEntity(); 
            $this->Endorsors->validator()->remove('start_date');

            $exists= $this->Endorsors->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->Endorsors->get($fundId);
                $this->set('fundDetails',$fundDetails);

                    if($this->request->is('post'))
                    {
                       
                        $target_market =$fundDetails->target_market;
                        if(!empty($this->request->data['target_market'])){
                          $target_market = implode(',', $this->request->data['target_market']);
                        }
                        $this->request->data['target_market']=$target_market;

                        $interest_keywords_id =$fundDetails->endorsor_interest_keywords_id;
                        if(!empty($this->request->data['endorsor_interest_keywords_id'])){
                          $interest_keywords_id = implode(',', $this->request->data['endorsor_interest_keywords_id']);
                        }
                        $this->request->data['endorsor_interest_keywords_id']=$interest_keywords_id;

                        $keywords_id =$fundDetails->endorsor_keywords_id;
                        if(!empty($this->request->data['endorsor_keywords_id'])){
                          $keywords_id = implode(',', $this->request->data['endorsor_keywords_id']);
                        }
                        $this->request->data['endorsor_keywords_id']=$keywords_id;


                        $uploadImgError='';
                        $uploadimgName=$fundDetails->image;
                        $flag=0;

                        if(!empty($this->request->data['image']['name'])){
                         
                            $data = [];
                            $data = $this->request->data['image']; 
                            $uploadImg = $this->EndorsorUpload->uploadImage($data);

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
                            $uploadDoc = $this->EndorsorUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->EndorsorUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->EndorsorUpload->uploadVideo($data3);

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

                            $addfunds = $this->Endorsors->patchEntity($addfunds, $this->request->data);
                            $addfunds->id=$fundId;
                                $resultSave = $this->Endorsors->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Endorser updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myEndorser']);

                                }else{
                                     $this->Flash->error('Could not update Endorser. Please, try again.');
                                } 
                        }else{
                            $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                        }          

                    }
            }else{
                $this->Flash->error('You dont have access to edit this Endorser.');
                return $this->redirect(['action'=>'myEndorser']);
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
            
            $this->loadModel('Endorsors');
            $this->loadModel('EndorsorLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->EndorsorLikes->find('all',['conditions'=>['endorsor_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('Endorsors');
            $this->loadModel('EndorsorDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->EndorsorDislikes->find('all',['conditions'=>['endorsor_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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

        $type= 'endorsor';
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
