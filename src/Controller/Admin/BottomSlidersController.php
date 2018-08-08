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

class BottomSlidersController extends AppController
{
    
    public function initialize()
    {
        parent::initialize(); 
		$this->loadComponent('Upload');  
    }
    
    /**
    *
    *  index method for get list of all users
    *
    *
    *
    ****/
    
    function index()
    {
            $this->loadModel('BottomSliders');
            
            $this->paginate = ['limit' => 20];
            
            $BottomSliders = $this->BottomSliders->find('all');
            $this->set('BottomSliders', $this->paginate($BottomSliders));
    
    }
    
    /**
    *  add method for users
    *
    *
    *
    ****/
    function add()
    {
            $this->loadModel('BottomSliders');  
            $BottomSliders = $this->BottomSliders->newEntity();
            
            if($this->request->is('post')){ 
                $BottomSliders = $this->BottomSliders->patchEntity($BottomSliders, $this->request->data);
                
                $result= $this->BottomSliders->save($BottomSliders);
            }      
            
            $this->set('BottomSliders', $BottomSliders);
            
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
            $this->loadModel('BottomSliders');
            
            $user = $this->Auth->user(); 
            $BottomSliders = $this->BottomSliders->get($rId);
             
            if($user){
                    
                    $UserId = $this->request->Session()->read('Auth.User.id');
                    
                    if($this->request->is('put')){
                        
                        if(!empty($BottomSliders)):
							$BottomSlider = $BottomSliders->toArray();
							$OldImage = $BottomSlider['image'];
						else:
							$OldImage = '';
						endif;
						
						if(!empty($this->request->data['image']) && ($this->request->data['image']['error'] == 0)){
							
							$data = [];
							$data = $this->request->data['image'];
							$data['module_type'] = 'sliderimages';
                             
							$upload = $this->Upload->Upload($data);
                            
							if($upload=='0'){
								
								$this->request->data['image'] = $OldImage;
								
							}else{
								
								$this->request->data['image'] = $upload;
								
								if(!empty($OldImage)&&($OldImage !='')&&(file_exists('img/sliderimages/'.$OldImage))){
								   unlink(WWW_ROOT . 'img/sliderimages/' .$OldImage);
								}
							}
						
						}else{
							
							if(!empty($OldImage)&&($OldImage !='')){
								$this->request->data['image'] = $OldImage;
							}else{
								$this->request->data['image'] = '';
							}
							
						}
                        
                        $BottomSliders = $this->BottomSliders->patchEntity($BottomSliders,$this->request->data);
                        $BottomSliders->id=$BottomSliders->id;
                        
                        if($result = $this->BottomSliders->save($BottomSliders)){
                                $this->Flash->success('The slider has been updated.');
                                return $this->redirect(['action' => 'index']);
                        }
                    }   

                } 
                $this->set('BottomSliders',$BottomSliders);
    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    function view($id=null)
    {
        $this->loadModel('BottomSliders');
        $userId= base64_decode($id);
        $BottomSliders = $this->BottomSliders->exists(['BottomSliders.id'=>$userId]);
        
        if (empty($BottomSliders)) {
            return $this->redirect(['action'=>'index']);
        }
        
        
        $BottomSliders = $this->BottomSliders->find('all',['conditions'=>['BottomSliders.id'=>$userId]])->first();
        $this->set('BottomSliders', $BottomSliders);
        
    }
    
} 


?>
