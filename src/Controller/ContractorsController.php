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
* Users Controller
*
*@property\App\Model\Table\Users table $users
*
*
**/ 
class ContractorsController extends AppController
{   
    public function beforeFilter(\Cake\Event\Event $event)
    {
         $this->Auth->allow(['viewLeanRoadmaps','viewLeanRoadmapApps','ventureCapitalApps','roadmapTemplateApps','gettingStarted','news','dashboard']);
    }
    public $helpers = ['Custom'];

    public function initialize()
    {
        parent::initialize();
        $this->loadComponent('Upload');
        $this->loadComponent('UserImageWeb');
        $this->loadComponent('WebNotification');
        $this->loadComponent('Contractor');
        $this->loadComponent('Feeds');
        $this->loadComponent('FeedUpload');
    }

    public function index(){
        if ($this->Auth->user()) {
           $this->redirect('/contractors/dashboard');
       }
   }

   /****
    *
    *  Dashboard Method
    *
    *
    *
    *******/
   public function dashboard()
   {
          $this->loadModel('Blocks');
          $this->loadModel('TopSliders');
          $this->loadModel('BottomSliders');
          $this->loadModel('VideoLinks');
          $UserId = $this->request->Session()->read('Auth.User.id');
          $widthClass ='';
          if(empty($UserId)){
            $widthClass ='notLogged';
          }
          $this->set('widthClass',$widthClass);
          $this->set('UserId',$UserId);    
          
              if($this->Auth->user('role_id')==3):
                  $this->redirect(['controller'=>'SubAdmins','action'=>'dashboard']);
              endif;
                      
              $Blocks = $this->Blocks->find('all');
              $this->set('BlocksData',$Blocks->toArray());
              
              $TopSliders = $this->TopSliders->find('all');
              $this->set('TopSlidersData',$TopSliders->toArray());
              
              $BottomSliders = $this->BottomSliders->find('all');
              $this->set('BottomSlidersData',$BottomSliders->toArray());
              
              $videoLink = $this->VideoLinks->find('all')->first();
              $this->set('videoLink',$videoLink->toArray());


   }

   /****
    *
    *  gettingStarted Method
    *
    *
    *
    *******/
  public function gettingStarted()
  {
        $UserId = $this->request->Session()->read('Auth.User.id');
        $widthClass ='';
        if(empty($UserId)){
          $widthClass ='notLogged';
        }
        $this->set('widthClass',$widthClass);
        $this->set('UserId',$UserId);   
  }

  /****
    *
    *  gettingStartedVideo Method
    *
    *
    *
    *******/
  public function gettingStartedVideo()
  {

  }

  /****
    *
    *  Accredited Investor
    *
    *
    *
    *******/
  public function accreditedInvestor()
  {

  }

  /****
    *
    *  entrepreneurVideo Investor
    *
    *
    *
    *******/
  public function entrepreneurVideo()
  {

  }

  /****
    *
    *  contractorVideo Investor
    *
    *
    *
    *******/
  public function contractorVideo()
  {

  }

  /****
    *
    *  Lean Roadmap Method
    *
    *
    *
    *******/
  public function leanRoadmaps()
  {
          $this->loadModel('RoadmapDynamics');
          $leanRoadmapList= $this->RoadmapDynamics->find('all',['conditions'=>['RoadmapDynamics.status'=>1]])->toArray();
          $this->set('leanRoadmapList',$leanRoadmapList);
  }

  /****
    *
    *  View Lean Roadmap Method
    *
    *
    *
    *******/
  public function viewLeanRoadmaps($id=null)
  {
          $rId= base64_decode($id);
          $this->loadModel('RoadmapDynamics');
          $leanRoadmapList= $this->RoadmapDynamics->find('all',['conditions'=>['RoadmapDynamics.id'=>$rId,'RoadmapDynamics.status'=>1]])->first();
          $this->set('leanRoadmapList',$leanRoadmapList);
  }


   /****
    *
    *  ventureCapital  Method
    *
    *
    *
    *******/
  public function ventureCapital()
  {

  }

  /****
    *
    *  roadmapTemplate  Method
    *
    *
    *
    *******/
  public function roadmapTemplate(){

  }
  /****
    *
    *  roadmapTemplate  Method
    *
    *
    *
    *******/
  public function roadmapTemplateApps(){

  }

  /****
    *
    *  ventureCapitalApps  Method
    *
    *
    *
    *******/
  public function ventureCapitalApps()
  {
        
  }

  /****
    *
    *  referFriends  Method
    *
    *
    *
    *******/
  public function referFriends()
  {
        $UserId = $this->request->Session()->read('Auth.User.id');
        $this->loadModel('Users');
        $users = $this->Users->find('all',['conditions'=>['Users.id'=>$UserId]])->first();
        $this->set('users', $users); 

        $this->loadModel('Messages');
        $Messages = $this->Messages->newEntity();
        $this->set('Messages', $Messages);

        if($this->request->is('post')){
          $flag=1;
          $from=$users->email;
          $name=$users->first_name;
          $to= $this->request->data['to'];
          $subject=$this->request->data['subject'];
          $comment=$this->request->data['comment'];

          $parts = explode("@", $to);
          $username = ucfirst($parts[0]);

          if (!filter_var($to, FILTER_VALIDATE_EMAIL)) {
              $flag=0;
              $this->Flash->error(__('Invalid email or email can not be left empty'));

          }

          if (!preg_match("/^[a-zA-Z0-9. ]+$/i", trim($subject))) {
            $flag=0;
            $this->Flash->error(__('Subject has invalid characters'));
          }

          if (empty($comment)) {
            $flag=0;
            $this->Flash->error(__('Message can not be left empty.'));
          }


          if($flag==1){
            $finalComment =str_replace('$friend',$username,$comment);

            $email = new Email();
            $headers=['replyTo'=>$from,'returnPath'=>$from,'cc'=>'','bcc'=>''];      
            $result= $email->template('refer')
                        ->to($to)
                        ->subject($subject) 
                        ->emailFormat('html')
                        ->from([$from => $name])
                        ->viewVars(['comment' => $finalComment])
                        ->setHeaders($headers)                  
                        ->send();
            $this->Flash->success('Refer link has been sent successfully.');            
          }              
        }
  }

  /****
    *
    *  View Lean Roadmap Apps Method
    *
    *
    *
    *******/
  public function viewLeanRoadmapApps($id=null)
  {
          $rId= base64_decode($id);
          $this->loadModel('RoadmapDynamics');
          $leanRoadmapList= $this->RoadmapDynamics->find('all',['conditions'=>['RoadmapDynamics.id'=>$rId,'RoadmapDynamics.status'=>1]])->first();
          $this->set('leanRoadmapList',$leanRoadmapList);
  }


    /**
    * MyProfile Method for Basic Profile edit
    *
    *
    */
    public function MyProfile()
    {       
       $this->loadModel('Users');
       $this->loadModel('ContractorBasics');
       $this->loadModel('Countries');
       $this->loadModel('States');
       $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

       $userEmail=$user['email'];
       $this->set('userEmail',$userEmail);
       if($user){
        $UserId = $this->request->Session()->read('Auth.User.id');

        $country_list = $this->Countries->find('list')->toArray();
        $this->set('countrylist',$country_list);

                    /// Get Rating
        $ratingStar= $this->getRating($UserId);
        $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
        $proPercentage= $this->profilePercentage($UserId);
        $this->set('proPercentage',$proPercentage);
                    //pr($proPercentage); die;


        /*To check detail of LoggedIn User in ContractorBasics Table */
        $contractordata = $this->ContractorBasics->find('all', [
            'conditions' => ['ContractorBasics.user_id' => $UserId]])->contain(['Countries','States']);
        $contractordata = $contractordata->first();

        $OldImage ='';
                  if(!empty($contractordata)){
                        //Get user image
                        if(!empty($contractordata['image'])){
                            $OldImage = $contractordata['image']; 
                        }
                        //get state list
                        
                        $state_list = $this->States->find('list',['conditions'=>['States.country_id'=>$contractordata->country_id]])->toArray();
                        $this->set('statelist',$state_list);

                        $contractorID = $contractordata->id;
                        $user = $this->ContractorBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $this->set('dc',$user->country_id);
                        $this->set('ds',$user->state_id);
                        $this->set('user',$user);
                  }else {

                        $userdetail = $this->Users->get($UserId, ['contain' => '']); // Get record from User Table
                        //get state list
                        
                        $this->set('dc',$userdetail->country);
                        $this->set('ds',$userdetail->state);
                        $state_list = $this->States->find('list',['conditions'=>['States.country_id'=>$userdetail->country]])->toArray();
                        $this->set('statelist',$state_list);

                        $this->set('user',$userdetail);
                    }  

                    ///Save Data to tables
                    $user = $this->ContractorBasics->newEntity();
                    $userupdate = $this->ContractorBasics->Users->newEntity();
                    if ($this->request->is(['patch', 'post', 'put'])) {

                        //Upload Image in Contractor Basic Table

                        if(!empty($this->request->data['image']['name'])){ 
                         $data = [];
                         $data = $this->request->data['image'];
                         $data['module_type'] = 'profile_pic';
                               $upload = $this->Upload->Upload($data); //call upload component to image Upload
                               if(!empty($upload) && (!empty($this->request->data['image']['error']) == 0)){
                                $this->request->data['image'] = $upload;
                                if(!empty($OldImage)){
                                      // unlink(WWW_ROOT . 'img/profile_pic/' .$OldImage);
                                }
                            }else{
                                $this->Flash->error('These files extension are allowed: .jpg, .jpeg, .gif, .png');
                                return $this->redirect($this->referer());
                                if(!empty($OldImage)){
                                    $filename =  $OldImage;
                                    $this->request->data['image'] = $filename;
                                }
                            } 
                        }else {
                             //$user->image= $OldImage;
                           $this->request->data['image']= $OldImage;
                       }
                       /*To Check LogIn Id exist in ContractorBasics Table */
                       if(!empty($contractordata)){
                           $user->id = $contractorID;
                       }
                       $user->user_id = $UserId; 
                       $user->email = $userEmail;
                        //$user->phoneno =$this->request->data['phoneno'];
                       $user->date_of_birth =$this->request->data['date_of_birth'];

                       $price= $this->request->data['price']; 
                       $price= str_replace("$","",$price);
                       $price= str_replace(",","",$price);
                       $this->request->data['price']=$price;

                        /*$phn1=$this->request->data['phoneno1'];
                        $phn2=$this->request->data['phoneno2'];
                        $phn3=$this->request->data['phoneno3'];

                        //if(!empty($phn1) && !empty($phn2) && !empty($phn3)){
                        if(!empty($phn1)){
                          $this->request->data['phoneno']='1 ('.$phn1.') '.$phn2.'-'.$phn3;
                        }else {
                          $this->request->data['phoneno']='';
                      }*/
                       // $user->phoneno = $this->request->data['phoneno']; 
                      $user = $this->ContractorBasics->patchEntity($user, $this->request->data); 

                        //$userupdate = $this->Users->patchEntity($userupdate,['id' =>$UserId]);

                      if ($this->ContractorBasics->save($user)) {

                        $query = $this->Users->query();
                        $query->update()
                        ->set(['state'=>$this->request->data['state_id'],
                           'country'=>$this->request->data['country_id'],
                           'first_name' =>$this->request->data['first_name'],
                           'last_name' =>$this->request->data['last_name'],
                           'phoneno' =>$this->request->data['phoneno'],
                           'date_of_birth' => $this->request->data['date_of_birth']
                           ])
                        ->where(['id' => $UserId])
                        ->execute();

                        //Save user Feeds
                        $this->Feeds->saveProfileFeeds($UserId,'feeds_profile');

                        $this->Flash->success(__('The contractor Details have been saved.'));
                        return $this->redirect($this->referer());

                    }else {
                        $errors = $user->errors();
                        foreach($errors as $key=>$value){
                          foreach($value as $keytwo=>$message){
                                //$errorData[$key] = $message;
                               // $this->Flash->error(__($key.' '.$message));
                            $this->Flash->error(__($message));
                        }
                    }
                            //$this->Flash->error(__('The Contractor could not be saved. Please, try again.'));
                }
            }

        }   
    }

    /*****
    *   followUser Method
    *
    *
    *
    ******/
    public function followUser($Id=null)
    {
        $this->viewBuilder()->layout(false);
        $this->render(false);
        $this->loadModel('userFollowers');


        $UserId = $this->request->Session()->read('Auth.User.id');

        $followId = base64_decode($Id); 


        $this->loadModel('Users');
        $users = $this->Users->find('all',['conditions'=>['Users.id'=>$followId]])->first();
        if(!empty($users)){


            $Followers = $this->userFollowers->newEntity();

            $this->request->data['followed_by']=$UserId;
            $this->request->data['user_id']=$followId;


            $Followers = $this->userFollowers->patchEntity($Followers,$this->request->data);

            if ($this->userFollowers->save($Followers)){


                //Save user notification
                $values = [];
                //json_encode($values);
                $link= Router::url(['controller' => 'Contractors', 'action' => 'myProfile']);
                $this->WebNotification->sendNotification($UserId,$followId,'Profile','has started following <strong> you.</strong>',$link,$values);


                $this->Flash->success(__('Followed user successfully.'));
                return $this->redirect(['action' => 'viewProfile',$Id]);

            }else {
                $this->Flash->error(__('Could not follow now! Please try again.'));
            }

        }else{
            $this->Flash->error(__('Could not follow now! Please try again.'));
        }

    }

    /*****
    *   unFollowUser Method
    *
    *
    *
    ******/
    public function unFollowUser($Id=null)
    {
        $this->viewBuilder()->layout(false);
        $this->render(false);
        $this->loadModel('userFollowers');

        $UserId = $this->request->Session()->read('Auth.User.id');

        $followId = base64_decode($Id); 


        $this->loadModel('Users');
        $users = $this->Users->find('all',['conditions'=>['Users.id'=>$followId]])->first();
        if(!empty($users)){

            $exists = $this->userFollowers->exists(['followed_by' => $UserId, 'user_id'=>$followId]);

            if(!empty($exists)){

                $query = $this->userFollowers->query();
                $query->delete()
                ->where(['followed_by' => $UserId, 'user_id'=>$followId])
                ->execute();   

                //Save user notification
                $values = [];
                //,json_encode($values);
                $link= Router::url(['controller' => 'Contractors', 'action' => 'myProfile']);
                $this->WebNotification->sendNotification($UserId,$followId,'Profile','has unfollowed <strong> you.</strong>',$link,$values);

                $this->Flash->success(__('Unfollowed user successfully.'));

                return $this->redirect(['action' => 'viewProfile',$Id]);


            }else {

                $this->Flash->error(__('Could not unfollow now! Please try again.'));
            }    

        }else{

            $this->Flash->error(__('Could not unfollow now! Please try again.'));
        }

    }

