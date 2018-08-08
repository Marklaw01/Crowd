<?php
namespace App\Model\Table;

use App\Model\Entity\BusinessCard;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class BusinessCardsTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('business_cards');
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
            ->requirePresence('user_bio', 'create')
            ->notEmpty('user_bio','This field can not be left empty.');
        
        $validator
            ->requirePresence('user_interest', 'create')
            ->notEmpty('user_interest','This field can not be left empty.');
        
           
        return $validator;
    }

   
}

?>