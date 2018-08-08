<?php
namespace App\Controller;

use App\Controller\AppController;
use Cake\ORM\TableRegistry;
use Cake\Filesystem\Folder;
use Cake\Filesystem\File;
use Cake\Database\Expression\QueryExpression;
use Cake\Mailer\Email;
use Cake\Routing\Router;
use Cake\I18n\Time;
use Cake\Datasource\ConnectionManager;
// Sample Mail configuration
/*Email::configTransport('default', [
    'className' => 'Mail'
]);*/

// Sample smtp configuration.
/*Email::configTransport('gmail', [
    'host' => 'ssl://smtp.gmail.com',
    'port' => 465,
    'username' => 'vijay.trantorinc@gmail.com',
    'password' => 'fadsfdssd',
    'className' => 'Smtp'
]);*/
/**
* Startups Controller
*
*@property\App\Model\Table\Users table $users
*/ 
class StartupsController extends AppController{

 /*This Function Will display all Startupdetail from Strartups table*/
    public $helpers = ['Custom'];

    public function initialize()
    {
        parent::initialize();
        $this->loadComponent('Upload');
        $this->loadComponent('Multiupload');
        $this->loadComponent('UserImageWeb');
        $this->loadComponent('Contractor');
        $this->loadComponent('WebNotification');
        $this->loadComponent('Feeds');
    }
    public function index()
    {
            $this->redirect(['controller' => 'Contractors', 'action' => 'dashboard']);
    }


    /**
     * ListStartup method
     *
     *
     *
     ***/
    public function roadmapVideo()
    {

    }

    /**
     * startupApplication method
     *
     *
     *
     ***/
    public function startupApplication()
    {

    }

    /**
     * startupProfile method
     *
     *
     *
     ***/
    public function startupProfile()
    {

    }

    /**
     * funds method
     *
     *
     *
     ***/
    public function funds()
    {

    }

    /**
     * searchCampaigns method
     *
     *
     *
     ***/
    public function searchCampaigns()
    {
            $ContractorProffesionalsTable = $this->loadModel('ContractorProfessionals');
            $user = $this->Auth->user();  
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->loadModel('Campaigns');

            $this->paginate = [ 'limit' => 10, 'order' => ['Campaigns.id' => 'desc'],];

                        //$startup_detail='';
                        $searchKeyword=$this->request->query('search');
                        //$searchKeyword = str_replace("'","",$searchKeyword);
                        if (strpos($searchKeyword, "'") !== false) {
                            $searchKeywordArray=explode("'", $searchKeyword);
                            $searchKeyword=$searchKeywordArray[0];
                        }
                        //user should not be entrepreneur of a start up
                        if(!empty($searchKeyword)){  
                            $connection = ConnectionManager::get('default');
                                 
                                $qq = "SELECT SU.id FROM keywords as KY INNER JOIN campaigns as SU ON FIND_IN_SET(KY.id, SU.keywords) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id 
                                            UNION
                                            SELECT SU.id FROM campaigns as SU where SU.campaigns_name like '%".$searchKeyword."%'
                                            UNION
                                            SELECT SU.id FROM startups as EB INNER JOIN campaigns as SU ON SU.startup_id=EB.id where EB.name like  '%".$searchKeyword."%'";
                                
                                $sql = $connection->execute ($qq);
                                $startup_ids = $sql->fetchAll('assoc');

                                if(!empty($startup_ids)){

                                        foreach($startup_ids as $SingleUser):
                                                if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                                    $startupIDs[] = $SingleUser['id'];
                                                }
                                        endforeach;
                                //pr($startupIDs);
                                        if(!empty($startupIDs)){
                                                
                                                //$startup_detail = $this->Campaigns->find('all')->where(['Campaigns.id IN'=>$startupIDs,'Campaigns.user_id !='=>$UserId ])->contain(['Users'=>['EntrepreneurBasics']]);

                                                $startup_detail = $this->Campaigns->find('all')->where(['Campaigns.id IN'=>$startupIDs])->contain(['Users'=>['EntrepreneurBasics']]);        
                                        }
                                //pr($startup_detail->toArray());die;
                                }else {
                                      
                                       $startup_detail='';
                                } 
                                
                                $this->paginate($startup_detail);


                        }else {         
                            
                            $conditions = [];
                            //array_push($conditions,["Campaigns.user_id !="=>$UserId]);
                            $contractorKeywords = $this->ContractorProfessionals->find('all')
                                                    ->where(['user_id'=>$UserId])
                                                    ->select(['keywords'])
                                                    ->first();

                            if(!empty($contractorKeywords)&&($contractorKeywords->keywords!='')){
                                $conditions['OR'] = [];
                                $contractorKeywords = $contractorKeywords->toArray();
                                
                                foreach(explode(',',$contractorKeywords['keywords']) as $single_keyword):
                                     
                                     array_push($conditions['OR'],["FIND_IN_SET($single_keyword,Campaigns.keywords)"]);
                                     
                                endforeach;
                            //pr($conditions);die;
                                $startup_detail = $this->Campaigns->find('all')
                                                        ->where($conditions)->contain(['Users'=>['EntrepreneurBasics']]);
                                                        //pr($query); die;
                            } else {
                                $startup_detail='';
                            }  

                            $this->paginate($startup_detail);   

                        } 

