<?php
namespace App\Model\Table;

use App\Model\Entity\EntrepreneurProfessional;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class EntrepreneurProfessionalsTable extends Table
{
    public function initialize(array $config)
    {
    	 parent::initialize($config);
         $this->addBehavior('Timestamp');
		
		$this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);
       
	    $this->belongsTo('PrefferStartups', [
            'foreignKey' => 'startup_stage'
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
            ->allowEmpty('company_name') ;  
            /*->add('company_name','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^~&*()||.+=_\/-:,;?\-<>\'\"\\\\ ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Company Name invalid characters!',
            ]);*/
           
        $validator
            ->requirePresence('website_link')
            ->allowEmpty('website_link');
            /*->add('website_link','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^~&*()||.+=_\/-:,;?\-<>\'\"\\\\ ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Website Link invalid characters!',
            ]);*/
        
        
        
        $validator
            ->requirePresence('description')
            ->allowEmpty('description');
            /*->add('description','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^~&*()||.+=_\/-:,;?\-<>\'\"\\\\ ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Description has invalid characters!',
            ]);*/

        $validator
            ->requirePresence('industry_focus')
            ->allowEmpty('industry_focus')
            ->add('industry_focus','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^~&*()||.+=_\/-:,;?\-<>\'\"\\\\ ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Industry focus invalid characters!',
            ]);   
        
       /* $validator
              ->requirePresence('image')
              ->allowEmpty('image')
              ->add('image', 'validFormat', [
                  'rule' => ['custom', '([^\s]+(\.(?i)(jpg|jpeg|gif|png))$)'], 
                  'message' => __('These files extension are allowed: .jpg, .jpeg, .gif, .png')
              ]);*/

        return $validator;
    }
}

?>