<?php
namespace App\Model\Table;

//use App\Model\Entity\Job;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;


class JobsTable extends Table
{
    public function initialize(array $config)
    { 
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('jobs');
        $this->displayField('id');
        $this->primaryKey('id');
        
        $this->belongsTo('SubAdminDetails', [
            'foreignKey' => 'company_id'
        ]);
        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);
		
        $this->belongsTo('JobIndustries', [
            'foreignKey' => 'industry_id'
        ]);

        $this->belongsTo('Countries', [
            'foreignKey' => 'country_id'
        ]);
        $this->belongsTo('States', [
            'foreignKey' => 'state_id'
        ]);
        $this->belongsTo('JobTypes', [
            'foreignKey' => 'job_type'
        ]);
        $this->hasMany('JobFollowers', [
            'foreignKey' => 'job_id'
        ]);
		
    }

    /**
     * Default validation rules.
     *
     *
     */
    public function validationDefault(Validator $validator)
    {
            $validator
                ->requirePresence('company_id', 'create')
                ->notEmpty('company_id','Please select company.');

            $validator
                ->requirePresence('industry_id', 'create')
                ->notEmpty('industry_id','Please select industry.');  

            $validator
                ->requirePresence('job_title', 'create')
                ->notEmpty('job_title','Job title can not be left blank.');
                /*->add('job_title','custom',[
                    'rule' => function($value){ //pr($value);die;
                                if ($value) {
                                    if (!preg_match("/^[a-zA-Z0-9!@#$%^&*() ~ ™ ® £ © € ¥.+=_\/-:,;?\-<>\'\" ]+$/i", $value)) {
                                        return false;
                                    }
                                }
                        return true;
                    },
                    'message'=>'Job title has invalid characters!',
            ]);*/

            $validator
                ->requirePresence('role', 'create')
                ->notEmpty('role','Role can not be left blank.');
                /*->add('role','custom',[
                    'rule' => function($value){ //pr($value);die;
                                if ($value) {
                                    if (!preg_match("/^[a-zA-Z0-9!@#$%^&*() ~ ™ ® £ © € ¥.+=_\/-:,;?\-<>\'\" ]+$/i", $value)) {
                                        return false;
                                    }
                                }
                        return true;
                    },
                    'message'=>'Role has invalid characters!',
            ]);*/

            $validator
                ->requirePresence('job_type', 'create')
                ->notEmpty('job_type','Please select job type.');  

            $validator
                ->requirePresence('min_work_nps', 'create')
                ->notEmpty('min_work_nps','Minimum work NPS can not left blank.');  

            $validator
                ->requirePresence('country_id', 'create')
                ->notEmpty('country_id','Please select country.');

            $validator
                ->requirePresence('state_id', 'create')
                ->notEmpty('state_id','Please select state.'); 

            $validator
                ->requirePresence('location', 'create')
                ->notEmpty('location','Location can not be left blank.'); 

            $validator
                ->requirePresence('description', 'create')
                ->notEmpty('description','Description can not be left blank.');

            $validator
                ->requirePresence('travel', 'create')
                ->notEmpty('travel','Travel can not be left blank.');

            $validator
                ->requirePresence('start_date', 'create')
                ->notEmpty('start_date','')
                ->add('start_date','custom',[
                    'rule' => function($value){
                                if ($value) {
                                    ///Check date format
                                    $dateFotmat = date_create_from_format('F d, Y', $value);
                                    if(!empty($dateFotmat)){
                                        $validFormat= date_format($dateFotmat, 'F d, Y');
                                    }
                                    if(!empty($validFormat)){
                                            //check year if greater then to current
                                            $newDob= str_replace(',', '',$value);
                                            $explo=explode(' ',$newDob);
                                            $crYear=date('Y');
                                            $year=$explo[2]; 
                                            if($year < $crYear){
                                                  return false;  
                                            }else{
                                                //Check future date
                                                $finalD= date('Y-m-d', strtotime($newDob));
                                                $today = date("Y-m-d");
                                                $dob = new \DateTime($finalD);
                                                $todaydate = new \DateTime($today);
                                                if ($dob < $todaydate){
                                                    return false;
                                                }
                                            }
                                    }else {
                                       return false; 
                                    }        
                                }
                        return true;
                    },
                    'message'=> 'Start date can not be past date.',
                ]);


            $validator
                ->requirePresence('end_date', 'create')
                ->notEmpty('end_date','')
                ->add('end_date','custom',[
                    'rule' => function($value){ 
                                if ($value) {
                                    ///Check date format
                                    $dateFotmat = date_create_from_format('F d, Y', $value);
                                    if(!empty($dateFotmat)){
                                        $validFormat= date_format($dateFotmat, 'F d, Y');
                                    }

                                    if(!empty($validFormat)){
                                            //check year if greater then to current
                                            $newDob= str_replace(',', '',$value);
                                            $explo=explode(' ',$newDob);
                                            $crYear=date('Y');
                                            $year=$explo[2]; 

                                            if($year < $crYear){ 
                                                  return false;  
                                            }else{
                                                //Check future date
                                                $finalD= date('Y-m-d', strtotime($newDob));
                                                $today = date("Y-m-d");
                                                $dob = new \DateTime($finalD);
                                                $todaydate = new \DateTime($today);
                                                if ($dob < $todaydate){
                                                    return false;
                                                }
                                            }
                                    }else {
                                       return false; 
                                    }        
                                }
                        return true;
                    },
                    'message'=> 'End date can not be past date...',
                ]);
            
            $validator
                ->requirePresence('skills', 'create')
                ->notEmpty('skills','Please select skill.');

            $validator
                ->requirePresence('requirements', 'create')
                ->notEmpty('requirements','Requirements can not be left blank.');
                /*->add('requirements','custom',[
                    'rule' => function($value){ //pr($value);die;
                                if ($value) {
                                    if (!preg_match("/^[a-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-<>\'\" ]+$/i", $value)) {
                                        return false;
                                    }
                                }
                        return true;
                    },
                    'message'=>'Requirements has invalid characters!',
            ]);*/

            $validator
                ->requirePresence('posting_keywords', 'create')
                ->notEmpty('posting_keywords','Job Posting Keywords.');    

            return $validator;
    }
    
}
?>
