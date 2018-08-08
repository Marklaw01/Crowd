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

class DashboardController extends AppController
{
   
    /*public function beforeFilter(\Cake\Event\Event $event)
    {
         $this->Auth->allow(['index']);
    }*/

    public function beforeFilter(\Cake\Event\Event $event)
    {
         $this->Auth->allow(['login']);
    }
    
    /**
   	*  index method for Admin
   	*
   	*
   	*
   	****/
    function index()
    {

    	$this->viewBuilder()->layout('admin_default');
      
    }
    function dashboard(){
        $this->redirect(['action' => 'index']);
    }
   
}
?>
