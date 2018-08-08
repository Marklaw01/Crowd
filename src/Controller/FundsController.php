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
class FundsController extends AppController
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
        $this->loadComponent('FundsUpload');
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
            $this->paginate = [ 'limit' => 10, 
                                'order' => [
                                    'Funds.id' => 'desc'
                                ] 
                            ];
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM keyword_funds as KY INNER JOIN funds as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Funds->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Funds.user_id !='=>$UserId, 'Funds.status'=>1,

                                                                    'OR' =>[
                                                                                ['Funds.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Funds.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Funds->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Funds.user_id !='=>$UserId, 'Funds.status'=>1,

                                                                    'OR' =>[
                                                                                ['Funds.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists = $this->Funds->find('all',['conditions'=>['Funds.user_id !='=>$UserId,'Funds.status'=>1]])->contain(['Users']);
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
    public function myFund()
    {
           $this->paginate = [ 'limit' => 10];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM keyword_funds as KY INNER JOIN funds as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Funds->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Funds.user_id '=>$UserId, 'Funds.status'=>1,

                                                                    'OR' =>[
                                                                                ['Funds.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Funds.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Funds->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Funds.user_id '=>$UserId, 'Funds.status'=>1,

                                                                    'OR' =>[
                                                                                ['Funds.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Funds->find('all',['conditions'=>['Funds.user_id'=>$UserId,'Funds.status'=>1]])->contain(['Users']);
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
         $this->paginate = [ 'limit' => 10];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM keyword_funds as KY INNER JOIN funds as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Funds->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Funds.user_id '=>$UserId, 'Funds.status'=>2,

                                                                    'OR' =>[
                                                                                ['Funds.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Funds.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Funds->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Funds.user_id '=>$UserId, 'Funds.status'=>2,

                                                                    'OR' =>[
                                                                                ['Funds.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Funds->find('all',['conditions'=>['Funds.user_id'=>$UserId,'Funds.status'=>2]])->contain(['Users']);
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
            $this->paginate = [ 'limit' => 10];
           $UserId = $this->request->Session()->read('Auth.User.id');
           $this->set('UserId',$UserId);

            $searchKeyword=$this->request->query('search');
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }

            if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM keyword_funds as KY INNER JOIN funds as SU ON FIND_IN_SET(KY.id, SU.keywords_id) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                        
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');
                    $startupIDs=[];

                    foreach($startup_ids as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                    if(!empty($startupIDs)){

                        $myFundsLists= $this->Funds->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Funds.user_id '=>$UserId, 'Funds.status'=>0,

                                                                    'OR' =>[
                                                                                ['Funds.title LIKE' => '%'.$searchKeyword.'%'],
                                                                                ['Funds.id IN' =>$startupIDs]
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);

                    }else{

                        $myFundsLists= $this->Funds->find('all',
                                                            ['conditions'=>
                                                                [
                                                                    'Funds.user_id '=>$UserId, 'Funds.status'=>0,

                                                                    'OR' =>[
                                                                                ['Funds.title LIKE' => '%'.$searchKeyword.'%']
                                                                            ]        
                                                                ]

                                                            ])->contain(['Users']);
                    }
            }else{

                    $myFundsLists= $this->Funds->find('all',['conditions'=>['Funds.user_id'=>$UserId,'Funds.status'=>0]])->contain(['Users']);
            }

           
           
           $this->set('myFundsLists', $this->paginate($myFundsLists));

     }


    /**
    * archiveFund Method
    *
    *
    ***/
    public function activateFund($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Funds');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Funds->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The fund has been activated successfully.');
                    //$this->redirect(['action' => 'myFund']);
                    return $this->redirect($this->referer()); 

                }else{

                    $this->Flash->error('The fund could not be activated. Please, try again.');
                    $this->redirect(['action' => 'myFund']);
                }
          
    }

     /**
    * archiveFund Method
    *
    *
    ***/
    public function archiveFund($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Funds');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Funds->query()
                      ->update()
                      ->set(['status' => 2])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The fund has been archived successfully.');
                    $this->redirect(['action' => 'myFund']);

                }else{

                    $this->Flash->error('The fund could not be archived. Please, try again.');
                    $this->redirect(['action' => 'myFund']);
                }
          
    }

     /**
    * archiveFund Method
    *
    *
    ***/
    public function deactivateFund($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Funds');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Funds->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The fund has been deactivated successfully.');
                    $this->redirect(['action' => 'myFund']);

                }else{

                    $this->Flash->error('The fund could not be deactivated. Please, try again.');
                    $this->redirect(['action' => 'myFund']);
                }
          
    }


     /**
    * archiveFund Method
    *
    *
    ***/
    public function deleteFund($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Funds');
                
                $this->request->allowMethod(['post', 'delete']);
                $user_id = $this->request->Session()->read('Auth.User.id');
                $fund_id = base64_decode($id);

                $res= $this->Funds->query()
                      ->update()
                      ->set(['status' => 3])
                      ->where(['id' => $fund_id,'user_id' => $user_id])
                      ->execute();

                if ($res) {
                        
                    $this->Flash->success('The fund has been deleted successfully.');
                    $this->redirect(['action' => 'myFund']);

                }else{

                    $this->Flash->error('The fund could not be deleted. Please, try again.');
                    $this->redirect(['action' => 'myFund']);
                }
          
    }


    /*
     *  likeFund method 
     *
     *
     *
     *
     ***/
    public function likeFund($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Funds');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Funds->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('FundDislikes');
                    $likeExists= $this->FundDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'fund_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->FundDislikes->get($likeExists->id);
                        $this->FundDislikes->delete($entity);
                    }

                    $this->loadModel('FundLikes');
                    $likefunds = $this->FundLikes->newEntity(); 

                    $this->request->data['like_by']=$likeBy;
                    $this->request->data['fund_id']=$fundId;
                    $likefunds = $this->FundLikes->patchEntity($likefunds, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->FundLikes->find('all',['conditions'=>['like_by'=>$likeBy,'fund_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
                        $resultSave = $this->FundLikes->save($likefunds);
                        if ($resultSave){

                            $this->Flash->success('Fund liked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->error('Could not like Funds. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->error('Could not like Funds. Please try again.');
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
    public function unLikeFund($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Funds');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Funds->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('FundLikes');
                    $likeExists= $this->FundLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'fund_id' => $fundId]])->first();

                    if(!empty($likeExists))
                    {
                        $entity = $this->FundLikes->get($likeExists->id);
                        $this->FundLikes->delete($entity);

                        $this->Flash->success('Fund unliked successfully.');
                        return $this->redirect($this->referer());

                    }else{

                        $this->Flash->success('Could not unlike Funds. Please try again.');
                        return $this->redirect($this->referer()); 
                    } 

                }else{
                    $this->Flash->success('Could not find Funds.');
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
    public function followFund($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Funds');

                $followBy= $this->request->Session()->read('Auth.User.id');;
                $fundId= base64_decode($id);
                
                $exists= $this->Funds->exists(['id' => $fundId]);

                if($exists){

                    $this->loadModel('FundFollowers');
                    $FundFollowers = $this->FundFollowers->newEntity(); 

                    $this->request->data['user_id']=$followBy;
                    $this->request->data['fund_id']=$fundId;
                    $likefunds = $this->FundFollowers->patchEntity($FundFollowers, $this->request->data);

                    //Check if liked already
                    $likeExists= $this->FundFollowers->find('all',['conditions'=>['user_id'=>$followBy,'fund_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $likefunds->id=$likeExists->id;
                    }
 
                        $resultSave = $this->FundFollowers->save($likefunds);
                        if ($resultSave){
                            
                            //Save Feeds
                            $this->Feeds->saveFundsFeeds($followBy,'feeds_fund_following',$fundId);

                            $this->Flash->success('Fund followed successfully.');
                            return $this->redirect($this->referer()); 

                        }else{
                            $this->Flash->error('Could not follow Funds. Please try again.');
                            return $this->redirect($this->referer()); 

                        }   
                }else{

                    $this->Flash->error('Could not find Funds.');
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
    public function unfollowFund($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Funds');

            $followBy= $this->request->Session()->read('Auth.User.id');;
            $fundId= base64_decode($id);

            $exists= $this->Funds->exists(['id' => $fundId]);

            if($exists){

                //delete record from follow table
                $this->loadModel('FundFollowers');
                $likeExists= $this->FundFollowers->find('all',['conditions'=>['user_id'=>$followBy,'fund_id' => $fundId]])->first();

                if(!empty($likeExists)){
                    $entity = $this->FundFollowers->get($likeExists->id);
                    $this->FundFollowers->delete($entity);
                }

                $this->Flash->success('Fund unfollowed successfully.');
                return $this->redirect($this->referer()); 

            }else{
                $this->Flash->error('Could not find Funds.');
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
    public function disLikeFund($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Funds');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $dislikeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Funds->exists(['id' => $fundId]);

                if($exists){

                    //delete record from like table
                    $this->loadModel('FundLikes');
                    $likeExists= $this->FundLikes->find('all',['conditions'=>['like_by'=>$dislikeBy,'fund_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->FundLikes->get($likeExists->id);
                        $this->FundLikes->delete($entity);
                    }

                    $this->loadModel('FundDislikes');
                    $dislikefunds = $this->FundDislikes->newEntity(); 

                     $this->request->data['dislike_by']=$dislikeBy;
                    $this->request->data['fund_id']=$fundId;
                    $dislikefunds = $this->FundDislikes->patchEntity($dislikefunds, $this->request->data);
                    
                    //Check if liked already
                    $dislikeExists= $this->FundDislikes->find('all',['conditions'=>['dislike_by'=>$dislikeBy,'fund_id' => $fundId]])->first();

                    if(!empty($dislikeExists)){
                        $dislikefunds->id=$dislikeExists->id;
                    }
                        $resultSave = $this->FundDislikes->save($dislikefunds);
                        if ($resultSave){

                            $this->Flash->success('Fund disliked successfully.');
                            return $this->redirect($this->referer());

                        }else{
                            $this->Flash->success('Could not dislike Funds. Please try again.');
                            return $this->redirect($this->referer()); 
                        }   
                }else{
                    $this->Flash->success('Could not find Funds.');
                    return $this->redirect($this->referer());
                }        
    }

    /*
     *  likeFund method 
     *
     *
     *
     *
     ***/
    public function undisLikeFund($id=null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('Funds');

            $this->request->allowMethod(['post', 'delete']);

                $user_id = $this->request->Session()->read('Auth.User.id');

                $likeBy= $user_id;
                $fundId= base64_decode($id);

                $exists= $this->Funds->exists(['id' => $fundId]);

                if($exists){

                    //delete record from dislike table
                    $this->loadModel('FundDislikes');
                    $likeExists= $this->FundDislikes->find('all',['conditions'=>['dislike_by'=>$likeBy,'fund_id' => $fundId]])->first();
                    if(!empty($likeExists)){
                        $entity = $this->FundDislikes->get($likeExists->id);
                        $this->FundDislikes->delete($entity);

                        $this->Flash->success('Fund undisliked successfully.');
                        return $this->redirect($this->referer());

                    }else{
                            
                            $this->Flash->error('Could not undislike Funds. Please try again.');
                            return $this->redirect($this->referer()); 
                    }   
                }else{
                    $this->Flash->error('Could not find Funds.');
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
            $this->loadModel('Funds');
            $this->loadModel('FundIndustries');
            $this->loadModel('KeywordFunds');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $managerLists = $this->FundsUpload->fundsManagerLists($userId);
            $this->set('managerLists', $managerLists);

            $sponsorsLists = $this->FundsUpload->sponsorsList($userId);
            $this->set('sponsorsLists', $sponsorsLists);

            $industryLists = $this->FundIndustries->find('list')->toArray();
            $this->set('industryLists',$industryLists);

            $portfolioLists = $this->FundsUpload->fundPortfolioList($userId);
            $this->set('portfolioLists', $portfolioLists);

            $keywordsLists = $this->KeywordFunds->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $exists= $this->Funds->exists(['id' => $fundId]);

            if($exists){   
                $fundDeatils=$this->Funds->find('all',['conditions'=>['Funds.id' => $fundId]])->contain('Users')->first();
                $this->set('fundDeatils', $fundDeatils);

                $is_follwed_by_user = $this->FundsUpload->isFundFollowedbyUser($fundDeatils->id,$userId);
                $this->set('is_follwed_by_user', $is_follwed_by_user);
            }else{

                $this->Flash->success('Could not find fund. Please, try again.');
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

            $this->loadModel('Funds');
            $this->loadModel('FundIndustries');
            $this->loadModel('KeywordFunds');


            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $managerLists = $this->FundsUpload->fundsManagerLists($userId);
            $this->set('managerLists', $managerLists);

            $sponsorsLists = $this->FundsUpload->sponsorsList($userId);
            $this->set('sponsorsLists', $sponsorsLists);

            $industryLists = $this->FundIndustries->find('list')->toArray();
            $this->set('industryLists',$industryLists);

            $portfolioLists = $this->FundsUpload->fundAddPortfolioList($userId);
            $this->set('portfolioLists', $portfolioLists);

            $keywordsLists = $this->KeywordFunds->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->Funds->newEntity(); 



            if($this->request->is('post'))
            {
               // pr($this->request->data());die;

                $managers_id ='';
                if(!empty($this->request->data['managers_id'])){
                  $managers_id = implode(',', $this->request->data['managers_id']);
                }
                $this->request->data['managers_id']=$managers_id;

                $sponsors_id ='';
                if(!empty($this->request->data['sponsors_id'])){
                  $sponsors_id = implode(',', $this->request->data['sponsors_id']);
                }
                $this->request->data['sponsors_id']=$sponsors_id;

                $indusries_id ='';
                if(!empty($this->request->data['indusries_id'])){
                  $indusries_id = implode(',', $this->request->data['indusries_id']);
                }
                $this->request->data['indusries_id']=$indusries_id;

                $portfolios_id ='';
                if(!empty($this->request->data['portfolios_id'])){
                  $portfolios_id = implode(',', $this->request->data['portfolios_id']);
                }
                $this->request->data['portfolios_id']=$portfolios_id;

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
                    $uploadImg = $this->FundsUpload->uploadFundImage($data);

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
                    $uploadDoc = $this->FundsUpload->uploadFundDoc($data2);

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
                    $uploadAusio = $this->FundsUpload->uploadFundAudio($data3);

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
                    $uploadVideo = $this->FundsUpload->uploadFundVideo($data3);

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
                    $DateClose = date('Y-m-d', strtotime($this->request->data['close_date']));

                    $flashMsg = '';
                    if($DateBegin <= $DateEnd)
                    {
                        $flag= 1;
                    }else{
                        
                        $flag= 0;
                        $flashMsg= 'Please ensure that the fund end date is greater than or equal to the fund start date.';
                    } 

                    if($DateEnd <= $DateClose){
                        if($flag == 0){
                            $flag= 0;
                        }else{
                            $flag= 1;
                        }   
                    }else{

                        $flag= 0;
                        $flashMsg= 'Please ensure that the fund close date is greater than or equal to the fund end date.';
                        
                    }

                    
                    if($flag)
                    {

                        $this->request->data['image']=$uploadimgName;
                        $this->request->data['document']=$uploaddocName;
                        $this->request->data['audio']=$uploadAudioName;
                        $this->request->data['video']=$uploadVideoName;
                        $this->request->data['user_id']=$userId;

                        $addfunds = $this->Funds->patchEntity($addfunds, $this->request->data);

                        $resultSave = $this->Funds->save($addfunds);
                        if ($resultSave){
                             //Save Feeds
                             $this->Feeds->saveFundsFeeds($userId,'feeds_fund_added',$resultSave->id);
                             $this->Flash->success('Fund saved successfully.');
                             //return $this->redirect($this->referer());
                             return $this->redirect(['action'=>'myFund']);

                        }else{
                             $this->Flash->error('Could not save fund. Please, try again.');
                        } 

                    }else{
                        $this->Flash->error($flashMsg);
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
        
            $this->loadModel('Funds');
            $this->loadModel('FundIndustries');
            $this->loadModel('KeywordFunds');
            $fundId = base64_decode($id);

            $userId = $this->request->Session()->read('Auth.User.id');
            $this->set('userId', $userId);

            $exists= $this->Funds->exists(['id' => $fundId,'user_id' => $userId]);
            $fundDetails= $this->Funds->get($fundId);
            $this->set('fundDetails',$fundDetails);

            $managerLists = $this->FundsUpload->fundsManagerLists($userId);
            $this->set('managerLists', $managerLists);

            $sponsorsLists = $this->FundsUpload->sponsorsList($userId);
            $this->set('sponsorsLists', $sponsorsLists);

            $industryLists = $this->FundIndustries->find('list')->toArray();
            $this->set('industryLists',$industryLists);

            $portfolioLists = $this->FundsUpload->fundEditPortfolioList($userId,$fundDetails->portfolios_id);
            $this->set('portfolioLists', $portfolioLists);

            $keywordsLists = $this->KeywordFunds->find('list')->toArray();
            $this->set('keywordsLists',$keywordsLists);

            $addfunds = $this->Funds->newEntity(); 

            

            if($exists){ 
                

                    if($this->request->is('post'))
                    {
                       // pr($this->request->data());die;

                        //$managers_id =$fundDetails->managers_id;
                        $managers_id =$fundDetails->managers_id;
                        if(!empty($this->request->data['managers_id'])){
                          $managers_id = implode(',', $this->request->data['managers_id']);
                        }
                        $this->request->data['managers_id']=$managers_id;

                        //$sponsors_id =$fundDetails->sponsors_id;
                        $sponsors_id =$fundDetails->sponsors_id;
                        if(!empty($this->request->data['sponsors_id'])){
                          $sponsors_id = implode(',', $this->request->data['sponsors_id']);
                        }
                        $this->request->data['sponsors_id']=$sponsors_id;

                        //$indusries_id =$fundDetails->indusries_id;
                        $indusries_id =$fundDetails->indusries_id;
                        if(!empty($this->request->data['indusries_id'])){
                          $indusries_id = implode(',', $this->request->data['indusries_id']);
                        }
                        $this->request->data['indusries_id']=$indusries_id;

                        //$portfolios_id =$fundDetails->portfolios_id;
                        $portfolios_id =$fundDetails->portfolios_id;
                        if(!empty($this->request->data['portfolios_id'])){
                          $portfolios_id = implode(',', $this->request->data['portfolios_id']);
                        }
                        $this->request->data['portfolios_id']=$portfolios_id;

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
                            $uploadImg = $this->FundsUpload->uploadFundImage($data);

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
                            $uploadDoc = $this->FundsUpload->uploadFundDoc($data2);

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
                            $uploadAusio = $this->FundsUpload->uploadFundAudio($data3);

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
                            $uploadVideo = $this->FundsUpload->uploadFundVideo($data3);

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
                            $DateClose = date('Y-m-d', strtotime($this->request->data['close_date']));

                            $flashMsg = '';
                            if($DateBegin <= $DateEnd)
                            {
                                $flag= 1;
                            }else{
                                
                                $flag= 0;
                                $flashMsg= 'Please ensure that the fund end date is greater than or equal to the fund start date.';
                            } 

                            if($DateEnd <= $DateClose){
                                if($flag == 0){
                                    $flag= 0;
                                }else{
                                    $flag= 1;
                                }   
                            }else{

                                $flag= 0;
                                $flashMsg= 'Please ensure that the fund close date is greater than or equal to the fund end date.';
                                
                            }
                            
                            if($flag)
                            {
                                $this->request->data['image']=$uploadimgName;
                                $this->request->data['document']=$uploaddocName;
                                $this->request->data['audio']=$uploadAudioName;
                                $this->request->data['video']=$uploadVideoName;
                                $this->request->data['user_id']=$userId;

                                $addfunds = $this->Funds->patchEntity($addfunds, $this->request->data);
                                $addfunds->id=$fundId;
                                $resultSave = $this->Funds->save($addfunds);
                                if ($resultSave){

                                     $this->Flash->success('Fund updated successfully.');
                                     //return $this->redirect($this->referer());
                                     return $this->redirect(['action'=>'myFund']);

                                }else{
                                     $this->Flash->error('Could not update fund. Please, try again.');
                                } 
                                
                            }else{
                                $this->Flash->error($flashMsg);
                            }      
                        }
                    }
            }else{
                $this->Flash->error('You dont have access to edit this Fund.');
                return $this->redirect(['action'=>'myFund']);
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
            
            $this->loadModel('Funds');
            $this->loadModel('FundLikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->FundLikes->find('all',['conditions'=>['fund_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

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
            
            $this->loadModel('Funds');
            $this->loadModel('FundDislikes');
            $Id = base64_decode($id);
            $this->set('Id',$Id);

            $this->loadModel('Keywords');
            $Keywords = $this->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $likelists= $this->FundDislikes->find('all',['conditions'=>['fund_id' => $Id]])->contain(['Users'=>['ContractorBasics']]);

            $TotalItems= $likelists->count();

            if(!empty($TotalItems))
            {     
                $this->set('users', $this->paginate($likelists));

            }else{
                return $this->redirect(['action'=>'index']);
            }

    }







}
