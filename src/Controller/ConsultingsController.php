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
class ConsultingsController extends AppController
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
        $this->loadComponent('ConsultingUpload');
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['Consultings.id' => 'desc']];
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM consulting_target_keywords as KY INNER JOIN consultings as SU ON FIND_IN_SET(KY.id, SU.target_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Consultings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Consultings.user_id !='=>$UserId, 'Consultings.status'=>1,

                                                                    'OR' =>[
                                                                                ['Consultings.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Consultings.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Consultings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Consultings.user_id !='=>$UserId, 'Consultings.status'=>1,

                                                                    'OR' =>[
                                                                                ['Consultings.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{


                    $myFundsLists = $this->Consultings->find('all',['conditions'=>['Consultings.user_id !='=>$UserId,'Consultings.status'=>1]])->contain(['Users']);
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
    public function myConsulting()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['Consultings.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM consulting_target_keywords as KY INNER JOIN consultings as SU ON FIND_IN_SET(KY.id, SU.target_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Consultings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Consultings.user_id '=>$UserId, 'Consultings.status'=>1,

                                                                    'OR' =>[
                                                                                ['Consultings.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Consultings.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Consultings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Consultings.user_id '=>$UserId, 'Consultings.status'=>1,

                                                                    'OR' =>[
                                                                                ['Consultings.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Consultings->find('all',['conditions'=>['Consultings.user_id'=>$UserId,'Consultings.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10,'order' => ['Consultings.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM consulting_target_keywords as KY INNER JOIN consultings as SU ON FIND_IN_SET(KY.id, SU.target_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Consultings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Consultings.user_id '=>$UserId, 'Consultings.status'=>2,

                                                                    'OR' =>[
                                                                                ['Consultings.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Consultings.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Consultings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Consultings.user_id '=>$UserId, 'Consultings.status'=>2,

                                                                    'OR' =>[
                                                                                ['Consultings.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Consultings->find('all',['conditions'=>['Consultings.user_id'=>$UserId,'Consultings.status'=>2]])->contain(['Users']);
            }

           
           
           $this->set('myFundsLists', $this->paginate($myFundsLists));      
        
    }


    /**
     * myClosed Following method
     *
     * 
     */
     public function myClosed()
     {  
            $this->paginate = [ 'limit' => 10,'order' => ['Consultings.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM consulting_target_keywords as KY INNER JOIN consultings as SU ON FIND_IN_SET(KY.id, SU.target_keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Consultings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Consultings.user_id '=>$UserId, 'Consultings.status'=>0,

                                                                    'OR' =>[
                                                                                ['Consultings.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Consultings.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Consultings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Consultings.user_id '=>$UserId, 'Consultings.status'=>0,

                                                                    'OR' =>[
                                                                                ['Consultings.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Consultings->find('all',['conditions'=>['Consultings.user_id'=>$UserId,'Consultings.status'=>0]])->contain(['Users']);
            }

           
           
           $this->set('myFundsLists', $this->paginate($myFundsLists));

     }


    /**
    * archiveFund Method
    *
    *
    ***/
    public function open($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingAwards');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Consultings->query()
                      ->update()
                      ->set(['status' => 1,'award_status'=>0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                //delete record from award table
                $likeExists= $this->ConsultingAwards->find('all',['conditions'=>['consulting_id' => $fund_id]])->first();
                if(!empty($likeExists)){
                    $entity = $this->ConsultingAwards->get($likeExists->id);
                    $this->ConsultingAwards->delete($entity);
                }  

                if ($res) {
                        
                    $this->Flash->success('Consulting has been opened successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('Consulting could not be opened. Please, try again.');
                    $this->redirect(['action' => 'myConsulting']);
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
            $this->loadModel('Consultings');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Consultings->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Consulting has been archived successfully.');
                    $this->redirect(['action' => 'myConsulting']);

                }else{

                    $this->Flash->error('Consulting could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myConsulting']);
                }
          
    }

     /**
    * archiveFund Method
    *
    *
    ***/
    public function close($id=null)
    {
            /*$this->viewBuilder()->layout(false);
            $this->render(false);*/
            $this->paginate = [ 'limit' => 10];
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingCommitments');
            $this->loadModel('ContractorProfessionals');
            $this->loadModel('ConsultingAwards');
            $this->loadModel('Users');

            $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $user_id = $this->request->Session()->read('Auth.User.id');
            $fund_id = base64_decode($id);
            
            $exists= $this->Consultings->exists(['id'=>$fund_id,'user_id'=>$user_id,'status'=>1]);  

            if($exists) {

                $ConsultingDetails=$this->Consultings->get($fund_id);
                $this->set('ConsultingDetails',$ConsultingDetails);


                $searchKeyword=trim($this->request->query('search'));
                $searchKeyword = str_replace("'","",$searchKeyword);  

                if (strpos($searchKeyword, "'") !== false) {
                    $searchKeywordArray=explode("'", $searchKeyword);
                    $searchKeyword=$searchKeywordArray[0];
                }


                if(!empty($searchKeyword)){

                    $users= $this->Users->find('all',['conditions'=>[ 'id !='=>$user_id,
                                                                    'OR' =>[
                                                                                ['first_name LIKE'=>'%'.$searchKeyword.'%'],
                                                                                ['last_name LIKE' =>'%'.$searchKeyword.'%']
                                                                            ]
                                                                    ]])->toArray();

                    if(!empty($users)){

                        foreach($users as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $contractorIds[] = $SingleUser['id'];
                            }
                        endforeach;

                        $conditions = ['ConsultingCommitments.consulting_id'=>$fund_id, 'ConsultingCommitments.user_id IN'=>$contractorIds];

                        $ConsultingCommitments = $this->ConsultingCommitments->find('all',['conditions'=>$conditions])->contain(['Users'=>['ContractorBasics']]);

                        $this->set('ConsultingCommitmentsList', $this->paginate($ConsultingCommitments));
                    } 

                }else{
                    
                    $ConsultingCommitments = $this->ConsultingCommitments->find('all',['conditions'=>['consulting_id'=>$fund_id]])->contain(['Users'=>['ContractorBasics']]);
                    $this->set('ConsultingCommitmentsList', $this->paginate($ConsultingCommitments));
                }

                if($this->request->is('post'))
                {   

                    if(isset($this->request->data['contractor_id'])){
                        $this->request->data['contractor_id']=$this->request->data['contractor_id'];
                        $awardstatus=1;

                        $msg = 'Consulting awarded successfully.';
                    }else{
                        $this->request->data['contractor_id']=0;
                        $awardstatus=0;
                        $msg= 'Consulting has been closed successfully.';
                    }
                    

                    $res= $this->Consultings->query()
                          ->update()
                          ->set(['status' => 0,'award_status'=>$awardstatus])
                          ->where(['id' => $fund_id,'user_id' => $user_id])
                          ->execute();

                    //Save  record to award table
                    $isExists= $this->ConsultingAwards->find('all',['conditions'=>['consulting_id' => $fund_id]])->first(); 
                    $this->request->data['consulting_id']=$fund_id;

                    $ConsultingAwards = $this->ConsultingAwards->newEntity(); 
                    $ConsultingAwards = $this->ConsultingAwards->patchEntity($ConsultingAwards, $this->request->data); 

                    if(!empty($isExists)){
                        $ConsultingAwards->id = $isExists->id;
                    }
                    $resultSave = $this->ConsultingAwards->save($ConsultingAwards);

                    if ($resultSave) {
                            
                        $this->Flash->success($msg);
                        $this->redirect(['action' => 'myConsulting']);

                    }else{

                        $this->Flash->error('Consulting could not be closed. Please, try again.');
                        $this->redirect(['action' => 'myConsulting']);
                    }
                }

            }else{

                $this->Flash->error('Please, try again.');
                $this->redirect(['action' => 'myConsulting']);

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
            $this->loadModel('Consultings');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Consultings->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Consulting has been deleted successfully.');
                    $this->redirect(['action' => 'myConsulting']);

                }else{

                    $this->Flash->error('Consulting could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myConsulting']);
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
            $this->loadModel('Consultings');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Consultings->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('ConsultingDislikes');
                    $likeExists= $this->ConsultingDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'consulting_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ConsultingDislikes->get($likeExists->id);
                        $this->ConsultingDislikes->delete($entity);
                    }

                    $this->loadModel('ConsultingLikes');
                    $likefunds = $this->ConsultingLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['consulting_id']=$fundId;
                    $likefunds = $this->ConsultingLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->ConsultingLikes->find('all',['conditions'=>['like_by'=>$likeBy,'consulting_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->ConsultingLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Consulting liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Consulting. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Consulting. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unlike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Consultings');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Consultings->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('ConsultingLikes');
                    $likeExists= $this->ConsultingLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'consulting_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ConsultingLikes->get($likeExists->id);
                        $this->ConsultingLikes->delete($entity);
                    

                        $this->Flash->success('Consulting unliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->success('Could not unlike Consulting. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find Consulting.');
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
            $this->loadModel('Consultings');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Consultings->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('ConsultingFollowers');
                    $ConsultingFollowers = $this->ConsultingFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['consulting_id']=$fundId;
                    $likefunds = $this->ConsultingFollowers->patchEntity($ConsultingFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->ConsultingFollowers->find('all',['conditions'=>['user_id'=>$followBy,'consulting_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->ConsultingFollowers->save($likefunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveConsultingFeeds($followBy,'feeds_consulting_following',$fundId);
                            
                            $this->Flash->success('Followed Consulting successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Consulting. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Consulting.');
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
            $this->loadModel('Consultings');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->Consultings->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('ConsultingFollowers');
                $likeExists= $this->ConsultingFollowers->find('all',['conditions'=>['user_id'=>$followBy,'consulting_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->ConsultingFollowers->get($likeExists->id);
                    $this->ConsultingFollowers->delete($entity);
                }

                $this->Flash->success('Unfollowed Consulting successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Consulting.');
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
            $this->loadModel('Consultings');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Consultings->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('ConsultingLikes');
                    $likeExists= $this->ConsultingLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'consulting_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ConsultingLikes->get($likeExists->id);
                        $this->ConsultingLikes->delete($entity);
                    }

                    $this->loadModel('ConsultingDislikes');
                    $dislikefunds = $this->ConsultingDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['consulting_id']=$fundId;
                    $dislikefunds = $this->ConsultingDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->ConsultingDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'consulting_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->ConsultingDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Consulting Disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Consulting. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Consulting.');
                    return $this->redirect($this->referer());
                }        
    }

    public function undisLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Consultings');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Consultings->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('ConsultingDislikes');
                    $likeExists= $this->ConsultingDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'consulting_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ConsultingDislikes->get($likeExists->id);
                        $this->ConsultingDislikes->delete($entity);
                    

                        $this->Flash->success('Consulting undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Consulting. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Consulting. Please try again.');
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
    public function apply($id=null)
    {
            // $this->viewBuilder()->layout(false);
            // $this->render(false);
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $commit = $this->ConsultingCommitments->newEntity(); 

                $exists= $this->Consultings->exists(['id' => $fundId]);

                $ConsultingDetails=$this->Consultings->get($fundId);
                $this->set('ConsultingDetails',$ConsultingDetails);

                $flag = '';
                if($exists){ 


                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['consulting_id']=$fundId;

                    if($this->request->is('post'))
                    {    
                        
                        $uploaddocError='';
                        $uploaddocName='';
                        if(!empty($this->request->data['document']['name'])){
                         
                            $data2 = [];
                            $data2 = $this->request->data['document']; 
                            $uploadDoc = $this->ConsultingUpload->uploadDoc($data2);

                            if(empty($uploadDoc['errors'])){
                                $uploaddocName=$uploadDoc['imgName'];
                            }else{
                                $flag=1;
                                $uploaddocError=$uploadDoc['errors'];
                            }
                        }

                        if(!empty($flag)){

                            if(!empty($uploaddocError)){
                                $this->Flash->error($uploaddocError);
                            }

                        }else{    
                            $this->request->data['document']=$uploaddocName;

                            $commit = $this->ConsultingCommitments->patchEntity($commit, $this->request->data);

                            //Check if liked already
                            $likeExists= $this->ConsultingCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'consulting_id' => $fundId]])->first();

                            if(!empty($likeExists)){
                                $commit->id=$likeExists->id;
                            }

                            $resultSave = $this->ConsultingCommitments->save($commit);

                            if ($resultSave){

                                $this->Flash->success('Registered your interest successfully.');
                                $this->redirect(['action' => 'view',$id]);
                                //return $this->redirect($this->referer());

                            }else{
                                $this->Flash->error('Could not register your interest. Please try again.');
                                return $this->redirect($this->referer()); 
                            }
                        }    
                    }
                }else{
                    $this->Flash->error('Could not register your interest or no record found. Please try again.');
                    return $this->redirect($this->referer());
                }  

                $this->set('commit', $commit);      
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
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Consultings->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->ConsultingCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'consulting_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ConsultingCommitments->get($likeExists->id);
                        $this->ConsultingCommitments->delete($entity);
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
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingTargetKeywords');
            $this->loadModel('ConsultingInterestKeywords');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->ConsultingInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);


            $keywordsLists = $this->ConsultingTargetKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->Consultings->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->Consultings->find('all',['conditions'=>['Consultings.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->ConsultingUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->ConsultingUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);
            }else{

                $this->Flash->success('Could not find Consulting. Please, try again.');
                return $this->redirect($this->referer());
            } 

    }


    /*********
     *
     *  addFunds method
     *
     *
     *
     *
     *********/
    public function add()
    {
        $userTimeZone = $this->WebNotification->getUserTimeZoneByIp();
        date_default_timezone_set($userTimeZone);

            $this->loadModel('Consultings');
            $this->loadModel('ConsultingTargetKeywords');
            $this->loadModel('ConsultingInterestKeywords');


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->ConsultingInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);


            $keywordsLists = $this->ConsultingTargetKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);


            $addfunds = $this->Consultings->newEntity(); 



            if($this->request->is('post'))
            {
               // pr($this->request->data());die;


                $target_keywords_id ='';
                if(!empty($this->request->data['target_keywords_id'])){
                  $target_keywords_id = implode(',', $this->request->data['target_keywords_id']);
                }
                $this->request->data['target_keywords_id']=$target_keywords_id;

                $interest_keyword_id ='';
                if(!empty($this->request->data['interest_keyword_id'])){
                  $interest_keyword_id = implode(',', $this->request->data['interest_keyword_id']);
                }
                $this->request->data['interest_keyword_id']=$interest_keyword_id;

                $uploadImgError='';
                $uploadimgName='';
                $flag=0;

                if(!empty($this->request->data['image']['name'])){
                 
                    $data = [];
                    $data = $this->request->data['image']; 
                    $uploadImg = $this->ConsultingUpload->uploadImage($data);

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
                    $uploadDoc = $this->ConsultingUpload->uploadDoc($data2);

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
                    $uploadAusio = $this->ConsultingUpload->uploadAudio($data3);

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
                    $uploadVideo = $this->ConsultingUpload->uploadVideo($data3);

                    if(empty($uploadVideo['errors'])){
                        $uploadVideoName=$uploadVideo['imgName'];
                    }else{
                        $flag=1;
                        $uploadVideoError=$uploadVideo['errors'];
                    }
                }


                $uploadQError='';
                $uploadQName='';
                if(!empty($this->request->data['question']['name'])){
                 
                    $data4 = [];
                    $data4 = $this->request->data['question']; 
                    $uploadQ = $this->ConsultingUpload->uploadDoc($data4);

                    if(empty($uploadQ['errors'])){
                        $uploadQName=$uploadQ['imgName'];
                    }else{
                        $flag=1;
                        $uploadQError=$uploadQ['errors'];
                    }
                }

                $uploadFBError='';
                $uploadFBName='';
                if(!empty($this->request->data['final_bid']['name'])){
                 
                    $data5 = [];
                    $data5 = $this->request->data['final_bid']; 
                    $uploadFB = $this->ConsultingUpload->uploadDoc($data5);

                    if(empty($uploadFB['errors'])){
                        $uploadFBName=$uploadFB['imgName'];
                    }else{
                        $flag=1;
                        $uploadFBError=$uploadFB['errors'];
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

                    if(!empty($uploadQError)){
                        $this->Flash->error($uploadQError);
                    }

                    if(!empty($uploadFBError)){
                        $this->Flash->error($uploadFBError);
                    }
                }else{

                    $DateBegin = date('Y-m-d', strtotime($this->request->data['project_start_date']));
                    $DateEnd = date('Y-m-d', strtotime($this->request->data['project_complete_date']));
                    
                    if($DateBegin <= $DateEnd)
                    {
                        $this->request->data['image']=$uploadimgName;
                        $this->request->data['document']=$uploaddocName;
                        $this->request->data['audio']=$uploadAudioName;
                        $this->request->data['video']=$uploadVideoName;
                        $this->request->data['question']=$uploadQName;
                        $this->request->data['final_bid']=$uploadFBName;
                        $this->request->data['user_id']=$userId;

                        $addfunds = $this->Consultings->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->Consultings->save($addfunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveConsultingFeeds($userId,'feeds_consulting_added',$resultSave->id);

                             $this->Flash->success('Consulting saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myConsulting']);

                        }else{
                             $this->Flash->error('Could not save Consulting. Please, try again.');
                        }
                    }else{
                        $this->Flash->error('Please ensure that the project end date is greater than or equal to the project start date.');
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
        
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingTargetKeywords');
            $this->loadModel('ConsultingInterestKeywords');

            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->ConsultingInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);


            $keywordsLists = $this->ConsultingTargetKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->Consultings->newEntity(); 


            $exists= $this->Consultings->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->Consultings->get($fundId);
                $this->set('fundDetails',$fundDetails);

                    if($this->request->is('post'))
                    {
                       // pr($this->request->data());die;

                        //$managers_id =$fundDetails->managers_id;


                        $target_keywords_id =$fundDetails->target_keywords_id;
                        if(!empty($this->request->data['target_keywords_id'])){
                          $target_keywords_id = implode(',', $this->request->data['target_keywords_id']);
                        }
                        $this->request->data['target_keywords_id']=$target_keywords_id;

                        $interest_keyword_id =$fundDetails->interest_keyword_id;
                        if(!empty($this->request->data['interest_keyword_id'])){
                          $interest_keyword_id = implode(',', $this->request->data['interest_keyword_id']);
                        }
                        $this->request->data['interest_keyword_id']=$interest_keyword_id;


                        $uploadImgError='';
                        $uploadimgName=$fundDetails->image;
                        $flag=0;

                        if(!empty($this->request->data['image']['name'])){
                         
                            $data = [];
                            $data = $this->request->data['image']; 
                            $uploadImg = $this->ConsultingUpload->uploadImage($data);

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
                            $uploadDoc = $this->ConsultingUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->ConsultingUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->ConsultingUpload->uploadVideo($data3);

                            if(empty($uploadVideo['errors'])){
                                $uploadVideoName=$uploadVideo['imgName'];
                            }else{
                                $flag=1;
                                $uploadVideoError=$uploadVideo['errors'];
                            }
                        }

                        $uploadQError='';
                        $uploadQName='';
                        if(!empty($this->request->data['question']['name'])){
                         
                            $data4 = [];
                            $data4 = $this->request->data['question']; 
                            $uploadQ = $this->ConsultingUpload->uploadDoc($data4);

                            if(empty($uploadQ['errors'])){
                                $uploadQName=$uploadQ['imgName'];
                            }else{
                                $flag=1;
                                $uploadQError=$uploadQ['errors'];
                            }
                        }

                        $uploadFBError='';
                        $uploadFBName='';
                        if(!empty($this->request->data['final_bid']['name'])){
                         
                            $data5 = [];
                            $data5 = $this->request->data['final_bid']; 
                            $uploadFB = $this->ConsultingUpload->uploadDoc($data5);

                            if(empty($uploadFB['errors'])){
                                $uploadFBName=$uploadFB['imgName'];
                            }else{
                                $flag=1;
                                $uploadFBError=$uploadFB['errors'];
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

                            if(!empty($uploadQError)){
                                $this->Flash->error($uploadQError);
                            }

                            if(!empty($uploadFBError)){
                                $this->Flash->error($uploadFBError);
                            }

                        }else{

                            $DateBegin = date('Y-m-d', strtotime($this->request->data['project_start_date']));
                            $DateEnd = date('Y-m-d', strtotime($this->request->data['project_complete_date']));
                            
                            if($DateBegin <= $DateEnd)
                            {
                                $this->request->data['image']=$uploadimgName;
                                $this->request->data['document']=$uploaddocName;
                                $this->request->data['audio']=$uploadAudioName;
                                $this->request->data['video']=$uploadVideoName;
                                $this->request->data['question']=$uploadQName;
                                $this->request->data['final_bid']=$uploadFBName;
                                $this->request->data['user_id']=$userId;

                                $addfunds = $this->Consultings->patchEntity($addfunds, $this->request->data);
                                $addfunds->id=$fundId;

                                $resultSave = $this->Consultings->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Consulting updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myConsulting']);

                                }else{
                                     $this->Flash->error('Could not update Consulting. Please, try again.');
                                }  
                            }else{
                                $this->Flash->error('Please ensure that the project end date is greater than or equal to the project start date.');
                            }     
                        }
                    }
            }else{
                $this->Flash->error('You dont have access to edit this.');
                return $this->redirect(['action'=>'myConsulting']);
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
            
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->ConsultingLikes->find('all',['conditions'=>['consulting_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->ConsultingDislikes->find('all',['conditions'=>['consulting_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
    public function sendInvite($id=null)
    {

            $this->paginate = [ 'limit' => 10];
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingInvitations');
            $this->loadModel('ContractorProfessionals');
            $this->loadModel('ConsultingAwards');
            $this->loadModel('EntrepreneurProfessionals');
            $this->loadModel('ContractorProfessionals');
            $this->loadModel('Users');

            $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $user_id = $this->request->Session()->read('Auth.User.id');
            $this->set('loggedUserId',$user_id);

            $fund_id = base64_decode($id);
            $this->set('ConslId',$id);
            
            $exists= $this->Consultings->exists(['id'=>$fund_id,'user_id !='=>$user_id,'status'=>1]);  

            if($exists) {

                $ConsultingDetails=$this->Consultings->get($fund_id);
                $this->set('ConsultingDetails',$ConsultingDetails);


                $searchKeyword=trim($this->request->query('search'));
                $searchKeyword = str_replace("'","",$searchKeyword);  

                if (strpos($searchKeyword, "'") !== false) {
                    $searchKeywordArray=explode("'", $searchKeyword);
                    $searchKeyword=$searchKeywordArray[0];
                }
                $ConsultingCommitments=[]; 
                $UserId = $this->request->Session()->read('Auth.User.id');
                

                if(!empty($searchKeyword)){

                    $ss = explode(' ', $searchKeyword);
                    if(!empty($ss)){
                      $searchKeyword =$ss[0];
                    }
            
                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT CP.user_id FROM keywords as KY INNER JOIN contractor_professionals as CP
                    ON FIND_IN_SET(KY.id, CP.keywords) where KY.name like '%".$searchKeyword."%' GROUP BY CP.user_id
                    UNION SELECT CB.user_id FROM contractor_basics as CB where CB.first_name like '%".$searchKeyword."%'
                    OR CB.last_name like '%".$searchKeyword."%' OR (CB.price='".$searchKeyword."' && CB.price!='' && CB.price!=0) GROUP BY CB.user_id";
                    $sql = $connection->execute ($qq);
                    $user_ids = $sql->fetchAll('assoc');

                      if(!empty($user_ids)){

                        foreach($user_ids as $SingleUser):
                            if(isset($SingleUser['user_id'])&&($SingleUser['user_id']!='')){
                                $contractorIds[] = $SingleUser['user_id'];
                            }
                        endforeach; 
                            $conditions = ['Users.id IN'=>$contractorIds,
                            'Users.id !='=>$UserId];

                            $ConsultingCommitments= $this->Users->find('all',['conditions'=>$conditions])->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);

                            $this->paginate($ConsultingCommitments); 

                      }                                                        

                }else{


                    $Startup = $this->EntrepreneurProfessionals->find('all',['conditions'=>['EntrepreneurProfessionals.user_id'=>$UserId]])
                    ->select(['keywords'])
                    ->first();
                                                //->toArray();

                    if(!empty($Startup)&&($Startup['keywords']!='')){
                        $conditions = [];
                        array_push($conditions,["ContractorProfessionals.user_id !="=>$UserId]);
                        $conditions['OR'] = [];
                            /// If search keyword is not empty

                        $keywordsList=explode(',',$Startup['keywords']);                
                        foreach($keywordsList as $single_keyword):

                           array_push($conditions['OR'],["FIND_IN_SET($single_keyword,ContractorProfessionals.keywords)"]);

                       endforeach;

                       $contractors = $this->ContractorProfessionals->find('all')
                       ->where($conditions)
                       ->select(['user_id']);

                            //$this->set('contractors', $this->paginate($contractors)); 

                       if($contractors->toArray()){

                        $contractors = $contractors->toArray();

                        foreach($contractors as $singleContractor):
                            if($singleContractor->user_id!=''):
                                $contractorIds[] = $singleContractor->user_id;
                            endif;
                        endforeach;

                            if(!empty($contractorIds)){

                              //Get result sort by name
                              //$users = $this->Users->find('all',['conditions'=>['Users.id IN'=>$contractorIds]])->contain(['ContractorBasics','ContractorProfessionals','Countries']);
                                                    //->toArray();

                              $ConsultingCommitments = $this->Users->find('all',['conditions'=>['Users.id IN'=>$contractorIds
                                   ]])->contain(['ContractorBasics','ContractorProfessionals','Countries'])->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);

                               $this->paginate($ConsultingCommitments);               
                           }

                       }

                }

               }

                $this->set('ConsultingCommitmentsList', $ConsultingCommitments);

            }else{

                $this->redirect(['action' => 'view',$id]);

            }

    }


    /*  
     * 
     *
     *
     *
     *
     ***/
    public function invite($sent_to=null,$ConlId=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingInvitations');

            $sent_to = base64_decode($sent_to);
            $ConlId = base64_decode($ConlId);

                $sent_by = $this->request->Session()->read('Auth.User.id');

                $this->request->data['sent_by'] =$sent_by;
                $this->request->data['sent_to']=$sent_to;
                $this->request->data['consulting_id']= $ConlId;

                if(!empty($sent_to)){

                        $this->request->data['status']=0;
                        $likefunds = $this->ConsultingInvitations->newEntity(); 
                        $likefunds = $this->ConsultingInvitations->patchEntity($likefunds, $this->request->data);

                        //Check if liked already
                        $likeExists= $this->ConsultingInvitations->find('all',['conditions'=>['sent_by'=>$sent_by,'sent_to'=>$sent_to,'consulting_id' => $ConlId]])->first();

                        if(!empty($likeExists)){
                            $likefunds->id=$likeExists->id;
                        }

                        $resultSave = $this->ConsultingInvitations->save($likefunds);
                    
                    if ($resultSave){

                        $this->Flash->success('Consulting invitation sent successfully.');
                        return $this->redirect($this->referer()); 

                    }else{

                        $this->Flash->error('Invitation could not be sent. Please, try again.');
                        return $this->redirect($this->referer()); 
                    }  
                }else{
                    $this->Flash->error('Invitation could not be sent. Please, try again.');
                    return $this->redirect($this->referer()); 
                }        

    }


    /*  
     * 
     *
     *
     *
     *
     ***/
    public function invitation()
    {       
            $this->paginate = [ 'limit' => 10];
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingInvitations');
            $sent_to = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId',$sent_to);

            $ConsultingInvitations= $this->ConsultingInvitations->find('all',['conditions'=>['ConsultingInvitations.sent_to'=>$sent_to,'ConsultingInvitations.status'=>0]])->contain(['Consultings'=>['Users'],'ByUser'=>['ContractorBasics'],'ToUser'=>['ContractorBasics']]);

            $this->set('ConsultingInvitations',$this->paginate($ConsultingInvitations));
    }

    /*  
     *
     *
     *
     *
     ***/
    public function accept($ConlId=null,$sent_by=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingInvitations');

            if($this->request->is('post'))
            {

                $sent_to = $this->request->Session()->read('Auth.User.id');

                $sent_by = base64_decode($sent_by);
                $ConlId = base64_decode($ConlId);

                $this->request->data['user_id']=$sent_to;
                $this->request->data['sent_by']=$sent_by;
                $this->request->data['consulting_id']=$ConlId;

                $exists= $this->ConsultingInvitations->exists(['sent_by'=>$sent_by,'sent_to'=>$sent_to,'consulting_id' => $ConlId]);

                if($exists){

                    $res= $this->ConsultingInvitations->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['sent_by' => $sent_by,'sent_to' => $sent_to,'consulting_id' => $ConlId])
                      ->execute(); 
                    
                    if ($res){

                        $this->Flash->success('Invitation accepted successfully.');
                        return $this->redirect($this->referer()); 

                    }else{
                        $this->Flash->error('Could not accept Invitation. Please try again.');
                        return $this->redirect($this->referer());
                    }   
                }else{
                    $this->Flash->error('Invitation could not be accepted. Please, try again.');
                    return $this->redirect($this->referer()); 
                }        
            }
    }


    /*  
     *
     *
     *
     *
     ***/
    public function reject($ConlId=null,$sent_by=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Consultings');
            $this->loadModel('ConsultingInvitations');

            if($this->request->is('post'))
            {

                $sent_to = $this->request->Session()->read('Auth.User.id');

                $sent_by = base64_decode($sent_by);
                $ConlId = base64_decode($ConlId);

                $this->request->data['user_id']=$sent_to;
                $this->request->data['sent_by']=$sent_by;
                $this->request->data['consulting_id']=$ConlId;

                $exists= $this->ConsultingInvitations->exists(['sent_by'=>$sent_by,'sent_to'=>$sent_to,'consulting_id' => $ConlId]);

                if($exists){

                    $likeExists= $this->ConsultingInvitations->find('all',['conditions'=>['sent_by'=>$sent_by,'sent_to'=>$sent_to,'consulting_id' => $ConlId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->ConsultingInvitations->get($likeExists->id);
                        $this->ConsultingInvitations->delete($entity);

                        $this->Flash->success('Invitation rejected successfully.');
                        return $this->redirect($this->referer()); 

                    }else{
                        $this->Flash->error('Could not reject Invitation. Please try again.');
                        return $this->redirect($this->referer());
                    }   
                }else{
                    $this->Flash->error('Invitation could not be rejected. Please, try again.');
                    return $this->redirect($this->referer()); 
                }        
            }
    }


}
