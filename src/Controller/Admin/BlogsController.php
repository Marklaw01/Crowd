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

class BlogsController extends AppController
{
   
    
    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function index()
    {
            $this->loadModel('BlogPosts');
            $UserId = $this->request->Session()->read('Auth.User.id');
            $this->paginate = [ 'limit' => 20];

            $BlogPosts = $this->BlogPosts->find('all',['conditions'=>['BlogPosts.posted_to_cbs'=>1,'BlogPosts.status'=>'publish'],'order'=>['BlogPosts.id DESC']]);

            //pr($Startups->toArray()); die;
            $this->set('BlogPosts', $this->paginate($BlogPosts));

    }

    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function blogSetting()
    {  

        $user = $this->Auth->user();    
        
        $this->loadModel('BlogSettings');
        $blogSetting = $this->BlogSettings->newEntity();

        $settingList = $this->BlogSettings->find('all',['conditions'=>['BlogSettings.status'=>1],['order'=>['BlogSettings.id DESC'],'limit'=>1]])->toArray();

        if(!empty($settingList)){
            $this->set('limit_per_day', $settingList[0]->limit_per_day);
        }else{
            $this->set('limit_per_day', '');
        }


        if($user){

            if($this->request->is('Post')){

                if (ctype_digit($this->request->data['limit_per_day'])) 
                {   
                    $id= $settingList[0]->id;

                    //echo "Yes"; 
                    $blogSetting = $this->BlogSettings->patchEntity($blogSetting,$this->request->data); 
                    $blogSetting->id = $id;
                    if($result = $this->BlogSettings->save($blogSetting)){
                        
                            $this->Flash->success('Blog settings has been saved.');
                            return $this->redirect($this->referer());
                    }
                } else { 
                    $this->Flash->success('Please enter numeric value only.'); 
                }

                
            }    

        }
        $this->set('blogSetting', $blogSetting);
    }

    /**
    *  index method for get list of all users
    *
    *
    *
    ****/
    function delete($id = null)
    {  
        $id = base64_decode($id);
        $user = $this->Auth->user();    
        
        $this->loadModel('BlogPosts');
        $this->request->allowMethod(['post', 'delete']);
        if($user){

            $query = $this->BlogPosts->query();
            $qr= $query->update()
                    ->set(['status' => 'hide'])
                    ->where(['id' => $id]);
            $rslt = $qr->execute();

            if($rslt){

                $this->Flash->success('Blog has been deleted successfuly.');
                return $this->redirect($this->referer());

            } else { 

                $this->Flash->success('Could not delete blog.'); 
            }

        }
    }


} 


?>
