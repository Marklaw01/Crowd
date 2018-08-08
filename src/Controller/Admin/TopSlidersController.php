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

class TopSlidersController extends AppController
{
    
    /**
    *
    *  index method for get list of all users
    *
    *
    *
    ****/
    
    function index()
    {
            $this->loadModel('TopSliders');
            
            $this->paginate = ['limit' => 20];
            
            $TopSliders = $this->TopSliders->find('all');
            $this->set('TopSliders', $this->paginate($TopSliders));
    
    }
    
    /**
    *  add method for users
    *
    *
    *
    ****/
    function add()
    {
            $this->loadModel('TopSliders');  
            $TopSliders = $this->TopSliders->newEntity();
            
            if($this->request->is('post')){ 
                $TopSliders = $this->TopSliders->patchEntity($TopSliders, $this->request->data);
                
                $result= $this->TopSliders->save($TopSliders);
                
            }      
            
            $this->set('TopSliders', $TopSliders);
            
    }
    
    /**
    *  edit method for users
    *
    *
    *
    ****/
    function edit($id=null)
    {
            $rId= base64_decode($id);
            $this->loadModel('TopSliders');
            
            $user = $this->Auth->user(); 
            $TopSliders = $this->TopSliders->get($rId);
            if($user){
                    
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('put')){
 
                        $TopSliders = $this->TopSliders->patchEntity($TopSliders,$this->request->data);
                        $TopSliders->id=$TopSliders->id;
                        
                        if($result = $this->TopSliders->save($TopSliders)){
                                $this->Flash->success('The Block has been updated.');
                                return $this->redirect(['action' => 'index']);
                        }
                    }   

                } 
                $this->set('TopSliders',$TopSliders);
    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    function view($id=null)
    {
        $this->loadModel('TopSliders');
        $userId= base64_decode($id);
        $TopSliders = $this->TopSliders->exists(['TopSliders.id'=>$userId]);
        
        if (empty($TopSliders)) {
            return $this->redirect(['action'=>'index']);
        }
        
        
        $TopSliders = $this->TopSliders->find('all',['conditions'=>['TopSliders.id'=>$userId]])->first();
        $this->set('TopSliders', $TopSliders);
        
    }
    
} 


?>
