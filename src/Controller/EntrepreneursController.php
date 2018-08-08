<?php
namespace App\Controller;

use App\Controller\AppController;
use Cake\ORM\TableRegistry;
use Cake\Filesystem\Folder;
use Cake\Filesystem\File;
use Cake\Database\Expression\QueryExpression;
use Cake\Mailer\Email;
use Cake\Routing\Router;
/**
*Enterpreneur Controller
*
*@property\App\Model\Table\Users table $users
*/ 
class EntrepreneursController extends AppController{
    public function initialize()
    {
    parent::initialize();
    $this->loadComponent('Upload');
    $this->loadComponent('WebNotification');

    }
    public function beforeFilter(\Cake\Event\Event $event)
    {
         $this->Auth->allow(['dashboard']);
    }
    public function dashboard(){
        $this->loadModel('BottomSliders');
        $UserId = $this->request->Session()->read('Auth.User.id');
          $widthClass ='';
          if(empty($UserId)){
            $widthClass ='notLogged';
          }
          $this->set('widthClass',$widthClass);
          $this->set('UserId',$UserId);  

        $BottomSliders = $this->BottomSliders->find('all');
        $this->set('BottomSlidersData',$BottomSliders->toArray());

    }
    public function index(){
        if ($this->Auth->user()) {
             $this->redirect('/entrepreneurs/dashboard');
        }
    }

