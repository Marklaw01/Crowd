<?php
namespace App\Model\Table;

use App\Model\Entity\StartupRoadmap;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class StartupRoadmapsTable extends Table
{
    public function initialize(array $config)
    {
    	 parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('startup_roadmaps');
         $this->primaryKey('id');

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);
        $this->belongsTo('Startups', [
            'foreignKey' => 'startup_id'
        ]);
        $this->belongsTo('Roadmaps', [
            'foreignKey' => 'current_roadmap'
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
            ->requirePresence('file_path')
            ->notEmpty('file_path','Please select doc or file.');

      $validator
            ->requirePresence('preffered_startup_stage')
            ->notEmpty('preffered_startup_stage','Preffered Startup stage can not be left empty.');
            /*->add('preffered_startup_stage', [
                'maxLength' => [
                    'rule' => ['maxLength', 50],
                    'message' => 'This field can not be too long.',
                ]
            ])
            ->add('preffered_startup_stage','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9. ]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Preffered Startup stage has invalid characters.!',
            ]);*/
 
       $validator
            ->requirePresence('current_roadmap')
            ->notEmpty('current_roadmap','Please select Current Roadmap.');

        $validator
            ->requirePresence('complete')
            ->notEmpty('complete','Please select Completed status.');    

        $validator
            ->requirePresence('next_step')
            ->notEmpty('next_step','Please select Next Step.');    
           

        return $validator;
    }

   

}

?>