                        $this->set('startup_detail', $startup_detail);
                        //$this->set('_serialize', ['startup_detail']);
    }

    /**
     * funds method
     *
     *
     *
     ***/
    public function assignWorkUnits($id = null)
    {
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);

            $this->loadModel('Users');
            $this->loadModel('ContractorBasics');
            $this->loadModel('EntrepreneurProfessionals');
            $this->loadModel('ContractorProfessionals');
            $this->loadModel('Keywords');
            $this->loadModel('Roadmaps');
            $user = $this->Auth->user();
            $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            if($user){


                $users=[]; 
                $UserId = $this->request->Session()->read('Auth.User.id');

                $searchKeyword=trim($this->request->query('search'));
                //$searchKeyword = str_replace("'","",$searchKeyword);  
                if (strpos($searchKeyword, "'") !== false) {
                    $searchKeywordArray=explode("'", $searchKeyword);
                    $searchKeyword=$searchKeywordArray[0];
                }
                if(!empty($searchKeyword)){
                    $ss = explode(' ', $searchKeyword);
                    if(!empty($ss)){
                      $searchKeyword =$ss[0];
                    }
                    
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
                            $conditions = ['Users.id IN'=>$contractorIds,
                            'Users.id !='=>$UserId];

                            $users= $this->Users->find('all',['conditions'=>$conditions])->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);

                            $this->paginate($users); 

                        }                                                        

                    }else{


                        $Startup = $this->EntrepreneurProfessionals->find('all',['conditions'=>['EntrepreneurProfessionals.user_id'=>$UserId]])
                        ->select(['keywords'])
                        ->first();
                                                    //->toArray();

                        if(!empty($Startup)&&($Startup['keywords']!='')){
                            $conditions = [];
                            array_push($conditions,["ContractorProfessionals.user_id !="=>$UserId]);
                            $conditions['OR'] = [];
                                /// If search keyword is not empty

                            $keywordsList=explode(',',$Startup['keywords']);                
                            foreach($keywordsList as $single_keyword):

                               array_push($conditions['OR'],["FIND_IN_SET($single_keyword,ContractorProfessionals.keywords)"]);

                           endforeach;

                           $contractors = $this->ContractorProfessionals->find('all')
                           ->where($conditions)
                           ->select(['user_id']);

                                //$this->set('contractors', $this->paginate($contractors)); 

                           if($contractors->toArray()){

                            $contractors = $contractors->toArray();

                            foreach($contractors as $singleContractor):
                                if($singleContractor->user_id!=''):
                                    $contractorIds[] = $singleContractor->user_id;
                                endif;
                            endforeach;

                                if(!empty($contractorIds)){

                                  //Get result sort by name
                                  //$users = $this->Users->find('all',['conditions'=>['Users.id IN'=>$contractorIds]])->contain(['ContractorBasics','ContractorProfessionals','Countries']);
                                                        //->toArray();

                                  $users = $this->Users->find('all',['conditions'=>['Users.id IN'=>$contractorIds
                                       ]])->contain(['ContractorBasics','ContractorProfessionals','Countries'])->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);

                                   $this->paginate($users);               
                               }

                           }

                       }

                   }

                   $this->set('users', $users);                     

           }
    }

    /**
     * funds method
     *
     *
     *
     ***/
    public function addWorkUnits($id = null)
    {
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);

            $this->loadModel('Users');
            $this->loadModel('ContractorBasics');
            $this->loadModel('EntrepreneurProfessionals');
            $this->loadModel('ContractorProfessionals');
            $this->loadModel('Keywords');
            $this->loadModel('Roadmaps');
            $user = $this->Auth->user();
            $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            if($user){


                $users=[]; 
                $UserId = $this->request->Session()->read('Auth.User.id');

                $searchKeyword=trim($this->request->query('search'));
                //$searchKeyword = str_replace("'","",$searchKeyword);  
                if (strpos($searchKeyword, "'") !== false) {
                    $searchKeywordArray=explode("'", $searchKeyword);
                    $searchKeyword=$searchKeywordArray[0];
                }
                if(!empty($searchKeyword)){
                    $ss = explode(' ', $searchKeyword);
                    if(!empty($ss)){
                      $searchKeyword =$ss[0];
                    }
                    
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
                            $conditions = ['Users.id IN'=>$contractorIds,
                            'Users.id !='=>$UserId];

                            $users= $this->Users->find('all',['conditions'=>$conditions])->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);

                            $this->paginate($users); 

                        }                                                        

                    }else{


                        $Startup = $this->EntrepreneurProfessionals->find('all',['conditions'=>['EntrepreneurProfessionals.user_id'=>$UserId]])
                        ->select(['keywords'])
                        ->first();
                                                    //->toArray();

                        if(!empty($Startup)&&($Startup['keywords']!='')){
                            $conditions = [];
                            array_push($conditions,["ContractorProfessionals.user_id !="=>$UserId]);
                            $conditions['OR'] = [];
                                /// If search keyword is not empty

                            $keywordsList=explode(',',$Startup['keywords']);                
                            foreach($keywordsList as $single_keyword):

                               array_push($conditions['OR'],["FIND_IN_SET($single_keyword,ContractorProfessionals.keywords)"]);

                           endforeach;

                           $contractors = $this->ContractorProfessionals->find('all')
                           ->where($conditions)
                           ->select(['user_id']);

                                //$this->set('contractors', $this->paginate($contractors)); 

                           if($contractors->toArray()){

                            $contractors = $contractors->toArray();

                            foreach($contractors as $singleContractor):
                                if($singleContractor->user_id!=''):
                                    $contractorIds[] = $singleContractor->user_id;
                                endif;
                            endforeach;

                                if(!empty($contractorIds)){

                                  //Get result sort by name
                                  //$users = $this->Users->find('all',['conditions'=>['Users.id IN'=>$contractorIds]])->contain(['ContractorBasics','ContractorProfessionals','Countries']);
                                                        //->toArray();

                                  $users = $this->Users->find('all',['conditions'=>['Users.id IN'=>$contractorIds
                                       ]])->contain(['ContractorBasics','ContractorProfessionals','Countries'])->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);

                                   $this->paginate($users);               
                               }

                           }

                       }

                   }

                   $this->set('users', $users);                     

           }
    }



    /**
     * ListStartup method
     *
     *
     *
     ***/
    public function ListStartup(){
            $this->loadModel('StartupTeams');
            $this->loadModel('Users');
            $this->loadModel('ContractorBasics');
            $this->loadModel('StartupListProfiles');
            $user = $this->Auth->user();    
            
            if($user){
                
               $UserId = $this->request->Session()->read('Auth.User.id');

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

                    
                    //pr($startupTeamData->startup_id);die;
                    
                    if(!empty($startupTeamData)){
                            //$startupdata = $this->Startups->StartupTeams->find('all',['conditions'=>['StartupTeams.user_id'=>$UserId]])->contain(['Startups'])->toArray();
                            $values = $startupTeamData->startup_id;
                            if(!empty($values)){
                             $selectedIds= explode(',', $values);
                            }
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

    /**
     * ListStartup method
     *
     *
     *
     ***/
    public function viewListStartup($id=null,$starupId=null)
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
             $this->set('startupId', $starupId);

              /// Check if conection request sent to view user or not
              $this->loadModel('userConnections');
              if($LoggedUserId != $viewUserId){

                $connectionListRecvd = $this->userConnections->find('all',['conditions'=>['userConnections.connection_by'=>$viewUserId],'userConnections.connection_to'=>$LoggedUserId])->first();
                $requestRcvd='';
                $rqstStatus='';
                if(!empty($connectionListRecvd)){
                    $requestRcvd=$connectionListRecvd->id;
                    $rqstStatus=$connectionListRecvd->status;
                }
                $this->set('requestRcvd', $requestRcvd);


                $requestSent='';
                $connectionListSent = $this->userConnections->find('all',['conditions'=>['userConnections.connection_by'=>$LoggedUserId],'userConnections.connection_to'=>$viewUserId])->first();
                if(!empty($connectionListSent)){
                  $requestSent=$connectionListSent->id;
                  $rqstStatus=$connectionListSent->status;
                }
                $this->set('requestSent', $requestSent);
                $this->set('rqstStatus', $rqstStatus);

              }else{

                    $this->set('requestRcvd', '');
                    $this->set('requestSent', '');
                    $this->set('rqstStatus', '');
              }

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
                     /*}else {
                        
                            $this->set('RatingStarupId', '');
                         
                     }*/
            }else {
                $this->set('RatingStarupId', '');
            }

            /* $validHiredUser = $this->StartupTeams->exists(['startup_id' => $RatingStarupId, 'user_id'=>$viewUserId]);
             if($validHiredUser == 1){
                $this->set('RatingStarupId', $starupId);
             }else {
                $this->set('RatingStarupId', '');
             }  */ 
            
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

                    
                    //pr($startupTeamData->startup_id);die;
                    
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
              $this->loadModel('WorkorderRatings');
          $user = $this->Auth->user();
          if($user){
                        //$UserId = $this->request->Session()->read('Auth.User.id');
            $UserId= $UserId;

            $countData = $this->WorkorderRatings->find('all',['conditions'=>['WorkorderRatings.given_to'=> $UserId,'WorkorderRatings.is_entrepreneur'=>1]])->toArray();

            $count= count($countData);
            $ratingData = $this->WorkorderRatings->find('all',['conditions'=>['WorkorderRatings.given_to'=> $UserId]]);

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
                $dim_star = 9-$int;
            }else{
                $star_view .= "";
                $dim_star = 10-$int;
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


     /**
     * addStartupList method for profile 
     *
     *
     *
     */
     public function addStartupList()
     {
            $this->loadModel('StartupTeams');
            $this->loadModel('Users');
            $this->loadModel('StartupListProfiles');
            $user = $this->Auth->user();  

            if($user){
                
               $UserId = $this->request->Session()->read('Auth.User.id');
               $user = $this->StartupListProfiles->newEntity();

               /*To check detail of LoggedIn User in Statrtup team Table */
                    $startupTeamData = $this->Startups->StartupTeams->find('all', [
                        'conditions' => ['StartupTeams.user_id' => $UserId]]);
                    $startupTeamData = $startupTeamData->first();

                    if(!empty($startupTeamData)){
                            $startupdata = $this->Startups->StartupTeams->find('all',['conditions'=>['StartupTeams.user_id'=>$UserId]])
                                                        ->contain(['Startups'])
                                                        ->toArray(); 
                    }else {
                        $startupdata='';
                    }
                    $this->set('startupdata',$startupdata);

                    //Check data in StartupListProfiles Table
                    $startupListdata = $this->StartupListProfiles->find('all', [
                        'conditions' => ['StartupListProfiles.user_id' => $UserId]]);
                    $startupListdata = $startupListdata->first();

                    
                    if(!empty($startupListdata)){
                       $StartupListProfilesId =$startupListdata->id;
                       $startup_profileData =  $this->StartupListProfiles->get($StartupListProfilesId);
                       $this->set('startup_profileData',$startup_profileData); 

                    }else {$this->set('startup_profileData',''); }



                    if($this->request->is('Post')){

                        $startup_id='';
                        if(!empty($this->request->data['startup_id'])){
                          $startup_id = implode(',', $this->request->data['startup_id']);
                        }

                        $user = $this->StartupListProfiles->patchEntity($user,$this->request->data); 
                        $user->user_id = $UserId;
                        $user->startup_id = $startup_id;

                        // Update id
                        if(!empty($startupListdata)){
                             $user->id = $StartupListProfilesId;
                        }
                       // pr($user);die;
                            if($this->StartupListProfiles->save($user)){
                                 $this->Flash->success('The Startup has been saved.');
                                 return $this->redirect($this->referer());
                            }else {
                                //pr($user->error);die;
                                 $this->Flash->error('The Startups could not be saved. Please, try again.');
                            }    
     
                    }

                    $this->set('user',$user);

            }       
     
     }


     /**
     * AddStartup method
     *
     *
     *
     ***/
     public function AddStartup()
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
                            $this->Feeds->saveStartupFeeds($UserId,'feeds_startup_added',$result->id);

                                $this->Flash->success('The Startup has been saved.');
                                //return $this->redirect($this->referer());
                                //$startup_id = $result->id;
                                return $this->redirect(['action' => 'myStartup']);
                        }
                    }    

                }

                $this->set('startup',$startup);
     }

     /**
     * Delete method startup
     *
     *
     ***/

    public function deleteStartup($id = null)
    {
            $startupId = base64_decode($id);
            $UserId = $this->request->Session()->read('Auth.User.id');

            $this->request->allowMethod(['post', 'delete']);

            $startupTable = $this->Startups->get($startupId);

            if ($this->Startups->delete($startupTable)) {
                $this->Flash->success('Startup has been deleted successfully.');
            } else {
                $this->Flash->error('Startup could not be deleted. Please, try again.');
            }
            return $this->redirect($this->referer());
    }


     
     /**
     * CurrentStartup method to get those startup on which user currently working
     *
     *
     ***/
    public function CurrentStartup($view=null)
    {
            $this->paginate = [ 'limit' => 10,
                'contain' => ['Users']
            ];
           $view= base64_decode($view);
            if($view =='workView'){
                $this->set('workView', $view);
            }else{
                $this->set('workView', '');
            }

            $UserId = $this->request->Session()->read('Auth.User.id');
            $startupteamtable = TableRegistry::get('StartupTeams');
            $startup_detail = $startupteamtable->find('all',['conditions'=>['StartupTeams.user_id'=> $UserId, 'StartupTeams.approved'=>'1']])->contain(['Startups'=>['Users','EntrepreneurBasics']]);
          
            //$this->set(compact('startup_detail'));
            $this->set('startup_detail', $this->paginate($startup_detail));
            $this->set('_serialize', ['startup_detail']);
    }


    /**
     * CompletedStartup method to get those startup are completed by user
     *
     *
     ***/
    public function CompletedStartup()
    {
            $this->paginate = [ 'limit' => 10,
                'contain' => ['Users']
            ];
            $UserId = $this->request->Session()->read('Auth.User.id');
            $startupteamtable = TableRegistry::get('StartupTeams');
            $startup_detail = $startupteamtable->find('all',['conditions'=>['StartupTeams.user_id'=> $UserId,'OR'=>[
                ['StartupTeams.approved'=>'2'],
                ['StartupTeams.approved'=>'3']
                ]]])->contain(['Startups'=>['Users','EntrepreneurBasics']]);
          
            //$this->set(compact('startup_detail'));
            $this->set('startup_detail', $this->paginate($startup_detail));
            $this->set('_serialize', ['startup_detail']);
    }


    /**
     * SearchStartup method to get those startup which are related to user keywords
     *
     *
     ***/
    public function SearchStartup()
    {       
            $ContractorProffesionalsTable = $this->loadModel('ContractorProfessionals');
            $user = $this->Auth->user();  
            $UserId = $this->request->Session()->read('Auth.User.id');

            $this->paginate = [ 'limit' => 10,
                                'order' => [
                                    'Startups.id' => 'asc'
                                ],
                                'contain' => ['Users']
                              ];
            $searchKeyword=$this->request->query('search');


            if($searchKeyword ==''):

                            $conditions = [];
                            
                            //$searchKeyword = str_replace("'","",$searchKeyword);
                            /*if (strpos($searchKeyword, "'") !== false) {
                                $searchKeywordArray=explode("'", $searchKeyword);
                                $searchKeyword=$searchKeywordArray[0];
                            }
                            //user should not be entrepreneur of a start up
                            if(isset($searchKeyword)){  
                                array_push($conditions,["Startups.user_id !="=>$UserId,"Startups.name LIKE"=> '%'.$searchKeyword.'%' ]); 
                            }else {
                                array_push($conditions,["Startups.user_id !="=>$UserId]);   
                            }*/
                            
                            array_push($conditions,["Startups.user_id !="=>$UserId]);  

                            $contractorKeywords = $this->ContractorProfessionals->find('all')
                                                    ->where(['user_id'=>$UserId])
                                                    ->select(['keywords'])
                                                    ->first();

                            if(!empty($contractorKeywords)&&($contractorKeywords->keywords!='')){
                                $conditions['OR'] = [];
                                $contractorKeywords = $contractorKeywords->toArray();
                                
                                foreach(explode(',',$contractorKeywords['keywords']) as $single_keyword):
                                     
                                     array_push($conditions['OR'],["FIND_IN_SET($single_keyword,Startups.keywords)"]);
                                     
                                endforeach;

                                $startup_detail = $this->Startups->find('all')
                                                        ->where($conditions)
                                                        ->contain(['Users'=>['EntrepreneurBasics']]);
                                                        //pr($query); die;
                            } else {
                                $startup_detail='';
                            } 

                             $this->set('startup_detail', $this->paginate($startup_detail));
                             $this->set('_serialize', ['startup_detail']);    

          else:
                        $searchKeyword=$this->request->query('search');
                        //$searchKeyword = str_replace("'","",$searchKeyword);
                        if (strpos($searchKeyword, "'") !== false) {
                            $searchKeywordArray=explode("'", $searchKeyword);
                            $searchKeyword=$searchKeywordArray[0];
                         }

                          $connection = ConnectionManager::get('default');
                 
                          $qq = "SELECT SU.id FROM keywords as KY INNER JOIN startups as SU ON FIND_IN_SET(KY.id, SU.keywords) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id 
                                UNION
                                SELECT SU.id FROM startups as SU where SU.name like '%".$searchKeyword."%'
                                UNION
                                SELECT SU.id FROM entrepreneur_basics as EB INNER JOIN startups as SU ON SU.user_id=EB.user_id where EB.first_name like  '%".$searchKeyword."%' OR EB.last_name like  '%".$searchKeyword."%'";
                          
                          $sql = $connection->execute ($qq);
                          $startup_ids = $sql->fetchAll('assoc');
                          
                          if(!empty($startup_ids)){
                            
                            foreach($startup_ids as $SingleUser):
                              if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                $startupIDs[] = $SingleUser['id'];
                              }
                            endforeach;
                          
                          //fetching the startups and listing the result
                          

                            if(!empty($startupIDs)):
                              
                                $query = $this->Startups->find('all')
                                          ->where(['Startups.id IN'=>$startupIDs]);
                                                  
                                $startup_detail = $this->Startups->find('all')
                                                        ->where(['Startups.id IN'=>$startupIDs])
                                                        ->contain(['Users'=>['EntrepreneurBasics']]);
                            else:                            
                                  $startup_detail = '';
                            endif;

                            $this->set('startup_detail', $this->paginate($startup_detail));
                            
                          }else{  
                              //print_r($startup_detail);   die;                             
                              $startup_detail = '';
                          } 
                          
                          
                          //$this->set('_serialize', ['startup_detail']); 


          endif;  
    } 

    /**
     * SearchStartup method to get those startup which are related to user keywords
     *
     *
     ***/
    public function SearchStartups()
    {       
            $ContractorProffesionalsTable = $this->loadModel('ContractorProfessionals');
            $user = $this->Auth->user();  
            $UserId = $this->request->Session()->read('Auth.User.id');

            $this->paginate = [ 'limit' => 10];

                        //$startup_detail='';
                         $searchKeyword=$this->request->query('search');
                         //$searchKeyword = str_replace("'","",$searchKeyword);
                         if (strpos($searchKeyword, "'") !== false) {
                            $searchKeywordArray=explode("'", $searchKeyword);
                            $searchKeyword=$searchKeywordArray[0];
                         }
                        //user should not be entrepreneur of a start up
                        if(!empty($searchKeyword)){  
                            $connection = ConnectionManager::get('default');
                                 
                                $qq = "SELECT SU.id FROM keywords as KY INNER JOIN startups as SU ON FIND_IN_SET(KY.id, SU.keywords) where KY.name like  '%".$searchKeyword."%' GROUP BY SU.id 
                                            UNION
                                            SELECT SU.id FROM startups as SU where SU.name like '%".$searchKeyword."%'
                                            UNION
                                            SELECT SU.id FROM entrepreneur_basics as EB INNER JOIN startups as SU ON SU.user_id=EB.user_id where EB.first_name like  '%".$searchKeyword."%' OR EB.last_name like  '%".$searchKeyword."%'";
                                
                                $sql = $connection->execute ($qq);
                                $startup_ids = $sql->fetchAll('assoc');

                                if(!empty($startup_ids)){

                                        foreach($startup_ids as $SingleUser):
                                                if(isset($SingleUser['id'])&&($SingleUser['id']!='')){
                                                    $startupIDs[] = $SingleUser['id'];
                                                }
                                        endforeach;

                                        if(!empty($startupIDs)){
                                                
                                                $startup_detail = $this->Startups->find('all')->where(['Startups.id IN'=>$startupIDs,'Startups.user_id !='=>$UserId ])->contain(['Users'=>['EntrepreneurBasics']]);        
                                        }

                                }else {
                                      
                                       $startup_detail='';
                                } 
                                
                                $this->paginate($startup_detail);


                        }else {         
                            
                            $conditions = [];
                            array_push($conditions,["Startups.user_id !="=>$UserId]);
                            $contractorKeywords = $this->ContractorProfessionals->find('all')
                                                    ->where(['user_id'=>$UserId])
                                                    ->select(['keywords'])
                                                    ->first();

                            if(!empty($contractorKeywords)&&($contractorKeywords->keywords!='')){
                                $conditions['OR'] = [];
                                $contractorKeywords = $contractorKeywords->toArray();
                                
                                foreach(explode(',',$contractorKeywords['keywords']) as $single_keyword):
                                     
                                     array_push($conditions['OR'],["FIND_IN_SET($single_keyword,Startups.keywords)"]);
                                     
                                endforeach;
//pr($conditions);die;
                                $startup_detail = $this->Startups->find('all')
                                                        ->where($conditions)->contain(['Users'=>['EntrepreneurBasics']]);
                                                        //pr($query); die;
                            } else {
                                $startup_detail='';
                            }  

                            $this->paginate($startup_detail);   

                        } 

                        $this->set('startup_detail', $startup_detail);
                        //$this->set('_serialize', ['startup_detail']);                 

    }  




    /**
     * MyStartup method to get those startup which are added by user
     *
     * 
     ***/
    public function MyStartup($view=null)
    {       
            $viewApp = base64_decode($view);
            $this->set('viewApp', $viewApp);

            $this->paginate = [ 'limit' => 10,
                'contain' => ['Users']
            ];
            $UserId = $this->request->Session()->read('Auth.User.id');
            //$startupteamtable = TableRegistry::get('StartupTeams');

            //$startup_detail = $this->Startups->find('all',['conditions'=>['Startups.user_id'=> $UserId]]);

            $startup_detail = $this->Startups->find('all', ['conditions' => ['Startups.user_id' => $UserId] , 'order'=>['Startups.id DESC']])->contain(['Users'=>['EntrepreneurBasics']]);
            //$this->set(compact('startup_detail'));
            $this->set('startup_detail', $this->paginate($startup_detail));
            $this->set('_serialize', ['startup_detail']);
    }


    /**
     * EditStartupOverview method
     *
     *
     */
     public function editStartupOverview($id=null)
     {      
            $startupId = base64_decode($id);
            $this->set('startupId', $id);
/*$ss = $this->Feeds->startupTeamList($startupId); 
pr($ss);
die();*/
            $this->loadModel('Roadmaps');
            $user = $this->Auth->user();
            if($user){

                    $this->loadModel('Funds');
                    $isFunded= $this->Funds->find('all',['conditions'=>["FIND_IN_SET($startupId,Funds.portfolios_id)"]])->contain(['Users'])->first();
                    
                    if(!empty($isFunded)){
                      $this->set('funded_by', $isFunded->title);
                      $nnn=$isFunded->user->first_name.' '.$isFunded->user->last_name;
                      $this->set('fund_creator', $nnn);
                    }else{
                      $this->set('funded_by', '');
                      $this->set('fund_creator', '');
                    }


                     $startup = $this->Startups->newEntity();
                     $UserId = $this->request->Session()->read('Auth.User.id');

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

                     /*pr($roadmaps);
                        pr($LinkRoadmapIds);
                     pr($roadmapss); die;  */                     

                     // Get Startup Details by id
                     $startup = $this->Startups->get($startupId,['conditions'=>['Startups.id'=>$startupId,'Startups.user_id'=>$UserId]]);
                    // pr($startup); die;
                     $stpName= $startup->name;
                     $nextstep= $startup->next_step;
                     $savedRoadMapImg=$startup->roadmap_graphic;

                     if ($this->request->is(['post', 'put'])) {

                        $keyword ='';
                        if(!empty($this->request->data['keywords'])){
                          $keyword = implode(',', $this->request->data['keywords']);
                        }
                        $this->request->data['keywords'] = $keyword;

                       // If upload image not blank
                        $flag=0;
                        if(!empty($this->request->data['roadmap_graphic']['name'])){

                            $RoadmapImg = $this->request->data['roadmap_graphic'];
                            $RoadmapImgName = $this->Multiupload->roadmapGraphicUpload($RoadmapImg);
                            
                            if(empty($RoadmapImgName['errors'])){
                                $savedRoadMapImg=$RoadmapImgName['imgName'];
                            }else {
                                $flag=1;
                            }   
                        }
                        
                        $startup = $this->Startups->patchEntity($startup,$this->request->data); 
                        $startup->roadmap_graphic =$savedRoadMapImg;
                        $startup->next_step=$nextstep;
                        $startup->user_id = $UserId;
                        $startup->id = $startupId;

                        //Get List of Team Users
                        $startupTeamLists = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId,'StartupTeams.approved' => 1]])->contain(['Users','ContractorRoles'])->select(['user_id'])->toArray();

                        if ($this->Startups->save($startup)) {
                            if($flag==1){
                                $this->Flash->error('Invalid! Allowed extensions are .jpg, .jpeg, .gif, .png.. Max upload size 2MB.');
                            }else {

                                // Save notification
                                $values = [];
                                //,json_encode($values);
                                $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartupOverview',$id]);
                                foreach ($startupTeamLists as $key => $value) {
                                    $teamUser= $value->user_id;
                                    $this->WebNotification->sendNotification($UserId,$teamUser,'Startup_update','has updated startup <strong> '.$stpName.'</strong>',$link,$values);
                                }  
                                //Save feeds
                                $this->Feeds->saveStartupFeeds($UserId,'feeds_startup_updated',$startupId);

                                $this->Flash->success('Startup has been updated.');   
                            } 
                        }else {
                            $this->Flash->error('Unable to update startup.');
                        }

                     }  
                     $this->set('startup',$startup); 


            } 
                 
            
     }

     /**
     * viewStartupOverview method
     *
     *
     */
     public function viewStartupOverview($id=null)
     {      
            $startupId = base64_decode($id);
            $this->set('startupId', $id);

            $this->loadModel('Roadmaps');
            $this->loadModel('StartupTeams');

            $this->loadModel('Funds');
            $isFunded= $this->Funds->find('all',['conditions'=>["FIND_IN_SET($startupId,Funds.portfolios_id)"]])->contain(['Users'])->first();
            
            if(!empty($isFunded)){
              $this->set('funded_by', $isFunded->title);
              $nnn=$isFunded->user->first_name.' '.$isFunded->user->last_name;
              $this->set('fund_creator', $nnn);
            }else{
              $this->set('funded_by', '');
              $this->set('fund_creator', '');
            }

            $this->loadModel('Funds');
            $isFunded= $this->Funds->find('all',['conditions'=>["FIND_IN_SET($startupId,Funds.portfolios_id)"]])->contain(['Users'])->first();

            $this->loadModel('StartupProfiles');
            $isStartupProfileFile= $this->StartupProfiles->find('all',['conditions'=>['startup_id'=>$startupId]])->first();

            $user = $this->Auth->user();
            $UserId = $this->request->Session()->read('Auth.User.id');
            if($user){

               ///Check is user part of Team ot not 
               $isPartStartupTeam = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startupId,'StartupTeams.user_id'=>$UserId,'StartupTeams.approved !=' => 0]])->order('StartupTeams.id DESC')->first();
               //pr($isPartStartupTeam); die; 
                if(!empty($isPartStartupTeam))                            
                {
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

                 }else{

                    return $this->redirect(['action' => 'viewStartup',$id]);
                 }    
            }         

     }

     /**
     * viewStartup method
     *
     *
     */
     public function viewStartup($id=null)
     {      
            $startupId = base64_decode($id);
            $this->set('startupId', $id);

            $this->loadModel('Roadmaps');
            $user = $this->Auth->user();
            if($user){

                     $startup = $this->Startups->newEntity();
                     $UserId = $this->request->Session()->read('Auth.User.id');

                     /*$Keywords = $this->Startups->Keywords->find('list')->toArray();
                     $this->set('Keywords',$Keywords);*/

                     $this->loadModel('KeywordStartups');
                     $Keywords = $this->KeywordStartups->find('list')->toArray();
                     $this->set('Keywords',$Keywords);

                     //$roadmap = $this->Roadmaps->find('list')->toArray();
                     $roadmaps = $this->Roadmaps->find('all')->toArray();
                     $this->set('roadmaps', $roadmaps);

                     $singleStartup = $this->Startups->find('all',
                                            ['conditions'=>['Startups.id'=>$startupId]])
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

                    //========== Get is user hired for startup or not ==========//
                    $this->loadModel('StartupTeams'); 

                    $LogUserIsHired = $this->StartupTeams->exists(['startup_id' => $startupId, 'user_id'=>$UserId]);

                    if(!empty($LogUserIsHired)){
                       $startupsTeam = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId,'StartupTeams.user_id'=>$UserId,'StartupTeams.approved !='=>3]])->contain(['Startups','Users','ContractorRoles'])->order(['StartupTeams.id DESC'])->first();  
                    }else{
                        $startupsTeam ='';
                    }
                    
                  $this->set('startupsTeam',$startupsTeam);


            }         

     }

     /**
     * acceptInvitation method remove user from team 
     *
     *
     ***/

    public function acceptInvitation($id = null)
    {
            $startupId = base64_decode($id);
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->loadModel('StartupTeams');

            $this->request->allowMethod(['post']);

            $startupsTeam = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId,'StartupTeams.user_id'=>$UserId]])->contain(['Startups','Users','ContractorRoles'])->order(['StartupTeams.id DESC'])->first(); 
           
            $steamId= $startupsTeam->id;
            $StpOwnerId= $startupsTeam->startup->user_id;
            $StpName= $startupsTeam->startup->name;
            $hiredBy= $startupsTeam->hired_by;

            $query = $this->StartupTeams->query();

            $suucess = $query->update()->set(['approved'=>1])->where(['id' => $steamId])->execute();

            if ($suucess) {

                  //Save user notification 
                  $values = [];
                  //,json_encode($values);

                 if($StpOwnerId == $hiredBy){
                        $link= Router::url(['controller' => 'Startups', 'action' => 'editStartupTeam',$id]);
                  }else{ 
                        $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartupTeam',$id]);
                  }
                 
                 $this->WebNotification->sendNotification($UserId,$StpOwnerId,'TeamMember_accepted','has accepted your proposal for startup <strong> '.$StpName.'</strong>',$link,$values);

                  //Save feeds
                  $this->Feeds->saveStartupFeeds($UserId,'feeds_startup_member_added',$startupId);


                    $this->Flash->success('Invitation has been accepted successfully.');

                    return $this->redirect(['action' => 'viewStartup',$id]);

            } else {
                $this->Flash->error('Oops there is some problem. Please, try again.');
            }
            return $this->redirect(['action' => 'viewStartup',$id]);
    }


    /**
     * declineInvitation method remove user from team 
     *
     *
     ***/

    public function declineInvitation($id = null)
    {
            $startupId = base64_decode($id);
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->loadModel('StartupTeams');

            $this->request->allowMethod(['post', 'delete']);
            $startupsTeam = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId,'StartupTeams.user_id'=>$UserId]])->contain(['Startups','Users','ContractorRoles'])->order(['StartupTeams.id DESC'])->first(); 
           
            $steamId= $startupsTeam->id;
            $StpOwnerId= $startupsTeam->startup->user_id;
            $StpName= $startupsTeam->startup->name;

            $hiredBy= $startupsTeam->hired_by;

            $startupTeam = $this->StartupTeams->get($steamId);

            

            // change status to three
            $query = $this->StartupTeams->query();
            $suucess = $query->update()->set(['approved'=>3])->where(['id' => $steamId])->execute();    
            //if ($this->Startups->StartupTeams->delete($startupTeam)) {

            if ($suucess) {

                 // Save notification to database
                  $values = [];
                  //,json_encode($values);
                  if($StpOwnerId == $hiredBy){
                        $link= Router::url(['controller' => 'Startups', 'action' => 'editStartupTeam',$id]);
                  }else{ 
                        $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartupTeam',$id]);
                  }
                  $this->WebNotification->sendNotification($UserId,$StpOwnerId,'TeamMember_rejected','has rejected your proposal for startup <strong> '.$StpName.'</strong>',$link,$values);

                  
                    $this->Flash->success('Invitation has been declined successfully.');

                    return $this->redirect(['action' => 'viewStartup',$id]); 

            } else {
                $this->Flash->error('Invitation could not be declined. Please, try again.');
            }

            return $this->redirect(['action' => 'viewStartup',$id]);
    }



    /**
     * EditStartupTeam method 
     *
     *
     ***/
    public function editStartupTeam($id=null)
    {       
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId', $UserId);

            //$userQuickbloxId= $this->WebNotification->getUserQuickbloxId($UserId);
            
            //Get start up details by id =>['EntrepreneurBasics']
            $startupDetails = $this->Startups->get($startupId, ['contain' => ['Users'=>['EntrepreneurBasics']]])->toArray();
            $this->set('startupDetails', $startupDetails); 

            $startups = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId,'StartupTeams.approved !=' => 0, 'OR'=>['StartupTeams.approved !=' => 3]]])->contain(['Users','ContractorRoles']);

