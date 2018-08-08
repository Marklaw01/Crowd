<?php
namespace App\Model\Table;

use App\Model\Entity\ForumReport;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class ForumReportsTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('forum_reports');
         $this->primaryKey('id');

         $this->belongsTo('Forums', [
            'foreignKey' => 'forum_id'
         ]);

         $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
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
                'message'=>'Comment has invalid characters.',
            ]); */   
        
        
        return $validator;
    }

   
}

?>
