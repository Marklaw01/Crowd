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
class EarlyAdoptersController extends AppController
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
        $this->loadComponent('EarlyUpload');
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['EarlyAdopters.id' => 'desc']];
            $this->loadModel('EarlyAdopters');
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM early_adopter_keywords as KY INNER JOIN early_adopters as SU ON FIND_IN_SET(KY.id, SU.early_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->EarlyAdopters->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'EarlyAdopters.user_id !='=>$UserId, 'EarlyAdopters.status'=>1,

                                                                    'OR' =>[
                                                                                ['EarlyAdopters.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['EarlyAdopters.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->EarlyAdopters->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'EarlyAdopters.user_id !='=>$UserId, 'EarlyAdopters.status'=>1,

                                                                    'OR' =>[
                                                                                ['EarlyAdopters.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists = $this->EarlyAdopters->find('all',['conditions'=>['EarlyAdopters.user_id !='=>$UserId,'EarlyAdopters.status'=>1]])->contain(['Users']);
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
    public function myEarlyAdopter()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['EarlyAdopters.id' => 'desc']];
           $this->loadModel('EarlyAdopters');
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM early_adopter_keywords as KY INNER JOIN early_adopters as SU ON FIND_IN_SET(KY.id, SU.early_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->EarlyAdopters->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'EarlyAdopters.user_id '=>$UserId, 'EarlyAdopters.status'=>1,

                                                                    'OR' =>[
                                                                                ['EarlyAdopters.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['EarlyAdopters.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->EarlyAdopters->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'EarlyAdopters.user_id '=>$UserId, 'EarlyAdopters.status'=>1,

                                                                    'OR' =>[
                                                                                ['EarlyAdopters.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->EarlyAdopters->find('all',['conditions'=>['EarlyAdopters.user_id'=>$UserId,'EarlyAdopters.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10,'order' => ['EarlyAdopters.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);
           $this->loadModel('EarlyAdopters');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM early_adopter_keywords as KY INNER JOIN early_adopters as SU ON FIND_IN_SET(KY.id, SU.early_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->EarlyAdopters->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'EarlyAdopters.user_id '=>$UserId, 'EarlyAdopters.status'=>2,

                                                                    'OR' =>[
                                                                                ['EarlyAdopters.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['EarlyAdopters.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->EarlyAdopters->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'EarlyAdopters.user_id '=>$UserId, 'EarlyAdopters.status'=>2,

                                                                    'OR' =>[
                                                                                ['EarlyAdopters.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->EarlyAdopters->find('all',['conditions'=>['EarlyAdopters.user_id'=>$UserId,'EarlyAdopters.status'=>2]])->contain(['Users']);
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
           $this->paginate = [ 'limit' => 10,'order' => ['EarlyAdopters.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);
           $this->loadModel('EarlyAdopters');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM early_adopter_keywords as KY INNER JOIN early_adopters as SU ON FIND_IN_SET(KY.id, SU.early_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->EarlyAdopters->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'EarlyAdopters.user_id '=>$UserId, 'EarlyAdopters.status'=>0,

                                                                    'OR' =>[
                                                                                ['EarlyAdopters.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['EarlyAdopters.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->EarlyAdopters->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'EarlyAdopters.user_id '=>$UserId, 'EarlyAdopters.status'=>0,

                                                                    'OR' =>[
                                                                                ['EarlyAdopters.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->EarlyAdopters->find('all',['conditions'=>['EarlyAdopters.user_id'=>$UserId,'EarlyAdopters.status'=>0]])->contain(['Users']);
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
            $this->loadModel('EarlyAdopters');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->EarlyAdopters->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Early Adopter has been activated successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('The Early Adopter could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myEarlyAdopter']);
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
            $this->loadModel('EarlyAdopters');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->EarlyAdopters->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Early Adopter has been archived successfully.');
                    $this->redirect(['action' => 'myEarlyAdopter']);

                }else{

                    $this->Flash->error('The Early Adopter could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myEarlyAdopter']);
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
            $this->loadModel('EarlyAdopters');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->EarlyAdopters->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Early Adopter has been deactivated successfully.');
                    $this->redirect(['action' => 'myEarlyAdopter']);

                }else{

                    $this->Flash->error('The Early Adopter could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myEarlyAdopter']);
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
            $this->loadModel('EarlyAdopters');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->EarlyAdopters->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The Early Adopter has been deleted successfully.');
                    $this->redirect(['action' => 'myEarlyAdopter']);

                }else{

                    $this->Flash->error('The Early Adopter could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myEarlyAdopter']);
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
            $this->loadModel('EarlyAdopters');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->EarlyAdopters->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('EarlyAdopterDislikes');
                    $likeExists= $this->EarlyAdopterDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'early_adopter_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->EarlyAdopterDislikes->get($likeExists->id);
                        $this->EarlyAdopterDislikes->delete($entity);
                    }

                    $this->loadModel('EarlyAdopterLikes');
                    $likefunds = $this->EarlyAdopterLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['early_adopter_id']=$fundId;
                    $likefunds = $this->EarlyAdopterLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->EarlyAdopterLikes->find('all',['conditions'=>['like_by'=>$likeBy,'early_adopter_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->EarlyAdopterLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Early Adopter liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Early Adopter. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Early Adopter. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unlike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('EarlyAdopters');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->EarlyAdopters->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('EarlyAdopterLikes');
                    $likeExists= $this->EarlyAdopterLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'early_adopter_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->EarlyAdopterLikes->get($likeExists->id);
                        $this->EarlyAdopterLikes->delete($entity);
                    

                        $this->Flash->success('Early Adopter unliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->success('Could not unlike Early Adopter. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find Early Adopter.');
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
            $this->loadModel('EarlyAdopters');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->EarlyAdopters->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('EarlyAdopterFollowers');
                    $FundFollowers = $this->EarlyAdopterFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['early_adopter_id']=$fundId;
                    $likefunds = $this->EarlyAdopterFollowers->patchEntity($FundFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->EarlyAdopterFollowers->find('all',['conditions'=>['user_id'=>$followBy,'early_adopter_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->EarlyAdopterFollowers->save($likefunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveEarlyAdopterFeeds($followBy,'feeds_earlyadopter_following',$fundId);
                            
                            $this->Flash->success('Early Adopter followed successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Early Adopter. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Early Adopter.');
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
            $this->loadModel('EarlyAdopters');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->EarlyAdopters->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('EarlyAdopterFollowers');
                $likeExists= $this->EarlyAdopterFollowers->find('all',['conditions'=>['user_id'=>$followBy,'early_adopter_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->EarlyAdopterFollowers->get($likeExists->id);
                    $this->EarlyAdopterFollowers->delete($entity);
                }

                $this->Flash->success('Early Adopter unfollowed successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Early Adopter.');
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
            $this->loadModel('EarlyAdopters');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->EarlyAdopters->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('EarlyAdopterLikes');
                    $likeExists= $this->EarlyAdopterLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'early_adopter_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->EarlyAdopterLikes->get($likeExists->id);
                        $this->EarlyAdopterLikes->delete($entity);
                    }

                    $this->loadModel('EarlyAdopterDislikes');
                    $dislikefunds = $this->EarlyAdopterDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['early_adopter_id']=$fundId;
                    $dislikefunds = $this->EarlyAdopterDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->EarlyAdopterDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'early_adopter_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->EarlyAdopterDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Early Adopter disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Early Adopter. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Early Adopter.');
                    return $this->redirect($this->referer());
                }        
    }

    public function undisLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('EarlyAdopters');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->EarlyAdopters->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('EarlyAdopterDislikes');
                    $likeExists= $this->EarlyAdopterDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'early_adopter_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->EarlyAdopterDislikes->get($likeExists->id);
                        $this->EarlyAdopterDislikes->delete($entity);
                    

                        $this->Flash->success('Early Adopter undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Early Adopter. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Early Adopter. Please try again.');
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
            $this->loadModel('EarlyAdopters');
            $this->loadModel('EarlyCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->EarlyAdopters->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['early_adopter_id']=$fundId;

                    $likefunds = $this->EarlyCommitments->newEntity(); 
                    $likefunds = $this->EarlyCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->EarlyCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'early_adopter_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->EarlyCommitments->save($likefunds);

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
            $this->loadModel('EarlyAdopters');
            $this->loadModel('EarlyCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->EarlyAdopters->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->EarlyCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'early_adopter_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->EarlyCommitments->get($likeExists->id);
                        $this->EarlyCommitments->delete($entity);
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
            $this->loadModel('EarlyAdopters');
            $this->loadModel('EarlyAdopterKeywords');
            $this->loadModel('EarlyAdopterInterestKeywords');
            $this->loadModel('EarlyAdopterTargetMarkets');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->EarlyAdopterInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->EarlyAdopterTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->EarlyAdopterKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->EarlyAdopters->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->EarlyAdopters->find('all',['conditions'=>['EarlyAdopters.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->EarlyUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->EarlyUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);
            }else{

                $this->Flash->success('Could not find Early Adopter. Please, try again.');
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

            $this->loadModel('EarlyAdopters');
            $this->loadModel('EarlyAdopterKeywords');
            $this->loadModel('EarlyAdopterInterestKeywords');
            $this->loadModel('EarlyAdopterTargetMarkets');


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->EarlyAdopterInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->EarlyAdopterTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->EarlyAdopterKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->EarlyAdopters->newEntity(); 



            if($this->request->is('post'))
            {

                $target_market ='';
                if(!empty($this->request->data['target_market'])){
                  $target_market = implode(',', $this->request->data['target_market']);
                }
                $this->request->data['target_market']=$target_market;

                $interest_keywords_id ='';
                if(!empty($this->request->data['early_interest_keywords_id'])){
                  $interest_keywords_id = implode(',', $this->request->data['early_interest_keywords_id']);
                }
                $this->request->data['early_interest_keywords_id']=$interest_keywords_id;

                $keywords_id ='';
                if(!empty($this->request->data['early_keywords_id'])){
                  $keywords_id = implode(',', $this->request->data['early_keywords_id']);
                }
                $this->request->data['early_keywords_id']=$keywords_id;

                $uploadImgError='';
                $uploadimgName='';
                $flag=0;

                if(!empty($this->request->data['image']['name'])){
                 
                    $data = [];
                    $data = $this->request->data['image']; 
                    $uploadImg = $this->EarlyUpload->uploadImage($data);

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
                    $uploadDoc = $this->EarlyUpload->uploadDoc($data2);

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
                    $uploadAusio = $this->EarlyUpload->uploadAudio($data3);

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
                    $uploadVideo = $this->EarlyUpload->uploadVideo($data3);

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

                        $addfunds = $this->EarlyAdopters->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->EarlyAdopters->save($addfunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveEarlyAdopterFeeds($userId,'feeds_earlyadopter_added',$resultSave->id);

                             $this->Flash->success('Early Adopter saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myEarlyAdopter']);

                        }else{

                             $this->Flash->error('Could not save Early Adopter. Please, try again.');
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
        
            $this->loadModel('EarlyAdopters');
            $this->loadModel('EarlyAdopterKeywords');
            $this->loadModel('EarlyAdopterInterestKeywords');
            $this->loadModel('EarlyAdopterTargetMarkets');
            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->EarlyAdopterInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->EarlyAdopterTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->EarlyAdopterKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->EarlyAdopters->newEntity(); 
            $this->EarlyAdopters->validator()->remove('start_date');

            $exists= $this->EarlyAdopters->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->EarlyAdopters->get($fundId);
                $this->set('fundDetails',$fundDetails);

                    if($this->request->is('post'))
                    {
                       
                        $target_market =$fundDetails->target_market;
                        if(!empty($this->request->data['target_market'])){
                          $target_market = implode(',', $this->request->data['target_market']);
                        }
                        $this->request->data['target_market']=$target_market;

                        $interest_keywords_id =$fundDetails->early_interest_keywords_id;
                        if(!empty($this->request->data['early_interest_keywords_id'])){
                          $interest_keywords_id = implode(',', $this->request->data['early_interest_keywords_id']);
                        }
                        $this->request->data['early_interest_keywords_id']=$interest_keywords_id;

                        $keywords_id =$fundDetails->early_keywords_id;
                        if(!empty($this->request->data['early_keywords_id'])){
                          $keywords_id = implode(',', $this->request->data['early_keywords_id']);
                        }
                        $this->request->data['early_keywords_id']=$keywords_id;


                        $uploadImgError='';
                        $uploadimgName=$fundDetails->image;
                        $flag=0;

                        if(!empty($this->request->data['image']['name'])){
                         
                            $data = [];
                            $data = $this->request->data['image']; 
                            $uploadImg = $this->EarlyUpload->uploadImage($data);

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
                            $uploadDoc = $this->EarlyUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->EarlyUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->EarlyUpload->uploadVideo($data3);

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

                            $addfunds = $this->EarlyAdopters->patchEntity($addfunds, $this->request->data);
                            $addfunds->id=$fundId;
                                $resultSave = $this->EarlyAdopters->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Early Adopter updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myEarlyAdopter']);

                                }else{
                                     $this->Flash->error('Could not update Early Adopter. Please, try again.');
                                }   
                        }else{
                            $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                        }        
                    }
            }else{
                $this->Flash->error('You dont have access to edit this Early Adopter.');
                return $this->redirect(['action'=>'myEarlyAdopter']);
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
            
            $this->loadModel('EarlyAdopters');
            $this->loadModel('EarlyAdopterLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->EarlyAdopterLikes->find('all',['conditions'=>['early_adopter_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('EarlyAdopters');
            $this->loadModel('EarlyAdopterDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->EarlyAdopterDislikes->find('all',['conditions'=>['early_adopter_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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

        $type= 'early_adopter';
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
