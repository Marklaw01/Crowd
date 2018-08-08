<?php
namespace App\Controller\Admin;

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
   
    /*public function beforeFilter(\Cake\Event\Event $event)
    {
         $this->Auth->allow(['index']);
    }*/

    public function beforeFilter(\Cake\Event\Event $event)
    {
         $this->Auth->allow(['login','forgotpassword','resetpassword']);
    }
    
   	/**
   	*  Login method for Admin
   	*
   	*
   	*
   	****/
	  function login()
	  {  
       
          if ($this->Auth->user()) {
                return $this->redirect('/admin');
                //$this->redirect(['action'=>'index']);
          }
          if ($this->request->is('post')) {
            $user = $this->Auth->identify();
              if ($user) {            
                    if($user['role_id'] == 1){
                            if($user['status'] !== 0){

                               $this->Auth->setUser($user);
                               $UserId = $this->request->Session()->read('Auth.User.id');
                               return $this->redirect('/admin');
                              // return $this->redirect(['controller'=>'Admin','action'=>'index']); 
                            }else {
                               $this->Flash->error('Your Account has not been activated');
                            }
                    }else{           
                       $this->Flash->error('You are not allowed to access this page.');                   
                    }
              }else {
               $this->Flash->error('Your username or password is incorrect..');
              } 
          }
	  }

    /**
    *  Logout method for Admin
    *
    *
    *
    ****/
    public function logout()
    {   

        $this->Flash->success('Logged out successfully.');
        return $this->redirect($this->Auth->logout());
    }


    /****
    *
    * Forgot Password Method
    *
    *
    *********/
    public function forgotpassword()
    { 
      $this->loadModel('Users');
      $this->loadModel('RecoverPasswords');

      $user = $this->Users->newEntity();

        if($this->request->is('post')) 
        {
          
          //$exists = $this->Users->exists(['email' => $this->request->data['email'], 'status' => 1]);
          $exists = $this->Users->exists(['email' => $this->request->data['email'],'role_id'=>1]);
          if($exists) 
          {

            $users = $this->Users->find('all',['conditions'=>['Users.email'=>$this->request->data['email']]])->toArray();
            //pr($user[0]->email);
            $userId=$users[0]['id'];
            $fullname=$users[0]['first_name'].' '.$users[0]['last_name'];


            $token = bin2hex(openssl_random_pseudo_bytes(16));        
            $user = $this->RecoverPasswords->patchEntity($user,[
                         'user_id' =>$userId,
                         'token'=>  $token,
                         'status'=> 1]
                        );
            if ($this->RecoverPasswords->save($user)) 
            {

              $to = $this->request->data['email'];
              $email = new Email();
              $url = Router::url(array("controller"=>"users","action"=>"resetpassword/".$token),true); 
              $rr = $url;
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
              
          }else {
            $this->Flash->error(__('Please enter your registered email.'));
          }
          
        }
        
        // $this->set('data',$dataArray);
        $this->set(compact('user'));
        $this->set('_serialize', ['user']);
    }




    /*****
    *
    * Reset Password Method
    *
    *
    ******/
    public function resetpassword()
    {
        $this->loadModel('RecoverPasswords');
        $flag = 1;
        //this will be used to check the if user is valid or not
        $token_id = $this->request->params['pass'][0];
      
        //User can not access this page without token_id...
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
                                           
                                $this->Flash->success(__('The password has been updated successfully.'));
                                return $this->redirect(['action' => 'login']);

                        }else{
                              $this->Flash->error(__('The Password could not be saved.please try again'));
                        }

                  }/// Pass match with old end          
      }
     

              $this->set(compact('user'));
              $this->set('_serialize', ['user']);

    }

    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('Users');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $users = $this->Users->find('all')->contain(['Countries','States','Roles']);

            //pr($users->toArray()); die;
            $this->set('users', $this->paginate($users));

    }

    /**
    *  add method for users
    *
    *
    *
    ****/
    function add()
    {
              $this->loadModel('Countries');
              $country_list = $this->Countries->find('list')->toArray();
              $this->set('countrylist',$country_list);    

              $this->loadModel('Questions');
              $question_list = $this->Questions->find('list')->toArray();
              $this->set('questionlist',$question_list);

              $user = $this->Users->newEntity();

              if ($this->request->is('post')) { 
                  $fullname=$this->request->data['first_name'].' '.$this->request->data['last_name'];
                  $pass= $this->request->data['password'];
                  $user = $this->Users->patchEntity($user, $this->request->data);
                  $emailId=$this->request->data['email'];
                  $user->status = 0; /* Insert status by default 1*/
                  $user->role_id = 2; /* Insert role_id by default 2*/
                  $user->terms = 1;                  
                  $user->state = $this->request->data['state'];
                  $user->country = $this->request->data['country'];
                  
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
                  //  pr($ownQdata);
                    $ownQdata=json_encode($ownQdata);      
                    $user->own_questions = $ownQdata; 
                     // Commented for seprating values      
                   }
                   $token = bin2hex(openssl_random_pseudo_bytes(16));
                   $url = Router::url(array("controller"=>"users","action"=>"ConfirmEmail/".$token),true);
                   $user->token = $token;                 

                 /* Save details of the user*/
                 if(empty($preQuestions[1]) or empty($preQuestionsAnswer[1])){
                          $this->Flash->error('Please slect atleast one question.');
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
                               /*$email->template('rgistration')
                                    ->emailFormat('html')
                                    ->from(['Crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
                                    ->to($to)
                                    ->subject('Crowd Bootstrap - Registration Confirmation') 
                                    ->viewVars(['url' => $url, 'fullname' => $fullname])                  
                                    ->send(); */       
                              //$this->Flash->success('User has been successfully registered.');
                              $this->Flash->success('User successfully registered.');
                              return $this->redirect(['action' => 'index']);    
                          }else {
                            $this->Users->deleteAll(['id'=>$lastInsertId]);
                            $this->Flash->error('User already exists.');
                            //return $this->redirect(['action' => 'login']);
                          }
                          

                      } 
                  }// Question mantory end     

    }
            
            $this->set('user', $user);
            

    }



    /**
    *  edit method for users
    *
    *
    *
    ****/
    function edit()
    {
            $this->loadModel('Users');
            

    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    function view($id=null)
    {       
            $userId= base64_decode($id);
            $users = $this->Users->exists(['Users.id'=>$userId]);

            if (empty($users)) {
                return $this->redirect(['action'=>'index']);
            }

            
            $this->loadModel('Users');
            $users = $this->Users->find('all',['conditions'=>['Users.id'=>$userId]])->contain(['Countries','States','Roles'])->first();
            $this->set('users', $users);
            

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
            echo $this->render('/Element/Front/adminajaxstates');
            //$result = "<option value=".$question_id.">".$questionname."</option>";
            //echo $result; 
            die;
        }

    }

} 


?>
