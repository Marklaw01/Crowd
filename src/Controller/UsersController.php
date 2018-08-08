<?php
namespace App\Controller;

use App\Controller\AppController;
use Cake\ORM\TableRegistry;
use Cake\Filesystem\Folder;
use Cake\Filesystem\File;
use Cake\Database\Expression\QueryExpression;
use Cake\Mailer\Email;
use Cake\Routing\Router;
use Cake\Auth\DefaultPasswordHasher;

/**
* Users Controller
*
*@property\App\Model\Table\Users table $users
*/ 

class UsersController extends AppController
{
    public function initialize()
    {
      parent::initialize();
      $this->loadComponent('Captcha');
    }

    public function beforeFilter(\Cake\Event\Event $event)
    {
         $this->Auth->allow(['captcha','register','forgotPassword','login','getOptionsList','ConfirmEmail','forgotPasswordQuestion','ResetPassword','testmail','sendMail','termsAndConditions','privacyPolicy','resendConfirmation','getUserTimeZone']);
    }

    function captcha()  {
        $this->autoRender = false;
        //$this->loadComponent('Captcha'); //or load on the fly!
        $this->viewBuilder()->layout('ajax');
        $this->Captcha->create();
    }

   /**
    * INDEX Method
    *   
    * @return void
    *
    */

    public function index()
	{
        return $this->redirect(['controller'=>'contractors','action'=>'index']); 
		
	}

  /**
  * termsAndConditions Method
  *
  *
  *
  ****/
    public function termsAndConditions()
  {
         
    
  }

  /**
  *  
  *
  *
  */
    public function privacyPolicy()
  {
        
    
  }


