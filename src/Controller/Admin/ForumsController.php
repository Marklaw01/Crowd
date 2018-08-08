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

class ForumsController extends AppController
{
   
    
    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('Forums');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $Forums = $this->Forums->find('all')->contain(['Users'=>['EntrepreneurBasics']])->order(['Forums.id' => 'DESC']);;
            //pr($Startups->toArray()); die;
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
                $this->loadModel('Roadmaps');
                $user = $this->Auth->user();    
                $roadmap = $this->Roadmaps->newEntity();

                if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('Post')){

                        $roadmap = $this->Roadmaps->patchEntity($roadmap,$this->request->data); 
                        $roadmap->user_id = $UserId;
                        
                        
                        if($result = $this->Roadmaps->save($roadmap)){
                            
                                $this->Flash->success('The roadmap has been saved.');
                                return $this->redirect(['action' => 'index']);
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
            $this->loadModel('Roadmaps');
            
            $user = $this->Auth->user(); 
            $roadmap = $this->Roadmaps->get($rId);
            if($user){
                    $UserId = $this->request->Session()->read('Auth.User.id');

                    if($this->request->is('put')){

                        $roadmap = $this->Roadmaps->patchEntity($roadmap,$this->request->data); 
                        $roadmap->user_id = $UserId;
                        $roadmap->id=$roadmap->id;
                        
                        if($result = $this->Roadmaps->save($roadmap)){
                            
                                $this->Flash->success('The roadmap has been saved.');
                                return $this->redirect(['action' => 'index']);
                        }
                    }    

                }

                $this->set('roadmap',$roadmap);
            

    }

    /**
    *  view method for users
    *
    *
    *
    ****/
    public function view($id=null,$allComm=null)
    {
         $formId = base64_decode($id);
         $this->set('formId',$formId);
         $this->paginate = ['limit' => 5];

         $this->loadModel('ForumComments');

         $forumDetails = $this->Forums->find('all',['conditions'=>['Forums.id'=>$formId,'Forums.status'=>1]])->contain(['ForumComments'])->first();
         $forumOwnerId= $forumDetails->user_id;
         $forumName= $forumDetails->title;

         /*$Keywords = $this->Forums->Keywords->find('list')->toArray();
         $this->set('Keywords',$Keywords);*/ 

         $this->loadModel('KeywordForums');
         $Keywords = $this->KeywordForums->find('list')->toArray();
         $this->set('Keywords',$Keywords);

        
        //Get comments list related to forum
        $allforumComments= $this->Forums->ForumComments->find('all',['conditions'=>['ForumComments.forum_id'=>$formId],'order'=>['ForumComments.id ASC']]);
        $this->set('allForumComments', $allforumComments);
        
        $this->set('commentcount', $allforumComments->count());
        //Get latest comments list related to forum
        $forumComments= $this->Forums->ForumComments->find('all',['conditions'=>['ForumComments.forum_id'=>$formId],'limit' => 5, 'order'=>['ForumComments.id DESC']]);

        $forumComments = array_reverse($forumComments->toArray());
        
        $this->set('forumComments', $forumComments);

         $UserId = $this->request->Session()->read('Auth.User.id');
         $this->set('UserId', $UserId);

        if(!empty($forumDetails)){
            $this->set('forumDetails', $forumDetails);
        }else{
            return $this->redirect(['action' => 'startupForum']);
        }

        $commentForm= $this->ForumComments->newEntity(); 
            if ($this->request->is(['patch', 'post', 'put'])) {
                $this->request->data['user_id']=$UserId;
                $this->request->data['forum_id']=$formId;

                $commentForm = $this->ForumComments->patchEntity($commentForm,$this->request->data); 

                        if ($this->ForumComments->save($commentForm)) {

                               //Save user notification
                               $values = ['forum_id'=>$formId,
                                         'forum_name'=>$forumName];
                               //,json_encode($values);
                                $link= Router::url(['controller' => 'Forums', 'action' => 'viewForum',$id]);
                                $this->WebNotification->sendNotification($UserId,$forumOwnerId,'Comment_Forum','has commented on your Forum <strong> '.$forumName.'.</strong>',$link,$values);

                                     $this->Flash->success('Comment has been posted successfully.'); 
                                     return $this->redirect($this->referer()); 

          
                        }else {
                                $this->Flash->error('Unable to post your Comment.Please try again.');
                        }
            }
        $this->set('commentForm', $commentForm); 
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
