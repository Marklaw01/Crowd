<?php
namespace App\Controller;

use App\Controller\AppController;
use Cake\ORM\TableRegistry;
use Cake\Filesystem\Folder;
use Cake\Filesystem\File;
use Cake\Database\Expression\QueryExpression;
use Cake\Mailer\Email;
use Cake\Routing\Router;
use Cake\Auth\DefaultPasswordHasher;
use Cake\Datasource\EntityInterface;
use Cake\Datasource\ConnectionManager;

/**
* Users Controller
*
*@property\App\Model\Table\Users table $users
*/ 

class SubAdminsController extends AppController
{
    
    public function beforeFilter(\Cake\Event\Event $event)
    {
         $this->viewBuilder()->layout('subadmin');
    }
    
    public $helpers = ['Custom'];
    
    public function initialize()
    {
        parent::initialize();
        $this->loadComponent('Upload');
        $this->loadModel('SubAdminDetails');
        
        $userid = $this->Auth->user('id');
        
       $SubAdminDetails = $this->SubAdminDetails->find('all',['conditions'=>['SubAdminDetails.user_id'=>$userid]])->first();
       
       if(!empty($SubAdminDetails->toArray())):
          $this->set('SubAdminDetails',$SubAdminDetails->toArray());
       else:
          $this->set('SubAdminDetails',[]);
       endif;
       
        //$subAdminImage
    }
    
    /****
    *
    *  Dashboard Method
    *
    *
    *
    *******/
   public function dashboard()
   {
    $this->loadModel('Blocks');
    $this->loadModel('TopSliders');
    $this->loadModel('BottomSliders');
    $this->loadModel('VideoLinks');
        
        $Blocks = $this->Blocks->find('all');
        $this->set('BlocksData',$Blocks->toArray());
        
        $TopSliders = $this->TopSliders->find('all');
        $this->set('TopSlidersData',$TopSliders->toArray());
        
        $BottomSliders = $this->BottomSliders->find('all');
        $this->set('BottomSlidersData',$BottomSliders->toArray());
        
        $videoLink = $this->VideoLinks->find('all')->first();
        $this->set('videoLink',$videoLink->toArray());
   }
    
