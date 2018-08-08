<?php
namespace App\Model\Table;

use App\Model\Entity\Message;
use Cake\ORM\Query;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class MessagesTable extends Table
{
     public function initialize(array $config)
    {
    	 parent::initialize($config);
        $this->addBehavior('Timestamp');

        $this->belongsTo('Users', [
            'foreignKey' => 'sender_id'
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
            ->requirePresence('subject')
            ->notEmpty('subject','Subject can not be left blank.')
            ->add('name', [
                'maxLength' => [
                    'rule' => ['maxLength', 50],
                    'message' => 'This field can not be more then 50 characters.',
                ]
            ]);
            /*->add('name','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9. ]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Name has invalid characters.!',
            ]);*/

            $validator
            ->requirePresence('comment')
            ->notEmpty('comment');
            /*->add('comment','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-\'\" ]+$/", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Message has invalid characters.',
            ]);*/

            return $validator;

    }

}




?>