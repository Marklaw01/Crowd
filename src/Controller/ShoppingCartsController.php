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
class ShoppingCartsController extends AppController{

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
            $this->redirect(['action' => 'groupBuying']);
        }   
    }

  
    /**
    * groupBuying Method 
    *
    *
    */
    public function groupBuying()
    {
        
    }

    /**
    * launchDeals Method
    *
    */

    public function launchDeals()
    {
        
    }


    /**
    * productServiceExchange Method
    *
    *
    */

    public function productServiceExchange()
    {
            
    }


    /**
    * recommendedSuppliers Method
    *
    *
    */

    public function recommendedSuppliers()
    {
            
    }

    /**
    * cbsAppStore Method
    *
    *
    */

    public function cbsAppStore()
    {
            
    }

    /**
    * recommendedApps Method
    *
    *
    */

    public function recommendedApps()
    {
            
    }


}
?>