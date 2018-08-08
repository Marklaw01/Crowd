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

class QuestionsController extends AppController
{
   
    
    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('Questions');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $Roadmaps = $this->Questions->find('all')->order(['id' => 'DESC']);;
            //pr($Roadmaps->toArray()); die;
            $this->set('Roadmaps', $this->paginate($Roadmaps));

    }

    /**
    *  add method for users
    *
    *
    *
    ****/
    function add()
    {
                $this->loadModel('Questions');
                $user = $this->Auth->user();    
                $roadmap = $this->Questions->newEntity();

                if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('Post')){

                        $roadmap = $this->Questions->patchEntity($roadmap,$this->request->data); 
                        $roadmap->user_id = $UserId;
                        
                        
                        if($result = $this->Questions->save($roadmap)){
                            
                                $this->Flash->success('The question has been saved.');
                                return $this->redirect(['action' => 'index']);
                        }
                    }    

                }

                $this->set('roadmap',$roadmap);    

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
            $this->loadModel('Questions');
            
            $user = $this->Auth->user(); 
            $roadmap = $this->Questions->get($rId);
            if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('put')){

                        $roadmap = $this->Questions->patchEntity($roadmap,$this->request->data); 
                        $roadmap->user_id = $UserId;
                        $roadmap->id=$roadmap->id;
                        
                        if($result = $this->Questions->save($roadmap)){
                            
                                $this->Flash->success('The question has been saved.');
                                return $this->redirect(['action' => 'index']);
                        }
                    }    

                }

                $this->set('roadmap',$roadmap);
            

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
            $users = $this->Users->exists(['Users.id'=>$userId]);

            if (empty($users)) {
                return $this->redirect(['action'=>'index']);
            }

            
            $this->loadModel('Users');
            $users = $this->Users->find('all',['conditions'=>['Users.id'=>$userId]])->contain(['Countries','States','Roles'])->first();
            $this->set('users', $users);
            

    }

    /**
     * 
     *
     *
     */
    public function delete($id = null)
    {
        $id = base64_decode($id);
        $this->loadModel('Questions');
        $this->request->allowMethod(['post', 'delete']);
        $campaign = $this->Questions->get($id);
        if ($this->Questions->delete($campaign)) {
            $this->Flash->success('The Question has been deleted.');
        } else {
            $this->Flash->error('The Question could not be deleted. Please, try again.');
        }
        return $this->redirect($this->referer());
    }

    /**
     * getOptionsList method
     *
     * @param string|null $Email ID.
     * @return void Redirects to register.
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function getOptionsList(){

      $this->loadModel('States');
        if(!empty($this->request->data)){
            $countryId  = $this->request->data['countryId'];
            $state = $this->States->find('all',['conditions'=>['States.country_id'=>$countryId]])->select(['id','name'])->toArray();
            //pr( $state );die;
            $this->set('states',$state);
            echo $this->render('/Element/Front/adminajaxstates');
            //$result = "<option value=".$question_id.">".$questionname."</option>";
            //echo $result; 
            die;
        }

    }

} 


?>