//pr($startupDetails); die;

            //check if user has rights to access the team area of enerpreneur 
             $createdByLogUser = $this->Startups->exists(['id' => $startupId, 'user_id'=>$UserId]);
             $LogUserCoFounder = $this->Startups->StartupTeams->exists(['startup_id' => $startupId, 'user_id'=>$UserId, 'contractor_role_id'=>2]); 
             $this->set('LogUserIsCoFounder', $LogUserCoFounder);

            $LogUserIsTeamMember = $this->Startups->StartupTeams->exists(['startup_id' => $startupId, 'user_id'=>$UserId, 'contractor_role_id'=>3]);
            $this->set('LogUserIsTeamMember', $LogUserIsTeamMember);



             if(!empty($createdByLogUser) or !empty($LogUserCoFounder)){

                $this->set('startups', $this->paginate($startups));    

             } else {
                $this->redirect(['action' => 'currentStartup']);
             } 

    }

    /**
     * viewStartupTeam method 
     *
     *
     ***/
    public function sendMessage($id=null,$startupId=null,$type=null)
    {
            $receiverId = base64_decode($id);
            $this->set('receiverId', $id);

            $UserId = $this->request->Session()->read('Auth.User.id');

            $startupIdd= base64_decode($startupId);
            $this->set('startupId', $startupId);

            $this->loadModel('StartupTeams');
            //$startDetails = $this->Startups->get($startupId,['conditions'=>['Users.id'=>$followId]]);
            $startTeam = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startupIdd, 'StartupTeams.user_id'=>$UserId]])->first();

            if(!empty($startTeam)){

               $roleId= $startTeam->contractor_role_id;

            }else {

                $this->loadModel('Startups');
                $startDetails = $this->Startups->get($startupIdd);
                $startupUseId= $startDetails->user_id;
                if($startupUseId == $UserId){
                    $roleId=1;
                }else{
                     $roleId=0;
                }
            }

            
            $type = base64_decode($type);
            if($type == 'entr'){
             $this->set('viewType', $type);
            }else{
               $this->set('viewType', ''); 
            }

            

            $this->loadModel('Users');
            $users = $this->Users->find('all',['conditions'=>['Users.id'=>$receiverId]])->first();
            $this->set('users', $users); 

            $this->loadModel('Messages');
            $Messages = $this->Messages->newEntity();

            if($this->request->is('post')){
                    $this->request->data['sender_id']=$UserId;
                    $this->request->data['receiver_id']=$receiverId;
                    $this->request->data['receiver_email']=$users->email;
                    $this->request->data['sender_role_id']=$roleId;
                    $this->request->data['msg_type']='team';
                   // $this->request->data['read']=0;

                    $Messages = $this->Messages->patchEntity($Messages,$this->request->data);
                    if ($this->Messages->save($Messages)){

                        //Save Notification to database
                        $values = [];
                       //,json_encode($values);
                        $link= Router::url(['controller' => 'Messages', 'action' => 'index']);

                        $this->WebNotification->sendNotification($UserId,$receiverId,'Message','has sent you a <strong> message.</strong>',$link,$values);
                        
                        $this->Flash->success('Message has been sent successfully.');

                        if($type == 'entr'){
                            return $this->redirect(['action' => 'editStartupTeam',$startupId]);
                        }else{
                            return $this->redirect(['action' => 'viewStartupTeam',$startupId]);
                        }
                        
                    }else {
                        $this->Flash->error('Could not send message! Please try again.');
                    }

            }


            $this->set('Messages', $Messages);
    }

    /**
     * sendMail method 
     *
     *
     ***/
    public function sendMail($id=null,$startupId=null,$type=null)
    {
            $receiverId = base64_decode($id);
            $this->set('receiverId', $id);

            $UserId = $this->request->Session()->read('Auth.User.id');
            

            $startupIdd= base64_decode($startupId);
            $this->set('startupId', $startupId);

            $this->loadModel('StartupTeams');
            //$startDetails = $this->Startups->get($startupId,['conditions'=>['Users.id'=>$followId]]);
            $startTeam = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startupIdd, 'StartupTeams.user_id'=>$UserId]])->first();

            if(!empty($startTeam)){

               $roleId= $startTeam->contractor_role_id;

            }else {

                $this->loadModel('Startups');
                $startDetails = $this->Startups->get($startupIdd);
                $startupUseId= $startDetails->user_id;
                if($startupUseId == $UserId){
                    $roleId=1;
                }else{
                     $roleId=0;
                }
            }

            
            $type = base64_decode($type);
            if($type == 'entr'){
             $this->set('viewType', $type);
            }else{
               $this->set('viewType', ''); 
            }

            

            $this->loadModel('Users');
            $users = $this->Users->find('all',['conditions'=>['Users.id'=>$receiverId]])->first();
            $this->set('users', $users); 

            $this->loadModel('Messages');
            $Messages = $this->Messages->newEntity();

            if($this->request->is('post')){

                    $to = $users->email;
                    $subject= $this->request->data['subject'];
                    $comment= $this->request->data['comment'];

                    $emailId = $this->request->Session()->read('Auth.User.email');
                    $name = $this->request->Session()->read('Auth.User.name');

                   // $this->request->data['read']=0;
                        $email = new Email();
                        /*$email->from([$emailId => $name])
                              ->to($to)
                              ->subject($subject)
                              ->send($comment);*/

                        $headers=['subject'=>'Crowd Bootstrap'];      
                        $result= $email->template('sendmail')
                                    ->to($to)
                                    ->subject('Crowd Bootstrap') 
                                    ->emailFormat('html')
                                    ->from([$emailId => $name])
                                    ->viewVars(['comment' => $comment])
                                    //->setHeaders($headers)                  
                                    ->send();           
//debug($result);die;
                        $this->Flash->success('Email has been sent successfully.');
                        if($type == 'entr'){
                            return $this->redirect(['action' => 'editStartupTeam',$startupId]);
                        }else{
                            return $this->redirect(['action' => 'viewStartupTeam',$startupId]);
                        }
                        

            }


            $this->set('Messages', $Messages);
    }     


    /**
     * viewStartupTeam method 
     *
     *
     ***/
    public function viewStartupTeam($id=null)
    {       
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId', $UserId);
            $this->loadModel('StartupTeams');


            ///Check is user part of Team ot not 
               $isPartStartupTeam = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startupId,'StartupTeams.user_id'=>$UserId,'StartupTeams.approved !=' => 0]])->first();

               $this->set('userApprovStatus', $isPartStartupTeam->approved);


                if(!empty($isPartStartupTeam))                            
                {       
                        $this->set('UserRoleId', $isPartStartupTeam->contractor_role_id);

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
                }else{

                    return $this->redirect(['action' => 'viewStartup',$id]);
                 }           

    }

    
    /**
     * recommendedContractors method remove user from team 
     *
     *
     ***/

    public function recommendedContractors($id = null)
    {
        $this->paginate = [ 'limit' => 10];
        $startupId = base64_decode($id); 
        $this->set('startupId', $id);

        $this->loadModel('Startups');
        $this->loadModel('Users');
        $this->loadModel('ContractorBasics');
        $this->loadModel('ContractorProfessionals');


        $this->loadModel('EntrepreneurProfessionals');
        $this->loadModel('Keywords');
        $this->loadModel('Roadmaps');

        $this->loadModel('Roadmaps');
        $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
        $this->set('Keywords',$Keywords);
        
        $user = $this->Auth->user();
        $users='';
        if($user){

          if(!empty($startupId))
          {

              $UserId = $this->request->Session()->read('Auth.User.id');

              $searchKeyword=trim($this->request->query('search'));
              $searchKeyword = str_replace("'","",$searchKeyword);

              if(!empty($searchKeyword)){

                $ss = explode(' ', $searchKeyword);
                if(!empty($ss)){
                  $searchKeyword =$ss[0];
                }
              
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
                        $conditions = ['Users.id IN'=>$contractorIds,
                        'Users.id !='=>$UserId];

                        $users= $this->Users->find('all',['conditions'=>$conditions])->contain(['ContractorBasics','ContractorProfessionals','Countries','States'])->order(['Users.first_name' => 'ASC','Users.last_name' => 'ASC']);

                        
                        $this->set('users',$this->paginate($users)); 

                  }                                                        

              }else{

                  $Startup = $this->Startups->find('all',['conditions'=>['Startups.id'=>$startupId]])
                                          ->select(['keywords','user_id'])
                                          ->first()
                                          ->toArray();

                  if(!empty($Startup)&&($Startup['keywords']!=''))
                  {

                        $StartupUserId=$Startup['user_id'];
                        $conditions = [];
                        array_push($conditions,["ContractorProfessionals.user_id !="=>$UserId]);
                        array_push($conditions,["ContractorProfessionals.user_id !="=>$StartupUserId]);
                        
                        $conditions['OR'] = [];
                 
                            foreach(explode(',',$Startup['keywords']) as $single_keyword):
                                 
                                 array_push($conditions['OR'],["FIND_IN_SET($single_keyword,ContractorProfessionals.keywords)"]);
                                 
                            endforeach;

                        $contractors = $this->ContractorProfessionals->find('all')
                                                        ->where($conditions)
                                                        ->select(['user_id']);

                        $this->set('contractors', $this->paginate($contractors)); 


                        if($contractors->toArray())
                        {
                    
                            $contractors = $contractors->toArray();
                            
                            foreach($contractors as $singleContractor):
                                if($singleContractor->user_id!=''):
                                    $contractorIds[] = $singleContractor->user_id;
                                endif;
                            endforeach;


                            if(!empty($contractorIds)){
                    
                                $users = $this->Users->find('all',['conditions'=>['Users.id IN'=>$contractorIds]])
                                            ->contain(['ContractorBasics','ContractorProfessionals','Countries'])
                                            ->toArray();
                            }                
                        }

                }      

                $this->set('users', $users);   

            }

        }else{
          return $this->redirect($this->referer());
        }                  
                 
      }          
    }

    /**
     * Suspend method remove user from team 
     *
     *
     ***/

    public function suspend($id = null)
    {
            $id = base64_decode($id);
            $UserId = $this->request->Session()->read('Auth.User.id');

            $this->request->allowMethod(['post', 'delete']);

            $startupTeam = $this->Startups->StartupTeams->get($id);
            $startupId= base64_encode($startupTeam->startup_id);

            $startupDetails = $this->Startups->get($startupTeam->startup_id);
            $stpName=$startupDetails->name;

            $reciverId= $startupTeam->user_id;
            $query = $this->Startups->StartupTeams->query();

            $suucess = $query->update()->set(['approved'=>2])->where(['id' => $id])->execute();

            if ($suucess) {

                // Save notifications
                $values = [];
                //,json_encode($values);
                $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartup',$startupId]);
                $this->WebNotification->sendNotification($UserId,$reciverId,'TeamMember_status','has suspended your services for the time being from startup <strong>'.$stpName.'</strong>',$link,$values);
                         
                $this->Flash->success('Contractor has been suspended successfully.');
                
            } else {
                $this->Flash->error('Contractor could not be suspended. Please, try again.');
            }
            return $this->redirect($this->referer());
    }

    /**
     * Resume method remove user from team 
     *
     *
     ***/

    public function resume($id = null)
    {
            $id = base64_decode($id);
            $UserId = $this->request->Session()->read('Auth.User.id');

            $this->request->allowMethod(['post', 'delete']);

            $startupTeam = $this->Startups->StartupTeams->get($id);
            $startupId= base64_encode($startupTeam->startup_id);
            $reciverId= $startupTeam->user_id;

            $startupDetails = $this->Startups->get($startupTeam->startup_id);
            $stpName=$startupDetails->name;

            $query = $this->Startups->StartupTeams->query();

            $suucess = $query->update()->set(['approved'=>1])->where(['id' => $id])->execute();

            if ($suucess) {


                // Save notifications
                $values = [];
                //,json_encode($values);
                $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartup',$startupId]);

                $this->WebNotification->sendNotification($UserId,$reciverId,'TeamMember_status','has resumed your services for startup <strong> '.$stpName.'</strong>',$link,$values);

                         
                $this->Flash->success('Contractor has been resumed successfully.');

            } else {
                $this->Flash->error('Contractor could not be resumed. Please, try again.');
            }
            return $this->redirect($this->referer());
    }

    /**
     * Delete method remove user from team 
     *
     *
     ***/

    public function delete($id = null,$contractorID = null)
    {
            echo $id = base64_decode($id);
            $UserId = $this->request->Session()->read('Auth.User.id');
            echo $contractorID = base64_decode($contractorID);

            $this->request->allowMethod(['post', 'delete']);

            $startupTeam = $this->Startups->StartupTeams->get($id);
            $startupId= base64_encode($startupTeam->startup_id);
            $reciverId= $startupTeam->user_id;

            $startupDetails = $this->Startups->get($startupTeam->startup_id);
            $stpName=$startupDetails->name;

            //Update workorder Status
            $this->loadModel('StartupWorkOrders');
            $query1 = $this->StartupWorkOrders->query();
            $suucess1 = $query1->update()->set(['show_status'=>1])->where(['user_id'=>$contractorID,'startup_team_id' => $id])->execute(); 

            $this->loadModel('StartupTeams');
            $query = $this->StartupTeams->query();
            $suucess = $query->update()->set(['approved'=>3])->where(['id' => $id])->execute(); 
            //if ($this->Startups->StartupTeams->delete($startupTeam)) {
            if ($suucess) {
                // Save notifications
                $values = [];
                //,json_encode($values);
                $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartup',$startupId]);
                $this->WebNotification->sendNotification($UserId,$reciverId,'TeamMember_status','has removed  you from the startup <strong> '.$stpName.'</strong>',$link,$values);
                         
                $this->Flash->success('Contractor has been removed successfully.');
                
            } else {
                $this->Flash->error('Contractor could not be removed. Please, try again.');
            }
            return $this->redirect($this->referer());
    }


    /**
     * EditStartupWorkorder method 
     *
     *
     ***/
    public function editStartupWorkorder($id=null)
    {       
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);

            $UserId = $this->request->Session()->read('Auth.User.id');
            //check if user has rights to access the team area of enerpreneur 
             $createdByLogUser = $this->Startups->exists(['id' => $startupId, 'user_id'=>$UserId]);

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


    }

    /****
     *
     *update startup Profile
     *
     ****/
    public function entrepreneurExcelDownload($id=null)
    {
        $this->viewBuilder()->layout(false);

        $startupId = base64_decode($id);
        $this->set('startupId', $id);

        $StartupsTable = $this->loadModel('Startups');
        $StartupTeamsTable = $this->loadModel('StartupTeams');
        $StartupWorkOrdersTable = $this->loadModel('StartupWorkOrders');
        
        $finalContractorDetails = [];
        
        if($this->request->is('post')){
            
            $startup_id = $startupId;
            
            $teamMembers = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startup_id]])
                                    ->select(['user_id','work_units_allocated']);
            
            
            if(!empty($teamMembers)):
                
                $teamMembers = $teamMembers->toArray();
                
                foreach($teamMembers as $singleTeammember):
                    
                    $SinglContractorDetails['ContractorName'] = $this->Contractor->contractorName($singleTeammember->user_id);
                    $SinglContractorDetails['ContractorEmail'] = $this->Contractor->contractorEmail($singleTeammember->user_id);
                    $SinglContractorDetails['AllocatedHours'] = ($singleTeammember->work_units_allocated!='')?$singleTeammember->work_units_allocated:'';
                    $SinglContractorDetails['ConsumedHours'] = $this->Contractor->memberConsumedHours($startup_id,$singleTeammember->user_id);
                    
                    if($SinglContractorDetails['AllocatedHours']!=''):
                        $SinglContractorDetails['RemainingHours'] = $SinglContractorDetails['AllocatedHours']-$SinglContractorDetails['ConsumedHours'];
                    else:
                        $SinglContractorDetails['RemainingHours'] = '0';
                    endif;
                     
                    $finalContractorDetails[] = $SinglContractorDetails;
                    
                endforeach;
                
            endif;
            
            $startupDetails = $this->Startups->find('all',['conditions'=>['Startups.id'=>$startup_id]])
                                                ->select(['name'])
                                                ->first();
                                                 
            if(!empty($startupDetails)&&($startupDetails->name!='')):
                $startup_name = $startupDetails->name;
            else:
                $startup_name = 'Anonymous Startup';
            endif;
            
            $this->set('startup_name',$startup_name);
            $this->set('finalContractorDetails',$finalContractorDetails);
            
            
            /*if(!empty($finalContractorDetails)):
                $result['code'] = 200;
                $result['file_path'] = 'excel_files/test.xlsx';
                echo json_encode($result);
            else:
                $result['code'] = 404;
                $result['message'] = 'No file found';
                echo json_encode($result);
            endif;*/
        }
        
    }


    /**
     * viewStartupWorkorder method 
     *
     *
     ***/
    public function updateStartupWorkorder($id=null,$getWeek=null,$getYear=null)
    {       
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);
            $UserId = $this->request->Session()->read('Auth.User.id');

            $this->loadModel('StartupTeams');
            ///Check is user part of Team ot not 
               $isPartStartupTeam = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startupId,'StartupTeams.user_id'=>$UserId,'StartupTeams.approved'=>1]])->order(['StartupTeams.id DESC'])->first();

               

                if(!empty($isPartStartupTeam))                            
                { 
                    $startupTeamId=$isPartStartupTeam->id;
                    $approveUnits= $isPartStartupTeam->work_units_approved;
                    $allocatedUnits= $isPartStartupTeam->work_units_allocated;

                    $this->set('userApprovStatus',$isPartStartupTeam->approved);

                }else{

                    return $this->redirect(['action' => 'viewStartupOverview',$id]);
                }

            
            //check if user has rights to access the team area of enerpreneur 
             $createdByLogUser = $this->Startups->exists(['id' => $startupId, 'user_id'=>$UserId]);

            $this->loadModel('Roadmaps');
            $roadmaps = $this->Roadmaps->find('all')->toArray();
            $this->set('roadmaps', $roadmaps);

             // Get hired roadmap id for user'StartupTeams.approved !=' => 0]])->order('StartupTeams.id DESC')
            $hiredRoadmapList = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId,'StartupTeams.user_id'=>$UserId,'StartupTeams.approved !=' => 0]])->order('StartupTeams.id DESC')->contain(['Users','Startups'])->first();

            $hiredRoadmapIds='';

            if(!empty($hiredRoadmapList)){
             $hiredRoadmapIds= $hiredRoadmapList->roadmap_id;
            }

            $this->set('hiredRoadmapIds', $hiredRoadmapIds); 

            //$WorkOrderListByweek = $this->Startups->StartupWorkOrders->find('all');

            $hiredRoadmapIds=explode(',',$hiredRoadmapIds);
            
            $from = date("Y-m-d",strtotime('monday this week'));
            $to = date("Y-m-d",strtotime('sunday this week'));
                        
                
            $week_no = date('W', strtotime($from));
            $year = date('Y', strtotime($from));

               
            $fromm = date("F d, Y", strtotime("{$year}-W{$week_no}-1")); //Returns the date of monday in week


            if (isset($getYear) && isset($getWeek)) {
                 $week_no =$getWeek;
                 $year =$getYear;
                 

                 $from = date("Y-m-d", strtotime("{$year}-W{$week_no}-1")); 
                 $to = date("Y-m-d", strtotime("{$year}-W{$week_no}-7")); //Returns the date of sunday in week

                 $fromm = date("F d, Y", strtotime("{$year}-W{$week_no}-1"));
            }
            $this->set('dateYear', $year);
            $this->set('week_no', $week_no);
            $this->set('from', $fromm);


            $countRoamapId=count($hiredRoadmapIds);
            for($i=0; $i<$countRoamapId;$i++){
             $sigleHiredRoadmapId = $hiredRoadmapIds[$i];

            while($from <= $to){
                    $singleStartup = $this->Startups->find('all',
                                                    ['conditions'=>['Startups.id'=>$startupId]])
                                    ->contain(['StartupTeams'=>['conditions'=>['StartupTeams.startup_id'=>$startupId
                                                                                ,'StartupTeams.user_id'=>$UserId,'StartupTeams.approved'=>1]
                                                                ],
                                               'StartupWorkOrders'=>
                                                            ['conditions'=>['StartupWorkOrders.startup_id'=>$startupId,
                                                                            'StartupWorkOrders.user_id'=>$UserId,
                                                                             'StartupWorkOrders.startup_team_id'=>$startupTeamId,
                                                                            'StartupWorkOrders.roadmap_id'=>$sigleHiredRoadmapId,
                                                                            'StartupWorkOrders.work_date'=>$from
                                                                            ]
                                                                        ]
                                                       ])
                                            ->first();                                


//pr($singleStartup);die; 
//}
                   //pr($singleStartup); die;
                    if(!empty($singleStartup)): 
                        //echo $from; echo '<br>';
                        $result['startup_id'] = ($singleStartup->id!='')?$singleStartup->id:' ';
                        $result['teammember_id'] = ($singleStartup->user_id!='')?$singleStartup->user_id:' ';
                        $result['Allocated_hours'] = (isset($singleStartup['startup_teams'][0]['work_units_allocated']))?$singleStartup['startup_teams'][0]['work_units_allocated']:' ';
                        $result['Approved_hours'] = (isset($singleStartup['startup_teams'][0]['work_units_approved']))?$singleStartup['startup_teams'][0]['work_units_approved']:' ';
                        
                        if(!empty($singleStartup['startup_work_orders'])){
                                 $dd = 0;
                                $singleDateWorkOrderArray = [];
                                $cc= count($singleStartup['startup_work_orders']); 

                              foreach($singleStartup['startup_work_orders'] as $singleWorkOrder):
                                        
                                    $singleDeliverable['work_orderid'] = ($singleWorkOrder->id!='')?$singleWorkOrder->id:' ';
                                    
                                    $roadmap = $this->UserImageWeb->RoadmapDetails($singleWorkOrder->roadmap_id);
                                    
                                    $singleDeliverable['deliverable_name'] = $roadmap;

                                    $singleDeliverable['approv_status'] = $singleWorkOrder->status;

                                    $dd=$singleWorkOrder->work_units+$dd;;

                                   // $singleDeliverable['work_units'] = ($singleWorkOrder->work_units!='')?$singleWorkOrder->work_units:' ';
       
                                endforeach; 
                                
                                $singleDeliverable['work_units']=$dd;
                                $singleDateWorkOrderArray[] = $singleDeliverable;
                                 
                                $singleDateObject['date'] = $from;
                                $singleDateObject['roadmap_id'] = $sigleHiredRoadmapId;
                                $singleDateObject['deliverables']  = $singleDateWorkOrderArray;
                                 
                        }else{
                            
                            $singleDateObject['date'] = $from;
                            $singleDateObject['roadmap_id'] = $sigleHiredRoadmapId;
                            $singleDateObject['deliverables']  = [];
                            
                        }
                    
                    else:
                            
                            $singleDateObject['date'] = $from;
                            $singleDateObject['roadmap_id'] = $sigleHiredRoadmapId;
                            $singleDateObject['deliverables']  = [];
                        
                        
                    endif;
                    
                    $FinalObject[$i][] = $singleDateObject;
                    
                    $from = date('Y-m-d', strtotime('+1 day', strtotime($from)));
                }

                    ///$from = date("Y-m-d",strtotime('monday this week'));
                   $from = date("Y-m-d", strtotime("{$year}-W{$week_no}-1"));
        }
                $result['consumedHours'] = $this->UserImageWeb->memberConsumedHours($startupId,$UserId,$startupTeamId);
                $result['weekly_update'] = $FinalObject;

            $this->set('workorderlits',$result);  

            //Get Current Week submited hours
            $con= count($result['weekly_update']);
            $thisweekSum =0;
            for($ij=0;$ij<$con;$ij++) {

                    for($ji=0;$ji<6;$ji++){
                        //pr($result['weekly_update'][$ij][$ji]['deliverables'][0]['work_units']); die;
                        if(!empty($result['weekly_update'][$ij][$ji]['deliverables'])){
                            if($result['weekly_update'][$ij][$ji]['deliverables'][0]['approv_status']==1){

                                $thisweekSum +=$result['weekly_update'][$ij][$ji]['deliverables'][0]['work_units'];

                            }
                        }    
                    }
            }
            //echo $thisweekSum;die;

            //// Save Contractor Work order
            $updateWorkUnits = $this->Startups->StartupWorkOrders->newEntity();

            if ($this->request->is(['post', 'put'])) 
            {  
                //Check is_submited or not
                if(isset($this->request->data['submit'])){
                   $is_submited=1; 
                }else{
                    $is_submited=0;
                }


                //Check is updated units are lesser to allocated units
                $Actual_remaining_hour= $result['Approved_hours']-$result['consumedHours'];

                //add this week hours to remaining hours
                $remaining_hour=$thisweekSum+$Actual_remaining_hour;

                $sum=0;
                foreach ($this->request->data as $keyss => $valuess) {
                    $sum += $valuess;
                }

                if($sum>$remaining_hour){

                    if($remaining_hour<1){
                        $this->Flash->error('You have already consumed your allocated hours.');
                    }else{    
                        $this->Flash->error('You can not add more than to '.$Actual_remaining_hour.' work units.');
                    }

                }else{


                    //Make array for post data with work units
                    $unitsArr=array();
                    foreach ($this->request->data as $key => $value) {
                        
                         $unitsArr[]=['data'=>explode('_', $key),'work_units'=>$value];              
                    }

                    // Get Date,StartupId DeliverableId and work units from array.
                    $unitsArrCount= count($unitsArr);
                    for($xy=0; $xy<$unitsArrCount-1;$xy++){

                      //Check if work uits is not blank
                      //if(!empty($unitsArr[$xy]['work_units'])){

                        $unitDate= $unitsArr[$xy]['data'][1].'-'.$unitsArr[$xy]['data'][2].'-'.$unitsArr[$xy]['data'][3];
                        $unitStartup= $unitsArr[$xy]['data'][5];
                        $unitDeliv= $unitsArr[$xy]['data'][7];
                        $workUnits= $unitsArr[$xy]['work_units'];
                        
                        $week_noo = date('W', strtotime($unitDate)); 
                        $yearrr = date('Y', strtotime($unitDate));

                            ///Check if submited date record exists 
                            $checkWorkOrderexist = $this->Startups->StartupWorkOrders->exists(['StartupWorkOrders.startup_id' => $unitStartup,'StartupWorkOrders.startup_team_id'=>$startupTeamId, 'StartupWorkOrders.user_id'=>$UserId,'StartupWorkOrders.work_date'=>$unitDate,'StartupWorkOrders.roadmap_id'=>$unitDeliv]); 
                        
                            if($checkWorkOrderexist ==1){
                                $checkWorkOrderexistArray = $this->Startups->StartupWorkOrders->find('all',['conditions'=>['StartupWorkOrders.startup_id' => $unitStartup, 'StartupWorkOrders.user_id'=>$UserId,'StartupWorkOrders.startup_team_id'=>$startupTeamId,'StartupWorkOrders.work_date'=>$unitDate,'StartupWorkOrders.roadmap_id'=>$unitDeliv]])->first();


                                if($is_submited == 1){ 
                                            ///Update data to database and change status 
                                            $updateWorkUnits = $this->Startups->StartupWorkOrders->newEntity();
                                            //$updateWorkUnits = $this->Startups->StartupWorkOrders->patchEntity($updateWorkUnits,$this->request->data);
                                            $updateWorkUnits['id']=$checkWorkOrderexistArray->id;
                                            $updateWorkUnits['startup_team_id']=$startupTeamId;
                                            $updateWorkUnits['user_id']=$UserId;
                                            $updateWorkUnits['startup_id']=$unitStartup;
                                            $updateWorkUnits['roadmap_id']=$unitDeliv;
                                            $updateWorkUnits['work_units']=$workUnits;
                                            $updateWorkUnits['status']=0;
                                            $updateWorkUnits['show_status']=0;
                                            $updateWorkUnits['work_date']=$unitDate;
                                            $updateWorkUnits['is_submited']=$is_submited; //1
                                            $updateWorkUnits['week_no']=$week_noo.'_'.$yearrr;
                                            if ($this->Startups->StartupWorkOrders->save($updateWorkUnits)) {  
                                            //$this->Flash->success('Work Units have been updated successfully.'); 
                                            //return $this->redirect($this->referer());
                                            }else {
                                                //$this->Flash->error('Unable to update work units, Please try again.');
                                            }
                                }else{
                                            ///Update data to database and change status 
                                            if($checkWorkOrderexistArray->work_units == $workUnits)
                                            {
                                                $newSatus=$checkWorkOrderexistArray->status;
                                            }else{
                                                $newSatus=0;
                                            }    
                                            $updateWorkUnits = $this->Startups->StartupWorkOrders->newEntity();
                                            $updateWorkUnits['id']=$checkWorkOrderexistArray->id;
                                            $updateWorkUnits['user_id']=$UserId;
                                            $updateWorkUnits['startup_team_id']=$startupTeamId;
                                            $updateWorkUnits['startup_id']=$unitStartup;
                                            $updateWorkUnits['roadmap_id']=$unitDeliv;
                                            $updateWorkUnits['work_units']=$workUnits;
                                            $updateWorkUnits['status']=$newSatus;
                                            $updateWorkUnits['show_status']=0;
                                            $updateWorkUnits['work_date']=$unitDate;
                                            $updateWorkUnits['is_submited']=$is_submited; //1
                                            $updateWorkUnits['week_no']=$week_noo.'_'.$yearrr;
                                            if ($this->Startups->StartupWorkOrders->save($updateWorkUnits)) {  
                                            //$this->Flash->success('Work Units have been updated successfully.'); 
                                            //return $this->redirect($this->referer());
                                            }else {
                                                //$this->Flash->error('Unable to update work units, Please try again.');
                                            }
                                }    
                            }else{
                                if(!empty($unitsArr[$xy]['work_units'])){   
                                ///Update data to database and change status 
                                        $updateWorkUnits = $this->Startups->StartupWorkOrders->newEntity();
                                        //$updateWorkUnits = $this->Startups->StartupWorkOrders->patchEntity($updateWorkUnits,$this->request->data);
                                        $updateWorkUnits['user_id']=$UserId;
                                        $updateWorkUnits['startup_team_id']=$startupTeamId;
                                        $updateWorkUnits['startup_id']=$unitStartup;
                                        $updateWorkUnits['roadmap_id']=$unitDeliv;
                                        $updateWorkUnits['work_units']=$workUnits;
                                        $updateWorkUnits['status']=0;
                                        $updateWorkUnits['show_status']=0;
                                        $updateWorkUnits['work_date']=$unitDate;
                                        $updateWorkUnits['is_submited']=$is_submited;
                                        $updateWorkUnits['week_no']=$week_noo.'_'.$yearrr;
                                        if ($this->Startups->StartupWorkOrders->save($updateWorkUnits)) {  
                                            //$this->Flash->success('Work Units have been updated successfully.'); 
                                            //return $this->redirect($this->referer());
                                        }else {
                                            //$this->Flash->error('Unable to update work units, Please try again.');
                                        }
                                }        
                            } 
                      //} 

                    } // End of For

                        //Save Notification to database
                        if(isset($this->request->data['submit'])){
                            $values = [];
                            //,json_encode($values);
                            $link= Router::url(['controller' => 'Startups', 'action' => 'editStartupWorkorder',$id]);
                            $this->WebNotification->sendNotification($UserId,$hiredRoadmapList->startup->user_id,'Workunits_updated','has updated work units for startup <strong>'.$hiredRoadmapList->startup->name.'</strong>',$link,$values);

                        }

                        $this->Flash->success('Work Units have been updated successfully.');
                        return $this->redirect($this->referer());
                  // pr($unitsArr); die; 
                                    
                } // End of remaining hour check
                

            }

            $this->set('updateWorkUnits',$updateWorkUnits); 

    }

    /**
     * viewStartupWorkorder method 
     *
     *
     ***/
    public function viewStartupWorkorder($id=null,$getWeek=null,$getYear=null)
    {       
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId', $UserId);

            $this->loadModel('StartupTeams');
            ///Check is user part of Team ot not 
               $isPartStartupTeam = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startupId,'StartupTeams.user_id'=>$UserId,'StartupTeams.approved !='=>0]])->order(['StartupTeams.id DESC'])->first();


                if(!empty($isPartStartupTeam))                            
                {
                    $StartupTeamId= $isPartStartupTeam->id;
                    $approveUnits= $isPartStartupTeam->work_units_approved;
                    $allocatedUnits= $isPartStartupTeam->work_units_allocated;

                    $this->set('userApprovStatus',$isPartStartupTeam->approved);

                }else{

                    return $this->redirect(['action' => 'viewStartup',$id]);
                }

            
            //check if user has rights to access the team area of enerpreneur 
             $createdByLogUser = $this->Startups->exists(['id' => $startupId, 'user_id'=>$UserId]);

            $this->loadModel('Roadmaps');
            $roadmaps = $this->Roadmaps->find('all')->toArray();
            $this->set('roadmaps', $roadmaps);

             // Get hired roadmap id for user 'StartupTeams.approved !=' => 0]])->order('StartupTeams.id DESC')
            $hiredRoadmapList = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId,'StartupTeams.user_id'=>$UserId,'StartupTeams.approved !=' => 0]])->order('StartupTeams.id DESC')->contain(['Users'])->first();
            //pr($hiredRoadmapList); die;
            $hiredRoadmapIds='';
            if(!empty($hiredRoadmapList)){
             $hiredRoadmapIds= $hiredRoadmapList->roadmap_id;
            }

            $this->set('hiredRoadmapIds', $hiredRoadmapIds); 

            //$WorkOrderListByweek = $this->Startups->StartupWorkOrders->find('all');

            $hiredRoadmapIds=explode(',',$hiredRoadmapIds);
            
            $from = date("Y-m-d",strtotime('monday this week'));
            $to = date("Y-m-d",strtotime('sunday this week'));
                        
                
            $week_no = date('W', strtotime($from));
            $year = date('Y', strtotime($from));
            if($week_no == 52){
              //$week_no = 01;
              //$year = $year+1;
            }
               
            $fromm = date("F d, Y", strtotime("{$year}-W{$week_no}-1")); //Returns the date of monday in week


            if (isset($getYear) && isset($getWeek)) {
                 $week_no =$getWeek;
                 $year =$getYear;
                 if($week_no == 52){
                    $week_no = 01;
                    $year = $year+1;
                 }

                 $from = date("Y-m-d", strtotime("{$year}-W{$week_no}-1"));
                 $to = date("Y-m-d", strtotime("{$year}-W{$week_no}-7")); //Returns the date of sunday in week

                 $fromm = date("F d, Y", strtotime("{$year}-W{$week_no}-1"));
            }
            $this->set('dateYear', $year);
            $this->set('week_no', $week_no);
            $this->set('from', $fromm);


            $countRoamapId=count($hiredRoadmapIds);
            for($i=0; $i<$countRoamapId;$i++){
             $sigleHiredRoadmapId = $hiredRoadmapIds[$i];

            while($from <= $to){
   
            /*$WorkOrderListByweek = $this->Startups->StartupWorkOrders->find('all')->where(['StartupWorkOrders.user_id'=>$UserId,'StartupWorkOrders.work_date '=> $from,'StartupWorkOrders.roadmap_id IN' => $hiredRoadmapIds])->contain(['Startups','Roadmaps'])->first();

                $finaArray[]=$WorkOrderListByweek;

            $from = date('Y-m-d', strtotime('+1 day', strtotime($from)));*/


           /* $singleStartup = $this->Startups->find('all',['conditions'=>['Startups.id'=>$startupId]])->contain(['StartupTeams'=>['conditions'=>['StartupTeams.startup_id'=>$startupId,'StartupTeams.user_id'=>$UserId]
                                                                        ],'StartupWorkOrders'=>['conditions'=>['StartupWorkOrders.startup_id'=>$startupId,
                                                                                            'StartupWorkOrders.user_id'=>$UserId,'StartupWorkOrders.roadmap_id'=>$sigleHiredRoadmapId,
                                                                                            'StartupWorkOrders.work_date'=>$from]
                                                                        ]
                                                       ])
                                            ->first();*/

//if($from == '2016-05-10'){
            $singleStartup = $this->Startups->find('all',
                                                    ['conditions'=>['Startups.id'=>$startupId]])
                                    ->contain(['StartupTeams'=>
                                                            ['conditions'=>['StartupTeams.startup_id'=>$startupId,
                                                              'StartupTeams.user_id'=>$UserId]
                                                            ],
                                                'StartupWorkOrders'=>
                                                            ['conditions'=>['StartupWorkOrders.startup_id'=>$startupId,
                                                                'StartupWorkOrders.startup_team_id'=>$StartupTeamId,
                                                                'StartupWorkOrders.user_id'=>$UserId,
                                                                'StartupWorkOrders.roadmap_id'=>$sigleHiredRoadmapId,
                                                                'StartupWorkOrders.work_date'=>$from
                                                                ]
                                                            ]
                                              ])
                                            ->first();                                                             
//pr($singleStartup);die; 
//}
                   //pr($singleStartup); 
                    if(!empty($singleStartup)):
                        //echo $from; echo '<br>';
                        $count = count($singleStartup['startup_teams']);
                        $count=$count-1;

                        $result['startup_id'] = ($singleStartup->id!='')?$singleStartup->id:' ';
                        $result['teammember_id'] = ($singleStartup->user_id!='')?$singleStartup->user_id:' ';
                        $result['Allocated_hours'] = (isset($singleStartup['startup_teams'][$count]['work_units_allocated']))?$singleStartup['startup_teams'][$count]['work_units_allocated']:' ';
                         $result['entrepreneur_id'] = ($singleStartup->user_id!='')?$singleStartup->user_id:' ';
                        $result['contractor_id'] = (isset($singleStartup['startup_teams'][$count]['user_id']))?$singleStartup['startup_teams'][$count]['user_id']:' ';

                        $result['Approved_hours'] = (isset($singleStartup['startup_teams'][$count]['work_units_approved']))?$singleStartup['startup_teams'][$count]['work_units_approved']:' ';
                        
                        if(!empty($singleStartup['startup_work_orders'])){
                                 $dd = 0;
                                $singleDateWorkOrderArray = [];
                                $cc= count($singleStartup['startup_work_orders']); 

                              foreach($singleStartup['startup_work_orders'] as $singleWorkOrder):
                                         
                                    $singleDeliverable['work_orderid'] = ($singleWorkOrder->id!='')?$singleWorkOrder->id:' ';
                                    
                                    $roadmap = $this->UserImageWeb->RoadmapDetails($singleWorkOrder->roadmap_id);
                                    
                                    $singleDeliverable['deliverable_name'] = $roadmap;

                                    $dd=$singleWorkOrder->work_units+$dd;;

                                   // $singleDeliverable['work_units'] = ($singleWorkOrder->work_units!='')?$singleWorkOrder->work_units:' ';
       
                                endforeach; 
                                
                                $singleDeliverable['work_units']=$dd;
                                $singleDateWorkOrderArray[] = $singleDeliverable;
                                 
                                $singleDateObject['date'] = $from;
                                $singleDateObject['roadmap_id'] = $sigleHiredRoadmapId;
                                $singleDateObject['deliverables']  = $singleDateWorkOrderArray;
                                 
                        }else{
                            
                            $singleDateObject['date'] = $from;
                            $singleDateObject['roadmap_id'] = $sigleHiredRoadmapId;
                            $singleDateObject['deliverables']  = [];
                            
                        }
                    
                    else:
                            
                            $singleDateObject['date'] = $from;
                            $singleDateObject['roadmap_id'] = $sigleHiredRoadmapId;
                            $singleDateObject['deliverables']  = [];
                        
                        
                    endif;
                    
                    $FinalObject[$i][] = $singleDateObject;
                    
                    $from = date('Y-m-d', strtotime('+1 day', strtotime($from)));
                }

                    ///$from = date("Y-m-d",strtotime('monday this week'));
                   $from = date("Y-m-d", strtotime("{$year}-W{$week_no}-1"));
        }
                $result['consumedHours'] = $this->UserImageWeb->memberConsumedHours($startupId,$UserId,$StartupTeamId);
                $result['unapproved_consumedHours'] = $this->UserImageWeb->memberunApprovedConsumedHours($startupId,$UserId,$StartupTeamId);
                $result['weekly_update'] = $FinalObject;
