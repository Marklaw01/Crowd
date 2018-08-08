<?php
namespace App\Model\Table;

use App\Model\Entity\ContractorBasic;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class ContractorBasicsTable extends Table
{
    public function initialize(array $config)
    {
         parent::initialize($config);
         $this->addBehavior('Timestamp');
         
         $this->table('contractor_basics');
         $this->displayField('id');
         $this->primaryKey('id');
    
          $this->belongsTo('Users', [
              'foreignKey' => 'user_id'
          ]);

          $this->belongsTo('States', [
            'foreignKey' => 'state_id'
          ]);
          $this->belongsTo('Countries', [
            'foreignKey' => 'country_id'
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
            ->requirePresence('bio')
            ->allowEmpty('bio');
            /*->add('bio','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^~&*()||.+=_\/-:,;?\-<>\'\"\\\\ ]+$/", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Bio invalid characters!',
            ]);*/

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
                'message'=>'Invalid price format!',
            ]);   
          
        $validator
            ->requirePresence('first_name')
            ->notEmpty('first_name')
            ->add('first_name', [
                'maxLength' => [
                    'rule' => ['maxLength', 70],
                    'message' => 'First Name must be less than 70 characters!',
                ]
            ])
            ->add('first_name','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z' ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'First name has invalid characters!',
            ]);
           
        $validator
            ->requirePresence('last_name')
            ->allowEmpty('last_name')
            ->add('last_name', [
                'maxLength' => [
                    'rule' => ['maxLength', 70],
                    'message' => 'Last Name must be less than 70 characters!',
                ],
                
            ])
            ->add('last_name','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z' ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Last name has invalid characters!',
            ]);
        
        $validator
            ->requirePresence('phoneno')
            ->allowEmpty('phoneno')
            /*->add('phoneno', [
                'minLength' => [
                    'rule' => ['minLength', 16],
                    'last' => true,
                    'message' => 'Phone No length must be 10 numbers!.'
                ],
                'maxLength' => [
                    'rule' => ['maxLength', 16],
                    'message' => 'Phone No length must be 10 numbers!.',
                ]
            ])*/
            ->add('phoneno','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match("/^[0-9 ()-]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=> 'Invalid Phone Number',
            ]);
            
         $validator
            ->requirePresence('date_of_birth')
            ->allowEmpty('date_of_birth')
            ->add('date_of_birth','custom',[
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
                                        if($year > $crYear){
                                              return false;  
                                        }else{
                                            //Check future date
                                            $finalD= date('Y-m-d', strtotime($newDob));
                                            $today = date("Y-m-d");
                                            $dob = new \DateTime($finalD);
                                            $todaydate = new \DateTime($today);
                                            if ($dob >= $todaydate){
                                                return false;
                                            }
                                        }
                                }else {
                                   return false; 
                                }        
                            }
                    return true;
                },
                'message'=> 'Date of birth can not be future date.',
            ]);
           
                
       /* $validator
            ->requirePresence('role_id')
            ->notEmpty('role_id','Please select one of these options');
          $validator
            ->requirePresence('country_id')
            ->notEmpty('country','Please select one of these options');
        
        $validator
            ->requirePresence('state_id')
            ->notEmpty('state','Please select one of these options');*/
        $validator
              ->allowEmpty('image')
              ->requirePresence('image')
              ->add('image', 'validFormat', [
                  'rule' => ['custom', '([^\s]+(\.(?i)(jpg|jpeg|gif|png))$)'], 
                  'message' => __('These files extension are allowed: .jpg, .jpeg, .gif, .png')
              ]);
        
        

        return $validator;
    }
   

}

?>
