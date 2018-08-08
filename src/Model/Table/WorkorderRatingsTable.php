<?php
namespace App\Model\Table;

use App\Model\Entity\WorkorderRating;
use Cake\ORM\Query;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class WorkorderRatingsTable extends Table
{
     public function initialize(array $config)
    {
    	 parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('workorder_ratings');
         $this->primaryKey('id');

        $this->belongsTo('Users', [
            'foreignKey' => 'given_by'
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
            ->requirePresence('work_comment')
            ->notEmpty('work_comment','Comment can not be left blank.')
            ->add('work_comment','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-\'\" ]+$/", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Comment has invalid characters.',
            ]);
  

     	return $validator;
    }
}




?>