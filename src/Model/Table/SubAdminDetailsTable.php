<?php
namespace App\Model\Table;

//use App\Model\Entity\SubAdminDetail;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;


class SubAdminDetailsTable extends Table
{
    public function initialize(array $config)
    { 
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('sub_admin_details');
        $this->displayField('id');
        $this->primaryKey('id');
        
        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);
		
		/*$this->belongsTo('Industries', [
            'foreignKey' => 'industry'
        ]); 
		
		$this->belongsTo('JobTypes', [
            'foreignKey' => 'job_type'
        ]);*/
		
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
            ->requirePresence('company_name')
            ->notEmpty('company_name');
            /*->add('company_name','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9 ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Company Name invalid characters!',
            ]);*/
		 
		 /*$validator
            ->requirePresence('job_title','update')
            ->notEmpty('job_title')
            ->add('job_title','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9 ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Job title has invalid characters!',
            ]);
			
			$validator
            ->requirePresence('role','update')
            ->notEmpty('role')
            ->add('role','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9 ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Role has invalid characters!',
            ]);
			 
			$validator
            ->requirePresence('location','update')
            ->notEmpty('location')
            ->add('location','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9, ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'location has invalid characters!',
            ]);
			
			$validator
            ->requirePresence('travel','update')
            ->notEmpty('travel')
            ->add('travel','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9 ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Travel has invalid characters!',
            ]);*/
			
			$validator
            ->requirePresence('description','update')
            ->notEmpty('description');
            /*->add('description','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9 ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Description has invalid characters!',
            ]);*/
			
			/*$validator
            ->requirePresence('requirements','update')
            ->notEmpty('requirements')
            ->add('requirements','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9 ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Requirements has invalid characters!',
            ]);*/
			
			/*$validator
            ->requirePresence('min_work_nps','update')
            ->notEmpty('min_work_nps')
            ->add('min_work_nps','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9. ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Minimum Work NPS has invalid characters!',
            ]);*/
			
		    
			$validator
					->allowEmpty('audio')
					->add('audio', [
						'validExtension' => [
							'rule' => ['extension',['mp3']],
							'message' => __('These files extension are allowed: .mp3')
						]
			]);
					
			$validator
					->allowEmpty('video')
					->add('video', [
						'validExtension' => [
							'rule' => ['extension',['mp4']],
							'message' => __('These files extension are allowed: .mp4')
						]
			]);
			
			$validator
					->allowEmpty('document')
					->add('document', [
						'validExtension' => [
							'rule' => ['extension',['ppt','docx','doc','pdf']],
							'message' => __('These files extension are allowed: .ppt .docx .doc .pdf')
						]
			]);
			
        return $validator;
    }
 
}
?>
