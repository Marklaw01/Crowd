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
class CampaignsController extends AppController
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
        $this->loadComponent('Feeds');
    }
    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {   
        if ($this->Auth->user()) {
                $this->redirect(['action' => 'Recommended']);
        }
    }


    /******
     * Recommended method
     *
     * 
     *
     *
     *****/

    public function Recommended()
    {         
            $this->paginate = [ 'limit' => 10,
            'contain' => ['Users', 'Startups']
            ];
            $campaigns = $this->Campaigns->find('all');
            $user = $this->Auth->user();
            //$current_date_time = date('Y-m-d H:i:s');
            $current_date_time =date('Y-m-d H:i:s', strtotime(' -1 day'));
            //$current_date_time = date('F d, Y');
            if($user){    
               $UserId = $this->request->Session()->read('Auth.User.id');
               $this->set('userId',$UserId);

               //Get User Keywords
               //$var = $this->UserImageWeb->entrepreneurKeywords($UserId);
               $var = $this->UserImageWeb->contractorKeywords($UserId);

                // Make custom query for FIND IN SET
                $x= explode(',',$var);
                $Cx=count($x);
                $finQuery='';
                
                    for ($i=0; $i<$Cx; $i++){
                        if($i<$Cx){
                             
                             $or = ' or';
                        
                        } else { $or ='';}
                            
                            $finQuery .= ' FIND_IN_SET("'.$x[$i].'", campaigns.keywords)'.$or;
                    }

                $finQuery= chop($finQuery,"or");
                $startups = $this->Campaigns->Startups->find('all', [
                                    'conditions' => ['Startups.user_id !=' => $UserId]])->toArray();;
                $this->set('startups',$startups);

                /// Custom Query to get reccommended campaigns
                $connection = ConnectionManager::get('default');
                $sql = $connection->execute ('SELECT DISTINCT *FROM `campaigns` WHERE '.$finQuery);
                $datas = $sql->fetchAll('assoc');
                //$this->set('datas', $datas);

                // Custom for Pagination
                if(!empty($var)&&($Cx!='')){
                    $conditions = [];
                    array_push($conditions,["Campaigns.user_id !="=>$UserId]);
                    array_push($conditions,['Campaigns.comp_due_date >='=>$current_date_time]);
                    $x= explode(',',$var);
                    $Cx=count($x);
                    $conditions['OR'] = [];

                    for ($i=0; $i<$Cx; $i++){              
                        array_push($conditions['OR'],["FIND_IN_SET($x[$i],Campaigns.keywords)"]);
                    }

                    $campaign_details = $this->Campaigns->find('all')->distinct()->where($conditions)->order(['Campaigns.id' => 'DESC']);
                    $this->set('datas', $campaign_details);

                    /*$campaign_details = $campaign_details->toArray();
                    foreach($campaign_details as $key=>$val){
                       $time = strtotime($val->due_date);
                        $newformat = date('Y-m-d',$time);
                        if(strtotime($current_date_time)>=strtotime($newformat)){
                            unset($campaign_details[$key]);
                        }
                    }*/

                }else {
                    $campaign_details='';
                    $this->set('datas', $campaign_details);
                }


                $this->set('campaigns', $this->paginate($campaign_details));
                $this->set('_serialize', ['campaigns']);

            }   
        
    }


    /**
     * Campaign Following method
     *
     * @return void
     */
     public function following()
     {  
        $userId = $this->Auth->user('id');
        $this->paginate = [ 'limit' => 10,
            'contain' => ['Campaigns']
        ];

        //$campaigns = $this->Campaigns->CampaignFollowers->find('all', ['conditions' => ['CampaignFollowers.user_id' => $userId] , 'order'=>['CampaignFollowers.id DESC']])->contain(['Campaigns']);
        
        //$current_date_time = date('Y-m-d H:i:s');
        $current_date_time =date('Y-m-d H:i:s', strtotime(' -1 day'));
        //$campaigns = $this->Campaigns->CampaignFollowers->find('all', ['conditions' => ['CampaignFollowers.user_id' => $userId] , 'order'=>['Campaigns.id DESC']])->contain(['Campaigns'=>['conditions'=>['Campaigns.comp_due_date >='=>$current_date_time]]]);

        $campaigns = $this->Campaigns->CampaignFollowers->find('all', ['conditions' => ['CampaignFollowers.user_id' => $userId] , 'order'=>['Campaigns.id DESC']])->contain(['Campaigns']);
//pr($campaigns); die;
        /// NEED TO REPLACE THIS $campaigns WITH $this->Campaigns IN BELOW CODE TO GET LOGGED USER CAMPAIGNS
        $this->set('campaigns', $this->paginate($campaigns));
        $this->set('_serialize', ['campaigns']);

     }

     /**
     *
     *
     * My Campaigns method
     *
     * 
     ***/
    public function myCampaign()
    {
        $userId = $this->Auth->user('id');
        $this->paginate = [ 'limit' => 10,
            'contain' => ['Users', 'Startups']
        ];

        $campaigns = $this->Campaigns->find('all', ['conditions' => ['Campaigns.user_id' => $userId] , 'order'=>['Campaigns.id DESC']]);

        /// NEED TO REPLACE THIS $campaigns WITH $this->Campaigns IN BELOW CODE TO GET LOGGED USER CAMPAIGNS
        $this->set('campaigns', $this->paginate($campaigns));
        $this->set('_serialize', ['campaigns']);
    }

    

    /**
     * View method
     *
     * @param string|null $id Campaign id.
     * @return void
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function view($id = null)
    {
        $id = base64_decode($id);
        $userId = $this->Auth->user('id');
        $campaign = $this->Campaigns->get($id, [
            'contain' => ['Users', 'Startups', 'CampaignDonations', 'CampaignFollowers', 'CampaignRecommendations']
        ]);

        //set campaign followed or not
        $exists = $this->Campaigns->campaignFollowers->exists(['campaign_id' => $id, 'user_id'=>$userId]);
        $this->set('campaignFollow', $exists);
        //$campaignDon = $this->Campaigns->CampaignDonations->exists(['user_id'=>$userId,'campaign_id'=>$id]);
       
        $Keywords = $this->Campaigns->CampaignTargetKeywords->find('list')->toArray();
        $this->set('Keywords',$Keywords);

        $this->loadModel('KeywordCampaigns');
        $campKeywords = $this->KeywordCampaigns->find('list')->toArray();
        $this->set('campKeywords',$campKeywords);

        //Get 
        $donContractor = $this->Campaigns->CampaignDonations->find('all',['conditions' => ['CampaignDonations.campaign_id' => $id]])->contain(['Campaigns','DonationTimeperiods','Users'])->toArray();
        $this->set('donContractors', $donContractor);


        $this->set('campaign', $campaign);
        $this->set('userId', $userId);
        $this->set('_serialize', ['campaign']);
    }

    /**
     * Add method
     *
     * @return void Redirects on successful add, renders view otherwise.
     */
    public function add()
    {
             $user = $this->Auth->user();
             if($user){

                     $UserId = $this->request->Session()->read('Auth.User.id');
                     
                     $Keywords = $this->Campaigns->CampaignTargetKeywords->find('list')->toArray();
                     $this->set('Keywords',$Keywords);

                    $this->loadModel('KeywordCampaigns');
                    $campKeywords = $this->KeywordCampaigns->find('list')->toArray();
                    $this->set('campKeywords',$campKeywords);

                    $campaign = $this->Campaigns->newEntity(); 

                    if ($this->request->is('post')) {
                        

                        //Upload Campaign Image 
                            $campaignImg = $this->request->data['campaign_image'];
                            $campaignImgName = $this->Multiupload->campaignImage($campaignImg);
                            
                        //Upload doc for Campaign
                           $files = $this->request->data['files'];
                           $files['file_type'] = $this->request->data['file_type'];

                           $upload = $this->Multiupload->Multiupload($files);//call upload component to file Upload
                         //pr($upload); die;

                        ///Merge two array 
                        $a1[]=$campaignImgName['errors'];
                        $a2= $upload['errors'];
                        $b=  array_merge($a1,$a2);   
                        $docErrors=json_encode($b); //pr($campaignImgName['imgName']);die;
                        $docErrorsCount= count($b);
                        //pr($docErrors); die;
                        $imgArray=json_encode($upload['imgArray']);
                        //pr(json_decode($imgArray)); die;

                        $keyword ='';
                        if(!empty($this->request->data['keywords'])){
                          $keyword = implode(',', $this->request->data['keywords']);
                        }

                        $campaign_keywords ='';
                        if(!empty($this->request->data['campaign_keywords'])){
                          $campaign_keywords = implode(',', $this->request->data['campaign_keywords']);
                        }

                        // Replace $ and , from price format
                        $target_amount= $this->request->data['target_amount']; 
                        $target_amount= str_replace("$","",$target_amount);
                        $target_amount= str_replace(",","",$target_amount);
                        $this->request->data['target_amount']=$target_amount;
                        
                        $campaign->file_path=$imgArray;
                        $campaign->errors=$docErrors;
                        $campaign->user_id=$UserId;
                        $campaign->status = 2; /* Insert status by default 2 for pending*/
                        $campaign->hold = 0; /* Insert hold by default 0*/
                        $this->request->data['keywords'] =$keyword; 
                        $this->request->data['campaign_keywords'] =$campaign_keywords;
                        $campaign = $this->Campaigns->patchEntity($campaign, $this->request->data);
                        //$campaign->keywords =$keyword; 
                        $campaign->fund_raised_so_far=0;
                        $campaign->campaign_image=$campaignImgName['imgName'];


                        // Custom date format for due date compare
                        $time = strtotime($this->request->data['due_date']);
                        $newformat = date('Y-m-d',$time);
                        $campaign->comp_due_date=$newformat;

                        $result = $this->Campaigns->save($campaign);
                        if ($result) {
                            $lastId = $result->id;
                            
                            //Save Feeds
                            $this->Feeds->saveCampaignFeeds($UserId,'feeds_campaign_added',$result->id);

                            $lastId = base64_encode($lastId);

                            $view = base64_encode('first');

                            $this->Flash->success('The campaign has been saved successfully.');
                            if(!empty($docErrorsCount)){
                                $this->redirect(['action' => 'edit',$lastId,$view]);
                            }else {

                                $this->redirect(['action' => 'index']);
                            }    

                        } else {
                            $this->Flash->error('The campaign could not be saved. Please, try again.');
                        }
                    }
                    //$users = $this->Campaigns->Users->find('list', ['limit' => 200]);
                    $users=$UserId;
                    $startups = $this->Campaigns->Startups->find('list',['conditions' => ['Startups.user_id' => $UserId]]);
                    $this->set(compact('campaign', 'users', 'startups'));
                    $this->set('_serialize', ['campaign']);
             }       
    }

    /**
     * Edit method
     *
     * @param string|null $id Campaign id.
     * @return void Redirects on successful edit, renders view otherwise.
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function edit($id = null, $view = null)
    {  
        $editView=$view;
        $id = base64_decode($id);
        $cDonId =$id;
        $userId = $this->Auth->user('id');
        $campaign = $this->Campaigns->get($id,[
            'conditions' => ['Campaigns.user_id' => $userId]], [
            'contain' => []
        ]);


        $Keywords = $this->Campaigns->CampaignTargetKeywords->find('list')->toArray();
        $this->set('Keywords',$Keywords);
        
        $this->loadModel('KeywordCampaigns');
        $campKeywords = $this->KeywordCampaigns->find('list')->toArray();
        $this->set('campKeywords',$campKeywords);

        //Get donated contractor list
        $donContractor = $this->Campaigns->CampaignDonations->find('all',['conditions' => ['CampaignDonations.campaign_id' => $id]])->contain(['Campaigns','DonationTimeperiods','Users'])->toArray();
        $this->set('donContractors', $donContractor);

        // get saved array data
        $savedImg = json_decode($campaign->file_path);
        $savedImgCount = count($savedImg);
        if(!empty($savedImgCount)){
            $savedImgArray='';
            for ($j=0; $j<$savedImgCount; $j++){
                $savedImgArray[]=array(
                                        'name' => $savedImg[$j]->name,
                                        'file_type' => $savedImg[$j]->file_type,                                 
                                );
            }
        }   
        $savedCampImage=$campaign->campaign_image; 
        //pr($savedImgArray);
        if ($this->request->is(['patch', 'post', 'put'])) {

             //Upload Campaign Image 
              $campaignImg = $this->request->data['campaign_image'];
              $campaignImgName = $this->Multiupload->campaignImage($campaignImg);
              
              if(!empty($campaignImgName['imgName'])){
                    $savedCampImage=$campaignImgName['imgName'];
              }
             //Upload doc for Campaign
               $files = $this->request->data['files']; 
               $files['file_type'] = $this->request->data['file_type'];

               $upload = $this->Multiupload->Multiupload($files);//call upload component to file Upload

               $imgArray=$upload['imgArray'];
               $imgArrayCount=count($imgArray);
               // Count erros during upload
                        $a1[]=$campaignImgName['errors'];
                        $a2= $upload['errors'];
                        $b=  array_merge($a1,$a2);   
                        $docErrors=json_encode($b); //pr($b);die;
                        $docErrorsCount= count($b);

               //$docErrors=json_encode($upload['errors']);
               //$docErrorsCount= count($upload['errors']);

               //Push New document array to previus saved array list
               if(!empty($savedImgCount)){
                   for($k=0; $k<$imgArrayCount; $k++){
                        array_push($savedImgArray, $imgArray[$k]);
                   }
               
                $finalSaveImg=$savedImgArray;
                $finalSaveImg=json_encode($finalSaveImg);
                }else {

                  $finalSaveImg=json_encode($imgArray);  
                }

              $keyword ='';
              if(!empty($this->request->data['keywords'])){
                  $keyword = implode(',', $this->request->data['keywords']);
              }  

              $campaign_keywords ='';
              if(!empty($this->request->data['campaign_keywords'])){
                    $campaign_keywords = implode(',', $this->request->data['campaign_keywords']);
              }  

              // Replace $ and , from price format
                        $target_amount= $this->request->data['target_amount']; 
                        $target_amount= str_replace("$","",$target_amount);
                        $target_amount= str_replace(",","",$target_amount);
                        $this->request->data['target_amount']=$target_amount;
                        
            $campaign->file_path=$finalSaveImg;
            $campaign->errors=$docErrors;
            $campaign->user_id=$userId;
            $this->request->data['keywords'] =$keyword;
            $this->request->data['campaign_keywords'] =$campaign_keywords;
            $campaign = $this->Campaigns->patchEntity($campaign, $this->request->data);
            //$campaign->keywords =$keyword; 
            $campaign->fund_raised_so_far =0;
            $campaign->campaign_image=$savedCampImage;

            // Custom date format for due date compare
            $time = strtotime($this->request->data['due_date']);
            $newformat = date('Y-m-d',$time);
            $campaign->comp_due_date=$newformat;

            if ($this->Campaigns->save($campaign)) {
                $cId = base64_encode($id);
                $view = base64_encode('editview');
                if(!empty($docErrorsCount)){
                    $this->Flash->success('Campaign Updated Successfully.');
                    $this->redirect(['action' => 'edit',$cId,$view]);
                }else {
                    $this->Flash->success('Campaign Updated Successfully.');
                    $this->redirect(['action' => 'index']);
                } 
            } else {
                $this->Flash->error('The campaign could not be saved. Please, try again.');
            }
        }
        //$users = $this->Campaigns->Users->find('list', ['limit' => 200]);
        $users=$userId;
        $startups = $this->Campaigns->Startups->find('list', ['conditions' => ['Startups.user_id' => $userId]]);
        $donations = $this->Campaigns->CampaignDonations->find('all',['conditions'=>['CampaignDonations.campaign_id'=>$cDonId]])->contain(['Users'])->toArray();
        $this->set(compact('campaign', 'users', 'startups','view','donations'));
        $this->set('userId',$users);
        $this->set('_serialize', ['campaign']);
        //echo $cn= count($donation);
        //pr($donation); die;
        // Update Errors
        $view= base64_decode($view);
            if($view =='first'){
                $this->Campaigns->query()
                ->update()
                ->set(['errors' => ''])
                ->where(['id' => $id])
                ->execute();
            }else {


            }
        // Update Errors
         // Used utf8_decode instead of  base64_decode 
            $editView= base64_decode($editView);
            if($editView =='editview'){
                $this->Campaigns->query()
                ->update()
                ->set(['errors' => ''])
                ->where(['id' => $id])
                ->execute();
            }    
    }

    /**
     * Delete method
     *
     * @param string|null $id Campaign id.
     * @return \Cake\Network\Response|null Redirects to index.
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function delete($id = null)
    {
        $id = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $campaign = $this->Campaigns->get($id);
        if ($this->Campaigns->delete($campaign)) {
            $this->Flash->success('The campaign has been deleted.');
        } else {
            $this->Flash->error('The campaign could not be deleted. Please, try again.');
        }
        return $this->redirect(['action' => 'myCampaign']);
    }


    /**
     * Delete method for Doc delete
     *
     */
    public function deleteDoc($id = null, $index)
    {
      
      //$this->request->allowMethod(['post', 'deleteDoc']);
      $this->viewBuilder()->layout(false);
      $this->render(false);
        $index = base64_decode($index); 
        $id = base64_decode($id);
        $campaign = $this->Campaigns->get($id);
        $imgArray = json_decode($campaign->file_path);
        unset($imgArray[$index]);
        $out = array_values($imgArray);
        $afterUnset= json_encode($out);
        //pr($afterUnset); die;
       $res= $this->Campaigns->query()
                ->update()
                ->set(['file_path' => $afterUnset])
                ->where(['id' => $id])
                ->execute();
            if($res){
                $id= base64_encode($id);
                $this->Flash->success('Deleted successfully.'); 
                //$this->redirect(['action' => 'edit',$id]);
                $this->redirect(['action' => 'edit',$id]);
            }
        }
     
        
       //$this->redirect(['action' => 'edit');
       

        //$this->request->allowMethod(['post', 'delete']);
       /* $campaign = $this->Campaigns->get($id);
        if ($this->Campaigns->delete($campaign)) {
            $this->Flash->success('The campaign has been deleted.');
        } else {
            $this->Flash->error('The campaign could not be deleted. Please, try again.');
        }
        return $this->redirect(['action' => 'index']);*/
    //}


     /*
     *  Follow method for follow campaign
     *
     *
     *
     *
     ***/
     public function followCampaign($id = null)
    {       
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $user = $this->Auth->user();
            if($user){

                    $UserId = $this->request->Session()->read('Auth.User.id');
                    $Id = base64_decode($id);
                    $exists = $this->Campaigns->exists(['id' => $Id, 'user_id !='=>$UserId]);
                    
                    $campDetails = $this->Campaigns->get($Id);
                    $campOwnerId =$campDetails->user_id;
                    $campName =$campDetails->campaigns_name;

                    $follow = $this->Campaigns->newEntity(); 

                    $follow = $this->Campaigns->campaignFollowers->patchEntity($follow, $this->request->data);
                    $follow->campaign_id=$Id;
                    $follow->user_id=$UserId;
                   // $campaign = $this->Campaigns->get($Id);
                    if(!empty($exists)){
                       $result = $this->Campaigns->campaignFollowers->save($follow);
                        if ($result) {

                            //Save Feeds
                            $this->Feeds->saveCampaignFeeds($UserId,'feeds_campaign_following',$Id);

                            //Save user notification
                            //$values = [];
                            $values = ['campaign_id'=>$Id,'campaign_name'=>$campName];
                            //,json_encode((object)$values)
                            $link= Router::url(['controller' => 'Campaigns', 'action' => 'view',$id]);

                            $this->WebNotification->sendNotification($UserId,$campOwnerId,'Follow_Campaign','has started following your campaign <strong>'.$campName.'</strong>',$link,$values);

                             $this->redirect(['action' => 'view',$id]);
                             $this->Flash->success('Campaign has been followed.'); 
   
                        }
                    }else {
                        $this->redirect(['action' => 'view',$id]);
                        $this->Flash->error('There is some problem can not follow Campaign now.');
                    }
            }       
    }

    /*
     *  unfollowCampaign method for unfollowCampaign campaign
     *
     *
     *
     *
     ***/
    public function unfollowCampaign($id = null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $user = $this->Auth->user();
            if($user){

                    $UserId = $this->request->Session()->read('Auth.User.id');  
                    $Id = base64_decode($id);
                    $exists = $this->Campaigns->campaignFollowers->exists(['campaign_id' => $Id, 'user_id'=>$UserId]);
                    $campDetails = $this->Campaigns->get($Id);
                    $campOwnerId =$campDetails->user_id;
                    $campName =$campDetails->campaigns_name;

                    if(!empty($exists)){
                        $query = $this->Campaigns->campaignFollowers->query();
                        $query->delete()
                            ->where(['campaign_id' => $Id, 'user_id'=>$UserId])
                            ->execute();

                            //Save user notification
                            //$values = [];
                            $values = ['campaign_id'=>$Id,'campaign_name'=>$campName];
                            //,json_encode($values);
                            $link= Router::url(['controller' => 'Campaigns', 'action' => 'view',$id]);
                            $this->WebNotification->sendNotification($UserId,$campOwnerId,'UnFollow_Campaign','has un-followed your campaign <strong>'.$campName.'.</strong>',$link,$values);

                            $this->redirect(['action' => 'view',$id]);
                            $this->Flash->success(' Campaign has been unfollowed.'); 
            
                    }else{
                        $this->redirect(['action' => 'view',$id]);
                        $this->Flash->error('There is some problem can not unfollow Campaign now.');   
                    }
            }        

    }


    /**
     * Delete method
     *
     *
     */
    public function deleteDonation($id = null)
    {
        $donId = base64_decode($id);
        $this->loadModel('CampaignDonations');
        
        //$this->request->allowMethod(['deleteDonation']);
        $CampaignDonations = $this->CampaignDonations->get($donId);
        $amount=$CampaignDonations->amount; 

        $UserId = $this->request->Session()->read('Auth.User.id');
        $dnatorId= $CampaignDonations->user_id;

        $cId= base64_encode($CampaignDonations->campaign_id);
        $campId=$CampaignDonations->campaign_id;

        $campDetails = $this->Campaigns->get($CampaignDonations->campaign_id);
        $campName =$campDetails->campaigns_name;

        $fund_raised_so_far =$campDetails->fund_raised_so_far;

        if($this->CampaignDonations->delete($CampaignDonations)) {

            $final_raised = $fund_raised_so_far - $amount;
                    $this->loadModel('Campaigns');
                    $query = $this->Campaigns->query();

                    $query->update()
                            ->set(['fund_raised_so_far'=>$final_raised
                                   ])
                            ->where(['id' => $campId])
                            ->execute();

            // Save Notification
            $values = [];
            //,json_encode($values);
            $link= Router::url(['controller' => 'Campaigns', 'action' => 'view',$cId]);
            $this->WebNotification->sendNotification($UserId,$dnatorId,'Delete_Commit','has rejected your commitment to Campaign <strong> '.$campName.'</strong>',$link,$values);

            $this->Flash->success('Commited amount has been deleted successfully.');

        } else {

            $this->Flash->error('Commited amount could not be deleted. Please, try again.');

        }

        return $this->redirect($this->referer());
    }


}
