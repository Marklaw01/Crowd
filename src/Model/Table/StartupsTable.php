<?php
namespace App\Model\Table;

use App\Model\Entity\Startup;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class StartupsTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('startups');
         $this->primaryKey('id');

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);

        $this->belongsTo('EntrepreneurBasics', [
            'foreignKey' => 'user_id'
        ]);
        $this->belongsTo('ContractorRoles', [
            'foreignKey' => 'contractor_role_id'
        ]);

        $this->belongsTo('Keywords', [
            'foreignKey' => 'keywords'
        ]);

        $this->hasMany('StartupWorkOrders', [
            'className' => 'StartupWorkOrders',
            'foreignKey' => 'startup_id'
        ]);

        $this->hasMany('StartupTeams', [
            'className' => 'StartupTeams',
            'foreignKey' => 'startup_id'
        ]);

        $this->hasMany('StartupRoadmaps', [
            'className' => 'StartupRoadmaps',
            'foreignKey' => 'startup_id'
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
            ->requirePresence('name')
            ->notEmpty('name','This field can not be left empty.');
            /*->add('name', [
                'maxLength' => [
                    'rule' => ['maxLength', 30],
                    'message' => 'This field can not be too long.',
                ]
            ])
            ->add('name','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%&*()._\/-:;,\-\' ]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Name has invalid characters.!',
            ]);*/

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
            ]); */   

        $validator
            ->requirePresence('keywords')
            ->notEmpty('keywords','Please select keywords.');

        $validator
            ->requirePresence('support_required')
            ->notEmpty('support_required')
              ->add('support_required', [
                'minLength' => [
                    'rule' => ['minLength', 3],
                    'message' => 'This field have to be atleast 3 characters.'
                ],
                'maxLength' => [
                    'rule' => ['maxLength', 50],
                    'message' => 'This field can not be too long.',
                ]
            ]);
            /*->add('support_required','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^~&*()||.+=_\/-:,;?\-<>\'\"\\\\ ]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Support Required has invalid characters.',
            ]);*/

        
        
        return $validator;
    }

   
}

?>