<?php
namespace App\Model\Table;

use App\Model\Entity\UserNotification;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class UserNotificationsTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('user_notifications');
         $this->primaryKey('id');
        
    }
    
   
}

?>