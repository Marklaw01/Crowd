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

class TicketsController extends AppController
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
           
            $this->loadModel('ForumReports');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $Forums = $this->ForumReports->find('all')->contain(['Forums'=>['Users'],'Users'])->group('forum_id')->order(['ForumReports.id' => 'DESC']);

            //pr($Forums->toArray()); die;
            $this->set('Forums', $this->paginate($Forums));  

    }

    /**
    *  add method for users
    *
    *
    *
    ****/
    function add()
    {
                    

    }



    /**
    *  edit method for users
    *
    *
    *
    ****/
    function edit($id=null)
    {
            
            

    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    function view($id=null)
    {       
            
            $formReportId = base64_decode($id);
            $this->set('formReportId',$formReportId);

            $this->loadModel('Forums');
            $this->loadModel('ForumComments');
            $this->loadModel('ForumReports');

            $this->loadModel('KeywordForums');
            $Keywords = $this->KeywordForums->find('list')->toArray();
            $this->set('Keywords',$Keywords);

            $ForumReports = $this->ForumReports->get($formReportId);
            $this->set('OneForumReports',$ForumReports);

            $forumDetails = $this->Forums->find('all',['conditions'=>['Forums.id'=>$ForumReports->forum_id]])->contain(['ForumComments'])->first();
            $this->set('forumDetails',$forumDetails);

            //Get reported Comments
            $ForumReportDetails = $this->ForumReports->find('all',['conditions'=>['ForumReports.forum_id'=>$ForumReports->forum_id]])->contain('Users');
            $this->set('ForumReportDetails',$ForumReportDetails);

            //Get comments list related to forum
            $allforumComments= $this->Forums->ForumComments->find('all',['conditions'=>['ForumComments.forum_id'=>$ForumReports->forum_id],'order'=>['ForumComments.id ASC']]);
            $this->set('allForumComments', $allforumComments);
            
            $this->set('commentcount', $allforumComments->count());
            //Get latest comments list related to forum
            $forumComments= $this->Forums->ForumComments->find('all',['conditions'=>['ForumComments.forum_id'=>$ForumReports->forum_id],'limit' => 5, 'order'=>['ForumComments.id DESC']]);

            $forumComments = array_reverse($forumComments->toArray());
            
            $this->set('forumComments', $forumComments);


    }

    /**
     * 
     *
     *
     */
    public function blockuser($id = null,$userId = null)
    {
        $id = base64_decode($id);
        $userId = base64_decode($userId); 
        $this->loadModel('ForumUserBlocklists');
        $this->request->allowMethod(['post', 'delete']);

        $roadmap = $this->ForumUserBlocklists->newEntity();

        $this->request->data['forum_id']=$id;
        $this->request->data['user_id']=$userId;

        $roadmap = $this->ForumUserBlocklists->patchEntity($roadmap,$this->request->data); 
                            
        if ($this->ForumUserBlocklists->save($roadmap)) {
            $this->Flash->success('The user has been blocked successfully.');
        } else {
            $this->Flash->error('The user could not be blocked. Please, try again.');
        }
        return $this->redirect($this->referer());
    }

    /**
     * 
     *
     *
     */
    public function unblockuser($id = null,$userId = null)
    {
        $id = base64_decode($id);
        $userId = base64_decode($userId); 
        $this->loadModel('ForumUserBlocklists');
        $this->request->allowMethod(['post', 'delete']);
        $roadmap = $this->ForumUserBlocklists->find('all',['conditions'=>['forum_id'=>$id,'user_id'=>$userId]])->first(); 

        $campaign = $this->ForumUserBlocklists->get($roadmap->id);

        if ($this->ForumUserBlocklists->delete($campaign)) {
            $this->Flash->success('The user has been unblocked successfully.');
        } else {
            $this->Flash->error('The user could not be unblocked. Please, try again.');
        }
        return $this->redirect($this->referer());
    }

    /**
     * 
     *
     *
     */
    public function resolve($id = null)
    {
        $id = base64_decode($id);

        $this->loadModel('ForumReports');
        $this->request->allowMethod(['post', 'delete']);

        $query = $this->ForumReports->query();

        $result= $query->update()
            ->set(['status'=>1])
            ->where(['forum_id' => $id])
            ->execute();
        if ($result) {
            $this->Flash->success('The forum updated successfully.');
        } else {
            $this->Flash->error('The forum could not be updated. Please, try again.');
        }
        return $this->redirect($this->referer());    
    }

    /**
     * 
     *
     *
     */
    public function close($id = null)
    {
        $id = base64_decode($id);

        $this->loadModel('Forums');
        $this->request->allowMethod(['post', 'delete']);

        $query = $this->Forums->query();

        $result= $query->update()
            ->set(['user_status'=>2])
            ->where(['id' => $id])
            ->execute();
        if ($result) {
            $this->Flash->success('The forum closed successfully.');
        } else {
            $this->Flash->error('The forum could not be closed. Please, try again.');
        }
        return $this->redirect($this->referer());    
    }

    /**
     * 
     *
     *
     */
    public function delete($id = null)
    {
        $id = base64_decode($id);
        $this->loadModel('Forums');
        $this->request->allowMethod(['post', 'delete']);
        $campaign = $this->Forums->get($id);
        if ($this->Forums->delete($campaign)) {
            $this->Flash->success('The Forum has been deleted.');
        } else {
            $this->Flash->error('The Forum could not be deleted. Please, try again.');
        }
        return $this->redirect(['action' => 'index']);
    }


     /**
     * 
     *
     *
     */
    public function deletecomment($id = null)
    {
        $id = base64_decode($id);
        $this->loadModel('ForumComments');
        $this->request->allowMethod(['post', 'deletecomment']);
        $campaign = $this->ForumComments->get($id);
        if ($this->ForumComments->delete($campaign)) {
            $this->Flash->success('The comment has been deleted.');
        } else {
            $this->Flash->error('The comment could not be deleted. Please, try again.');
        }
        return $this->redirect($this->referer());
    }


} 


?>
