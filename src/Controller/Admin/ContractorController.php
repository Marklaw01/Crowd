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

class ContractorController extends AppController
{
   
    
    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('ContractorBasics');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $users = $this->ContractorBasics->find('all')->contain(['Users', 'Countries','States']);
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
            
            $userId= base64_decode($id);
            
            $this->loadModel('ContractorBasics');
            $users = $this->ContractorBasics->find('all',['conditions'=>['ContractorBasics.id'=>$userId]])->contain(['Countries','States'])->first();
            $this->set('users', $users); 

    }

    

} 


?>
