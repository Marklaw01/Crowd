<?php
namespace App\Model\Table;

//use App\Model\Entity\Job;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;


class ConsultingInvitationsTable extends Table
{
    public function initialize(array $config)
    { 
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('consulting_invitations');
        $this->displayField('id');
        $this->primaryKey('id');

        $this->belongsTo('ByUser', [ 
            'className' => 'Users', 
            'foreignKey' => 'sent_by',
            'joinType' => 'INNER'
        ]);

        $this->belongsTo('ToUser', [ 
           'className' => 'Users',                      
           'foreignKey' => 'sent_to',
            'joinType' => 'INNER'
        ]);

        $this->belongsTo('Consultings', [
            'foreignKey' => 'consulting_id',
            'joinType' => 'INNER'
        ]);
        
    }

    
}
?>
