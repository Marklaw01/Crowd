<?php
/**
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link      http://cakephp.org CakePHP(tm) Project
 * @since     0.2.9
 * @license   http://www.opensource.org/licenses/mit-license.php MIT License
 */
namespace App\Controller;

use Cake\Controller\Controller;
use Cake\Event\Event;
use Cake\View\ViewBuilder;

/**
 * Application Controller
 *
 * Add your application-wide methods in the class below, your controllers
 * will inherit them.
 *
 * @link http://book.cakephp.org/3.0/en/controllers.html#the-app-controller
 */
class AppController extends Controller
{

    /**
     * Initialization hook method.
     *
     * Use this method to add common initialization code like loading components.
     *
     * e.g. `$this->loadComponent('Security');`
     *
     * @return void
     */
    public function initialize()
    {
        parent::initialize();

        $this->loadComponent('RequestHandler');
        $this->loadComponent('Flash');
        $this->loadComponent('UserImageWeb');
        $this->loadComponent('WebNotification');
        $this->loadComponent('Auth', [
            'authenticate' => [
                    'Form' => ['fields' => [
                    'username' => 'email',
                    'password' => 'password'
                    ]
                ]
            ],
                'loginAction' => [
                'controller' => 'Users',
                'action' => 'login'
                ]
            ]);


        // Check is user admin or not
         //$user = $this->Auth->user();
        //$this->Auth->allow(['display']);

          $roleId = $this->Auth->user('role_id');
          if(isset($this->request->params['prefix']) && $this->request->params['prefix'] == 'admin'){  
            
            if($roleId == 2){
                return $this->redirect('/contractors/index');               
            }elseif($roleId == 3){
                return $this->redirect('/SubAdmins/dashboard'); 
            }
            $this->viewBuilder()->layout('admin_default');
            
          }else{
             
              if($roleId == 1){
                return $this->redirect('/admin');   
              }
              
          }

    }
    

    /**
     * Before render callback.
     *
     * @param \Cake\Event\Event $event The beforeRender event.
     * @return void
     */
    public function beforeRender(Event $event)
    {
        /*if (!array_key_exists('_serialize', $this->viewVars) &&
            in_array($this->response->type(), ['application/json', 'application/xml'])
        ) {
            $this->set('_serialize', true);
        }*/
 

        $userId = $this->Auth->user('id');
        $this->set('looginUserId', $userId);
        //Set Contractor Image
        $contImage = $this->UserImageWeb->contractorImage($userId);
        $this->set('contractorImage',$contImage);

        $contNam = $this->WebNotification->contractorName($userId);
        $this->set('contNam',$contNam);
        
        
         //Set Entrepreneurr Image
        $entrprImage = $this->UserImageWeb->entrepreneurImage($userId);
        if(empty($entrprImage)){
            $entrprImage=$contImage;
        }
        $this->set('entrepreneurImage',$entrprImage);

        //Set user profile status
        $userProfileStatus = $this->UserImageWeb->getUserProfileStatus($userId);
        if(empty($userProfileStatus)){
            $userProfileStatus=$userProfileStatus;
        }else {
            $userProfileStatus=0;
        }
        $this->set('userProfileStatus',$userProfileStatus);


    }

    public function isAuthorized($user)
    {
        // Admin can access every action
        if (isset($user['role']) && $user['role'] === 'admin') {
            return true;
        }

        // Default deny
        return false;
    }
    // Blobal function to get campaign follower
    public function getNotifications(){
        $this->viewBuilder()->layout(false);
        $this->render(false);
        $this->paginate = [ 'limit' => 10];
        $this->loadModel('userNotifications');
        $loginUserId  = $this->request->data['loginUserId'];

        $notifications = $this->userNotifications->find('all',['conditions'=>['userNotifications.receiver_id'=>$loginUserId],'order'=>['userNotifications.id DESC']]);

        $totalCount = $this->userNotifications->find('all',['conditions'=>['userNotifications.receiver_id'=>$loginUserId],'order'=>['userNotifications.id DESC']])->toArray();
        $ccv= count($totalCount);
        $this->set('totalCount',$ccv);

        $this->set('notifications',$this->paginate($notifications));
        $this->render('/Element/Front/notifications');
        
    }
    public function getNotificationsCount(){
        $this->viewBuilder()->layout(false);
        $this->render(false);
        $this->loadModel('userNotifications');
        $loginUserId  = $this->request->data['loginUserId'];

        $notificationsCount = $this->userNotifications->find('all',['conditions'=>['userNotifications.receiver_id'=>$loginUserId,'userNotifications.seen'=>0]])->toArray();
        echo $count=count($notificationsCount);

       $this->set('notificationsCount',$count);

    }    

    public function updateNotifications(){

            $this->viewBuilder()->layout(false);
            $this->render(false);
            $this->loadModel('userNotifications');
            $loginUserId  = $this->request->data['loginUserId'];
            $readStatus  = $this->request->data['readStatus'];

                            $query = $this->userNotifications->query();
                            if($readStatus == 'no'){
                                $query->update()
                                  ->set(['seen'=>1
                                         ])
                                  ->where(['receiver_id' => $loginUserId])
                                  ->execute();
                            }else{
                                $query->update()
                                  ->set(['read'=>1
                                         ])
                                  ->where(['receiver_id' => $loginUserId])
                                  ->execute();
                            }
                            

    }

   
}