//echo '<pre>';                
//print_r($result);die;
            $this->set('workorderlits',$result);  


            // Get submited date of workorder
            $weekNo= $week_no.'_'.$year;
            $this->loadModel('StartupWorkOrders');
            $worderSubmisionDate= $this->StartupWorkOrders->find('all', ['conditions' => ['StartupWorkOrders.startup_id' => $startupId,'StartupWorkOrders.startup_team_id'=>$StartupTeamId,'StartupWorkOrders.week_no ' => $weekNo]])->order('StartupWorkOrders.id ASC')->first();
            if(!empty($worderSubmisionDate)){
               $todayDate=date('Y-m-d');
               $subDate= date_format($worderSubmisionDate->created,"Y-m-d");

               $date1=date_create($subDate);
               $date2=date_create($todayDate);
               //$date1=date_create("2013-03-16");
               //$date2=date_create("2013-03-16");
               $diff=date_diff($date1,$date2);
               $submittedDays= $diff->format("%a");
               if($submittedDays <31){
                  $daysLeft= 1;
               }else{
                  $daysLeft= 0;
               }
            }else{
              $daysLeft= 0;
            }   
           $this->set('daysLeft',$daysLeft);

            //// Save rating for work order
            $weekNo= $week_no.'_'.$year;
            $this->loadModel('WorkorderRatings');

            $workorderRatingListEntrewpreneur = $this->WorkorderRatings->find('all', ['conditions' => ['WorkorderRatings.startup_id' => $startupId,'WorkorderRatings.startup_team_id'=>$StartupTeamId,'WorkorderRatings.week_no' => $weekNo,'WorkorderRatings.given_by' => $result['entrepreneur_id']]])->first();
            $this->set('workorderRatingListEntrewpreneur',$workorderRatingListEntrewpreneur); 

            $workorderRatingList = $this->WorkorderRatings->find('all', ['conditions' => ['WorkorderRatings.startup_id' => $startupId,'WorkorderRatings.startup_team_id'=>$StartupTeamId,'WorkorderRatings.week_no' => $weekNo,'WorkorderRatings.given_by' => $UserId]])->first();

            $this->set('workorderRatingList',$workorderRatingList); 
            
