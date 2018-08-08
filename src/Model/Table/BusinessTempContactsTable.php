<?php
namespace App\Model\Table;

use App\Model\Entity\BusinessCard;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class BusinessTempContactsTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('business_temp_contacts');
         $this->primaryKey('id');

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
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
            ->requirePresence('name', 'create')
            ->notEmpty('name','This field can not be left empty.');
        
        $validator
            ->requirePresence('phone', 'create')
            ->notEmpty('phone','This field can not be left empty.');
        
        $validator
            ->requirePresence('email', 'create')
            ->notEmpty('email','This field can not be left empty.');
           
        return $validator;
    }

   
}

?>