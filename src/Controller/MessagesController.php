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
class MessagesController extends AppController{

    public function initialize()
    {
    parent::initialize();
    $this->loadComponent('Upload');
    $this->loadComponent('Contractor');
    $this->loadComponent('UserImageWeb');
    }


   /**
    * archiveMessageList Method for list messages
    *
    *
    */
    public function groups()
    {

    }

    /**
    * index Method for list messages
    *
    *
    */

    public function index()
    {
            $this->paginate = [ 'limit' => 10];

            $user = $this->Auth->user();    
            $UserId = $this->request->Session()->read('Auth.User.id');
            if($user){  

                $MessagesDetails = $this->Messages->find('all',['conditions'=>['Messages.receiver_id'=> $UserId,'Messages.archived '=>0,'Messages.msg_type'=>'team'], 'order'=>['Messages.id DESC']])->contain(['Users'=>['EntrepreneurBasics']]);

                $this->set('MessagesDetails', $this->paginate($MessagesDetails));  
            }
    }

  
    /**
    * deleteMessage Method for list messages
    *
    *
    */
    public function deleteMessage($id = null)
    {
        $MsgId = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $Messages = $this->Messages->get($MsgId);
        if ($Messages) {
            $query = $this->Messages->query();
            $query->update()
                  ->set(['archived'=>2])
                  ->where(['id' => $MsgId])
                  ->execute();

            $this->Flash->success(__('Message has been deleted successfully.'));
        } else {
            $this->Flash->error(__('Message could not be deleted. Please, try again.'));
        }
        return $this->redirect(['action' => 'index']);
    }

    /**
    * archiveMessage Method for list messages
    *
    *
    */

    public function archiveMessage($id = null)
    {
        $MsgId = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $Messages = $this->Messages->get($MsgId);
        if ($Messages) {
            $query = $this->Messages->query();
            $query->update()
                  ->set(['archived'=>1])
                  ->where(['id' => $MsgId])
                  ->execute();

            $this->Flash->success(__('Message has been archived successfully.'));
        } else {
            $this->Flash->error(__('Message could not be archived. Please, try again.'));
        }
        return $this->redirect(['action' => 'index']);
    }


    /**
    * archiveMessageList Method for list messages
    *
    *
    */

    public function archiveMessageList()
    {
            $this->paginate = [ 'limit' => 10];

            $user = $this->Auth->user();    
            $UserId = $this->request->Session()->read('Auth.User.id');
                if($user){  

                    $MessagesDetails = $this->Messages->find('all',['conditions'=>['Messages.receiver_id'=> $UserId,'Messages.archived '=>1]])->contain(['Users'=>['EntrepreneurBasics']]);

                    $this->set('MessagesDetails', $this->paginate($MessagesDetails));  
                }
    }


    /**
    *
    *
    *
    *
    **/
    public function notificationList()
    {
        $this->paginate = [ 'limit' => 10];
        $this->loadModel('userNotifications');
        $UserId = $this->request->Session()->read('Auth.User.id');

        $notifications = $this->userNotifications->find('all',['conditions'=>['userNotifications.receiver_id'=>$UserId],'order'=>['userNotifications.id DESC']]);
        $this->set('notifications',$this->paginate($notifications));

        $totalCount = $this->userNotifications->find('all',['conditions'=>['userNotifications.receiver_id'=>$UserId],'order'=>['userNotifications.id DESC']])->toArray();
        $ccv= count($totalCount);
        $this->set('totalCount',$ccv);
    }