    /**
    * MyProfile Method for Basic Profile edit
    *
    *
    */
    public function viewProfile($id=null,$starupId=null)
    {       
       $this->loadModel('Users');
       $this->loadModel('ContractorBasics');
       $this->loadModel('Countries');
       $this->loadModel('States');
       $this->loadModel('StartupTeams');
       $this->loadModel('Startups');
       $this->loadModel('userFollowers');
       $this->loadModel('userConnections');

       $LoggedUserId = $this->request->Session()->read('Auth.User.id');
       $UserId = $this->request->Session()->read('Auth.User.id');

       $viewUserId = base64_decode($id);
       $validUserId = $this->Users->exists(['id'=>$viewUserId]);
       if($validUserId == 1){

        
        //Set user profile status
        $userProfileStatus = $this->UserImageWeb->getUserProfileStatus($viewUserId);
        if($userProfileStatus == 0){

            $this->Flash->error(__('This user profile is private.'));
            return $this->redirect(['action' => 'viewProfile']);

        }


        $UserId=$viewUserId;
        $this->set('viewUserId', $id);

        //Check user is followed by login user or not
        $followDetails= $this->userFollowers->exists(['followed_by' => $LoggedUserId, 'user_id'=>$viewUserId]);

        if($followDetails==1){
            $this->set('followStatus', '1');
        }else{
            $this->set('followStatus', '0');
        } 


    }else {

        $this->set('viewUserId', '');
        $this->set('followStatus', '0');

    }
    $this->set('startupId', $starupId);


    /// Check if conection request sent to view user or not
    $this->loadModel('userConnections');
    if($LoggedUserId != $viewUserId){

      $connectionListRecvd = $this->userConnections->find('all',['conditions'=>['userConnections.connection_by'=>$viewUserId,'userConnections.connection_to'=>$LoggedUserId]])->first();
      $requestRcvd='';
      $rqstStatus='';
      if(!empty($connectionListRecvd)){
          $requestRcvd=$connectionListRecvd->id;
          $rqstStatus=$connectionListRecvd->status;
      }
      $this->set('requestRcvd', $requestRcvd);


      $requestSent='';
      $connectionListSent = $this->userConnections->find('all',['conditions'=>['userConnections.connection_by'=>$LoggedUserId,'userConnections.connection_to'=>$viewUserId]])->first();
      if(!empty($connectionListSent)){
        $requestSent=$connectionListSent->id;
        $rqstStatus=$connectionListSent->status;
      }
      $this->set('requestSent', $requestSent);
      $this->set('rqstStatus', $rqstStatus);

    }else{

          $this->set('requestRcvd', '');
          $this->set('requestSent', '');
          $this->set('rqstStatus', '');
    }

    //Check startid and user exists in teamTable
    $RatingStarupId = base64_decode($starupId);

    if(!empty($starupId)){
       $startupDetails= $this->Startups->get($RatingStarupId);
       $startUpUserId= $startupDetails->user_id;
       $validHiredUser = $this->StartupTeams->exists(['startup_id' => $RatingStarupId, 'user_id'=>$viewUserId,'approved'=>1]);

        //if($LoggedUserId == $startUpUserId) {
        if($validHiredUser == 1){
            $this->set('RatingStarupId', $starupId);
        }else {
            $this->set('RatingStarupId', '');
        }

    }else {
        $this->set('RatingStarupId', '');
    } 

              $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

             //if logged user and view user id is same
                    if($LoggedUserId == $viewUserId){

                        $this->set('RatingStarupId', '');
                        $this->set('viewUserId', '');
                        $this->set('followStatus', '0');

                    }

                    if($user){

                        $country_list = $this->Countries->find('list')->toArray();
                        $this->set('countrylist',$country_list);

                    /// Get Rating
                        $ratingStar= $this->getRating($UserId);
                        $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
                        $proPercentage= $this->profilePercentage($UserId);
                        $this->set('proPercentage',$proPercentage);
                    //pr($proPercentage); die;


                        /*To check detail of LoggedIn User in ContractorBasics Table */
                        $contractordata = $this->ContractorBasics->find('all', [
                            'conditions' => ['ContractorBasics.user_id' => $UserId]])->contain(['Countries','States']);
                        $contractordata = $contractordata->first();

                        $OldImage ='';
                        if(!empty($contractordata)){
                        //Get user image
                            if(!empty($contractordata['image'])){
                                $OldImage = $contractordata['image']; 
                            }
                        //get state list
                            $this->set('dc','');
                            $this->set('ds','');
                            $state_list = $this->States->find('list',['conditions'=>['States.country_id'=>$contractordata->country_id]])->toArray();
                            $this->set('statelist',$state_list);

                            $contractorID = $contractordata->id;
                        $user = $this->ContractorBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $this->set('user',$user);
                        $userEmail=$user->email;
                    }else {

                        $userdetail = $this->Users->get($UserId, ['contain' => '']); // Get record from User Table
                        //get state list
                        $this->set('dc',$userdetail->country);
                        $this->set('ds',$userdetail->state);
                        $state_list = $this->States->find('list',['conditions'=>['States.country_id'=>$userdetail->country]])->toArray();
                        $this->set('statelist',$state_list);

                        $this->set('user',$userdetail);
                        $userEmail=$userdetail->email;
                    } 
                    
                    $this->set('userEmail',$userEmail); 

                    
                }   
            }


    /**
    *
    * addConnection Method
    *
    *
    ***/
    public function connections()
    {
            $this->paginate = ['limit' => 10];
            $this->loadModel('userConnections');
            $this->loadModel('ContractorBasics');
            $UserId = $this->request->Session()->read('Auth.User.id');

            $this->set('UserId',$UserId);

            $searchKeyword=trim($this->request->query('search'));
            $searchKeyword = str_replace("'","",$searchKeyword);  

            if(!empty($searchKeyword)){
              $connectionLists = $this->ContractorBasics->find('all', 
                                      ['conditions' => 
                                        [ 
                                         'OR' =>[
                                            ['ContractorBasics.first_name LIKE' => '%'.$searchKeyword.'%'],
                                            ['ContractorBasics.last_name LIKE' => '%'.$searchKeyword.'%']
                                            ]
                                        ],           
                                        'fields' => [
                                            'connection_by' => 'user_connections.connection_by',
                                            'connection_to' => 'user_connections.connection_to'
                                        ],
                                        'join' => 
                                          [
                                                  [
                                                    'table' => 'user_connections', 
                                                    'type' => 'inner',
                                                    'conditions' => 
                                                        ['user_connections.status'=>1,
                                                          'OR' => 
                                                          [ 
                                                              [
                                                              'ContractorBasics.user_id = user_connections.connection_by',
                                                              'user_connections.connection_to'=>$UserId
                                                              ],

                                                              [
                                                              'ContractorBasics.user_id = user_connections.connection_to',
                                                              'user_connections.connection_by'=>$UserId
                                                              ]
                                                          ]   
                                                        ]
                                                ]
                                          ],
                                      ]);
                
                $this->set('connectionLists', $this->paginate($connectionLists));

                ///pr($connectionLists->toArray()); die;
            
                /*$connection = ConnectionManager::get('default');

                $qq = "SELECT CB.user_id, CB.first_name FROM contractor_basics AS CB INNER JOIN user_connections AS UC ON CB.user_id = UC.connection_by or CB.user_id = UC.connection_to WHERE (CB.first_name LIKE '%".$searchKeyword."%' or CB.last_name LIKE '%".$searchKeyword."%') and CB.user_id!=".$UserId;*/

            }else{    

            $connectionLists = $this->userConnections->find('all',
                                                      ['conditions'=>
                                                        ['userConnections.status'=>1,
                                                        'OR'=>[
                                                                ['userConnections.connection_by'=>$UserId],
                                                                ['userConnections.connection_to'=>$UserId]
                                                              ]  
                                                        ]
                                                      ]);

            $this->set('connectionLists', $this->paginate($connectionLists));
          }

    } 

    /**
    *
    * myMessages Method
    *
    *
    ***/
    public function myMessages()
    {
            $this->loadModel('Messages');
            $this->paginate = [ 'limit' => 10];

            $user = $this->Auth->user();    
            $UserId = $this->request->Session()->read('Auth.User.id');
            if($user){  

                $MessagesDetails = $this->Messages->find('all',['conditions'=>['Messages.receiver_id'=> $UserId,'Messages.archived '=>0,'Messages.msg_type'=>'connection'], 'order'=>['Messages.id DESC']])->contain(['Users'=>['EntrepreneurBasics']]);

                $this->set('MessagesDetails', $this->paginate($MessagesDetails));  
            }

    } 

    /**
    * deleteMessage Method for list messages
    *
    *
    */
    public function deleteMessage($id = null)
    {
        $this->loadModel('Messages');
        $MsgId = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $Messages = $this->Messages->get($MsgId);
        if ($Messages) {
            $query = $this->Messages->query();
            $query->update()
                  ->set(['archived'=>2])
                  ->where(['id' => $MsgId])
                  ->execute();

            $this->Flash->success(__('Message has been deleted successfully.'));
        } else {
            $this->Flash->error(__('Message could not be deleted. Please, try again.'));
        }
        return $this->redirect(['action' => 'myMessages']);
    }

    /**
    * archiveMessage Method for list messages
    *
    *
    */

    public function archiveMessage($id = null)
    {
        $this->loadModel('Messages');
        $MsgId = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $Messages = $this->Messages->get($MsgId);
        if ($Messages) {
            $query = $this->Messages->query();
            $query->update()
                  ->set(['archived'=>1])
                  ->where(['id' => $MsgId])
                  ->execute();

            $this->Flash->success(__('Message has been archived successfully.'));
        } else {
            $this->Flash->error(__('Message could not be archived. Please, try again.'));
        }
        return $this->redirect(['action' => 'myMessages']);
    } 

    /**
    *
    * myMessages Method
    *
    *
    ***/
    public function sendMessage($id=null)
    {
            $this->loadModel('userConnections');
            $this->loadModel('Messages');

            $UserId = $this->request->Session()->read('Auth.User.id');
            $receiverId = base64_decode($id);
            $this->set('receiverId', $id);

            $this->loadModel('Users');
            $users = $this->Users->find('all',['conditions'=>['Users.id'=>$receiverId]])->first();
            $this->set('users', $users);


            //Check user has connection or not
            $this->loadModel('userConnections');
            $connectionLists = $this->userConnections->find('all',
                                                      ['conditions'=>
                                                        ['userConnections.status'=>1,
                                                          'OR'=>
                                                            [
                                                              ['userConnections.connection_by'=>$UserId,
                                                              'userConnections.connection_to'=>$receiverId
                                                              ],
                                                              ['userConnections.connection_by'=>$receiverId,
                                                              'userConnections.connection_to'=>$UserId
                                                              ]
                                                            ]
                                                        ]
                                                      ])->first();

          if(empty($connectionLists)){
            return $this->redirect(['action' => 'connections']);
          }

            $this->loadModel('Messages');
            $Messages = $this->Messages->newEntity();

            if($this->request->is('post')){
                    $this->request->data['sender_id']=$UserId;
                    $this->request->data['receiver_id']=$receiverId;
                    $this->request->data['receiver_email']=$users->email;
                    $this->request->data['msg_type']='connection';
                    //$this->request->data['sender_role_id']=$roleId;
                   // $this->request->data['read']=0;

                    $Messages = $this->Messages->patchEntity($Messages,$this->request->data);
                    if ($this->Messages->save($Messages)){

                        //Save Notification to database
                        $values = [];
                       //,json_encode($values);
                        $link= Router::url(['controller' => 'Contractors', 'action' => 'myMessages']);

                        $this->WebNotification->sendNotification($UserId,$receiverId,'Message','has sent you a <strong> message.</strong>',$link,$values);
                        
                        $this->Flash->success('Message has been sent successfully.');

                        return $this->redirect(['action' => 'connections']);

                    }else {
                        $this->Flash->error('Could not send message! Please try again.');
                    }

            }


            $this->set('Messages', $Messages);


    }


    /**
    *
    * addConnection Method
    *
    *
    ***/
    public function addConnection($Id)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('userConnections');


            $UserId = $this->request->Session()->read('Auth.User.id');

            $connectionUserId = base64_decode($Id); 


