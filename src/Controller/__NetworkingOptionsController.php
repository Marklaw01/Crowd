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
**/ 
class NetworkingOptionsController extends AppController{

    public function initialize()
    {
        parent::initialize();
        $this->loadComponent('Upload');
        $this->loadComponent('UserImageWeb');
    }


   
    /**
    * index Method for list messages
    *
    */
    public function index()
    {
           
    }

  
    /**
    * Contacts Method 
    *
    */
    public function contacts()
    {
        
    }
    /**
    * Add Contacts Method 
    *
    */
    public function addContacts()
    {
        
    }
    /**
    * My Contacts Method 
    *
    */
    public function myContacts()
    {
        
    }

    /**
    * launchDeals Method
    *
    */
    public function launchDeals()
    {
        
    }

}
?>