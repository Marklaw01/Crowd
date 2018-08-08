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

class SettingsController extends AppController
{
   
    
    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('RatingContents');
            
            $settings = $this->RatingContents->newEntity();
            $rs = $this->RatingContents->find('all')->first();

            if(!empty($rs)){
                $settings=$rs;
            }
            
            if($this->request->is('post') || $this->request->is('put')) { 

                
                $settings = $this->RatingContents->patchEntity($settings, $this->request->data);
                if(!empty($rs)){
                 $settings->id= $rs->id;
                }

                $result= $this->RatingContents->save($settings);
                if ($result) {
                    $this->Flash->success('Successfully saved.');
                    return $this->redirect($this->referer());
                }else{
                    $this->Flash->error('Can not update.');
                }
            }


            $this->set('settings',$settings); 
    }

    /**
    *  profileSetting for users
    *
    *
    *
    ****/
    function profileSetting()
    {   
        //$this->loadModel('ContractorSettings');
        $this->loadModel('Settings');
        $this->loadModel('AdminBetaSignupSettings');
        $user = $this->Auth->user();
        $UserId = $this->request->Session()->read('Auth.User.id');

        $user = $this->AdminBetaSignupSettings->newEntity();

        //Get beta signup users list
        $betaSignuplists= $this->AdminBetaSignupSettings->find('all',['conditions'=>['AdminBetaSignupSettings.status'=>1]])->toArray();
        $this->set('betaSignuplists',$betaSignuplists);

        $this->set('user',$user);
  
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

        $this->loadModel('AdminBetaSignupSettings');
        $this->loadModel('Settings');

        if($this->request->is('post'))
        {
            $user_id= $this->request->Session()->read('Auth.User.id');
            $this->request->data['user_id']=$user_id;
            $type= $this->request->data['type'];
            $status= $this->request->data['status'];

            if(!empty($status)){

                $registerBeta = $this->AdminBetaSignupSettings->newEntity(); 
                $registerBeta = $this->AdminBetaSignupSettings->patchEntity($registerBeta, $this->request->data);

                $betaExists= $this->AdminBetaSignupSettings->find('all',['conditions'=>['type' => $type]])->first();
              
                if(!empty($betaExists)){
                    $registerBeta->id=$betaExists->id;
                }
                $saveResult = $this->AdminBetaSignupSettings->save($registerBeta); 

                if($saveResult){
                    echo 'Setting saved successfully.';
                }else{
                    echo 'Could not setting save please try again.';
                } 

            }else{
                $registerBeta = $this->AdminBetaSignupSettings->newEntity(); 
                $registerBeta = $this->AdminBetaSignupSettings->patchEntity($registerBeta, $this->request->data);

                $likeExists= $this->AdminBetaSignupSettings->find('all',['conditions'=>['type' => $type]])->first();

                if(!empty($likeExists)){
                    $registerBeta->id=$likeExists->id;
                }

                $saveResult = $this->AdminBetaSignupSettings->save($registerBeta); 
                if($saveResult){
                    echo 'Setting saved successfully.';
                }else{
                    echo 'Could not setting save please try again.';
                }

            }
        }
    }

    /**
    *  add method for users
    *
    *
    *
    ****/
    function add()
    {
                    

    }



    /**
    *  edit method for users
    *
    *
    *
    ****/
    function edit($id=null)
    {
            
            

    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    function view($id=null)
    {       
            
            

    }

    

} 


?>
