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
class AudioVideosController extends AppController
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
        $this->loadComponent('AudioUpload');
        $this->loadComponent('Feeds');
        
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['AudioVideos.id' => 'desc']];
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM audio_keywords as KY INNER JOIN audio_videos as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->AudioVideos->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'AudioVideos.user_id !='=>$UserId, 'AudioVideos.status'=>1,

                                                                    'OR' =>[
                                                                                ['AudioVideos.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['AudioVideos.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->AudioVideos->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'AudioVideos.user_id !='=>$UserId, 'AudioVideos.status'=>1,

                                                                    'OR' =>[
                                                                                ['AudioVideos.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists = $this->AudioVideos->find('all',['conditions'=>['AudioVideos.user_id !='=>$UserId,'AudioVideos.status'=>1]])->contain(['Users']);
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
    public function myAudioVideo()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['AudioVideos.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM audio_keywords as KY INNER JOIN audio_videos as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->AudioVideos->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'AudioVideos.user_id '=>$UserId, 'AudioVideos.status'=>1,

                                                                    'OR' =>[
                                                                                ['AudioVideos.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['AudioVideos.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->AudioVideos->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'AudioVideos.user_id '=>$UserId, 'AudioVideos.status'=>1,

                                                                    'OR' =>[
                                                                                ['AudioVideos.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->AudioVideos->find('all',['conditions'=>['AudioVideos.user_id'=>$UserId,'AudioVideos.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10,'order' => ['AudioVideos.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM audio_keywords as KY INNER JOIN audio_videos as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->AudioVideos->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'AudioVideos.user_id '=>$UserId, 'AudioVideos.status'=>2,

                                                                    'OR' =>[
                                                                                ['AudioVideos.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['AudioVideos.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->AudioVideos->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'AudioVideos.user_id '=>$UserId, 'AudioVideos.status'=>2,

                                                                    'OR' =>[
                                                                                ['AudioVideos.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->AudioVideos->find('all',['conditions'=>['AudioVideos.user_id'=>$UserId,'AudioVideos.status'=>2]])->contain(['Users']);
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
            $this->paginate = [ 'limit' => 10,'order' => ['AudioVideos.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM audio_keywords as KY INNER JOIN audio_videos as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->AudioVideos->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'AudioVideos.user_id '=>$UserId, 'AudioVideos.status'=>0,

                                                                    'OR' =>[
                                                                                ['AudioVideos.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['AudioVideos.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->AudioVideos->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'AudioVideos.user_id '=>$UserId, 'AudioVideos.status'=>0,

                                                                    'OR' =>[
                                                                                ['AudioVideos.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->AudioVideos->find('all',['conditions'=>['AudioVideos.user_id'=>$UserId,'AudioVideos.status'=>0]])->contain(['Users']);
            }

           
           
           $this->set('myFundsLists', $this->paginate($myFundsLists));

     }


    /**
    * archiveFund Method
    *
    *
    ***/
    public function activateAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->AudioVideos->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Audio/Video has been activated successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('Audio/Video could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myAudioVideo']);
                }
          
    }

     /**
    * archiveFund Method
    *
    *
    ***/
    public function archiveAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->AudioVideos->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Audio/Video has been archived successfully.');
                    $this->redirect(['action' => 'myAudioVideo']);

                }else{

                    $this->Flash->error('Audio/Video could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myAudioVideo']);
                }
          
    }

     /**
    * archiveFund Method
    *
    *
    ***/
    public function deactivateAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->AudioVideos->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Audio/Video has been deactivated successfully.');
                    $this->redirect(['action' => 'myAudioVideo']);

                }else{

                    $this->Flash->error('Audio/Video could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myAudioVideo']);
                }
          
    }


     /**
    * archiveFund Method
    *
    *
    ***/
    public function deleteAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->AudioVideos->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Audio/Video has been deleted successfully.');
                    $this->redirect(['action' => 'myAudioVideo']);

                }else{

                    $this->Flash->error('Audio/Video could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myAudioVideo']);
                }
          
    }


    /*
     *  likeFund method 
     *
     *
     *
     *
     ***/
    public function likeAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->AudioVideos->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('AudioDislikes');
                    $likeExists= $this->AudioDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'audio_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->AudioDislikes->get($likeExists->id);
                        $this->AudioDislikes->delete($entity);
                    }

                    $this->loadModel('AudioLikes');
                    $likefunds = $this->AudioLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['audio_id']=$fundId;
                    $likefunds = $this->AudioLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->AudioLikes->find('all',['conditions'=>['like_by'=>$likeBy,'audio_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->AudioLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Audio/Video liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Audio/Video. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Audio/Video. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unlikeAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->AudioVideos->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('AudioLikes');
                    $likeExists= $this->AudioLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'audio_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->AudioLikes->get($likeExists->id);
                        $this->AudioLikes->delete($entity);
                    

                        $this->Flash->success('Audio/Video undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->success('Could not undislike Audio/Video. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find Audio/Video.');
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
    public function followAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->AudioVideos->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('AudioFollowers');
                    $AudioFollowers = $this->AudioFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['audio_id']=$fundId;
                    $likefunds = $this->AudioFollowers->patchEntity($AudioFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->AudioFollowers->find('all',['conditions'=>['user_id'=>$followBy,'audio_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->AudioFollowers->save($likefunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveAudioFeeds($followBy,'feeds_audio_following',$fundId);
                            
                            $this->Flash->success('Followed Audio/Video successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Audio/Video. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Audio/Video.');
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
    public function unfollowAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->AudioVideos->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('AudioFollowers');
                $likeExists= $this->AudioFollowers->find('all',['conditions'=>['user_id'=>$followBy,'audio_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->AudioFollowers->get($likeExists->id);
                    $this->AudioFollowers->delete($entity);
                }

                $this->Flash->success('Unfollowed Audio/Video successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Audio/Video.');
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
    public function disLikeAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->AudioVideos->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('AudioLikes');
                    $likeExists= $this->AudioLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'audio_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->AudioLikes->get($likeExists->id);
                        $this->AudioLikes->delete($entity);
                    }

                    $this->loadModel('AudioDislikes');
                    $dislikefunds = $this->AudioDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['audio_id']=$fundId;
                    $dislikefunds = $this->AudioDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->AudioDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'audio_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->AudioDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Audio/Video Disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Audio/Video. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Audio/Video.');
                    return $this->redirect($this->referer());
                }        
    }

    public function undisLikeAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->AudioVideos->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('AudioDislikes');
                    $likeExists= $this->AudioDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'audio_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->AudioDislikes->get($likeExists->id);
                        $this->AudioDislikes->delete($entity);
                    

                        $this->Flash->success('Audio/Video undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Audio/Video. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Audio/Video. Please try again.');
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
    public function commitAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');
            $this->loadModel('AudioCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->AudioVideos->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['audio_id']=$fundId;

                    $likefunds = $this->AudioCommitments->newEntity(); 
                    $likefunds = $this->AudioCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->AudioCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'audio_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->AudioCommitments->save($likefunds);

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
    public function uncommitAudio($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('AudioVideos');
            $this->loadModel('AudioCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->AudioVideos->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->AudioCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'audio_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->AudioCommitments->get($likeExists->id);
                        $this->AudioCommitments->delete($entity);
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
            $this->loadModel('AudioVideos');
            $this->loadModel('AudioKeywords');
            $this->loadModel('AudioInterestKeywords');
            $this->loadModel('AudioTargetMarkets');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->AudioInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->AudioTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->AudioKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->AudioVideos->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->AudioVideos->find('all',['conditions'=>['AudioVideos.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->AudioUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->AudioUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);
            }else{

                $this->Flash->success('Could not find Audio/Video. Please, try again.');
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

            $this->loadModel('AudioVideos');
            $this->loadModel('AudioKeywords');
            $this->loadModel('AudioInterestKeywords');
            $this->loadModel('AudioTargetMarkets');


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->AudioInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->AudioTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->AudioKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);


            $addfunds = $this->AudioVideos->newEntity(); 



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
                    $uploadImg = $this->AudioUpload->uploadImage($data);

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
                    $uploadDoc = $this->AudioUpload->uploadDoc($data2);

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
                    $uploadAusio = $this->AudioUpload->uploadAudio($data3);

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
                    $uploadVideo = $this->AudioUpload->uploadVideo($data3);

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

                        $addfunds = $this->AudioVideos->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->AudioVideos->save($addfunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveAudioFeeds($userId,'feeds_audio_added',$resultSave->id);

                             $this->Flash->success('Audio/Video saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myAudioVideo']);

                        }else{
                             $this->Flash->error('Could not save Audio/Video. Please, try again.');
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

            $this->loadModel('AudioVideos');
            $this->loadModel('AudioKeywords');
            $this->loadModel('AudioInterestKeywords');
            $this->loadModel('AudioTargetMarkets');
            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->AudioInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->AudioTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->AudioKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->AudioVideos->newEntity(); 
            $this->AudioVideos->validator()->remove('start_date');

            $exists= $this->AudioVideos->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->AudioVideos->get($fundId);
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
                            $uploadImg = $this->AudioUpload->uploadImage($data);

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
                            $uploadDoc = $this->AudioUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->AudioUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->AudioUpload->uploadVideo($data3);

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

                                $addfunds = $this->AudioVideos->patchEntity($addfunds, $this->request->data);
                                $addfunds->id=$fundId;
                                $resultSave = $this->AudioVideos->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Audio/Video updated Audio/Videosuccessfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myAudioVideo']);

                                }else{
                                     $this->Flash->error('Could not update Audio/Video. Please, try again.');
                                }  
                            }else{
                                 $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                            } 
                        }
                    }
            }else{
                $this->Flash->error('You dont have access to edit this.');
                return $this->redirect(['action'=>'myAudioVideo']);
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
            
            $this->loadModel('AudioVideos');
            $this->loadModel('AudioLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->AudioLikes->find('all',['conditions'=>['audio_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('AudioVideos');
            $this->loadModel('AudioDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->AudioDislikes->find('all',['conditions'=>['audio_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $likelists->count();

            if(!empty($TotalItems))
            {     
                $this->set('users', $this->paginate($likelists));

            }else{
                return $this->redirect(['action'=>'index']);
            }

    }












}
