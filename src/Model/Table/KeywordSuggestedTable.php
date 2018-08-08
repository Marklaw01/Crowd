<?php
namespace App\Model\Table;

use App\Model\Entity\KeywordSuggested;
use Cake\ORM\Query;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class KeywordSuggestedTable extends Table
{
     public function initialize(array $config)
    {
    	 parent::initialize($config);
        $this->addBehavior('Timestamp');

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);

        $this->belongsTo('KeywordTypes', [
            'foreignKey' => 'type'
        ]);
    }


    public function validationDefault(Validator $validator)
    {
     	$validator
            ->requirePresence('type')
            ->notEmpty('type','Select keyword type.')
            ->add('type','custom',[
                'rule' => function($value){ //pr($value);die;
                            if (empty($value)) {
                                return false;
                            }
                    return true;
                },
                'message'=>'Select keyword type.',
            ]);

        $validator
            ->requirePresence('name')
            ->notEmpty('name')
            ->add('name','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%*().+=_\/-:,;?\-\'\" ]+$/", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Keyword name has invalid characters.',
            ]);

            return $validator;

    }

}




?>