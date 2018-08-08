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
require_once getcwd().'/linkedin/linkedin.php';
use LinkedIn;


/**
* Users Controller
*
*@property\App\Model\Table\Users table $users
**/ 
class NetworkingOptionsController extends AppController{

    public function initialize()
    {
        $helpers = ['Custom'];
        parent::initialize();
        $this->loadComponent('Upload');
        $this->loadComponent('Multiupload');
        $this->loadComponent('UserImageWeb');
        $this->loadComponent('SoftwareUpload');
        $this->loadComponent('Contractor');
        $this->loadComponent('WebNotification');
        $components = array('Linkedin.Linkedin' => array(
                                'key' => '81e3d823pozynm',
                                'secret' => 'TZ2PSU8CshUunR5X',
                            ));

    }


   
    /**
    * index Method for list messages
    *
    */
    public function index()
    {
            $UserId = $this->request->Session()->read('Auth.User.id');
            $widthClass ='';
            if(empty($UserId)){
              $widthClass ='notLogged';
            }
            $this->set('widthClass',$widthClass);
            $this->set('UserId',$UserId);
    }

   
    /**
    * Contacts Method 
    *
    */
    public function contacts($id = null)
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
        $this->loadModel('BusinessUserNetworks');

        $user = $this->Auth->user();
        $Keywords = $this->ContractorProfessionals->Keywords->find('list')->toArray();
        $this->set('Keywords',$Keywords);