//pr($updateWorkUnits->toArray()); die;
            $updateWorkUnits = $this->WorkorderRatings->newEntity();
            if ($this->request->is(['post', 'put'])) 
            {
                    $stpid=$this->request->data['startup_id'];

                    $this->request->data['given_by'];
                    $this->request->data['given_to'];
                    $this->request->data['description']=$this->request->data['work_comment'];
                    $this->request->data['startup_id']=base64_decode($this->request->data['startup_id']);
                    $this->request->data['rating_star']=0;
                    $this->request->data['week_no'];
                    $this->request->data['status']=1;
                    $this->request->data['is_entrepreneur'];
                    $this->request->data['startup_team_id']=$StartupTeamId;

                    $updateWorkUnits = $this->WorkorderRatings->patchEntity($updateWorkUnits,$this->request->data);

                    //Check id rating exist for user
                    if(!empty($workorderRatingList)){
                      $updateWorkUnits->id=$workorderRatingList->id;
                    }

                    if ($this->WorkorderRatings->save($updateWorkUnits)) {  
                            $this->Flash->success('Comment saved successfully.'); 

                            //Save Notification to database
                            $values = [];
                            //,json_encode($values);
                            $link= Router::url(['controller' => 'Startups', 'action' => 'entrepreneurStartupWorkorder',$stpid,$week_no,$year,base64_encode($this->request->data['startup_team_id'])]);

                            $this->WebNotification->sendNotification($this->request->data['given_by'],$this->request->data['given_to'],'Workorder_rating','has commented on workorder.',$link,$values);

                            return $this->redirect($this->referer());

                    }else {
                            $this->Flash->error('Unable to save your comment, Please try again.');
                    }
            }

            $this->set('updateWorkUnits',$updateWorkUnits); 

    }


    /**
     * entrepreneurStartupWorkorder method 
     *
     *
     ***/
    public function entrepreneurStartupWorkorder($id=null,$getWeek=null,$getYear=null,$getTeamId=null)
    {       
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);

            $getTeamId = base64_decode($getTeamId);

            $entrepreneurId = $this->request->Session()->read('Auth.User.id');
            $this->set('entrepreneurId', $entrepreneurId);

            $this->loadModel('StartupTeams');
            ///Check is user part of Team ot not 
               //$isPartStartupTeam = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startupId,'StartupTeams.user_id'=>$viewUserId,'StartupTeams.approved !='=>0]])->order(['StartupTeams.id DESC'])->first();

               $isPartStartupTeam = $this->StartupTeams->get($getTeamId);

                if(!empty($isPartStartupTeam))                            
                {
                    $UserId =$isPartStartupTeam->user_id;
                    $this->set('UserId', $UserId);

                    $StartupTeamId= $isPartStartupTeam->id;
                    $approveUnits= $isPartStartupTeam->work_units_approved;
                    $allocatedUnits= $isPartStartupTeam->work_units_allocated;

                    $this->set('userApprovStatus',$isPartStartupTeam->approved);

                }else{

                    return $this->redirect(['action' => 'viewStartup',$id]);
                }

            
            //check if user has rights to access the team area of enerpreneur 
            $createdByLogUser = $this->Startups->exists(['id' => $startupId, 'user_id'=>$UserId]);

            $this->loadModel('Roadmaps');
            $roadmaps = $this->Roadmaps->find('all')->toArray();
            $this->set('roadmaps', $roadmaps);

             // Get hired roadmap id for user 'StartupTeams.approved !=' => 0]])->order('StartupTeams.id DESC')
            $hiredRoadmapList = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId,'StartupTeams.user_id'=>$UserId,'StartupTeams.id ' => $getTeamId]])->order('StartupTeams.id DESC')->contain(['Users'])->first();
            //pr($hiredRoadmapList); die;
            $hiredRoadmapIds='';
            if(!empty($hiredRoadmapList)){
             $hiredRoadmapIds= $hiredRoadmapList->roadmap_id;
            }

            $this->set('hiredRoadmapIds', $hiredRoadmapIds); 

            //$WorkOrderListByweek = $this->Startups->StartupWorkOrders->find('all');

            $hiredRoadmapIds=explode(',',$hiredRoadmapIds);
            
            $from = date("Y-m-d",strtotime('monday this week'));
            $to = date("Y-m-d",strtotime('sunday this week'));
                        
                
            $week_no = date('W', strtotime($from));
            $year = date('Y', strtotime($from));
               
            $fromm = date("F d, Y", strtotime("{$year}-W{$week_no}-1")); //Returns the date of monday in week


            if (isset($getYear) && isset($getWeek)) {
                 $week_no =$getWeek;
                 $year =$getYear;
                 if($week_no == 52){
                    $week_no = 01;
                    $year = $year+1;
                 }

                 $from = date("Y-m-d", strtotime("{$year}-W{$week_no}-1"));
                 $to = date("Y-m-d", strtotime("{$year}-W{$week_no}-7")); //Returns the date of sunday in week

                 $fromm = date("F d, Y", strtotime("{$year}-W{$week_no}-1"));
            }
            $this->set('dateYear', $year);
            $this->set('week_no', $week_no);
            $this->set('from', $fromm);


            $countRoamapId=count($hiredRoadmapIds);
            for($i=0; $i<$countRoamapId;$i++){
             $sigleHiredRoadmapId = $hiredRoadmapIds[$i];

            while($from <= $to){

            $singleStartup = $this->Startups->find('all',
                                                    ['conditions'=>['Startups.id'=>$startupId]])
                                    ->contain(['StartupTeams'=>
                                              ['conditions'=>['StartupTeams.startup_id'=>$startupId,
                                                              'StartupTeams.user_id'=>$UserId,
                                                              'StartupTeams.id'=>$getTeamId
                                                             ]
                                              ],
                                        'StartupWorkOrders'=>
                                                    ['conditions'=>['StartupWorkOrders.startup_id'=>$startupId,
                                                        'StartupWorkOrders.startup_team_id'=>$getTeamId,
                                                        'StartupWorkOrders.user_id'=>$UserId,
                                                        'StartupWorkOrders.roadmap_id'=>$sigleHiredRoadmapId,
                                                        'StartupWorkOrders.work_date'=>$from
                                                        ]
                                                    ]
                                              ])
                                            ->first();                                                             
//pr($singleStartup);die; 
//}
                   //pr($singleStartup); 
                    if(!empty($singleStartup)):
                        //echo $from; echo '<br>';
                        $count = count($singleStartup['startup_teams']);
                        $count=$count-1;

                        $result['startup_id'] = ($singleStartup->id!='')?$singleStartup->id:' ';
                        $result['teammember_id'] = ($singleStartup->user_id!='')?$singleStartup->user_id:' ';
                        $result['Allocated_hours'] = (isset($singleStartup['startup_teams'][$count]['work_units_allocated']))?$singleStartup['startup_teams'][$count]['work_units_allocated']:' ';
                         $result['entrepreneur_id'] = ($singleStartup->user_id!='')?$singleStartup->user_id:' ';
                        $result['contractor_id'] = (isset($singleStartup['startup_teams'][$count]['user_id']))?$singleStartup['startup_teams'][$count]['user_id']:' ';

                        $result['Approved_hours'] = (isset($singleStartup['startup_teams'][$count]['work_units_approved']))?$singleStartup['startup_teams'][$count]['work_units_approved']:' ';
                        
                        if(!empty($singleStartup['startup_work_orders'])){
                                 $dd = 0;
                                $singleDateWorkOrderArray = [];
                                $cc= count($singleStartup['startup_work_orders']); 

                              foreach($singleStartup['startup_work_orders'] as $singleWorkOrder):
                                         
                                    $singleDeliverable['work_orderid'] = ($singleWorkOrder->id!='')?$singleWorkOrder->id:' ';
                                    
                                    $roadmap = $this->UserImageWeb->RoadmapDetails($singleWorkOrder->roadmap_id);
                                    
                                    $singleDeliverable['deliverable_name'] = $roadmap;

                                    $dd=$singleWorkOrder->work_units+$dd;;

                                   // $singleDeliverable['work_units'] = ($singleWorkOrder->work_units!='')?$singleWorkOrder->work_units:' ';
       
                                endforeach; 
                                
                                $singleDeliverable['work_units']=$dd;

                                $singleDateWorkOrderArray[] = $singleDeliverable;
                                 
                                $singleDateObject['date'] = $from;
                                $singleDateObject['roadmap_id'] = $sigleHiredRoadmapId;
                                $singleDateObject['deliverables']  = $singleDateWorkOrderArray;
                                 
                        }else{
                            
                            $singleDateObject['date'] = $from;
                            $singleDateObject['roadmap_id'] = $sigleHiredRoadmapId;
                            $singleDateObject['deliverables']  = [];
                            
                        }
                    
                    else:
                            
                            $singleDateObject['date'] = $from;
                            $singleDateObject['roadmap_id'] = $sigleHiredRoadmapId;
                            $singleDateObject['deliverables']  = [];
                        
                        
                    endif;
                    
                    $FinalObject[$i][] = $singleDateObject;
                    
                    $from = date('Y-m-d', strtotime('+1 day', strtotime($from)));
                }

                    ///$from = date("Y-m-d",strtotime('monday this week'));
                   $from = date("Y-m-d", strtotime("{$year}-W{$week_no}-1"));
        }
                $result['consumedHours'] = $this->UserImageWeb->memberConsumedHours($startupId,$UserId,$StartupTeamId);
                $result['weekly_update'] = $FinalObject;
