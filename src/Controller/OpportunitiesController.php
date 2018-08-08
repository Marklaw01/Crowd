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
class OpportunitiesController extends AppController{

    public function initialize()
    {
        parent::initialize();
        $this->loadComponent('Upload');
        $this->loadComponent('Multiupload');
        $this->loadComponent('UserImageWeb');
        $this->loadComponent('WebNotification');
        $this->loadComponent('Feeds');
    }

    public $helpers = ['Custom'];

    /**
    * index Method for list messages
    *
    *
    */

    public function index()
    {
        if ($this->Auth->user()) {
            $this->redirect(['action' => 'betaTester']);
        }   
    }

  
    /**
    * betaTester Method 
    *
    *
    */
    public function betaTester()
    {
        
    }

    /**
    * boardMembers Method 
    *
    *
    */
    public function boardMembers()
    {
        
    }

    /**
    * communalAssets Method 
    *
    *
    */
    public function communalAssets()
    {
        
    }

     /**
    * endorsers Method 
    *
    *
    */
    public function endorsers()
    {
        
    }

    /**
    * consulting Method
    *
    */

    public function consulting()
    {
        
    }


    /**
    * earlyAdopters Method
    *
    *
    */

    public function earlyAdopters()
    {
            
    }


    /**
    * focusGroup Method
    *
    *
    *
    **/
    public function focusGroup()
    {
        
    }

    
    
     /**
    * recuiter method
    *
    *
    */
    public function recuiter()
    {       
            $this->paginate = [ 'limit' => 10,'order' => ['Jobs.id' => 'desc']];
            $this->loadModel('Jobs');
            $this->loadModel('Countries');
            $country_list = $this->Countries->find('list')->toArray();
            $this->set('countrylist',$country_list);

            $UserId = $this->Auth->user('id');

            $searchKeyword=$this->request->query('search');
            $this->set('searchKeyword',$searchKeyword);
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }
            $country=$this->request->query('country');
            $this->set('country',$country);
            $state=$this->request->query('state');
            $this->set('state',$state);