    /**
    * chat Method for Basic Profile edit
    *
    *
    */
    public function chat($id=null,$startupId=null)
    {       
            $userQbId = base64_decode($id);
            $stpId = base64_decode($startupId);
            if($userQbId == 'group'){
                $this->set('userQbId', '');
                $this->set('stpId', $stpId);

                $this->loadModel('StartupTeams');
                $startups = $this->StartupTeams->find('all', ['conditions' => ['StartupTeams.startup_id' => $stpId,'StartupTeams.approved !=' => 0, 'OR'=>['StartupTeams.approved !=' => 3]]])->contain(['Users'])->toArray();
                //pr($startups);die;

            }else {
                $this->set('userQbId', $userQbId);
            }
            $this->loadModel('Users');
            $this->loadModel('Quickblox');
            $user = $this->Auth->user();    
            $UserId = $this->request->Session()->read('Auth.User.id'); 
            $user = $this->Users->get($UserId);
            $userPass = $this->Quickblox->find('all',['conditions'=>['Quickblox.user_id'=> $UserId]])->first();

            $this->set('userPass', $userPass);  
            $this->set('user', $user);  

           
            //Get list of the users who are related to logged user
            $UserId = $this->request->Session()->read('Auth.User.id');

            $ForumsTable = $this->loadModel('ForumComments');
            $finalMember = [];
            $user_id = $UserId;
            
            $connection = ConnectionManager::get('default');
               $qq = "SELECT US.quickbloxid as teamMemberQBID , ST.user_id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM startups as SU ,
                    users as US inner join startup_teams as ST on US.id=ST.user_id  where SU.user_id=".$user_id." and ST.startup_id=SU.id
                    
                   UNION
                    
                   SELECT US.quickbloxid as teamMemberQBID , CF.user_id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM campaigns as CA ,
                   campaign_followers as CF inner join users as US on US.id=CF.user_id where CA.user_id=".$user_id." and CF.campaign_id=CA.id
                    
                   UNION
                    
                   SELECT US.quickbloxid as teamMemberQBID , FF.user_id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM forums as FO ,
                   forum_followers as FF inner join users as US on US.id=FF.user_id where FO.user_id=".$user_id." and FF.forum_id=FO.id
                   
                   UNION
                   
                   SELECT US.quickbloxid as teamMemberQBID , US.id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM startup_teams as ST ,
                   users as US inner join startups as SU on US.id=SU.user_id where ST.user_id=".$user_id." and ST.startup_id=SU.id
                    
                    UNION
                    
                    SELECT US.quickbloxid as teamMemberQBID , US.id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM campaign_followers as CF,
                    campaigns as CA inner join users as US on US.id=CA.user_id where CF.user_id=".$user_id." and CF.campaign_id=CA.id
                    
                    UNION
                    
                    SELECT US.quickbloxid as teamMemberQBID , US.id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM  forum_followers as FF,
                    forums as FO  inner join users as US on US.id=FO.user_id where FF.user_id=".$user_id." and FF.forum_id=FO.id";
                  
            $sql = $connection->execute ($qq);
            $members = $sql->fetchAll('assoc');
            
            if(!empty($members)):
                foreach($members as $member):
                    if($member['teamMemberQBID']!=''):
                        $keys['user_id'] = ($member['member_id']!='')?$member['member_id']:' ';
                        $keys['quickbloxid'] = ($member['teamMemberQBID']!='')?$member['teamMemberQBID']:' ';
                        $keys['username'] = ($member['name']!='')?$member['name']:' ';
                        $keys['userimage'] = $this->Contractor->contractorImage($keys['user_id']);
                        
                        $finalMember[] = $keys;
                    endif;
                endforeach;     
            endif;

            $this->set('finalMember', $finalMember);  

    }

    public function quickBloxId(){
        $this->viewBuilder()->layout(false);
        $this->render(false);
        $UserId = $this->request->Session()->read('Auth.User.id');

        $ForumsTable = $this->loadModel('ForumComments');
        $finalMember = [];
        $user_id = $UserId;
        
        $connection = ConnectionManager::get('default');
           $qq = "SELECT US.quickbloxid as teamMemberQBID , ST.user_id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM startups as SU ,
                users as US inner join startup_teams as ST on US.id=ST.user_id  where SU.user_id=".$user_id." and ST.startup_id=SU.id
                
               UNION
                
               SELECT US.quickbloxid as teamMemberQBID , CF.user_id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM campaigns as CA ,
               campaign_followers as CF inner join users as US on US.id=CF.user_id where CA.user_id=".$user_id." and CF.campaign_id=CA.id
                
               UNION
                
               SELECT US.quickbloxid as teamMemberQBID , FF.user_id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM forums as FO ,
               forum_followers as FF inner join users as US on US.id=FF.user_id where FO.user_id=".$user_id." and FF.forum_id=FO.id
               
               UNION
               
               SELECT US.quickbloxid as teamMemberQBID , US.id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM startup_teams as ST ,
               users as US inner join startups as SU on US.id=SU.user_id where ST.user_id=".$user_id." and ST.startup_id=SU.id
                
                UNION
                
                SELECT US.quickbloxid as teamMemberQBID , US.id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM campaign_followers as CF,
                campaigns as CA inner join users as US on US.id=CA.user_id where CF.user_id=".$user_id." and CF.campaign_id=CA.id
                
                UNION
                
                SELECT US.quickbloxid as teamMemberQBID , US.id as member_id, CONCAT(US.first_name , ' ', US.last_name) as name FROM  forum_followers as FF,
                forums as FO  inner join users as US on US.id=FO.user_id where FF.user_id=".$user_id." and FF.forum_id=FO.id";
              
        $sql = $connection->execute ($qq);
        $members = $sql->fetchAll('assoc');
        
        if(!empty($members)):
            foreach($members as $member):
                if($member['teamMemberQBID']!=''):
                    $keys['user_id'] = ($member['member_id']!='')?$member['member_id']:' ';
                    $keys['quickbloxid'] = ($member['teamMemberQBID']!='')?$member['teamMemberQBID']:' ';
                    $keys['username'] = ($member['name']!='')?$member['name']:' ';
                    //$keys['userimage'] = $this->Contractor->contractorImage($keys['user_id']);
                    
                    $finalMember[] = $keys;
                endif;
            endforeach;     
        endif;
             
echo "<pre>";
        print_r($finalMember);

        /*if(!empty($finalMember)):
            
            $result['users'] = $finalMember;
            $result['code'] = 200;
            echo json_encode($result);
            
        else:
            
            $result['users'] = [];
            $result['code'] = 404;
            echo json_encode($result);
            
        endif;*/
        
    }


}
?>