//pr($result);die;
            $this->set('workorderlits',$result);  



            // Get submited date of workorder
            $weekNo= $week_no.'_'.$year;
            $this->loadModel('StartupWorkOrders');
            $worderSubmisionDate= $this->StartupWorkOrders->find('all', ['conditions' => ['StartupWorkOrders.startup_id' => $startupId,'StartupWorkOrders.startup_team_id'=>$StartupTeamId,'StartupWorkOrders.week_no ' => $weekNo]])->order('StartupWorkOrders.id ASC')->first();
            
            if(!empty($$worderSubmisionDate)){
               $todayDate=date('Y-m-d');

               $subDate= date_format($worderSubmisionDate->created,"Y-m-d");

               $date1=date_create($subDate);
               $date2=date_create($todayDate);
               //$date1=date_create("2013-03-16");
               //$date2=date_create("2013-03-16");
               $diff=date_diff($date1,$date2);
               $submittedDays= $diff->format("%a");
               if($submittedDays <16){
                  $daysLeft= 1;
               }else{
                  $daysLeft= 1;
               }
            }else{
              $daysLeft= 1;
            }   
           $this->set('daysLeft',$daysLeft); 

            //// Save rating for work order
            $weekNo= $week_no.'_'.$year;
            $this->loadModel('WorkorderRatings');

            $workorderRatingListContractor = $this->WorkorderRatings->find('all', ['conditions' => ['WorkorderRatings.startup_id' => $startupId,'WorkorderRatings.startup_team_id'=>$StartupTeamId,'WorkorderRatings.week_no' => $weekNo,'WorkorderRatings.given_by' => $UserId]])->first();

            $this->set('workorderRatingListContractor',$workorderRatingListContractor); 

            $workorderRatingList = $this->WorkorderRatings->find('all', ['conditions' => ['WorkorderRatings.startup_id' => $startupId,'WorkorderRatings.startup_team_id'=>$StartupTeamId,'WorkorderRatings.week_no' => $weekNo,'WorkorderRatings.given_by' => $entrepreneurId]])->first();

            $this->set('workorderRatingList',$workorderRatingList); 
            