	/*********************************************/
	/********     User Registration    ***********/
	/*********************************************/
	public function register()
    {
      if ($this->Auth->user())
        {
              $this->redirect('/contractors/dashboard');
        }
 
          $this->loadModel('Countries');
          /****** Fetching records from State table ******/
          $country_list = $this->Countries->find('list')->toArray();
          $this->set('countrylist',$country_list);    
          /*  Load the Question Model  */
          $this->loadModel('Questions');
          /****** Fetching records from Questions table ******/
          $question_list = $this->Questions->find('list',['conditions'=>['status'=>1]])->toArray();
          $this->set('questionlist',$question_list);
      
    $user = $this->Users->newEntity();

    if ($this->request->is('post')) { 
      //pr($this->request->data);die;
                  //$this->Users->setCaptcha('securitycode', $this->Captcha->getCode('securitycode'));

          $fullname=$this->request->data['first_name'].' '.$this->request->data['last_name'];
          $pass= $this->request->data['password'];
          $user = $this->Users->patchEntity($user, $this->request->data);
          $emailId=$this->request->data['email'];
          $user->status = 0; /* Insert status by default 1*/
          $user->role_id = 2; /* Insert role_id by default 2*/
          //$user->terms = 1;
          
          //$user->state = $this->request->data['state'];
          //$user->country = $this->request->data['country'];

          $user->state = '';
          $user->country = '';


            /*$phn1=$this->request->data['phoneno1'];
            $phn2=$this->request->data['phoneno2'];
            $phn3=$this->request->data['phoneno3'];*/

            //if(!empty($phn1) && !empty($phn2) && !empty($phn3)){
            /*if(!empty($phn1)){
                $this->request->data['phoneno']='1 ('.$phn1.') '.$phn2.'-'.$phn3;
            }else {
                 $this->request->data['phoneno']='';
            }*/
          
          //For saving multiple Questions of a User by using an array

          $preQuestions = $this->request->data['question_id'];
          $preQuestionsAnswer = $this->request->data['answer'];
          $arraylength = count($preQuestions);
          
          $preQdata = array();
              for($i=1; $i<=$arraylength; $i++){
                //check answer and q are not empty
                if(!empty($preQuestions[$i]) && !empty($preQuestionsAnswer[$i])){
                  $preQdata[] = array(
                          'id' => $preQuestions[$i],
                          'answer'=>$preQuestionsAnswer[$i],
                          );
                }
              } 
          //pr($preQdata);
          $preQdata=json_encode($preQdata);
          $user->predefined_questions = $preQdata;

          // Save Own questions 

          if (!empty($this->request->data['own_question'])) {

              $ownQuestions = $this->request->data['own_question'];
              $ownAnswer   = $this->request->data['own_answer'];
              $ownarraylength = count($ownQuestions);

              $ownQdata = array();
                  for($i=1; $i<=$ownarraylength; $i++){
                    //check answer and q are not empty
                      if(!empty($ownQuestions[$i]) && !empty($ownAnswer[$i])){
                        $ownQdata[] = array(
                            'id' => $ownQuestions[$i],
                            'answer'=>$ownAnswer[$i],
                        );
                      }  
                  }
            //pr($ownQdata);
            $ownQdata=json_encode($ownQdata);      
            $user->own_questions = $ownQdata;
            
             //pr($user);die;   
             // Commented for seprating values      
           }

           $token = bin2hex(openssl_random_pseudo_bytes(16));
           $url = Router::url(array("controller"=>"users","action"=>"ConfirmEmail/".$token),true);
           $user->token = $token;
         

          /* Save details of the user*/
          $QFlag = 0;
          if(empty($preQuestions[1]) or empty($preQuestionsAnswer[1])){
            //if(empty($this->request->data['own_question'])){
            if(empty($ownQuestions[1]) or empty($ownAnswer[1])){
              $QFlag = 0;
            }else{
              $QFlag = 1;
            }
          }else{
            $QFlag = 1;
          }

         if($QFlag == 0){
                  $this->Flash->error('Please slect atleast one question and answer.');
          }else {
              $result= $this->Users->save($user);
              if ($result) {
                      $lastInsertId =$result->id; 
                      $to = $emailId;

                      $name =$this->request->data['first_name'].' '.$this->request->data['last_name']; 
                      $username =$this->request->data['username'];
                      $password =$this->request->data['password'];  

                    require_once(ROOT . DS . 'webroot' . DS  . 'quickblox' . DS . 'php' . DS . 'resgister.php');

                  /// Save Quickblox id to user table
                  if($quickId != 'error'){

                      $query = $this->Users->query();
                      $query->update()
                          ->set(['quickbloxid' => $quickId])
                          ->where(['id' => $lastInsertId])
                          ->execute();
                      

                       $this->loadModel('Quickblox');
                       /// Save user password for quickblox login
                       $quickUseDetails = $this->Quickblox->newEntity();
                       $quickUseDetails->user_id=$lastInsertId;
                       $quickUseDetails->password=$pass;
                       $this->Quickblox->save($quickUseDetails);


                       /// Send mail to user
                       $email = new Email();
                       /*$email->from(['me@example.com' => 'Crowdbootstrap'])
                            ->to($to)
                            ->subject('Welcome to CrowdBootstrap')
                            ->send('Hi Welcome to Crowdbootstrap.'.$url);*/

                       $email->template('rgistration')
                            ->emailFormat('html')
                            ->from(['crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
                            ->to($to)
                            ->replyTo('crowdbootstrap@crowdbootstrap.com')
                            ->setHeaders(['MIME-Version: 1.0\n','Content-type: text/html; charset=iso 8859-1'])
                            ->subject('Crowd Bootstrap - Registration Confirmation') 
                            ->viewVars(['url' => $url, 'fullname' => $fullname])                  
                            ->send(); 
                        /*$email->from(['Crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
                              ->emailFormat('html')
                              ->to($to)
                              ->subject('Crowd Bootstrap - Registeration')                 
                              ->send('Dear '.$name.':<br /><br />
                                      Please click <a href="'.$url.'">"This Link"</a> to complete the registration process for the Crowd Bootstrap application.<br /><br />
                                      Alternatively, if the link above does not work, you can copy and paste the following URL into the address bar in your browser. This URL will also allow you to complete the registration process.<br /><br />
                                      '.$url.'<br /><br />

                                      Regards,<br /><br />
                                      Crowd Bootstrap Team ')   ;*/          
    
                      //$this->Flash->success('User has been successfully registered.');
                      $this->Flash->success('You are successfully registered. Please check your mail to activate your account.');
                      return $this->redirect(['action' => 'login']);    
                  }else {
                    $this->Users->deleteAll(['id'=>$lastInsertId]);
                    $this->Flash->error('User already exists.');
                    //return $this->redirect(['action' => 'login']);
                  }
                  

              } else {
                  $errors = $user->errors();
                    foreach($errors as $key=>$value){
                      foreach($value as $keytwo=>$message){
                        //$errorData[$key] = $message;
                        $this->Flash->error($message);
                      }
                    }
                    //$this->Flash->error(__($message));
              }
          }// Question mantory end     

    }
            
            $this->set('user', $user);

    }

    


    /**
     * Login Method
     *
     * Method is used to login user Using Auth Component
    */
    
    public function login(){
    
          if ($this->Auth->user()) {
                   $this->redirect(['controller'=>'contractors','action'=>'dashboard']);
          }
          if ($this->request->is('post')) {
            //$pass= $this->request->data['password'];
            //$this->request->data['email'] = $this->request->data['username'];
            //$user = $this->Auth->identify($this->request->data['email'],$this->request->data['password']);
    		    $user = $this->Auth->identify();
              if ($user) {            
                    if($user['role_id'] !== 1){
                            if($user['status'] !== 0){

                               $this->Auth->setUser($user);
                               $UserId = $this->request->Session()->read('Auth.User.id');

                               /*$this->loadModel('Quickblox');
                               $this->Quickblox->deleteAll(['user_id'=>$UserId]);

                               /// Save user password for quickblox login
                               $quickUseDetails = $this->Quickblox->newEntity();
                               $quickUseDetails->user_id=$UserId;
                               $quickUseDetails->password=$pass;
                               $this->Quickblox->save($quickUseDetails);*/

                                if($user['role_id']=='3'){
                                  return $this->redirect(['controller'=>'SubAdmins','action'=>'dashboard']);
                                }else{
                                  return $this->redirect(['controller'=>'Contractors','action'=>'news']);
                                }
                            }else {
                               $this->Flash->error('Your Account has not been activated, Please check your mail or Contact your Administrator');
                            }
                    }else{           
                       $this->Flash->error('You are not allowed to access this page.');           		    
                    }
              }else {
               $this->Flash->error('Your username or password is incorrect..');
              } 
          }
   }

    public function logout(){
        $UserId = $this->request->Session()->read('Auth.User.id');

        //$this->loadModel('Quickblox');
        //$this->Quickblox->deleteAll(['user_id'=>$UserId]);
        
        $this->Flash->success('You are now logged out.');
        return $this->redirect($this->Auth->logout());
    }
  /*
		This function will handle the forgot password functionality for front Users
	*/
   public function forgotPassword()
   {
      $user = $this->Users->newEntity();
        if($this->request->is('post')) {
          
          //$exists = $this->Users->exists(['email' => $this->request->data['email'], 'status' => 1]);
          $exists = $this->Users->exists(['email' => $this->request->data['email']]);
          if($exists) {
             $Email= base64_encode($this->request->data['email']);
             $this->redirect(['action' => 'forgotPasswordQuestion',$Email]);
          }else {
            $this->Flash->error(__('Please enter your registered email.'));
          }
        }
        
     // $this->set('data',$dataArray);
      $this->set(compact('user'));
      $this->set('_serialize', ['user']);

  }

  public function resendConfirmation()
  { 
    $this->loadModel('Users');
    $user = $this->Users->newEntity();

    if($this->request->is('post')) 
    {   

      $user = $this->Users->patchEntity($user, $this->request->data,['validate' => 'resendConfirmation']);
      $errors = $user->errors();
      if(empty($errors))
      {
        $exists = $this->Users->exists(['email' => $this->request->data['email']]);
        if($exists)
        {
            $users = $this->Users->find('all',['conditions'=>['Users.email'=>$this->request->data['email']]])->first();

            if(!empty($users['token']))
            {
                  
                  $fullname=$users['first_name'].' '.$users['last_name'];
                  $to = $this->request->data['email'];
                  $token = $users['token'];
                  $url = Router::url(array("controller"=>"users","action"=>"ConfirmEmail/".$token),true);
                  $email = new Email();
            
                  $email->template('rgistration')
                     ->emailFormat('html')
                     ->from(['crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
                     ->to($to)
                     ->replyTo('crowdbootstrap@crowdbootstrap.com')
                               ->setHeaders(['MIME-Version: 1.0\n','Content-type: text/html; charset=iso 8859-1'])
                     ->subject('Crowd Bootstrap - Registration Confirmation') 
                     ->viewVars(['url' => $url, 'fullname' => $fullname])                  
                     ->send(); 

                     $this->redirect(['action' => 'login']);
                     $this->Flash->success('We have sent an email that contains the confirmation link to your email address.');


            }else{

                  $fullname=$users['first_name'].' '.$users['last_name'];
                  $to = $this->request->data['email'];
                  $token = bin2hex(openssl_random_pseudo_bytes(16));
                  $url = Router::url(array("controller"=>"users","action"=>"ConfirmEmail/".$token),true);

                  $userTable=$this->loadModel('Users');
                  $query = $userTable->query();
                      $save = $query->update()
                                    ->set(['token' => $token])
                                    ->where(['id' => $users['id']])
                                    ->execute();
                  if($save){  
                    $email = new Email();

                    $email->template('rgistration')
                     ->emailFormat('html')
                     ->from(['crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
                     ->to($to)
                     ->replyTo('crowdbootstrap@crowdbootstrap.com')
                               ->setHeaders(['MIME-Version: 1.0\n','Content-type: text/html; charset=iso 8859-1'])
                     ->subject('Crowd Bootstrap - Registration Confirmation') 
                     ->viewVars(['url' => $url, 'fullname' => $fullname])                  
                     ->send();
                     
                     $this->redirect(['action' => 'login']);
                     $this->Flash->success('We have sent an email that contains the confirmation link to your email address.');
                  }    

            }

        }else{

          $this->Flash->error(__('Please enter your registered email.'));

        }
      }
    }  
    $this->set(compact('user'));
    $this->set('_serialize', ['user']);
  }

     /**
       Forgot password Question
    */
       public function forgotPasswordQuestion($Email = null,$hit= null)
       {
          if(empty($Email) or $Email== null) {
           return $this->redirect(['action' => 'login']);
          }
         $user = $this->Users->newEntity();
         $emailId= base64_decode($Email);
         $questions='';
         $ownQshow='';
         $hidebutton='';
         $this->loadModel('RecoverPasswords');
         $users = $this->Users->find('all',['conditions'=>['Users.email'=>$emailId]])->toArray();
         //pr($user[0]->email);
        $userId=$users[0]['id'];
        $fullname=$users[0]['first_name'].' '.$users[0]['last_name'];

        $psshits= $users[0]['forgotpass_hits'];

        // Pre defined question array
        $prQ=  json_decode($users[0]['predefined_questions']);
        $CprQ= count($prQ);

        //Own Question array
        $ownQ=  json_decode($users[0]['own_questions']);
        $CownQ= count($ownQ);

        if($CprQ > $psshits){
             $qId=$prQ[$psshits]->id;
             $qAnswer=$prQ[$psshits]->answer;
             $questions = $this->Users->Questions->get($qId);
        }else{
          if(!empty($CownQ)){
             $ownhits = $psshits-$CprQ;
              if($CownQ > $ownhits){
                 $OwnqId =$ownQ[$ownhits]->id;
                 $OwnqAnswer = $ownQ[$ownhits]->answer;
              }else {
                //Check if hits are less then to three
                if($psshits > 200000000000000){
                  $this->Flash->error(__('Exceeded recover password limit Please contact site administrator.'));
                  $hidebutton=1;
                }else {
                  $qId=$prQ[0]->id;
                  $qAnswer=$prQ[0]->answer;
                  $questions = $this->Users->Questions->get($qId);
                }

              }

           } else {
                //Check if hits are less then to three
               if($psshits > 200000000000000){
                  $this->Flash->error(__('Exceeded recover password limit Please contact site administrator.'));
                  $hidebutton=1;
                }else {
                  $qId=$prQ[0]->id;
                  $qAnswer=$prQ[0]->answer;
                  $questions = $this->Users->Questions->get($qId);
                }
               // $this->Flash->error(__('Please contact site administrator.'));
           } 
        }

        if(!empty($qId)){
          $matchQ=$qId;
          $matchA=$qAnswer;
        }
        if(!empty($OwnqId)){
          $matchQ=$OwnqId;
          $matchA=$OwnqAnswer;
        }  

        if($this->request->is(['patch', 'post', 'put'])) {
          $qI=$this->request->data['question'];
          $qA=trim($this->request->data['answer']);

          //Match question and answer
          $matchQuest= strcasecmp($matchQ,$qI);
          $matchAns= strcasecmp($matchA,$qA);
          
          //Check Question and answer are not blank
          if(!empty($qA) && !empty($qI)){
                      if($matchQuest == 0 && $matchAns == 0){
                            $token = bin2hex(openssl_random_pseudo_bytes(16));        
                            $user = $this->RecoverPasswords->patchEntity($user,[
                                         'user_id' =>$userId,
                                         'token'=>  $token,
                                         'status'=> 1]
                                        );
                            if ($this->RecoverPasswords->save($user)) {
                              $to = $emailId;
                              $email = new Email();
                              $url = Router::url(array("controller"=>"users","action"=>"ResetPassword/".$token),true); 
                              $rr = $url;
                             /* $email->from(['me@example.com' => 'Crowdbootstrap'])
                                    ->to($to)
                                    ->subject('CrowdBootstrap:ForgotPassword')
                                    ->send('Please click here given link below to reset new password '. $rr);*/
                              $email->template('reset')
                                    ->emailFormat('html')
                                    ->from(['crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
                                    ->to($to)
                                    ->replyTo('crowdbootstrap@crowdbootstrap.com')
                                    ->setHeaders(['MIME-Version: 1.0\n','Content-type: text/html; charset=iso 8859-1'])
                                    ->subject('Crowd Bootstrap - Reset Password') 
                                    ->viewVars(['url' => $rr, 'fullname' => $fullname])                  
                                    ->send();
                                    

                              $this->Flash->success(__('An email has been sent with link to change password at your Email Address.'));
                              return $this->redirect(['action' => 'login']);
                            }
                      } else {
                        if($psshits >= 2200000000000000){$stat=0;}else {$stat=1;}
                        $updateHits=  $this->Users->query()
                                      ->update()
                                      ->set(['forgotpass_hits' =>  $psshits + 1, 'status'=>$stat])
                                      ->where(['id' => $userId])
                                      ->execute();
                        if($updateHits){  
                          $this->redirect(['action' => 'forgotPasswordQuestion',$Email]);
                          $this->Flash->error(__('Wrong answer, Please enter correct answer.'));
                        }
                      }
            }else {
                $this->Flash->error(__('Question and Answer can not be blank.'));
            }

         }
         $this->set(compact('users','questions','OwnqId','hidebutton'));
         $this->set('_serialize', ['user']);
       }

   /*
    To change Password of user
  */
  public function ResetPassword(){

      $this->loadModel('RecoverPasswords');
      $flag = 1;
    // this will be used to check the if user is valid or not
      $token_id = $this->request->params['pass'][0];
      
    // User can not access this page without token_id...
    if($token_id === null){
      $flag = 0;      
    }else{
      // fetch the User details...
      $recover = $this->RecoverPasswords->find('all',['conditions' => ['RecoverPasswords.token' => $token_id]])->toArray();
      
      if(!empty($recover)){
        $update_id = $recover[0]['user_id'];
      }

      if(empty($recover)){
        $flag = 0;
      }
    }
     
    // It means user is not valid to see this page...
    if($flag === 0){
        $this->Flash->success(__('Please login to continue.'));
        return $this->redirect(array('controller' => 'users','action' => 'login'));
    }
   
    $user = $this->Users->newEntity();
    //$user = $this->Users->get($update_id);
    
    $recovers = TableRegistry::get('RecoverPasswords');
    
    $userupdate = $this->RecoverPasswords->newEntity();
    
    // Get email and old pass by id
     $userData = $this->Users->get($update_id);
     $fullname=$userData->first_name.' '.$userData->last_name;
     $EmailId=$userData->email;
     $oldpass= $userData->password;

    if ($this->request->is(['patch', 'post', 'put'])) {
                $user = $this->Users->patchEntity($user,[
                                        'id' => $update_id,
                                        'password1' => $this->request->data['password1'],
                                        'password2' => $this->request->data['password2']
                                        ],
                                        ['validate' => 'resetPass'
                                        ]);
                 
                 /// Match  old and new pass
                  $hasher = new DefaultPasswordHasher();
                  if ((new DefaultPasswordHasher)->check($this->request->data['password1'],$oldpass)) {
                    $PassFlag=1;
                  }else{
                    $PassFlag=0;
                  }
                
                 if($PassFlag == 1){
                         
                         $this->Flash->error(__('New password can not be same as old password.'));

                 }else {  
                         $user->password =$this->request->data['password1']; 
                         $user->id = $update_id;
                         $user->forgotpass_hits = 0;

                        if($this->Users->save($user)){
                               $query = $recovers->query();
                               $query->update()
                                  ->set(['status' => 0,'token' => false])
                                  ->where(['user_id' => $update_id])
                                  ->execute();
                          /// Send email if pass updated
                              $to = $EmailId;
                              $email = new Email();
                              /*$email->from(['me@example.com' => 'Crowdbootstrap'])
                                    ->to($to)
                                    ->subject('Crowdbootstrap:Updated Password')
                                    ->send('Hi You have just updated your password..');*/ 

                              $email->template('updatedpass')
                                    ->emailFormat('html')
                                    ->from(['crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
                                    ->to($to)
                                    ->replyTo('crowdbootstrap@crowdbootstrap.com')
                                    ->setHeaders(['MIME-Version: 1.0\n','Content-type: text/html; charset=iso 8859-1'])
                                    ->subject('Crowd Bootstrap - Updated Password') 
                                    ->viewVars(['fullname' => $fullname])                  
                                    ->send();
                                           
                                $this->Flash->success(__('The Password has been saved.'));
                                return $this->redirect(['action' => 'login']);

                        }else{
                              $this->Flash->error(__('The Password could not be saved.please try again'));
                        }

                  }/// Pass match with old end          
    }
   

            $this->set(compact('user'));
            $this->set('_serialize', ['user']);

  }

    /***
    *
    *
    *
    */
    public function ConfirmEmail($confrimToken = null){
          
          $this->viewBuilder()->layout(false);
          $this->render(false);
          $users = $this->Users->find('all',['conditions'=>['Users.token'=>$confrimToken]])->toArray();
          $count= count($users);
          if(!empty($count)){

             $emailid= $users[0]['email'];
             $fullname= $users[0]['first_name'].' '.$users[0]['last_name'];

             $user_id= $users[0]['id'];
                               $query = $this->Users->query();
                               $query->update()
                                  ->set(['status' => 1,'token' => false])
                                  ->where(['id' => $user_id])
                                  ->execute();
                  
                  $email = new Email();                
                  /*$email->from(['me@example.com' => 'Crowdbootstrap'])
                                    ->to($emailid)
                                    ->subject('CrowdBootstrap:Account Confirmed')
                                    ->send('Hi Your Account has been confirmed successfuly');*/

                  $email->template('confirmation')
                        ->emailFormat('html')
                        ->from(['crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
                        ->to($emailid)
                        ->replyTo('crowdbootstrap@crowdbootstrap.com')
                        ->setHeaders(['MIME-Version: 1.0\n','Content-type: text/html; charset=iso 8859-1'])
                        ->subject('Crowd Bootstrap - Registration Confirmed') 
                        ->viewVars(['fullname' => $fullname])                  
                        ->send();                  
                  $this->Flash->success(__('Your Account has been confirmed successfully, Please login.'));
                  
                  return $this->redirect(['action' => 'login']);                
          
          }else {

            $this->Flash->error(__('Your accout has already been activated.'));
            return $this->redirect(['action' => 'login']);

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
            $this->render('/Element/Front/ajaxstates');
            //$result = "<option value=".$question_id.">".$questionname."</option>";
            //echo $result; 
            die;
        }

    }
    
   /*function testmail()
   {
      $this->viewBuilder()->layout(false);
      $this->render(false);
      //echo getcwd(); die;
       
      $url = Router::url(array("controller"=>"users","action"=>"login"),true);
      //$emailid='vijay.kumar@chd.trantorinc.com';
      $emailid='leena.rohilla@trantorinc.com';
      //$email = new Email();                
      $email = new Email('default');
      $result = $email->from(['me@example.com' => 'My Site'])
          ->to($emailid)
          ->subject('About')
          ->send('My message');
      /*$result= $email->from(['Crowdbootstrap@crowdbootstrap.com' => 'Crowdbootstrap'])
                                    ->to($emailid)
                                    ->subject('CrowdBootstrap:Test Mail')
                                    ->send('This is test mail from live site to check subject is showing or not. Mail sent from '.$url);*/
    /*  if($result){
        echo 'Mail sent to '.$emailid; 
        echo '<br> Server IP : '.$_SERVER['SERVER_ADDR'];
        echo '<br>';
        echo getcwd();   
      } else {
        echo 'Can not send mail.';
      }                             

   }*/


 function testmail()
   {
      $this->viewBuilder()->layout(false);
      $this->render(false);
      // echo getcwd(); die;
       
      if(isset($_REQUEST['id'])){
        $emailid = $_REQUEST['id'];
      }else{
        $emailid='vijay.kumar@trantorinc.com';
      }

      $email = new Email();                
      $result= $email->from(['crowdbootstrap@crowdbootstrap.com' => 'Crowdbootstrap'])
                    ->to($emailid)
                    ->replyTo('crowdbootstrap@crowdbootstrap.com')
                    ->setHeaders(['MIME-Version: 1.0\n','Content-type: text/html; charset=iso 8859-1'])
                    ->subject('CrowdBootstrap:Registartion Mail')
                    ->send('This is mail from staging site. Mail sent from ');
      if($emailid){
        echo 'Mail sent to '.$emailid; 
        echo '<br> Server IP : '.$_SERVER['SERVER_ADDR'];
        echo '<br>';
        echo getcwd();   
      } else {
        echo 'Can not send mail.';
      }                             

   }

  public function sendMail(){

    $this->viewBuilder()->layout(false);
    $this->render(false);

    if(isset($_REQUEST['id'])){
      $to = $_REQUEST['id'];
    }else{
      $to = 'vijay.kumar@trantorinc.com';
    }
    
    $fullname = "Vijay Kumar";
    $token = bin2hex(openssl_random_pseudo_bytes(16)); 
    $url = Router::url(array("controller"=>"users","action"=>"login/".$token),true);


       $email = new Email();
       //$email->transport('default')
        $email->template('rgistration')
              ->emailFormat('html')
              ->from(['crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
              ->to($to)
              ->replyTo('crowdbootstrap@crowdbootstrap.com')
              ->returnPath('crowdbootstrap@crowdbootstrap.com')
              ->setHeaders(['Organization: Crowd Bootstrap\r\n','X-Mailer: PHP/'.phpversion().'\r\n','X-Priority: 3\r\n','MIME-Version: 1.0\r\n','Content-type: text/html; charset=iso-8859-1\r\n','Content-type: text/plain;','Content-type: image/png;'])
              ->subject('Crowd Bootstrap - Registration Confirmation') 
              ->viewVars(['url' => $url, 'fullname' => $fullname])                  
              ->send();

        if ($email) {
            echo 'Mail sent successfully.';
        }else{
            echo 'Could not send mail.';
        }      
       exit;
    }


    /**
    * Check user timeZone
    *
    ****/
    public function getUserTimeZone()
    {

      $this->viewBuilder()->layout(false);
      $this->render(false);

      $usertimeZone = 'UTC';
      $ip_address = getenv('HTTP_CLIENT_IP') ?: getenv('HTTP_X_FORWARDED_FOR') ?: getenv('HTTP_X_FORWARDED') ?: getenv('HTTP_FORWARDED_FOR') ?: getenv('HTTP_FORWARDED') ?: getenv('REMOTE_ADDR');

        // Get JSON object
        $jsondata = file_get_contents("http://timezoneapi.io/api/ip/?" . $ip_address);

        // Decode
        $data = json_decode($jsondata, true);

        // Request OK?
        if($data['meta']['code'] == '200'){

            // Example: Get the city parameter
            echo "Ip Address: " . $ip_address . "<br>";

            echo "City: " . $data['data']['city'] . "<br>";

            // Example: Get the users time
            echo "Time: " . $data['data']['datetime']['date_time_txt'] . "<br>";

            $usertimeZone = $data['data']['timezone']['id'];
            echo "Time Zone: " . $data['data']['timezone']['id'] . "<br>";

        }

        date_default_timezone_set($usertimeZone);
        echo date('e') . ' => ' . date('T');
    }

}           