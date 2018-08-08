<?php
namespace App\Model\Table;

use App\Model\Entity\StartupTeam;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class StartupTeamsTable extends Table
{
    public function initialize(array $config)
    {
    	 parent::initialize($config);
         $this->addBehavior('Timestamp');
         
         $this->table('startup_teams');
         $this->displayField('id');
         $this->primaryKey('id');

          $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
          ]);

          $this->belongsTo('Startups', [
            'foreignKey' => 'startup_id'
          ]);
          
          $this->belongsTo('ContractorRoles', [
            'foreignKey' => 'contractor_role_id'
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
            ->requirePresence('startup_id')
            ->notEmpty('startup_id','Please select Startup.');

        $validator
            ->requirePresence('roadmap_id')
            ->notEmpty('roadmap_id','Please select Roadmap.');

        $validator
            ->requirePresence('contractor_role_id')
            ->notEmpty('contractor_role_id','Please select Contractor role.');

        $validator
            ->requirePresence('hourly_price')
            ->notEmpty('hourly_price','Price can not be blank')
            ->add('hourly_price','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[0-9.]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Hourly printer_close(printer_handle) has invalid characters.',
            ])
            ->add('hourly_price','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if ($value == 0) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Hourly price can not be 0.',
            ]);

        
        

        $validator
            ->requirePresence('work_units_allocated')
            ->notEmpty('work_units_allocated','Allocated work units can not be left blank.')
            ->add('work_units_allocated','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[0-9]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Work units has invalid characters.',
            ]);

        $validator
            ->requirePresence('work_units_approved')
            ->allowEmpty('work_units_approved','Allocated work units can not be left blank.')
            ->add('work_units_approved','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[0-9]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Work units has invalid characters.',
            ]);    

        $validator
            ->requirePresence('target_date', 'create')
            ->notEmpty('target_date','')
            ->add('target_date','custom',[
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
                'message'=> 'Target date can not be past date.',
            ]);
        
        return $validator;
    }

   

}

?>