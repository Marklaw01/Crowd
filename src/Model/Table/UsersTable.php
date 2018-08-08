<?php
namespace App\Model\Table;

use App\Model\Entity\User;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;

class UsersTable extends Table
{
    public function initialize(array $config)
    {
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('users');
        $this->displayField('id');
        $this->primaryKey('id');
        
        /*$this->addBehavior('Captcha', [
                    'field' => 'securitycode',
                    'message' => 'Incorrect captcha code value'
                ]);*/
        
        $this->belongsTo('Roles', [
            'foreignKey' => 'role_id'
        ]);

        $this->belongsTo('Questions', [
            'foreignKey' => 'question_id'
        ]);

        $this->belongsTo('States', [
            'foreignKey' => 'state'
        ]);
        
        $this->belongsTo('Countries', [
            'foreignKey' => 'country'
        ]);

	 
        $this->hasMany('Ratings', [
            'className' => 'Ratings',
            'foreignKey' => 'given_by'
        ]);

        $this->hasMany('Ratings', [
            'className' => 'Ratings',
            'foreignKey' => 'given_to'
        ]);
        
        $this->hasOne('ContractorBasics', [
            'className' => 'ContractorBasics',
            'foreignKey' => 'user_id'
        ]);
        
        $this->hasOne('ContractorProfessionals', [
            'className' => 'ContractorProfessionals',
            'foreignKey' => 'user_id'
        ]);

		$this->hasOne('EntrepreneurBasics', [
            'className' => 'EntrepreneurBasics',
            'foreignKey' => 'user_id'
        ]);
	
		$this->hasOne('EntrepreneurProfessionals', [
            'className' => 'EntrepreneurProfessionals',
            'foreignKey' => 'user_id'
        ]);

        $this->hasMany('BusinessUserNetworks', [
            'className' => 'BusinessUserNetworks',
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
        /*$validator
            ->add('id', 'valid', ['rule' => 'numeric'])
            ->allowEmpty('id', 'create');
            $validator
            ->requirePresence('last_name')
            ->add('email', 'valid', ['rule' => 'email'])
            ->notEmpty('email');*/

        $validator
            ->requirePresence('username')
            ->notEmpty('username')
            
            ->add('username','custom',[
                'rule' => function($value){
                            $value= trim($value);
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9.-_@]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Username invalid characters!',
            ]);



        $validator
            ->requirePresence('email')
            ->add('email', 'validFormat', [
                'rule' => 'email',
                'message' => 'E-mail must be valid'
           ]);
        $validator
            ->requirePresence('password')
            ->notEmpty('password')
            //->allowEmpty('password','update')
            ->add('password', [
                'minLength' => [
                    'rule' => ['minLength', 8],
                    'message' => 'The password have to be at least 8 characters!',
                ]
            ])
            ->add('password','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match('/(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/', $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Password must be a minimum of 8 characters with at least one special character or numeric, at least one uppercase letter & at least one lower case letter.!',
            ]);

         $validator
            ->requirePresence('confirm_password')
            ->add('confirm_password',
                'compareWith', [
                       'rule' => ['compareWith', 'password'],
                       'message' => 'Confirm Password not matched.'
                     ]
                );
            
        $validator
            ->requirePresence('first_name')
            ->notEmpty('first_name')
            ->add('first_name', [
                'maxLength' => [
                    'rule' => ['maxLength', 50],
                    'message' => 'First Name must be less than 50 characters!',
                ]
            ])
            ->add('first_name','custom',[
                'rule' => function($value){
                            if ($value) {
                                $value= trim($value);
                                if (!preg_match("/^[a-zA-Z' ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'First name invalid characters!',
            ]);

        $validator
            ->requirePresence('last_name')
            ->allowEmpty('last_name')
            ->add('last_name', [
                'maxLength' => [
                    'rule' => ['maxLength', 50],
                    'message' => 'Last Name must be less than 50 characters!',
                ],
                
            ])
            ->add('last_name','custom',[
                'rule' => function($value){
                            if ($value) {
                                $value= trim($value);
                                if (!preg_match("/^[a-zA-Z' ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Last name invalid characters!',
            ]);
        
        /*$validator
            ->requirePresence('phoneno')
            ->allowEmpty('phoneno')
            ->add('phoneno', [
                'minLength' => [
                    'rule' => ['minLength', 16],
                    'last' => true,
                    'message' => 'Phone No length must be 10 numbers!.'
                ],
                'maxLength' => [
                    'rule' => ['maxLength', 16],
                    'message' => 'Phone No length must be 10 numbers!.',
                ]
            ])
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
            ]);*/
        
           
       /* $validator
            ->requirePresence('date_of_birth')
            ->allowEmpty('date_of_birth')
            ->add('date_of_birth','custom',[
                'rule' => function($value){
                            if ($value) {

                                $dateFotmat = date_create_from_format('F d, Y', $value);
                                if(!empty($dateFotmat)){
                                    $validFormat= date_format($dateFotmat, 'F d, Y');
                                }
                                if(!empty($validFormat)){

                                    $newDob= str_replace(',', '',$value);
                                    $finalD= date('Y-m-d', strtotime($newDob));
                                    $today = date("Y-m-d");
                                    $dob = new \DateTime($finalD);
                                    $todaydate = new \DateTime($today);
                                    if ($dob >= $todaydate){
                                        return false;
                                    }
                                    
                                }else {
                                   return false; 
                                }    
                            }
                    return true;
                },
                'message'=> 'Invalid date of birth.',
            ]);*/

        $validator
            ->requirePresence('answer')
            ->notEmpty('answer');
       
        $validator
            ->requirePresence('question_id')
            ->allowEmpty('question_id');
        
       /* $validator
            ->requirePresence('role_id')
            ->notEmpty('role_id','Please select one of these options');*/
        /*$validator
            ->requirePresence('country')
            ->allowEmpty('country');*/
        

        /*$validator
            ->requirePresence('state')
            ->allowEmpty('state');*/
        
        /*$validator
            ->requirePresence('city')
            ->allowEmpty('city')
            ->add('city', [
                'maxLength' => [
                    'rule' => ['maxLength', 50],
                    'message' => 'City Name must be less than 50 characters!',
                ]
            ])
            ->add('city','custom',[
                'rule' => function($value){
                            if ($value) {
                              $value= trim($value);  
                                if (!preg_match("/^[a-zA-Z ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'City name invalid characters!',
            ]);*/

        /*$validator
            ->requirePresence('best_availablity')
            ->allowEmpty('best_availablity')
            ->add('best_availablity','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-\'\" ]+$/", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Best availablity has invalid characters.',
            ]);*/

        $validator    
            ->requirePresence('terms','create')
            ->notEmpty('terms', 'You must agree to our terms and conditions')
            ->add('terms',[
                'equalTo'=> [
                    'rule' => ['equalTo', '1'],
                    'message' => 'You must agree to our terms and conditions'
                ]
            ]);

        $validator
            ->requirePresence('captcha_value')
            ->notEmpty('captcha_value','Please check captcha.')
            ->add('captcha_value','custom',[
                'rule' => function($value){ //echo $value; die;
                            $value= trim($value);
                            if (empty($value)) {
                                return false;
                            }

                    return true;
                },
                'message'=>'Please check captcha.',
            ]);    

        
        return $validator;
    }
    /**
    *       Password Validations
    **/

    public function validationPassword(Validator $validator )
    {
        $validator
            ->add('password','custom',[
                'rule'=>  function($value, $context){
                    $user = $this->get($context['data']['id']);
                    if ($user) {
                        if ((new DefaultPasswordHasher)->check($value, $user->password)) {
                            return false;
                        }
                    }
                    return true;
                },
                'message'=>'Your new password should not match with existing password!',
            ])
            ->add('password', [
                'length' => [
                    'rule' => ['minLength', 8],
                    'message' => 'The password have to be at least 8 characters!',
                ]
            ])
            ->add('password',[
                'match'=>[
                    'rule'=> ['compareWith','confirm_password'],
                    'message'=>'The passwords does not match!',
                ]
            ])
            ->notEmpty('password');
        $validator
            ->add('confirm_password', [
                'length' => [
                    'rule' => ['minLength', 8],
                    'message' => 'The password have to be at least 8 characters!',
                ]
            ])
            //~ ->add('password2',[
                //~ 'match'=>[
                    //~ 'rule'=> ['compareWith','password1'],
                    //~ 'message'=>'The passwords does not match!',
                //~ ]
            //~ ])
            ->notEmpty('confirm_password');

        return $validator;
    }

    // Custom validation for forgot password
    public function validationForgotPass(Validator $validator){
             //Its empty 
        $validator
            ->requirePresence('email')
            ->add('email', 'validFormat', [
                'rule' => 'email',
                'message' => 'E-mail must be valid'
           ]);
        return $validator;
    }

    // Custom validation for forgot password
    public function validationResendConfirmation(Validator $validator){
             //Its empty 
        $validator
            ->requirePresence('email')
            ->add('email', 'validFormat', [
                'rule' => 'email',
                'message' => 'E-mail must be valid'
           ]);
        return $validator;
    }

    
    // Custom validation for forgot password question
    public function validationForgotPassQuestion(Validator $validator){
             //Its empty 
        $validator
            ->requirePresence('email')
            ->add('email', 'validFormat', [
                'rule' => 'email',
                'message' => 'E-mail must be valid'
           ]);

        $validator
            ->requirePresence('answer')
            ->notEmpty('answer');
       
        $validator
            ->requirePresence('question')
            ->notEmpty('question','Please select one of these options');  

        return $validator;
    }

    // Custom validation for update password
    public function validationResetPass(Validator $validator){
             //Its empty 
        $validator
            ->requirePresence('password1')
            ->notEmpty('password1')
            //->allowEmpty('password','update')
            ->add('password1', [
                'minLength' => [
                    'rule' => ['minLength', 8],
                    'message' => 'The password have to be at least 8 characters!',
                ]
            ])
            ->add('password1','custom',[
                'rule' => function($value){
                            if ($value) {
                                if (!preg_match('/(?=^.{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/', $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Invalid password format!',
            ]);
        
        $validator
            ->requirePresence('password2')
            ->notEmpty('password2')
            ->add('password2', [
                'length' => [
                    'rule' => ['minLength', 8],
                    'message' => 'The password have to be at least 8 characters!',
                ]
            ])
            ->add('password2',[
                'match'=>[
                    'rule'=> ['compareWith','password1'],
                    'message'=>'The passwords does not match...!',
                ]
            ]);


        return $validator;
    }

      /**************************************
     *******Edit Mode Validations**********
     **************************************/
    public function validationUpdatePassword(Validator $validator)
{
    
        $validator
            ->add('id', 'valid', ['rule' => 'numeric'])
            ->requirePresence('id')
            ->requirePresence('password')
            ->notEmpty('password');
            //->allowEmpty('password','update')
            /*->add('password', [
                'minLength' => [
                    'rule' => ['minLength', 8],
                    'message' => 'The password have to be at least 8 characters!',
                ]
            ]);
            /*->add('password','custom',[
                'rule'=>  function($value, $context){
                    $user = $this->get($context['data']['id']); //pr($value);
                    if ($user) {
                        if ((new DefaultPasswordHasher)->check($value, $user->password)) {
                            return false;
                        }
                    }
                    return true;
                },
                'message'=>'You cant not use your old password!',
            ]);*/

         $validator

            ->add('confirm_password', [
                'length' => [
                    'rule' => ['minLength', 8],
                    'message' => 'The password have to be at least 8 characters!',
                ]
            ])
            ->add('confirm_password',[
                'match'=>[
                    'rule'=> ['compareWith','password'],
                    'message'=>'The passwords does not match!',
                ]
            ])
            ->notEmpty('confirm_password');

    return $validator;
}
/**
     * Returns a rules checker object that will be used for validating
     * application integrity.
     *
     * @param \Cake\ORM\RulesChecker $rules The rules object to be modified.
     * @return \Cake\ORM\RulesChecker
     */
    public function buildRules(RulesChecker $rules)
    {
        $rules->add($rules->isUnique(['username']));
        $rules->add($rules->isUnique(['email']));
        return $rules;
    }

}
?>
