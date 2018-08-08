<?php
namespace App\Model\Table;

use App\Model\Entity\Forum;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class ForumsTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('forums');
         $this->primaryKey('id');

        $this->belongsTo('Startups', [
            'foreignKey' => 'startup_id'
        ]);

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);

        $this->belongsTo('Keywords', [
            'foreignKey' => 'keywords'
        ]);

        
        $this->hasMany('ForumComments', [
            'foreignKey' => 'forum_id'
        ]);

        $this->hasMany('ForumReports', [
            'foreignKey' => 'forum_id'
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
            ->requirePresence('title')
            ->notEmpty('title');
            /*->add('title','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^&*() ~ ™ ® £ © € ¥.+=_\/-:,;?\-\'\" ]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Title has invalid characters.!',
            ]);*/
        $validator
            ->requirePresence('keywords')
            ->notEmpty('keywords','Please select keywords.');

        $validator
            ->requirePresence('description')
            ->notEmpty('description');
            /*->add('description','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^~&*()|| ~ ™ ® £ © € ¥.+=_\/-:,;?\-<>\'\"\\\\ ]+$/", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Description has invalid characters.',
            ]);*/    
        
        
        return $validator;
    }

   
}

?>