//pr($updateWorkUnits->toArray()); die;
            $updateWorkUnits = $this->WorkorderRatings->newEntity();
            if ($this->request->is(['post', 'put'])) 
            {
                    $stpid=$this->request->data['startup_id'];
                    $this->request->data['given_by'];
                    $this->request->data['given_to'];
                    $this->request->data['description']=$this->request->data['work_comment'];
                    $this->request->data['startup_id']=base64_decode($this->request->data['startup_id']);
                    $this->request->data['rating_star'];
                    $this->request->data['week_no'];
                    $this->request->data['status']=1;
                    $this->request->data['is_entrepreneur'];
                    $this->request->data['startup_team_id']=$StartupTeamId;

                    $updateWorkUnits = $this->WorkorderRatings->patchEntity($updateWorkUnits,$this->request->data);

                    //Check id rating exist for user
                    if(!empty($workorderRatingList)){
                      $updateWorkUnits->id=$workorderRatingList->id;
                    }

                    if ($this->WorkorderRatings->save($updateWorkUnits)) {  
                            $this->Flash->success('Comment saved successfully.'); 

                            //Save Notification to database
                            $values = [];
                            //,json_encode($values);
                            $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartupWorkorder',$stpid]);

                            $this->WebNotification->sendNotification($this->request->data['given_by'],$this->request->data['given_to'],'Workorder_rating','has commented on your workorder.',$link,$values);

                            return $this->redirect($this->referer());

                    }else {
                            $this->Flash->error('Unable to save your comment, Please try again.');
                    }
            }

            $this->set('updateWorkUnits',$updateWorkUnits); 

    }

    /****
     *
     * Download excel sheet for work order
     *
     ****/
    public function ContractorExcelDownload($id=null,$getWeek=null,$getYear=null)
    {
        $this->viewBuilder()->layout(false);
        //$this->render(false);

        $startupId = base64_decode($id);
        $this->set('startupId', $id);

        $UserId = $this->request->Session()->read('Auth.User.id');
        $startupsTable = $this->loadModel('Startups');
        $StartupTeamsTable = $this->loadModel('StartupTeams');
        $RoadmapsTable = $this->loadModel('Roadmaps');
        $ContractorProffesionalsTable = $this->loadModel('ContractorProfessionals');
        
        $FinalObject = [];
        $deliverables_list = [];
        $UserHoursDetails = [];
        
        if($this->request->is(['post', 'put']))
        {            
                $user_id =$UserId;
                $startup_id = $startupId;
                
                $from = date("Y-m-d",strtotime('monday this week'));
                $to = date("Y-m-d",strtotime('sunday this week'));


                            
                    
                $week_no = date('W', strtotime($from));
                $year = date('Y', strtotime($from));
                   
                $fromm = date("F d, Y", strtotime("{$year}-W{$week_no}-1")); //Returns the date of monday in week


                if (isset($getYear) && isset($getWeek)) {
                     $week_no =$getWeek;
                     $year =$getYear;

                     $from = date("Y-m-d", strtotime("{$year}-W{$week_no}-1"));
                     $to = date("Y-m-d", strtotime("{$year}-W{$week_no}-7")); //Returns the date of sunday in week

                     $fromm = date("F_d_Y", strtotime("{$year}-W{$week_no}-1"));
                     $tooo = date("F_d_Y", strtotime("{$year}-W{$week_no}-7"));
                }
                $this->set('from', $fromm);
                $this->set('too', $tooo);
                 //echo $from;
                 //echo $to;
                while($from <= $to){
                    
                    $singleStartup = $this->Startups->find('all',['conditions'=>['Startups.id'=>$startup_id]    ])
                                            ->contain(['StartupTeams'=>['conditions'=>['StartupTeams.startup_id'=>$startup_id,
                                                                                       'StartupTeams.user_id'=>$user_id]
                                                                        ]
                                                       ,'StartupWorkOrders'=>['conditions'=>['StartupWorkOrders.startup_id'=>$startup_id,
                                                                                            'StartupWorkOrders.user_id'=>$user_id,
                                                                                            'StartupWorkOrders.work_date'=>$from
                                                                                            ]
                                                                        ]
                                                       ])
                                            ->first();
                    
                    if(!empty($singleStartup)):
                        
                        $result['startup_id'] = ($singleStartup->id!='')?$singleStartup->id:' ';
                        $result['teammember_id'] = ($singleStartup->user_id!='')?$singleStartup->user_id:' ';
                        $result['Allocated_hours'] = (isset($singleStartup['startup_teams'][0]['work_units_allocated']))?$singleStartup['startup_teams'][0]['work_units_allocated']:' ';
                        $result['Approved_hours'] = (isset($singleStartup['startup_teams'][0]['work_units_approved']))?$singleStartup['startup_teams'][0]['work_units_approved']:' ';
                        
                        if(!empty($singleStartup['startup_work_orders'])){
                                $ddd=0; 
                                $singleDateWorkOrderArray = [];
                                
                                foreach($singleStartup['startup_work_orders'] as $singleWorkOrder):
                                    
                                    $singleDeliverable['work_orderid'] = ($singleWorkOrder->id!='')?$singleWorkOrder->id:' ';
                                    
                                    $roadmap = $this->Contractor->RoadmapDetails($singleWorkOrder->roadmap_id);
                                    
                                    $singleDeliverable['deliverable_name'] = $roadmap;
                                    $singleDeliverable['work_units'] = ($singleWorkOrder->work_units!='')?$singleWorkOrder->work_units:' ';;

                                    /*$ddd=$singleWorkOrder->work_units+$ddd;
                                    $singleDeliverable['work_units'] =$ddd;*/

                                    $singleDateWorkOrderArray[] = $singleDeliverable;
                                        
                                endforeach;
                                 
                                $singleDateObject['date'] = $from;
                                $singleDateObject['deliverables']  = $singleDateWorkOrderArray;
                                 
                        }else{
                            
                            $singleDateObject['date'] = $from;
                            $singleDateObject['deliverables']  = [];
                            
                        }
                        
                    else:
                            
                            $singleDateObject['date'] = $from;
                            $singleDateObject['deliverables']  = [];
                         
                    endif;
                    
                    $FinalObject[] = $singleDateObject;
                    
                    $from = date('Y-m-d', strtotime('+1 day', strtotime($from)));
                }
            
    //getting the deliverable name
            
            $deliverables = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startup_id,
                                                            'StartupTeams.user_id'=>$user_id]])
                                                    ->select(['roadmap_id'])
                                                    ->first();
            
            if(!empty($deliverables)&&($deliverables['roadmap_id']!='')):
            
                foreach(explode(',',$deliverables['roadmap_id']) as $deliverable):
                    if($deliverable!=''):
                        $rdMap = $this->Roadmaps->find('all',['conditions'=>['Roadmaps.id'=>$deliverable]])
                                                    ->select(['name'])
                                                    ->first();
                        if(!empty($rdMap)&&($rdMap->name!='')):
                            $deliverables_list[] = $rdMap->name;
                        endif;
                    endif;  
                endforeach;
                
            endif;
            
            $HoursDetails = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startup_id,
                                                            'StartupTeams.user_id'=>$user_id]])
                                                                ->select(['work_units_allocated','work_units_approved'])
                                                                ->first();
            
            if(!empty($HoursDetails)):
                
                $UserHoursDetails['AllocatedHours'] = ($HoursDetails->work_units_allocated!='')?$HoursDetails->work_units_allocated:'';
                
                if($UserHoursDetails['AllocatedHours']!=''):
                    $UserHoursDetails['RemainingHours'] = $UserHoursDetails['AllocatedHours']-$this->UserImageWeb->memberConsumedHours($startup_id,$user_id);
                else:
                    $UserHoursDetails['RemainingHours'] = '0';
                endif;
                
            endif;
            
            $this->set('columns',range('A', 'Z'));
            $this->set('FinalObject',$FinalObject);
            $this->set('deliverables',$deliverables_list);
            $this->set('UserHoursDetails',$UserHoursDetails);
        }

        //pr($result);
        
    }

    /**
     * accept method for workorder 
     *
     *
     ***/

    public function accept($id = null,$StartupId = null,$userId = null)
    {
        $id = base64_decode($id);
        $startupId=base64_decode($StartupId);
        $LoggedUserId = $this->request->Session()->read('Auth.User.id');
        $UserId=base64_decode($userId);
        $this->loadModel('StartupWorkOrders');
        $this->request->allowMethod(['post', 'accept']);

        $this->loadModel('Startups');
        $stratupDetails= $this->Startups->get($startupId);
        //$startupTeam = $this->Startups->StartupWorkOrders->get($id);
        //$startupTeam->status=1;
        //if ($this->Startups->StartupWorkOrders->save($startupTeam)) {
        $query = $this->StartupWorkOrders->query();
                 $query->update()
                        ->set(['status'=>1])
                        ->where(['user_id'=>$UserId,'startup_id'=>$startupId,'week_no' => $id])
                        ->execute();
        

        if ($query) {
            //Save Notification to database
            $values = [];
            //,json_encode($values);
            $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartupWorkorder',$StartupId]);
            $this->WebNotification->sendNotification($stratupDetails->user_id,$UserId,'Workunits_accepted','has accepted your work units for startup <strong>'.$stratupDetails->name.'</strong>',$link,$values);
            
            //Save feeds
            $this->Feeds->saveStartupFeeds($LoggedUserId,'feeds_startup_completed_assignment',$startupId);

            $this->Flash->success('Work units has been approved successfully.');
        } else {
            $this->Flash->error('Work units could not be removed. Please, try again.');
        }
        return $this->redirect($this->referer());
    }


    /**
     * reject method for workorder 
     *
     *
     ***/

    public function reject($id = null,$StartupId = null,$userId = null)
    {
        $id = base64_decode($id);
        $startupId=base64_decode($StartupId);
        //$UserId = $this->request->Session()->read('Auth.User.id');
        $UserId=base64_decode($userId);

        $this->request->allowMethod(['post', 'reject']);
        $this->loadModel('Startups');
        $stratupDetails= $this->Startups->get($startupId);

        //$startupTeam = $this->Startups->StartupWorkOrders->get($id);
       //$startupTeam->status=2;
        $StartupWorkOrdersTable = TableRegistry::get('StartupWorkOrders');
        $dlett= $StartupWorkOrdersTable->deleteAll(['user_id'=>$UserId,'startup_id'=>$startupId,'week_no' => $id]);
        //if ($this->Startups->StartupWorkOrders->delete($startupTeam)) {
        if ($dlett) {
            //Save Notification to database
            $values = [];
            //,json_encode($values);
            $link= Router::url(['controller' => 'Startups', 'action' => 'viewStartupWorkorder',$StartupId]);
            $this->WebNotification->sendNotification($stratupDetails->user_id,$UserId,'Workunits_rejected','has rejected your work units for startup <strong>'.$stratupDetails->name.'</strong>',$link,$values);

            $this->Flash->success('Work units has been rejected successfully.');

        } else {
            $this->Flash->error('Work units could not be rejected. Please, try again.');
        }
        return $this->redirect($this->referer());
    }


    /**
     * EditStartupDocs method 
     *
     *
     ***/
    public function editStartupDocs($id=null)
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

    /**
     * viewStartupDocs method 
     *
     *
     ***/
    public function viewStartupDocs($id=null)
    {   
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);

            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId', $UserId);

            $this->loadModel('StartupTeams');
            ///Check is user part of Team ot not 
               $isPartStartupTeam = $this->StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startupId,'StartupTeams.user_id'=>$UserId]])->first();

               $this->set('userApprovStatus',$isPartStartupTeam->approved);
               
                if(!empty($isPartStartupTeam))                            
                {

                        $this->loadModel('StartupDocs');
                        $startupDocLists = $this->StartupDocs->find('all', ['conditions' => ['StartupDocs.startup_id' => $startupId]])->contain(['Startups','Users'=>['EntrepreneurBasics'],'Roadmaps']);
                     //pr($startupDocLists); die;
                        $this->set('startupDocLists', $this->paginate($startupDocLists));
                }else{

                    return $this->redirect(['action' => 'viewStartup',$id]);
                 }        
    }

    /**
     * addStartupDocs method 
     *
     *
     ***/
    public function addStartupDocs($id=null)
    {       
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);   

            $this->loadModel('Roadmaps');
            $roadmap = $this->Roadmaps->find('list')->toArray();
            $this->set('roadmaps', $roadmap);

            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId', $UserId);

            //Check if user allowed to access that page means to upload doc
            $createdByLogUser = $this->Startups->exists(['id' => $startupId, 'user_id'=>$UserId]); 

            if($createdByLogUser !=1){
                $this->redirect(['action' => 'editStartupDocs',$id]); 
                $this->Flash->error('Your are not allowed to access this page.');
            }

            $user = $this->Auth->user();
            if($user){
                       $this->loadModel('StartupDocs');
                       $startup = $this->StartupDocs->newEntity();


                       //Get start up details by id =>['EntrepreneurBasics']
                        $startupDetails = $this->Startups->get($startupId, ['contain' => ['Users'=>['EntrepreneurBasics']]])->toArray();
                        $this->set('startupDetails', $startupDetails); 

                       //Start up Team member list
                       $startupMemberLists = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId]])->contain(['Users','ContractorRoles']);
                       $this->set('startupMemberLists',$startupMemberLists);

                    if ($this->request->is(['post', 'put'])) {

                        // If upload image not blank
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

                       $access ='';
                       $accArray= [];
                        if(!empty($this->request->data['access'])){
                          $accArray= $this->request->data['access'];
                          $access = implode(',', $this->request->data['access']);
                        } 

                        $public =1;

                            if(!empty($this->request->data['public'])){
                              $public = 0;
                            }

                       if($flag==1){
                                $this->Flash->error('Invalid! Allowed extensions are .jpg, .jpeg, .gif, .png.. Max upload size 5MB.');
                        }else { 
                               $filN= $this->request->data['name'];
                                $this->request->data['user_id']=$UserId;
                                $this->request->data['startup_id']=$startupId;
                                $this->request->data['file_path']=$newfilename;
                                $this->request->data['access']=$access;
                                $this->request->data['public']=$public;

                                $startup = $this->StartupDocs->patchEntity($startup,$this->request->data);
                               // pr($this->request->data); die;


                                //Get List of Team Users
                                $this->loadModel('StartupTeams');
                                $startupTeamLists = $this->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId,'StartupTeams.approved' => 1]])->select(['user_id'])->toArray();

                                 //pr($accArray); die;

                                if ($this->StartupDocs->save($startup)) {

//die('vvv');
                                    // Save notification
                                     $values = [];
                                    //,json_encode($values);
                                    $link= Router::url(['controller' => 'Startups', 'action' => 'editStartupDocs',$id]);

                                    // send notification to all users of team if public checked
                                    if(!empty($this->request->data['public'])){
                                        foreach ($startupTeamLists as $key => $value) {
                                           $teamUser= $value->user_id;
                                            $this->WebNotification->sendNotification($UserId,$teamUser,'Upload_doc','has uploaded a document <strong> '.$filN.'</strong>',$link,$values);
                                        }
                                    }else{
                                    // send notification to selected users
                                        if(!empty($accArray)){

                                                $coun= count($accArray);
                                                for($v=0;$v<$coun; $v++){
                                                 //echo $accArray[$v];
                                                  $this->WebNotification->sendNotification($UserId,$accArray[$v],'Upload_doc','has uploaded a document <strong> '.$filN.'</strong>',$link,$values);  
                                                }
                                        }
                                    }  
                                    $this->Flash->success('File has been uploaded successfully.'); 
                                    $this->redirect(['action' => 'editStartupDocs',$id]); 

                                }else {
                                    $this->Flash->error('Unable to upload, Please try again.');
                                }          
                       } 
                         

                    }

                       $this->set('startup',$startup);
            }           
    } 


    /**
     * addStartupDocs method 
     *
     *
     ***/
    public function addStartupDocsContractor($id=null)
    {       
            $this->paginate = [ 'limit' => 10];

            $startupId = base64_decode($id);
            $this->set('startupId', $id);   

            $this->loadModel('Roadmaps');
            $roadmap = $this->Roadmaps->find('list')->toArray();
            $this->set('roadmaps', $roadmap);

            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId', $UserId);

            //Check if user allowed to access that page means to upload doc
            $orPartofTeam = $this->Startups->StartupTeams->exists(['StartupTeams.startup_id' => $startupId,'StartupTeams.user_id' =>$UserId]);

            if($orPartofTeam !=1){
                $this->redirect(['action' => 'viewStartup',$id]); 
                //$this->Flash->error(__('Your are not allowed to access this page.'));
            }

            $user = $this->Auth->user();
            if($user){
                       $this->loadModel('StartupDocs');
                       $startup = $this->StartupDocs->newEntity();


                       //Get start up details by id =>['EntrepreneurBasics']
                        $startupDetails = $this->Startups->get($startupId, ['contain' => ['Users'=>['EntrepreneurBasics']]])->toArray();
                        $this->set('startupDetails', $startupDetails); 

                       //Start up Team member list
                       $startupMemberLists = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId]])->contain(['Users','ContractorRoles']);
                       //pr($startupMemberLists->toArray());die;
                       $this->set('startupMemberLists',$startupMemberLists);

                    if ($this->request->is(['post', 'put'])) {

                        // If upload image not blank
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

                       $access ='';
                        if(!empty($this->request->data['access'])){
                          $access = implode(',', $this->request->data['access']);
                        } 

                        $public =1;

                            if(!empty($this->request->data['public'])){
                              $public = 0;
                            }

                       if($flag==1){
                                $this->Flash->error('Invalid! Allowed extensions are .jpg, .jpeg, .gif, .png.. Max upload size 5MB.');
                        }else { 
                                $this->request->data['user_id']=$UserId;
                                $this->request->data['startup_id']=$startupId;
                                $this->request->data['file_path']=$newfilename;
                                $this->request->data['access']=$access;
                                $this->request->data['public']=$public;

                                $startup = $this->StartupDocs->patchEntity($startup,$this->request->data);
                               // pr($this->request->data); die;

                                if ($this->StartupDocs->save($startup)) { 

                                         $this->Flash->success('File has been uploaded successfully.'); 
                                         $this->redirect(['action' => 'viewStartupDocs',$id]); 

                                }else {
                                    $this->Flash->error('Unable to upload, Please try again.');
                                }          
                       } 
                         

                    }

                       $this->set('startup',$startup);
            }           
    } 

    /**
     * editStartupUploadedDocs method 
     *
     *
     ***/
    public function editStartupUploadedDocs($id=null,$StartupId=null)
    {       
            $startupDocId = base64_decode($id);
            $this->set('startupDocId', $id);

            $startupId = base64_decode($StartupId);
            $this->set('startupId', $StartupId);

            $this->loadModel('StartupDocs');

            $this->loadModel('Roadmaps');
            $roadmap = $this->Roadmaps->find('list')->toArray();
            $this->set('roadmaps', $roadmap);

            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->set('UserId', $UserId);

            //Check if user allowed to access that page means to upload doc
            $createdByLogUser = $this->StartupDocs->exists(['id' => $startupDocId, 'user_id'=>$UserId]);
            if($createdByLogUser !=1){
                $this->redirect(['action' => 'editStartupDocs',$StartupId]); 
                $this->Flash->error('Your are not allowed to access this page.');
            }  


            $user = $this->Auth->user();
            if($user){
                       $startups = $this->StartupDocs->newEntity();

                       //Get start up details by id =>['EntrepreneurBasics']
                        $startupDetails = $this->Startups->get($startupId, ['contain' => ['Users'=>['EntrepreneurBasics']]])->toArray();
                        $this->set('startupDetails', $startupDetails); 

                       //Start up Team member list
                       $startupMemberLists = $this->Startups->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $startupId]])->contain(['Users','ContractorRoles']);
                       $this->set('startupMemberLists',$startupMemberLists);

                       $startups = $this->StartupDocs->get($startupDocId,['conditions'=>['StartupDocs.id'=>$startupDocId,'StartupDocs.user_id'=>$UserId]]);

                    /// Update data to DB
                    $newfilename=$startups->file_path;
                    if ($this->request->is(['post', 'put'])) {

                        
                        // If upload image not blank
                        $flag=0;
                        if(!empty($this->request->data['file_path']['name'])){

                            $file_path = $this->request->data['file_path'];
                            $file_path_name = $this->Multiupload->uploadStratupDocs($file_path);
                            
                            if(empty($file_path_name['errors'])){
                                $newfilename=$file_path_name['imgName'];
                            }else {
                                $flag=1;
                            }   
                        }


                        $access ='';
                        if(!empty($this->request->data['access'])){
                          $access = implode(',', $this->request->data['access']);
                        } 

                        $public =1;
                        if(!empty($this->request->data['public'])){
                              $public = 0;
                        }

                        //if($access==''){$public = 0;}
                        if($flag==1){
                                $this->Flash->error('Invalid! Allowed extensions are doc,docx,PDF. Max upload size 5MB.');
                        }else { 
                                $this->request->data['user_id']=$UserId;
                                $this->request->data['startup_id']=$startupId;
                                $this->request->data['file_path']=$newfilename;
                                $this->request->data['access']=$access;
                                $this->request->data['public']=$public;

                                $startups = $this->StartupDocs->patchEntity($startups,$this->request->data);
                                $startups->id=$startupDocId;
                               // pr($this->request->data); die;

                                if ($this->StartupDocs->save($startups)) {  
                                         $this->Flash->success('Updated successfully.'); 
                                         return $this->redirect($this->referer()); 

                                }else {
                                    $this->Flash->error('Unable to upload, Please try again.');
                                }          
                       }



                    }

            }
            $this->set('startups',$startups);           

    } 

    /**
     * DeleteUploadedDocs method 
     *
     *
     ***/

    public function deleteUploadedDocs($id = null)
    {
            $startupDocId = base64_decode($id);
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->loadModel('StartupDocs');

            $this->request->allowMethod(['post', 'delete']);

            $startupDoc = $this->StartupDocs->get($startupDocId,['conditions'=>['StartupDocs.user_id'=>$UserId]]);

            if ($this->StartupDocs->delete($startupDoc)) {
                $this->Flash->success('File has been deleted successfully.');
            } else {
                $this->Flash->error('File could not be deleted. Please, try again.');
            }
            return $this->redirect($this->referer());
    }



    /**
     * EditStartupRoadmapdocs method 
     *
     *
     ***/
    public function editStartupRoadmapdocs($id=null)
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


    /****
    *
    * Download Startup doc
    *
    *
    ***/

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
     /*****
     *
     * SubmitApplication method
     *
     * 
     *
     *****/
    public function submitApplication($id=null)
    {
            $startupId = base64_decode($id);
            $this->set('startupId', $id);
            $this->loadModel('StartupQuestions');
            $this->loadModel('StartupSubmitapplicationQuestionList');

            $UserId = $this->request->Session()->read('Auth.User.id'); 

            //Get questionlist
            $StartupQuestionsList = $this->StartupSubmitapplicationQuestionList->find('all',['conditions'=>['StartupSubmitapplicationQuestionList.id'=>1]])->first();
            $this->set('QuestionsList',json_decode($StartupQuestionsList->name));

            $StartupQuestions = $this->StartupQuestions->newEntity();
            //Check if user sbmited application befor
            //,'StartupQuestions.is_submited'=>0
            $ApplicationSubmitedBefore= $this->StartupQuestions->find('all',['conditions'=>['StartupQuestions.startup_id'=>$startupId]])->first();
            if(!empty($ApplicationSubmitedBefore)){
               $this->redirect(['action' => 'editSubmitApplication',$id]); 
            }


            $startupDetails= $this->Startups->find('all',['conditions'=>['Startups.id'=>$startupId,'Startups.user_id'=>$UserId]])->first();
            

            $this->set('startupDetails',$startupDetails);

            if(!empty($startupDetails)){

                if ($this->request->is(['post', 'put'])) { 

                    // Above question Array
                    $Above['above']= array_combine($this->request->data['above']['question'], $this->request->data['above']['answer']);
                    
                    // Cofounders question Array
                    $this->request->data['cofounders']['question'] = array_values($this->request->data['cofounders']['question']);
                    $this->request->data['cofounders']['answer'] = array_values($this->request->data['cofounders']['answer']);

                    $arraylength = count($this->request->data['cofounders']['question']);
                    $preQdata = [];
                    for($ci=0; $ci<$arraylength; $ci++){

                            $preQdata[$ci]= array_combine($this->request->data['cofounders']['question'][$ci],$this->request->data['cofounders']['answer'][$ci]);

                    }

                    $CoFounderList['cofounders']=$preQdata;
                    //$CoFounderList=json_encode($CoFounderList);
                    $array1= array_merge($Above, $CoFounderList);
                    
                    // Below question Array
                    $Below['below']= array_combine($this->request->data['below']['question'], $this->request->data['below']['answer']);

                    // $Below=json_encode($Below);
                    $array2= array_merge($array1, $Below);

                    // BelowA question Array
                    $BelowA['belowA']= array_combine($this->request->data['belowA']['question'], $this->request->data['belowA']['answer']);

                    // $BelowA=json_encode($BelowA);
                    $array3= array_merge($array2, $BelowA);

                    // BelowB question Array
                    $BelowB['belowB']= array_combine($this->request->data['belowB']['question'], $this->request->data['belowB']['answer']);

                    //$BelowB=json_encode($BelowB);
                    $array4= array_merge($array3, $BelowB);

                    // BelowC question Array
                    $BelowC['belowC']= array_combine($this->request->data['belowC']['question'], $this->request->data['belowC']['answer']);

                    $array5= array_merge($array4, $BelowC);
                    //$BelowC=json_encode($BelowC);

                    // BelowD question Array
                     $BelowD['belowD']= array_combine($this->request->data['belowD']['question'], $this->request->data['belowD']['answer']);
                    //$BelowD=json_encode($BelowD);

                    $finalArray= array_merge($array5, $BelowD);
                    $finalArray= json_encode($finalArray);

                    /// Check is application submited before
                    $startupApplicationDetails= $this->StartupQuestions->find('all',['conditions'=>['StartupQuestions.startup_id'=>$startupId]])->first();


                    $this->request->data['startup_id']=$startupId;
                    $this->request->data['questions']=$finalArray;
                    $this->request->data['status']=0;

                    $StartupQuestions = $this->StartupQuestions->patchEntity($StartupQuestions, $this->request->data);
                    $StartupQuestions->is_submited=0;

                    if(!empty($startupApplicationDetails)){
                           $StartupQuestions->id= $startupApplicationDetails->id;
                    }

                    if ($this->StartupQuestions->save($StartupQuestions)) {

                        $this->Flash->success(('Your application has been saved successfully.'));
                        //return $this->redirect($this->referer());
                        $this->redirect(['action' => 'editSubmitApplication',$id]);
                    }else{

                        $this->Flash->success(_('Could not submit your application, Please try again.'));
                    }
                    
                    


                }    

            }else{

                $this->redirect(['action' => 'myStartup']);
            }    
    }

    /*****
     *
     * EditSubmitApplication method
     *
     * 
     *
     *****/
    public function editSubmitApplication($id=null)
    {   
            $startupId = base64_decode($id);
            $this->set('startupId', $id);
            $this->loadModel('StartupQuestions');

            $UserId = $this->request->Session()->read('Auth.User.id'); 

            $StartupQuestions = $this->StartupQuestions->newEntity();

            $startupDetails= $this->Startups->find('all',['conditions'=>['Startups.id'=>$startupId,'Startups.user_id'=>$UserId]])->first();
            

            $this->set('startupDetails',$startupDetails);

            if(!empty($startupDetails)){

                //,'StartupQuestions.is_submited'=>0
                $startupApplicationDetails= $this->StartupQuestions->find('all',['conditions'=>['StartupQuestions.startup_id'=>$startupId]])->first();

                if(empty($startupApplicationDetails)){
                    $this->redirect(['action' => 'editStartupRoadmapdocs',$id]);
                }
                
                $result= json_decode($startupApplicationDetails->questions);
                $this->set('result',$result);
                $this->set('resultSubmit',$startupApplicationDetails->is_submited);

                
                if ($this->request->is(['post', 'put'])) {

                    // Above question Array
                    $Above['above']= array_combine($this->request->data['above']['question'], $this->request->data['above']['answer']);
                    
                    // Cofounders question Array
                    $this->request->data['cofounders']['question'] = array_values($this->request->data['cofounders']['question']);
                    $this->request->data['cofounders']['answer'] = array_values($this->request->data['cofounders']['answer']);

                    $arraylength = count($this->request->data['cofounders']['question']);
                    $preQdata = [];
                    for($ci=0; $ci<$arraylength; $ci++){

                            $preQdata[$ci]= array_combine($this->request->data['cofounders']['question'][$ci],$this->request->data['cofounders']['answer'][$ci]);

                    }

                    $CoFounderList['cofounders']=$preQdata;
                    //$CoFounderList=json_encode($CoFounderList);
                    $array1= array_merge($Above, $CoFounderList);
                    
                    // Below question Array
                    $Below['below']= array_combine($this->request->data['below']['question'], $this->request->data['below']['answer']);

                    // $Below=json_encode($Below);
                    $array2= array_merge($array1, $Below);

                    // BelowA question Array
                    $BelowA['belowA']= array_combine($this->request->data['belowA']['question'], $this->request->data['belowA']['answer']);

                    // $BelowA=json_encode($BelowA);
                    $array3= array_merge($array2, $BelowA);

                    // BelowB question Array
                    $BelowB['belowB']= array_combine($this->request->data['belowB']['question'], $this->request->data['belowB']['answer']);

                    //$BelowB=json_encode($BelowB);
                    $array4= array_merge($array3, $BelowB);

                    // BelowC question Array
                    $BelowC['belowC']= array_combine($this->request->data['belowC']['question'], $this->request->data['belowC']['answer']);

                    $array5= array_merge($array4, $BelowC);
                    //$BelowC=json_encode($BelowC);

                    // BelowD question Array
                     $BelowD['belowD']= array_combine($this->request->data['belowD']['question'], $this->request->data['belowD']['answer']);
                    //$BelowD=json_encode($BelowD);

                    $finalArray= array_merge($array5, $BelowD);
                    $finalArray= json_encode($finalArray);
                    //pr($finalArray); die;
                    /// Check is application submited before
                    $startupApplicationDetails= $this->StartupQuestions->find('all',['conditions'=>['StartupQuestions.startup_id'=>$startupId]])->first();


                    $this->request->data['startup_id']=$startupId;
                    $this->request->data['questions']=$finalArray;
                    $this->request->data['status']=0;

                    $StartupQuestions = $this->StartupQuestions->patchEntity($StartupQuestions, $this->request->data);
                    $StartupQuestions->is_submited=0;

                    if(!empty($startupApplicationDetails)){
                           $StartupQuestions->id= $startupApplicationDetails->id;
                    }
                    if(isset($_REQUEST['submit'])){
                        $StartupQuestions->is_submited=1;
                    }

                    if ($this->StartupQuestions->save($StartupQuestions)) {
                        if(isset($_REQUEST['submit'])){
                            $this->Flash->success(('Your application has been submitted successfully.'));
                            $this->redirect(['action' => 'editStartupRoadmapdocs',$id]);

                        }else{
                            $this->Flash->success(('Your application has been submitted successfully.'));
                            return $this->redirect($this->referer());
                        }
                    }else{

                        $this->Flash->success(('Could not submit your application, Please try again.'));
                    }
                    
                }

                

                

            }else{

                $this->redirect(['action' => 'myStartup']);
            }
    }


    /***
    *
    *
    *
    *
    *****/
    public function getQuestionList()
    {
            $id  = $this->request->data['id'];
            $this->set('id',$id);
            $this->loadModel('StartupSubmitapplicationQuestionList');
            //Get questionlist
            $StartupQuestionsList = $this->StartupSubmitapplicationQuestionList->find('all',['conditions'=>['StartupSubmitapplicationQuestionList.id'=>1]])->first();
            $this->set('QuestionsList',json_decode($StartupQuestionsList->name));

            if ($this->request->is(['post', 'put'])) {

                echo $this->render('/Element/Front/applicationquestion');               
            }
    }

     /*****
     *
     * UploadStartupProfile method
     *
     * 
     *
     *****/
    public function UploadStartupProfile($id=null)
    {

            $startupId = base64_decode($id);
            $this->set('startupId', $id);
            $UserId = $this->request->Session()->read('Auth.User.id');

            $this->loadModel('StartupProfiles');

            $startupDetails= $this->Startups->find('all',['conditions'=>['Startups.id'=>$startupId,'Startups.user_id'=>$UserId]])->first();

            $this->set('startupDetails',$startupDetails);
            if(!empty($startupDetails)){
                $profiledetail= $this->StartupProfiles->find('all',['conditions'=>['StartupProfiles.startup_id'=>$startupId,'StartupProfiles.user_id'=>$UserId]])->first();

//pr($startupDetails); die;
                $startup=$this->StartupProfiles->newEntity();
                if ($this->request->is(['post', 'put'])) {

                        // If upload image not blank
                        $flag=0;
                        $newfilename='';
                        if(!empty($this->request->data['file_path']['name'])){

                            $file_path = $this->request->data['file_path'];
                            $file_path_name = $this->Multiupload->uploadStratupProfileDocsWeb($file_path);
                            
                            if(empty($file_path_name['errors'])){
                                $newfilename=$file_path_name['imgName'];
                            }else {
                                $flag=1;
                            }   
                        } 

                        if($flag==1){
                                $this->Flash->error('Invalid! Allowed extensions are .PDF, .DOC, .DOCX. Max upload size 5MB.');
                        }else {
                            $this->request->data['file_path']=$newfilename;
                            $this->request->data['startup_id']=$startupId; 
                            $this->request->data['user_id']=$UserId;
                            $startup = $this->StartupProfiles->patchEntity($startup,$this->request->data);
                            //$startup->startup_id = $startupId;     //assign startup ID
                            //$startup->user_id = $UserId;

                            if(!empty($profiledetail)){
                                $startup->id = $profiledetail->id; 
                            }
                          
                            if ($this->StartupProfiles->save($startup)) {
                                $this->Flash->success('Startup profile has been uploaded successfully.');
                                return $this->redirect($this->referer());//redirect on current page
                               // return $this->redirect(['action' => 'AddStartup/']);
                            }else{
                                $this->Flash->error('Unable to uploaded your startup profile.');
                            }

                        }
                         
                            
                }
                $this->set('startup',$startup);

            }else{

                $this->redirect(['action' => 'myStartup']);
            }
        }















    
