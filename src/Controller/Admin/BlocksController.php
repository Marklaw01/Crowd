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

class BlocksController extends AppController
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
            $this->loadModel('Blocks');
            
            $this->paginate = ['limit' => 20];
            
            $blocks = $this->Blocks->find('all');
            $this->set('blocks', $this->paginate($blocks));
    
    }
    
    /**
    *  add method for users
    *
    *
    *
    ****/
    function add()
    { 
            $this->loadModel('Blocks');  
            $Blocks = $this->Blocks->newEntity();
            
            if($this->request->is('post')){ 
                $Blocks = $this->Blocks->patchEntity($Blocks, $this->request->data);
                
                $result= $this->Blocks->save($Blocks);
                
            }      
      
            $this->set('Blocks', $Blocks);
            
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
            $this->loadModel('Blocks');
            
            $user = $this->Auth->user(); 
            $Blocks = $this->Blocks->get($rId);
            if($user){
                    
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('put')){
 
                        $Blocks = $this->Blocks->patchEntity($Blocks,$this->request->data);
                        $Blocks->id=$Blocks->id;
                         
                        if($result = $this->Blocks->save($Blocks)){
                                $this->Flash->success('The Block has been updated.');
                                return $this->redirect(['action' => 'index']);
                        }
                    }   

                } 
                $this->set('Blocks',$Blocks);
    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    function view($id=null)
    {
        $this->loadModel('Blocks');
        $userId= base64_decode($id);
        $Blocks = $this->Blocks->exists(['Blocks.id'=>$userId]);
        
        if (empty($Blocks)) {
            return $this->redirect(['action'=>'index']);
        }
        
        
        $Blocks = $this->Blocks->find('all',['conditions'=>['Blocks.id'=>$userId]])->first();
        $this->set('Blocks', $Blocks);
        
    }
    
} 


?>
