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
class MeetupsController extends AppController
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
        $this->loadComponent('MeetupUpload');
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 30,'order' => ['Meetups.id' => 'desc']];
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId',$UserId);

            $this->loadModel('BusinessUserNetworks');
            $this->loadModel('UserConnections');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM meetup_keywords as KY INNER JOIN meetups as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Meetups->find('all',
                                        ['conditions'=>[
                                            'Meetups.user_id !='=>$UserId, 
                                            'Meetups.status'=>1,
                                            //'Meetups.access_level'=>1,
                                            'OR' =>[
                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%'],
                                                ['Meetups.id IN' =>$startupIDs]
                                                ]        
                                                        ]
                                        ])->contain(['Users']);

                        $userConnData= $this->BusinessUserNetworks->find('all',['conditions'=>['connected_to' =>$UserId]])->first();
                       
                        $userConnections= $this->UserConnections->find('all',['conditions'=>['connection_to' =>$UserId,'status'=>1]])->first();

                        /*if($userConnData && !$userConnections){
                            
                            $myFundsLists= $this->Meetups->find('all',
                                        ['conditions'=>[
                                            'Meetups.user_id !='=>$UserId, 
                                            'Meetups.status'=>1,
                                            'Meetups.access_level'=>1,
                                            'OR' =>[
                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%'],
                                                ['Meetups.id IN' =>$startupIDs]
                                                ]        
                                                        ]
                                        ])->contain(['Users']);
                        
                        }elseif($userConnections && !$userConnData){
                           
                            $myFundsLists= $this->Meetups->find('all',
                                        ['conditions'=>[
                                            'Meetups.user_id !='=>$UserId, 
                                            'Meetups.status'=>1,
                                            'Meetups.access_level'=>2,
                                            'OR' =>[
                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%'],
                                                ['Meetups.id IN' =>$startupIDs]
                                                ]        
                                                        ]
                                        ])->contain(['Users']);
                        }else{
                            //echo "in";
                            $myFundsLists= $this->Meetups->find('all',
                                        ['conditions'=>[
                                            'Meetups.user_id !='=>$UserId, 
                                            'Meetups.status'=>1,
                                            'Meetups.access_level'=>3,
                                            'OR' =>[
                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%'],
                                                ['Meetups.id IN' =>$startupIDs]
                                                ]        
                                                        ]
                                        ])->contain(['Users']);

                        } */

                    }else{

                        $myFundsLists= $this->Meetups->find('all',
                                        ['conditions'=>[
                                            'Meetups.user_id !='=>$UserId,
                                            'Meetups.status'=>1,
                                            //'Meetups.access_level'=>1
                                            'OR' =>[
                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%']
                                                    ]        
                                            ]
                                        ])->contain(['Users']);

                        /*$userConnData= $this->BusinessUserNetworks->find('all',['conditions'=>['connected_to' =>$UserId]])->first();
                        //pr($userConnData); die;

                        $userConnections= $this->UserConnections->find('all',['conditions'=>['connection_to' =>$UserId,'status'=>1]])->first();

                        if($userConnData && !$userConnections){
                            $myFundsLists= $this->Meetups->find('all',
                                        ['conditions'=>[
                                            'Meetups.user_id !='=>$UserId,
                                            'Meetups.status'=>1,
                                            'Meetups.access_level'=>1,
                                            'OR' =>[
                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%']
                                                    ]        
                                            ]
                                        ])->contain(['Users']);
                        
                        }elseif($userConnections && !$userConnData){
                            $myFundsLists= $this->Meetups->find('all',
                                        ['conditions'=>[
                                            'Meetups.user_id !='=>$UserId,
                                            'Meetups.status'=>1,
                                            'Meetups.access_level'=>2,
                                            'OR' =>[
                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%']
                                                    ]        
                                            ]
                                        ])->contain(['Users']);
                        }else{
                            //echo "in"; die;
                            $myFundsLists= $this->Meetups->find('all',
                                        ['conditions'=>[
                                            'Meetups.user_id !='=>$UserId,
                                            'Meetups.status'=>1,
                                            'Meetups.access_level'=>3,
                                            'OR' =>[
                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%']
                                                    ]        
                                            ]
                                        ])->contain(['Users']);
                        }*/ 

                    }
            }else{

                $myFundsLists = $this->Meetups->find('all',['conditions'=>['Meetups.user_id !='=>$UserId,'Meetups.status'=>1]])->contain(['Users']);

                /*$userConnData= $this->BusinessUserNetworks->find('all',['conditions'=>['connected_to' =>$UserId]])->first();
                //pr($userConnData); die;

                $userConnections= $this->UserConnections->find('all',['conditions'=>['connection_to' =>$UserId,'status'=>1]])->first();

                if($userConnData && !$userConnections){
                    $myFundsLists= $this->Meetups->find('all',['conditions'=>['Meetups.user_id !='=>$UserId,'Meetups.status'=>1,'Meetups.access_level'=>1]])->contain(['Users']);
                
                }elseif($userConnections && !$userConnData){
                    $myFundsLists= $this->Meetups->find('all',['conditions'=>['Meetups.user_id !='=>$UserId,'Meetups.status'=>1,'Meetups.access_level'=>2]])->contain(['Users']);
                }else{
                    //echo "in"; die;
                    $myFundsLists= $this->Meetups->find('all',['conditions'=>['Meetups.user_id !='=>$UserId,'Meetups.status'=>1,'Meetups.access_level'=>3]])->contain(['Users']);
                }*/ 

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
    public function myMeetup()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['Meetups.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM meetup_keywords as KY INNER JOIN meetups as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Meetups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Meetups.user_id '=>$UserId, 'Meetups.status'=>1,

                                                                    'OR' =>[
                                                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Meetups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Meetups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Meetups.user_id '=>$UserId, 'Meetups.status'=>1,

                                                                    'OR' =>[
                                                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Meetups->find('all',['conditions'=>['Meetups.user_id'=>$UserId,'Meetups.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10,'order' => ['Meetups.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM meetup_keywords as KY INNER JOIN meetups as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Meetups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Meetups.user_id '=>$UserId, 'Meetups.status'=>2,

                                                                    'OR' =>[
                                                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Meetups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Meetups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Meetups.user_id '=>$UserId, 'Meetups.status'=>2,

                                                                    'OR' =>[
                                                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Meetups->find('all',['conditions'=>['Meetups.user_id'=>$UserId,'Meetups.status'=>2]])->contain(['Users']);
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
            $this->paginate = [ 'limit' => 10,'order' => ['Meetups.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM meetup_keywords as KY INNER JOIN meetups as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Meetups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Meetups.user_id '=>$UserId, 'Meetups.status'=>0,

                                                                    'OR' =>[
                                                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Meetups.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Meetups->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Meetups.user_id '=>$UserId, 'Meetups.status'=>0,

                                                                    'OR' =>[
                                                                                ['Meetups.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Meetups->find('all',['conditions'=>['Meetups.user_id'=>$UserId,'Meetups.status'=>0]])->contain(['Users']);
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
            $this->loadModel('Meetups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Meetups->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Meetup has been activated successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('Meetup could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myMeetup']);
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
            $this->loadModel('Meetups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Meetups->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Meetup has been archived successfully.');
                    $this->redirect(['action' => 'myMeetup']);

                }else{

                    $this->Flash->error('Meetup could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myMeetup']);
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
            $this->loadModel('Meetups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Meetups->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Meetup has been deactivated successfully.');
                    $this->redirect(['action' => 'myMeetup']);

                }else{

                    $this->Flash->error('Meetup could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myMeetup']);
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
            $this->loadModel('Meetups');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Meetups->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Meetup has been deleted successfully.');
                    $this->redirect(['action' => 'myMeetup']);

                }else{

                    $this->Flash->error('Meetup could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myMeetup']);
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
            $this->loadModel('Meetups');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Meetups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('MeetupDislikes');
                    $likeExists= $this->MeetupDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'meetup_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->MeetupDislikes->get($likeExists->id);
                        $this->MeetupDislikes->delete($entity);
                    }

                    $this->loadModel('MeetupLikes');
                    $likefunds = $this->MeetupLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['meetup_id']=$fundId;
                    $likefunds = $this->MeetupLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->MeetupLikes->find('all',['conditions'=>['like_by'=>$likeBy,'meetup_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->MeetupLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Meetup liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Meetup. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Meetup. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unlike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Meetups');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Meetups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('MeetupLikes');
                    $likeExists= $this->MeetupLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'meetup_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->MeetupLikes->get($likeExists->id);
                        $this->MeetupLikes->delete($entity);
                    

                        $this->Flash->success('Meetup unliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->success('Could not unlike Meetup. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find Meetup.');
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
            $this->loadModel('Meetups');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Meetups->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('MeetupFollowers');
                    $MeetupFollowers = $this->MeetupFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['meetup_id']=$fundId;
                    $likefunds = $this->MeetupFollowers->patchEntity($MeetupFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->MeetupFollowers->find('all',['conditions'=>['user_id'=>$followBy,'meetup_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->MeetupFollowers->save($likefunds);
                        if ($resultSave){
                            
                            //Save Feeds
                            $this->Feeds->saveMeetupFeeds($followBy,'feeds_meetup_following',$fundId);

                            $this->Flash->success('Followed Meetup successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Meetup. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Meetup.');
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
            $this->loadModel('Meetups');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->Meetups->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('MeetupFollowers');
                $likeExists= $this->MeetupFollowers->find('all',['conditions'=>['user_id'=>$followBy,'meetup_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->MeetupFollowers->get($likeExists->id);
                    $this->MeetupFollowers->delete($entity);
                }

                $this->Flash->success('Unfollowed Meetup successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Meetup.');
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
            $this->loadModel('Meetups');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Meetups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('MeetupLikes');
                    $likeExists= $this->MeetupLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'meetup_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->MeetupLikes->get($likeExists->id);
                        $this->MeetupLikes->delete($entity);
                    }

                    $this->loadModel('MeetupDislikes');
                    $dislikefunds = $this->MeetupDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['meetup_id']=$fundId;
                    $dislikefunds = $this->MeetupDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->MeetupDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'meetup_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->MeetupDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Meetup Disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Meetup. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Meetup.');
                    return $this->redirect($this->referer());
                }        
    }

     public function undisLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Meetups');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Meetups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('MeetupDislikes');
                    $likeExists= $this->MeetupDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'meetup_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->MeetupDislikes->get($likeExists->id);
                        $this->MeetupDislikes->delete($entity);
                    

                        $this->Flash->success('Meetup undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Meetup. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Meetup. Please try again.');
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
            $this->loadModel('Meetups');
            $this->loadModel('MeetupCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Meetups->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['meetup_id']=$fundId;

                    $likefunds = $this->MeetupCommitments->newEntity(); 
                    $likefunds = $this->MeetupCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->MeetupCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'meetup_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->MeetupCommitments->save($likefunds);

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
            $this->loadModel('Meetups');
            $this->loadModel('MeetupCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->Meetups->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->MeetupCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'meetup_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->MeetupCommitments->get($likeExists->id);
                        $this->MeetupCommitments->delete($entity);
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
            $this->loadModel('Meetups');
            $this->loadModel('Forums');
            $this->loadModel('MeetupKeywords');
            $this->loadModel('MeetupInterestKeywords');
            $this->loadModel('MeetupTargetMarkets');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->MeetupInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->MeetupTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->MeetupKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);


            $exists= $this->Meetups->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->Meetups->find('all',['conditions'=>['Meetups.id' => $fundId]])->contain('Users')->first();

                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->MeetupUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->MeetupUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);

                if($fundDeatils->forum_id >= 0){
                    $Forums = $this->Forums->find('all',['conditions'=>['Forums.id'=>$fundDeatils->forum_id,'Forums.user_status'=>0,'Forums.status'=>1]])->first();
                }else{
                    $Forums = "";
                }   
                $this->set('forum', $Forums);

            }else{

                $this->Flash->success('Could not find Meetup. Please, try again.');
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

            $this->loadModel('Meetups');
            $this->loadModel('MeetupKeywords');
            $this->loadModel('MeetupInterestKeywords');
            $this->loadModel('MeetupTargetMarkets');
            $this->loadModel('Forums');
        
            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->MeetupInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->MeetupTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->MeetupKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $Forums = $this->Forums->find('list',['conditions'=>['Forums.user_id'=>$userId,'Forums.user_status'=>0,'Forums.status'=>1]])->toArray();

            $this->set('forums',$Forums);


            $addfunds = $this->Meetups->newEntity(); 



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
                    $uploadImg = $this->MeetupUpload->uploadImage($data);

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
                    $uploadDoc = $this->MeetupUpload->uploadDoc($data2);

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
                    $uploadAusio = $this->MeetupUpload->uploadAudio($data3);

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
                    $uploadVideo = $this->MeetupUpload->uploadVideo($data3);

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

                        $addfunds = $this->Meetups->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->Meetups->save($addfunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveMeetupFeeds($userId,'feeds_meetup_added',$resultSave->id);

                             $this->Flash->success('Meetup saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myMeetup']);

                        }else{
                             $this->Flash->error('Could not save Meetup. Please, try again.');
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
        
            $this->loadModel('Meetups');
            $this->loadModel('Forums');
            $this->loadModel('MeetupKeywords');
            $this->loadModel('MeetupInterestKeywords');
            $this->loadModel('MeetupTargetMarkets');
            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->MeetupInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->MeetupTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->MeetupKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->Meetups->newEntity(); 
            $this->Meetups->validator()->remove('start_date');

            $Forums = $this->Forums->find('list',['conditions'=>['Forums.user_id'=>$userId,'Forums.user_status'=>0,'Forums.status'=>1]])->toArray();

            $this->set('forums',$Forums);

            $exists= $this->Meetups->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->Meetups->get($fundId);
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
                            $uploadImg = $this->MeetupUpload->uploadImage($data);

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
                            $uploadDoc = $this->MeetupUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->MeetupUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->MeetupUpload->uploadVideo($data3);

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
//print_r($this->request->data); die();
                                $addfunds = $this->Meetups->patchEntity($addfunds, $this->request->data);
                                $addfunds->id=$fundId;
                                $resultSave = $this->Meetups->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Meetup updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myMeetup']);

                                }else{
                                     $this->Flash->error('Could not update Meetup. Please, try again.');
                                }
                            }else{
                                $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                            }       
                        }
                    }
            }else{
                $this->Flash->error('You dont have access to edit this.');
                return $this->redirect(['action'=>'myMeetup']);
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
            
            $this->loadModel('Meetups');
            $this->loadModel('MeetupLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->MeetupLikes->find('all',['conditions'=>['meetup_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('Meetups');
            $this->loadModel('MeetupDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->MeetupDislikes->find('all',['conditions'=>['meetup_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $likelists->count();

            if(!empty($TotalItems))
            {     
                $this->set('users', $this->paginate($likelists));

            }else{
                return $this->redirect(['action'=>'index']);
            }

    }












}
