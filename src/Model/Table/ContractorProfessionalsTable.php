<?php
namespace App\Model\Table;

use App\Model\Entity\Contractor_Professional;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class ContractorProfessionalsTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');

       $this->belongsTo('PrefferStartups', [
            'foreignKey' => 'startup_stage'
        ]);
        

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);

        $this->belongsTo('Experiences', [
            'foreignKey' => 'experience_id'
        ]);

        $this->belongsTo('Keywords', [
            'foreignKey' => 'keywords'
        ]);

        $this->belongsTo('Qualifications', [
            'foreignKey' => 'qualifications'
        ]);

        $this->belongsTo('Certifications', [
            'foreignKey' => 'certifications'
        ]);

        $this->belongsTo('Skills', [
            'foreignKey' => 'skills'
        ]);

        $this->belongsTo('ContractorTypes', [
            'foreignKey' => 'contributor_type'
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
        /*$validator
        ->allowEmpty('image')
        ->requirePresence('image')
        ->add('image', 'validFormat', [
            'rule' => ['custom', '([^\s]+(\.(?i)(jpg|jpeg|gif|png))$)'], 
            'message' => __('These files extension are allowed: .jpg, .jpeg, .gif, .png')
        ]);

        $validator
            ->requirePresence('price')
            ->allowEmpty('price')
            ->add('price','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[0-9.]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Invalid format for price!',
            ]);   */
          
       $validator
            ->requirePresence('industry_focus')
            ->allowEmpty('industry_focus')
            ->add('industry_focus', [
                'maxLength' => [
                    'rule' => ['maxLength', 50],
                    'message' => 'Industry Focus must be less than 50 characters!',
                ],
                
            ])
            ->add('industry_focus','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^~&*()||.+=_\/-:,;?\-<>\'\"\\\\ ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Industry Focus invalid characters!',
            ]);
         
        

        return $validator;
    }
}

?>
