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
class BetaTestersController extends AppController
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
        $this->loadComponent('BetaUpload');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['BetaTests.id' => 'desc']];
            $this->loadModel('BetaTests');
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM beta_test_keywords as KY INNER JOIN beta_tests as SU ON FIND_IN_SET(KY.id, SU.beta_test_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->BetaTests->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BetaTests.user_id !='=>$UserId, 'BetaTests.status'=>1,

                                                                    'OR' =>[
                                                                                ['BetaTests.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['BetaTests.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->BetaTests->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BetaTests.user_id !='=>$UserId, 'BetaTests.status'=>1,

                                                                    'OR' =>[
                                                                                ['BetaTests.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists = $this->BetaTests->find('all',['conditions'=>['BetaTests.user_id !='=>$UserId,'BetaTests.status'=>1]])->contain(['Users']);
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
    public function myBetaTest()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['BetaTests.id' => 'desc']];
           $this->loadModel('BetaTests');
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM beta_test_keywords as KY INNER JOIN beta_tests as SU ON FIND_IN_SET(KY.id, SU.beta_test_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->BetaTests->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BetaTests.user_id '=>$UserId, 'BetaTests.status'=>1,

                                                                    'OR' =>[
                                                                                ['BetaTests.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['BetaTests.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->BetaTests->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BetaTests.user_id '=>$UserId, 'BetaTests.status'=>1,

                                                                    'OR' =>[
                                                                                ['BetaTests.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->BetaTests->find('all',['conditions'=>['BetaTests.user_id'=>$UserId,'BetaTests.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10,'order' => ['BetaTests.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);
           $this->loadModel('BetaTests');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM beta_test_keywords as KY INNER JOIN beta_tests as SU ON FIND_IN_SET(KY.id, SU.beta_test_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->BetaTests->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BetaTests.user_id '=>$UserId, 'BetaTests.status'=>2,

                                                                    'OR' =>[
                                                                                ['BetaTests.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['BetaTests.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->BetaTests->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BetaTests.user_id '=>$UserId, 'BetaTests.status'=>2,

                                                                    'OR' =>[
                                                                                ['BetaTests.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->BetaTests->find('all',['conditions'=>['BetaTests.user_id'=>$UserId,'BetaTests.status'=>2]])->contain(['Users']);
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
           $this->paginate = [ 'limit' => 10,'order' => ['BetaTests.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);
           $this->loadModel('BetaTests');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM beta_test_keywords as KY INNER JOIN beta_tests as SU ON FIND_IN_SET(KY.id, SU.beta_test_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->BetaTests->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BetaTests.user_id '=>$UserId, 'BetaTests.status'=>0,

                                                                    'OR' =>[
                                                                                ['BetaTests.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['BetaTests.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->BetaTests->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'BetaTests.user_id '=>$UserId, 'BetaTests.status'=>0,

                                                                    'OR' =>[
                                                                                ['BetaTests.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->BetaTests->find('all',['conditions'=>['BetaTests.user_id'=>$UserId,'BetaTests.status'=>0]])->contain(['Users']);
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
            $this->loadModel('BetaTests');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->BetaTests->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Beta Test has been activated successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('The Beta Test could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myBetaTest']);
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
            $this->loadModel('BetaTests');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->BetaTests->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Beta Test has been archived successfully.');
                    $this->redirect(['action' => 'myBetaTest']);

                }else{

                    $this->Flash->error('The Beta Test could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myBetaTest']);
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
            $this->loadModel('BetaTests');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->BetaTests->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Beta Test has been deactivated successfully.');
                    $this->redirect(['action' => 'myBetaTest']);

                }else{

                    $this->Flash->error('The Beta Test could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myBetaTest']);
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
            $this->loadModel('BetaTests');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->BetaTests->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Beta Test has been deleted successfully.');
                    $this->redirect(['action' => 'myBetaTest']);

                }else{

                    $this->Flash->error('The Beta Test could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myBetaTest']);
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
            $this->loadModel('BetaTests');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->BetaTests->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('BetaTestDislikes');
                    $likeExists= $this->BetaTestDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'beta_test_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->BetaTestDislikes->get($likeExists->id);
                        $this->BetaTestDislikes->delete($entity);
                    }

                    $this->loadModel('BetaTestLikes');
                    $likefunds = $this->BetaTestLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['beta_test_id']=$fundId;
                    $likefunds = $this->BetaTestLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->BetaTestLikes->find('all',['conditions'=>['like_by'=>$likeBy,'beta_test_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->BetaTestLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Beta Test liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Beta Test. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Beta Test. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unlike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('BetaTests');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->BetaTests->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('BetaTestLikes');
                    $likeExists= $this->BetaTestLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'beta_test_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->BetaTestLikes->get($likeExists->id);
                        $this->BetaTestLikes->delete($entity);
                    

                        $this->Flash->success('Beta Test unliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->success('Could not unlike Beta Test. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find Beta Test.');
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
            $this->loadModel('BetaTests');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->BetaTests->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('BetaTestFollowers');
                    $FundFollowers = $this->BetaTestFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['beta_test_id']=$fundId;
                    $likefunds = $this->BetaTestFollowers->patchEntity($FundFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->BetaTestFollowers->find('all',['conditions'=>['user_id'=>$followBy,'beta_test_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->BetaTestFollowers->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Beta Test followed successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Beta Test. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Beta Test.');
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
            $this->loadModel('BetaTests');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->BetaTests->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('BetaTestFollowers');
                $likeExists= $this->BetaTestFollowers->find('all',['conditions'=>['user_id'=>$followBy,'beta_test_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->BetaTestFollowers->get($likeExists->id);
                    $this->BetaTestFollowers->delete($entity);
                }

                $this->Flash->success('Beta Test unfollowed successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Beta Test.');
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
            $this->loadModel('BetaTests');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->BetaTests->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('BetaTestLikes');
                    $likeExists= $this->BetaTestLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'beta_test_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->BetaTestLikes->get($likeExists->id);
                        $this->BetaTestLikes->delete($entity);
                    }

                    $this->loadModel('BetaTestDislikes');
                    $dislikefunds = $this->BetaTestDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['beta_test_id']=$fundId;
                    $dislikefunds = $this->BetaTestDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->BetaTestDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'beta_test_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->BetaTestDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Beta Test disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Beta Test. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Beta Test.');
                    return $this->redirect($this->referer());
                }        
    }

    public function undisLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('BetaTests');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->BetaTests->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('BetaTestDislikes');
                    $likeExists= $this->BetaTestDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'beta_test_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->BetaTestDislikes->get($likeExists->id);
                        $this->BetaTestDislikes->delete($entity);
                    

                        $this->Flash->success('Beta Test undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Beta Test. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Beta Test. Please try again.');
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
            $this->loadModel('BetaTests');
            $this->loadModel('BetaCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->BetaTests->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['beta_test_id']=$fundId;

                    $likefunds = $this->BetaCommitments->newEntity(); 
                    $likefunds = $this->BetaCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->BetaCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'beta_test_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->BetaCommitments->save($likefunds);

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
            $this->loadModel('BetaTests');
            $this->loadModel('BetaCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->BetaTests->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->BetaCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'beta_test_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->BetaCommitments->get($likeExists->id);
                        $this->BetaCommitments->delete($entity);
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
            $this->loadModel('BetaTests');
            $this->loadModel('BetaTestKeywords');
            $this->loadModel('BetaInterestKeywords');
            $this->loadModel('BetaTestTargetMarkets');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->BetaInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->BetaTestTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->BetaTestKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->BetaTests->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->BetaTests->find('all',['conditions'=>['BetaTests.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->BetaUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->BetaUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);
            }else{

                $this->Flash->success('Could not find Beta Test. Please, try again.');
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

            $this->loadModel('BetaTests');
            $this->loadModel('BetaTestKeywords');
            $this->loadModel('BetaInterestKeywords');
            $this->loadModel('BetaTestTargetMarkets');


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->BetaInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->BetaTestTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->BetaTestKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->BetaTests->newEntity(); 



            if($this->request->is('post'))
            {

                $target_market ='';
                if(!empty($this->request->data['target_market'])){
                  $target_market = implode(',', $this->request->data['target_market']);
                }
                $this->request->data['target_market']=$target_market;

                $interest_keywords_id ='';
                if(!empty($this->request->data['beta_interest_keywords_id'])){
                  $interest_keywords_id = implode(',', $this->request->data['beta_interest_keywords_id']);
                }
                $this->request->data['beta_interest_keywords_id']=$interest_keywords_id;

                $keywords_id ='';
                if(!empty($this->request->data['beta_test_keywords_id'])){
                  $keywords_id = implode(',', $this->request->data['beta_test_keywords_id']);
                }
                $this->request->data['beta_test_keywords_id']=$keywords_id;

                $uploadImgError='';
                $uploadimgName='';
                $flag=0;

                if(!empty($this->request->data['image']['name'])){
                 
                    $data = [];
                    $data = $this->request->data['image']; 
                    $uploadImg = $this->BetaUpload->uploadImage($data);

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
                    $uploadDoc = $this->BetaUpload->uploadDoc($data2);

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
                    $uploadAusio = $this->BetaUpload->uploadAudio($data3);

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
                    $uploadVideo = $this->BetaUpload->uploadVideo($data3);

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

                        $addfunds = $this->BetaTests->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->BetaTests->save($addfunds);
                        if ($resultSave){

                             $this->Flash->success('Beta Test saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myBetaTest']);

                        }else{

                             $this->Flash->error('Could not save Beta Test. Please, try again.');
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
        
            $this->loadModel('BetaTests');
            $this->loadModel('BetaTestKeywords');
            $this->loadModel('BetaInterestKeywords');
            $this->loadModel('BetaTestTargetMarkets');
            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->BetaInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->BetaTestTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->BetaTestKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->BetaTests->newEntity(); 
            $this->BetaTests->validator()->remove('start_date');

            $exists= $this->BetaTests->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->BetaTests->get($fundId);
                $this->set('fundDetails',$fundDetails);

                    if($this->request->is('post'))
                    {
                       
                        $target_market =$fundDetails->target_market;
                        if(!empty($this->request->data['target_market'])){
                          $target_market = implode(',', $this->request->data['target_market']);
                        }
                        $this->request->data['target_market']=$target_market;

                        $interest_keywords_id =$fundDetails->beta_interest_keywords_id;
                        if(!empty($this->request->data['beta_interest_keywords_id'])){
                          $interest_keywords_id = implode(',', $this->request->data['beta_interest_keywords_id']);
                        }
                        $this->request->data['beta_interest_keywords_id']=$interest_keywords_id;

                        $keywords_id =$fundDetails->beta_test_keywords_id;
                        if(!empty($this->request->data['beta_test_keywords_id'])){
                          $keywords_id = implode(',', $this->request->data['beta_test_keywords_id']);
                        }
                        $this->request->data['beta_test_keywords_id']=$keywords_id;


                        $uploadImgError='';
                        $uploadimgName=$fundDetails->image;
                        $flag=0;

                        if(!empty($this->request->data['image']['name'])){
                         
                            $data = [];
                            $data = $this->request->data['image']; 
                            $uploadImg = $this->BetaUpload->uploadImage($data);

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
                            $uploadDoc = $this->BetaUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->BetaUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->BetaUpload->uploadVideo($data3);

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

                            $addfunds = $this->BetaTests->patchEntity($addfunds, $this->request->data);
                            $addfunds->id=$fundId;
                                $resultSave = $this->BetaTests->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Beta Test updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myBetaTest']);

                                }else{
                                     $this->Flash->error('Could not update Beta Test. Please, try again.');
                                } 
                        }else{
                            $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                        }          

                    }
            }else{
                $this->Flash->error('You dont have access to edit this Beta Test.');
                return $this->redirect(['action'=>'myBetaTest']);
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
            
            $this->loadModel('BetaTests');
            $this->loadModel('BetaTestLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->BetaTestLikes->find('all',['conditions'=>['beta_test_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('BetaTests');
            $this->loadModel('BetaTestDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->BetaTestDislikes->find('all',['conditions'=>['beta_test_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $likelists->count();

            if(!empty($TotalItems))
            {     
                $this->set('users', $this->paginate($likelists));

            }else{
                return $this->redirect(['action'=>'index']);
            }

    }

    /*  
     *  Search Recommended Contacts
     *
     *
     *
     *
     ***/
    public function searchRecommendedContacts()
    {       

        $this->paginate = [ 'limit' => 10];

        $this->loadModel('BetaSignups');

        $user_id = $this->request->Session()->read('Auth.User.id');
        $this->set('userId', $user_id);

        $type= 'beta_tester';
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
