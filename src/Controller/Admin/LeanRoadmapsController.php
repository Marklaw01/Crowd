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

class LeanRoadmapsController extends AppController
{
    public function initialize()
    {
        parent::initialize();
        $this->loadComponent('Upload');
    }    
    
    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('RoadmapDynamics');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $Roadmaps = $this->RoadmapDynamics->find('all')->order(['id' => 'Asc']);;
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
                $this->loadModel('RoadmapDynamics');
                $user = $this->Auth->user();    
                $roadmap = $this->RoadmapDynamics->newEntity();

                if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('Post')){

                        $data = [];
                        $data = $this->request->data['sample_doc'];
                        $upload = $this->Upload->UploadSampelDoc($data); 

                        $data2 = [];
                        $data2 = $this->request->data['template_link'];
                        $upload2 = $this->Upload->UploadSampelDoc($data2); 

                        //pr($upload['errors']); die;
                        if(empty($upload['errors']) or empty($upload2['errors'])){

                            $roadmap = $this->RoadmapDynamics->patchEntity($roadmap,$this->request->data); 
                            $roadmap->user_id = $UserId;
                            $roadmap->sample_link = $upload['imgName'];
                            $roadmap->template_link = $upload2['imgName'];

                            if($result = $this->RoadmapDynamics->save($roadmap)){
                                
                                    $this->Flash->success('The lean roadmap has been saved.');
                                    return $this->redirect(['action' => 'index']);
                            }
                        }else{

                            $this->Flash->success($upload['errors']);
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
            $this->loadModel('RoadmapDynamics');
            
            $user = $this->Auth->user(); 
            $roadmap = $this->RoadmapDynamics->get($rId);
            $old_sample_doc = $roadmap->sample_link;
            $old_template_doc = $roadmap->template_link;

            if($user){

                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('put')){

                        $flag=0;
                        $data = [];
                        $data = $this->request->data['sample_doc'];

                        $data2 = [];
                        $data2 = $this->request->data['template_link'];

                        if(!empty($this->request->data['sample_doc']['name'])){

                            $upload = $this->Upload->UploadSampelDoc($data); 

                            if(!empty($upload['imgName'])){
                                $old_sample_doc= $upload['imgName'];
                            }else{
                                $flag=1;
                            }
                        }   

                        if(!empty($this->request->data['template_link']['name'])){

                            $upload2 = $this->Upload->UploadSampelDoc($data2); 

                            if(!empty($upload2['imgName'])){
                                $old_template_doc= $upload2['imgName'];
                            }else{
                                $flag=1;
                            }
                        }

                        if($flag==1){
                                if(!empty($upload['errors'])){
                                    $this->Flash->error($upload['errors']);
                                }
                                if(!empty($upload2['errors'])){
                                    $this->Flash->error($upload2['errors']);
                                }
                                
                        }else {
                            $roadmap = $this->RoadmapDynamics->patchEntity($roadmap,$this->request->data); 
                            $roadmap->user_id = $UserId;
                            $roadmap->id=$roadmap->id;
                            $roadmap->sample_link=$old_sample_doc;
                            $roadmap->template_link=$old_template_doc;
                            
                            if($result = $this->RoadmapDynamics->save($roadmap)){
                                
                                    $this->Flash->success('The roadmap has been saved.');
                                    return $this->redirect(['action' => 'index']);
                            }
                        }    
                    }    

                }

                $this->set('roadmap',$roadmap);
            

    }

    /**
     * 
     *
     *
     */
    public function delete($id = null)
    {
        $id = base64_decode($id);
        $this->loadModel('RoadmapDynamics');
        $this->request->allowMethod(['post', 'delete']);
        $campaign = $this->RoadmapDynamics->get($id);
        if ($this->RoadmapDynamics->delete($campaign)) {
            $this->Flash->success('The Lean Startup Roadmaps has been deleted.');
        } else {
            $this->Flash->error('The Lean Startup Roadmaps could not be deleted. Please, try again.');
        }
        return $this->redirect($this->referer());
    }

   
     /**
     * 
     *
     *
     */
    public function delete11($id=null)
    {
        $rId= base64_decode($id);
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
