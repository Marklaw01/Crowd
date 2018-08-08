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

class CampaignsController extends AppController
{
   
    
    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('Campaigns');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $Campaigns = $this->Campaigns->find('all')->contain(['Users'=>['EntrepreneurBasics']])->order(['Campaigns.id' => 'DESC']);;
            //pr($Startups->toArray()); die;
            $this->set('Campaigns', $this->paginate($Campaigns));

    }

    /**
    *  add method for users
    *
    *
    *
    ****/
    function add()
    {
                $this->loadModel('Campaigns');
                $user = $this->Auth->user();    
                $Campaigns = $this->Campaigns->newEntity();

                if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('Post')){

                        $Campaigns = $this->Campaigns->patchEntity($Campaigns,$this->request->data); 
                        $Campaigns->user_id = $UserId;
                        
                        
                        if($result = $this->Campaigns->save($Campaigns)){
                            
                                $this->Flash->success('The campaign has been saved.');
                                return $this->redirect(['action' => 'index']);
                        }
                    }    

                }

                $this->set('Campaigns',$Campaigns);    

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
            $this->loadModel('Campaigns');
            
            $user = $this->Auth->user(); 
            $Campaigns = $this->Campaigns->get($rId);
            if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('put')){

                        $Campaigns = $this->Campaigns->patchEntity($Campaigns,$this->request->data); 
                        $Campaigns->user_id = $UserId;
                        $Campaigns->id=$Campaigns->id;
                        
                        if($result = $this->Campaigns->save($Campaigns)){
                            
                                $this->Flash->success('The Campaign has been saved.');
                                return $this->redirect(['action' => 'index']);
                        }
                    }    

                }

                $this->set('Campaigns',$Campaigns);
            

    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    function view($id=null)
    {       
            $id = base64_decode($id);
            $userId = $this->Auth->user('id');
            $campaign = $this->Campaigns->get($id, [
                'contain' => ['Users', 'Startups', 'CampaignDonations', 'CampaignFollowers', 'CampaignRecommendations']
            ]);

            //set campaign followed or not
            $exists = $this->Campaigns->campaignFollowers->exists(['campaign_id' => $id, 'user_id'=>$userId]);
            $this->set('campaignFollow', $exists);
            //$campaignDon = $this->Campaigns->CampaignDonations->exists(['user_id'=>$userId,'campaign_id'=>$id]);
           
            $Keywords = $this->Campaigns->CampaignTargetKeywords->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $this->loadModel('KeywordCampaigns');
            $campKeywords = $this->KeywordCampaigns->find('list')->toArray();
            $this->set('campKeywords',$campKeywords);

            //Get 
            $donContractor = $this->Campaigns->CampaignDonations->find('all',['conditions' => ['CampaignDonations.campaign_id' => $id]])->contain(['Campaigns','DonationTimeperiods','Users'])->toArray();
            $this->set('donContractors', $donContractor);


            $this->set('campaign', $campaign);
            $this->set('userId', $userId);
            $this->set('_serialize', ['campaign']);
            

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