    /*
    *
    *  view profile Method
    *
    *
    *
    */
   public function editprofile()
   {
       
       $this->loadModel('SubAdminDetails');
       $this->loadModel('CompanyKeywords');
       $this->loadModel('Skills');
       $this->loadModel('Industries');
       $this->loadModel('JobTypes');
       
       $user = $this->Auth->user();
       $user_id = $this->Auth->user('id');
        
       $JobPostingKeywords = $this->CompanyKeywords->find('list', [
                                                                      'keyField' => 'id',
                                                                      'valueField' => 'name'
                                                                  ]);
       $this->set('JobPostingKeywords',$JobPostingKeywords->toArray());
       
       $Skills = $this->Skills->find('list', [
                                                  'keyField' => 'id',
                                                  'valueField' => 'name'
                                              ]);
       $this->set('Skills',$Skills->toArray());
       
       $Industries = $this->Industries->find('list', [
                                                  'keyField' => 'id',
                                                  'valueField' => 'name'
                                              ]);
       $this->set('Industries',$Industries->toArray());
          
       $JobTypes = $this->JobTypes->find('list', [
                                                  'keyField' => 'id',
                                                  'valueField' => 'name'
                                              ]);
       $this->set('JobTypes',$JobTypes->toArray());
       
       $subAdminDetails = $this->SubAdminDetails->newEntity();
       
       if($user){
                     
                     $SubAdminDetails = $this->SubAdminDetails->find('all',['conditions'=>['SubAdminDetails.user_id'=>$user_id]])->first();
                    
                     $subAdminDetails = $this->SubAdminDetails->get($SubAdminDetails->id);
                    
                    if($this->request->is(['patch', 'post', 'put'])){
                    
                    if(isset($this->request->data['skills'])
                       &&(!empty($this->request->data['skills']))):
                              $this->request->data['skills'] = implode(',',$this->request->data['skills']);
                    endif;
                    
                    if(isset($this->request->data['job_posting_keywords'])
                       &&(!empty($this->request->data['job_posting_keywords']))):
                              $this->request->data['job_posting_keywords'] = implode(',',$this->request->data['job_posting_keywords']);
                    endif;
                    
                     //moving the profile image file start
                    
                        if($subAdminDetails->profile_image!=''): 
							$ProfileImage = $subAdminDetails->profile_image;
						else:
							$ProfileImage = '';
						endif;
						
						if(!empty($this->request->data['profile_image']) && ($this->request->data['profile_image']['error'] == 0)){
							
							$data = [];
							$data = $this->request->data['profile_image'];
							$data['module_type'] = 'subadmin_profile_image';
                            
							$upload = $this->Upload->Upload($data);
                            
							if($upload=='0'){
								
								$this->request->data['profile_image'] = $ProfileImage;
								
							}else{
								
								$this->request->data['profile_image'] = $upload;
								
								if(!empty($ProfileImage)&&($ProfileImage !='')&&(file_exists('img/subadmin_profile_image/'.$ProfileImage))){
								   unlink(WWW_ROOT . 'img/subadmin_profile_image/' .$ProfileImage);
								}
							}
						
						}else{
							
							if(!empty($ProfileImage)&&($ProfileImage !='')){
								$this->request->data['profile_image'] = $ProfileImage;
							}else{
								$this->request->data['profile_image'] = '';
							}
							
						}
                    
                    //moving the profile image end
                    
                    //moving the audio file start
                    
                        if($subAdminDetails->audio!=''): 
							$OldAudio = $subAdminDetails->audio;
						else:
							$OldAudio = '';
						endif;
						
						if(!empty($this->request->data['audio']) && ($this->request->data['audio']['error'] == 0)){
							
							$data = [];
							$data = $this->request->data['audio'];
							$data['module_type'] = 'subadmin_audio';
                            
							$upload = $this->Upload->Upload($data);
                            
							if($upload=='0'){
								
								$this->request->data['audio'] = $OldAudio;
								
							}else{
								
								$this->request->data['audio'] = $upload;
								
								if(!empty($OldAudio)&&($OldAudio !='')&&(file_exists('img/subadmin_audio/'.$OldAudio))){
								   unlink(WWW_ROOT . 'img/subadmin_audio/' .$OldAudio);
								}
							}
						
						}else{
							
							if(!empty($OldAudio)&&($OldAudio !='')){
								$this->request->data['audio'] = $OldAudio;
							}else{
								$this->request->data['audio'] = '';
							}
							
						}
                      
                    //moving the audio file end
                    
                    //moving the video file start
                    
                        if($subAdminDetails->video!=''): 
							$OldVideo = $subAdminDetails->video;
						else:
							$OldVideo = '';
						endif;
						
						if(!empty($this->request->data['video']) && ($this->request->data['video']['error'] == 0)){
							
							$data = [];
							$data = $this->request->data['video'];
							$data['module_type'] = 'subadmin_video';
                            
							$upload = $this->Upload->Upload($data);
                            
							if($upload=='0'){
								
								$this->request->data['video'] = $OldVideo;
								
							}else{
								
								$this->request->data['video'] = $upload;
								
								if(!empty($OldVideo)&&($OldVideo !='')&&(file_exists('img/subadmin_video/'.$OldVideo))){
								   unlink(WWW_ROOT . 'img/subadmin_video/' .$OldVideo);
								}
							}
						
						}else{
							
							if(!empty($OldVideo)&&($OldVideo !='')){
								$this->request->data['video'] = $OldVideo;
							}else{
								$this->request->data['video'] = '';
							}
							
						}
                      
                      //moving the video file end
                      
                      //moving the docs file start
                    
                        if($subAdminDetails->video!=''): 
							$OldDocs = $subAdminDetails->document;
						else:
							$OldDocs = '';
						endif;
						
						if(!empty($this->request->data['document']) && ($this->request->data['document']['error'] == 0)){
							
							$data = [];
							$data = $this->request->data['document'];
							$data['module_type'] = 'subadmin_docs';
                            
							$upload = $this->Upload->Upload($data);
                            
							if($upload=='0'){
								
								$this->request->data['document'] = $OldDocs;
								
							}else{
								
								$this->request->data['document'] = $upload;
								
								if(!empty($OldDocs)&&($OldDocs !='')&&(file_exists('img/subadmin_docs/'.$OldDocs))){
								   unlink(WWW_ROOT . 'img/subadmin_docs/' .$OldDocs);
								}
							}
						
						}else{
							
							if(!empty($OldDocs)&&($OldDocs !='')){
								$this->request->data['document'] = $OldDocs;
							}else{
								$this->request->data['document'] = '';
							}
							
						}
                      
                      //moving the docs file end
                    
                      $subAdminDetails = $this->SubAdminDetails->patchEntity($subAdminDetails, $this->request->data);
                            
                            if($this->SubAdminDetails->save($subAdminDetails)){
                                
                                $this->Flash->success(__('The SubAdmin Details has been updated.'));
                                return $this->redirect(['controller'=>'SubAdmins','action'=>'viewProfile']);
                              
                            }else {
                                        $errors = $subAdminDetails->errors();
                                        foreach($errors as $key=>$value){
                                          foreach($value as $keytwo=>$message){
                                            $this->Flash->error(__($message));
                                         }
                                        }
                    
                                 }
                     }
          
          $this->set('subAdminDetails',$subAdminDetails);
          
        }   
   }
   
   /*
    * View ProfessionalProfile Method for Professional Profile edit
    *
    *
    */
    public function viewProfile($id=null,$starupId = null)
    {
        
        $this->loadModel('SubAdminDetails');
        $this->loadModel('Industries');
        $this->loadModel('JobTypes');
        $this->loadModel('Skills');
        $this->loadModel('JobPostingKeywords');
        return $this->redirect(['controller'=>'SubAdmins','action'=>'editProfile']);

        $user_id = $this->Auth->user('id');
        
        $subAdminDetails = $this->SubAdminDetails->find('all',['conditions'=>['SubAdminDetails.user_id'=>$user_id] ])->first();
        
        $this->set('subAdminDetails',$subAdminDetails->toArray());
         
     //getting industry
        
        $industry_array = $this->Industries->find('all', [
                                                  'conditions'=>['Industries.id'=>$subAdminDetails->industry]
                                              ])->first();
        
        if(isset($industry_array)
           &&(!empty($industry_array))):
        $this->set('industry',$industry_array->toArray());
        else:
        $this->set('industry','');
        endif;
        
     //getting JobTypes
        
        $jobtype_array = $this->JobTypes->find('all', [
                                                  'conditions'=>['JobTypes.id'=>$subAdminDetails->job_type]
                                              ])->first();
        
        
        if(isset($jobtype_array)
           &&(!empty($jobtype_array))):
        $this->set('jobtype',$jobtype_array->toArray());
        else:
        $this->set('jobtype','');
        endif;
     //getting skills
          
        $skill_array = explode(',',$subAdminDetails->skills);
        $skill_array = $this->Skills->find('all', [
                                                  'conditions'=>['Skills.id IN'=>$skill_array]
                                              ]);
        
        $this->set('skills',$skill_array->toArray());
        
    //getting skills
        
        $job_posting_keywords_array = explode(',',$subAdminDetails->job_posting_keywords);
        $job_posting_keywords_array = $this->JobPostingKeywords->find('all', [
                                                  'conditions'=>['JobPostingKeywords.id IN'=>$job_posting_keywords_array]
                                              ]);
        
        $this->set('job_posting_keywords',$job_posting_keywords_array->toArray());
        
    }
    
