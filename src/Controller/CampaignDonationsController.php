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
use Cake\I18n\Number;

/** 
 * Campaigns Controller
 *
 * @property \App\Model\Table\CampaignDonationssTable $Campaigns
 */
class CampaignDonationsController extends AppController
{

 public $helpers = ['Custom'];

 public function initialize()
 {
    parent::initialize();
        //$this->loadHelper('Custom');
    $this->loadComponent('WebNotification');
    $this->loadComponent('Feeds');
}

    /**
     * View method
     *
     */



    public function index()
    {
        if ($this->Auth->user()) {
            $this->redirect(['action' => 'Commitment']);
        }

    }

    /**
     * Commitments method
     *
     */

    public function Commitment()
    {
        $this->paginate = [ 'limit' => 10,
        'contain' => ['Campaigns']
        ];
        $userId = $this->Auth->user('id');

        //$commitments = $this->CampaignDonations->find('all',['conditions' => ['CampaignDonations.user_id' => $userId]])->contain(['Campaigns','DonationTimeperiods']);
        //$current_date_time = date('Y-m-d H:i:s');
        $current_date_time =date('Y-m-d H:i:s', strtotime(' -1 day'));
        //$commitments = $this->CampaignDonations->find('all',['conditions' => ['CampaignDonations.user_id' => $userId]])->contain(['Campaigns'=>['conditions'=>['Campaigns.comp_due_date >='=>$current_date_time]],'DonationTimeperiods']);
        
        $commitments = $this->CampaignDonations->find('all',['conditions' => ['CampaignDonations.user_id' => $userId]])->contain(['Campaigns','DonationTimeperiods']);

        //pr($commitments);
        $this->set('commitments', $this->paginate($commitments));
        $this->set('_serialize', ['commitments']);

    }
    /**
     * View method
     *
     * @param string|null $id Campaign id.
     * @return void
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function view($id = null)
    {
        $id = base64_decode($id);
        $campaign = $this->Campaigns->get($id, [
            'contain' => ['Users', 'Startups', 'CampaignDonations', 'CampaignFollowers', 'CampaignRecommendations']
            ]);
        $this->set('campaign', $campaign);
        $this->set('_serialize', ['campaign']);
    }

    /**
     * Add method
     *
     * @return void Redirects on successful add, renders view otherwise.
     */
    public function add($id = null)
    {
        $cId=base64_decode($id);
        $userId = $this->Auth->user('id');
        //$exists = $this->CampaignDonations->Campaigns->exists(['id' => $cId,'NOT'=>['user_id'=>2]]);
        $UserId = $this->request->Session()->read('Auth.User.id');  
        $campaign = $this->CampaignDonations->Campaigns->get($cId,[
            'conditions' => ['NOT' =>['Campaigns.user_id' => $userId]]], [
            'contain' => []
            ]);
        $campOwnerId =$campaign->user_id; 
        $campName =$campaign->campaigns_name; 
        // Compre donated and target amount
        $targetAmount= $campaign->target_amount; 
        $DonatedAmount = $this->loadModel('CampaignDonations'); 
        $DonatedAmount = $DonatedAmount->find('all',['conditions' => ['campaign_id' => $cId]]);
        $TotalDonatedAmount= $DonatedAmount->sumOf('amount');

        $DonatedAmountLeft=$targetAmount-$TotalDonatedAmount;
        $targetAcived=0;
        if($DonatedAmountLeft>0){
            $targetAcived=1;
        }
        $this->set('targetAcived',$targetAcived);

        //Get timeperiods list
        $this->loadModel('DonationTimeperiods');
        $timeperiods = $this->DonationTimeperiods->find('all')->toArray();
        $this->set('timeperiods',$timeperiods);
        $donation = $this->CampaignDonations->newEntity();

        $date = date('Y-m-d');
        if ($this->request->is(['patch', 'post', 'put'])) {

            $donation->user_id=$userId;
            $donation->campaign_id=$cId;


            /// Get Donation time period type to count end date for time period
            $timeP= $this->request->data['time_period'];
            $timePeriod = $this->CampaignDonations->DonationTimeperiods->get($timeP);
            $donationTime=$timePeriod->timeperiod;
            $timeType=$timePeriod->type;
            if($timeType=='Days'){
              $timePeriodEnd=  date('Y-m-d', strtotime('+'.$donationTime.'day', strtotime($date)));
          }else if($timeType=='Weeks'){
             $timePeriodEnd=  date('Y-m-d', strtotime('+'.$donationTime.'week', strtotime($date)));
         }else if($timeType=='Months'){
             $timePeriodEnd=  date('Y-m-d', strtotime('+'.$donationTime.'month', strtotime($date)));
            }else { // else Years
             $timePeriodEnd=  date('Y-m-d', strtotime('+'.$donationTime.'year', strtotime($date)));
         }
            //$timeDa=date_format($timePeriodEnd,"F, d, Y");
         $donation->time_period_start=date('F, d, Y');
         $donation->time_period_end=$timePeriodEnd;

         $actualAmoutForma= $this->request->data['amount'];
         $amount= $this->request->data['amount']; 
         $amount= str_replace("$","",$amount);
         $amount= str_replace(",","",$amount);
         $this->request->data['amount']=$amount;

         if($DonatedAmountLeft>=$amount){

             $donation = $this->CampaignDonations->patchEntity($donation, $this->request->data);
             $result = $this->CampaignDonations->save($donation);
                    //pr($result); die;
             if ($result) {

                $this->loadModel('Campaigns');
                $query = $this->Campaigns->query();
                $epr = 'fund_raised_so_far = fund_raised_so_far + '.$this->request->data['amount'];
                $query->update()
                          ->set(
                                $query->newExpr($epr)
                                )
                          ->where([
                                   'id' => $cId])
                          ->execute();

                //Save user notification
                $values = ['campaign_id'=>$cId,
                           'campaign_name'=>$campName];
                //,json_encode($values);

                $link= Router::url(['controller' => 'Campaigns', 'action' => 'edit',$id]);
                $this->WebNotification->sendNotification($UserId,$campOwnerId,'Commit_Campaign',' has committed '.$actualAmoutForma.' to your campaign<strong> '.$campName.'</strong>',$link,$values);

                //Save Feeds
                $this->Feeds->saveCampaignFeeds($userId,'feeds_campaign_commited',$cId);


                $this->Flash->success('Committed successfully.');
                $this->redirect(['controller' => 'campaigns','action' => 'view',base64_encode($cId)]);

            }else{
                $this->Flash->error('Couldnt commit, Please, try again.');

            }
        }else{
            if($DonatedAmountLeft>0){
                $this->Flash->error('You can not commit donation more than $'.number_format($DonatedAmountLeft,2));
            }else {
                $this->Flash->error('You can not make donation for this Campaign as target amount has been achieved');
            }
        }        
    }   

    $this->set(compact('donation','cId','campaign'));
    $this->set('_serialize', ['donation']);


}

