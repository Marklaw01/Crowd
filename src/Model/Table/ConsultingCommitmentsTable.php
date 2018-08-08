<?php
namespace App\Model\Table;

//use App\Model\Entity\Job;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;


class ConsultingCommitmentsTable extends Table
{
    public function initialize(array $config)
    { 
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('consulting_commitments');
        $this->displayField('id');
        $this->primaryKey('id');


        $this->belongsTo('Users', [
            'foreignKey' => 'user_id',
            'joinType' => 'INNER'
        ]);
        
        
		
    }

    /**
     * Default validation rules.
     *
     *
     */
    public function validationDefault(Validator $validator)
    {
             

            $validator
                ->requirePresence('document', 'create')
                ->notEmpty('document','Please upload document.');

            return $validator;

    }            
    
}
?>