            $this->loadModel('Users');
            $users = $this->Users->find('all',['conditions'=>['Users.id'=>$connectionUserId]])->first();
            if(!empty($users)){


                $connections = $this->userConnections->newEntity();

                $this->request->data['connection_by']=$UserId;
                $this->request->data['connection_to']=$connectionUserId;

                //Check is user added you to your connection list
                $connectionList = $this->userConnections->find('all',['conditions'=>['userConnections.connection_by'=>$UserId,'userConnections.connection_to'=>$connectionUserId]])->first();
                //pr($connectionList); die;

                $connectionId='';
                if(!empty($connectionList)){
                  $connectionId=$connectionList->id;
                }else{
                  $connectionList = $this->userConnections->find('all',['conditions'=>['userConnections.connection_by'=>$connectionUserId,'userConnections.connection_to'=>$UserId]])->first();
                  
                  if(!empty($connectionList)){
                    $connectionId=$connectionList->id;
                  }
                }

                $connections = $this->userConnections->patchEntity($connections,$this->request->data);
                if(!empty($connectionId)){
                  $connections->id=$connectionId;
                }

                $saveResult= $this->userConnections->save($connections);
                if ($saveResult){

                  $lastInsertId =$saveResult->id; 

                  //Save user notification
                  // $values = [];
                    $values = ['user_id'=>$UserId,'connection_id'=>$lastInsertId,'status'=>0];
                    //json_encode($values);
                    $link= Router::url(['controller' => 'Contractors', 'action' => 'viewProfile',base64_encode($UserId)]);

                    $this->WebNotification->sendNotification($UserId,$connectionUserId,'Add_Connection','wants to connect with <strong> you.</strong>',$link,$values);


                    $this->Flash->success(__('Connection request sent successfully.'));
                    return $this->redirect(['action' => 'viewProfile',$Id]);

                }else {
                    $this->Flash->error(__('Could not send connection request now! Please try again.'));
                }

            }else{
                $this->Flash->error(__('Could not send connection request now! Please try again.'));
            }

    }


    /**
    * acceptConnection Method
    *
    *
    ***/
    public function acceptConnection($Id)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('userConnections');


            $UserId = $this->request->Session()->read('Auth.User.id');

            $connectionId = base64_decode($Id); 

            $userConnections = $this->userConnections->find('all',['conditions'=>['userConnections.id'=>$connectionId]])->first();

            if(!empty($userConnections)){
              $query = $this->userConnections->query();
                $query->update()
                ->set(['status'=>1])
                ->where(['id'=>$connectionId])
                ->execute();

              //Update Notification
              $this->loadModel('UserNotifications');
              $query2 = $this->UserNotifications->query();
              $query2->update()
              ->set(['status'=>1])
              ->where(['sender_id'=>$userConnections->connection_by,'receiver_id'=>$userConnections->connection_to,'type'=>'Add_Connection'])
              ->execute();  


              //Save user notification
              $values = [];
              //json_encode($values);
              $link= Router::url(['controller' => 'Contractors', 'action' => 'viewProfile',base64_encode($userConnections->connection_to)]);

              $this->WebNotification->sendNotification($userConnections->connection_to,$userConnections->connection_by,'Accepted_Connection','has accepted your connection <strong> request.</strong>',$link,$values); 

             $this->Flash->success(__('Connection accepted successfully.'));   
             return $this->redirect($this->referer());   
            }else{
              $this->Flash->error(__('Could not accept connection request now! Please try again.'));   
              return $this->redirect($this->referer());  
            }    
    } 

    /**
    * acceptConnection Method
    *
    *
    ***/
    public function rejectConnection($Id)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('userConnections');


            $UserId = $this->request->Session()->read('Auth.User.id');

            $connectionId = base64_decode($Id); 

            $userConnections = $this->userConnections->find('all',['conditions'=>['userConnections.id'=>$connectionId]])->first();

            if(!empty($userConnections)){
              $query = $this->userConnections->query();
                $query->delete()
                ->where(['id'=>$connectionId])
                ->execute();

              //Delete Notfication
              $this->loadModel('UserNotifications');
              $query2 = $this->UserNotifications->query();
              $query2->delete()
              ->where(['sender_id'=>$userConnections->connection_by,'receiver_id'=>$userConnections->connection_to,'type'=>'Add_Connection'])
              ->execute();  

             $this->Flash->success(__('Connection removed successfully.'));   
             return $this->redirect($this->referer());   
            }else{
              $this->Flash->error(__('Could not remove connection request now! Please try again.'));   
              return $this->redirect($this->referer());  
            }    
    }

    /**
    * ProfessionalProfile Method for Professional Profile edit
    *
    *
    */
    public function excellenceAwards($id=null)
    {   
        $this->paginate = [ 'limit' => 10];

        $this->loadModel('WorkorderRatings');
        $this->loadModel('Users');

        $UserId = $this->request->Session()->read('Auth.User.id');
        $viewUserId = base64_decode($id);
        $validUserId = $this->Users->exists(['id'=>$viewUserId]);

        if($validUserId == 1){
            $UserId=$viewUserId;
            $this->set('viewUserId', $id);
        }else {
            $this->set('viewUserId', '');
        }

        $excellenceAwards = $this->WorkorderRatings->find('all',['conditions'=>['WorkorderRatings.given_to'=>$UserId]])->contain(['Users']);

        $this->set('excellenceAwards', $this->paginate($excellenceAwards));

    }


    /**
    * ProfessionalProfile Method for Professional Profile edit
    *
    *
    */
    public function ProfessionalProfile()
    {
        $this->loadModel('Users');
        $this->loadModel('ContractorBasics');  
        $this->loadModel('ContractorProfessionals'); 
        $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

        $Experiences = $this->ContractorProfessionals->Experiences->find('list')->toArray();
        $this->set('Experiences',$Experiences);

        $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
        $this->set('Keywords',$Keywords);

        $Qualifications = $this->ContractorProfessionals->Qualifications->find('list')->toArray();
        $this->set('Qualifications',$Qualifications);

        $Certifications = $this->ContractorProfessionals->Certifications->find('list')->toArray();
        $this->set('Certifications',$Certifications); 

        $Skills = $this->ContractorProfessionals->Skills->find('list')->toArray();
        $this->set('Skills',$Skills);

        $PrefferStartups = $this->ContractorProfessionals->PrefferStartups->find('list')->toArray();
        $this->set('PrefferStartups',$PrefferStartups);

        $ContractorTypes = $this->ContractorProfessionals->ContractorTypes->find('list')->toArray();
        $this->set('ContractorTypes',$ContractorTypes);

        if($user){
            $UserId = $this->request->Session()->read('Auth.User.id');

                    /// Get Rating
            $ratingStar= $this->getRating($UserId);
            $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
            $proPercentage= $this->profilePercentage($UserId);
            $this->set('proPercentage',$proPercentage);

            /*To check detail of LoggedIn User in ContractorBasics Table */
            $contractordata = $this->ContractorBasics->find('all', [
                'conditions' => ['ContractorBasics.user_id' => $UserId]])->contain(['Countries','States']);
            $contractordata = $contractordata->first();
            if(!empty($contractordata)){
                        //Get user image
                if(!empty($contractordata['image'])){
                    $OldImage = $contractordata['image']; 
                    $OldPrice = $contractordata['price'];
                }

                $contractorID = $contractordata->id;
                        $user = $this->ContractorBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $this->set('user',$user);
            }else {
                        $OldImage='';
                        $OldPrice ='';
                        $userdetail = $this->Users->get($UserId, ['contain' => '']); // Get record from User Table
                        $this->set('user',$userdetail);
            } 


                    /// Professional body Content
                    $professional_user = $this->ContractorProfessionals->newEntity();

                    $professional_detail = $this->ContractorProfessionals->find('all',['conditions'=>['ContractorProfessionals.user_id'=> $UserId]])->select('id','user_id');
                    $professional_detail = $professional_detail->first();

                    if(!empty( $professional_detail)){
                        $profession_id =  $professional_detail->id;
                        $professional_user =  $this->ContractorProfessionals->get($profession_id,['contain'=>'Experiences']);
                        $this->set('professional_user',$professional_user);
                    }

                    //Save data to contractor professiona Table
                    if($this->request->is(['patch','post','put'])){
                        if(!empty($professional_detail)){
                            $professional_user->id = $profession_id;/*To Check LogIn Id exist in ContractorProfessionals Table */
                        }
                        // Make Comma seprated ids
                        $qualification='';
                        if(!empty($this->request->data['qualifications'])){
                          $qualification = implode(',', $this->request->data['qualifications']);
                      }
                      $skill ='';
                      if(!empty($this->request->data['skills'])){
                          $skill = implode(',', $this->request->data['skills']);
                      }
                      $certification ='';
                      if(!empty($this->request->data['certifications'])){
                          $certification = implode(',', $this->request->data['certifications']);
                      }
                      $keyword ='';
                      if(!empty($this->request->data['keywords'])){
                          $keyword = implode(',', $this->request->data['keywords']);
                      }

                      $startup_stage ='';
                      if(!empty($this->request->data['startup_stage'])){
                          $startup_stage = implode(',', $this->request->data['startup_stage']);
                      }


                      $this->ContractorProfessionals->patchEntity($professional_user, $this->request->data); 

                        //Patch comma seprated ids
                      $professional_user->qualifications =$qualification;
                      $professional_user->skills =$skill;
                      $professional_user->certifications =$certification;
                      $professional_user->keywords =$keyword;
                      $professional_user->user_id = $UserId;
                      $professional_user->startup_stage=$startup_stage;


                        //Upload Image in Contractor Basic Table
                      if(!empty($this->request->data['image']['name'])){
                         $data = [];
                         $data = $this->request->data['image'];
                         $data['module_type'] = 'profile_pic';
                                       $upload = $this->Upload->Upload($data);  //call upload component to image Upload
                                       if(!empty($upload) && (!empty($this->request->data['image']['error']) == 0)){
                                        $professional_user->image = $upload;
                                        if(!empty($OldImage)){
                                              // unlink(WWW_ROOT . 'img/profile_pic/' .$OldImage);
                                        }
                                    }else{
                                      $this->Flash->error('These files extension are allowed: .jpg, .jpeg, .gif, .png');
                                      return $this->redirect($this->referer());
                                      if(!empty($OldImage)){
                                        $filename =  $OldImage;
                                        $professional_user->image = $filename;
                                    }
                                }
                            }else {
                               if(!empty($OldImage)){
                                $filename =  $OldImage;
                                $professional_user->image = $filename;
                            }else {
                                $professional_user->image='';
                            }
                        } 

                        $price= $this->request->data['price']; 
                        $price= str_replace("$","",$price);
                        $price= str_replace(",","",$price);
                        $this->request->data['price']=$price;         

                        //Update price to contractor basic table  
                        if(!empty($this->request->data['price'])){
                          if (!preg_match("/^[0-9.]+$/i", $this->request->data['price'])) {
                              $this->Flash->error('Invalid Price.');
                              return $this->redirect($this->referer());
                          }
                          $professional_user->price=$this->request->data['price'];
                      }else {
                        $professional_user->price=$OldPrice;
                    }             

                       //pr($professional_user);die;
                    /* Save Professional Details of the user*/
                    if ($this->ContractorProfessionals->save($professional_user)) {
                       $query = $this->ContractorBasics->query();
                       $update= $query->update()
                       ->set(['price'=>$professional_user->price,
                           'image'=>$professional_user->image
                           ])
                       ->where(['user_id' => $UserId])
                       ->execute();

                       if($update){
                        //Save user Feeds
                        $this->Feeds->saveProfileFeeds($UserId,'feeds_profile');
                        
                        $this->Flash->success('Your Professional Detail have been saved.');
                        return $this->redirect($this->referer());
                    }
                }
                else{
                    $this->Flash->error('Your Professional Detail could not be saved.Please,try again.');
                }
            }

            $this->set('professional_user',$professional_user);

        }    


    }


    /**
    * View ProfessionalProfile Method for Professional Profile edit
    *
    *
    */
    public function viewProfessionalProfile($id=null,$starupId = null)
    {
        $viewUserId = base64_decode($id);
        $this->set('viewUserId', $id);

        $this->loadModel('Users');
        $this->loadModel('ContractorBasics');  
        $this->loadModel('ContractorProfessionals'); 
        $this->loadModel('StartupTeams');
        $this->loadModel('userFollowers');
        $this->loadModel('Startups');

        $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

        $LoggedUserId = $this->request->Session()->read('Auth.User.id');
        $UserId = $this->request->Session()->read('Auth.User.id');

        $viewUserId = base64_decode($id);
        $validUserId = $this->Users->exists(['id'=>$viewUserId]);
        if($validUserId == 1){
            $UserId=$viewUserId;
            $this->set('viewUserId', $id);

                    //Check user is followed by login user or not
            $followDetails= $this->userFollowers->exists(['followed_by' => $LoggedUserId, 'user_id'=>$viewUserId]);

            if($followDetails==1){
                $this->set('followStatus', '1');
            }else{
                $this->set('followStatus', '0');
            }


        }else {
            $this->set('followStatus', '0');
            $this->set('viewUserId', '');
        }

        $this->set('startupId', $starupId);


         /// Check if conection request sent to view user or not
    $this->loadModel('userConnections');
    if($LoggedUserId != $viewUserId){

      $connectionListRecvd = $this->userConnections->find('all',['conditions'=>['userConnections.connection_by'=>$viewUserId],'userConnections.connection_to'=>$LoggedUserId])->first();
      $requestRcvd='';
      $rqstStatus='';
      if(!empty($connectionListRecvd)){
          $requestRcvd=$connectionListRecvd->id;
          $rqstStatus=$connectionListRecvd->status;
      }
      $this->set('requestRcvd', $requestRcvd);


      $requestSent='';
      $connectionListSent = $this->userConnections->find('all',['conditions'=>['userConnections.connection_by'=>$LoggedUserId],'userConnections.connection_to'=>$viewUserId])->first();
      if(!empty($connectionListSent)){
        $requestSent=$connectionListSent->id;
        $rqstStatus=$connectionListSent->status;
      }
      $this->set('requestSent', $requestSent);
      $this->set('rqstStatus', $rqstStatus);

    }else{

          $this->set('requestRcvd', '');
          $this->set('requestSent', '');
          $this->set('rqstStatus', '');
    }

             //Check startid and user exists in teamTable
        $RatingStarupId = base64_decode($starupId);

        if(!empty($starupId)){
           $startupDetails= $this->Startups->get($RatingStarupId);
           $startUpUserId= $startupDetails->user_id;
           $validHiredUser = $this->StartupTeams->exists(['startup_id' => $RatingStarupId, 'user_id'=>$viewUserId]);

                     //if($LoggedUserId == $startUpUserId) {
           if($validHiredUser == 1){
            $this->set('RatingStarupId', $starupId);
        }else {
            $this->set('RatingStarupId', '');
        }
                     /*}else {
                        
                            $this->set('RatingStarupId', '');
                         
                        }*/
                    }else {
                        $this->set('RatingStarupId', '');
                    }

             /*$validHiredUser = $this->StartupTeams->exists(['startup_id' => $RatingStarupId, 'user_id'=>$viewUserId]);
             if($validHiredUser == 1){
                $this->set('RatingStarupId', $starupId);
             }else {
                $this->set('RatingStarupId', '');
            }*/

            $Experiences = $this->ContractorProfessionals->Experiences->find('list')->toArray();
            $this->set('Experiences',$Experiences);

            $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $Qualifications = $this->ContractorProfessionals->Qualifications->find('list')->toArray();
            $this->set('Qualifications',$Qualifications);

            $Certifications = $this->ContractorProfessionals->Certifications->find('list')->toArray();
            $this->set('Certifications',$Certifications); 

            $Skills = $this->ContractorProfessionals->Skills->find('list')->toArray();
            $this->set('Skills',$Skills);

            $PrefferStartups = $this->ContractorProfessionals->PrefferStartups->find('list')->toArray();
            $this->set('PrefferStartups',$PrefferStartups);

            $ContractorTypes = $this->ContractorProfessionals->ContractorTypes->find('list')->toArray();
            $this->set('ContractorTypes',$ContractorTypes);

            if($user){


                    /// Get Rating
                $ratingStar= $this->getRating($UserId);
                $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
                $proPercentage= $this->profilePercentage($UserId);
                $this->set('proPercentage',$proPercentage);

                /*To check detail of LoggedIn User in ContractorBasics Table */
                $contractordata = $this->ContractorBasics->find('all', [
                    'conditions' => ['ContractorBasics.user_id' => $UserId]])->contain(['Countries','States']);
                $contractordata = $contractordata->first();
                if(!empty($contractordata)){
                        //Get user image
                    if(!empty($contractordata['image'])){
                        $OldImage = $contractordata['image']; 
                        $OldPrice = $contractordata['price'];
                    }

                    $contractorID = $contractordata->id;
                        $user = $this->ContractorBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $this->set('user',$user);
                    }else {
                        $OldImage='';
                        $OldPrice ='';
                        $userdetail = $this->Users->get($UserId, ['contain' => '']); // Get record from User Table
                        $this->set('user',$userdetail);
                    } 


                    /// Professional body Content
                    $professional_user = $this->ContractorProfessionals->newEntity();

                    $professional_detail = $this->ContractorProfessionals->find('all',['conditions'=>['ContractorProfessionals.user_id'=> $UserId]])->select('id','user_id');
                    $professional_detail = $professional_detail->first();

                    if(!empty( $professional_detail)){
                        $profession_id =  $professional_detail->id;
                        $professional_user =  $this->ContractorProfessionals->get($profession_id,['contain'=>'Experiences']);
                        $this->set('professional_user',$professional_user);
                    }

                    

                    $this->set('professional_user',$professional_user);

                }  


            }


    /****
    *
    *  Get User Star Rating
    *
    *
    *
    *******/
    public function getRating($UserId)
    {
          $this->loadModel('WorkorderRatings');
          $user = $this->Auth->user();
          if($user){
                        //$UserId = $this->request->Session()->read('Auth.User.id');
            $UserId= $UserId;

            $countData = $this->WorkorderRatings->find('all',['conditions'=>['WorkorderRatings.given_to'=> $UserId,'WorkorderRatings.is_entrepreneur'=>1]])->toArray();

            $count= count($countData);
            $ratingData = $this->WorkorderRatings->find('all',['conditions'=>['WorkorderRatings.given_to'=> $UserId,'WorkorderRatings.is_entrepreneur'=>1]]);

            $ratingSum=$ratingData->sumOf('rating_star');
            if(!empty($ratingSum)){
               $finalRating= $ratingSum/$count;
            }else {
              $finalRating=0;
            }

            /// Show star accordig to rating
            @list($int, $parse) = split('[.]', $finalRating);
            $int;
            $parse;
            $star_view='';
            for ($i = 1; $i <= $int; $i++) 
            {
                //$star_view .= '<IMG src="'.$this->request->webroot.'img/star/star.gif">';
                $star_view .='<li><i class="fa fa-star"></i></li>';
            }
            
            // Show half star
            if($parse >0 && $parse <=9 )
            {
                //$star_view .= '<IMG src="'.$this->request->webroot.'img/star/halfstar.gif">';
                $star_view .='<li><i class="fa fa-star-half-empty"></i></li>';
                $dim_star = 9-$int;
            }else{
                $star_view .= "";
                $dim_star = 10-$int;
            }

            $dim_star;
            if($dim_star!="")
            {
                for ($i = 1; $i <= $dim_star; $i++) 
                {
                  //$star_view .= '<IMG src="'.$this->request->webroot.'img/star/dimstar.gif">';
                  $star_view .='<li><i class="fa fa-star-o"></i></li>';
                }
            }

            $ratingData= $star_view;

          }  

          return $ratingData;    
    }

    /****
    *
    *  Get Profile Percentage
    *
    *
    *
    *******/
    public function profilePercentage($UserId)
    {
      $this->loadModel('ContractorBasics');
      $this->loadModel('ContractorProfessionals');

      $user = $this->Auth->user();
      if($user){
                    //$UserId = $this->request->Session()->read('Auth.User.id');
        $UserId= $UserId;
        $contMaxPoints = 100;
        $ContPoint = 0;

                    /// Contractor Basics percentage
        $contractordata = $this->ContractorBasics->find('all', [
            'conditions' => ['ContractorBasics.user_id' => $UserId]]);
        $contractordata = $contractordata->first();
        if(!empty( $contractordata)){
            if(!empty($contractordata->price)) $ContPoint+=20;
            if(!empty($contractordata->image)) $ContPoint+=20;
            if(!empty($contractordata->bio)) $ContPoint+=20;
            if(!empty($contractordata->first_name)) $ContPoint+=20;
            if(!empty($contractordata->last_name)) $ContPoint+=20;
            if(!empty($contractordata->date_of_birth)) $ContPoint+=20;
            if(!empty($contractordata->country_id)) $ContPoint+=20;
            if(!empty($contractordata->state_id)) $ContPoint+=20;
        }
        $contractorPercentage = ($ContPoint*$contMaxPoints)/160;
                    //echo $contractorPercentage."%"; 


                    /// Contractor Professional percentage
        $contractorProfessional = $this->ContractorProfessionals->find('all',['conditions'=>['ContractorProfessionals.user_id'=> $UserId]]);
        $contractorProfessional = $contractorProfessional->first();

        $proMaxPoints = 100;
        $proPoint = 0;
        if(!empty( $contractorProfessional)){
            if(!empty($contractorProfessional->experience_id)) $proPoint+=20;
            if(!empty($contractorProfessional->keywords)) $proPoint+=20;
            if(!empty($contractorProfessional->qualifications)) $proPoint+=20;
            if(!empty($contractorProfessional->certifications)) $proPoint+=20;
            if(!empty($contractorProfessional->skills)) $proPoint+=20;
            if(!empty($contractorProfessional->startup_stage)) $proPoint+=20;
            if(!empty($contractorProfessional->contributor_type)) $proPoint+=20;
            if(!empty($contractorProfessional->accredited_investor)) $proPoint+=20;
        }  
        $contractorProfePercentage = ($proPoint*$proMaxPoints)/160;
                    //echo $contractorProfePercentage."%";
        $finalPercentageContractor=($contractorPercentage+$contractorProfePercentage)/2;


        /*  Over all profile percentage */
        $overallPercentage= number_format((float)$finalPercentageContractor, 0, '.', ''); 

    }

    return $overallPercentage;     

    }



    /**
    *   Settings for Contractor
    *
    *
    ***/
    public function Settings()
    {       
        //$this->loadModel('ContractorSettings');
        $this->loadModel('Settings');
        $this->loadModel('BetaSignups');
        $user = $this->Auth->user();
        $UserId = $this->request->Session()->read('Auth.User.id');

        $betaSignuplists= $this->BetaSignups->find('all',['conditions'=>['BetaSignups.user_id =' => $UserId]]);
        $TotalItems=$betaSignuplists->count();
        //if empty save admin set default settings
        if(empty($TotalItems))
        { 
          $this->loadModel('AdminBetaSignupSettings');
          $adminSignupDeafultSetting= $this->AdminBetaSignupSettings->find('all');

          foreach ($adminSignupDeafultSetting as $key => $value)
          {
              $settingdDefault= $this->BetaSignups->newEntity();

              $settingdDefault->user_id = $UserId;
              $settingdDefault->type = $value->type;
              $settingdDefault->status = $value->status;
              
              $this->BetaSignups->save($settingdDefault);
          }

        }


        if($user){
            
            $user = $this->Settings->newEntity();

            // Get user saved settings
            $settingdata = $this->Settings->find('all', [
                'conditions' => ['Settings.user_id' => $UserId]]);
            $settingdata = $settingdata->first();

            if(!empty($settingdata)){
             $settingdataId =$settingdata->id;
             $settingData =  $this->Settings->get($settingdataId);

             $this->set('settingData',$settingData); 

        }else {$this->set('settingData',''); }

        //Get beta signup users list
        $betaSignuplists= $this->BetaSignups->find('all',['conditions'=>['BetaSignups.user_id =' => $UserId,'BetaSignups.status'=>1]])->toArray();
        $this->set('betaSignuplists',$betaSignuplists);

         if($this->request->is(['patch','post','put'])){

            $user = $this->Settings->patchEntity($user, $this->request->data); 
            $user->user_id =$UserId;

                    // Update id
            if(!empty($settingdata)){
               $user->id = $settingdataId;
           }

           if ($this->Settings->save($user)) {

            $this->Flash->success('Your settings have been saved.');
            return $this->redirect($this->referer());
        }
    }
    $this->set('user',$user);
  }        
}

    /**
    *   Ajax for Contractor
    *
    *
    ***/
    public function ajaxSettings()
    {  
            $this->viewBuilder()->layout(false);
            $this->render(false);

            $this->loadModel('BetaSignups');
            $this->loadModel('Settings');

            if($this->request->is('post'))
            {
              $user_id= $this->request->Session()->read('Auth.User.id');
              $this->request->data['user_id']=$user_id;
              $type= $this->request->data['type'];
              $status= $this->request->data['status'];

              if($type == 'public_profile'){

                  $this->request->data['public_profile']=$this->request->data['status'];
                  $settingdata = $this->Settings->find('all',['conditions' => ['Settings.user_id' => $user_id]])->first();

                  $user = $this->Settings->newEntity();
                  $user = $this->Settings->patchEntity($user, $this->request->data); 
                  $user->user_id =$user_id;

                  if(!empty($settingdata)){
                    $user->id = $settingdata->id;
                  }

                  if ($this->Settings->save($user)) {
                      echo 'Your settings have been saved.';
                  }
              }else{

                  if(!empty($status)){

                      $registerBeta = $this->BetaSignups->newEntity(); 
                      $registerBeta = $this->BetaSignups->patchEntity($registerBeta, $this->request->data);

                      $betaExists= $this->BetaSignups->find('all',['conditions'=>['user_id'=>$user_id,'type' => $type]])->first();
                      
                      if(!empty($betaExists)){
                        $registerBeta->id=$betaExists->id;
                      }
                      $saveResult = $this->BetaSignups->save($registerBeta); 

                      if($saveResult){
                        echo 'Registered successfully.';
                      }else{
                         echo 'Could not register please try again.';
                      } 

                  }else{

                      $registerBeta = $this->BetaSignups->newEntity(); 
                      $registerBeta = $this->BetaSignups->patchEntity($registerBeta, $this->request->data);

                      $betaExists= $this->BetaSignups->find('all',['conditions'=>['user_id'=>$user_id,'type' => $type]])->first();
                      
                      if(!empty($betaExists)){
                        $registerBeta->id=$betaExists->id;
                      }
                      $saveResult = $this->BetaSignups->save($registerBeta); 
                      if($saveResult){
                        echo'Unregistered successfully.';
                      }else{
                        echo 'Could not unregister. Please try again.';
                      }


                      /*$likeExists= $this->BetaSignups->find('all',['conditions'=>['user_id'=>$user_id,'type' => $type]])->first();
                      if(!empty($likeExists)){
                        $entity = $this->BetaSignups->get($likeExists->id);
                        $delResult=$this->BetaSignups->delete($entity);

                        if($delResult){
                          echo'Un registered successfully.';
                        }else{
                          echo 'Could not unregister. Please try again.';
                        }
                                   
                      }else{
                        echo 'Could not unregister. Please try again.';
                      }*/
                  }

              } //Type if end   
            }
    }


    /*** 
    * Search Method for Contractor
    *
    *
    ***/
    public function SearchContractors($id = null)
    {
        $this->paginate = [ 'limit' => 10];

        $startupId = base64_decode($id);
        $this->set('startupId', $id);

        $this->loadModel('Users');
        $this->loadModel('ContractorBasics');
        $this->loadModel('EntrepreneurProfessionals');
        $this->loadModel('ContractorProfessionals');
        $this->loadModel('Keywords');
        $this->loadModel('Roadmaps');
        $user = $this->Auth->user();
        $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
        $this->set('Keywords',$Keywords);

        if($user){


            $users=[]; 
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=trim($this->request->query('search'));
            $searchKeyword = str_replace("'","",$searchKeyword);  

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

                        $users= $this->Users->find('all',['conditions'=>$conditions])->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);

                        $this->paginate($users); 

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

                              $users = $this->Users->find('all',['conditions'=>['Users.id IN'=>$contractorIds
                                   ]])->contain(['ContractorBasics','ContractorProfessionals','Countries'])->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);

                               $this->paginate($users);               
                           }

                       }

                   }

               }

               $this->set('users', $users);                     

           }

       } 




     /*****
     *
     *  Add Contractor method
     *
     * 
     * 
     *
     *****/
     public function addContractor($id = null,$strtId = null)
     {

        if(!empty($id)){

              $ContractorId = base64_decode($id);
              $UserId = $this->request->Session()->read('Auth.User.id');

              $startupId = base64_decode($strtId); 
              $this->set('startupId', $strtId);

              $startupteamtable = TableRegistry::get('StartupTeams');

              $startup_detail = $startupteamtable->Startups->find('all',['conditions'=>['Startups.id'=>$startupId]])->first();

              /* Fetching all startup Detail from Startups Table with respective their logged in Id */
              if(!empty($startup_detail)){

                  $startupUserId=$startup_detail->user_id;

                  $startup_detail = $startupteamtable->Startups->find('list',['conditions'=>['Startups.id'=>$startupId]])->toArray();
              }else {

                  $startup_detail = $startupteamtable->Startups->find('list',['conditions'=>['Startups.user_id'=>$UserId]])->toArray();
              }
              $this->set('startup_detail',$startup_detail);


              // Check if user exists in Team for startup
              $this->loadModel('StartupTeams');
              $isPartStartupTeam = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startupId,'StartupTeams.user_id'=>$UserId]])->first();

              if(!empty($strtId)){
                  // if hiring for startup of other owner
                  $conditions = [];
                  array_push($conditions,["ContractorRoles.id !="=>1]);

                  if(!empty($isPartStartupTeam))                            
                  {       
                      $conditions = [];
                      if($isPartStartupTeam->contractor_role_id == 2){
                          array_push($conditions,["ContractorRoles.id !="=>1]);
                          array_push($conditions,["ContractorRoles.id !="=>2]);
                      }else if($isPartStartupTeam->contractor_role_id == 3){
                          array_push($conditions,["ContractorRoles.id !="=>1]);
                          array_push($conditions,["ContractorRoles.id !="=>2]);
                          array_push($conditions,["ContractorRoles.id !="=>3]);
                      }else {
                          array_push($conditions,["ContractorRoles.id !="=>1]);
                      }

                      $this->set('UserRoleId', $isPartStartupTeam->contractor_role_id);
                  }else {
                      if($startupUserId==$UserId){

                      }else {
                          return $this->redirect(['action' => 'searchContractors/']);
                      }
                  }

              }else {

                  $conditions = [];
                  array_push($conditions,["ContractorRoles.id !="=>1]);
              } 

            //Fetching roles of user from CountractorRoles Table with respective their logged in Id
            $contractor_roles = $startupteamtable->ContractorRoles->find('list')->where($conditions)->toArray();
            //pr( $contractor_roles );die;
            $this->set('roles',$contractor_roles); 

            $team_detail = $startupteamtable->newEntity();
            //prepare entity to be save into StartupTeams table

            $this->loadModel('Roadmaps');
            $roadmap = $this->Roadmaps->find('list')->toArray();
            $this->set('roadmaps', $roadmap);

            /* Fetching all User Detail from ContractorBasics Table with respective their logged in Id */
            $this->loadModel('ContractorBasics');
            $user_detail = $this->ContractorBasics->find('all',['conditions'=>['ContractorBasics.user_id'=>$ContractorId]])->select(['id','user_id','first_name','last_name','price']);
            $user_detail = $user_detail->first();
            $assign_contractor_id = $user_detail['user_id'];


            if(!empty($user_detail)){
                $this->set('userdetail',$user_detail);
            }else{

                $this->loadModel('Users');
                $user_detail = $this->Users->find('all',['conditions'=>['Users.id'=>$ContractorId]]);
                $user_detail = $user_detail->first();
                $this->set('userdetail',$user_detail);

            } 

            if($this->request->is('post','put')){

                $StartupId= $this->request->data['startup_id'];

                //check is user hired for startup
                $selected_startup_detail = $startupteamtable->find('all',['conditions'=>['StartupTeams.startup_id'=>$StartupId,'StartupTeams.user_id'=>$ContractorId]])->first();

                
                    $actualPriceFormat= str_replace("$","",$this->request->data['hourly_price']);
                    $price= $this->request->data['hourly_price']; 
                    $price= str_replace("$","",$price);
                    $price= str_replace(",","",$price);
                    $this->request->data['hourly_price']=$price;

                    $alloctedUnits= str_replace(",","",$this->request->data['work_units_allocated']);
                    $this->request->data['work_units_allocated']=$alloctedUnits;

                    $actuallApprovUnit=$this->request->data['work_units_approved'];
                    $approUnits= str_replace(",","",$this->request->data['work_units_approved']);
                    $this->request->data['work_units_approved']=$approUnits;

                    $roadmap_id ='';
                    if(!empty($this->request->data['roadmap_id'])){
                        $roadmap_id = implode(',', $this->request->data['roadmap_id']);
                    }
                    $this->request->data['roadmap_id'] = $roadmap_id;

                    $team_detail = $startupteamtable->patchEntity($team_detail,$this->request->data);
                                            //pr($team_detail); die();
                    $team_detail->user_id = $ContractorId;
                    $team_detail->hired_by = $UserId;

                    //Set status approved for testing
                    $team_detail->approved=0;


                    if($approUnits>$alloctedUnits){

                          $this->Flash->error(__('Approved work units can not be greater then to allocated work units.'));

                    }else{ 

                        //if(empty($selected_startup_detail)){
                        if(empty($selected_startup_detail) or $selected_startup_detail->approved==3){     

                              if ($startupteamtable->save($team_detail)) {

                                  //Save user notification 
                                  if(!empty($strtId)){
                                      $strtId=$strtId;
                                  }else {
                                      $strtId= base64_encode($this->request->data['startup_id']);
                                  }

                                  // Save notifications
                                  $android_message = "Entrepreneur ".$this->Contractor->entrepreneurName($UserId)." has offered you the opportunity to work as ".$this->Contractor->teamMemberRoleName($this->request->data['contractor_role_id'])." in Startup ".$this->Contractor->startupName($this->request->data['startup_id'])." and has approved ".$actuallApprovUnit." Work Units at an hourly rate of $".$actualPriceFormat.". Do you want to be a member of this Startup?";

                                  $ios_message = $this->Contractor->entrepreneurName($UserId).",".$this->Contractor->teamMemberRoleName($this->request->data['contractor_role_id']).",".$this->Contractor->startupName($this->request->data['startup_id']).",".$this->request->data['work_units_approved'].",".$actualPriceFormat;    

                                  //$values = [];
                                  $values = ['startup_id'=>$this->request->data['startup_id'],'android_message'=>$android_message,'ios_message'=>$ios_message];
                                  //,json_encode($values);
          ;
                                  $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartup',$strtId]);
                                  $this->WebNotification->sendNotification($UserId,$ContractorId,'Add_member','has sent you invitation for <strong> startup.</strong>',$link,$values);

                                  $this->Flash->success(__('The contractor has been assigned to your Startup successfully.'));
                              
                                  return $this->redirect($this->referer());
                              
                              }else{
                                    
                                    $this->Flash->error(__('Unable to add this contractor to your startup.'));
                              }

                        }else{ 

                            // If hired and status is 3 then update the user
                            if($selected_startup_detail->approved==3){
                              
                                $team_detail->id=$selected_startup_detail->id;
                                if($startupteamtable->save($team_detail)){

                                  //Save user notification 
                                  if(!empty($strtId)){
                                      $strtId=$strtId;
                                  }else {
                                      $strtId= base64_encode($this->request->data['startup_id']);
                                  }

                                  // Save notifications
                                  $android_message = "Entrepreneur ".$this->Contractor->entrepreneurName($UserId)." has offered you the opportunity to work as ".$this->Contractor->teamMemberRoleName($this->request->data['contractor_role_id'])." in Startup ".$this->Contractor->startupName($this->request->data['startup_id'])." and has approved ".$this->request->data['work_units_approved']." Work Units at an hourly rate of $".$actualPriceFormat.". Do you want to be a member of this Startup?";

                                  $ios_message = $this->Contractor->entrepreneurName($UserId).",".$this->Contractor->teamMemberRoleName($this->request->data['contractor_role_id']).",".$this->Contractor->startupName($this->request->data['startup_id']).",".$this->request->data['work_units_approved'].",".$actualPriceFormat;    

                                 // $values = [];
                                  $values = ['startup_id'=>$this->request->data['startup_id'],'android_message'=>$android_message,'ios_message'=>$ios_message];

                                  //,json_encode($values);
            

                               //,json_encode($values);

                                  $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartup',$strtId]);
                                  $this->WebNotification->sendNotification($UserId,$ContractorId,'Add_member','has sent you invitation for <strong> startup.</strong>',$link,$values);

                                  $this->Flash->success(__('The contractor has been assigned to your Startup successfully.'));
                              
                                  return $this->redirect($this->referer()); 
                                }

                            }else{

                                $this->Flash->error(__('This Contractor is already hired for this startup.'));
                            }                          
                        }
                    }// end of if approved hours greate then to allocated
            }
          
        }else{

                  return $this->redirect(['action' => 'searchContractors/']);
        }

        $this->set('team_detail',$team_detail);

     }



    /*****
     *
     *  Add Contractor method
     *
     * 
     * 
     *
     *****/
    public function rateContractor($contractorId = null,$StartupId = null)
    {
      $this->loadModel('Ratings');
      $this->loadModel('Users');
      $this->loadModel('StartupTeams');
      $this->loadModel('Roadmaps');

      if(!empty($contractorId) && !empty($StartupId)){

          $UserId = $this->request->Session()->read('Auth.User.id');

          $contractorId = base64_decode($contractorId);
                          //$this->set('contractorId', $contractorId);  

          $StartupId = base64_decode($StartupId);
                          //$this->set('StartupId', $StartupId);

          $User = $this->Users->get($contractorId);
          $this->set('User',$User);

                          //Check is user got hired for this startup or not
          $checkUsUserHired = $this->StartupTeams->exists(['StartupTeams.startup_id' => $StartupId, 'StartupTeams.user_id'=>$contractorId]);

          if($checkUsUserHired == 1){

              $Startups = $this->StartupTeams->find('all',['conditions' =>['StartupTeams.user_id'=>$contractorId,'StartupTeams.startup_id'=>$StartupId]])->contain(['Startups'])->first();
              $this->set('Startups',$Startups);

              $roadmaps = $this->Roadmaps->find('all')->toArray();
              $this->set('roadmaps', $roadmaps);

                                  //die;
              $Ratings = $this->Ratings->newEntity();

          if($this->request->is('post','put')){

                /*$roadmap_id ='';
                if(!empty($this->request->data['deliverable'])){
                 $roadmap_id = implode(',', $this->request->data['deliverable']);
                }*/
                $roadmap_id=$this->request->data['deliverable'];

                                             /// Update if rating is already given
             $Startups = $this->Ratings->find('all',['conditions' =>['Ratings.given_by'=>$UserId,'Ratings.given_to'=>$contractorId,'Ratings.startup_id'=>$StartupId,'Ratings.deliverable'=>$roadmap_id]])->first();



             $this->request->data['deliverable'] = $roadmap_id;
             $this->request->data['given_by'] = $UserId;
             $this->request->data['given_to'] = $contractorId;
             $this->request->data['startup_id'] = $StartupId;
             $this->request->data['status'] = 1;

                                            //pr($this->request->data); die;
             $Ratings = $this->Ratings->patchEntity($Ratings,$this->request->data);
             if(!empty($Startups)){
                $Ratings->id = $Startups->id;
            }

            if ($this->Ratings->save($Ratings)) {

              //Save user notification
              $values = [];
              //,json_encode($values);
              $link= Router::url(['controller' => 'Contractors', 'action' => 'excellenceAwards']);
              $this->WebNotification->sendNotification($UserId,$contractorId,'Rate_user','has rated your <strong> profile.</strong>',$link,$values);


              $this->Flash->success(__('Rating has been saved successfully.'));
              return $this->redirect($this->referer());

          }else{
            $this->Flash->error(__('Oops somthing wrong! Please try again.'));
        }                        

    } 

    $this->set('Ratings',$Ratings);
    }else{
        $this->Flash->error(__('You are not hired for this startup.'));
        return $this->redirect(['action' => 'searchContractors/']);
    }      
    }else{

        return $this->redirect(['action' => 'searchContractors/']);
    }
    }   


     /**
     * getOptionsList method
     *
     * @param string|null $Email ID.
     * @return void Redirects to register.
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
     public function getOptionsList(){

       $this->loadModel('States');
       if(!empty($this->request->data)){
          $countryId  = $this->request->data['countryId'];
          $state = $this->States->find('all',['conditions'=>['States.country_id'=>$countryId]])->select(['id','name'])->toArray();
          $this->set('states',$state);
          echo $this->render('/Element/Front/ajaxstates');
              //$result = "<option value=".$question_id.">".$questionname."</option>";
              //echo $result; 
          die;
        }

    }
    /**
     * RemoveImage method
     *
     * @param string|null $image_id.
     * @return void.
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function RemoveImage(){
        $this->autoRender = false;
        $this->loadModel('ContractorBasics');
        if(!empty($this->request->data)){
            $ImageId = $this->request->data['image_id'];

            $ContractorTable = TableRegistry::get('ContractorBasics');
            $update = $this->ContractorBasics->newEntity();
            $userupdate = $this->ContractorBasics->patchEntity($update,[
               'id' =>$ImageId
               ]);
            $query = $ContractorTable->query();
            $query->update()
            ->set([ 'image'=>false])
            ->where(['id' => $ImageId])
            ->execute();
            if($query == true){
                echo "Success";
            }


        }
    }
    
    /***
    * suggestKeywords Method
    *
    *
    ****/
    public function suggestKeywords()
    {
          $this->paginate = [ 'limit' => 20];

          $this->loadModel('KeywordSuggested');
          $this->loadModel('KeywordTypes');

          $KeywordTypes= $this->KeywordTypes->find('list')->toArray();
          $this->set('KeywordTypes',$KeywordTypes);

          $UserId = $this->request->Session()->read('Auth.User.id');


          $KeywordSuggestedLists= $this->KeywordSuggested->find('all',['conditions'=>['KeywordSuggested.user_id'=>$UserId]])->contain(['KeywordTypes']);
          //print_r($KeywordSuggestedLists->toArray()); die;

          $this->set('KeywordSuggestedLists',$this->paginate($KeywordSuggestedLists));

          $KeywordSuggested = $this->KeywordSuggested->newEntity();

          if($this->request->is('post','put')){
              $this->request->data['user_id']=$UserId;
              $this->request->data['name'];
              $this->request->data['type']=$this->request->data['keyword_type'];

              if(!empty($this->request->data['type'])){
                $KeywordSuggested = $this->KeywordSuggested->patchEntity($KeywordSuggested,$this->request->data);
   
                if ($this->KeywordSuggested->save($KeywordSuggested)) {
                    
                    $this->Flash->success(__('Keyword has been saved successfully.'));
                    return $this->redirect($this->referer());

                }else{
                    $this->Flash->error(__('Oops somthing wrong! Please try again.'));
                }

              }else{
                    $this->Flash->error(__('Please select keyword type.'));
              }  
          }    

          $this->set('suggested',$KeywordSuggested);

    }

    /***
    * suggestKeywords Method
    *
    *
    ****/
    public function deleteSuggestKeywords($id = null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('KeywordSuggested');

            $Id= base64_decode($id);
            $UserId = $this->request->Session()->read('Auth.User.id');

            $exists = $this->KeywordSuggested->exists(['id' => $Id, 'user_id'=>$UserId]);

            if(!empty($exists)){

                $query = $this->KeywordSuggested->query();
                $query->delete()
                ->where(['id' => $Id, 'user_id'=>$UserId])
                ->execute();

                $this->Flash->success(__('Keyword has been deleted successfully.'));
                return $this->redirect($this->referer());

            }else{
                $this->Flash->error(__('Oops somthing wrong! Please try again.'));
            }    

    }

    /***
    *
    * Add Feed
    *
    *
    ****/
    public function addFeed()
    {   
        $this->loadModel('UserFeeds');
        $UserFeeds = $this->UserFeeds->newEntity();

        $UserId = $this->request->Session()->read('Auth.User.id');
        $UserConnections = TableRegistry::get('UserConnections');
        $UserFollowers = TableRegistry::get('UserFollowers');
        $connectionLists = $UserConnections->find('all',
                                                      ['conditions'=>
                                                        ['UserConnections.status'=>1,
                                                        'OR'=>[
                                                                ['UserConnections.connection_by'=>$UserId],
                                                                ['UserConnections.connection_to'=>$UserId]
                                                              ] 
                                                        ],           
                                                        'fields' => [
                                                            'first_user' => 'UserConnections.connection_by',
                                                            'other_user' => 'UserConnections.connection_to'
                                                        ]
                                                      ] );
        $followerLists = $UserFollowers->find('all',
                                                      ['conditions'=>['UserFollowers.user_id'=>$UserId],           
                                                        'fields' => [
                                                            'first_user' => 'UserFollowers.user_id',
                                                            'other_user' => 'UserFollowers.followed_by'
                                                        ]
                                                      ] );
        $allResults = $connectionLists->unionAll($followerLists)->toArray();

        $result_array = [];
        if(!empty($allResults)){
          foreach($allResults as $key=>$result){
              if($result->first_user==$UserId){
                $result_array[$key] = $result->other_user;
              }else{
                $result_array[$key] = $result->first_user;
              }
          }
        } 

        $finalResult = array_values(array_unique($result_array));

        $TotalItems= count($finalResult);

        if($this->request->is('post'))
        {
          $uploadImgError='';
          $uploadimgName='';
          $flag=0;

          $msgError='';
          if (empty($this->request->data['message'])) {
            $flag=1;
            $msgError='Please enter message.';
          }
          if(!empty($this->request->data['file1']['name'])){
           
              $data = [];
              $data = $this->request->data['file1']; 
              $uploadImg = $this->FeedUpload->uploadFile($data);

              if(empty($uploadImg['errors'])){
                  $uploadimgName=$uploadImg['imgName'];
              }else{
                  $flag=1;
                  $uploadImgError=$uploadImg['errors'];
              }
          }

          $uploaddocError='';
          $uploaddocName='';
          if(!empty($this->request->data['file2']['name'])){
           
              $data2 = [];
              $data2 = $this->request->data['file2']; 
              $uploadDoc = $this->FeedUpload->uploadFile($data2);

              if(empty($uploadDoc['errors'])){
                  $uploaddocName=$uploadDoc['imgName'];
              }else{
                  $flag=1;
                  $uploaddocError=$uploadDoc['errors'];
              }
          }

          $uploadAudioError='';
          $uploadAudioName='';
          if(!empty($this->request->data['file3']['name'])){
           
              $data3 = [];
              $data3 = $this->request->data['file3']; 
              $uploadAusio = $this->FeedUpload->uploadFile($data3);

              if(empty($uploadAusio['errors'])){
                  $uploadAudioName=$uploadAusio['imgName'];
              }else{
                  $flag=1;
                  $uploadAudioError=$uploadAusio['errors'];
              }
          }


          $uploadVideoError='';
          $uploadVideoName='';
          if(!empty($this->request->data['file4']['name'])){
           
              $data3 = [];
              $data3 = $this->request->data['file4']; 
              $uploadVideo = $this->FeedUpload->uploadFile($data3);

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

              if(!empty($msgError)){
                  $this->Flash->error($msgError);
              }

          }else{

                $this->request->data['file1']=$uploadimgName;
                $this->request->data['file2']=$uploaddocName;
                $this->request->data['file3']=$uploadAudioName;
                $this->request->data['file4']=$uploadVideoName;

                //Save record for Followers and Connections
                if(!empty($TotalItems))
                {
                  foreach($finalResult as $key => $value)
                  {
                    //Check if seeting enabled
                    $UserFeeds = TableRegistry::get('UserFeeds');
                    $title =" has added a new information source for 'What's New'.";
                    $type="custom_feed";
                    $feeds = $UserFeeds->newEntity();

                    //$link= Router::url(['controller' => 'Contractors', 'action' => 'myProfile',base64_encode($value->connection_by)]);
                    $link='';
                    $values = ['sender_id'=>$UserId,'record_id'=>'','team_id'=>''];

                    $feeds->sender_id = $UserId;
                    $feeds->receiver_id = $value;

                    $feeds->type =$type;
                    $feeds->title =$title;
                    $feeds->link =$link;
                    $feeds->message =$this->request->data['message'];
                    $feeds->file1 =$this->request->data['file1'];
                    $feeds->file2 =$this->request->data['file2'];
                    $feeds->file3 =$this->request->data['file3'];
                    $feeds->file4 =$this->request->data['file4'];
                    $feeds->record_name  ='custom';
                    $feeds->data =json_encode($values);

                    //Save user feeds.
                    $result = $UserFeeds->save($feeds);

                  }
                }

              //Save record feed creator
              $UserFeeds = TableRegistry::get('UserFeeds');
              $title =" has added a new information source for 'What's New'.";
              $type="custom_feed";
              $feeds = $UserFeeds->newEntity();

              //$link= Router::url(['controller' => 'Contractors', 'action' => 'myProfile',base64_encode($value->connection_by)]);
              $link='';
              $values = ['sender_id'=>$UserId,'record_id'=>'','team_id'=>''];

              $feeds->sender_id = $UserId;
              $feeds->receiver_id = $UserId;

              $feeds->type =$type;
              $feeds->title =$title;
              $feeds->link =$link;
              $feeds->message =$this->request->data['message'];
              $feeds->file1 =$this->request->data['file1'];
              $feeds->file2 =$this->request->data['file2'];
              $feeds->file3 =$this->request->data['file3'];
              $feeds->file4 =$this->request->data['file4'];
              $feeds->record_name  ='custom';
              $feeds->data =json_encode($values);

              //Save user feeds.
              $result = $UserFeeds->save($feeds);
              $this->Flash->success('Feed saved successfully.');
              return $this->redirect(['action'=>'feeds']);
                

          }      
          
        }

        $this->set('UserFeeds',$UserFeeds);  
    }
    /***
    *
    * Feeds List
    *
    ****/
    public function feeds()
    {
          $this->paginate = [ 'limit' => 10,'order'=>['UserFeeds.id DESC']];

          $pageNo=$this->request->query('page');
          $this->set('pageNo',$pageNo);

          $UserId = $this->request->Session()->read('Auth.User.id');
          $widthClass ='';
          if(empty($UserId)){
            $widthClass ='notLogged';
          }
          $this->set('widthClass',$widthClass);
          $this->set('UserId',$UserId);   

          $UserId = $this->request->Session()->read('Auth.User.id');
          $this->loadModel('UserFeeds');
          $UserFeeds= $this->paginate($this->UserFeeds->find('all',['conditions'=>['UserFeeds.receiver_id'=>$UserId]])->contain(['Sender'=>['ContractorBasics'],'Receiver'=>['ContractorBasics']]));

          $finalConnections=[];
          $TotalItems= $UserFeeds->count();
          //$UserFeeds= $this->paginate($UserFeeds);
          $this->set('TotalItems',$TotalItems);
          if(!empty($TotalItems)){

            foreach($UserFeeds as $UserFeed){

              $keys['id']=$UserFeed->id;

              $keys['sender_name']= $UserFeed->sender->first_name.' '.$UserFeed->receiver->last_name;
              $keys['link']= $UserFeed->link;

              if($UserFeed->type == 'feeds_startup_completed_assignment'){

                $keys['message']=$UserFeed->receiver->first_name.' '.$UserFeed->sender->last_name.$UserFeed->title;

              }else{
                $keys['message']=$UserFeed->sender->first_name.' '.$UserFeed->sender->last_name.$UserFeed->title;
              }
              

              
              $keys['type']=$UserFeed->type;
                        $keys['data']=json_decode($UserFeed->data);
                        $keys['date']=date_format($UserFeed->created,"M d, Y");

                    //Startups    
              if($UserFeed->type == 'feeds_startup_added' or $UserFeed->type == 'feeds_startup_updated' or $UserFeed->type == 'feeds_startup_member_added' or $UserFeed->type == 'feeds_startup_completed_assignment' ){
                

                $data= json_decode($UserFeed->data);
                $this->loadModel('Startups');
                $startups= $this->Startups->get($data->record_id);

                if(!empty($startups)){
                  $keys['title']= $startups->name;

                  $keys['sender_image']= '';
                  if(!empty($startups->roadmap_graphic)){
                    $keys['sender_image']= "/img/roadmap/".$startups->roadmap_graphic;
                  }
                  
                  $keys['sender_bio']= $startups->description;

                }else{
                  $keys['title']= 'Startup';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }

            //Funds     
              }else if($UserFeed->type == 'feeds_fund_added' or $UserFeed->type == 'feeds_fund_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Funds');
                $funds= $this->Funds->get($data->record_id);

                if(!empty($funds)){
                  $keys['title']= $funds->title;
                  $keys['sender_image']= '';
                  if(!empty($funds->image)){
                    $keys['sender_image']= "/img/funds/".$funds->image;
                  }
                  
                  $keys['sender_bio']= $funds->description;

                }else{
                  $keys['title']= 'Fund';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Campaign
              }else if($UserFeed->type == 'feeds_campaign_added' or $UserFeed->type == 'feeds_campaign_following' or $UserFeed->type=='feeds_campaign_commited'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Campaigns');
                $Campaigns= $this->Campaigns->get($data->record_id);

                if(!empty($Campaigns)){
                  $keys['title']= $Campaigns->campaigns_name;
                  $keys['sender_image']= '';
                  if(!empty($Campaigns->campaign_image)){
                    $keys['sender_image']= "/img/campaign/".$Campaigns->campaign_image;
                  }
                  
                  $keys['sender_bio']= $Campaigns->summary;

                }else{
                  $keys['title']= 'Campaign';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Self Improvements
              }else if($UserFeed->type == 'feeds_improvement_added' or $UserFeed->type == 'feeds_improvement_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('SelfImprovements');
                $SelfImprovements= $this->SelfImprovements->get($data->record_id);

                if(!empty($SelfImprovements)){
                  $keys['title']= $SelfImprovements->title;
                  $keys['sender_image']= '';
                  if(!empty($SelfImprovements->image)){
                    $keys['sender_image']= "/img/self/".$SelfImprovements->image;
                  }
                  
                  $keys['sender_bio']= $SelfImprovements->description;

                }else{
                  $keys['title']= 'Self';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Career    
              }else if($UserFeed->type == 'feeds_career_added' or $UserFeed->type == 'feeds_career_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('CareerAdvancements');
                $CareerAdvancements= $this->CareerAdvancements->get($data->record_id);

                if(!empty($CareerAdvancements)){
                  $keys['title']= $CareerAdvancements->title;
                  $keys['sender_image']= '';
                  if(!empty($CareerAdvancements->image)){
                    $keys['sender_image']= "/img/career/".$CareerAdvancements->image;
                  }
                  
                  $keys['sender_bio']= $CareerAdvancements->description;

                }else{
                  $keys['title']= 'Career Help';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Organization    
              }else if($UserFeed->type == 'feeds_organization_added' or $UserFeed->type == 'feeds_organization_updated'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('SubAdminDetails');
                $SubAdminDetails= $this->SubAdminDetails->get($data->record_id);

                if(!empty($SubAdminDetails)){
                  $keys['title']= $SubAdminDetails->company_name;
                  $keys['sender_image']= '';
                  if(!empty($SubAdminDetails->profile_image)){
                    $keys['sender_image']= "/img/subadmin_profile_image/".$SubAdminDetails->profile_image;
                  }
                  
                  $keys['sender_bio']= $SubAdminDetails->description;

                }else{
                  $keys['title']= 'Organization';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Forum   
              }else if($UserFeed->type == 'feeds_forum_added' or $UserFeed->type == 'feeds_forum_message'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Forums');
                $Forums= $this->Forums->get($data->record_id);

                if(!empty($Forums)){
                  $keys['title']= $Forums->title;
                  $keys['sender_image']= '';
                  if(!empty($Forums->image)){
                    $keys['sender_image']= "/img/forums/".$Forums->image;
                  }
                  
                  $keys['sender_bio']= $Forums->description;

                }else{
                  $keys['title']= 'Forum';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Groups    
              }else if($UserFeed->type == 'feeds_group_added' or $UserFeed->type == 'feeds_group_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Groups');
                $Groups= $this->Groups->get($data->record_id);

                if(!empty($Groups)){
                  $keys['title']= $Groups->title;
                  $keys['sender_image']= '';
                  if(!empty($Groups->image)){
                    $keys['sender_image']= "/img/group/".$Groups->image;
                  }
                  
                  $keys['sender_bio']= $Groups->description;

                }else{
                  $keys['title']= 'Group';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //hardware    
              }else if($UserFeed->type == 'feeds_hardware_added' or $UserFeed->type == 'feeds_hardware_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Hardwares');
                $Hardwares= $this->Hardwares->get($data->record_id);

                if(!empty($Hardwares)){
                  $keys['title']= $Hardwares->title;
                  $keys['sender_image']= '';
                  if(!empty($Hardwares->image)){
                    $keys['sender_image']= "/img/hardware/".$Hardwares->image;
                  }
                  
                  $keys['sender_bio']= $Hardwares->description;

                }else{
                  $keys['title']= 'Hardware';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Software    
              }else if($UserFeed->type == 'feeds_software_added' or $UserFeed->type == 'feeds_software_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Softwares');
                $Softwares= $this->Softwares->get($data->record_id);

                if(!empty($Softwares)){
                  $keys['title']= $Softwares->title;
                  $keys['sender_image']= '';
                  if(!empty($Softwares->image)){
                    $keys['sender_image']= "/img/software/".$Softwares->image;
                  }
                  
                  $keys['sender_bio']= $Softwares->description;

                }else{
                  $keys['title']= 'Software';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Service
              }else if($UserFeed->type == 'feeds_service_added' or $UserFeed->type == 'feeds_service_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Services');
                $Services= $this->Services->get($data->record_id);

                if(!empty($Services)){
                  $keys['title']= $Services->title;
                  $keys['sender_image']= '';
                  if(!empty($Services->image)){
                    $keys['sender_image']= "/img/service/".$Services->image;
                  }
                  
                  $keys['sender_bio']= $Services->description;

                }else{
                  $keys['title']= 'Service';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Audi Video    
              }else if($UserFeed->type == 'feeds_audio_added' or $UserFeed->type == 'feeds_audio_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('AudioVideos');
                $AudioVideos= $this->AudioVideos->get($data->record_id);

                if(!empty($AudioVideos)){
                  $keys['title']= $AudioVideos->title;
                  $keys['sender_image']= '';
                  if(!empty($AudioVideos->image)){
                    $keys['sender_image']= "/img/audio_video/".$AudioVideos->image;
                  }
                  
                  $keys['sender_bio']= $AudioVideos->description;

                }else{
                  $keys['title']= 'Audio Video';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Information 
              }else if($UserFeed->type == 'feeds_information_added' or $UserFeed->type == 'feeds_information_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Informations');
                $Informations= $this->Informations->get($data->record_id);

                if(!empty($Informations)){
                  $keys['title']= $Informations->title;
                  $keys['sender_image']= '';
                  if(!empty($Informations->image)){
                    $keys['sender_image']= "/img/information/".$Informations->image;
                  }
                  
                  $keys['sender_bio']= $Informations->description;

                }else{
                  $keys['title']= 'Information';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Productivity    
              }else if($UserFeed->type == 'feeds_productivity_added' or $UserFeed->type == 'feeds_productivity_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Productivities');
                $Productivities= $this->Productivities->get($data->record_id);

                if(!empty($Productivities)){
                  $keys['title']= $Productivities->title;
                  $keys['sender_image']= '';
                  if(!empty($Productivities->image)){
                    $keys['sender_image']= "/img/productivity/".$Productivities->image;
                  }
                  
                  $keys['sender_bio']= $Productivities->description;

                }else{
                  $keys['title']= 'productivities';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //conference
              }else if($UserFeed->type == 'feeds_conference_added' or $UserFeed->type == 'feeds_conference_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Conferences');
                $Conferences= $this->Conferences->get($data->record_id);

                if(!empty($Conferences)){
                  $keys['title']= $Conferences->title;
                  $keys['sender_image']= '';
                  if(!empty($Conferences->image)){
                    $keys['sender_image']= "/img/conference/".$Conferences->image;
                  }
                  
                  $keys['sender_bio']= $Conferences->description;

                }else{
                  $keys['title']= 'Conference';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Demoday   
              }else if($UserFeed->type == 'feeds_demoday_added' or $UserFeed->type == 'feeds_demoday_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Demodays');
                $Demodays= $this->Demodays->get($data->record_id);

                if(!empty($Demodays)){
                  $keys['title']= $Demodays->title;
                  $keys['sender_image']= '';
                  if(!empty($Demodays->image)){
                    $keys['sender_image']= "/img/demoday/".$Demodays->image;
                  }
                  
                  $keys['sender_bio']= $Demodays->description;

                }else{
                  $keys['title']= 'Demodays';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //meetup    
              }else if($UserFeed->type == 'feeds_meetup_added' or $UserFeed->type == 'feeds_meetup_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Meetups');
                $Meetups= $this->Meetups->get($data->record_id);

                if(!empty($Meetups)){
                  $keys['title']= $Meetups->title;
                  $keys['sender_image']= '';
                  if(!empty($Meetups->image)){
                    $keys['sender_image']= "/img/meetup/".$Meetups->image;
                  }
                  
                  $keys['sender_bio']= $Meetups->description;

                }else{
                  $keys['title']= 'Meetups';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //webinar   
              }else if($UserFeed->type == 'feeds_webinar_added' or $UserFeed->type == 'feeds_webinar_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Webinars');
                $Webinars= $this->Webinars->get($data->record_id);

                if(!empty($Webinars)){
                  $keys['title']= $Webinars->title;
                  $keys['sender_image']= '';
                  if(!empty($Webinars->image)){
                    $keys['sender_image']= "/img/meetup/".$Webinars->image;
                  }
                  
                  $keys['sender_bio']= $Webinars->description;

                }else{
                  $keys['title']= 'Webinars';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //betatest  
              }else if($UserFeed->type == 'feeds_betatest_added' or $UserFeed->type == 'feeds_betatest_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('BetaTests');
                $BetaTests= $this->BetaTests->get($data->record_id);

                if(!empty($BetaTests)){
                  $keys['title']= $BetaTests->title;
                  $keys['sender_image']= '';
                  if(!empty($BetaTests->image)){
                    $keys['sender_image']= "/img/beta_test/".$BetaTests->image;
                  }
                  
                  $keys['sender_bio']= $BetaTests->description;

                }else{
                  $keys['title']= 'Beta Tests';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //boardmember     
              }else if($UserFeed->type == 'feeds_boardmember_added' or $UserFeed->type == 'feeds_boardmember_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('BoardMembers');
                $BoardMembers= $this->BoardMembers->get($data->record_id);

                if(!empty($BoardMembers)){
                  $keys['title']= $BoardMembers->title;
                  $keys['sender_image']= '';
                  if(!empty($BoardMembers->image)){
                    $keys['sender_image']= "/img/board_member/".$BoardMembers->image;
                  }
                  
                  $keys['sender_bio']= $BoardMembers->description;

                }else{
                  $keys['title']= 'Board Members';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //communal_asset    
              }else if($UserFeed->type == 'feeds_communal_added' or $UserFeed->type == 'feeds_communal_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('CommunalAssets');
                $CommunalAssets= $this->CommunalAssets->get($data->record_id);

                if(!empty($CommunalAssets)){
                  $keys['title']= $CommunalAssets->title;
                  $keys['sender_image']= '';

                  if(!empty($CommunalAssets->image)){
                    $keys['sender_image']= "/img/communal/".$CommunalAssets->image;
                  }
                  
                  $keys['sender_bio']= $CommunalAssets->description;

                }else{
                  $keys['title']= 'Communal Assets';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //consulting    
              }else if($UserFeed->type == 'feeds_consulting_added' or $UserFeed->type == 'feeds_consulting_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Consultings');
                $Consultings= $this->Consultings->get($data->record_id);

                if(!empty($Consultings)){
                  $keys['title']= $Consultings->title;
                  $keys['sender_image']= '';

                  if(!empty($Consultings->image)){
                    $keys['sender_image']= "/img/consulting/".$Consultings->image;
                  }
                  
                  $keys['sender_bio']= $Consultings->description;

                }else{
                  $keys['title']= 'Consultings';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //EarlyAdopters   
              }else if($UserFeed->type == 'feeds_earlyadopter_added' or $UserFeed->type == 'feeds_earlyadopter_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('EarlyAdopters');
                $EarlyAdopters= $this->EarlyAdopters->get($data->record_id);

                if(!empty($EarlyAdopters)){
                  $keys['title']= $EarlyAdopters->title;
                  $keys['sender_image']= '';

                  if(!empty($EarlyAdopters->image)){
                    $keys['sender_image']= "/img/early_adopter/".$EarlyAdopters->image;
                  }
                  
                  $keys['sender_bio']= $EarlyAdopters->description;

                }else{
                  $keys['title']= 'Early Adopters';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //focusgroup    
              }else if($UserFeed->type == 'feeds_focusgroup_added' or $UserFeed->type == 'feeds_focusgroup_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('FocusGroups');
                $FocusGroups= $this->FocusGroups->get($data->record_id);

                if(!empty($FocusGroups)){
                  $keys['title']= $FocusGroups->title;
                  $keys['sender_image']= '';

                  if(!empty($FocusGroups->image)){
                    $keys['sender_image']= "/img/focus_group/".$FocusGroups->image;
                  }
                  
                  $keys['sender_bio']= $FocusGroups->description;

                }else{
                  $keys['title']= 'Focus Group';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Job   
              }else if($UserFeed->type == 'feeds_job_added' or $UserFeed->type == 'feeds_job_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Jobs');
                $Jobs= $this->Jobs->get($data->record_id);

                if(!empty($Jobs)){
                  $keys['title']= $Jobs->job_title;
                  $keys['sender_image']= '';

                  /*if(!empty($Jobs->image)){
                    $keys['sender_image']= "/img/jobs/".$Jobs->image;
                  }*/
                  
                  $keys['sender_bio']= $Jobs->description;

                }else{
                  $keys['title']= 'Job';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //launch_deal   
              }else if($UserFeed->type == 'feeds_launchdeal_added' or $UserFeed->type == 'feeds_launchdeal_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('LaunchDeals');
                $LaunchDeals= $this->LaunchDeals->get($data->record_id);

                if(!empty($LaunchDeals)){
                  $keys['title']= $LaunchDeals->title;
                  $keys['sender_image']= '';

                  if(!empty($LaunchDeals->image)){
                    $keys['sender_image']= "/img/launchdeal/".$LaunchDeals->image;
                  }
                  
                  $keys['sender_bio']= $LaunchDeals->description;

                }else{ 
                  $keys['title']= 'Launch Deals ';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Group Buying    
              }else if($UserFeed->type == 'feeds_purchaseorder_added' or $UserFeed->type == 'feeds_purchaseorder_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('GroupBuyings');
                $GroupBuyings= $this->GroupBuyings->get($data->record_id);

                if(!empty($GroupBuyings)){
                  $keys['title']= $GroupBuyings->title;
                  $keys['sender_image']= '';

                  if(!empty($GroupBuyings->image)){
                    $keys['sender_image']= "/img/groupbuying/".$GroupBuyings->image;
                  }
                  
                  $keys['sender_bio']= $GroupBuyings->description;

                }else{
                  $keys['title']= 'Job';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
                
            //Custom Feed    
              }else if($UserFeed->type == 'custom_feed'){

                
                $keys['title']= $UserFeed->sender->first_name.' '.$UserFeed->sender->last_name;
                
                if(!empty($UserFeed->sender->contractor_basic)){
                  $keys['sender_image']='';
                  if(!empty($UserFeed->sender->contractor_basic->image)){
                    $keys['sender_image']= "/img/profile_pic/".$UserFeed->sender->contractor_basic->image;
                  }
                }else{
                  $keys['sender_image']= '';
                }
                $keys['sender_bio']=$UserFeed->message;

              }else{

                $keys['title']= $UserFeed->sender->first_name.' '.$UserFeed->sender->last_name;

                  if(!empty($UserFeed->sender->contractor_basic)){
                    $keys['sender_bio']= $UserFeed->sender->contractor_basic->bio;
                    $keys['sender_image']='';
                    if(!empty($UserFeed->sender->contractor_basic->image)){
                      $keys['sender_image']= "/img/profile_pic/".$UserFeed->sender->contractor_basic->image;
                    }
                  }else{
                    $keys['sender_bio']= '';
                    $keys['sender_image']= '';
                  }

              }


              if(!empty($UserFeed->file1)){
                $keys['file1']='img/feed/'.$UserFeed->file1;
              }else{
                $keys['file1']='';
              }

              if(!empty($UserFeed->file2)){
                $keys['file2']='img/feed/'.$UserFeed->file2;
              }else{
                $keys['file2']='';
              }


              if(!empty($UserFeed->file3)){
                $keys['file3']='img/feed/'.$UserFeed->file3;
              }else{
                $keys['file3']='';
              }

              if(!empty($UserFeed->file4)){
                $keys['file4']='img/feed/'.$UserFeed->file4;
              }else{
                $keys['file4']='';
              }


              $finalConnections[] = $keys;
            }

            $this->set('feedsLists',$finalConnections);
            //$this->set('feedsLists',$this->paginate($finalConnections));

          }else{

            $this->set('feedsLists',$finalConnections);
          }
    }

    /***
    *
    * Ajax getFeedLists
    *
    ****/
    public function getFeedLists()
    {
          $this->paginate = [ 'limit' => 10,'order'=>['UserFeeds.id DESC']];

          $pageNo=$this->request->query('page');
          $this->set('pageNo',$pageNo);
          
          $UserId = $this->request->Session()->read('Auth.User.id');
          $this->loadModel('UserFeeds');
          $UserFeeds= $this->paginate($this->UserFeeds->find('all',['conditions'=>['UserFeeds.receiver_id'=>$UserId]])->contain(['Sender'=>['ContractorBasics'],'Receiver'=>['ContractorBasics']]));

          $ajaxfinalConnections=[];
          $TotalItems= $UserFeeds->count();
          //$UserFeeds= $this->paginate($UserFeeds);
          $this->set('TotalItems',$TotalItems);
          if(!empty($TotalItems)){

            foreach($UserFeeds as $UserFeed){

              $keys['id']=$UserFeed->id;

              $keys['sender_name']= $UserFeed->sender->first_name.' '.$UserFeed->receiver->last_name;
              $keys['link']= $UserFeed->link;

              if($UserFeed->type == 'feeds_startup_completed_assignment'){

                $keys['message']=$UserFeed->receiver->first_name.' '.$UserFeed->sender->last_name.$UserFeed->title;

              }else{
                $keys['message']=$UserFeed->sender->first_name.' '.$UserFeed->sender->last_name.$UserFeed->title;
              }
              

              
              $keys['type']=$UserFeed->type;
              $keys['data']=json_decode($UserFeed->data);
              $keys['date']=date_format($UserFeed->created,"M d, Y");

            //Startups    
              if($UserFeed->type == 'feeds_startup_added' or $UserFeed->type == 'feeds_startup_updated' or $UserFeed->type == 'feeds_startup_member_added' or $UserFeed->type == 'feeds_startup_completed_assignment' ){
                

                $data= json_decode($UserFeed->data);
                $this->loadModel('Startups');
                $startups= $this->Startups->get($data->record_id);

                if(!empty($startups)){
                  $keys['title']= $startups->name;

                  $keys['sender_image']= '';
                  if(!empty($startups->roadmap_graphic)){
                    $keys['sender_image']= "/img/roadmap/".$startups->roadmap_graphic;
                  }
                  
                  $keys['sender_bio']= $startups->description;

                }else{
                  $keys['title']= 'Startup';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }

            //Funds     
              }else if($UserFeed->type == 'feeds_fund_added' or $UserFeed->type == 'feeds_fund_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Funds');
                $funds= $this->Funds->get($data->record_id);

                if(!empty($funds)){
                  $keys['title']= $funds->title;
                  $keys['sender_image']= '';
                  if(!empty($funds->image)){
                    $keys['sender_image']= "/img/funds/".$funds->image;
                  }
                  
                  $keys['sender_bio']= $funds->description;

                }else{
                  $keys['title']= 'Fund';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Campaign
              }else if($UserFeed->type == 'feeds_campaign_added' or $UserFeed->type == 'feeds_campaign_following' or $UserFeed->type=='feeds_campaign_commited'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Campaigns');
                $Campaigns= $this->Campaigns->get($data->record_id);

                if(!empty($Campaigns)){
                  $keys['title']= $Campaigns->campaigns_name;
                  $keys['sender_image']= '';
                  if(!empty($Campaigns->campaign_image)){
                    $keys['sender_image']= "/img/campaign/".$Campaigns->campaign_image;
                  }
                  
                  $keys['sender_bio']= $Campaigns->summary;

                }else{
                  $keys['title']= 'Campaign';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Self Improvements
              }else if($UserFeed->type == 'feeds_improvement_added' or $UserFeed->type == 'feeds_improvement_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('SelfImprovements');
                $SelfImprovements= $this->SelfImprovements->get($data->record_id);

                if(!empty($SelfImprovements)){
                  $keys['title']= $SelfImprovements->title;
                  $keys['sender_image']= '';
                  if(!empty($SelfImprovements->image)){
                    $keys['sender_image']= "/img/self/".$SelfImprovements->image;
                  }
                  
                  $keys['sender_bio']= $SelfImprovements->description;

                }else{
                  $keys['title']= 'Self';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Career    
              }else if($UserFeed->type == 'feeds_career_added' or $UserFeed->type == 'feeds_career_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('CareerAdvancements');
                $CareerAdvancements= $this->CareerAdvancements->get($data->record_id);

                if(!empty($CareerAdvancements)){
                  $keys['title']= $CareerAdvancements->title;
                  $keys['sender_image']= '';
                  if(!empty($CareerAdvancements->image)){
                    $keys['sender_image']= "/img/career/".$CareerAdvancements->image;
                  }
                  
                  $keys['sender_bio']= $CareerAdvancements->description;

                }else{
                  $keys['title']= 'Career Help';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Organization    
              }else if($UserFeed->type == 'feeds_organization_added' or $UserFeed->type == 'feeds_organization_updated'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('SubAdminDetails');
                $SubAdminDetails= $this->SubAdminDetails->get($data->record_id);

                if(!empty($SubAdminDetails)){
                  $keys['title']= $SubAdminDetails->company_name;
                  $keys['sender_image']= '';
                  if(!empty($SubAdminDetails->profile_image)){
                    $keys['sender_image']= "/img/subadmin_profile_image/".$SubAdminDetails->profile_image;
                  }
                  
                  $keys['sender_bio']= $SubAdminDetails->description;

                }else{
                  $keys['title']= 'Organization';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Forum   
              }else if($UserFeed->type == 'feeds_forum_added' or $UserFeed->type == 'feeds_forum_message'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Forums');
                $Forums= $this->Forums->get($data->record_id);

                if(!empty($Forums)){
                  $keys['title']= $Forums->title;
                  $keys['sender_image']= '';
                  if(!empty($Forums->image)){
                    $keys['sender_image']= "/img/forums/".$Forums->image;
                  }
                  
                  $keys['sender_bio']= $Forums->description;

                }else{
                  $keys['title']= 'Forum';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Groups    
              }else if($UserFeed->type == 'feeds_group_added' or $UserFeed->type == 'feeds_group_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Groups');
                $Groups= $this->Groups->get($data->record_id);

                if(!empty($Groups)){
                  $keys['title']= $Groups->title;
                  $keys['sender_image']= '';
                  if(!empty($Groups->image)){
                    $keys['sender_image']= "/img/group/".$Groups->image;
                  }
                  
                  $keys['sender_bio']= $Groups->description;

                }else{
                  $keys['title']= 'Group';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //hardware    
              }else if($UserFeed->type == 'feeds_hardware_added' or $UserFeed->type == 'feeds_hardware_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Hardwares');
                $Hardwares= $this->Hardwares->get($data->record_id);

                if(!empty($Hardwares)){
                  $keys['title']= $Hardwares->title;
                  $keys['sender_image']= '';
                  if(!empty($Hardwares->image)){
                    $keys['sender_image']= "/img/hardware/".$Hardwares->image;
                  }
                  
                  $keys['sender_bio']= $Hardwares->description;

                }else{
                  $keys['title']= 'Hardware';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Software    
              }else if($UserFeed->type == 'feeds_software_added' or $UserFeed->type == 'feeds_software_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Softwares');
                $Softwares= $this->Softwares->get($data->record_id);

                if(!empty($Softwares)){
                  $keys['title']= $Softwares->title;
                  $keys['sender_image']= '';
                  if(!empty($Softwares->image)){
                    $keys['sender_image']= "/img/software/".$Softwares->image;
                  }
                  
                  $keys['sender_bio']= $Softwares->description;

                }else{
                  $keys['title']= 'Software';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Service
              }else if($UserFeed->type == 'feeds_service_added' or $UserFeed->type == 'feeds_service_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Services');
                $Services= $this->Services->get($data->record_id);

                if(!empty($Services)){
                  $keys['title']= $Services->title;
                  $keys['sender_image']= '';
                  if(!empty($Services->image)){
                    $keys['sender_image']= "/img/service/".$Services->image;
                  }
                  
                  $keys['sender_bio']= $Services->description;

                }else{
                  $keys['title']= 'Service';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Audi Video    
              }else if($UserFeed->type == 'feeds_audio_added' or $UserFeed->type == 'feeds_audio_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('AudioVideos');
                $AudioVideos= $this->AudioVideos->get($data->record_id);

                if(!empty($AudioVideos)){
                  $keys['title']= $AudioVideos->title;
                  $keys['sender_image']= '';
                  if(!empty($AudioVideos->image)){
                    $keys['sender_image']= "/img/audio_video/".$AudioVideos->image;
                  }
                  
                  $keys['sender_bio']= $AudioVideos->description;

                }else{
                  $keys['title']= 'Audio Video';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Information 
              }else if($UserFeed->type == 'feeds_information_added' or $UserFeed->type == 'feeds_information_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Informations');
                $Informations= $this->Informations->get($data->record_id);

                if(!empty($Informations)){
                  $keys['title']= $Informations->title;
                  $keys['sender_image']= '';
                  if(!empty($Informations->image)){
                    $keys['sender_image']= "/img/information/".$Informations->image;
                  }
                  
                  $keys['sender_bio']= $Informations->description;

                }else{
                  $keys['title']= 'Information';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Productivity    
              }else if($UserFeed->type == 'feeds_productivity_added' or $UserFeed->type == 'feeds_productivity_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Productivities');
                $Productivities= $this->Productivities->get($data->record_id);

                if(!empty($Productivities)){
                  $keys['title']= $Productivities->title;
                  $keys['sender_image']= '';
                  if(!empty($Productivities->image)){
                    $keys['sender_image']= "/img/productivity/".$Productivities->image;
                  }
                  
                  $keys['sender_bio']= $Productivities->description;

                }else{
                  $keys['title']= 'productivities';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //conference
              }else if($UserFeed->type == 'feeds_conference_added' or $UserFeed->type == 'feeds_conference_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Conferences');
                $Conferences= $this->Conferences->get($data->record_id);

                if(!empty($Conferences)){
                  $keys['title']= $Conferences->title;
                  $keys['sender_image']= '';
                  if(!empty($Conferences->image)){
                    $keys['sender_image']= "/img/conference/".$Conferences->image;
                  }
                  
                  $keys['sender_bio']= $Conferences->description;

                }else{
                  $keys['title']= 'Conference';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Demoday   
              }else if($UserFeed->type == 'feeds_demoday_added' or $UserFeed->type == 'feeds_demoday_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Demodays');
                $Demodays= $this->Demodays->get($data->record_id);

                if(!empty($Demodays)){
                  $keys['title']= $Demodays->title;
                  $keys['sender_image']= '';
                  if(!empty($Demodays->image)){
                    $keys['sender_image']= "/img/demoday/".$Demodays->image;
                  }
                  
                  $keys['sender_bio']= $Demodays->description;

                }else{
                  $keys['title']= 'Demodays';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //meetup    
              }else if($UserFeed->type == 'feeds_meetup_added' or $UserFeed->type == 'feeds_meetup_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Meetups');
                $Meetups= $this->Meetups->get($data->record_id);

                if(!empty($Meetups)){
                  $keys['title']= $Meetups->title;
                  $keys['sender_image']= '';
                  if(!empty($Meetups->image)){
                    $keys['sender_image']= "/img/meetup/".$Meetups->image;
                  }
                  
                  $keys['sender_bio']= $Meetups->description;

                }else{
                  $keys['title']= 'Meetups';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //webinar   
              }else if($UserFeed->type == 'feeds_webinar_added' or $UserFeed->type == 'feeds_webinar_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Webinars');
                $Webinars= $this->Webinars->get($data->record_id);

                if(!empty($Webinars)){
                  $keys['title']= $Webinars->title;
                  $keys['sender_image']= '';
                  if(!empty($Webinars->image)){
                    $keys['sender_image']= "/img/meetup/".$Webinars->image;
                  }
                  
                  $keys['sender_bio']= $Webinars->description;

                }else{
                  $keys['title']= 'Webinars';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //betatest  
              }else if($UserFeed->type == 'feeds_betatest_added' or $UserFeed->type == 'feeds_betatest_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('BetaTests');
                $BetaTests= $this->BetaTests->get($data->record_id);

                if(!empty($BetaTests)){
                  $keys['title']= $BetaTests->title;
                  $keys['sender_image']= '';
                  if(!empty($BetaTests->image)){
                    $keys['sender_image']= "/img/beta_test/".$BetaTests->image;
                  }
                  
                  $keys['sender_bio']= $BetaTests->description;

                }else{
                  $keys['title']= 'Beta Tests';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //boardmember     
              }else if($UserFeed->type == 'feeds_boardmember_added' or $UserFeed->type == 'feeds_boardmember_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('BoardMembers');
                $BoardMembers= $this->BoardMembers->get($data->record_id);

                if(!empty($BoardMembers)){
                  $keys['title']= $BoardMembers->title;
                  $keys['sender_image']= '';
                  if(!empty($BoardMembers->image)){
                    $keys['sender_image']= "/img/board_member/".$BoardMembers->image;
                  }
                  
                  $keys['sender_bio']= $BoardMembers->description;

                }else{
                  $keys['title']= 'Board Members';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //communal_asset    
              }else if($UserFeed->type == 'feeds_communal_added' or $UserFeed->type == 'feeds_communal_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('CommunalAssets');
                $CommunalAssets= $this->CommunalAssets->get($data->record_id);

                if(!empty($CommunalAssets)){
                  $keys['title']= $CommunalAssets->title;
                  $keys['sender_image']= '';

                  if(!empty($CommunalAssets->image)){
                    $keys['sender_image']= "/img/communal/".$CommunalAssets->image;
                  }
                  
                  $keys['sender_bio']= $CommunalAssets->description;

                }else{
                  $keys['title']= 'Communal Assets';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //consulting    
              }else if($UserFeed->type == 'feeds_consulting_added' or $UserFeed->type == 'feeds_consulting_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Consultings');
                $Consultings= $this->Consultings->get($data->record_id);

                if(!empty($Consultings)){
                  $keys['title']= $Consultings->title;
                  $keys['sender_image']= '';

                  if(!empty($Consultings->image)){
                    $keys['sender_image']= "/img/consulting/".$Consultings->image;
                  }
                  
                  $keys['sender_bio']= $Consultings->description;

                }else{
                  $keys['title']= 'Consultings';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //EarlyAdopters   
              }else if($UserFeed->type == 'feeds_earlyadopter_added' or $UserFeed->type == 'feeds_earlyadopter_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('EarlyAdopters');
                $EarlyAdopters= $this->EarlyAdopters->get($data->record_id);

                if(!empty($EarlyAdopters)){
                  $keys['title']= $EarlyAdopters->title;
                  $keys['sender_image']= '';

                  if(!empty($EarlyAdopters->image)){
                    $keys['sender_image']= "/img/early_adopter/".$EarlyAdopters->image;
                  }
                  
                  $keys['sender_bio']= $EarlyAdopters->description;

                }else{
                  $keys['title']= 'Early Adopters';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //focusgroup    
              }else if($UserFeed->type == 'feeds_focusgroup_added' or $UserFeed->type == 'feeds_focusgroup_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('FocusGroups');
                $FocusGroups= $this->FocusGroups->get($data->record_id);

                if(!empty($FocusGroups)){
                  $keys['title']= $FocusGroups->title;
                  $keys['sender_image']= '';

                  if(!empty($FocusGroups->image)){
                    $keys['sender_image']= "/img/focus_group/".$FocusGroups->image;
                  }
                  
                  $keys['sender_bio']= $FocusGroups->description;

                }else{
                  $keys['title']= 'Focus Group';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Job   
              }else if($UserFeed->type == 'feeds_job_added' or $UserFeed->type == 'feeds_job_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('Jobs');
                $Jobs= $this->Jobs->get($data->record_id);

                if(!empty($Jobs)){
                  $keys['title']= $Jobs->job_title;
                  $keys['sender_image']= '';

                  /*if(!empty($Jobs->image)){
                    $keys['sender_image']= "/img/jobs/".$Jobs->image;
                  }*/
                  
                  $keys['sender_bio']= $Jobs->description;

                }else{
                  $keys['title']= 'Job';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //launch_deal   
              }else if($UserFeed->type == 'feeds_launchdeal_added' or $UserFeed->type == 'feeds_launchdeal_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('LaunchDeals');
                $LaunchDeals= $this->LaunchDeals->get($data->record_id);

                if(!empty($LaunchDeals)){
                  $keys['title']= $LaunchDeals->title;
                  $keys['sender_image']= '';

                  if(!empty($LaunchDeals->image)){
                    $keys['sender_image']= "/img/launchdeal/".$LaunchDeals->image;
                  }
                  
                  $keys['sender_bio']= $LaunchDeals->description;

                }else{ 
                  $keys['title']= 'Launch Deals ';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //Group Buying    
              }else if($UserFeed->type == 'feeds_purchaseorder_added' or $UserFeed->type == 'feeds_purchaseorder_following'){

                $data= json_decode($UserFeed->data);
                $this->loadModel('GroupBuyings');
                $GroupBuyings= $this->GroupBuyings->get($data->record_id);

                if(!empty($GroupBuyings)){
                  $keys['title']= $GroupBuyings->title;
                  $keys['sender_image']= '';

                  if(!empty($GroupBuyings->image)){
                    $keys['sender_image']= "/img/groupbuying/".$GroupBuyings->image;
                  }
                  
                  $keys['sender_bio']= $GroupBuyings->description;

                }else{
                  $keys['title']= 'Job';
                  $keys['sender_image']= '';
                  $keys['sender_bio']= '';
                }
            //custom feed    
              }else if($UserFeed->type == 'custom_feed'){

                
                $keys['title']= $UserFeed->sender->first_name.' '.$UserFeed->sender->last_name;
                
                if(!empty($UserFeed->sender->contractor_basic)){
                  $keys['sender_image']='';
                  if(!empty($UserFeed->sender->contractor_basic->image)){
                    $keys['sender_image']= "/img/profile_pic/".$UserFeed->sender->contractor_basic->image;
                  }
                }else{
                  $keys['sender_image']= '';
                }
                $keys['sender_bio']=$UserFeed->message;

              }else{

                $keys['title']= $UserFeed->sender->first_name.' '.$UserFeed->sender->last_name;

                  if(!empty($UserFeed->sender->contractor_basic)){
                    $keys['sender_bio']= $UserFeed->sender->contractor_basic->bio;
                    $keys['sender_image']='';
                    if(!empty($UserFeed->sender->contractor_basic->image)){
                      $keys['sender_image']= "/img/profile_pic/".$UserFeed->sender->contractor_basic->image;
                    }
                  }else{
                    $keys['sender_bio']= '';
                    $keys['sender_image']= '';
                  }

              }


              if(!empty($UserFeed->file1)){
                $keys['file1']='img/feed/'.$UserFeed->file1;
              }else{
                $keys['file1']='';
              }

              if(!empty($UserFeed->file2)){
                $keys['file2']='img/feed/'.$UserFeed->file2;
              }else{
                $keys['file2']='';
              }


              if(!empty($UserFeed->file3)){
                $keys['file3']='img/feed/'.$UserFeed->file3;
              }else{
                $keys['file3']='';
              }

              if(!empty($UserFeed->file4)){
                $keys['file4']='img/feed/'.$UserFeed->file4;
              }else{
                $keys['file4']='';
              }

              $ajaxfinalConnections[] = $keys;
            }

            $this->set('ajaxfinalConnections',$ajaxfinalConnections);
            $this->render('/Element/Front/ajaxfeeds');
            //$this->set('feedsLists',$this->paginate($finalConnections));

          }else{

            $this->set('feedsLists',$finalConnections);
          }
    }

    /***
    *
    * Feeds List
    *
    ****/
    public function news()
    {
        $this->paginate = ['limit' => 10,'order'=>['BlogPosts.id DESC']];
        $this->loadModel('BlogPosts');
        $UserId = $this->request->Session()->read('Auth.User.id');
        $widthClass ='';
        if(empty($UserId)){
          $widthClass ='notLogged';
        }
        $this->set('widthClass',$widthClass);
        $this->set('UserId',$UserId);   

        $UserId = $this->request->Session()->read('Auth.User.id');

        $BlogList = $this->BlogPosts->find('all',['conditions'=>['status'=>'publish','posted_to_cbs'=>1]]);
        $TotalItems=$BlogList->count();

        $this->set('TotalItems',$TotalItems);

        $BlogPosts= $this->paginate($BlogList);

        $this->set('BlogPostLists',$BlogPosts);

    }


}
?>