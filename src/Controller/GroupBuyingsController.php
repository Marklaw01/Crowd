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
class GroupBuyingsController extends AppController
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
        $this->loadComponent('GroupBuyingUpload');
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['GroupBuyings.id' => 'desc']];
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM group_buying_keywords as KY INNER JOIN group_buyings as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->GroupBuyings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'GroupBuyings.user_id !='=>$UserId, 'GroupBuyings.status'=>1,

                                                                    'OR' =>[
                                                                                ['GroupBuyings.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['GroupBuyings.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->GroupBuyings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'GroupBuyings.user_id !='=>$UserId, 'GroupBuyings.status'=>1,

                                                                    'OR' =>[
                                                                                ['GroupBuyings.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{


                    $myFundsLists = $this->GroupBuyings->find('all',['conditions'=>['GroupBuyings.user_id !='=>$UserId,'GroupBuyings.status'=>1]])->contain(['Users']);
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
    public function myGroupBuying()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['GroupBuyings.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM group_buying_keywords as KY INNER JOIN group_buyings as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->GroupBuyings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'GroupBuyings.user_id '=>$UserId, 'GroupBuyings.status'=>1,

                                                                    'OR' =>[
                                                                                ['GroupBuyings.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['GroupBuyings.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->GroupBuyings->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'GroupBuyings.user_id '=>$UserId, 'GroupBuyings.status'=>1,

                                                                    'OR' =>[
                                                                                ['GroupBuyings.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->GroupBuyings->find('all',['conditions'=>['GroupBuyings.user_id'=>$UserId,'GroupBuyings.status'=>1]])->contain(['Users']);
            }

           
           
           $this->set('myFundsLists', $this->paginate($myFundsLists));
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
            $this->loadModel('GroupBuyings');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->GroupBuyings->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Group Buying has been deleted successfully.');
                    $this->redirect(['action' => 'myGroupBuying']);

                }else{

                    $this->Flash->error('GroupBuying could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myGroupBuying']);
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
            $this->loadModel('GroupBuyings');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->GroupBuyings->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('GroupBuyingDislikes');
                    $likeExists= $this->GroupBuyingDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'groupbuying_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->GroupBuyingDislikes->get($likeExists->id);
                        $this->GroupBuyingDislikes->delete($entity);
                    }

                    $this->loadModel('GroupBuyingLikes');
                    $likefunds = $this->GroupBuyingLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['groupbuying_id']=$fundId;
                    $likefunds = $this->GroupBuyingLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->GroupBuyingLikes->find('all',['conditions'=>['like_by'=>$likeBy,'groupbuying_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->GroupBuyingLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Group Buying liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Group Buying. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Group Buying. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unlike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('GroupBuyings');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->GroupBuyings->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('GroupBuyingLikes');
                    $likeExists= $this->GroupBuyingLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'groupbuying_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->GroupBuyingLikes->get($likeExists->id);
                        $this->GroupBuyingLikes->delete($entity);
                    

                        $this->Flash->success('Group Buying Disliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        
                        $this->Flash->success('Could not dislike Group Buying. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find GroupBuying.');
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
            $this->loadModel('GroupBuyings');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->GroupBuyings->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('GroupBuyingFollowers');
                    $GroupBuyingFollowers = $this->GroupBuyingFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['groupbuying_id']=$fundId;
                    $likefunds = $this->GroupBuyingFollowers->patchEntity($GroupBuyingFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->GroupBuyingFollowers->find('all',['conditions'=>['user_id'=>$followBy,'groupbuying_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->GroupBuyingFollowers->save($likefunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveGroupBuyingFeeds($followBy,'feeds_purchaseorder_following',$fundId);
                            
                            $this->Flash->success('Followed Group Buying successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Group Buying. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Group Buying.');
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
            $this->loadModel('GroupBuyings');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->GroupBuyings->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('GroupBuyingFollowers');
                $likeExists= $this->GroupBuyingFollowers->find('all',['conditions'=>['user_id'=>$followBy,'groupbuying_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->GroupBuyingFollowers->get($likeExists->id);
                    $this->GroupBuyingFollowers->delete($entity);
                }

                $this->Flash->success('Unfollowed Group Buying successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Group Buying.');
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
            $this->loadModel('GroupBuyings');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->GroupBuyings->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('GroupBuyingLikes');
                    $likeExists= $this->GroupBuyingLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'groupbuying_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->GroupBuyingLikes->get($likeExists->id);
                        $this->GroupBuyingLikes->delete($entity);
                    }

                    $this->loadModel('GroupBuyingDislikes');
                    $dislikefunds = $this->GroupBuyingDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['groupbuying_id']=$fundId;
                    $dislikefunds = $this->GroupBuyingDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->GroupBuyingDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'groupbuying_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->GroupBuyingDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Group Buying Disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Group Buying. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find GroupBuying.');
                    return $this->redirect($this->referer());
                }        
    }

    public function undisLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('GroupBuyings');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->GroupBuyings->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('GroupBuyingDislikes');
                    $likeExists= $this->GroupBuyingDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'groupbuying_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->GroupBuyingDislikes->get($likeExists->id);
                        $this->GroupBuyingDislikes->delete($entity);
                   

                        $this->Flash->success('Group Buying undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Group Buying. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Group Buying. Please try again.');
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
            $this->loadModel('GroupBuyings');
            $this->loadModel('GroupBuyingCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->GroupBuyings->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['groupbuying_id']=$fundId;

                    $likefunds = $this->GroupBuyingCommitments->newEntity(); 
                    $likefunds = $this->GroupBuyingCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->GroupBuyingCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'groupbuying_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->GroupBuyingCommitments->save($likefunds);

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
            $this->loadModel('GroupBuyings');
            $this->loadModel('GroupBuyingCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->GroupBuyings->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->GroupBuyingCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'groupbuying_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->GroupBuyingCommitments->get($likeExists->id);
                        $this->GroupBuyingCommitments->delete($entity);
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
            $this->loadModel('GroupBuyings');
            $this->loadModel('GroupBuyingKeywords');
            $this->loadModel('GroupBuyingInterestKeywords');
            $this->loadModel('GroupBuyingTargetMarkets');

            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->GroupBuyingInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->GroupBuyingTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);
            
            $keywordsLists = $this->GroupBuyingKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->GroupBuyings->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->GroupBuyings->find('all',['conditions'=>['GroupBuyings.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->GroupBuyingUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->GroupBuyingUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);

            }else{

                $this->Flash->success('Could not find Group Buying. Please, try again.');
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

            $this->loadModel('GroupBuyings');
            $this->loadModel('GroupBuyingKeywords');
            $this->loadModel('GroupBuyingInterestKeywords');
            $this->loadModel('GroupBuyingTargetMarkets');



            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $keywordsLists = $this->GroupBuyingKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $intrestKeywordLists = $this->GroupBuyingInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->GroupBuyingTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);


            $addfunds = $this->GroupBuyings->newEntity(); 



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
                    $uploadImg = $this->GroupBuyingUpload->uploadImage($data);

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
                    $uploadDoc = $this->GroupBuyingUpload->uploadDoc($data2);

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
                    $uploadAusio = $this->GroupBuyingUpload->uploadAudio($data3);

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
                    $uploadVideo = $this->GroupBuyingUpload->uploadVideo($data3);

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

                        $addfunds = $this->GroupBuyings->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->GroupBuyings->save($addfunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveGroupBuyingFeeds($userId,'feeds_purchaseorder_added',$resultSave->id);

                             $this->Flash->success('Group Buying saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myGroupBuying']);

                        }else{
                             $this->Flash->error('Could not save Group Buying. Please, try again.');
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
        
            $this->loadModel('GroupBuyings');
            $this->loadModel('GroupBuyingKeywords');
            $this->loadModel('GroupBuyingInterestKeywords');
            $this->loadModel('GroupBuyingTargetMarkets');

            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $keywordsLists = $this->GroupBuyingKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $intrestKeywordLists = $this->GroupBuyingInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->GroupBuyingTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $addfunds = $this->GroupBuyings->newEntity(); 

            $exists= $this->GroupBuyings->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->GroupBuyings->get($fundId);
                $this->set('fundDetails',$fundDetails);

                    if($this->request->is('post'))
                    {
                       // pr($this->request->data());die;

                        //$managers_id =$fundDetails->managers_id;

                        $keywords_id =$fundDetails->keywords_id;
                        if(!empty($this->request->data['keywords_id'])){
                          $keywords_id = implode(',', $this->request->data['keywords_id']);
                        }
                        $this->request->data['keywords_id']=$keywords_id;

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


                        $uploadImgError='';
                        $uploadimgName=$fundDetails->image;
                        $flag=0;

                        if(!empty($this->request->data['image']['name'])){
                         
                            $data = [];
                            $data = $this->request->data['image']; 
                            $uploadImg = $this->GroupBuyingUpload->uploadImage($data);

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
                            $uploadDoc = $this->GroupBuyingUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->GroupBuyingUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->GroupBuyingUpload->uploadVideo($data3);

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

                                $addfunds = $this->GroupBuyings->patchEntity($addfunds, $this->request->data);
                                $addfunds->id=$fundId;
                                $resultSave = $this->GroupBuyings->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Group Buying updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myGroupBuying']);

                                }else{
                                     $this->Flash->error('Could not update Group Buying. Please, try again.');
                                }
                                 
                            }else{
                                $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                            }      
                        }
                    }
            }else{
                $this->Flash->error('You dont have access to edit this.');
                return $this->redirect(['action'=>'myGroupBuying']);
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
            
            $this->loadModel('GroupBuyings');
            $this->loadModel('GroupBuyingLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->GroupBuyingLikes->find('all',['conditions'=>['groupbuying_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('GroupBuyings');
            $this->loadModel('GroupBuyingDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->GroupBuyingDislikes->find('all',['conditions'=>['groupbuying_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $likelists->count();

            if(!empty($TotalItems))
            {     
                $this->set('users', $this->paginate($likelists));

            }else{
                return $this->redirect(['action'=>'index']);
            }

    }












}