        if($user){


            $users=[]; 
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

                        $businessNetworkData = $this->BusinessUserNetworks->find('all',['conditions'=>['connected_to IN'=>$contractorIds]])->toArray();

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

                                $businessNetworkData = $this->BusinessUserNetworks->find('all',['conditions'=>['connected_to IN'=>$contractorIds]]);


                               $this->paginate($users);               
                           }

                       }

                   }

               }

               if(!empty($businessNetworkData)){
                $this->set('businessNetworkData', $businessNetworkData);
               } 
               $this->set('users', $users);                     

           }

    }
    /**
    * Add Contacts Method 
    *
    */
    public function addContacts()
    {
        $this->loadModel('BusinessTempContacts');
        $businessTempContactsTable = TableRegistry::get('BusinessTempContacts'); 
        $user = $this->Auth->user(); 

        if($user){
            $user_id = $this->request->Session()->read('Auth.User.id');

            $businessUserConnTable = TableRegistry::get('BusinessUserConnectionTypes');
            $businessConnectionData = $businessUserConnTable->find('all',['conditions'=>['user_id'=>$user_id]])->toArray();

            
            if(!empty($businessConnectionData)){

                $result = json_decode($businessConnectionData[0]->data);
                
                foreach ($result as $conn) {
                     $finalArray[$conn->id] = $conn->name;
                }
                
            }else{ 

                $businessConnectionTable = TableRegistry::get('BusinessConnectionTypes');
                $finalArray = $businessConnectionTable->find('list')->toArray();

            }  
            $this->set('businessConnection',$finalArray);

            $businessContact = $businessTempContactsTable->newEntity(); 

            if($this->request->is('post'))
            {

                $uploadImgError='';
                $uploadimgName='';
                $flag=0;

                if(!empty($this->request->data['image']['name'])){
             
                    $data = [];
                    $data = $this->request->data['image']; 
                    $uploadImg = $this->SoftwareUpload->uploadImage($data);

                    if(empty($uploadImg['errors'])){
                        $uploadimgName=$uploadImg['imgName'];
                    }else{
                        $flag=1;
                        $uploadImgError=$uploadImg['errors'];
                    }
                }
                
                if(!empty($flag)){

                    if(!empty($uploadImgError)){
                        $this->Flash->error($uploadImgError);
                    }

                }else{

                    $this->request->data['image']=$uploadimgName;
                    $this->request->data['created_by']=$user_id;
                    $this->request->data['actual_user_id']= 0;
                    $this->request->data['status']= 0;
                  
                    $businessContact = $businessTempContactsTable->patchEntity($businessContact,$this->request->data);

                    if($businessTempContactsTable->save($businessContact)){
                        $this->Flash->success('The Contact has been saved.');
                        //return $this->redirect($this->referer());
                        //$startup_id = $result->id;
                        return $this->redirect(['action' => 'newUsers']);

                    }else{
                         $this->Flash->error('Could not save contact. Please, try again.');
                    } 
                }
            }   
            $this->set('businessContactData',$businessContact); 
        }

        
    
    }

    /**
    * View Business Cards Method 
    *
    */
    public function businessCardDetail($id=null,$connectionTypeId=null){

        $this->loadModel('businessCards');
        $businessCardsTable = TableRegistry::get('businessCards');

        $LoggedUserId = $this->request->Session()->read('Auth.User.id');
        $UserId = $this->request->Session()->read('Auth.User.id');

        $this->set('LoggedUserId',$LoggedUserId);

        //$connectionTypeId = base64_decode($connectionTypeId);

        $businessCardId = base64_decode($id);
        $validCardId = $businessCardsTable->exists(['id'=>$businessCardId]);

        $businessUserConnTable = TableRegistry::get('BusinessUserConnectionTypes');
        $businessConnectionData = $businessUserConnTable->find('all',['conditions'=>['user_id'=>$UserId]])->first();

        //pr($businessConnectionData->data);     die;   

        $finalArray = [];
        if(!empty($businessConnectionData)){

            $result = json_decode($businessConnectionData->data,True);
            $i = 0;
            foreach ($result as $key => $value) 
            {   $i++;
                $finalArray[$i]=$value['name'];
            }

        }else{ 

            $businessConnectionTable = TableRegistry::get('BusinessConnectionTypes');
            $result = $businessConnectionTable->find('list')->toArray();
            $finalArray =$result;
        }

        $this->set('businessConnection',$finalArray);

        if($validCardId){
            $businessCardDetail= $businessCardsTable->find('all',['conditions'=>['businessCards.id'=>$businessCardId]])->contain(['Users'])->first();
             
            //pr($businessCardDetail);
            $this->set('businessCardDetail', $businessCardDetail);
            
        }

        $businessCardNotesTable = TableRegistry::get('BusinessCardNotes');
        $businessCardNotes = $businessCardNotesTable->newEntity(); 
        
        if($this->request->is('post')){      

            // If connect button is clicked
            if(isset($this->request->data['connect'])){

                $BusinessUserNetworksTable = TableRegistry::get('BusinessUserNetworks');
                $BusinessUserNetwork = $BusinessUserNetworksTable->newEntity();

                $connectionTypId =$this->request->data['connection_type_id'];

                if(!empty($connectionTypId)){
                    $this->request->data['user_id'] = $UserId;
                    $this->request->data['connected_to'] =$this->request->data['connected_to'];
                    $this->request->data['connection_type_id'] =$connectionTypId;
                    $this->request->data['business_card_id'] = $businessCardId;

                    $BusinessUserNetwork = $BusinessUserNetworksTable->patchEntity($BusinessUserNetwork,$this->request->data);

                    if($BusinessUserNetworksTable->save($BusinessUserNetwork)){
                        $this->Flash->success('Connected successfully.');
                        return $this->redirect($this->referer());

                    }else{
                         $this->Flash->error('Could not connect. Please, try again.');
                    }
                }else{
                    $this->Flash->error('Please select connection type.');
                }

            // If disconnect button is clicked    
            }else if(isset($this->request->data['disconnect'])){ 

                $BusinessUserNetworksTable = TableRegistry::get('BusinessUserNetworks');
                $query = $BusinessUserNetworksTable->query();
                $rsl = $query->delete()
                    ->where(['user_id' => $UserId,'connected_to'=>$this->request->data['connected_to']])
                    ->execute();

                if($rsl){
                    $this->Flash->success('Disconnected successfully.');
                    //return $this->redirect(['action' => 'networking-options']);
                    return $this->redirect($this->referer());

                }else{
                     $this->Flash->error('Could not disconnect. Please, try again.');
                } 

            // If update connection type button is clicked    
            }else if(isset($this->request->data['updateconnection'])){ 

                $connectionTypId =$this->request->data['connection_type_id'];

                if(!empty($connectionTypId)){

                    $BusinessUserNetworksTable = TableRegistry::get('BusinessUserNetworks');
                    $query = $BusinessUserNetworksTable->query();
                    $result = $query->update()
                            ->set(['connection_type_id' => $this->request->data['connection_type_id']])
                            ->where(['user_id' => $UserId,'connected_to'=>$this->request->data['connected_to']])
                            ->execute();
                    if($result){
                        $this->Flash->success('Connection updated successfully.');
                        return $this->redirect($this->referer());

                    }else{
                         $this->Flash->error('Could not update connection. Please, try again.');
                    }
                }else{
                    $this->Flash->error('Please select connection type.');
                }
            
            // Save note button clicked        
            }else{
                if(!empty($this->request->data['description'])){
                    $this->request->data['user_id'] = $UserId;
                    $this->request->data['business_card_id'] = $businessCardId;
                    $this->request->data['title'] = "";
                    $this->request->data['status'] = 1;
                    
                    //pr($this->request->data); die;
                    $businessCardNotes = $businessCardNotesTable->patchEntity($businessCardNotes,$this->request->data);

                    if($businessCardNotesTable->save($businessCardNotes)){
                        $this->Flash->success('The Note has been saved.');
                        //return $this->redirect(['action' => 'networking-options']);
                        return $this->redirect($this->referer());

                    }else{
                         $this->Flash->error('Could not save card note. Please, try again.');
                    } 
                }else{
                    $this->Flash->error('Please add notes description.');
                }    
            }
        }


        $this->set('saveCardNote',$businessCardNotes);   
    }


    /**  
    *    Business Card List Method
    *
    *
    ***/
    public function businessCardList(){
        $user = $this->Auth->user();  
        $UserId = $this->request->Session()->read('Auth.User.id');
        $businessCardsTable = TableRegistry::get('businessCards');
        $this->paginate = [ 'limit' => 10];

        if($user){
           $businessCardResults = $businessCardsTable->find('all',['conditions' => ['
                user_id' => $UserId]])->order(['id DESC']);
            //pr($businessCardResults); die;
        }
        $this->set('businessCardResults',$this->paginate($businessCardResults));    
    }  



    /**
    * Owner Business Cards DetailMethod 
    *
    */
    public function editBusinessCard($id=null){

        $this->loadModel('businessCards');
        $businessCardsTable = TableRegistry::get('businessCards');

        $LoggedUserId = $this->request->Session()->read('Auth.User.id');
        $UserId = $this->request->Session()->read('Auth.User.id');
        $this->set('user_id',$UserId); 
        
        $businessCardId = base64_decode($id);
        $validCardId = $businessCardsTable->exists(['id'=>$businessCardId]);

        $businessUserConnTable = TableRegistry::get('BusinessUserConnectionTypes');
        $businessConnectionData = $businessUserConnTable->find('all',['conditions'=>['user_id'=>$UserId]])->toArray();

        if($validCardId){
            $businessCardDetail= $businessCardsTable->find('all',['conditions'=>['businessCards.id'=>$businessCardId]])->contain(['Users'])->first();
             
            //pr($businessCardDetail);
            $this->set('businessCardDetail', $businessCardDetail);
            
        }

        $businessCard = $businessCardsTable->newEntity();
        if($this->request->is('post')){
            $uploadImgError='';
            $uploadimgName='';
            $flag=0; 
            
            if(!empty($this->request->data['image']['name'])){
             
                $data = [];
                $data = $this->request->data['image']; 
                $uploadImg = $this->Multiupload->uploadImg($data);

                if(empty($uploadImg['errors'])){
                    $uploadimgName=$uploadImg['imgArray'][0]['name'];
                }else{
                    $flag=1;
                    $uploadImgError=$uploadImg['errors'];
                }
            }else{
                    $uploadimgName = $this->request->data['old_image'];

            }

            if(!empty($flag)){

                if(!empty($uploadImgError)){
                    $this->Flash->error($uploadImgError);
                }
            }
            
            $this->request->data['image']=$uploadimgName;
            $this->request->data['user_id']=$UserId;
            //pr($this->request->data); die;

            $businessCard = $businessCardsTable->patchEntity($businessCard,$this->request->data);
            $businessCard->id=$businessCardId;
            if($businessCardsTable->save($businessCard)){
                return $this->redirect(['action' =>'businessCardList']);

            }else{
                 $this->Flash->error('Could not business card. Please, try again.');
            } 
        }
        $this->set('businessCard',$businessCard); 

    }

     /**
     * delete business card  
     *
     * @return delete business card   
     */

    public function deleteBusinessCard($cardID=null){
        $this->viewBuilder()->layout(false);
        $this->render(false);

        $user = $this->Auth->user();  
        $UserId = $this->request->Session()->read('Auth.User.id');

        if($user){
            $businessCardsTable = $this->loadModel('businessCards');
            $businessCardId = base64_decode($cardID);
                
            $entity = $this->businessCards->get($businessCardId);
                
            if($this->businessCards->delete($entity)){
                
                return $this->redirect(['action' => 'businessCardList']);   
            }             
        }    
    }   


    /**
    * Add Business Card Method 
    *
    */
    public function addBusinessCard(){
        $this->loadModel('BusinessTempContacts');
        $businessCardsTable = TableRegistry::get('businessCards');
        $this->loadModel('businessCards');
        $user = $this->Auth->user(); 

        if($user){
            $user_id = $this->request->Session()->read('Auth.User.id');
            $this->set('user_id',$user_id); 
            $businessCard = $businessCardsTable->newEntity(); 

            if($this->request->is('post'))
            {

                $uploadImgError='';
                $uploadimgName='';
                $flag=0;

                if(!empty($this->request->data['image']['name'])){
             
                    $data = [];
                    $data = $this->request->data['image']; 
                    $uploadImg = $this->Multiupload->uploadImg($data);

                    if(empty($uploadImg['errors'])){
                        $uploadimgName=$uploadImg['imgArray'][0]['name'];
                    }else{
                        $flag=1;
                        $uploadImgError=$uploadImg['errors'];
                    }
                }
                
                if(!empty($flag)){

                    if(!empty($uploadImgError)){
                        $this->Flash->error($uploadImgError);
                    }

                }else{

                    $this->request->data['image']=$uploadimgName;
                    $this->request->data['user_id']=$user_id;
                    $this->request->data['status']=0;
                    
                    $businessCard = $businessCardsTable->patchEntity($businessCard,$this->request->data);

                    if($businessCardsTable->save($businessCard)){
                        $this->Flash->success('The business card has been saved.');
                        return $this->redirect(['action' =>'businessCardList']);

                    }else{
                         $this->Flash->error('Could not business card. Please, try again.');
                    } 
                }
            }   
            $this->set('businessCard',$businessCard); 
        }
    }


    /**
     * Active Business Card method
     *
     *
     **/
    public function activeBusinessCard($cardId=null)
    {
        $businessCardsTable = TableRegistry::get('businessCards');
        $this->loadModel('BusinessCards');
        $user = $this->Auth->user(); 

        if($user)
        {

            $cardId = base64_decode($cardId);
            $user_id = $this->request->Session()->read('Auth.User.id'); 

            $res= $this->BusinessCards->query()
                      ->update()
                      ->set(['status' => 1])
                      ->where(['id' => $cardId,'user_id' => $user_id])
                      ->execute();

            $update= $this->BusinessCards->query()
                      ->update()
                      ->set(['status' => 0])
                      ->where(['id !=' => $cardId,'user_id' => $user_id])
                      ->execute();

            //pr($res); die;        
            if($res){
                return $this->redirect(['action' =>'businessCardList']);
            }
        }                   
    }   


    /**  
    *    Business Card notes List Method
    *
    *
    ***/
    public function businessCardNoteList(){
        $user = $this->Auth->user();  
        $UserId = $this->request->Session()->read('Auth.User.id');
        $this->loadModel('BusinessCardNotes');
        $this->loadModel('BusinessUserNetworks');
        $this->loadModel('Users');
        $BusinessCardNotesTable = TableRegistry::get('BusinessCardNotes');
        $this->paginate = [ 'limit' => 10];

        if($user){
           $businessCardNotes = $BusinessCardNotesTable->find('all',['conditions' => ['
                user_id' => $UserId]])->order(['id DESC']);
        }

        $this->set('businessCardNotes',$this->paginate($businessCardNotes));    
    }  


    /**
    * View Business Cards Method 
    *
    */
    public function businessCardNoteEdit($id=null){

        $this->loadModel('businessCards');
        $businessCardNotesTable = TableRegistry::get('BusinessCardNotes');
        $businessCardsTable = TableRegistry::get('businessCards');

        $LoggedUserId = $this->request->Session()->read('Auth.User.id');
        $UserId = $this->request->Session()->read('Auth.User.id');

        $this->set('LoggedUserId',$LoggedUserId);

        //$connectionTypeId = base64_decode($connectionTypeId);

        $businessCardNoteId = base64_decode($id);
        $validNoteId = $businessCardNotesTable->exists(['id'=>$businessCardNoteId]);

        if($validNoteId){
            $businessNoteDetail= $businessCardNotesTable->find('all',['conditions'=>['BusinessCardNotes.id'=>$businessCardNoteId]])->contain(['Users'])->first();
             
            //pr($businessNoteDetail); die;
            $this->set('businessNoteDetail', $businessNoteDetail);

            //pr($businessNoteDetail['business_card_id']); die;
            if($businessNoteDetail){
                $businessCardDetail= $businessCardsTable->find('all',['conditions'=>['businessCards.id'=>$businessNoteDetail['business_card_id']]])->contain(['Users'])->first();

                //pr($businessCardDetail); die;
                $this->set('businessCardDetail', $businessCardDetail);


                $this->loadModel('BusinessUserNetworks');
                $businessNetworkData= $this->BusinessUserNetworks->find('all',['conditions'=>['business_card_id'=>$businessCardDetail['id'],'user_id'=>$UserId]])->first();

                $connectionTypeId = $businessNetworkData['connection_type_id'];

                $businessUserConnTable = TableRegistry::get('BusinessUserConnectionTypes');
                $businessConnectionData = $businessUserConnTable->find('all',['conditions'=>['user_id'=>$UserId]])->first();

                
                $totralC = count($businessConnectionData);
                $finalArray = [];
                if(!empty($businessConnectionData)){

                    $result = json_decode($businessConnectionData->data,True);
                    $i = 0;
                    foreach ($result as $key => $value) 
                    {   $i++;
                        $finalArray[$i]=$value['name'];
                    }
/*echo '<pre>';                    
print_r($businessConnectionData);     die;  */
                }else{ 

                    $businessConnectionTable = TableRegistry::get('BusinessConnectionTypes');
                    $result = $businessConnectionTable->find('list')->toArray();
                    $finalArray =$result;
                } 
                /*if(!empty($businessConnectionData)){

                    $result = json_decode($businessConnectionData[0]->data);
                    
                    foreach ($result as $conn) {
                        
                        if($conn->id == $connectionTypeId)
                        { 
                            @$finalArray = $conn->name;
                            
                        }
                    }

                    
                }else{ 

                    $businessConnectionTable = TableRegistry::get('BusinessConnectionTypes');
                    @$finalArray = $businessConnectionTable->find('all')->toArray();

                    foreach ($finalArray as $conn){
                        if($conn['id'] == $connectionTypeId){
                            
                            @$finalArray = $conn['name'];
                        }
                    }   
                }*/ 
                
                $this->set('businessConnection',@$finalArray); 
            }
            
        }

        $businessCardNotesTable = TableRegistry::get('BusinessCardNotes');
        $businessCardNotes = $businessCardNotesTable->newEntity(); 
        
        if($this->request->is('post')){  

            if(isset($this->request->data['connect'])){

                $BusinessUserNetworksTable = TableRegistry::get('BusinessUserNetworks');
                $BusinessUserNetwork = $BusinessUserNetworksTable->newEntity();

                $connectionTypId =$this->request->data['connection_type_id'];

                if(!empty($connectionTypId)){
                    $this->request->data['user_id'] = $UserId;
                    $this->request->data['connected_to'] =$this->request->data['connected_to'];
                    $this->request->data['connection_type_id'] =$connectionTypId;
                    $this->request->data['business_card_id'] = $businessCardDetail['id'];

                    $BusinessUserNetwork = $BusinessUserNetworksTable->patchEntity($BusinessUserNetwork,$this->request->data);

                    if($BusinessUserNetworksTable->save($BusinessUserNetwork)){
                        $this->Flash->success('Connected Successfully.');
                        return $this->redirect($this->referer());

                    }else{
                         $this->Flash->error('Could not connect. Please, try again.');
                    }
                }else{
                    $this->Flash->error('Please select connection type.');
                }

            }else{    

                $this->request->data['user_id'] = $UserId;
                $this->request->data['business_card_id'] = $businessCardDetail['id'];
                $this->request->data['title'] = "";
                $this->request->data['status'] = 0;
                
                //pr($this->request->data); die;
                $businessCardNotes = $businessCardNotesTable->patchEntity($businessCardNotes,$this->request->data);
                $businessCardNotes->id=$businessCardNoteId;

                if($businessCardNotesTable->save($businessCardNotes)){
                    $this->Flash->success('The Note has been saved.');
                    return $this->redirect(['action' => 'businessCardNoteList']);

                }else{
                     $this->Flash->error('Could not save card note. Please, try again.');
                } 
            }

        }
        $this->set('saveCardNote',$businessCardNotes);   
    }


    /**
    * Business Connections
    *
    */
    public function businessConnections(){
        $user = $this->Auth->user();  
        $UserId = $this->request->Session()->read('Auth.User.id'); 
        //$UserId = "301"; 

        $businessUserConnTable = TableRegistry::get('BusinessUserConnectionTypes');
        $businessConnectionData = $businessUserConnTable->find('all',['conditions'=>['user_id'=>$UserId]])->toArray();

        
        if(!empty($businessConnectionData)){

            $result = json_decode($businessConnectionData[0]->data);
            $result = json_decode(json_encode($result), True);
            
            
        }else{ 

            $businessConnectionTable = TableRegistry::get('BusinessConnectionTypes');
            $result = $businessConnectionTable->find('all')->toArray();

        }  
        //
        $this->set('businessConnection',$result);

        $businessUserConnection = $businessUserConnTable->newEntity();
        if($this->request->is('post')){

            $id = $this->request->data['id'];
            $name = $this->request->data['name'];
            $description = $this->request->data['description'];
            $result = array_map(function ($id, $name, $description) {
                          return array_combine(
                            ['id', 'name', 'description'],
                            [$id, $name, $description]
                          );
                        }, $id, $name, $description);

            //pr($result); die;
            $data = json_encode($result, JSON_PRETTY_PRINT); 

            //pr($businessConnectionData); die;
            if(empty($businessConnectionData)){

                $this->request->data['data'] = $data;
                $this->request->data['user_id'] = $UserId;


                $businessUserConnection = $businessUserConnTable->patchEntity($businessUserConnection,$this->request->data);
                if($businessUserConnTable->save($businessUserConnection)){

                    $this->Flash->success('The Groups has been saved.');
                    return $this->redirect(['action' => 'businessConnections']);
                    
                }else{
                    $this->Flash->error('Could not groups. Please, try again.');
                }

            }else{

                $this->request->data['data'] = $data;
                $this->request->data['user_id'] = $UserId;

               // echo "else";pr($this->request->data); die;
                $businessUserConnection = $businessUserConnTable->patchEntity($businessUserConnection,$this->request->data);
                $businessUserConnection->id= $businessConnectionData[0]->id;

                if($businessUserConnTable->save($businessUserConnection)){

                    return $this->redirect(['action' => 'businessConnections']);
                    $this->Flash->success('The Groups has been updated Successfully.');
                    
                    
                }else{
                    $this->Flash->error('Could not groups. Please, try again.');
                }
            }    

        }
        $this->set('businessUserConnection',$businessUserConnection);
        
    }



    /**
    * Linked in Login 
    *
    */
    public function auth(){

        $config['base_url']             =  "http://$_SERVER[HTTP_HOST]/networking-options/auth";
        $config['callback_url']         =  "http://$_SERVER[HTTP_HOST]/networking-options/socialConnect";
        $config['linkedin_access']      =   '81e3d823pozynm';
        $config['linkedin_secret']      =   'TZ2PSU8CshUunR5X';

        
        $linkedin = new LinkedIn($config['linkedin_access'], $config['linkedin_secret'], $config['callback_url'] );

        //$linkedin->debug = true;
        
        # Now we retrieve a request token. It will be set as $linkedin->request_token
        $linkedin->getRequestToken(); 

        $_SESSION['requestToken'] = serialize($linkedin->request_token);
      
        # With a request token in hand, we can generate an authorization URL, which we'll direct the user to
        $this->redirect($linkedin->generateAuthorizeUrl());
        
    }

    public function socialConnect(){
        $config['base_url']             =  "http://$_SERVER[HTTP_HOST]/networking-options/auth";
        $config['callback_url']         =  "http://$_SERVER[HTTP_HOST]/networking-options/socialConnect";
        $config['linkedin_access']      =   '81e3d823pozynm';
        $config['linkedin_secret']      =   'TZ2PSU8CshUunR5X';
        
        # First step is to initialize with your consumer key and secret. We'll use an out-of-band oauth_callback
        $linkedin = new LinkedIn($config['linkedin_access'], $config['linkedin_secret'], $config['callback_url'] );
        //$linkedin->debug = true;

       if (isset($_REQUEST['oauth_verifier'])){
            $_SESSION['oauth_verifier']     = $_REQUEST['oauth_verifier'];

            $linkedin->request_token    =   unserialize($_SESSION['requestToken']);
            $linkedin->oauth_verifier   =   $_SESSION['oauth_verifier'];
            $linkedin->getAccessToken($_REQUEST['oauth_verifier']);

            $_SESSION['oauth_access_token'] = serialize($linkedin->access_token);
            header("Location: " . $config['callback_url']);
            exit;
       }
       else{
            $linkedin->request_token    =   unserialize($_SESSION['requestToken']);
            $linkedin->oauth_verifier   =   $_SESSION['oauth_verifier'];
            $linkedin->access_token     =   unserialize($_SESSION['oauth_access_token']);
       }


        # You now have a $linkedin->access_token and can make calls on behalf of the current member
       
        $xml_response = $linkedin->getProfile("~:(id,first-name,last-name,picture-url,public-profile-url)");

        $xml = simplexml_load_string($xml_response);
        $json = json_encode($xml);
        $array = json_decode($json,TRUE);
        $this->set('linkedin',$array); 
        
        $this->loadModel('BusinessTempContacts');
        $businessCardsTable = TableRegistry::get('businessCards');
        $this->loadModel('businessCards');
        $user = $this->Auth->user(); 

        if($user){
            $user_id = $this->request->Session()->read('Auth.User.id');
            $this->set('user_id',$user_id); 
            $businessCard = $businessCardsTable->newEntity(); 

            if($this->request->is('post'))
            {

                $uploadImgError='';
                $uploadimgName='';
                $flag=0;

                if(!empty($this->request->data['image']['name'])){
             
                    $data = [];
                    $data = $this->request->data['image']; 
                    $uploadImg = $this->Multiupload->uploadImg($data);

                    if(empty($uploadImg['errors'])){
                        $uploadimgName=$uploadImg['imgArray'][0]['name'];
                    }else{
                        $flag=1;
                        $uploadImgError=$uploadImg['errors'];
                    }
                }
                
                if(!empty($flag)){

                    if(!empty($uploadImgError)){
                        $this->Flash->error($uploadImgError);
                    }

                }else{

                    $this->request->data['image']=$uploadimgName;
                    $this->request->data['user_id']=$user_id;
                    $this->request->data['status']=0;

                    $businessCard = $businessCardsTable->patchEntity($businessCard,$this->request->data);

                    if($businessCardsTable->save($businessCard)){
                        $this->Flash->success('The business card has been saved.');
                        return $this->redirect(['action' =>'businessCardList']);

                    }else{
                         $this->Flash->error('Could not business card. Please, try again.');
                    } 
                }
            }   
            $this->set('businessCard',$businessCard); 
        }
    }
    

    /**
    * Temp User List
    *
    */
    public function newUsers()
    {
        $this->paginate = [ 'limit' => 10];

        $this->loadModel('BusinessTempContacts');

        $user_id = $this->request->Session()->read('Auth.User.id');

        $this->set('loggedInUserId',$user_id);

        $query = $this->BusinessTempContacts->find('all')->where(['BusinessTempContacts.created_by' => $user_id])->order(['id DESC']);

        $this->paginate($query);

        $this->set('users',$query);
    }


    public function delete($id = null)
    {
        $id = base64_decode($id);
        $this->loadModel('BusinessTempContacts');
        
        $this->request->allowMethod(['post', 'delete']);
        $campaign = $this->BusinessTempContacts->get($id);
        if ($this->BusinessTempContacts->delete($campaign)) {
            $this->Flash->success('Contact has been deleted.');
        } else {
            $this->Flash->error('Contact could not be deleted. Please, try again.');
        }
        return $this->redirect(['action' => 'newUsers']);
    }

    /**
    * launchDeals Method
    *
    */
    public function launchDeals()
    {
        
    }

}
?>