            if(!empty($searchKeyword) || !empty($country) || !empty($country)){ 

                if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM job_posting_keywords as KY INNER JOIN jobs as SU ON FIND_IN_SET(KY.id, SU.posting_keywords) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                    
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');

                    $qq2 = "SELECT JB.id FROM sub_admin_details as SAD INNER JOIN jobs as JB ON FIND_IN_SET(SAD.id, JB.company_id) where SAD.company_name like  '%".$searchKeyword."%' GROUP BY JB.id";
                    
                    $sql2 = $connection->execute ($qq2);
                    $startup_ids2 = $sql2->fetchAll('assoc');


                    $finalArray =array_merge($startup_ids, $startup_ids2);
                    $startupIDs=[];
                    foreach($finalArray as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                }else{
                    $startupIDs=[];
                } 

                if(!empty($startupIDs)){
                    
                    $myJobs= $this->Jobs->find('all',
                        ['conditions'=>
                            [
                                'Jobs.user_id'=>$UserId, 'Jobs.status'=>1,

                                'OR' =>[
                                            ['Jobs.country_id' => $country],
                                            ['Jobs.state_id' => $state],
                                            ['Jobs.id IN' =>$startupIDs]
                                        ]        
                            ]

                        ])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');
    
                }else{

                    if(!empty($searchKeyword)){

                        $myJobs= $this->Jobs->find('all',
                            ['conditions'=>
                                [
                                    'Jobs.user_id'=>$UserId, 'Jobs.status'=>1,

                                    'OR' =>[
                                                ['Jobs.country_id' => $country],
                                                ['Jobs.state_id' => $state],
                                                ['Jobs.job_title LIKE' => '%'.$searchKeyword.'%']
                                            ]        
                                ]

                            ])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');

                    }else{
                        $myJobs= $this->Jobs->find('all',
                            ['conditions'=>
                                [
                                    'Jobs.user_id'=>$UserId, 'Jobs.status'=>1,

                                    'OR' =>[
                                                ['Jobs.country_id' => $country],
                                                ['Jobs.state_id' => $state]
                                                //['Jobs.job_title LIKE' => '%'.$searchKeyword.'%']
                                            ]        
                                ]

                            ])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');
                    }
                }

                $this->set('myJobs',$this->paginate($myJobs));

            }else{    
                
                $myJobs= $this->Jobs->find('all',['conditions'=>['Jobs.user_id'=>$UserId, 'Jobs.status'=>1]])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');

                $this->set('myJobs',$this->paginate($myJobs));
            }

    }
    /**
    * archived Method
    *
    *
    *
    **/
    public function archived()
    {
            $this->paginate = [ 'limit' => 10,'order' => ['Jobs.id' => 'desc']];
            $this->loadModel('Jobs');
            $this->loadModel('Countries');
            $country_list = $this->Countries->find('list')->toArray();
            $this->set('countrylist',$country_list);

            $searchKeyword=$this->request->query('search');
            $this->set('searchKeyword',$searchKeyword);
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }
            $country=$this->request->query('country');
            $this->set('country',$country);
            $state=$this->request->query('state');
            $this->set('state',$state);

            $UserId = $this->Auth->user('id');

            if(!empty($searchKeyword) || !empty($country) || !empty($country)){ 

                if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM job_posting_keywords as KY INNER JOIN jobs as SU ON FIND_IN_SET(KY.id, SU.posting_keywords) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                    
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');

                    $qq2 = "SELECT JB.id FROM sub_admin_details as SAD INNER JOIN jobs as JB ON FIND_IN_SET(SAD.id, JB.company_id) where SAD.company_name like  '%".$searchKeyword."%' GROUP BY JB.id";
                    
                    $sql2 = $connection->execute ($qq2);
                    $startup_ids2 = $sql2->fetchAll('assoc');


                    $finalArray =array_merge($startup_ids, $startup_ids2);
                    $startupIDs=[];
                    foreach($finalArray as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                }else{
                    $startupIDs=[];
                } 

                if(!empty($startupIDs)){
                    
                    $myJobs= $this->Jobs->find('all',
                        ['conditions'=>
                            [
                                'Jobs.user_id'=>$UserId, 'Jobs.status'=>2,

                                'OR' =>[
                                            ['Jobs.country_id' => $country],
                                            ['Jobs.state_id' => $state],
                                            ['Jobs.id IN' =>$startupIDs]
                                        ]        
                            ]

                        ])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');
    
                }else{

                    if(!empty($searchKeyword)){

                        $myJobs= $this->Jobs->find('all',
                            ['conditions'=>
                                [
                                    'Jobs.user_id'=>$UserId, 'Jobs.status'=>2,

                                    'OR' =>[
                                                ['Jobs.country_id' => $country],
                                                ['Jobs.state_id' => $state],
                                                ['Jobs.job_title LIKE' => '%'.$searchKeyword.'%']
                                            ]        
                                ]

                            ])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');

                    }else{
                        $myJobs= $this->Jobs->find('all',
                            ['conditions'=>
                                [
                                    'Jobs.user_id'=>$UserId, 'Jobs.status'=>2,

                                    'OR' =>[
                                                ['Jobs.country_id' => $country],
                                                ['Jobs.state_id' => $state]
                                                //['Jobs.job_title LIKE' => '%'.$searchKeyword.'%']
                                            ]        
                                ]

                            ])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');
                    }
                }
                $this->set('myJobs',$this->paginate($myJobs));

            }else{
                $myJobs= $this->Jobs->find('all',['conditions'=>['Jobs.user_id'=>$UserId, 'Jobs.status'=>2]])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');

                $this->set('myJobs',$this->paginate($myJobs)); 
            }
    }
    /**
    * deactivated Method
    *
    *
    *
    **/
    public function deactivated()
    {
            $this->paginate = [ 'limit' => 10,'order' => ['Jobs.id' => 'desc']];
            $this->loadModel('Jobs');
            $this->loadModel('Countries');
            $country_list = $this->Countries->find('list')->toArray();
            $this->set('countrylist',$country_list);

            $searchKeyword=$this->request->query('search');
            $this->set('searchKeyword',$searchKeyword);
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }
            $country=$this->request->query('country');
            $this->set('country',$country);
            $state=$this->request->query('state');
            $this->set('state',$state);

            $UserId = $this->Auth->user('id');

            if(!empty($searchKeyword) || !empty($country) || !empty($country)){ 

                if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM job_posting_keywords as KY INNER JOIN jobs as SU ON FIND_IN_SET(KY.id, SU.posting_keywords) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                    
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');

                    $qq2 = "SELECT JB.id FROM sub_admin_details as SAD INNER JOIN jobs as JB ON FIND_IN_SET(SAD.id, JB.company_id) where SAD.company_name like  '%".$searchKeyword."%' GROUP BY JB.id";
                    
                    $sql2 = $connection->execute ($qq2);
                    $startup_ids2 = $sql2->fetchAll('assoc');


                    $finalArray =array_merge($startup_ids, $startup_ids2);
                    $startupIDs=[];
                    foreach($finalArray as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                }else{
                    $startupIDs=[];
                } 

                if(!empty($startupIDs)){
                    
                    $myJobs= $this->Jobs->find('all',
                        ['conditions'=>
                            [
                                'Jobs.user_id'=>$UserId, 'Jobs.status'=>3,

                                'OR' =>[
                                            ['Jobs.country_id' => $country],
                                            ['Jobs.state_id' => $state],
                                            ['Jobs.id IN' =>$startupIDs]
                                        ]        
                            ]

                        ])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');
    
                }else{

                    if(!empty($searchKeyword)){

                        $myJobs= $this->Jobs->find('all',
                            ['conditions'=>
                                [
                                    'Jobs.user_id'=>$UserId, 'Jobs.status'=>3,

                                    'OR' =>[
                                                ['Jobs.country_id' => $country],
                                                ['Jobs.state_id' => $state],
                                                ['Jobs.job_title LIKE' => '%'.$searchKeyword.'%']
                                            ]        
                                ]

                            ])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');
                        
                    }else{
                        $myJobs= $this->Jobs->find('all',
                            ['conditions'=>
                                [
                                    'Jobs.user_id'=>$UserId, 'Jobs.status'=>3,

                                    'OR' =>[
                                                ['Jobs.country_id' => $country],
                                                ['Jobs.state_id' => $state]
                                                //['Jobs.job_title LIKE' => '%'.$searchKeyword.'%']
                                            ]        
                                ]

                            ])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');
                    }
                }

                $this->set('myJobs',$this->paginate($myJobs));

            }else{

                $myJobs= $this->Jobs->find('all',['conditions'=>['Jobs.user_id'=>$UserId, 'Jobs.status'=>3]])->contain(['SubAdminDetails','Countries','States','JobFollowers'])->order('Jobs.id DESC');

                $this->set('myJobs',$this->paginate($myJobs));
            }
    }

    /**
    * recuiter method
    *
    *
    */
    public function addJobs()
    {       
            $this->loadModel('Countries');
            $country_list = $this->Countries->find('list')->toArray();
            $this->set('countrylist',$country_list);

            $this->loadModel('JobIndustries');
            $job_industry = $this->JobIndustries->find('list')->toArray();
            $this->set('jobindustry',$job_industry);

            $this->loadModel('JobTypes');
            $job_type = $this->JobTypes->find('list')->toArray();
            $this->set('jobtype',$job_type);  

            $this->loadModel('JobPostingKeywords');
            $job_posting_eywords = $this->JobPostingKeywords->find('list')->toArray();
            $this->set('jobpostingkeyword',$job_posting_eywords); 

            $this->loadModel('Skills');
            $skills = $this->Skills->find('list')->toArray();
            $this->set('skill',$skills);  

            $UserId = $this->Auth->user('id'); 

            //Get Hired Company Lists
            $this->loadModel('SubAdminRelations'); 
            $companyDetails= $this->SubAdminRelations->find('all',['conditions' => ['SubAdminRelations.contractor_id' => $UserId]])->contain(['SubAdminDetails'])->toArray();
            $this->set('company',$companyDetails); 
          


            //Save Job
            $flag=0;
            $this->loadModel('Jobs'); 
            $jobs = $this->Jobs->newEntity();

            if ($this->request->is('post')) {
                //pr($this->request->data); die;
                //Upload Doc
                $uploadDocError='';
                if(!empty($this->request->data['doc_name']['name'])){
                    $doc_name = $this->request->data['doc_name'];
                    $docName = $this->Multiupload->jobsUpload($doc_name,$this->request->data['file_type'][0]);
                    if(empty($docName['errors'])){
                        $uploadDocName=$docName['fileName'];
                    }else{
                        $flag=1;
                        $uploadDocError=$docName['errors'];
                    }
                }else{
                    $uploadDocName='';
                }

                //Upload Mp3
                $uploadMp3Error='';
                if(!empty($this->request->data['mp3_name']['name'])){
                    $mp3_name = $this->request->data['mp3_name'];
                    $mp3Name = $this->Multiupload->jobsUpload($mp3_name,$this->request->data['file_type'][1]);
                    if(empty($mp3Name['errors'])){
                        $uploadMp3Name=$mp3Name['fileName'];
                    }else{
                        $flag=1;
                        $uploadMp3Error=$mp3Name['errors'];
                    }
                }else{
                    $uploadMp3Name='';
                }    

                //Upload Mp4
                $uploadMp4Error='';
                if(!empty($this->request->data['mp4_name']['name'])){
                    $mp4_name = $this->request->data['mp4_name'];
                    $mp4Name = $this->Multiupload->jobsUpload($mp4_name,$this->request->data['file_type'][2]);

                    if(empty($mp4Name['errors'])){
                        $uploadMp4Name=$mp4Name['fileName'];
                    }else{
                        $flag=1;
                        $uploadMp4Error=$mp4Name['errors'];
                    }
                }else{
                    $uploadMp4Name='';
                }    

                if(!empty($flag)){

                    if(!empty($uploadDocError)){
                      $this->Flash->error($uploadDocError);  
                    }
                    if(!empty($uploadMp3Error)){
                      $this->Flash->error($uploadMp3Error); 
                    }
                    if(!empty($uploadMp4Error)){
                      $this->Flash->error($uploadMp4Error); 
                    }  

                }else{

                    $this->request->data['user_id']=$UserId;
                    $this->request->data['audio']=$uploadMp3Name;
                    $this->request->data['video']=$uploadMp4Name;
                    $this->request->data['document']=$uploadDocName;
                    $this->request->data['status']=1;

                    $job_type=$this->request->data['job_type'];


                    $industry_id ='';
                    if(!empty($this->request->data['industry_id'])){
                        $industry_id = implode(',', $this->request->data['industry_id']);
                    }
                    $this->request->data['industry_id']=$industry_id;


                    $skill ='';
                    if(!empty($this->request->data['skills'])){
                        $skill = implode(',', $this->request->data['skills']);
                    }
                    $this->request->data['skills']=$skill;

                    $posting_keywords ='';
                    if(!empty($this->request->data['posting_keywords'])){
                        $posting_keywords = implode(',', $this->request->data['posting_keywords']);
                    }
                    $this->request->data['posting_keywords']=$posting_keywords;

                    $jobs = $this->Jobs->patchEntity($jobs, $this->request->data);
                    $jobs->job_type=$job_type;
                    $resultSave = $this->Jobs->save($jobs);
                    if($resultSave)
                    {   
                        //Save Feeds
                        $this->Feeds->saveJobFeeds($UserId,'feeds_job_added',$resultSave->id);

                        $this->Flash->success('The job has been saved successfully.');
                        $this->redirect($this->referer());

                    }else{

                        $this->Flash->error('The job could not be saved. Please, try again.');
                        
                    }
                }    

            }
            $this->set('jobs',$jobs);

    }


    /**
    * editJob method
    *
    *
    */
    public function editJob($id = null)
    {

            $this->loadModel('Countries');
            $country_list = $this->Countries->find('list')->toArray();
            $this->set('countrylist',$country_list);

            $this->loadModel('JobIndustries');
            $job_industry = $this->JobIndustries->find('list')->toArray();
            $this->set('jobindustry',$job_industry);

            $this->loadModel('JobTypes');
            $job_type = $this->JobTypes->find('list')->toArray();
            $this->set('jobtype',$job_type);  

            $this->loadModel('JobPostingKeywords');
            $job_posting_eywords = $this->JobPostingKeywords->find('list')->toArray();
            $this->set('jobpostingkeyword',$job_posting_eywords); 

            $this->loadModel('Skills');
            $skills = $this->Skills->find('list')->toArray();
            $this->set('skill',$skills); 

            $this->loadModel('Jobs');  

            $Id = base64_decode($id);
            $UserId = $this->Auth->user('id'); 
            $jobDetails = $this->Jobs->find('all',['conditions' => ['Jobs.id' => $Id, 'Jobs.user_id' => $UserId]])->contain(['SubAdminDetails','Countries','States','JobTypes'])->first();
            $this->set('jobDetails',$jobDetails); 
            //pr($jobDetails); die;
            if(empty($jobDetails)){
                $this->redirect(['action' => 'recuiter']);
            }

            //Get Hired Company Lists
            $this->loadModel('SubAdminRelations'); 
            $companyDetails= $this->SubAdminRelations->find('all',['conditions' => ['SubAdminRelations.contractor_id' => $UserId]])->contain(['SubAdminDetails'])->toArray();
            $this->set('company',$companyDetails); 
          


            //Save Job
            $flag=0;
            $jobs = $this->Jobs->newEntity();

            if ($this->request->is('post')) {
                //pr($this->request->data); die;
                //Upload Doc
                $uploadDocError='';
                if(!empty($this->request->data['doc_name']['name'])){
                    $doc_name = $this->request->data['doc_name'];
                    $docName = $this->Multiupload->jobsUpload($doc_name,$this->request->data['file_type'][0]);
                    if(empty($docName['errors'])){
                        $uploadDocName=$docName['fileName'];
                    }else{
                        $flag=1;
                        $uploadDocError=$docName['errors'];
                    }
                }else{
                    $uploadDocName=$jobDetails->document;
                }

                //Upload Mp3
                $uploadMp3Error='';
                if(!empty($this->request->data['mp3_name']['name'])){
                    $mp3_name = $this->request->data['mp3_name'];
                    $mp3Name = $this->Multiupload->jobsUpload($mp3_name,$this->request->data['file_type'][1]);
                    if(empty($mp3Name['errors'])){
                        $uploadMp3Name=$mp3Name['fileName'];
                    }else{
                        $flag=1;
                        $uploadMp3Error=$mp3Name['errors'];
                    }
                }else{
                    $uploadMp3Name=$jobDetails->audio;
                }    

                //Upload Mp4
                $uploadMp4Error='';
                if(!empty($this->request->data['mp4_name']['name'])){
                    $mp4_name = $this->request->data['mp4_name'];
                    $mp4Name = $this->Multiupload->jobsUpload($mp4_name,$this->request->data['file_type'][2]);

                    if(empty($mp4Name['errors'])){
                        $uploadMp4Name=$mp4Name['fileName'];
                    }else{
                        $flag=1;
                        $uploadMp4Error=$mp4Name['errors'];
                    }
                }else{
                    $uploadMp4Name=$jobDetails->video;
                }    
                echo '<pre>';
                print_r($uploadMp4Name); die;

                if(!empty($flag)){

                    if(!empty($uploadDocError)){
                      $this->Flash->error($uploadDocError);  
                    }
                    if(!empty($uploadMp3Error)){
                      $this->Flash->error($uploadMp3Error); 
                    }
                    if(!empty($uploadMp4Error)){
                      $this->Flash->error($uploadMp4Error); 
                    }  

                }else{

                    $this->request->data['user_id']=$UserId;
                    $this->request->data['audio']=$uploadMp3Name;
                    $this->request->data['video']=$uploadMp4Name;
                    $this->request->data['document']=$uploadDocName;
                    $this->request->data['status']=$jobDetails->status;

                    $job_type=$this->request->data['job_type'];


                    $industry_id ='';
                    if(!empty($this->request->data['industry_id'])){
                        $industry_id = implode(',', $this->request->data['industry_id']);
                    }
                    $this->request->data['industry_id']=$industry_id;


                    $skill ='';
                    if(!empty($this->request->data['skills'])){
                        $skill = implode(',', $this->request->data['skills']);
                    }
                    $this->request->data['skills']=$skill;

                    $posting_keywords ='';
                    if(!empty($this->request->data['posting_keywords'])){
                        $posting_keywords = implode(',', $this->request->data['posting_keywords']);
                    }
                    $this->request->data['posting_keywords']=$posting_keywords;

                    $jobs = $this->Jobs->patchEntity($jobs, $this->request->data);
                    $jobs->job_type=$job_type;
                    $jobs->id=$jobDetails->id;
                    $result = $this->Jobs->save($jobs);
                    if($result)
                    {
                        $this->Flash->success('The job has been updated successfully.');
                        $this->redirect($this->referer());

                    }else{

                        $this->Flash->error('The job could not be updated. Please, try again.');
                        
                    }
                }    

            }
            $this->set('jobs',$jobs);
    }

    /**
    * jobs method
    *
    *
    */
    public function viewJob($id = null)
    {       
            $jobId = base64_decode($id);
            $UserId = $this->Auth->user('id');
            $this->set('UserId',$UserId);

            $this->loadModel('Skills');
            $Skills = $this->Skills->find('list')->toArray();
            $this->set('Skills',$Skills);

            $this->loadModel('JobIndustries');
            $job_industry = $this->JobIndustries->find('list')->toArray();
            $this->set('jobindustry',$job_industry);

            $this->loadModel('JobPostingKeywords');
            $job_posting_eywords = $this->JobPostingKeywords->find('list')->toArray();
            $this->set('jobpostingkeyword',$job_posting_eywords); 

            $this->loadModel('Jobs'); 
            $JobsDetails = $this->Jobs->find('all',['conditions' => ['Jobs.id' => $jobId]])->contain(['SubAdminDetails','Countries','States','JobIndustries','JobTypes'])->first();
            
            $this->set('JobsDetails',$JobsDetails);

    }


    /**
     * deleteJob method
     *
     * 
     *
     */
    public function deleteJob($id = null)
    {
        $this->loadModel('Jobs');
        $id = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $Jobs = $this->Jobs->get($id);
        if ($this->Jobs->delete($Jobs)) {
            $this->Flash->success('The job has been deleted successfully.');
        } else {
            $this->Flash->error('The job could not be deleted. Please, try again.');
        }
        return $this->redirect(['action' => 'recuiter']);
    }

    /**
     * deleteJob method
     *
     * 
     *
     */
    public function archiveJob($id = null)
    {
        $this->loadModel('Jobs');
        $id = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $res= $this->Jobs->query()
                ->update()
                ->set(['status' => 2])
                ->where(['id' => $id])
                ->execute();

        if ($res) {
            $this->Flash->success('The job has been archived successfully.');
        } else {
            $this->Flash->error('The job could not be archived. Please, try again.');
        }
        return $this->redirect(['action' => 'recuiter']);
    }

    /**
     * deactivateJob method
     *
     * 
     *
     */
    public function deactivateJob($id = null)
    {
        $this->loadModel('Jobs');
        $id = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $res= $this->Jobs->query()
                ->update()
                ->set(['status' => 3])
                ->where(['id' => $id])
                ->execute();

        if ($res) {
            $this->Flash->success('The job has been deactivated successfully.');
        } else {
            $this->Flash->error('The job could not be deactivated. Please, try again.');
        }
        return $this->redirect(['action' => 'recuiter']);
    }

    /**
     * deactivateJob method
     *
     * 
     *
     */
    public function activateJob($id = null)
    {
        $this->loadModel('Jobs');
        $id = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $res= $this->Jobs->query()
                ->update()
                ->set(['status' => 1])
                ->where(['id' => $id])
                ->execute();

        if ($res) {
            $this->Flash->success('The job has been activated successfully.');
        } else {
            $this->Flash->error('The job could not be activated. Please, try again.');
        }
        return $this->redirect(['action' => 'recuiter']);
    }

    /**
    * jobs method
    *
    *
    */
    public function jobs()
    {       
            $this->paginate = [ 'limit' => 10,'order' => ['Jobs.id' => 'desc']];
            $this->loadModel('Jobs');
            $this->loadModel('Countries');
            $country_list = $this->Countries->find('list')->toArray();
            $this->set('countrylist',$country_list);

            $UserId = $this->Auth->user('id');

            $searchKeyword=$this->request->query('search');
            $this->set('searchKeyword',$searchKeyword);
            if (strpos($searchKeyword, "'") !== false) {
                $searchKeywordArray=explode("'", $searchKeyword);
                $searchKeyword=$searchKeywordArray[0];
            }
            $country=$this->request->query('country');
            $this->set('country',$country);
            $state=$this->request->query('state');
            $this->set('state',$state);

            if(!empty($searchKeyword) || !empty($country) || !empty($country)){ 

                if(!empty($searchKeyword)){

                    $connection = ConnectionManager::get('default');
                    $qq = "SELECT SU.id FROM job_posting_keywords as KY INNER JOIN jobs as SU ON FIND_IN_SET(KY.id, SU.posting_keywords) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id";
                    
                    $sql = $connection->execute ($qq);
                    $startup_ids = $sql->fetchAll('assoc');

                    $qq2 = "SELECT JB.id FROM sub_admin_details as SAD INNER JOIN jobs as JB ON FIND_IN_SET(SAD.id, JB.company_id) where SAD.company_name like  '%".$searchKeyword."%' GROUP BY JB.id";
                    
                    $sql2 = $connection->execute ($qq2);
                    $startup_ids2 = $sql2->fetchAll('assoc');


                    $finalArray =array_merge($startup_ids, $startup_ids2);
                    $startupIDs=[];
                    foreach($finalArray as $SingleUser):
                            if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                            }
                    endforeach;

                }else{
                    $startupIDs=[];
                } 

                if(!empty($startupIDs)){
                    
                    $myJobs= $this->Jobs->find('all',
                        ['conditions'=>
                            [
                                'Jobs.user_id != '=>$UserId, 'Jobs.status'=>1,

                                'OR' =>[
                                            ['Jobs.country_id' => $country],
                                            ['Jobs.state_id' => $state],
                                            ['Jobs.id IN' =>$startupIDs]
                                        ]        
                            ]

                        ])->contain(['SubAdminDetails','Countries','States'])->order('Jobs.id DESC');
    
                }else{

                    if(!empty($searchKeyword)){

                        $myJobs= $this->Jobs->find('all',
                            ['conditions'=>
                                [
                                    'Jobs.user_id !='=>$UserId, 'Jobs.status'=>1,

                                    'OR' =>[
                                                ['Jobs.country_id' => $country],
                                                ['Jobs.state_id' => $state],
                                                ['Jobs.job_title LIKE' => '%'.$searchKeyword.'%']
                                            ]        
                                ]

                            ])->contain(['SubAdminDetails','Countries','States'])->order('Jobs.id DESC');

                    }else{
                        $myJobs= $this->Jobs->find('all',
                            ['conditions'=>
                                [
                                    'Jobs.user_id !='=>$UserId, 'Jobs.status'=>1,

                                    'OR' =>[
                                                ['Jobs.country_id' => $country],
                                                ['Jobs.state_id' => $state]
                                                //['Jobs.job_title LIKE' => '%'.$searchKeyword.'%']
                                            ]        
                                ]

                            ])->contain(['SubAdminDetails','Countries','States'])->order('Jobs.id DESC');
                    }
                }

                $this->set('myJobs',$this->paginate($myJobs));

            }else{  

                $this->loadModel('ContractorProfessionals');
                $conditions = [];
                            array_push($conditions,["Jobs.user_id !="=>$UserId, 'Jobs.status'=>1]);
                            $contractorKeywords = $this->ContractorProfessionals->find('all')
                                                    ->where(['user_id'=>$UserId])
                                                    ->select(['skills'])
                                                    ->first();  
                if(!empty($contractorKeywords)&&($contractorKeywords->skills!='')){
                    $conditions['OR'] = [];
                    $contractorKeywords = $contractorKeywords->toArray();
                    
                    foreach(explode(',',$contractorKeywords['skills']) as $single_keyword):
                         
                         array_push($conditions['OR'],["FIND_IN_SET($single_keyword,Jobs.skills)"]);
                         
                    endforeach;

                    $myJobs = $this->Jobs->find('all')
                                            ->where($conditions)->contain(['SubAdminDetails','Countries','States'])
                                            ->order('Jobs.id DESC');
                                            //pr($query); die;
                } else {
                    $myJobs='';
                }
                //$myJobs= $this->Jobs->find('all',['conditions'=>['Jobs.user_id !='=>$UserId, 'Jobs.status'=>1]])->contain(['SubAdminDetails','Countries','States'])->order('Jobs.id DESC');

                $this->set('myJobs',$this->paginate($myJobs));
            }  

    }

    /**
    * viewJobDetails method
    *
    *
    */
    public function viewJobDetails($id = null)
    {       
            $jobId = base64_decode($id);
            $UserId = $this->Auth->user('id');
            $this->set('UserId',$UserId);

            $this->loadModel('Skills');
            $Skills = $this->Skills->find('list')->toArray();
            $this->set('Skills',$Skills);

            $this->loadModel('JobIndustries');
            $job_industry = $this->JobIndustries->find('list')->toArray();
            $this->set('jobindustry',$job_industry);

            $this->loadModel('JobPostingKeywords');
            $job_posting_eywords = $this->JobPostingKeywords->find('list')->toArray();
            $this->set('jobpostingkeyword',$job_posting_eywords); 

            //check job followed or not
            $this->loadModel('JobFollowers');
            $exists = $this->JobFollowers->exists(['job_id' => $jobId, 'user_id'=>$UserId]);
            $this->set('jobFollow', $exists);

            //check job applied or not
            $this->loadModel('JobApplies');
            $jobApply = $this->JobApplies->exists(['job_id' => $jobId, 'user_id'=>$UserId]);
            $this->set('jobApply', $jobApply);

            $this->loadModel('Jobs'); 
            $JobsDetails = $this->Jobs->find('all',['conditions' => ['Jobs.id' => $jobId]])->contain(['SubAdminDetails','Countries','States','JobIndustries','JobTypes','Users'])->first();
            
            $this->set('JobsDetails',$JobsDetails);

    }



    /*
     *  followJob method for follow job
     *
     *
     *
     *
     ***/
     public function followJob($id = null)
    {       
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $user = $this->Auth->user();
            if($user){

                    $this->loadModel('Jobs');
                    $this->loadModel('JobFollowers');
                    $UserId = $this->request->Session()->read('Auth.User.id');
                    $Id = base64_decode($id);

                    $exists = $this->Jobs->exists(['id' => $Id, 'user_id !='=>$UserId]);
                    
                    $jobDetails = $this->Jobs->get($Id);
                    $jobOwnerId =$jobDetails->user_id;
                    $jobName =$jobDetails->job_title;

                    $follow = $this->JobFollowers->newEntity(); 

                    $follow = $this->JobFollowers->patchEntity($follow, $this->request->data);
                    $follow->job_id=$Id;
                    $follow->user_id=$UserId;
                   // $campaign = $this->Campaigns->get($Id);
                    if(!empty($exists)){
                       $result = $this->JobFollowers->save($follow);
                        if ($result) {

                            //Save Feeds
                            $this->Feeds->saveJobFeeds($UserId,'feeds_job_following',$Id);

                            //Save user notification
                            //$values = [];
                            $values = ['job_id'=>$Id,'job_title'=>$jobName];
                            //,json_encode((object)$values)
                            $link= Router::url(['controller' => 'Opportunities', 'action' => 'viewJobDetails',$id]);

                            $this->WebNotification->sendNotification($UserId,$jobOwnerId,'Follow_Job','has started following your job <strong>'.$jobName.'</strong>',$link,$values);

                             $this->redirect(['action' => 'viewJobDetails',$id]);
                             $this->Flash->success('Job has been followed successfully.'); 
   
                        }
                    }else {
                        $this->redirect(['action' => 'viewJobDetails',$id]);
                        $this->Flash->error('There is some problem can not follow job now.');
                    }
            }       
    }



    /*
     *  unfollowJob method for unfollowJob job
     *
     *
     *
     *
     ***/
    public function unfollowJob($id = null)
    {
            $this->viewBuilder()->layout(false);
            $this->render(false);
            $user = $this->Auth->user();
            if($user){

                    $this->loadModel('Jobs');
                    $this->loadModel('JobFollowers');

                    $UserId = $this->request->Session()->read('Auth.User.id');  
                    $Id = base64_decode($id);

                    $exists = $this->Jobs->exists(['id' => $Id, 'user_id !='=>$UserId]);
                    $jobDetails = $this->Jobs->get($Id);
                    $jobOwnerId =$jobDetails->user_id;
                    $jobName =$jobDetails->job_title;

                    if(!empty($exists)){
                        $query = $this->JobFollowers->query();
                        $query->delete()
                            ->where(['job_id' => $Id, 'user_id'=>$UserId])
                            ->execute();

                            //Save user notification
                            //$values = [];
                            $values = ['job_id'=>$Id,'job_title'=>$jobName];
                            //,json_encode($values);
                            $link= Router::url(['controller' => 'Opportunities', 'action' => 'viewJobDetails',$id]);
                            $this->WebNotification->sendNotification($UserId,$jobOwnerId,'UnFollow_Job','has un-followed your job <strong>'.$jobName.'.</strong>',$link,$values);

                            $this->redirect(['action' => 'viewJobDetails',$id]);
                            $this->Flash->success(' Job has been unfollowed successfully.'); 
            
                    }else{

                        $this->redirect(['action' => 'viewJobDetails',$id]);
                        $this->Flash->error('There is some problem can not unfollow job now.');   

                    }
            }        

    }

     /*
     *  unfollowJob method for unfollowJob job
     *
     *
     *
     *
     ***/
    public function jobFollowerLists($id = null)
    {        
            $user = $this->Auth->user();
            if($user){

                    $this->loadModel('Jobs');
                    $this->loadModel('JobFollowers');
                    $this->loadModel('Keywords');
                    $Keywords = $this->Keywords->find('list')->toArray();
                    $this->set('Keywords',$Keywords);

                    $UserId = $this->request->Session()->read('Auth.User.id');  
                    $Id = base64_decode($id);

                    $JobFollowers = $this->Jobs->find('all',['conditions' => ['Jobs.id' => $Id]])->contain(['SubAdminDetails','Countries','States','JobIndustries','JobTypes','JobFollowers'=>['Users'=>['ContractorBasics','ContractorProfessionals']]])->first();

                    $this->set('JobFollowers',$JobFollowers);

                  if(empty($JobFollowers)){
                    $this->redirect(['action' => 'recuiter']);
                  }
            }
    }


    /*
     *  applyForJob method for unfollowJob job
     *
     *
     *
     *
     ***/
    public function applyForJob($id = null)
    {
            $user = $this->Auth->user();
            if($user){

                    $this->loadModel('Jobs');
                    $this->loadModel('JobFollowers');
                    $this->loadModel('JobApplies');
                    $loguserName = 'Guest';
                    $loguser = $this->request->Session()->read('Auth.User');
                    if(!empty($loguser)){
                        $loguserName = $loguser['first_name']." ".$loguser['last_name'];
                    }
                    $this->set('loguserName',$loguserName);

                    $UserId = $this->request->Session()->read('Auth.User.id');  
                    $Id = base64_decode($id);

                    $this->loadModel('JobExperiences');
                    $experienceList = $this->JobExperiences->find('all',['conditions'=>['user_id '=>$UserId]])->first();
                    $this->set('experienceList',$experienceList);

                    $exists = $this->Jobs->exists(['id' => $Id, 'user_id !='=>$UserId]);
                    $JobApplies = $this->JobApplies->newEntity(); 
                    if(!empty($exists)){

                        $jobDetails = $this->Jobs->get($Id,['contain'=>['Users','Countries','States']]);
                        $this->set('jobDetails',$jobDetails);

                        //check job applied or not
                        $this->loadModel('JobApplies');
                        $jobApply = $this->JobApplies->exists(['job_id' => $Id, 'user_id'=>$UserId]);
                        if(empty($jobApply)){
                            
                            if ($this->request->is(['post', 'put'])) {

                                //Upload Doc
                                $flag=0;
                                $uploadDocError='';
                                if(!empty($this->request->data['coverletter_doc']['name'])){
                                    $doc_name = $this->request->data['coverletter_doc'];
                                    $docName = $this->Multiupload->jobsUploadApply($doc_name);
                                    if(empty($docName['errors'])){
                                        $uploadDocName=$docName['fileName'];
                                    }else{
                                        $flag=1;
                                        $uploadDocError=$docName['errors'];
                                    }
                                }else{
                                    $uploadDocName='';
                                }


                                //resume Doc
                                $flag=0;
                                $uploadresumeError='';
                                if(!empty($this->request->data['resume']['name'])){
                                    $resume_name = $this->request->data['resume'];
                                    $resumeName = $this->Multiupload->jobsUploadApply($resume_name);
                                    if(empty($resumeName['errors'])){
                                        $uploadresumeName=$resumeName['fileName'];
                                    }else{
                                        $flag=1;
                                        $uploadresumeError=$resumeName['errors'];
                                    }
                                }else{
                                    $uploadresumeName='';
                                }

                                $this->request->data['job_id']=$Id;
                                $this->request->data['user_id']=$UserId;
                                $this->request->data['status']=1;
                                $this->request->data['coverletter_doc']=$uploadDocName;
                                $this->request->data['resume']=$uploadresumeName;

                                if(!empty($flag)){

                                    if(!empty($uploadDocError)){
                                      $this->Flash->error($uploadDocError);  
                                    }
                                    if(!empty($uploadresumeError)){
                                      $this->Flash->error($uploadresumeError); 
                                    } 

                                }else{

                                    $JobApplies = $this->JobApplies->patchEntity($JobApplies, $this->request->data);

                                    $resultSave = $this->JobApplies->save($JobApplies);
                                    if ($resultSave){

                                        $this->redirect(['action' =>'viewJobDetails',$id]);
                                        $this->Flash->success('Job applied successfully.'); 

                                    }else{
                                        $this->Flash->error('Could not apply for job. Please try again'); 
                                    }
                                } 
                            } 

                        }else{
                                $this->redirect(['action' =>'viewJobDetails',$id]);
                                $this->Flash->error('You have already applied for this job.');
                        }
                        $this->set('JobApplies',$JobApplies);

                    }else{

                        $this->redirect(['action' => 'jobs']); 

                    }

            }

    }

    /*
     *  addExperiences method for unfollowJob job
     *
     *
     *
     *
     ***/
    public function addExperiences()
    {
            $user = $this->Auth->user();
            if($user){

                    $this->loadModel('JobExperiences');

                    $this->loadModel('JobAchievements');
                    $JobAchievements = $this->JobAchievements->find('list')->toArray();
                    $this->set('JobAchievements',$JobAchievements);

                    $this->loadModel('JobRoles');
                    $JobRoles = $this->JobRoles->find('list')->toArray();
                    $this->set('JobRoles',$JobRoles);

                    $this->loadModel('JobDuties');
                    $JobDuties = $this->JobDuties->find('list')->toArray();
                    $this->set('JobDuties',$JobDuties);

                    $UserId = $this->request->Session()->read('Auth.User.id');

                    $exists = $this->JobExperiences->exists(['user_id'=>$UserId]); 

                    $getExpDetails= $this->JobExperiences->find('all',['conditions'=>['user_id'=>$UserId]])->first();
                    
                    if($exists){
                        $this->redirect(['action' => 'editExperiences',base64_encode($getExpDetails->id)]); 
                    } 

                    $JobExperiences = $this->JobExperiences->newEntity(); 

                    if ($this->request->is(['post', 'put'])) {

                        $arraylength = count($this->request->data['company_name']); 
                        $preQdata = [];
                        for($ci=1; $ci<=$arraylength; $ci++){

                                $job_role_id[$ci] ='';
                                if(!empty($this->request->data['job_role_id'][$ci])){
                                    $job_role_id[$ci] = implode(',', $this->request->data['job_role_id'][$ci]);
                                }

                                /*$job_achievement_id[$ci] ='';
                                if(!empty($this->request->data['job_achievement_id'][$ci])){
                                    $job_achievement_id[$ci] = implode(',', $this->request->data['job_achievement_id'][$ci]);
                                }*/

                                /*$job_duty_id[$ci] ='';
                                if(!empty($this->request->data['job_duty_id'][$ci])){
                                    $job_duty_id[$ci] = implode(',', $this->request->data['job_duty_id'][$ci]);
                                }*/
                                //$preQdata[$ci]
                                $preQdata[]= array('company_name' => $this->request->data['company_name'][$ci],
                                                      'job_title' => $this->request->data['job_title'][$ci],
                                                      'start_date' => $this->request->data['start_date'][$ci],
                                                      'end_date' => $this->request->data['end_date'][$ci],
                                                      'company_url' => $this->request->data['company_url'][$ci],
                                                      'job_role_id' => $job_role_id[$ci],
                                                      'job_duty_id' => $this->request->data['job_duty_id'][$ci],
                                                      'job_achievement_id' => $this->request->data['job_achievement_id'][$ci]
                                                    );

                        }
                        $experience_details =json_encode($preQdata);

                        $this->request->data['user_id']=$UserId;
                        $this->request->data['experience_details']=$experience_details;
                        $this->request->data['status']=1;
                        //pr($this->request->data); die;

                        $JobExperiences = $this->JobExperiences->patchEntity($JobExperiences, $this->request->data);
                        $result = $this->JobExperiences->save($JobExperiences);

                        if($result)
                        {   
                            $this->redirect(['action' => 'editExperiences',base64_encode($result->id)]); 
                            $this->Flash->success('Experience added successfully.'); 

                        }else{
                            $this->Flash->error('Could not add Experience. Please try again.'); 
                        }


                    }

                    $this->set('JobExperiences',$JobExperiences);

            }

    }

    /*
     *  editExperiences method for unfollowJob job
     *
     *
     *
     *
     ***/
    public function editExperiences($id=null)
    {
            $user = $this->Auth->user();
            if($user){
                    $this->loadModel('JobExperiences');
                    $UserId = $this->request->Session()->read('Auth.User.id');
                    $Id = base64_decode($id);

                    $getExpDetails= $this->JobExperiences->find('all',['conditions'=>['id'=>$Id, 'user_id'=>$UserId]])->first();
                    if(!empty($getExpDetails)){

                        $this->set('getExpDetails',$getExpDetails);

                        $this->loadModel('JobAchievements');
                        $JobAchievements = $this->JobAchievements->find('list')->toArray();
                        $this->set('JobAchievements',$JobAchievements);

                        $this->loadModel('JobRoles');
                        $JobRoles = $this->JobRoles->find('list')->toArray();
                        $this->set('JobRoles',$JobRoles);

                        $this->loadModel('JobDuties');
                        $JobDuties = $this->JobDuties->find('list')->toArray();
                        $this->set('JobDuties',$JobDuties);

                        $JobExperiences = $this->JobExperiences->newEntity();

                        if ($this->request->is(['post', 'put'])) {

                            $arraylength = count($this->request->data['company_name']); 
                            $preQdata = [];
                            for($ci=1; $ci<=$arraylength; $ci++){

                                    $job_role_id[$ci] ='';
                                    if(!empty($this->request->data['job_role_id'][$ci])){
                                        $job_role_id[$ci] = implode(',', $this->request->data['job_role_id'][$ci]);
                                    }

                                    /*$job_achievement_id[$ci] ='';
                                    if(!empty($this->request->data['job_achievement_id'][$ci])){
                                        $job_achievement_id[$ci] = implode(',', $this->request->data['job_achievement_id'][$ci]);
                                    }*/

                                    /*$job_duty_id[$ci] ='';
                                    if(!empty($this->request->data['job_duty_id'][$ci])){
                                        $job_duty_id[$ci] = implode(',', $this->request->data['job_duty_id'][$ci]);
                                    }*/
                                    //$preQdata[$ci]
                                    $preQdata[]= array('company_name' => $this->request->data['company_name'][$ci],
                                                          'job_title' => $this->request->data['job_title'][$ci],
                                                          'start_date' => $this->request->data['start_date'][$ci],
                                                          'end_date' => $this->request->data['end_date'][$ci],
                                                          'company_url' => $this->request->data['company_url'][$ci],
                                                          'job_role_id' => $job_role_id[$ci],
                                                          'job_duty_id' => $this->request->data['job_duty_id'][$ci],
                                                          'job_achievement_id' => $this->request->data['job_achievement_id'][$ci]
                                                        );

                            }
                            $experience_details =json_encode($preQdata);

                            $this->request->data['user_id']=$UserId;
                            $this->request->data['experience_details']=$experience_details;
                            $this->request->data['status']=1;
                            //pr($this->request->data); die;

                            $JobExperiences = $this->JobExperiences->patchEntity($JobExperiences, $this->request->data);
                            $JobExperiences->id= $getExpDetails->id;
                            $result = $this->JobExperiences->save($JobExperiences);
                            if($result)
                            {
                                $this->Flash->success('Experience updated successfully.');
                                $this->redirect($this->referer()); 

                            }else{
                                $this->Flash->error('Could not update. Please try again.'); 
                            }


                        }


                        $this->set('JobExperiences',$JobExperiences);

                    }else{

                        $this->redirect(['action' => 'addExperiences']);

                    }

            }    
    }


    /***
    *
    *
    *
    *
    *****/
    public function getExperienceList()
    {
            $id  = $this->request->data['id'];
            $this->set('id',$id);
            $this->loadModel('JobExperiences');

            $this->loadModel('JobAchievements');
            $JobAchievements = $this->JobAchievements->find('list')->toArray();
            $this->set('JobAchievements',$JobAchievements);

            $this->loadModel('JobRoles');
            $JobRoles = $this->JobRoles->find('list')->toArray();
            $this->set('JobRoles',$JobRoles);

            $this->loadModel('JobDuties');
            $JobDuties = $this->JobDuties->find('list')->toArray();
            $this->set('JobDuties',$JobDuties);

            if ($this->request->is(['post', 'put'])) {

                echo $this->render('/Element/Front/jobexperiences');               
            }
    }

    /**
     * getOptionsList method
     *
     * 
     */
    public function getOptionsList(){

        $this->loadModel('States');
        if(!empty($this->request->data)){
            $countryId  = $this->request->data['countryId'];
            $state = $this->States->find('all',['conditions'=>['States.country_id'=>$countryId]])->select(['id','name'])->toArray();
            //pr( $state );die;
            $this->set('states',$state);
            echo $this->render('/Element/Front/ajaxstates');
            //$result = "<option value=".$question_id.">".$questionname."</option>";
            //echo $result; 
            die;
        }

    }


}
?>