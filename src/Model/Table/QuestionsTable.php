<?php
namespace App\Model\Table;

use App\Model\Entity\Question;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class QuestionsTable extends Table
{
    public function initialize(array $config)
    {
    	 parent::initialize($config);
         $this->addBehavior('Timestamp');

       
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
            ->requirePresence('name')
            ->notEmpty('name','Name cant not be left empty.');
            /*->add('name','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9!@#$%&*()?:._\/-:;,\-\' ]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Name has invalid characters.',
            ]);*/

        
        
        return $validator;
    }
}

?>