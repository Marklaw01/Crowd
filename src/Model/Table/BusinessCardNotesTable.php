<?php
namespace App\Model\Table;

use App\Model\Entity\BusinessCardNote;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class BusinessCardNotesTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('business_card_notes');
         $this->primaryKey('id');

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);

        /*$this->belongsTo('BusinessUserNetworks', [
            'foreignKey' => 'business_card_id'
        ]);*/

        $this->belongsTo('BusinessCards', [
            'foreignKey' => 'business_card_id'
        ]);

    }
     /**
     * Default validation rules.
     *
     * @param \Cake\Validation\Validator $validator Validator instance.
     * @return \Cake\Validation\Validator
     */
    public function validationDefault(Validator $validator)
    {
        $validator
            ->requirePresence('user_id', 'create')
            ->notEmpty('user_id','This field can not be left empty.');
        
        $validator
            ->requirePresence('business_card_id', 'create')
            ->notEmpty('business_card_id','This field can not be left empty.');
        
        /*$validator
            ->requirePresence('description', 'create')
            ->notEmpty('description','This field can not be left empty.');*/
        
           
        return $validator;
    }

   
}

?>