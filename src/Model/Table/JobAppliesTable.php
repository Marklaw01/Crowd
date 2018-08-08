<?php
namespace App\Model\Table;

//use App\Model\Entity\Job;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;


class JobAppliesTable extends Table
{
    public function initialize(array $config)
    { 
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('job_applies');
        $this->displayField('id');
        $this->primaryKey('id');
        
        $this->belongsTo('Jobs', [
            'foreignKey' => 'job_id'
        ]);
		
        $this->belongsTo('JobExperiences', [
            'foreignKey' => 'job_experience_id'
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
                ->requirePresence('summary', 'create')
                ->notEmpty('summary','Summary can not be left blank.');
                /*->add('summary','custom',[
                    'rule' => function($value){ //pr($value);die;
                                if ($value) {
                                    if (!preg_match("/^[a-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-<>\'\" ]+$/i", $value)) {
                                        return false;
                                    }
                                }
                        return true;
                    },
                    'message'=>'Summary has invalid characters!',
                ]);*/  

            $validator
                ->requirePresence('name', 'create')
                ->notEmpty('name','Name can not be left blank.');
                /*->add('name','custom',[
                    'rule' => function($value){ //pr($value);die;
                                if ($value) {
                                    if (!preg_match("/^[a-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-<>\'\" ]+$/i", $value)) {
                                        return false;
                                    }
                                }
                        return true;
                    },
                    'message'=>'Name has invalid characters!',
            ]);*/

            $validator
                ->requirePresence('job_experience_id', 'create')
                ->notEmpty('job_experience_id','Please add experience.'); 

            /*$validator
                ->requirePresence('resume', 'create')
                ->notEmpty('resume','Please upload resume.'); */ 
 

            return $validator;
    }
    
}
?>
