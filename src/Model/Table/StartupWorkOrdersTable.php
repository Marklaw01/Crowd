<?php
namespace App\Model\Table;

use App\Model\Entity\StartupWorkOrder;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class StartupWorkOrdersTable extends Table
{
    public function initialize(array $config)
    {
    	 parent::initialize($config);
         $this->addBehavior('Timestamp');
         
         $this->table('startup_work_orders');
         $this->displayField('id');
         $this->primaryKey('id');

          $this->belongsTo('Startups', [
            'foreignKey' => 'startup_id'
          ]);
          
          $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
          ]);

          $this->belongsTo('Roadmaps', [
            'foreignKey' => 'roadmap_id'
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
            ->requirePresence('roadmap_id')
            ->notEmpty('roadmap_id','Please select roadmap.');

        $validator
            ->requirePresence('work_date')
            ->notEmpty('work_date','Please select keywords.');   

        $validator
            ->requirePresence('work_units')
            ->notEmpty('work_units')
            ->add('work_units','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[0-9]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Work unit has invalid characters.!',
            ]);

       return $validator;
    }


}

?>