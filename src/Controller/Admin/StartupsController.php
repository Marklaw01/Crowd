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

class StartupsController extends AppController
{
   public $helpers = ['Custom'];
    
    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('Startups');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $Startups = $this->Startups->find('all')->contain(['Keywords','Users'=>['EntrepreneurBasics']]);
            //pr($Startups->toArray()); die;
            $this->set('Startups', $this->paginate($Startups));

    }

    /**
    *  add method for users
    *
    *
    *
    ****/
    function add()
    {
                $this->loadModel('Startups');
                $EntrepreneurTable = TableRegistry::get('EntrepreneurBasics'); 
                $user = $this->Auth->user();    
            
                if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');
                    $startup = $this->Startups->newEntity();

                    //Get Keywords list
                    /*$Keywords = $this->Startups->Keywords->find('list')->toArray();
                    $this->set('Keywords',$Keywords);*/

                    $this->loadModel('KeywordStartups');
                    $Keywords = $this->KeywordStartups->find('list')->toArray();
                    $this->set('Keywords',$Keywords);

                    if($this->request->is('Post')){

                        $keyword ='';
                        if(!empty($this->request->data['keywords'])){
                          $keyword = implode(',', $this->request->data['keywords']);
                        }
                        $this->request->data['keywords'] = $keyword;
                        $startup = $this->Startups->patchEntity($startup,$this->request->data); 
                        $startup->user_id = $UserId;
                        
                        
                        if($result = $this->Startups->save($startup)){
                            
                                $this->Flash->success('The Startup has been saved.');
                                //return $this->redirect($this->referer());
                                //$startup_id = $result->id;
                                return $this->redirect(['action' => 'index']);
                        }
                    }    

                }

                $this->set('startup',$startup);    

    }



    /**
    *  edit method for users
    *
    *
    *
    ****/
    function edit()
    {
            $this->loadModel('Users');
            

    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    function overview($id=null)
    {       
            $startupId = base64_decode($id);
            $this->set('startupId', $id);

            $this->loadModel('Roadmaps');
            $this->loadModel('StartupTeams');

            $user = $this->Auth->user();
            $UserId = $this->request->Session()->read('Auth.User.id');
            if($user){

                     $startup = $this->Startups->newEntity();
                     

                     /*$Keywords = $this->Startups->Keywords->find('list')->toArray();
                     $this->set('Keywords',$Keywords);*/

                     $this->loadModel('KeywordStartups');
                     $Keywords = $this->KeywordStartups->find('list')->toArray();
                     $this->set('Keywords',$Keywords);

                     //$roadmap = $this->Roadmaps->find('list')->toArray();
                     $roadmaps = $this->Roadmaps->find('all')->toArray();
                     $this->set('roadmaps', $roadmaps);

                     $singleStartup = $this->Startups->find('all',['conditions'=>['Startups.id'=>$startupId]])
                                            ->contain(['StartupRoadmaps'])
                                            ->first();
                    $customRoadmaps='';                       
                    if(!empty($singleStartup['startup_roadmaps'])){
                        foreach($singleStartup['startup_roadmaps'] as $singleRoadmap):
                            if($singleRoadmap->current_roadmap!=''):
                                $LinkRoadmapIds[]=$singleRoadmap->current_roadmap;
                                $startupRoadmapsIDSFilepath[$singleRoadmap->current_roadmap] = $singleRoadmap['file_path'];
                            endif;
                        endforeach;

                        if(!empty($startupRoadmapsIDSFilepath)){
                            
                            foreach($roadmaps as $singleRdMap){


                                
                                if(in_array($singleRdMap->id,$LinkRoadmapIds)):
                                    $finalRoadMapArray['roadmap_id'] = $singleRdMap->id;
                                    $finalRoadMapArray['name'] = $singleRdMap->name;
                                    $finalRoadMapArray['file_path'] = 'img/roadmap/'.$startupRoadmapsIDSFilepath[$singleRdMap->id];
                                else:
                                    $finalRoadMapArray['roadmap_id'] = $singleRdMap->id;
                                    $finalRoadMapArray['name'] = $singleRdMap->name;
                                    $finalRoadMapArray['file_path'] = '';
                                endif;
                                
                                $customRoadmaps[] = $finalRoadMapArray;
                                
                            }
                            
                            //$roadmaps['roadmap_deliverable_list'] = $lastFinal;
                            
                        }else{
                        
                        }
                    }
                    $this->set('customRoadmaps', $customRoadmaps);

                     // Get Startup Details by id
                     $startup = $this->Startups->get($startupId,['conditions'=>['Startups.id'=>$startupId]]);
                    // pr($startup); die;  
                     $this->set('startup',$startup); 

                    
            } 
            

    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    function team($id=null)
    {
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId', $UserId);
            $this->loadModel('StartupTeams');


                        //Get start up details by id =>['EntrepreneurBasics']
                        $startupDetails = $this->Startups->get($startupId, ['contain' => ['Users'=>['EntrepreneurBasics']]])->toArray();
                        $this->set('startupDetails', $startupDetails); 

                        //Check logged user is co founder
                        $LogUserIsCoFounder = $this->Startups->StartupTeams->exists(['startup_id' => $startupId, 'user_id'=>$UserId, 'contractor_role_id'=>2]);
                        $this->set('LogUserIsCoFounder', $LogUserIsCoFounder);

                        $LogUserIsTeamMember = $this->Startups->StartupTeams->exists(['startup_id' => $startupId, 'user_id'=>$UserId, 'contractor_role_id'=>3]);
                        $this->set('LogUserIsTeamMember', $LogUserIsTeamMember);

                        $startups = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId,'StartupTeams.approved !=' => 0, 'OR'=>['StartupTeams.approved !=' => 3]]])->contain(['Users','ContractorRoles']);
                        //pr($startups); die;

                        $this->set('startups', $this->paginate($startups)); 
                
    }



    /**
    *  view method for users
    *
    *
    *
    ****/
    function workorder($id=null)
    {
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);
            $createdByLogUser = $this->Startups->exists(['id' => $startupId]);

            //$startups = $this->Startups->StartupWorkOrders->find('all', ['conditions' => ['StartupWorkOrders.startup_id' => $startupId], 'order'=>['StartupWorkOrders.id DESC']])->contain(['Users','Roadmaps']);

            $startups = $this->Startups->StartupWorkOrders->find('all', [
                                                                'conditions' => ['StartupWorkOrders.startup_id' => $startupId,'StartupWorkOrders.is_submited' => 1],           
                                                                'fields' => [
                                                                    'total_work_units' => 'SUM(work_units)',
                                                                    'first_name' => 'users.first_name',
                                                                    'last_name' => 'users.last_name',
                                                                    'roadmap' => 'roadmaps.name',
                                                                    'week_no' => 'StartupWorkOrders.week_no',
                                                                    'user_id' => 'users.id',
                                                                    'status' => 'StartupWorkOrders.status',
                                                                    'show_status' => 'StartupWorkOrders.show_status',
                                                                    'date' => 'StartupWorkOrders.modified',
                                                                    'startup_team_id' => 'StartupWorkOrders.startup_team_id'
                                                                ],
                                                                'join' => [
                                                                        [
                                                                            'table' => 'users', 
                                                                            'type' => 'inner',
                                                                            'conditions' => 'StartupWorkOrders.user_id = users.id'
                                                                        ],
                                                                        [
                                                                            'table' => 'roadmaps', 
                                                                            'type' => 'inner',
                                                                            'conditions' => 'StartupWorkOrders.roadmap_id = roadmaps.id'
                                                                        ]
                                                                ],
                                                                'group' => ['StartupWorkOrders.startup_team_id','StartupWorkOrders.week_no'],
                                                    ]);
            //pr($startups->toArray()); die;
            if(!empty($createdByLogUser)){

                $this->set('startups', $this->paginate($startups));    

             } else {
                $this->redirect(['action' => 'currentStartup']);
             }
           // $workorders='';
            //$this->set('workorders', $this->paginate($workorders)); 
    }


    /**
    *  view method for users
    *
    *
    *
    ****/
    function docs($id=null)
    {
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);

            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId', $UserId);


            $this->loadModel('StartupDocs');
            $startupDocLists = $this->StartupDocs->find('all', ['conditions' => ['StartupDocs.startup_id' => $startupId]])->contain(['Users'=>['EntrepreneurBasics'],'Roadmaps']);
         
            $this->set('startupDocLists', $this->paginate($startupDocLists));
    }

    /*
    * Download Startup Docs
    *
    *
    */

    public function downloadStartupDoc($id=null)
    {
            $startupDocId = base64_decode($id);

            $this->loadModel('StartupDocs');
            $startupdetail = $this->StartupDocs->get($startupDocId);
            $file_name = $startupdetail->file_path;
            if(!empty($file_name)){
            $filePath = WWW_ROOT .'img/roadmap'. DS . $file_name;
            $this->response->file($filePath ,array('download'=> true));
            return $this->response;
           }
    }

    /*
    *
    *
    *
    *
    */
    public function roadmapdocs($id=null)
    {
        $this->paginate = [ 'limit' => 10];
            $startupId = base64_decode($id);
            $this->set('startupId', $id); 

            $this->loadModel('StartupRoadmaps');
            $this->loadModel('Roadmaps');
            $this->loadModel('Startups');

            
            $roadmap = $this->StartupRoadmaps->newEntity();
            $UserId = $this->request->Session()->read('Auth.User.id');

            //Get statrup application status
            $this->loadModel('StartupQuestions');
            $getAplicationStatus = $this->StartupQuestions->find('all',['conditions'=>['StartupQuestions.startup_id' => $startupId]])->contain(['Startups'])->first();
            
            $ApplicationStatus='';
            if(!empty($getAplicationStatus)){
                $ApplicationStatus= $getAplicationStatus->status;
            }
            $this->set('ApplicationStatus', $ApplicationStatus);

            //Get statrup profile status
            $this->loadModel('StartupProfiles');
            $getProfilesStatus = $this->StartupProfiles->find('all',['conditions'=>['StartupProfiles.startup_id' => $startupId]])->contain(['Startups'])->first();
            
            $ProfileStatus='';
            if(!empty($getProfilesStatus)){
                $ProfileStatus= $getProfilesStatus->status;
            }
            $this->set('ProfileStatus', $ProfileStatus);


            // Get completed Roadmap Ids
            $compltedRoadmapIds = $this->StartupRoadmaps->find('all',['conditions'=>['StartupRoadmaps.startup_id' => $startupId, 'StartupRoadmaps.user_id'=>$UserId,'StartupRoadmaps.complete'=>1]])->contain(['Roadmaps'])->toArray();

            $finalCompletedRoadmapIds='';
            foreach($compltedRoadmapIds as $StartupRoadmap){
                    
                    $keys = ($StartupRoadmap->current_roadmap!=' ')?$StartupRoadmap->current_roadmap:' ';
                    
                    $finalCompletedRoadmapIds[]= $keys;
            }
            $this->set('finalCompletedRoadmapIds',$finalCompletedRoadmapIds);

            /*Fetching Records from Roadmap table with respective login ID*/
            $roadmaplist = $this->Roadmaps->find('all')->toArray();
            $this->set('roadmaplist', $roadmaplist);

            $PreferredAndNextStep='';
            if(!empty($finalCompletedRoadmapIds)){
                foreach($roadmaplist as $roadmaplistId){

                    if(!in_array($roadmaplistId->id, $finalCompletedRoadmapIds)){ 

                            $PreferredAndNextStep[]=$roadmaplistId->name;

                            //$PreferredAndNext[]= $keys;
                    }        
                 }
            }            
            $this->set('PreferredAndNextStep',$PreferredAndNextStep);

           //pr($finalCompletedRoadmapIds); die;

                if($this->request->is('Post')){

                    // If upload image not blank
                    //echo $this->request->data['file_path'];
                        $flag=0;
                        $newfilename='';
                        if(!empty($this->request->data['file_path']['name'])){

                            $file_path = $this->request->data['file_path'];
                            $file_path_name = $this->Multiupload->uploadStratupDocs($file_path);
                            
                            if(empty($file_path_name['errors'])){
                                $newfilename=$file_path_name['imgName'];
                            }else {
                                $flag=1;
                            }   
                        }

                        if($flag==1){
                                $this->Flash->error('Invalid! Allowed extensions are doc,docx,PDF. Max upload size 5MB.');
                        }else {

                                ///Check if record exists
                               $checkStartupRoadmapsexist = $this->StartupRoadmaps->exists(['StartupRoadmaps.startup_id' => $startupId, 'StartupRoadmaps.user_id'=>$UserId,'StartupRoadmaps.current_roadmap'=>$this->request->data['current_roadmap']]);
                    
                                if($checkStartupRoadmapsexist ==1){
                                    $checkWorkOrderexistArray = $this->StartupRoadmaps->find('all',['conditions'=>['StartupRoadmaps.startup_id' => $startupId, 'StartupRoadmaps.user_id'=>$UserId,'StartupRoadmaps.current_roadmap'=>$this->request->data['current_roadmap']]])->first();
                                    $this->request->data['id'] = $checkWorkOrderexistArray->id;
                                }


                    
                                

                                $this->request->data['file_path']=$newfilename;
                                $nextSStep=$this->request->data['next_step'];
                                $roadmap = $this->StartupRoadmaps->patchEntity($roadmap,$this->request->data); 
                                $roadmap->user_id = $UserId;
                                $roadmap->startup_id = $startupId;

                                if($checkStartupRoadmapsexist ==1){
                                    $roadmap->id= $this->request->data['id'];
                                }
                                
                                  

                                    if($result = $this->StartupRoadmaps->save($roadmap)){

                                        $query = $this->Startups->query();
                                        $query->update()
                                             ->set(['next_step'=>$nextSStep])
                                             ->where(['id' => $startupId])
                                             ->execute();
                                            
                                            $this->Flash->success('Roadmap docs has been updated successfully.');
                                            return $this->redirect($this->referer());
                                    } else {
                                             $this->Flash->error('Roadmap docs could not be saved. Please, try again.');
                                    }
                        }            
                }

      
        
        $this->set('roadmap',$roadmap);
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

    /**
    * 
    * Delete Startup
    *
    ****/
    public function delete($id = null)
    {
        $id = base64_decode($id);
        $this->loadModel('Startups');
        $campaign = $this->Startups->get($id);
        if ($this->Startups->delete($campaign)) {
            $this->Flash->success('The startup has been deleted.');
        } else {
            $this->Flash->error('The startup could not be deleted. Please, try again.');
        }
        return $this->redirect($this->referer());
    }


    /*
    * Approve Startup
    *
    *
    */

    public function approve($id=null)
    {
        $startupId = base64_decode($id);

        $this->loadModel('Startups');
        $res= $this->Startups->query()
                  ->update()
                  ->set(['status' => 1])
                  ->where(['id' => $startupId])
                  ->execute();
        $this->Flash->success('Startup approved successfully.');          
        return $this->redirect($this->referer());          
          
    }


    /*
    * Disapprove
    *
    *
    */

    public function disapprove($id=null)
    {
        $startupId = base64_decode($id);

        $this->loadModel('Startups');
        $res= $this->Startups->query()
                  ->update()
                  ->set(['status' => 2])
                  ->where(['id' => $startupId])
                  ->execute();
        $this->Flash->success('Startup disapproved successfully.');          
        return $this->redirect($this->referer()); 
    }

} 


?>
