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
*
*
**/ 
class CompaniesController extends AppController
{   
    public $helpers = ['Custom'];

    public function initialize()
    {
        parent::initialize();
        $this->loadComponent('Upload');
        $this->loadComponent('UserImageWeb');
        $this->loadComponent('WebNotification');
        $this->loadComponent('Contractor');
    }


    /****
    *
    *  index Method
    *
    *
    *
    *******/
    public function index()
    {
      $this->loadModel('SubAdminDetails');
      $user = $this->Auth->user();  
      $UserId = $this->request->Session()->read('Auth.User.id');
      $this->paginate = [ 'limit' => 10,'order' => ['SubAdminDetails.id' => 'desc']];


          $searchKeyword=$this->request->query('search');
          //$searchKeyword = str_replace("'","",$searchKeyword);
          if (strpos($searchKeyword, "'") !== false) {
              $searchKeywordArray=explode("'", $searchKeyword);
              $searchKeyword=$searchKeywordArray[0];
          }
          
          //user should not be entrepreneur of a start up
          if(!empty($searchKeyword)){ 

              $companyLists= $this->SubAdminDetails->find('all',['conditions'=>['SubAdminDetails.company_name LIKE' => '%'.$searchKeyword.'%']])->contain(['Users'])->order(['SubAdminDetails.id DESC']);
          
          }else { 

              $companyLists= $this->SubAdminDetails->find('all')->contain(['Users'])->order(['SubAdminDetails.id DESC']);   
          } 

          $this->set('companyLists',$this->paginate($companyLists));

    }

    /**
     * view method
     *
     *
     *
     ***/
    public function view($id=null)
    {
            $this->loadModel('SubAdminDetails');
            $this->loadModel('JobPostingKeywords');
            $user = $this->Auth->user();  
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 10];

            $JobPostingKeywords =$this->JobPostingKeywords->find('list')->toArray();
            $this->set('JobPostingKeywords', $JobPostingKeywords);

            $companyId= base64_decode($id);

            $companyDetails= $this->SubAdminDetails->find('all',['conditions'=>['SubAdminDetails.id'=>$companyId]])->contain(['Users'])->first();

            $this->set('companyDetails', $companyDetails);
    }

    /**
     * view method
     *
     *
     *
     ***/
    public function companyVideo()
    {


    }

}

?>