    /**
     * Edit method
     *
     * @param string|null $id Campaign id.
     * @return void Redirects on successful edit, renders view otherwise.
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function edit($id = null)
    {  
        $dId=base64_decode($id);
        $userId = $this->Auth->user('id');
        $donations = $this->CampaignDonations->get($dId, ['contain' => ['Campaigns']]);
        //pr($donations);
        $this->loadModel('DonationTimeperiods');
        $timeperiods = $this->DonationTimeperiods->find('all')->toArray();
        $this->set('timeperiods',$timeperiods);

        if ($this->request->is(['patch', 'post', 'put'])) {
           // $this->request->data['amount']=$donations->amount;

            $amount= $donations->amount; 
            $amount= str_replace("$","",$amount);
            $amount= str_replace(",","",$amount);
            $this->request->data['amount']=$amount;

            $this->request->data['time_period']=$donations->time_period;
            $donations = $this->CampaignDonations->patchEntity($donations, $this->request->data);
            $result = $this->CampaignDonations->save($donations);
            if ($result) {
                $this->Flash->success('Updated successfully.');
                $this->redirect(['controller' => 'campaigns','action' => 'view',base64_encode($donations->campaign_id)]);
            }else{
                $this->Flash->success('Couldnt update, Please, try again.');
            }

        }    
        $this->set(compact('donations'));
        $this->set('_serialize', ['donations']);
    }

    /**
     * Edit method
     *
     *
     **/
    public function donatingContractor($id = null)
    {
        $cId=base64_decode($id);
        $this->set('campId', $id);
        $this->paginate = [
        'contain' => ['Campaigns','Users']
        ];
        $userId = $this->Auth->user('id');

        //$exists = $this->CampaignDonations->Campaigns->exists(['id' => $cId,'NOT'=>['user_id'=>2]]);

        $donContractor = $this->CampaignDonations->find('all',['conditions' => ['CampaignDonations.campaign_id' => $cId]])->contain(['Campaigns','DonationTimeperiods','Users']);

        //pr($donContractor);
        //$donContractor = $this->CampaignDonations->find('all',['conditions' => ['CampaignDonations.campaign_id' => $cId]])->toArray();

        $this->set('donContractor', $this->paginate($donContractor));
        $this->set('_serialize', ['donContractor']);

    }
    /**
     * Edit method
     *
     *
     **/
    public function uncommit($id = null,$Cid = null)
    {
             $dId = base64_decode($id);
             $cId = base64_decode($Cid);
             $UserId = $this->request->Session()->read('Auth.User.id');  

             $this->viewBuilder()->layout(false);
             $this->render(false);
             $CampaignDonations = $this->CampaignDonations->get($dId);
             $amount=$CampaignDonations->amount;

             $campaign = $this->CampaignDonations->Campaigns->get($cId,[
                'conditions' => ['NOT' =>['Campaigns.user_id' => $UserId]]], [
                'contain' => []
                ]);
             $campOwnerId =$campaign->user_id; 
             $campName =$campaign->campaigns_name; 

             // pr($CampaignDonations);
             if ($this->CampaignDonations->delete($CampaignDonations)) {

                $this->loadModel('Campaigns');
                $fun_so_far = $this->Campaigns->find('all',['conditions'=>['Campaigns.id'=>$cId]])
                                    ->select(['fund_raised_so_far'])
                                    ->first();
                    
                    $fund_raised_so_far = $fun_so_far['fund_raised_so_far'];
                    
                    
                    $final_raised = $fund_raised_so_far - $amount;
                    
                    $query = $this->Campaigns->query();

                    $query->update()
                            ->set(['fund_raised_so_far'=>$final_raised
                                   ])
                            ->where(['id' => $cId])
                            ->execute();

                //Save user notification
                //Save user notification
                $values = ['campaign_id'=>$cId,
                           'campaign_name'=>$campName];
                //,json_encode($values);

                $link= Router::url(['controller' => 'Campaigns', 'action' => 'edit',$Cid]);
                $this->WebNotification->sendNotification($UserId,$campOwnerId,'Uncommit_Campaign','has uncommitted from your campaign <strong> '.$campName.'.</strong>',$link,$values);

                $this->Flash->success('Uncommitted successfully.');  


            } else {
                $this->Flash->error('Please, try again.');
            }
            return $this->redirect(['controller'=>'campaigns', 'action' => 'view',$Cid]);

    }
}
