<?php
namespace App\Model\Table;

use App\Model\Entity\ForumComment;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class ForumCommentsTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('forum_comments');
         $this->primaryKey('id');

        
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
            ->requirePresence('comment')
            ->notEmpty('comment','Comment can not be left blank.');
            /*->add('comment','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-\'\" ]+$/", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Comment has invalid characters.',
            ]);*/    
        
        
        return $validator;
    }

   
}

?>