    /**
    * MyProfile Method for Enterpreneur Basics Profile edit
    *
    *
    */
    public function MyProfile()
    {
             $this->loadModel('Users');
             $this->loadModel('EntrepreneurBasics');
             $this->loadModel('ContractorBasics');
             $this->loadModel('Countries');
             $this->loadModel('States');
             $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

             $userEmail=$user['email'];
             $this->set('userEmail',$userEmail);

             if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    /// Get Rating
                    $ratingStar= $this->getRating($UserId);
                    $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
                    $proPercentage= $this->profilePercentage($UserId);
                    $this->set('proPercentage',$proPercentage);

                    //Get country List
                    $country_list = $this->Countries->find('list')->toArray();
                    $this->set('countrylist',$country_list);
                    $OldImage='';
                    /*To check detail of LoggedIn User in ContractorBasics Table for Image*/
                        $contractordata = $this->ContractorBasics->find('all', [
                            'conditions' => ['ContractorBasics.user_id' => $UserId]])->contain(['Countries','States']);
                        $contractordata = $contractordata->first();
                        if(!empty($contractordata)){
                            //Get user image from Contractor basic
                            if(!empty($contractordata['image'])){
                                $OldImage = $contractordata['image']; 
                            }
                        }

                    /// Check Logged user data is in Entrepreneur Basics table
                    $enterpreneurdata = $this->EntrepreneurBasics->find('all', ['conditions' => ['EntrepreneurBasics.user_id' => $UserId]]);
                    $enterpreneurdata =  $enterpreneurdata->first();

                    if(!empty($enterpreneurdata)){

                        if(!empty($enterpreneurdata['image'])){
                            $OldImage = $enterpreneurdata['image'];
                          
                        }
                        //get state list
                        $this->set('dc','');
                        $this->set('ds','');
                        $state_list = $this->States->find('list',['conditions'=>['States.country_id'=>$enterpreneurdata->country_id]])->toArray();
                        $this->set('statelist',$state_list);

                        $enterpreneurID = $enterpreneurdata->id;
                        $user = $this->EntrepreneurBasics->get($enterpreneurID);
                        $user['image']=$OldImage;
                        $this->set('user',$user);
                    
                    }else { 

                        // Get details from user table
                        $userdetail = $this->Users->get($UserId, ['contain' => '']);
                        $userdetail['image']=$OldImage;
                        //get state list
                        $this->set('dc',$userdetail->country);
                        $this->set('ds',$userdetail->state);
                        $state_list = $this->States->find('list',['conditions'=>['States.country_id'=>$userdetail->country]])->toArray();
                        $this->set('statelist',$state_list);
                        $this->set('user',$userdetail);
                    }

                    /******To Save Detail of user in EntrepreneurBasics Table******/
                    $user = $this->EntrepreneurBasics->newEntity();
                    if ($this->request->is(['patch', 'post', 'put'])) {

                            //Upload Image in Contractor Basic Table
                            if(!empty($this->request->data['image']['name'])){ 
                                   $data = [];
                                   $data = $this->request->data['image'];
                                   $data['module_type'] = 'profile_pic';
                                   $upload = $this->Upload->Upload($data); //call upload component to image Upload
                                if(!empty($upload) && (!empty($this->request->data['image']['error']) == 0)){
                                    //$user->image = $upload;
                                    $this->request->data['image']= $upload;
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

                            if(!empty($enterpreneurdata)){
                                $user->id = $enterpreneurID;/*To Check LogIn Id exist in ContractorBasics Table */
                            }
                            $user->user_id = $UserId;
                            $user->email = $userEmail;  
                            //$user->phoneno =$this->request->data['phoneno'];
                            $user->date_of_birth =$this->request->data['date_of_birth'];  
                            $user->image=$this->request->data['image'];

                            /*$phn1=$this->request->data['phoneno1'];
                            $phn2=$this->request->data['phoneno2'];
                            $phn3=$this->request->data['phoneno3'];

                            //if(!empty($phn1) && !empty($phn2) && !empty($phn3)){
                            if(!empty($phn1)){
                              $this->request->data['phoneno']='1 ('.$phn1.') '.$phn2.'-'.$phn3;
                            }else {
                              $this->request->data['phoneno']='';
                            }*/
                            
                                /*Data update in EntrepreneurBasic Table */
                                $user = $this->EntrepreneurBasics->patchEntity($user, $this->request->data);
                                //pr($user); die;
                                /* Save Basic Details of the user*/
                                if ($this->EntrepreneurBasics->save($user)) {
                                        /*Update Data in users table with Respective ID */ 
                                    $this->Flash->success(__('The Entrepreneur Details have been saved.'));
                                    return $this->redirect($this->referer());
                             
                                }else {
                                    $errors = $user->errors();
                                    foreach($errors as $key=>$value){
                                      foreach($value as $keytwo=>$message){
                                        //$errorData[$key] = $message;
                                        $this->Flash->error(__($message));
                                      }
                                    }
                                    //$this->Flash->error(__('The Enterpreneur could not be saved. Please, try again.'));
                                }
                                        
                    }
             }


    }

    /**
    * View Profile Method for Enterpreneur Basics Profile 
    *
    *
    */
    public function viewProfile($id=null,$starupId=null)
    {
             $viewUserId = base64_decode($id);
             $this->set('viewUserId', $id);

             $this->loadModel('Users');
             $this->loadModel('EntrepreneurBasics');
             $this->loadModel('ContractorBasics');
             $this->loadModel('Countries');
             $this->loadModel('States');
             $this->loadModel('StartupTeams');
             $this->loadModel('Startups');
             $this->loadModel('userFollowers');

             $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

             $UserId = $this->request->Session()->read('Auth.User.id');
             $LoggedUserId = $this->request->Session()->read('Auth.User.id');

             $userBasic = $this->EntrepreneurBasics->find('all', [
                            'conditions' => ['EntrepreneurBasics.user_id' => $LoggedUserId]])->first();
             if(!empty($userBasic)){
                $logedUseName=$userBasic->first_name.' '.$userBasic->last_name;
             }else {
                $userUsers = $this->Users->get($LoggedUserId);

                $logedUseName=$userUsers->first_name.' '.$userUsers->last_name;
             }
             $this->set('logedUseName',$logedUseName);



             $viewUserId = base64_decode($id);
             $validUserId = $this->Users->exists(['id'=>$viewUserId]);
             if($validUserId == 1){
                   // $UserId=$viewUserId;
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

             //Check startid and user exists in teamTable
             
             $RatingStarupId = base64_decode($starupId);

             if(!empty($starupId)){
                     $startupDetails= $this->Startups->get($RatingStarupId);
                     $startUpUserId= $startupDetails->user_id;
                     $validHiredUser = $this->StartupTeams->exists(['startup_id' => $RatingStarupId, 'user_id'=>$UserId]);
                     
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

            //if logged user and view user id is same
             if($LoggedUserId == $viewUserId){

                $this->set('RatingStarupId', '');
                $this->set('viewUserId', '');
                $this->set('followStatus', '0');
             }



             if($user){
                    if(!empty($viewUserId)){
                        $UserId=$viewUserId;
                    }

                    /// Get Rating
                    $ratingStar= $this->getRating($UserId);
                    $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
                    $proPercentage= $this->profilePercentage($UserId);
                    $this->set('proPercentage',$proPercentage);

                    //Get country List
                    $country_list = $this->Countries->find('list')->toArray();
                    $this->set('countrylist',$country_list);

                    /*To check detail of LoggedIn User in ContractorBasics Table for Image*/
                    $OldImage='';
                        $contractordata = $this->ContractorBasics->find('all', [
                            'conditions' => ['ContractorBasics.user_id' => $UserId]])->contain(['Countries','States']);
                        $contractordata = $contractordata->first();
                        if(!empty($contractordata)){
                            //Get user image from Contractor basic
                            if(!empty($contractordata['image'])){
                                $OldImage = $contractordata['image']; 
                            }
                        }


                    /// Check Logged user data is in Entrepreneur Basics table
                    $enterpreneurdata = $this->EntrepreneurBasics->find('all', ['conditions' => ['EntrepreneurBasics.user_id' => $UserId]]);
                    $enterpreneurdata =  $enterpreneurdata->first();

                    if(!empty($enterpreneurdata)){

                        if(!empty($enterpreneurdata['image'])){
                            $OldImage = $enterpreneurdata['image'];
                          
                        }
                        //get state list
                        $this->set('dc','');
                        $this->set('ds','');
                        $state_list = $this->States->find('list',['conditions'=>['States.country_id'=>$enterpreneurdata->country_id]])->toArray();
                        $this->set('statelist',$state_list);

                        $enterpreneurID = $enterpreneurdata->id;
                        $user = $this->EntrepreneurBasics->get($enterpreneurID);
                        $user['image']=$OldImage;
                        $this->set('user',$user);
                        $userEmail=$user->email;
                    
                    }else { 

                        // Get details from user table
                        $userdetail = $this->Users->get($UserId, ['contain' => '']);
                        $userdetail['image']=$OldImage;
                        //get state list
                        $this->set('dc',$userdetail->country);
                        $this->set('ds',$userdetail->state);
                        $state_list = $this->States->find('list',['conditions'=>['States.country_id'=>$userdetail->country]])->toArray();
                        $this->set('statelist',$state_list);
                        $this->set('user',$userdetail);
                        $userEmail=$userdetail->email;
                    }

                    //$userEmail=$user['email'];
                    $this->set('userEmail',$userEmail);
                    
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

                $this->loadModel('EntrepreneurRatings');
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

                $excellenceAwards = $this->EntrepreneurRatings->find('all',['conditions'=>['EntrepreneurRatings.given_to'=>$UserId]])->contain(['Users']);

                $this->set('excellenceAwards', $this->paginate($excellenceAwards));

    }


    /*****
     *
     *  Add Contractor method
     *
     * 
     * 
     *
     *****/
    public function rateEntrepreneur($contractorId = null,$StartupId = null)
    {
              $this->loadModel('EntrepreneurRatings');
              $this->loadModel('Users');
              $this->loadModel('StartupTeams');
              $this->loadModel('Roadmaps');

                if(!empty($contractorId) && !empty($StartupId)){

                          $UserId = $this->request->Session()->read('Auth.User.id');

                          $this->set('contractorId', $contractorId);
                          $contractorId = base64_decode($contractorId);
                            
                          $this->set('StartupId', $StartupId);
                          $StartupId = base64_decode($StartupId);
                          

                          //$User = $this->Users->get($contractorId);
                          $User = $this->Users->find('all',['conditions' =>['Users.id'=>$contractorId]])->contain(['EntrepreneurBasics'])->first();

                          $this->set('User',$User);

                          //Check is user got hired for this startup or not
                          $checkUsUserHired = $this->StartupTeams->exists(['StartupTeams.startup_id' => $StartupId, 'StartupTeams.user_id'=>$UserId]);

                            if($checkUsUserHired == 1){

                                  $Startups = $this->StartupTeams->find('all',['conditions' =>['StartupTeams.user_id'=>$UserId,'StartupTeams.startup_id'=>$StartupId]])->contain(['Startups'])->first();
                                  $this->set('Startups',$Startups);

                                  $roadmaps = $this->Roadmaps->find('all')->toArray();
                                  $this->set('roadmaps', $roadmaps);

                                  //die;
                                  $Ratings = $this->EntrepreneurRatings->newEntity();

                                if($this->request->is('post','put')){
                                            /*$roadmap_id ='';
                                             if(!empty($this->request->data['deliverable'])){
                                               $roadmap_id = implode(',', $this->request->data['deliverable']);
                                             }*/
                                             
                                             $roadmap_id=$this->request->data['deliverable'];

                                             /// Update if rating is already given
                                             $Startups = $this->EntrepreneurRatings->find('all',['conditions' =>['EntrepreneurRatings.given_by'=>$UserId,'EntrepreneurRatings.given_to'=>$contractorId,'EntrepreneurRatings.startup_id'=>$StartupId,'EntrepreneurRatings.deliverable'=>$roadmap_id]])->first();

                                             

                                             $this->request->data['deliverable'] = $roadmap_id;
                                             $this->request->data['given_by'] = $UserId;
                                             $this->request->data['given_to'] = $contractorId;
                                             $this->request->data['startup_id'] = $StartupId;
                                             $this->request->data['status'] = 1;

                                            //pr($this->request->data); die;
                                            $Ratings = $this->EntrepreneurRatings->patchEntity($Ratings,$this->request->data);
                                                if(!empty($Startups)){
                                                    $Ratings->id = $Startups->id;
                                                 }

                                                if ($this->EntrepreneurRatings->save($Ratings)) {

                                                    //Save user notification
                                                      $values = [];
                                                      //,json_encode($values);
                                                    $link= Router::url(['controller' => 'Entrepreneurs', 'action' => 'excellenceAwards']);
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
                                return $this->redirect(['Controller'=>'Contractors','action' => 'searchContractors/']);
                            }      
                }else{

                    return $this->redirect(['Controller'=>'Contractors','action' => 'searchContractors/']);
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

                        $link= Router::url(['controller' => 'Entrepreneurs', 'action' => 'myProfile']);
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
                     //json_encode($values);

                    $link= Router::url(['controller' => 'Entrepreneurs', 'action' => 'myProfile']);
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
    * Professional Profile Method for Enterpreneur Basics Profile edit
    *
    *
    */
    public function ProfessionalProfile()
    {   
            $this->loadModel('EntrepreneurProfessionals');
            $this->loadModel('Users');
            $this->loadModel('ContractorBasics');
            $this->loadModel('EntrepreneurBasics');
            $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

                //Get Associated tables list
                 $Keywords = $this->EntrepreneurProfessionals->Keywords->find('list')->toArray();
                 $this->set('Keywords',$Keywords);

                 $Qualifications = $this->EntrepreneurProfessionals->Qualifications->find('list')->toArray();
                 $this->set('Qualifications',$Qualifications);

                 $Certifications = $this->EntrepreneurProfessionals->Certifications->find('list')->toArray();
                 $this->set('Certifications',$Certifications); 

                 $Skills = $this->EntrepreneurProfessionals->Skills->find('list')->toArray();
                 $this->set('Skills',$Skills);

            if($user){
                 $UserId = $this->request->Session()->read('Auth.User.id');

                        /// Get Rating
                        $ratingStar= $this->getRating($UserId);
                        $this->set('ratingStar',$ratingStar);

                        /// Get Percentage
                        $proPercentage= $this->profilePercentage($UserId);
                        $this->set('proPercentage',$proPercentage);
                     
                       /*To check detail of LoggedIn User in ContractorBasics Table for Image*/
                        $contractordata = $this->ContractorBasics->find('all', [
                            'conditions' => ['ContractorBasics.user_id' => $UserId]])->contain(['Countries','States']);
                        $contractordata = $contractordata->first();

                        
                        // Find details in Entrepreneur Basic Table
                        $professional_detail_basic = $this->EntrepreneurBasics->find('all',['conditions'=>['EntrepreneurBasics.user_id'=> $UserId]]);
                        $professional_detail_basic  =  $professional_detail_basic->first();


                        ///Set header image and name
                        $OldImage ='';
                        if(!empty($professional_detail_basic)){

                            if(!empty($professional_detail_basic['image'])){
                                $OldImage = $professional_detail_basic['image']; 
                            }
                            $profession_id = $professional_detail_basic->id;
                            $user =  $this->EntrepreneurBasics->get($profession_id);
                            $user['image']=$OldImage;
                            $this->set('user',$user);

                        }else if (!empty($contractordata)){

                            if(!empty($contractordata['image'])){
                                $OldImage = $contractordata['image']; 
                            }
                            $profession_id = $contractordata->id;
                            $user =  $this->ContractorBasics->get($profession_id);
                            $user['image']=$OldImage;
                            $this->set('user',$user);

                        }else{
                           $userdetail = $this->Users->get($UserId, ['contain' => '']);
                           $userdetail['image']=$OldImage;
                           $this->set('user',$userdetail);  
                        }


                    /// Entrepreneur Body Data
                    $professional_user = $this->EntrepreneurProfessionals->newEntity();

                    // Find details in Entrepreneur Professional Table
                        $professional_detail = $this->EntrepreneurProfessionals->find('all',['conditions'=>['EntrepreneurProfessionals.user_id'=> $UserId]]);
                        $professional_detail  =  $professional_detail->first();

                        if (!empty($professional_detail)){
                            $profession_id = $professional_detail->id;
                            $professional_user =  $this->EntrepreneurProfessionals->get($profession_id);
                            $this->set('professional_user',$professional_user); 
                        }

                    
                    //Save data to Entrepreneur Professionals Table
                    if($this->request->is(['patch','post','put'])){

                            // Make Comma seprated ids
                            $qualification='';
                            if(!empty($this->request->data['qualifications'])){
                              $qualification = implode(',', $this->request->data['qualifications']);
                            }
                            $skill ='';
                            if(!empty($this->request->data['skills'])){
                              $skill = implode(',', $this->request->data['skills']);
                            }
                            
                            $keyword ='';
                            if(!empty($this->request->data['keywords'])){
                              $keyword = implode(',', $this->request->data['keywords']);
                            }

                            //Upload Image in Contractor Basic Table
                            if(!empty($this->request->data['image']['name'])){ 
                                   $data = [];
                                   $data = $this->request->data['image'];
                                   $data['module_type'] = 'profile_pic';
                                   $upload = $this->Upload->Upload($data); //call upload component to image Upload
                                if(!empty($upload) && (!empty($this->request->data['image']['error']) == 0)){
                                    //$user->image = $upload;
                                    $this->request->data['image']= $upload;
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

                            if(!empty($professional_detail)){
                                 $professional_user->id = $profession_id;/*To Check LogIn Id exist in ContractorProfessionals Table */
                            }
                            

                          //Patch Data to save
                          $professional_user =  $this->EntrepreneurProfessionals->patchEntity($professional_user, $this->request->data); 

                          //Patch comma seprated ids
                            $professional_user->qualifications =$qualification;
                            $professional_user->skills =$skill;
                            $professional_user->keywords =$keyword;
                            $professional_user->user_id =$UserId;
                        
                        /* Save Professional Details of the user*/
                            if ($this->EntrepreneurProfessionals->save($professional_user)) {
                                $this->Flash->success('Your Professional Detail have been saved.');
                                return $this->redirect($this->referer());
                            }
                            else{
                                $this->Flash->error('Your Professional Detail could not be saved.Please,try again.');
                            }

                    }   
                 
                    $this->set('professional_user',$professional_user);
            }    

    }   


    /**
    * View Professional Profile Method for Enterpreneur Basics Profile 
    *
    *
    */
    public function viewProfessionalProfile($id=null,$starupId=null)
    {   
            $viewUserId = base64_decode($id);
            $this->set('viewUserId', $id);

            $this->loadModel('EntrepreneurProfessionals');
            $this->loadModel('Users');
            $this->loadModel('ContractorBasics');
            $this->loadModel('EntrepreneurBasics');

             $this->loadModel('StartupTeams');
             $this->loadModel('Startups');
             $this->loadModel('userFollowers');

             $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

             $UserId = $this->request->Session()->read('Auth.User.id');
             $LoggedUserId = $this->request->Session()->read('Auth.User.id');

             /// Get loged user name
             $logedUserId = $this->request->Session()->read('Auth.User.id');
             $userBasic = $this->EntrepreneurBasics->find('all', [
                            'conditions' => ['EntrepreneurBasics.user_id' => $logedUserId]])->first();
             if(!empty($userBasic)){
                $logedUseName=$userBasic->first_name.' '.$userBasic->last_name;
             }else {
                $userUsers = $this->Users->get($logedUserId);
                $logedUseName=$userUsers->first_name.' '.$userUsers->last_name;
             }
             $this->set('logedUseName',$logedUseName);

                //Get Associated tables list
                 $Keywords = $this->EntrepreneurProfessionals->Keywords->find('list')->toArray();
                 $this->set('Keywords',$Keywords);

                 $Qualifications = $this->EntrepreneurProfessionals->Qualifications->find('list')->toArray();
                 $this->set('Qualifications',$Qualifications);

                 $Certifications = $this->EntrepreneurProfessionals->Certifications->find('list')->toArray();
                 $this->set('Certifications',$Certifications); 

                 $Skills = $this->EntrepreneurProfessionals->Skills->find('list')->toArray();
                 $this->set('Skills',$Skills);

            

             $viewUserId = base64_decode($id);
             $validUserId = $this->Users->exists(['id'=>$viewUserId]);
             if($validUserId == 1){
                   // $UserId=$viewUserId;
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

             //Check startid and user exists in teamTable
             
             $RatingStarupId = base64_decode($starupId);

             if(!empty($starupId)){
                     $startupDetails= $this->Startups->get($RatingStarupId);
                     $startUpUserId= $startupDetails->user_id;
                     $validHiredUser = $this->StartupTeams->exists(['startup_id' => $RatingStarupId, 'user_id'=>$UserId]);
                     
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

            //if logged user and view user id is same
             if($LoggedUserId == $viewUserId){

                $this->set('RatingStarupId', '');
                $this->set('viewUserId', '');
                $this->set('followStatus', '0');
             }




            if($user){
                    if(!empty($viewUserId)){
                        $UserId=$viewUserId;
                    }else {
                        $UserId = $this->request->Session()->read('Auth.User.id');
                    }

                        /// Get Rating
                        $ratingStar= $this->getRating($UserId);
                        $this->set('ratingStar',$ratingStar);

                        /// Get Percentage
                        $proPercentage= $this->profilePercentage($UserId);
                        $this->set('proPercentage',$proPercentage);
                     
                       /*To check detail of LoggedIn User in ContractorBasics Table for Image*/
                        $contractordata = $this->ContractorBasics->find('all', [
                            'conditions' => ['ContractorBasics.user_id' => $UserId]])->contain(['Countries','States']);
                        $contractordata = $contractordata->first();

                        
                        // Find details in Entrepreneur Basic Table
                        $professional_detail_basic = $this->EntrepreneurBasics->find('all',['conditions'=>['EntrepreneurBasics.user_id'=> $UserId]]);
                        $professional_detail_basic  =  $professional_detail_basic->first();


                        ///Set header image and name
                        $OldImage ='';
                        if(!empty($professional_detail_basic)){

                            if(!empty($professional_detail_basic['image'])){
                                $OldImage = $professional_detail_basic['image']; 
                            }
                            $profession_id = $professional_detail_basic->id;
                            $user =  $this->EntrepreneurBasics->get($profession_id);
                            $user['image']=$OldImage;
                            $this->set('user',$user);

                        }else if (!empty($contractordata)){

                            if(!empty($contractordata['image'])){
                                $OldImage = $contractordata['image']; 
                            }
                            $profession_id = $contractordata->id;
                            $user =  $this->ContractorBasics->get($profession_id);
                            $user['image']=$OldImage;
                            $this->set('user',$user);

                        }else{
                           $userdetail = $this->Users->get($UserId, ['contain' => '']);
                           $userdetail['image']=$OldImage;
                           $this->set('user',$userdetail);  
                        }


                    /// Entrepreneur Body Data
                    $professional_user = $this->EntrepreneurProfessionals->newEntity();

                    // Find details in Entrepreneur Professional Table
                        $professional_detail = $this->EntrepreneurProfessionals->find('all',['conditions'=>['EntrepreneurProfessionals.user_id'=> $UserId]]);
                        $professional_detail  =  $professional_detail->first();

                        if (!empty($professional_detail)){
                            $profession_id = $professional_detail->id;
                            $professional_user =  $this->EntrepreneurProfessionals->get($profession_id);
                            $this->set('professional_user',$professional_user); 
                        }   
                 
                    $this->set('professional_user',$professional_user);
            }    

    }

    
    /* 
    * List Startup Method Enrepreneur Startups
    *
    *
    */
    public function listStartup()
    {
            $this->loadModel('Startups');
            $this->loadModel('Users');
            $this->loadModel('ContractorBasics');
            $this->loadModel('EntrepreneurBasics');
            $this->loadModel('StartupListEntrepreneurProfiles');
            $user = $this->Auth->user();    
            
            if($user){
                
                $UserId = $this->request->Session()->read('Auth.User.id');

                    /// Get Rating
                    $ratingStar= $this->getRating($UserId);
                    $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
                    $proPercentage= $this->profilePercentage($UserId);
                    $this->set('proPercentage',$proPercentage);

                   /*To check detail of LoggedIn User in ContractorBasics Table */
                    $entrepreneurdata = $this->EntrepreneurBasics->find('all', [
                        'conditions' => ['EntrepreneurBasics.user_id' => $UserId]]);
                    $entrepreneurdata = $entrepreneurdata->first();

                   /*To check detail of LoggedIn User in ContractorBasics Table */
                    $contractordata = $this->ContractorBasics->find('all', [
                        'conditions' => ['ContractorBasics.user_id' => $UserId]]);
                    $contractordata = $contractordata->first();

                    $OldImage ='';
                    if(!empty($entrepreneurdata)){

                        //Get user image
                        if(!empty($entrepreneurdata['image'])){
                            $OldImage = $entrepreneurdata['image']; 
                        }
                        
                        $contractorID = $entrepreneurdata->id;
                        $user = $this->EntrepreneurBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $user['image']=$OldImage;
                        $this->set('user',$user);

                    }else if(!empty($contractordata)){
                        //Get user image
                        if(!empty($contractordata['image'])){
                            $OldImage = $contractordata['image']; 
                        }
                        
                        $contractorID = $contractordata->id;
                        $user = $this->ContractorBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $user['image']=$OldImage;
                        $this->set('user',$user);

                    }else {

                        $user = $this->Users->get($UserId); // Get record from Users Table
                        $user['image']=$OldImage;
                        $this->set('user',$user);
                    }


                    /*To check detail of LoggedIn User in Statrtup team Table */
                    $startupTeamData = $this->StartupListEntrepreneurProfiles->find('all', [
                        'conditions' => ['StartupListEntrepreneurProfiles.user_id' => $UserId]]);
                    $startupTeamData = $startupTeamData->first();
                    
                    $selectedIds=array();

                    
                    //pr($startupTeamData->startup_id);die;
                    
                    if(!empty($startupTeamData)){
                            //$startupdata = $this->Startups->StartupTeams->find('all',['conditions'=>['StartupTeams.user_id'=>$UserId]])->contain(['Startups'])->toArray();
                            $values = $startupTeamData->startup_id;
                            if(!empty($values)){
                             $selectedIds= explode(',', $values);
                            }
                            $startupdata = $this->Startups->find('all',[
                            'conditions' => ['Startups.user_id' => $UserId]])->toArray();                             
                    }else {
                        $startupdata='';
                    }                                                                  
                    /*To check detail of LoggedIn User in Startups Table */
                    //$startupdata = $this->Startups->find('all', [
                        //'conditions' => ['Startups.user_id' => $UserId]])->toArray();
                    //pr($startupdata);die;
                    $this->set('selectedIds',$selectedIds);
                    $this->set('startupdata',$startupdata);

        }
    }


    /***
    *
    *  Add Startup List to profile
    *
    *
    *
    *
    *
    ****/
    public function addStartupList()
    {
            $this->loadModel('Users');
            $this->loadModel('Startups');
            $this->loadModel('StartupListEntrepreneurProfiles');
            $user = $this->Auth->user();  

            if($user){
                
               $UserId = $this->request->Session()->read('Auth.User.id');
               $user = $this->StartupListEntrepreneurProfiles->newEntity();

               /*To check detail of LoggedIn User in Statrtup team Table */
                    $startupdata = $this->Startups->find('all', [
                        'conditions' => ['Startups.user_id' => $UserId]])->toArray();

                   
                    $this->set('startupdata',$startupdata);


                    //Check data in StartupListEntrepreneurProfiles Table
                    $startupListdata = $this->StartupListEntrepreneurProfiles->find('all', [
                        'conditions' => ['StartupListEntrepreneurProfiles.user_id' => $UserId]]);
                    $startupListdata = $startupListdata->first();

                    
                    if(!empty($startupListdata)){
                       $StartupListProfilesId =$startupListdata->id; 
                       $startup_profileData =  $this->StartupListEntrepreneurProfiles->get($StartupListProfilesId);
                       $this->set('startup_profileData',$startup_profileData); 

                    }else {$this->set('startup_profileData',''); }



                    if($this->request->is('Post')){

                        $startup_id='';
                        if(!empty($this->request->data['startup_id'])){
                          $startup_id = implode(',', $this->request->data['startup_id']);
                        }

                        $user = $this->StartupListEntrepreneurProfiles->patchEntity($user,$this->request->data); 
                        $user->user_id = $UserId;
                        $user->startup_id = $startup_id;


                        // Update id
                        if(!empty($startupListdata)){
                             $user->id = $StartupListProfilesId;
                        }
                       // pr($user);die;
                            if($this->StartupListEntrepreneurProfiles->save($user)){
                                 $this->Flash->success(__('The Startup has been saved.'));
                                 return $this->redirect($this->referer());
                            }else {
                                pr($user->error);die;
                                 $this->Flash->error(__('The Startups could not be saved. Please, try again.'));
                            }    
     
                    }

                    $this->set('user',$user);

            }       
     
     }


    /* 
    * View List Startup Method Enrepreneur Startups
    *
    *
    */
    public function viewListStartup($id=null,$starupId=null)
    {
            $viewUserId = base64_decode($id);
            $this->set('viewUserId', $id);
            
            $this->loadModel('Startups');
            $this->loadModel('Users');
            $this->loadModel('ContractorBasics');
            $this->loadModel('EntrepreneurBasics');
            $this->loadModel('StartupListEntrepreneurProfiles');
            
             $this->loadModel('StartupTeams');
             $this->loadModel('Startups');
             $this->loadModel('userFollowers');

             $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

             $UserId = $this->request->Session()->read('Auth.User.id');
             $LoggedUserId = $this->request->Session()->read('Auth.User.id');

            /// Get loged user name
             $logedUserId = $this->request->Session()->read('Auth.User.id');
             $userBasic = $this->EntrepreneurBasics->find('all', [
                            'conditions' => ['EntrepreneurBasics.user_id' => $logedUserId]])->first();
             if(!empty($userBasic)){
                $logedUseName=$userBasic->first_name.' '.$userBasic->last_name;
             }else {
                $userUsers = $this->Users->get($logedUserId);
                $logedUseName=$userUsers->first_name.' '.$userUsers->last_name;
             }
             $this->set('logedUseName',$logedUseName);
            
            
             $viewUserId = base64_decode($id);
             $validUserId = $this->Users->exists(['id'=>$viewUserId]);
             if($validUserId == 1){
                   // $UserId=$viewUserId;
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

             //Check startid and user exists in teamTable
             
             $RatingStarupId = base64_decode($starupId);

             if(!empty($starupId)){
                     $startupDetails= $this->Startups->get($RatingStarupId);
                     $startUpUserId= $startupDetails->user_id;
                     $validHiredUser = $this->StartupTeams->exists(['startup_id' => $RatingStarupId, 'user_id'=>$UserId]);
                     
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

            //if logged user and view user id is same
             if($LoggedUserId == $viewUserId){

                $this->set('RatingStarupId', '');
                $this->set('viewUserId', '');
                $this->set('followStatus', '0');
             }


            if($user){
                
                    if(!empty($viewUserId)){
                        $UserId=$viewUserId;
                    }else {
                        $UserId = $this->request->Session()->read('Auth.User.id');
                    }

                    /// Get Rating
                    $ratingStar= $this->getRating($UserId);
                    $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
                    $proPercentage= $this->profilePercentage($UserId);
                    $this->set('proPercentage',$proPercentage);

                   /*To check detail of LoggedIn User in ContractorBasics Table */
                    $entrepreneurdata = $this->EntrepreneurBasics->find('all', [
                        'conditions' => ['EntrepreneurBasics.user_id' => $UserId]]);
                    $entrepreneurdata = $entrepreneurdata->first();

                   /*To check detail of LoggedIn User in ContractorBasics Table */
                    $contractordata = $this->ContractorBasics->find('all', [
                        'conditions' => ['ContractorBasics.user_id' => $UserId]]);
                    $contractordata = $contractordata->first();

                    $OldImage ='';
                    if(!empty($entrepreneurdata)){

                        //Get user image
                        if(!empty($entrepreneurdata['image'])){
                            $OldImage = $entrepreneurdata['image']; 
                        }
                        
                        $contractorID = $entrepreneurdata->id;
                        $user = $this->EntrepreneurBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $user['image']=$OldImage;
                        $this->set('user',$user);

                    }else if(!empty($contractordata)){
                        //Get user image
                        if(!empty($contractordata['image'])){
                            $OldImage = $contractordata['image']; 
                        }
                        
                        $contractorID = $contractordata->id;
                        $user = $this->ContractorBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $user['image']=$OldImage;
                        $this->set('user',$user);

                    }else {

                        $user = $this->Users->get($UserId); // Get record from Users Table
                        $user['image']=$OldImage;
                        $this->set('user',$user);
                    }


                    /*To check detail of LoggedIn User in Statrtup team Table */
                    $startupTeamData = $this->StartupListEntrepreneurProfiles->find('all', [
                        'conditions' => ['StartupListEntrepreneurProfiles.user_id' => $UserId]]);
                    $startupTeamData = $startupTeamData->first();
                    
                    $selectedIds='';

                    
                    //pr($startupTeamData->startup_id);die;
                    
                    if(!empty($startupTeamData)){
                            //$startupdata = $this->Startups->StartupTeams->find('all',['conditions'=>['StartupTeams.user_id'=>$UserId]])->contain(['Startups'])->toArray();
                            $values = $startupTeamData->startup_id;
                            if(!empty($values)){
                             $selectedIds= explode(',', $values);
                            }
                            $startupdata = $this->Startups->find('all',[
                            'conditions' => ['Startups.user_id' => $UserId]])->toArray();                             
                    }else {
                        $startupdata='';
                    }                                                                  
                    /*To check detail of LoggedIn User in Startups Table */
                    //$startupdata = $this->Startups->find('all', [
                        //'conditions' => ['Startups.user_id' => $UserId]])->toArray();
                    //pr($startupdata);die;
                    $this->set('selectedIds',$selectedIds);
                    $this->set('startupdata',$startupdata);  

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
              $this->loadModel('EntrepreneurRatings');
              $user = $this->Auth->user();
              if($user){
                    //$UserId = $this->request->Session()->read('Auth.User.id');
                    $UserId= $UserId;

                    $countData = $this->EntrepreneurRatings->find('all',['conditions'=>['EntrepreneurRatings.given_to'=> $UserId]])->toArray();
                    $count= count($countData);
                    $ratingData = $this->EntrepreneurRatings->find('all',['conditions'=>['EntrepreneurRatings.given_to'=> $UserId]]);
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

              $this->loadModel('EntrepreneurBasics');
              $this->loadModel('EntrepreneurProfessionals');
              
              $user = $this->Auth->user();
              if($user){
                    //$UserId = $this->request->Session()->read('Auth.User.id');
                    $UserId= $UserId;
                                        
                    /// Entrepreneur Basics percentage
                    $entrepreneurdata = $this->EntrepreneurBasics->find('all', [
                        'conditions' => ['EntrepreneurBasics.user_id' => $UserId]]);
                    $entrepreneurdata = $entrepreneurdata->first();

                    $enpreMaxPoints = 100;
                    $enprePoint = 0;

                    if(!empty( $entrepreneurdata)){
                        if(!empty($entrepreneurdata->image)) $enprePoint+=20;
                        if(!empty($entrepreneurdata->bio)) $enprePoint+=20;
                        if(!empty($entrepreneurdata->first_name)) $enprePoint+=20;
                        if(!empty($entrepreneurdata->last_name)) $enprePoint+=20;
                        if(!empty($entrepreneurdata->date_of_birth)) $enprePoint+=20;
                        if(!empty($entrepreneurdata->phoneno)) $enprePoint+=20;
                        if(!empty($entrepreneurdata->country_id)) $enprePoint+=20;
                        if(!empty($entrepreneurdata->state_id)) $enprePoint+=20;
                        if(!empty($entrepreneurdata->my_interests)) $enprePoint+=20;

                    }
                    $entrepreneurPercentage = ($enprePoint*$enpreMaxPoints)/180;
                    //echo $entrepreneurPercentage."%"; 

                    /// Entrepreneur Professional percentage
                    $entrepreProfessional = $this->EntrepreneurProfessionals->find('all',['conditions'=>['EntrepreneurProfessionals.user_id'=> $UserId]]);
                    $entrepreProfessional = $entrepreProfessional->first();

                    $EntreproMaxPoints = 100;
                    $EntreproPoint = 0;
                    if(!empty( $entrepreProfessional)){
                        if(!empty($entrepreProfessional->company_name)) $EntreproPoint+=20;
                        if(!empty($entrepreProfessional->website_link)) $EntreproPoint+=20;
                        if(!empty($entrepreProfessional->description)) $EntreproPoint+=20;
                        if(!empty($entrepreProfessional->keywords)) $EntreproPoint+=20;
                        if(!empty($entrepreProfessional->qualifications)) $EntreproPoint+=20;
                        if(!empty($entrepreProfessional->skills)) $EntreproPoint+=20;
                        if(!empty($entrepreProfessional->industry_focus)) $EntreproPoint+=20;
                    }  

                    $EntreProfePercentage = ($EntreproPoint*$EntreproMaxPoints)/140;
                    //echo $EntreProfePercentage."%";
                    $finalPercentageEntrepreneur=($entrepreneurPercentage+$EntreProfePercentage)/2;
                    
                    /*  Over all profile percentage */
                    $overallPercentage= number_format((float)$finalPercentageEntrepreneur, 0, '.', ''); 

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
           // $this->loadModel('EntrepreneurSettings');
            $this->loadModel('Settings');
            $user = $this->Auth->user();

              if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');
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


    ///////////////////////////////////

    /* ViewBasicProfile
    *
    *
    */

    public function ViewBasicProfile(){
    $this->loadModel('Users');  
    $this->loadModel('EntrepreneurBasics');
    $this->loadModel('Questions');
    $this->loadModel('Countries');
    $user = $this->Auth->user();/* To Check User LoggedIn OR Not */
    if($user){
        $UserId = $this->request->Session()->read('Auth.User.id');
        /*To check detail of LoggedIn User in EnterpreneurBasics Table */
      $enterpreneurdata = $this->EntrepreneurBasics->find('all', [
            'conditions' => ['EntrepreneurBasics.user_id' => $UserId]])->contain(['Questions','States','Countries']);
        $enterpreneurdata = $enterpreneurdata->first();
        if(!empty($enterpreneurdata)){
            
            $this->set('enterpreneurdata',$enterpreneurdata);
        }
        else{
            $UserData = $this->Users->find('all',['conditions'=>['Users.id'=>$UserId]])->contain(['Questions','States','Countries']);
            $UserData = $UserData->first();
            $this->set('enterpreneurdata',$UserData);
        }
    }
    }

    /* This function will save Basic Info in EnterpreneurBasics Table*/
    public function MyProfile1(){
     $this->loadModel('Users');
     $this->loadModel('EntrepreneurBasics');
     $this->loadModel('Countries');
     $this->loadModel('States');
     $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

     $userEmail=$user['email'];
     $this->set('userEmail',$userEmail);
     if($user){
            $UserId = $this->request->Session()->read('Auth.User.id');

            $this->loadModel('Questions');
      /****** Fetching records from Questions table ******/
            $question_list = $this->Questions->find('list')->toArray();
            $this->set('questionlist',$question_list);
      /****** Fetching records from State table ******/
            $state_list = $this->States->find('list')->toArray();
            $this->set('statelist',$state_list);
       /***** Fetching records from country table *****/
            $country_list = $this->Countries->find('list')->toArray();
            $this->set('countrylist',$country_list);
        
        /*To check detail of LoggedIn User in ContractorBasics Table */
        //$enterpreneurdata = $this->EntrepreneurBasics->find('all', [
            //'conditions' => ['EntrepreneurBasics.user_id' => $UserId]])->contain([''States','Countries'']);
        $enterpreneurdata = $this->EntrepreneurBasics->find('all', [
            'conditions' => ['EntrepreneurBasics.user_id' => $UserId]]);
        
        $enterpreneurdata =  $enterpreneurdata->first();
        
        if(!empty($enterpreneurdata)){

        $enterpreneurID = $enterpreneurdata->id;
        /****** Fetching records from EntrepreneurBasics table with respective LoggedIn ID******/
        $user = $this->EntrepreneurBasics->get($enterpreneurID);
        $emailget = $user['email'];
        if(!empty($user['image'])){
            $OldImage = $user['image'];
          
        }
        $this->set('user',$user);
        }
       else{
         /****** Fetching records from User table with respective LoggedIn ID******/
        $userdetail = $this->Users->get($UserId, [
                'contain' => ''
            ]);
        $email = $userdetail['email'];
            
        $this->set('user',$userdetail);
        }
     
        /******To Save Detail of user in EntrepreneurBasics Table******/
        $user = $this->EntrepreneurBasics->newEntity();
     
        if(!empty($email)){
             $user->email = $email;
        }
        else{
              $user->email = $emailget;
            }
        
         
        if ($this->request->is(['patch', 'post', 'put'])) {
            //Upload Image in Contractor Basic Table
               $data = [];
               $data = $this->request->data['image'];
               $data['module_type'] = 'profile_pic';
               $upload = $this->Upload->Upload($data);//call upload compone to image Upload
            
            if(!empty($upload) && (!empty($this->request->data['image']['error']) == 0)){

                $this->request->data['image'] = $upload;
                if(!empty($OldImage)){
                       unlink(WWW_ROOT . 'img/profile_pic/' .$OldImage);
                }
            }
            else{
                if(!empty($OldImage)){
                        $filename =  $OldImage;
                        $this->request->data['image'] = $filename;
                    }
            } 
             
            if(!empty($enterpreneurdata)){
                 $user->id = $enterpreneurID;/*To Check LogIn Id exist in ContractorBasics Table */
            }
            $user->user_id = $UserId;
            /*Data update in EntrepreneurBasic Table */
            $user = $this->EntrepreneurBasics->patchEntity($user, $this->request->data);
            
            if(!empty($this->request->data['country'])){
            
                 $user->email = $user['email'];
                 $user->country = $this->request->data['country']; 
                 $user->state = $this->request->data['state'];
            }
            /* Save Basic Details of the user*/
            if ($this->EntrepreneurBasics->save($user)) {
                    /*Update Data in users table with Respective ID */ 
                $this->Flash->success(__('The Enterpreneur has been saved.'));
                return $this->redirect($this->referer());
         
            }else {
                    $this->Flash->error(__('The Enterpreneur could not be saved. Please, try again.'));
            }
        }

        }
    }

    public function ViewProfessionalProfile111(){
    $this->loadModel('EntrepreneurProfessionals');
    $this->loadModel('Questions');
    $this->loadModel('Countries');
    
    $user = $this->Auth->user();/* To Check User LoggedIn OR Not */
    
    if($user){
        $UserId = $this->request->Session()->read('Auth.User.id');
        /*To check detail of LoggedIn User in ContractorProfessionals Table */
        $professionaldata = $this->EntrepreneurProfessionals->find('all', [
            'conditions' => ['EntrepreneurProfessionals.user_id' => $UserId]]);
        $professionaldata = $professionaldata->first();
        //pr($contractordata);die;
        $this->set('professionaldata',$professionaldata);
    }
    }

    
    /* This function will handle search functionality to Contractor*/
    public function SearchContractor(){
    $this->loadModel('ContractorBasics');
    $user = $this->Auth->user();  
        
        if($user){
        $UserId = $this->request->Session()->read('Auth.User.id');
        /*To check detail of LoggedIn User in Startups Table */
        $ContractorBasic = $this->ContractorBasics->find('all')->select('first_name','price')->toArray();

        $ContractorProfessionals = $this->ContractorProfessionals->find('all')->select('id','user_id','skills')->toArray();

        //pr($contractor);die;
        $this->set('contractor',$contractor);

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
            //pr( $state );die;
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
        $this->loadModel('EntrepreneurBasics');
        if(!empty($this->request->data)){
            $ImageId = $this->request->data['image_id'];
           
            $EntrepreneurTable = TableRegistry::get('EntrepreneurBasics');
            $update = $this->EntrepreneurBasics->newEntity();
            $userupdate = $this->EntrepreneurBasics->patchEntity($update,[
                             'id' =>$ImageId
                             ]);
            $query = $EntrepreneurTable->query();
                    $query->update()
                         ->set([ 'image'=>false])
                         ->where(['id' => $ImageId])
                         ->execute();
            if($query == true){
                echo "Success";
            }
            
 
        }



    }
   
   









}
?>