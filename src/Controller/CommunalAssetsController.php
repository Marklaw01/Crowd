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
class CommunalAssetsController extends AppController
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
        $this->loadComponent('CommunalUpload');
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10,'order' => ['CommunalAssets.id' => 'desc']];
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM communal_asset_keywords as KY INNER JOIN communal_assets as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->CommunalAssets->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'CommunalAssets.user_id !='=>$UserId, 'CommunalAssets.status'=>1,

                                                                    'OR' =>[
                                                                                ['CommunalAssets.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['CommunalAssets.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->CommunalAssets->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'CommunalAssets.user_id !='=>$UserId, 'CommunalAssets.status'=>1,

                                                                    'OR' =>[
                                                                                ['CommunalAssets.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{


                    $myFundsLists = $this->CommunalAssets->find('all',['conditions'=>['CommunalAssets.user_id !='=>$UserId,'CommunalAssets.status'=>1]])->contain(['Users']);
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
    public function myCommunalAsset()
    {
           $this->paginate = [ 'limit' => 10,'order' => ['CommunalAssets.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM communal_asset_keywords as KY INNER JOIN communal_assets as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->CommunalAssets->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'CommunalAssets.user_id '=>$UserId, 'CommunalAssets.status'=>1,

                                                                    'OR' =>[
                                                                                ['CommunalAssets.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['CommunalAssets.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->CommunalAssets->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'CommunalAssets.user_id '=>$UserId, 'CommunalAssets.status'=>1,

                                                                    'OR' =>[
                                                                                ['CommunalAssets.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->CommunalAssets->find('all',['conditions'=>['CommunalAssets.user_id'=>$UserId,'CommunalAssets.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10,'order' => ['CommunalAssets.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM communal_asset_keywords as KY INNER JOIN communal_assets as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->CommunalAssets->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'CommunalAssets.user_id '=>$UserId, 'CommunalAssets.status'=>2,

                                                                    'OR' =>[
                                                                                ['CommunalAssets.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['CommunalAssets.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->CommunalAssets->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'CommunalAssets.user_id '=>$UserId, 'CommunalAssets.status'=>2,

                                                                    'OR' =>[
                                                                                ['CommunalAssets.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->CommunalAssets->find('all',['conditions'=>['CommunalAssets.user_id'=>$UserId,'CommunalAssets.status'=>2]])->contain(['Users']);
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
            $this->paginate = [ 'limit' => 10,'order' => ['CommunalAssets.id' => 'desc']];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM communal_asset_keywords as KY INNER JOIN communal_assets as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->CommunalAssets->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'CommunalAssets.user_id '=>$UserId, 'CommunalAssets.status'=>0,

                                                                    'OR' =>[
                                                                                ['CommunalAssets.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['CommunalAssets.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->CommunalAssets->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'CommunalAssets.user_id '=>$UserId, 'CommunalAssets.status'=>0,

                                                                    'OR' =>[
                                                                                ['CommunalAssets.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->CommunalAssets->find('all',['conditions'=>['CommunalAssets.user_id'=>$UserId,'CommunalAssets.status'=>0]])->contain(['Users']);
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
            $this->loadModel('CommunalAssets');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->CommunalAssets->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Communal Asset has been activated successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('Communal Asset could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myCommunalAsset']);
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
            $this->loadModel('CommunalAssets');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->CommunalAssets->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Communal Asset has been archived successfully.');
                    $this->redirect(['action' => 'myCommunalAsset']);

                }else{

                    $this->Flash->error('Communal Asset could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myCommunalAsset']);
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
            $this->loadModel('CommunalAssets');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->CommunalAssets->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Communal Asset has been deactivated successfully.');
                    $this->redirect(['action' => 'myCommunalAsset']);

                }else{

                    $this->Flash->error('Communal Asset could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myCommunalAsset']);
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
            $this->loadModel('CommunalAssets');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->CommunalAssets->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('Communal Asset has been deleted successfully.');
                    $this->redirect(['action' => 'myCommunalAsset']);

                }else{

                    $this->Flash->error('Communal Asset could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myCommunalAsset']);
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
            $this->loadModel('CommunalAssets');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->CommunalAssets->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('CommunalAssetDislikes');
                    $likeExists= $this->CommunalAssetDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'communalasset_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->CommunalAssetDislikes->get($likeExists->id);
                        $this->CommunalAssetDislikes->delete($entity);
                    }

                    $this->loadModel('CommunalAssetLikes');
                    $likefunds = $this->CommunalAssetLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['communalasset_id']=$fundId;
                    $likefunds = $this->CommunalAssetLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->CommunalAssetLikes->find('all',['conditions'=>['like_by'=>$likeBy,'communalasset_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->CommunalAssetLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Communal Asset liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Communal Asset. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Communal Asset. Please try again.');
                    return $this->redirect($this->referer()); 
                }        

    }

    public function unLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('CommunalAssets');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->CommunalAssets->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('CommunalAssetLikes');
                    $likeExists= $this->CommunalAssetLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'communalasset_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->CommunalAssetLikes->get($likeExists->id);
                        $this->CommunalAssetLikes->delete($entity);
                    

                        $this->Flash->success('Communal Asset unliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->success('Could not unlike Communal Asset. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->success('Could not find Communal Asset.');
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
            $this->loadModel('CommunalAssets');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->CommunalAssets->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('CommunalAssetFollowers');
                    $CommunalAssetFollowers = $this->CommunalAssetFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['communalasset_id']=$fundId;
                    $likefunds = $this->CommunalAssetFollowers->patchEntity($CommunalAssetFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->CommunalAssetFollowers->find('all',['conditions'=>['user_id'=>$followBy,'communalasset_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->CommunalAssetFollowers->save($likefunds);
                        if ($resultSave){
                            
                            //Save Feeds
                            $this->Feeds->saveCommunalAssetFeeds($followBy,'feeds_communal_following',$fundId);

                            $this->Flash->success('Followed Communal Asset successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Communal Asset. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Communal Asset.');
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
            $this->loadModel('CommunalAssets');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->CommunalAssets->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('CommunalAssetFollowers');
                $likeExists= $this->CommunalAssetFollowers->find('all',['conditions'=>['user_id'=>$followBy,'communalasset_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->CommunalAssetFollowers->get($likeExists->id);
                    $this->CommunalAssetFollowers->delete($entity);
                }

                $this->Flash->success('Unfollowed Communal Asset successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Communal Asset.');
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
            $this->loadModel('CommunalAssets');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->CommunalAssets->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('CommunalAssetLikes');
                    $likeExists= $this->CommunalAssetLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'communalasset_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->CommunalAssetLikes->get($likeExists->id);
                        $this->CommunalAssetLikes->delete($entity);
                    }

                    $this->loadModel('CommunalAssetDislikes');
                    $dislikefunds = $this->CommunalAssetDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['communalasset_id']=$fundId;
                    $dislikefunds = $this->CommunalAssetDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->CommunalAssetDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'communalasset_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->CommunalAssetDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Communal Asset Disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Communal Asset. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Communal Asset.');
                    return $this->redirect($this->referer());
                }        
    }

    public function undisLike($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('CommunalAssets');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->CommunalAssets->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('CommunalAssetDislikes');
                    $likeExists= $this->CommunalAssetDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'communalasset_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->CommunalAssetDislikes->get($likeExists->id);
                        $this->CommunalAssetDislikes->delete($entity);
                    

                        $this->Flash->success('Communal Asset undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                        $this->Flash->error('Could not undislike Communal Asset. Please try again.');
                        return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not undislike Communal Asset. Please try again.');
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
            $this->loadModel('CommunalAssets');
            $this->loadModel('CommunalAssetCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->CommunalAssets->exists(['id' => $fundId]);

                if($exists){
                    $this->request->data['user_id']=$likeBy;
                    $this->request->data['communalasset_id']=$fundId;

                    $likefunds = $this->CommunalAssetCommitments->newEntity(); 
                    $likefunds = $this->CommunalAssetCommitments->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->CommunalAssetCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'communalasset_id' => $fundId]])->first();

                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }

                        $resultSave = $this->CommunalAssetCommitments->save($likefunds);

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
            $this->loadModel('CommunalAssets');
            $this->loadModel('CommunalAssetCommitments');

                $likeBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);

                $exists= $this->CommunalAssets->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $likeExists= $this->CommunalAssetCommitments->find('all',['conditions'=>['user_id'=>$likeBy,'communalasset_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->CommunalAssetCommitments->get($likeExists->id);
                        $this->CommunalAssetCommitments->delete($entity);
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
            $this->loadModel('CommunalAssets');
            $this->loadModel('CommunalAssetKeywords');
            $this->loadModel('CommunalAssetInterestKeywords');
            $this->loadModel('CommunalAssetTargetMarkets');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);


            $intrestKeywordLists = $this->CommunalAssetInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->CommunalAssetTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->CommunalAssetKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->CommunalAssets->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->CommunalAssets->find('all',['conditions'=>['CommunalAssets.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->CommunalUpload->isFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);

                $is_commited_by_user = $this->CommunalUpload->isCommitedbyUser($fundDeatils->id,$userId);
                $this->set('is_commited_by_user', $is_commited_by_user);
            }else{

                $this->Flash->success('Could not find Communal Asset. Please, try again.');
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

            $this->loadModel('CommunalAssets');
            $this->loadModel('CommunalAssetKeywords');
            $this->loadModel('CommunalAssetInterestKeywords');
            $this->loadModel('CommunalAssetTargetMarkets');


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->CommunalAssetInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->CommunalAssetTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->CommunalAssetKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);


            $addfunds = $this->CommunalAssets->newEntity(); 



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
                    $uploadImg = $this->CommunalUpload->uploadImage($data);

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
                    $uploadDoc = $this->CommunalUpload->uploadDoc($data2);

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
                    $uploadAusio = $this->CommunalUpload->uploadAudio($data3);

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
                    $uploadVideo = $this->CommunalUpload->uploadVideo($data3);

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

                        $addfunds = $this->CommunalAssets->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->CommunalAssets->save($addfunds);
                        if ($resultSave){

                            //Save Feeds
                            $this->Feeds->saveCommunalAssetFeeds($userId,'feeds_communal_added',$resultSave->id);

                             $this->Flash->success('Communal Asset saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myCommunalAsset']);

                        }else{
                             $this->Flash->error('Could not save Communal Asset. Please, try again.');
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
        
            $this->loadModel('CommunalAssets');
            $this->loadModel('CommunalAssetKeywords');
            $this->loadModel('CommunalAssetInterestKeywords');
            $this->loadModel('CommunalAssetTargetMarkets');
            $fundId = base64_decode($id);


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $intrestKeywordLists = $this->CommunalAssetInterestKeywords->find('list')->toArray();
            $this->set('intrestKeywordLists',$intrestKeywordLists);

            $targetMarketLists = $this->CommunalAssetTargetMarkets->find('list')->toArray();
            $this->set('targetMarketLists',$targetMarketLists);

            $keywordsLists = $this->CommunalAssetKeywords->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->CommunalAssets->newEntity(); 
            $this->CommunalAssets->validator()->remove('start_date');

            $exists= $this->CommunalAssets->exists(['id' => $fundId,'user_id' => $userId]);

            if($exists){ 
                $fundDetails= $this->CommunalAssets->get($fundId);
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
                            $uploadImg = $this->CommunalUpload->uploadImage($data);

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
                            $uploadDoc = $this->CommunalUpload->uploadDoc($data2);

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
                            $uploadAusio = $this->CommunalUpload->uploadAudio($data3);

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
                            $uploadVideo = $this->CommunalUpload->uploadVideo($data3);

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

                                $addfunds = $this->CommunalAssets->patchEntity($addfunds, $this->request->data);
                                $addfunds->id=$fundId;
                                $resultSave = $this->CommunalAssets->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Communal Asset updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myCommunalAsset']);

                                }else{
                                     $this->Flash->error('Could not update Communal Asset. Please, try again.');
                                }  
                            }else{
                                $this->Flash->error('Please ensure that the end date is greater than or equal to the start date.');
                            }     
                        }
                    }
            }else{
                $this->Flash->error('You dont have access to edit this.');
                return $this->redirect(['action'=>'myCommunalAsset']);
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
            
            $this->loadModel('CommunalAssets');
            $this->loadModel('CommunalAssetLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->CommunalAssetLikes->find('all',['conditions'=>['communalasset_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('CommunalAssets');
            $this->loadModel('CommunalAssetDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->CommunalAssetDislikes->find('all',['conditions'=>['communalasset_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $likelists->count();

            if(!empty($TotalItems))
            {     
                $this->set('users', $this->paginate($likelists));

            }else{
                return $this->redirect(['action'=>'index']);
            }

    }












}
