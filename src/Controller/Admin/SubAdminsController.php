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

class SubAdminsController extends AppController
{
    
    public function initialize()
    {
        parent::initialize();
        $this->loadComponent('Feeds');
    }

    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('SubAdminDetails');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $users = $this->SubAdminDetails->find('all')->contain(['Users']);
            //pr($users->toArray()); die;
            $this->set('users', $this->paginate($users)); 

    }


    /**
    *  add method for users
    *
    *
    *
    */
    
    function add()
    {
              $this->loadModel('Users');
              $this->loadModel('SubAdminDetails');
              $userId = $this->request->Session()->read('Auth.User.id');

              $user = $this->Users->newEntity();
              
              if($this->request->is('post')){
                  
                  $user->status = 1; /* Insert status by default 1*/
                  $user->role_id = 3; /* Insert role_id by default 2*/
                  
                  $this->request->data['password'] =  'Xct-'.ucfirst(strtolower($this->request->data['username'])).'@'.rand('1','9999');
                  
                  //removing the validations of the user model dynamically
                        
                      $this->Users->validator()->remove('email');
                      $this->Users->validator()->remove('confirm_password');
                      //$this->Users->validator()->remove('first_name');
                      //$this->Users->validator()->remove('last_name');
                      $this->Users->validator()->remove('phoneno');
                      $this->Users->validator()->remove('date_of_birth');
                      $this->Users->validator()->remove('answer');
                      $this->Users->validator()->remove('question_id');
                      $this->Users->validator()->remove('country');
                      $this->Users->validator()->remove('city');
                      $this->Users->validator()->remove('terms');
                      $this->Users->validator()->remove('best_availablity');
                      $this->Users->validator()->remove('captcha_value');
                      
                      //echo '<pre>';
                      //print_r($this->request->data()); die;
                      $user = $this->Users->patchEntity($user, $this->request->data());

                        if($user->errors())
                        {
                        
                        //here we are getting the errors while validating the data
                            
                            $errors = $user->errors();
                            
                            foreach($errors as $key=>$error){
                                foreach($error as $errorKey=>$errorMessage){
                                        //$finalErrors[$key] = $errorMessage;
                                        $this->Flash->error($errorMessage);
                                }
                            }
                           
                        }else{
                                $result = $this->Users->save($user);

                                if($result){
                                     
                                     $user_id = $result->id;
                                     
                                    //saving the data in subadmin details table
                                     $SubAdminDetails['user_id'] = $user_id;
                                     $SubAdminDetails['company_name'] = $this->request->data['company_name'];
                                        
                                        $to = $this->request->data['email'];
                                        $password = $this->request->data['password'];

                                        $fullname= $this->request->data['first_name'].' '.$this->request->data['last_name'];
                                        
                                        $SubAdminDetails = $this->SubAdminDetails->newEntity($SubAdminDetails);
                                        
                                        $resultSave=$this->SubAdminDetails->save($SubAdminDetails);
                                        
                                        if($resultSave){
                                        //Save Feeds
                                        $this->Feeds->saveOrganizationFeeds($userId,'feeds_organization_added',$resultSave->id);

                                                $email = new Email();
                                                $email->template('addsubadmin')
                                                     ->emailFormat('html')
                                                     ->from(['Crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
                                                     ->to($to)
                                                     ->subject('Crowd Bootstrap - Sub Admin Login Details') 
                                                     ->viewVars(['email' => $to, 'password' => $password,'fullname'=>$fullname])                  
                                                     ->send();
                                                
                                        }
                                        
                                        $this->Flash->success(__('The SubAdmin has been created successfully.'));
                                        return $this->redirect($this->referer());
                                }else{
                                        $this->Flash->error(__('The SubAdmin has not been created.'));
                                        //return $this->redirect($this->referer());
                                }
                        }
                        
                }
        
        $this->set('user', $user);
        
    }

     /**
    *  add method for users
    *
    *
    *
    */
    
    function edit($id = null)
    {
              $this->loadModel('Users');
              $this->loadModel('SubAdminDetails');
              $LoggedUId = $this->request->Session()->read('Auth.User.id');

              $userId= base64_decode($id);
            
              $this->loadModel('SubAdminDetails');
              $users = $this->SubAdminDetails->find('all',['conditions'=>['SubAdminDetails.id'=>$userId]])->contain(['Users'])->first();
              $this->set('users', $users); 
              
              $user = $this->Users->newEntity();
              
              if($this->request->is('post')){
                $first_name=$this->request->data['first_name'];
                $last_name=$this->request->data['last_name'];
                $company_name=$this->request->data['company_name'];
                $status=$this->request->data['status'];

                if(!empty($first_name) && !empty($last_name)){
                  $query = $this->Users->query();
                  $result= $query->update()
                      ->set(['first_name'=>$first_name,'last_name'=>$last_name,'status'=>$status])
                      ->where(['id' => $users->user->id])
                      ->execute();
                }else{
                  $this->Flash->error(__('First and last name can not be left empty.'));
                }

                if(!empty($company_name)){
                    $query1 = $this->SubAdminDetails->query();
                    $result1= $query1->update()
                        ->set(['company_name'=>$company_name])
                        ->where(['id' => $userId])
                        ->execute();

                    //Save Feeds
                    $this->Feeds->saveOrganizationFeeds($LoggedUId,'feeds_organization_updated',$userId);

                  $this->Flash->success(__('Sub admin details has been updated successfully.')); 

                }else{
                  $this->Flash->error(__('Company name can not be left empty.'));
                }

                return $this->redirect($this->referer());

            }   
        $this->set('user', $user);
        
    }

    /**
     * 
     *
     *
     */
    public function delete($id = null)
    {
        $id = base64_decode($id);
        $this->loadModel('Users');
        $this->request->allowMethod(['post', 'delete']);
        $campaign = $this->Users->get($id);
        if ($this->Users->delete($campaign)) {
            $this->Flash->success('The sub admin has been deleted.');
        } else {
            $this->Flash->error('The sub admin could not be deleted. Please, try again.');
        }
        return $this->redirect($this->referer());
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
            
            $this->loadModel('SubAdminDetails');
            $users = $this->SubAdminDetails->find('all',['conditions'=>['SubAdminDetails.id'=>$userId]])->contain(['Users'])->first();
            $this->set('users', $users); 

    }

}
?>
