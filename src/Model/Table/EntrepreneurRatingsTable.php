<?php
namespace App\Model\Table;

use App\Model\Entity\EntrepreneurRating;
use Cake\ORM\Query;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class EntrepreneurRatingsTable extends Table
{
     public function initialize(array $config)
    {
    	 parent::initialize($config);
        $this->addBehavior('Timestamp');

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
            ->requirePresence('deliverable')
            ->notEmpty('deliverable','Please select Roadmap.');

        $validator
            ->requirePresence('description')
            ->notEmpty('description','Description can not be left blank.');
            /*->add('description','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-\'\" ]+$/", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Description has invalid characters.',
            ]);*/

        $validator
            ->requirePresence('rating_star')
            ->notEmpty('rating_star','Please give rating stars.')
            ->add('rating_star','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value == 0) {
                                
                                    return false; 
                            
                            }
                    return true;
                },
                'message'=>'Please give rating starts.',
            ]);;   

     	return $validator;
    }

}




?>