    /*
     *
     *add admins
     *
     */
    public function addAdmin(){
        
        $this->paginate = [ 'limit' => 10];
        
        $this->loadModel('Users');
        $this->loadModel('ContractorBasics');
        $this->loadModel('EntrepreneurProfessionals');
        $this->loadModel('ContractorProfessionals');
        $this->loadModel('Keywords');
        $this->loadModel('Roadmaps');
        $this->loadModel('SubAdminRelations');
        $this->loadModel('SubAdminDetails');
        
        $user = $this->Auth->user();
        $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
        $this->set('Keywords',$Keywords);

        if($user){
                    
            $users=[]; 
            $UserId = $this->request->Session()->read('Auth.User.id');

            //Get Company Id
            $companyDetails= $this->SubAdminDetails->find('all',['conditions' => ['SubAdminDetails.user_id' => $UserId]])->first();
            $this->set('companyId',$companyDetails->id);

            $searchKeyword=trim($this->request->query('search'));
            $searchKeyword = str_replace("'","",$searchKeyword);  

            if(!empty($searchKeyword))
            {
                    
             //this code runs when search is done
             
                $admincontractorIds = $this->SubAdminRelations->find('list',
                                        ['keyField' => 'id','valueField' => 'contractor_id'])
                                        ->where(['SubAdminRelations.sub_admin_id' =>$UserId])
                                        ->group('contractor_id');
                
                if($admincontractorIds->toArray())
                {
                   
                    $admincontractorIds = $admincontractorIds->toArray();
             
                    //this code runs when contractor is linked to subadmin
              
                    $connection = ConnectionManager::get('default');
                    
                    $qq = "SELECT CP.user_id FROM keywords as KY INNER JOIN contractor_professionals as CP
                           ON FIND_IN_SET(KY.id, CP.keywords) where KY.name like '%".$searchKeyword."%' GROUP BY CP.user_id
                           UNION SELECT CB.user_id FROM contractor_basics as CB where CB.first_name like '%".$searchKeyword."%'
                           OR CB.last_name like '%".$searchKeyword."%' OR (CB.price='".$searchKeyword."' && CB.price!='' && CB.price!=0) GROUP BY CB.user_id";
                    
                    $sql = $connection->execute ($qq);
                    $user_ids = $sql->fetchAll('assoc');
                    
                    if(!empty($user_ids))
                    { 
                        foreach($user_ids as $SingleUser):
                            
                            if(isset($SingleUser['user_id'])&&($SingleUser['user_id']!='')){
                                $contractorIds[] = $SingleUser['user_id'];
                            }
                        endforeach;
                            
                        $conditions = ['Users.id IN'=>$contractorIds,
                        'Users.id !='=>$UserId,
                        'Users.id NOT IN'=>$admincontractorIds];
                        
                        $users= $this->Users->find('all',['conditions'=>$conditions])
                              ->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])
                              ->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);
                        
                        $this->paginate($users); 
                    }
                              
                }else{
                    
                    //this code runs when NOT ANY contractor is linked to subadmin
                    $connection = ConnectionManager::get('default');
                          $qq = "SELECT CP.user_id FROM keywords as KY INNER JOIN contractor_professionals as CP
                          ON FIND_IN_SET(KY.id, CP.keywords) where KY.name like '%".$searchKeyword."%' GROUP BY CP.user_id
                          UNION SELECT CB.user_id FROM contractor_basics as CB where CB.first_name like '%".$searchKeyword."%'
                          OR CB.last_name like '%".$searchKeyword."%' OR (CB.price='".$searchKeyword."' && CB.price!='' && CB.price!=0) GROUP BY CB.user_id";
                          $sql = $connection->execute ($qq);
                          $user_ids = $sql->fetchAll('assoc');
          
                          if(!empty($user_ids))
                          {
                              
                              foreach($user_ids as $SingleUser):
                                  
                                  if(isset($SingleUser['user_id'])&&($SingleUser['user_id']!='')){
                                      $contractorIds[] = $SingleUser['user_id'];
                                  }
                              endforeach;
                                  
                              $conditions = ['Users.id IN'=>$contractorIds,
                              'Users.id !='=>$UserId];
                              
                              $users= $this->Users->find('all',['conditions'=>$conditions])
                                    ->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])
                                    ->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);
                              $this->paginate($users); 
                          }
                    
                }
                 
            }else{
                    
                  //this code runs when search is not done
                    
                  $admincontractorIds = $this->SubAdminRelations->find('list',
                                        ['keyField' => 'id','valueField' => 'contractor_id'])
                                        ->where(['SubAdminRelations.sub_admin_id' =>$UserId])
                                        ->group('contractor_id');
                    
                    if(!empty($admincontractorIds->toArray()))
                    {
                              
                        $admincontractorIds = $admincontractorIds->toArray();
                        
                        $contractorIds = $this->ContractorBasics->find('list',
                                        ['conditions'=>['ContractorBasics.user_id !='=>$UserId,
                                                        'ContractorBasics.user_id NOT IN'=>$admincontractorIds],
                                         'keyField' => 'id','valueField' => 'user_id']);
                        
                       if(!empty($contractorIds->toArray()))
                       {   
                          $contractorIds = $contractorIds->toArray();
                             
                          $conditions = ['Users.id IN'=>$contractorIds,
                                            'Users.id !='=>$UserId]; 
                          $users= $this->Users->find('all',
                                            ['conditions'=>$conditions])
                                            ->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])
                                            ->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']); 
                          $this->paginate($users);     
                       }
                   
                    }else{
                              
                          $contractorIds = $this->ContractorBasics->find('list',
                                              ['conditions'=>['ContractorBasics.user_id !='=>$UserId],
                                               'keyField' => 'id','valueField' => 'user_id']);
                              
                          if(!empty($contractorIds->toArray()))
                          {
                                  
                              $contractorIds = $contractorIds->toArray();
                               
                              $conditions = ['Users.id IN'=>$contractorIds,
                                              'Users.id !='=>$UserId];
                              
                              $users= $this->Users->find('all',
                                              ['conditions'=>$conditions])
                                              ->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])
                                              ->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);
                              $this->paginate($users);    
                          }
                             
                    }
                     
              }

               $this->set('users', $users);                     

           }

    }
    
    public function addContractorAdmin($id=nul,$companyId=nul){
          
          $this->viewBuilder()->layout(false);
          $this->render(false);
          
          $this->loadModel('SubAdminRelations');
          
          $rId= base64_decode($id);
          $companyId= base64_decode($companyId);
          
          $data['sub_admin_id'] = $this->request->Session()->read('Auth.User.id');
          $data['contractor_id'] = $rId;
          $data['sub_admin_details_id'] = $companyId;
          
          $SubAdminRelations = $this->SubAdminRelations->newEntity($data);
          
          if($this->SubAdminRelations->save($SubAdminRelations)){
                    $this->Flash->success(__('The contractor has been assigned as Admin successfully.'));
                    return $this->redirect($this->referer());
          }else{
                    $this->Flash->error(__('The contractor cannot be assigned as Admin.'));
                    return $this->redirect($this->referer());
          }
    }
    
    /*
     *
     *job applications
     *
     */
    
    public function jobApplication(){
          
          $this->loadModel('JobApplications');
          $this->paginate = [ 'limit' => 10];
          
          $jobapplications = $this->JobApplications->find('all', [/*'conditions' => 
                                        ['JobApplications.status'=>0
                                        ],*/
                                        'fields' => [
                                            'contractor_id' => 'contractor_basics.user_id',
                                            'contractor_first_name' => 'contractor_basics.first_name',
                                            'contractor_last_name' => 'contractor_basics.last_name',
                                            'contractor_image' => 'contractor_basics.image',
                                            'contractor_bio' => 'contractor_basics.bio',
                                            'job_id' => 'JobApplications.job_id',
                                            'id' => 'JobApplications.id'
                                        ],
                                        'join' => [
                                                            [
                                                                'table' => 'contractor_basics', 
                                                                'type' => 'inner',
                                                                'conditions' =>['JobApplications.contractor_id = contractor_basics.user_id']
                                                            ]
                                                  ],
                            ]);
          
          $this->paginate($jobapplications);
          $this->set('jobapplications',$jobapplications->toArray());
          
    }
    
    /*
     *
     *add admins
     *
     */
    public function removeAdmin(){
        
        $this->paginate = [ 'limit' => 10];
        
        $this->loadModel('Users');
        $this->loadModel('ContractorBasics');
        $this->loadModel('EntrepreneurProfessionals');
        $this->loadModel('ContractorProfessionals');
        $this->loadModel('Keywords');
        $this->loadModel('Roadmaps');
        $this->loadModel('SubAdminRelations');
        
        $user = $this->Auth->user();
        $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
        $this->set('Keywords',$Keywords);

        if($user){
                    
            $users=[]; 
            $UserId = $this->request->Session()->read('Auth.User.id');

            $searchKeyword=trim($this->request->query('search'));
            $searchKeyword = str_replace("'","",$searchKeyword);  

            if(!empty($searchKeyword)){
                    
             //this code runs when search is done
             
                $admincontractorIds = $this->SubAdminRelations->find('list',
                                        ['keyField' => 'id','valueField' => 'contractor_id'])
                                        ->where(['SubAdminRelations.sub_admin_id' =>$UserId])
                                        ->group('contractor_id');
                
                if($admincontractorIds->toArray())
                {
                   
                   $admincontractorIds = $admincontractorIds->toArray();
                   
                    //this code runs when contractor is linked to subadmin
                    
                    $connection = ConnectionManager::get('default');
                          
                    $qq = "SELECT CP.user_id FROM keywords as KY INNER JOIN contractor_professionals as CP
                           ON FIND_IN_SET(KY.id, CP.keywords) where KY.name like '%".$searchKeyword."%' GROUP BY CP.user_id
                           UNION SELECT CB.user_id FROM contractor_basics as CB where CB.first_name like '%".$searchKeyword."%'
                           OR CB.last_name like '%".$searchKeyword."%' OR (CB.price='".$searchKeyword."' && CB.price!='' && CB.price!=0) GROUP BY CB.user_id";
                    
                    $sql = $connection->execute ($qq);
                    $user_ids = $sql->fetchAll('assoc');
                    
                    if(!empty($user_ids)){
                        
                        foreach($user_ids as $SingleUser):
                            
                            if(isset($SingleUser['user_id'])&&($SingleUser['user_id']!='')){
                                $contractorIds[] = $SingleUser['user_id'];
                            }
                            endforeach;
                            
                            $conditions = ['Users.id !='=>$UserId,
                                            'Users.id IN'=>$admincontractorIds];
                            
                            $users= $this->Users->find('all',['conditions'=>$conditions])
                                  ->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])
                                  ->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);
                            
                            $this->paginate($users); 
    
                        }
                              
                }
                 
              }else{
                    
                    //this code runs when search is not done
                    
                    $admincontractorIds = $this->SubAdminRelations->find('list',
                                        ['keyField' => 'id','valueField' => 'contractor_id'])
                                        ->where(['SubAdminRelations.sub_admin_id' =>$UserId])
                                        ->group('contractor_id');
                     
                    
                    if(!empty($admincontractorIds->toArray())){
                              
                             $admincontractorIds = $admincontractorIds->toArray();
                             
                              $contractorIds = $this->ContractorBasics->find('list',
                                              ['conditions'=>['ContractorBasics.user_id !='=>$UserId,
                                                              'ContractorBasics.user_id IN'=>$admincontractorIds],
                                               'keyField' => 'id','valueField' => 'user_id']);
                              
                             if(!empty($contractorIds->toArray())){
                                  
                                  $contractorIds = $contractorIds->toArray();
                                   
                                  $conditions = ['Users.id IN'=>$contractorIds,
                                                  'Users.id !='=>$UserId];
                                  
                                  $users= $this->Users->find('all',
                                                  ['conditions'=>$conditions])
                                                  ->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])
                                                  ->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);
                                  
                                  $this->paginate($users);
                                   
                             }
                   
                    }
                     
               }

               $this->set('users', $users);                     

           }

    }
    
    public function removeContractorAdmin($id){
          
          $this->viewBuilder()->layout(false);
          $this->render(false);
          
          $this->loadModel('SubAdminRelations');
          
          $rId= base64_decode($id);
           
          $SubAdminRelations = $this->SubAdminRelations->find('all',['conditions'=>[
                                                                      'SubAdminRelations.sub_admin_id'=>$this->request->Session()->read('Auth.User.id'),
                                                                      'SubAdminRelations.contractor_id'=>$rId ]])
                                                            ->first();
          
          if(!empty($SubAdminRelations->toArray())):
                
                $SubAdminRelations = $this->SubAdminRelations->get($SubAdminRelations->toArray()['id']);
               
                    if($this->SubAdminRelations->delete($SubAdminRelations)){
                              $this->Flash->success(__('The contractor has been removed as Admin successfully.'));
                              return $this->redirect($this->referer());
                    }else{
                              $this->Flash->error(__('The contractor cannot be removed as Admin.'));
                              return $this->redirect($this->referer());
                    }
          else:
                     $this->Flash->error(__('The contractor cannot be removed as Admin.'));
                    return $this->redirect($this->referer());
          endif;
           
    }
    
    /*
     *
     *
     *view contractor profile
     *
     */
    public function viewContractorProfile($id){
       
       $this->loadModel('Users');
       $this->loadModel('ContractorBasics');
       $this->loadModel('Countries');
       $this->loadModel('States');
       $this->loadModel('StartupTeams');
       $this->loadModel('Startups');
       $this->loadModel('userFollowers');

       $LoggedUserId = $this->request->Session()->read('Auth.User.id');
       $UserId = $this->request->Session()->read('Auth.User.id');

       $viewUserId = base64_decode($id);
       $validUserId = $this->Users->exists(['id'=>$viewUserId]);
       if($validUserId == 1){

        
        //Set user profile status
        $userProfileStatus = $this->UserImageWeb->getUserProfileStatus($viewUserId);
        if($userProfileStatus == 0){

            $this->Flash->error(__('This user profile is private.'));
            return $this->redirect(['action' => 'viewProfile']);

        }


        $UserId=$viewUserId;
        $this->set('viewUserId', $id);

                //Check user is followed by login user or not
        $followDetails= $this->userFollowers->exists(['followed_by' => $LoggedUserId, 'user_id'=>$viewUserId]);

        if($followDetails==1){
            $this->set('followStatus', '1');
        }else{
            $this->set('followStatus', '0');
        } 


    }else {

        $this->set('viewUserId', '');
        $this->set('followStatus', '0');

    }
      
                    $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

             //if logged user and view user id is same
             
          if($LoggedUserId == $viewUserId){

              $this->set('RatingStarupId', '');
              $this->set('viewUserId', '');
              $this->set('followStatus', '0');
          }

          if($user){

                        $country_list = $this->Countries->find('list')->toArray();
                        $this->set('countrylist',$country_list);

                    /// Get Rating
                        $ratingStar= $this->getRating($UserId);
                        $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
                        $proPercentage= $this->profilePercentage($UserId);
                        $this->set('proPercentage',$proPercentage);
                    //pr($proPercentage); die;


                        /*To check detail of LoggedIn User in ContractorBasics Table */
                        $contractordata = $this->ContractorBasics->find('all', [
                            'conditions' => ['ContractorBasics.user_id' => $UserId]])->contain(['Countries','States']);
                        $contractordata = $contractordata->first();

                        $OldImage ='';
                        if(!empty($contractordata)){
                        //Get user image
                            if(!empty($contractordata['image'])){
                                $OldImage = $contractordata['image']; 
                            }
                        //get state list
                            $this->set('dc','');
                            $this->set('ds','');
                            $state_list = $this->States->find('list',['conditions'=>['States.country_id'=>$contractordata->country_id]])->toArray();
                            $this->set('statelist',$state_list);

                            $contractorID = $contractordata->id;
                        $user = $this->ContractorBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $this->set('user',$user);
                        $userEmail=$user->email;
                        
                    }else {

                        $userdetail = $this->Users->get($UserId, ['contain' => '']); // Get record from User Table
                        //get state list
                        $this->set('dc',$userdetail->country);
                        $this->set('ds',$userdetail->state);
                        $state_list = $this->States->find('list',['conditions'=>['States.country_id'=>$userdetail->country]])->toArray();
                        $this->set('statelist',$state_list);

                        $this->set('user',$userdetail);
                        $userEmail=$userdetail->email;
                    } 
                    
                    $this->set('userEmail',$userEmail); 
  
          }   
    
    }
     
     /**
    * View ProfessionalProfile Method for Professional Profile edit
    *
    *
    */
    public function viewProfessionalProfile($id=null,$starupId = null)
    {
         $viewUserId = base64_decode($id);
        $this->set('viewUserId', $id);

        $this->loadModel('Users');
        $this->loadModel('ContractorBasics');  
        $this->loadModel('ContractorProfessionals'); 
        $this->loadModel('StartupTeams');
        $this->loadModel('userFollowers');
        $this->loadModel('Startups');

        $user = $this->Auth->user();/* To Check User LoggedIn OR NOt */

        $LoggedUserId = $this->request->Session()->read('Auth.User.id');
        $UserId = $this->request->Session()->read('Auth.User.id');

        $viewUserId = base64_decode($id);
        $validUserId = $this->Users->exists(['id'=>$viewUserId]);
        if($validUserId == 1){
            $UserId=$viewUserId;
            $this->set('viewUserId', $id);

                    //Check user is followed by login user or not
            $followDetails= $this->userFollowers->exists(['followed_by' => $LoggedUserId, 'user_id'=>$viewUserId]);

            if($followDetails==1){
                $this->set('followStatus', '1');
            }else{
                $this->set('followStatus', '0');
            }


        }else {
            $this->set('followStatus', '0');
            $this->set('viewUserId', '');
        }

        $this->set('startupId', $starupId);

             //Check startid and user exists in teamTable
        $RatingStarupId = base64_decode($starupId);

        if(!empty($starupId)){
           $startupDetails= $this->Startups->get($RatingStarupId);
           $startUpUserId= $startupDetails->user_id;
           $validHiredUser = $this->StartupTeams->exists(['startup_id' => $RatingStarupId, 'user_id'=>$viewUserId]);

                     //if($LoggedUserId == $startUpUserId) {
           if($validHiredUser == 1){
            $this->set('RatingStarupId', $starupId);
        }else {
            $this->set('RatingStarupId', '');
        }
                    
                    }else {
                        $this->set('RatingStarupId', '');
                    }
 
            $Experiences = $this->ContractorProfessionals->Experiences->find('list')->toArray();
            $this->set('Experiences',$Experiences);

            $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $Qualifications = $this->ContractorProfessionals->Qualifications->find('list')->toArray();
            $this->set('Qualifications',$Qualifications);

            $Certifications = $this->ContractorProfessionals->Certifications->find('list')->toArray();
            $this->set('Certifications',$Certifications); 

            $Skills = $this->ContractorProfessionals->Skills->find('list')->toArray();
            $this->set('Skills',$Skills);

            $PrefferStartups = $this->ContractorProfessionals->PrefferStartups->find('list')->toArray();
            $this->set('PrefferStartups',$PrefferStartups);

            $ContractorTypes = $this->ContractorProfessionals->ContractorTypes->find('list')->toArray();
            $this->set('ContractorTypes',$ContractorTypes);

            if($user){


                    /// Get Rating
                $ratingStar= $this->getRating($UserId);
                $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
                $proPercentage= $this->profilePercentage($UserId);
                $this->set('proPercentage',$proPercentage);

                /*To check detail of LoggedIn User in ContractorBasics Table */
                $contractordata = $this->ContractorBasics->find('all', [
                    'conditions' => ['ContractorBasics.user_id' => $UserId]])->contain(['Countries','States']);
                $contractordata = $contractordata->first();
                if(!empty($contractordata)){
                        //Get user image
                    if(!empty($contractordata['image'])){
                        $OldImage = $contractordata['image']; 
                        $OldPrice = $contractordata['price'];
                    }

                    $contractorID = $contractordata->id;
                        $user = $this->ContractorBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $this->set('user',$user);
                    }else {
                        $OldImage='';
                        $OldPrice ='';
                        $userdetail = $this->Users->get($UserId, ['contain' => '']); // Get record from User Table
                        $this->set('user',$userdetail);
                    } 


                    /// Professional body Content
                    $professional_user = $this->ContractorProfessionals->newEntity();

                    $professional_detail = $this->ContractorProfessionals->find('all',['conditions'=>['ContractorProfessionals.user_id'=> $UserId]])->select('id','user_id');
                    $professional_detail = $professional_detail->first();

                    if(!empty( $professional_detail)){
                        $profession_id =  $professional_detail->id;
                        $professional_user =  $this->ContractorProfessionals->get($profession_id,['contain'=>'Experiences']);
                        $this->set('professional_user',$professional_user);
                    }

                    

                    $this->set('professional_user',$professional_user);

                }  


            }
    /**
     * ListStartup method
     *
     *
     *
     ***/
    
    public function viewListStartup($id=null)
    {

            $viewUserId = base64_decode($id);
            $this->set('viewUserId', $id);

            $this->loadModel('StartupTeams');
            $this->loadModel('Users');
            $this->loadModel('ContractorBasics');
            $this->loadModel('StartupListProfiles');
            $this->loadModel('userFollowers');
            $this->loadModel('Startups');

            $user = $this->Auth->user(); 

            $LoggedUserId = $this->request->Session()->read('Auth.User.id');
            $UserId = $this->request->Session()->read('Auth.User.id');

             $viewUserId = base64_decode($id);
             $validUserId = $this->Users->exists(['id'=>$viewUserId]);
             if($validUserId == 1){
                    $UserId=$viewUserId;
                    $this->set('viewUserId', $id);

                    //Check user is followed by login user or not
                    $followDetails= $this->userFollowers->exists(['followed_by' => $LoggedUserId, 'user_id'=>$viewUserId]);

                    if($followDetails==1){
                            $this->set('followStatus', '1');
                    }else{
                        $this->set('followStatus', '0');
                    }

             }else {
                    $this->set('followStatus', '0');
                    $this->set('viewUserId', '');
             }
             
            if($user){
                
                    
                    
                    /// Get Rating
                    $ratingStar= $this->getRating($UserId);
                    $this->set('ratingStar',$ratingStar);

                    /// Get Percentage
                    $proPercentage= $this->profilePercentage($UserId);
                    $this->set('proPercentage',$proPercentage);

                    /*To check detail of LoggedIn User in ContractorBasics Table */
                    $contractordata = $this->ContractorBasics->find('all', [
                        'conditions' => ['ContractorBasics.user_id' => $UserId]]);
                    $contractordata = $contractordata->first();

                    $OldImage ='';
                    if(!empty($contractordata)){
                        //Get user image
                        if(!empty($contractordata['image'])){
                            $OldImage = $contractordata['image']; 
                        }
                        
                        $contractorID = $contractordata->id;
                        $user = $this->ContractorBasics->get($contractorID); // Get record from Contractor Baisc Table
                        $this->set('user',$user);

                    }else {

                        $user = $this->Users->get($UserId); // Get record from Users Table
                        $user['image']=$OldImage;
                        $this->set('user',$user);
                    }

                    /*To check detail of LoggedIn User in Statrtup team Table */
                    $startupTeamData = $this->StartupListProfiles->find('all', [
                        'conditions' => ['StartupListProfiles.user_id' => $UserId]]);
                    $startupTeamData = $startupTeamData->first();

                    $selectedIds='';
                    
                    if(!empty($startupTeamData)){
                        $values = $startupTeamData->startup_id;
                        if(!empty($values)){
                         $selectedIds= explode(',', $values);
                        }
                            //$startupdata = $this->Startups->StartupTeams->find('all',['conditions'=>['StartupTeams.user_id'=>$UserId]])->contain(['Startups'])->toArray();

                            $startupdata = $this->Startups->find('all')->toArray();                             
                    }else {
                        $startupdata='';
                    }                                                                  
                    /*To check detail of LoggedIn User in Startups Table */
                    //$startupdata = $this->Startups->find('all', [
                        //'conditions' => ['Startups.user_id' => $UserId]])->toArray();
                    //pr($startupdata);die;
                    $this->set('selectedIds',$selectedIds);
                    $this->set('startupdata',$startupdata);

        }  

    }
    
    /****
    *
    *  Get User Star Rating
    *
    *
    *
    *******/
    public function getRating($UserId)
    {
                    $this->loadModel('Ratings');
                    $user = $this->Auth->user();
                    if($user){
                                  //$UserId = $this->request->Session()->read('Auth.User.id');
                      $UserId= $UserId;
              
                      $countData = $this->Ratings->find('all',['conditions'=>['Ratings.given_to'=> $UserId]])->toArray();
                      $count= count($countData);
                      $ratingData = $this->Ratings->find('all',['conditions'=>['Ratings.given_to'=> $UserId]]);
                      $ratingSum=$ratingData->sumOf('rating_star');
                      if(!empty($ratingSum)){
                        $finalRating= $ratingSum/$count;
                    }else {
                     $finalRating=0;
                 }
              
                                 /// Show star accordig to rating
                 @list($int, $parse) = split('[.]', $finalRating);
                 $int;
                 $parse;
                 $star_view='';
                 for ($i = 1; $i <= $int; $i++) 
                 {
                                      //$star_view .= '<IMG src="'.$this->request->webroot.'img/star/star.gif">';
                  $star_view .='<li><i class="fa fa-star"></i></li>';
              }
                                  // Show half star
              if($parse >0 && $parse <=9 )
              {
                                      //$star_view .= '<IMG src="'.$this->request->webroot.'img/star/halfstar.gif">';
                  $star_view .='<li><i class="fa fa-star-half-empty"></i></li>';
                  $dim_star = 4-$int;
              }else{
                  $star_view .= "";
                  $dim_star = 5-$int;
              }
              
              $dim_star;
              if($dim_star!="")
              {
                  for ($i = 1; $i <= $dim_star; $i++) 
                  {
                                        //$star_view .= '<IMG src="'.$this->request->webroot.'img/star/dimstar.gif">';
                    $star_view .='<li><i class="fa fa-star-o"></i></li>';
                }
              }
              
              $ratingData= $star_view;
              
              }  
              
              return $ratingData;    
              }
              
               /****
    *
    *  Get Profile Percentage
    *
    *
    *
    *******/
    public function profilePercentage($UserId)
    {
          
          $this->loadModel('ContractorBasics');
          $this->loadModel('ContractorProfessionals');

          $user = $this->Auth->user();
          if($user){
                        //$UserId = $this->request->Session()->read('Auth.User.id');
            $UserId= $UserId;
            $contMaxPoints = 100;
            $ContPoint = 0;
    
                        /// Contractor Basics percentage
            $contractordata = $this->ContractorBasics->find('all', [
                'conditions' => ['ContractorBasics.user_id' => $UserId]]);
            $contractordata = $contractordata->first();
            if(!empty( $contractordata)){
                if(!empty($contractordata->price)) $ContPoint+=20;
                if(!empty($contractordata->image)) $ContPoint+=20;
                if(!empty($contractordata->bio)) $ContPoint+=20;
                if(!empty($contractordata->first_name)) $ContPoint+=20;
                if(!empty($contractordata->last_name)) $ContPoint+=20;
                if(!empty($contractordata->date_of_birth)) $ContPoint+=20;
                if(!empty($contractordata->country_id)) $ContPoint+=20;
                if(!empty($contractordata->state_id)) $ContPoint+=20;
            }
            $contractorPercentage = ($ContPoint*$contMaxPoints)/160;
                        //echo $contractorPercentage."%"; 
    
    
                        /// Contractor Professional percentage
            $contractorProfessional = $this->ContractorProfessionals->find('all',['conditions'=>['ContractorProfessionals.user_id'=> $UserId]]);
            $contractorProfessional = $contractorProfessional->first();
    
            $proMaxPoints = 100;
            $proPoint = 0;
            if(!empty( $contractorProfessional)){
                if(!empty($contractorProfessional->experience_id)) $proPoint+=20;
                if(!empty($contractorProfessional->keywords)) $proPoint+=20;
                if(!empty($contractorProfessional->qualifications)) $proPoint+=20;
                if(!empty($contractorProfessional->certifications)) $proPoint+=20;
                if(!empty($contractorProfessional->skills)) $proPoint+=20;
                if(!empty($contractorProfessional->startup_stage)) $proPoint+=20;
                if(!empty($contractorProfessional->contributor_type)) $proPoint+=20;
                if(!empty($contractorProfessional->accredited_investor)) $proPoint+=20;
            }  
            $contractorProfePercentage = ($proPoint*$proMaxPoints)/160;
                        //echo $contractorProfePercentage."%";
            $finalPercentageContractor=($contractorPercentage+$contractorProfePercentage)/2;
    
    
            /*  Over all profile percentage */
            $overallPercentage= number_format((float)$finalPercentageContractor, 0, '.', ''); 
    
        }

    return $overallPercentage;     

   }
   
  /*
      change Password
  */
  public function ChangePassword(){
          
    $this->LoadModel('Users');
    
    $flag = 1;
      
    $user = $this->Users->newEntity();
     
    $recovers = TableRegistry::get('RecoverPasswords');
    
    $user_id = $this->Auth->user('id');
	
// Get email and old pass by id
    
     $userData = $this->Users->get($user_id);
     $fullname='Anonymous';
     $EmailId=$userData->email;
     $oldpass= $userData->password;
	
    if ($this->request->is(['patch', 'post', 'put'])) {
                $user = $this->Users->patchEntity($user,[
                                        'id' => $user_id,
                                        'password1' => $this->request->data['password1'],
                                        'password2' => $this->request->data['password2']
                                        ],
                                        ['validate' => 'resetPass'
                                        ]);
                 
                // Match  old and new pass
				
                  $hasher = new DefaultPasswordHasher();
                  if ((new DefaultPasswordHasher)->check($this->request->data['password1'],$oldpass)) {
                    $PassFlag=1;
                  }else{
                    $PassFlag=0;
                  }
                
                 if($PassFlag == 1){
                         
                         $this->Flash->error(__('New password can not be same as old password.'));

                 }else {
					
                         $user->password =$this->request->data['password1']; 
                         $user->id = $user_id;
                         
                        if($this->Users->save($user)){
                         
						  // Send email if pass updated
							
                              $to = $EmailId;
                              $email = new Email();
							  
                              $email->template('updatedpass')
                                    ->emailFormat('html')
                                    ->from(['Crowdbootstrap@crowdbootstrap.com' => 'Crowd Bootstrap'])
                                    ->to($to)
                                    ->subject('Crowd Bootstrap - Updated Password') 
                                    ->viewVars(['fullname' => $fullname])                  
                                    ->send();
                                           
                                $this->Flash->success(__('The Password has been updated.'));

                        }else{
                              $this->Flash->error(__('The Password could not be saved.please try again'));
                        }

                  }/// Pass match with old end          
    }
   

            $this->set(compact('user'));
            $this->set('_serialize', ['user']);

  }
    
}
?>
