<?php
namespace App\Model\Table;

use App\Model\Entity\BusinessCUserNetwork;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class BusinessUserNetworksTable extends Table
{
    public function initialize(array $config)
    {
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('business_user_networks');
        $this->primaryKey('id');

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);

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
            ->requirePresence('connected_to', 'create')
            ->notEmpty('connected_to','This field can not be left empty.');
        $validator
            ->requirePresence('connection_type_id', 'create')
            ->notEmpty('connection_type_id','This field can not be left empty.');
        $validator
            ->requirePresence('business_card_id', 'create')
            ->notEmpty('business_card_id','This field can not be left empty.');
        
           
        return $validator;
    }

   
}

?>