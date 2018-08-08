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

/**
 * Notes Controller
 *
 * @property \App\Model\Table\NotesTable $Notes
 */
class NotesController extends AppController
{

    /**
     * Index method
     *
     * @return void
     */
    public function index()
    {
        $UserId = $this->request->Session()->read('Auth.User.id');
        $this->paginate = [ 'limit' => 10,'order' => ['Notes.id' => 'desc']];

        $notes = $this->Notes->find('all', ['conditions' => ['Notes.user_id' => $UserId]])->contain(['Startups']);
       /* echo '<pre>';
        print_r($notes->toArray()); die;*/
        $this->set('notes', $this->paginate($notes));
        $this->set('_serialize', ['notes']);
    }

    /**
     * View method
     *
     * @param string|null $id Note id.
     * @return void
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function view($id = null)
    {
        $id = base64_decode($id);
        $UserId = $this->request->Session()->read('Auth.User.id');
        $note = $this->Notes->get($id,['conditions' => ['Notes.user_id' => $UserId]], ['contain' => ['Users', 'Startups']]);

        $startups = $this->Notes->Startups->find('list',['conditions' => ['Startups.user_id' => $UserId]]);
        $this->set('startups',$startups);
        
        $this->set('note', $note);
        $this->set('_serialize', ['note']);
    }

    /**
     * Add method
     *
     * @return void Redirects on successful add, renders view otherwise.
     */
    public function add()
    {
        $UserId = $this->request->Session()->read('Auth.User.id');

        $note = $this->Notes->newEntity();

        if ($this->request->is('post')) {
            $this->request->data['user_id']=$UserId;
            $note = $this->Notes->patchEntity($note, $this->request->data);
            if ($this->Notes->save($note)) {
                $this->Flash->success(__('The note has been saved.'));
                return $this->redirect(['action' => 'index']);
            } else {
                $this->Flash->error(__('The note could not be saved. Please, try again.'));
            }
        }

        //$users = $this->Notes->Users->find('list', ['limit' => 200]);
        $users =$UserId;

        //$startups = $this->Notes->Startups->find('list',['conditions' => ['Startups.user_id' => $UserId]]);

        /*$connection = ConnectionManager::get('default');
        $qq = "SELECT SU.name as SNAME,SU.id as SID FROM startups as SU where SU.user_id=$UserId
        UNION
        SELECT SU.name as SNAME, ST.startup_id as SID FROM startup_teams as ST inner join startups as SU on ST.startup_id=SU.id  where ST.user_id=$UserId";
                                
        $sql = $connection->execute ($qq);
        $startups = $sql->fetchAll('assoc');*/

        $this->loadModel('Startups');
        $startups= $this->Startups->find('all')->toArray();
        
        $this->set(compact('note', 'users', 'startups'));
        $this->set('_serialize', ['note']);

        //$this->loadModel('StartupTeams');
        //echo '<pre>';
        //print_r($startups); die;
    }

    /**
     * Edit method
     *
     * @param string|null $id Note id.
     * @return void Redirects on successful edit, renders view otherwise.
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function edit($id = null)
    { 
        $id = base64_decode($id);

        $UserId = $this->request->Session()->read('Auth.User.id');

        $note = $this->Notes->get($id, ['conditions' => ['Notes.user_id' => $UserId]],['contain' => []]);

        if ($this->request->is(['patch', 'post', 'put'])) {

            $this->request->data['user_id']=$UserId;
            $note = $this->Notes->patchEntity($note, $this->request->data);
            $note->id=$id;

            if ($this->Notes->save($note)) {
                $this->Flash->success('The note has been saved.');
                return $this->redirect(['action' => 'index']);
            } else {
                $this->Flash->error('The note could not be saved. Please, try again.');
            }
        }


        //$startups = $this->Notes->Startups->find('list',['conditions' => ['Startups.user_id' => $UserId]]);
        /*$connection = ConnectionManager::get('default');
        $qq = "SELECT SU.name as SNAME,SU.id as SID FROM startups as SU where SU.user_id=$UserId
        UNION
        SELECT SU.name as SNAME, ST.startup_id as SID FROM startup_teams as ST inner join startups as SU on ST.startup_id=SU.id  where ST.user_id=$UserId";
                                
        $sql = $connection->execute ($qq);
        $startups = $sql->fetchAll('assoc');*/
        
        $this->loadModel('Startups');
        $startups= $this->Startups->find('all')->toArray();
        
        $this->set(compact('note', 'users', 'startups'));
        $this->set('_serialize', ['note']);
    }

    /**
     * Delete method
     *
     * @param string|null $id Note id.
     * @return \Cake\Network\Response|null Redirects to index.
     * @throws \Cake\Network\Exception\NotFoundException When record not found.
     */
    public function delete($id = null)
    {   
        $id = base64_decode($id);
        $this->request->allowMethod(['post', 'delete']);
        $note = $this->Notes->get($id);
        if ($this->Notes->delete($note)) {
            $this->Flash->success('The note has been deleted.');
        } else {
            $this->Flash->error('The note could not be deleted. Please, try again.');
        }
        return $this->redirect(['action' => 'index']);
    }
}
