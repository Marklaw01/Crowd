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

class VideoLinksController extends AppController
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
            $this->loadModel('VideoLinks');
            
            $this->paginate = ['limit' => 20];
            
            $blocks = $this->VideoLinks->find('all');
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
            $this->loadModel('VideoLinks');  
            $VideoLinks = $this->VideoLinks->newEntity();
            
            if($this->request->is('post')){ 
                $VideoLinks = $this->VideoLinks->patchEntity($VideoLinks, $this->request->data);
                
                $result= $this->VideoLinks->save($VideoLinks);
                
            }      
      
            $this->set('VideoLinks', $VideoLinks);
            
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
            $this->loadModel('VideoLinks');
            
            $user = $this->Auth->user(); 
            $VideoLinks = $this->VideoLinks->get($rId);
            if($user){
                    
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('put')){
 
                        $VideoLinks = $this->VideoLinks->patchEntity($VideoLinks,$this->request->data);
                        $VideoLinks->id=$VideoLinks->id;
                         
                        if($result = $this->VideoLinks->save($VideoLinks)){
                                $this->Flash->success('The VideoLink has been updated.');
                                return $this->redirect(['action' => 'index']);
                        }
                    }   

                } 
                $this->set('VideoLinks',$VideoLinks);
    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    function view($id=null)
    {
        $this->loadModel('VideoLinks');
        $userId= base64_decode($id);
        $VideoLinks = $this->VideoLinks->exists(['VideoLinks.id'=>$userId]);
        
        if (empty($VideoLinks)) {
            return $this->redirect(['action'=>'index']);
        }
        
        
        $VideoLinks = $this->VideoLinks->find('all',['conditions'=>['VideoLinks.id'=>$userId]])->first();
        $this->set('VideoLinks', $VideoLinks);
        
    }
    
} 


?>
