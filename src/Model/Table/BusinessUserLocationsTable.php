<?php
namespace App\Model\Table;

use App\Model\Entity\BusinessUserLocation;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class BusinessUserLocationsTable extends Table
{
    public function initialize(array $config)
    {
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('business_user_locations');
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
            ->requirePresence('latitude', 'create')
            ->notEmpty('latitude','This field can not be left empty.');
        
        $validator
            ->requirePresence('longitude', 'create')
            ->notEmpty('longitude','This field can not be left empty.');
        
        $validator
            ->requirePresence('status', 'create')
            ->notEmpty('status','This field can not be left empty.');
           
        return $validator;
    }

   
}

?>