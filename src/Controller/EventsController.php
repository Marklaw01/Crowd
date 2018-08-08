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
class EventsController extends AppController{

    public function initialize()
    {
    parent::initialize();
    $this->loadComponent('Upload');
    $this->loadComponent('UserImageWeb');
    }


   
    /**
    * index Method for list messages
    *
    *
    */

    public function index()
    {
        if ($this->Auth->user()) {
            $this->redirect(['action' => 'conferences']);
        }   
    }

  
    /**
    * conferences Method 
    *
    *
    */
    public function conferences()
    {
        
    }

    /**
    * demoDays Method
    *
    */

    public function demoDays()
    {
        
    }


    /**
    * meetUps Method
    *
    *
    */

    public function meetUps()
    {
            
    }


    /**
    * webinars Method
    *
    *
    *
    **/
    public function webinars()
    {
        
    }

}
?>