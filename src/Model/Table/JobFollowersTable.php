<?php
namespace App\Model\Table;

//use App\Model\Entity\Job;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;


class JobFollowersTable extends Table
{
    public function initialize(array $config)
    { 
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('job_followers');
        $this->displayField('id');
        $this->primaryKey('id');
        
        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);
    }     
    
}
?>
