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

class RoadmapsController extends AppController
{
   
    
    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('Roadmaps');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $Roadmaps = $this->Roadmaps->find('all')->order(['order_no' => 'Asc']);
            //pr($Startups->toArray()); die;
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
                $this->loadModel('Roadmaps');
                $user = $this->Auth->user();    
                $roadmap = $this->Roadmaps->newEntity();

                //Get Roadmap list
                $roadMapList = $this->Roadmaps->find('all')->order(['order_no' => 'DESC']);;
                $TotalItems= $roadMapList->count();
                if(!empty($TotalItems)){  
                    foreach ($roadMapList as $key => $value) {
                        $finalConnections[$value->id] = $value->name;
                    }
                }else{
                    $finalConnections=[];
                }
                $this->set('roadmaplist',$finalConnections);  


                if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('Post')){

                        $orderId= $this->request->data['order_id'];

                        if(!empty($orderId)){

                            $orderValue = $this->Roadmaps->find('all',['conditions'=>['id'=>$orderId]])->select('order_no')->first();

                            $query = $this->Roadmaps->query();

                            $query->update()
                                ->set(['order_no = order_no + 1'])
                                ->where(['order_no >' => $orderValue->order_no])
                                ->execute();

                            $roadmap = $this->Roadmaps->patchEntity($roadmap,$this->request->data); 
                            $roadmap->user_id = $UserId;
                            $roadmap->order_no = $orderValue->order_no+1;
                            
                            if($result = $this->Roadmaps->save($roadmap)){
                                
                                    $this->Flash->success('The roadmap has been saved.');
                                    return $this->redirect(['action' => 'index']);
                            }        

                        }else{

                            $orderValue = 0;

                            $query = $this->Roadmaps->query();

                            $query->update()
                                ->set(['order_no = order_no + 1'])
                                ->where(['order_no >' => $orderValue])
                                ->execute();

                            $roadmap = $this->Roadmaps->patchEntity($roadmap,$this->request->data); 
                            $roadmap->user_id = $UserId;
                            $roadmap->order_no = $orderValue+1;
                            
                            if($result = $this->Roadmaps->save($roadmap)){
                                
                                    $this->Flash->success('The roadmap has been saved.');
                                    return $this->redirect(['action' => 'index']);
                            } 

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
            $this->loadModel('Roadmaps');

            //Get Roadmap list
            $roadMapList = $this->Roadmaps->find('all',['conditions'=>['id !='=> $rId]])->order(['order_no' => 'DESC']);
            $TotalItems= $roadMapList->count();
            if(!empty($TotalItems)){  
                foreach ($roadMapList as $key => $value) {
                    $finalConnections[$value->id] = $value->name;
                }
            }else{
                $finalConnections=[];
            }
            $this->set('roadmaplist',$finalConnections);
            
            $user = $this->Auth->user(); 
            $roadmap = $this->Roadmaps->get($rId);

            $nearestValue= $this->Roadmaps->find('all',['conditions'=>['order_no <' =>$roadmap->order_no]])->order(['order_no' => 'DESC'])->first();
            if(!empty($nearestValue)){
                $afterSaveId=$nearestValue->id;
            }else{
                $afterSaveId='';
            }
            $this->set('afterSaveId',$afterSaveId);


            if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('put')){

                        $orderId= $this->request->data['order_id'];

                        if(!empty($orderId)){

                            $orderValue = $this->Roadmaps->find('all',['conditions'=>['id'=>$orderId]])->select('order_no')->first();
                            $query = $this->Roadmaps->query();

                            $query->update()
                                ->set(['order_no = order_no + 1'])
                                ->where(['order_no >' => $orderValue->order_no])
                                ->execute();

                            $roadmap = $this->Roadmaps->patchEntity($roadmap,$this->request->data); 
                            $roadmap->user_id = $UserId;
                            $roadmap->id=$roadmap->id;
                            $roadmap->order_no = $orderValue->order_no+1;
                            
                            if($result = $this->Roadmaps->save($roadmap)){
                                
                                    $this->Flash->success('The roadmap has been saved.');
                                    return $this->redirect(['action' => 'index']);
                            }

                        }else{
                            $orderValue = 0;

                            $query = $this->Roadmaps->query();

                            $query->update()
                                ->set(['order_no = order_no + 1'])
                                ->where(['order_no >' => $orderValue])
                                ->execute();

                            $roadmap = $this->Roadmaps->patchEntity($roadmap,$this->request->data); 
                            $roadmap->user_id = $UserId;
                            $roadmap->id=$roadmap->id;
                            $roadmap->order_no = $orderValue+1;
                            
                            if($result = $this->Roadmaps->save($roadmap)){
                                
                                    $this->Flash->success('The roadmap has been saved.');
                                    return $this->redirect(['action' => 'index']);
                            }
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
        $this->loadModel('Roadmaps');
        $this->request->allowMethod(['post', 'delete']);
        $campaign = $this->Roadmaps->get($id);
        if ($this->Roadmaps->delete($campaign)) {
            $this->Flash->success('The Roadmaps has been deleted.');
        } else {
            $this->Flash->error('The Roadmaps could not be deleted. Please, try again.');
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
