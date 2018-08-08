<?php
namespace App\Model\Table;

use App\Model\Entity\StartupListEntrepreneurProfile;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class StartupListEntrepreneurProfilesTable extends Table
{
    public function initialize(array $config)
    {
    	 parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('startup_list_entrepreneur_profiles');
         $this->primaryKey('id');

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);

        $this->belongsTo('EntrepreneurBasics', [
            'foreignKey' => 'entrepreneur_id'
        ]);

        $this->belongsTo('Keywords', [
            'foreignKey' => 'keywords'
        ]);


        $this->hasMany('StartupTeams', [
            'className' => 'StartupTeams',
            'foreignKey' => 'startup_id'
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
       
        
        return $validator;
    }
}

?>