/////////////////////////////////////////////////
     /**
     * ListCurrentStartup method
     *
     * @param string|null $userID (Loggedin ID).
     * @return void
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    /*This Function Will display all currentStartupdetail from Strartups table*/
    public function ListCurrentStartup(){
            $this->loadModel('Startups');
            $this->loadModel('Users');
            
            $user = $this->Auth->user();  
            
            if($user){
                    
                    $UserId = $this->request->Session()->read('Auth.User.id');
                    



            /*To check detail of LoggedIn User in Startups Table */
            $startupdata = $this->Startups->find('all')->contain(['Users'])->toArray();
           //pr($startupdata);die;
            $this->set('startupdata',$startupdata);

            }  

    }


    

    /*This Function will add detail of new Startup in Startup Table*/
    public function AddRoadmap($id=null){
        $this->loadModel('StartupRoadmaps');
        $this->loadModel('Roadmaps');
        
        $roadmap = $this->StartupRoadmaps->newEntity();
        $UserId = $this->request->Session()->read('Auth.User.id');
        $startup_id = $id;
        
        /*Fetching Records from Roadmap table with respective login ID*/
         $roadmaplist = $this->Roadmaps->find('list')->toArray();
         $this->set('roadmaplist', $roadmaplist);
       
       if($this->request->is('Post')){
        
        $roadmap = $this->StartupRoadmaps->patchEntity($roadmap,$this->request->data); 
        
        $roadmap->user_id = $UserId;
        $roadmap->startup_id = $startup_id;
        
        //pr($this->request->data);die;
        if($result = $this->StartupRoadmaps->save($roadmap)){
                
                $this->Flash->success('The Startup has been saved.');
                return $this->redirect(['action' => 'EditStartup/'.$startup_id]);
        } else {
                 $this->Flash->error('The Startup could not be saved. Please, try again.');
               }
        }

      
        
        $this->set('roadmap',$roadmap);
    }
    
    /**
     * DownloadDoc method
     *
     * @param string|null $id Roadmap ID.
     * @return void
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */

    /*This function will download documaent to uploaded roadmap with respective their ID  */

    public function DownloadDoc($id=null){
            $this->loadModel('StartupRoadmaps');
            $startupdetail = $this->StartupRoadmaps->get($id);
            $file_name = $startupdetail->file_path;
            if(!empty($file_name)){
            $filePath = WWW_ROOT .'img/doc'. DS . $file_name;
            $this->response->file($filePath ,array('download'=> true));
            return $this->response;
           }
    }
     /**
     * StartupDocs method
     *
     * @param string|null $id Startup ID.
     * @return void
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */

    /*This function will update Roadmap to Startup with respective their ID  */

    public function StartupDocs($id=null){
            $this->loadModel('StartupRoadmaps');
            $this->loadModel('Startups');
            $this->loadModel('Roadmaps');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $project_id = $id;
            $this->set('project_id',$project_id);
           /* $startup = $this->Startups->find('all',['conditions'=>['Startups.id'=>$id]]);
            $startup = $startup->first();*/
           
            $RoadmapTable = TableRegistry::get('StartupRoadmaps');
            $startupdetail = $this->StartupRoadmaps->find('all',['conditions'=>['StartupRoadmaps.startup_id'=>$id]])->contain(['Startups','Roadmaps']);
            $startupdetail = $startupdetail->first();
            
            $roadmap = $this->Roadmaps->find('list',['conditions'=>['Roadmaps.user_id'=>  $UserId ]])->toArray();
            $this->set('roadmap', $roadmap);
            $startup = $this->StartupRoadmaps->newEntity();
             
            if(!empty($startupdetail)){

                    $startdocs_id = $startupdetail->id;
                    $OldDoc    = $startupdetail->file_path;
                    $OldRoadmapID = $startupdetail->roadmap_id;
                    $startup = $startupdetail;
                    $startup->id = $startdocs_id;
                    $startup = $startupdetail;
                    $this->set('startup',$startup);
            }
           
       if ($this->request->is(['post', 'put'])) {
               //Upload document
               $data = $this->request->data['file_path'];
               $data['module_type'] = 'startup';
               $upload = $this->Upload->Upload($data);
            
            if(!empty($upload) && (($this->request->data['file_path']['error'])== 0)){

                $this->request->data['file_path'] = $upload;
                if(!empty($OldDoc)){
                        unlink(WWW_ROOT . 'img/doc/' .$OldDoc);//Remove old image
                }
            }
            else{
                if(!empty($OldDoc)){            //in case user do not want to upload a new image
                        $filename =  $OldDoc;
                        $this->request->data['file_path'] = $filename;
                    }
            }
            //Upload Roadmap in Startup Table
                $startup = $this->StartupRoadmaps->patchEntity($startup,$this->request->data);
                $startup->startup_id = $id;//assign startup ID
                if($this->request->data['complete'] == true ){
                $startup->previous_roadmap  = $this->request->data['next_step']; 
               
                }
                else{
                   $startup->previous_roadmap == 'Problem';  
                }
                if ($this->StartupRoadmaps->save($startup)) {
                    $this->Flash->success('Your startup has been Saved.');
                    return $this->redirect(['action' => 'EditStartup/'. $id]);
                   // return $this->redirect(['action' => 'AddStartup/']);
                    }
                else{
                    $this->Flash->error('Unable to update your startup.');
                    }
                
             
        }
                   $this->set('startup',$startup);
    }

}?>