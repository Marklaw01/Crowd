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
class ProductivitiesController extends AppController
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
        $this->loadComponent('ProductivityUpload');
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['Productivities.id' => 'desc']];
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM productivity_keywords as KY INNER JOIN productivities as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Productivities->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Productivities.user_id !='=>$UserId, 'Productivities.status'=>1,

                                                                    'OR' =>[
                                                                                ['Productivities.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Productivities.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Productivities->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Productivities.user_id !='=>$UserId, 'Productivities.status'=>1,

                                                                    'OR' =>[
                                                                                ['Productivities.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists = $this->Productivities->find('all',['conditions'=>['Productivities.user_id !='=>$UserId,'Productivities.status'=>1]])->contain(['Users']);
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
    public function myProductivity()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['Productivities.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM productivity_keywords as KY INNER JOIN productivities as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Productivities->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Productivities.user_id '=>$UserId, 'Productivities.status'=>1,

                                                                    'OR' =>[
                                                                                ['Productivities.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Productivities.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Productivities->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Productivities.user_id '=>$UserId, 'Productivities.status'=>1,

                                                                    'OR' =>[
                                                                                ['Productivities.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Productivities->find('all',['conditions'=>['Productivities.user_id'=>$UserId,'Productivities.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10,'order' => ['Productivities.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM productivity_keywords as KY INNER JOIN productivities as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Productivities->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Productivities.user_id '=>$UserId, 'Productivities.status'=>2,

                                                                    'OR' =>[
                                                                                ['Productivities.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Productivities.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Productivities->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Productivities.user_id '=>$UserId, 'Productivities.status'=>2,

                                                                    'OR' =>[
                                                                                ['Productivities.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Productivities->find('all',['conditions'=>['Productivities.user_id'=>$UserId,'Productivities.status'=>2]])->contain(['Users']);
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
            $this->paginate = [ 'limit' => 10,'order' => ['Productivities.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM productivity_keywords as KY INNER JOIN productivities as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Productivities->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Productivities.user_id '=>$UserId, 'Productivities.status'=>0,

                                                                    'OR' =>[
                                                                                ['Productivities.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Productivities.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Productivities->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Productivities.user_id '=>$UserId, 'Productivities.status'=>0,

                                                                    'OR' =>[
                                                                                ['Productivities.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Productivities->find('all',['conditions'=>['Productivities.user_id'=>$UserId,'Productivities.status'=>0]])->contain(['Users']);
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
            $this->loadModel('Productivities');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Productivities->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Productivity has been activated successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('Productivity could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myProductivity']);
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
            $this->loadModel('Productivities');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Productivities->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Productivity has been archived successfully.');
                    $this->redirect(['action' => 'myProductivity']);

                }else{

                    $this->Flash->error('Productivity could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myProductivity']);
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
            $this->loadModel('Productivities');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Productivities->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Productivity has been deactivated successfully.');
                    $this->redirect(['action' => 'myProductivity']);

                }else{

                    $this->Flash->error('Productivity could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myProductivity']);
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
            $this->loadModel('Productivities');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Productivities->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Productivity has been deleted successfully.');
                    $this->redirect(['action' => 'myProductivity']);

                }else{

                    $this->Flash->error('Productivity could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myProductivity']);
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
            $this->loadModel('Productivities');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Productivities->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('ProductivityDislikes');
                    $likeExists= $this->ProductivityDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'productivity_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ProductivityDislikes->get($likeExists->id);
                        $this->ProductivityDislikes->delete($entity);
                    }

                    $this->loadModel('ProductivityLikes');
                    $likefunds = $this->ProductivityLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['productivity_id']=$fundId;
                    $likefunds = $this->ProductivityLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->ProductivityLikes->find('all',['conditions'=>['like_by'=>$likeBy,'productivity_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->ProductivityLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Productivity liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Productivity. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Productivity. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unlike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Productivities');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Productivities->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('ProductivityLikes');
                    $likeExists= $this->ProductivityLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'productivity_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ProductivityLikes->get($likeExists->id);
                        $this->ProductivityLikes->delete($entity);
                    

                        $this->Flash->success('Productivity unliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->success('Could not unlike Productivity. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find Productivity.');
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
            $this->loadModel('Productivities');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Productivities->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('ProductivityFollowers');
                    $ProductivityFollowers = $this->ProductivityFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['productivity_id']=$fundId;
                    $likefunds = $this->ProductivityFollowers->patchEntity($ProductivityFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->ProductivityFollowers->find('all',['conditions'=>['user_id'=>$followBy,'productivity_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->ProductivityFollowers->save($likefunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveProductivityFeeds($followBy,'feeds_productivity_following',$fundId);
                            
                            $this->Flash->success('Followed Productivity successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Productivity. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Productivity.');
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
            $this->loadModel('Productivities');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->Productivities->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('ProductivityFollowers');
                $likeExists= $this->ProductivityFollowers->find('all',['conditions'=>['user_id'=>$followBy,'productivity_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->ProductivityFollowers->get($likeExists->id);
                    $this->ProductivityFollowers->delete($entity);
                }

                $this->Flash->success('Unfollowed Productivity successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Productivity.');
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
            $this->loadModel('Productivities');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Productivities->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('ProductivityLikes');
                    $likeExists= $this->ProductivityLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'productivity_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ProductivityLikes->get($likeExists->id);
                        $this->ProductivityLikes->delete($entity);
                    }

                    $this->loadModel('ProductivityDislikes');
                    $dislikefunds = $this->ProductivityDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['productivity_id']=$fundId;
                    $dislikefunds = $this->ProductivityDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->ProductivityDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'productivity_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->ProductivityDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Productivity Disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Productivity. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Productivity.');
                    return $this->redirect($this->referer());
                }        
    }

    public function undisLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Productivities');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Productivities->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('ProductivityDislikes');
                    $likeExists= $this->ProductivityDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'productivity_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ProductivityDislikes->get($likeExists->id);
                        $this->ProductivityDislikes->delete($entity);
                    

                        $this->Flash->success('Productivity undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Productivity. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Productivity. Please try again.');
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
            $this->loadModel('Productivities');
            $this->loadModel('ProductivityCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Productivities->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['productivity_id']=$fundId;

                    $likefunds = $this->ProductivityCommitments->newEntity(); 
                    $likefunds = $this->ProductivityCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->ProductivityCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'productivity_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->ProductivityCommitments->save($likefunds);

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
            $this->loadModel('Productivities');
            $this->loadModel('ProductivityCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Productivities->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->ProductivityCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'productivity_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ProductivityCommitments->get($likeExists->id);
                        $this->ProductivityCommitments->delete($entity);
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
            $this->loadModel('Productivities');
            $this->loadModel('ProductivityKeywords');
            $this->loadModel('ProductivityInterestKeywords');
            $this->loadModel('ProductivityTargetMarkets');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->ProductivityInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->ProductivityTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->ProductivityKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->Productivities->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->Productivities->find('all',['conditions'=>['Productivities.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->ProductivityUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->ProductivityUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);
            }else{

                $this->Flash->success('Could not find Productivity. Please, try again.');
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

            $this->loadModel('Productivities');
            $this->loadModel('ProductivityKeywords');
            $this->loadModel('ProductivityInterestKeywords');
            $this->loadModel('ProductivityTargetMarkets');


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->ProductivityInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->ProductivityTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->ProductivityKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);


            $addfunds = $this->Productivities->newEntity(); 



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
                    $uploadImg = $this->ProductivityUpload->uploadImage($data);

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
                    $uploadDoc = $this->ProductivityUpload->uploadDoc($data2);

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
                    $uploadAusio = $this->ProductivityUpload->uploadAudio($data3);

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
                    $uploadVideo = $this->ProductivityUpload->uploadVideo($data3);

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

                        $addfunds = $this->Productivities->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->Productivities->save($addfunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveProductivityFeeds($userId,'feeds_productivity_added',$resultSave->id);

                             $this->Flash->success('Productivity saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myProductivity']);

                        }else{
                             $this->Flash->error('Could not save Productivity. Please, try again.');
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
        
            $this->loadModel('Productivities');
            $this->loadModel('ProductivityKeywords');
            $this->loadModel('ProductivityInterestKeywords');
            $this->loadModel('ProductivityTargetMarkets');
            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->ProductivityInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->ProductivityTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->ProductivityKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->Productivities->newEntity(); 
            $this->Productivities->validator()->remove('start_date');

            $exists= $this->Productivities->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->Productivities->get($fundId);
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
                            $uploadImg = $this->ProductivityUpload->uploadImage($data);

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
                            $uploadDoc = $this->ProductivityUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->ProductivityUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->ProductivityUpload->uploadVideo($data3);

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

                                $addfunds = $this->Productivities->patchEntity($addfunds, $this->request->data);
                                $addfunds->id=$fundId;
                                $resultSave = $this->Productivities->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Productivity updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myProductivity']);

                                }else{
                                     $this->Flash->error('Could not update Productivity. Please, try again.');
                                } 
                            }else{
                                $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                            }      
                        }
                    }
            }else{
                $this->Flash->error('You dont have access to edit this.');
                return $this->redirect(['action'=>'myProductivity']);
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
            
            $this->loadModel('Productivities');
            $this->loadModel('ProductivityLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->ProductivityLikes->find('all',['conditions'=>['productivity_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('Productivities');
            $this->loadModel('ProductivityDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->ProductivityDislikes->find('all',['conditions'=>['productivity_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $likelists->count();

            if(!empty($TotalItems))
            {     
                $this->set('users', $this->paginate($likelists));

            }else{
                return $this->redirect(['action'=>'index']);
            }

    }












}
