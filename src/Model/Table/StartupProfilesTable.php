<?php
namespace App\Model\Table;

use App\Model\Entity\StartupProfile;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class StartupProfilesTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');
         
         $this->table('startup_profiles');
         $this->displayField('id');
         $this->primaryKey('id');

         $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
          ]);

         $this->belongsTo('Startups', [
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
            ->requirePresence('file_path')
            ->notEmpty('file_path','Please select document file.');

        $validator
            ->requirePresence('file_name')
            ->notEmpty('file_name','File name can not be left blank.')
            ->add('file_name', [
                
                'maxLength' => [
                    'rule' => ['maxLength', 30],
                    'message' => 'File name must be less than 30 characters!',
                ]
            ]);
            /*->add('file_name','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-\'\" ]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'File name has invalid characters.!',
            ]);;*/

        return $validator;






    }
}