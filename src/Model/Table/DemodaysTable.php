<?php
namespace App\Model\Table;

//use App\Model\Entity\Job;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;


class DemodaysTable extends Table
{
    public function initialize(array $config)
    { 
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('demodays');
        $this->displayField('id');
        $this->primaryKey('id');


        $this->belongsTo('Users', [
            'foreignKey' => 'user_id',
            'joinType' => 'INNER'
        ]);
        
        
		
    }

    /**
     * Default validation rules.
     *
     *
     */
    public function validationDefault(Validator $validator)
    {
            date_default_timezone_set('America/Los_Angeles'); 

            $validator
                ->requirePresence('title', 'create')
                ->notEmpty('title','Title can not be left blank.');
                /*->add('title','custom',[
                    'rule' => function($value){ //pr($value);die;
                                if ($value) {
                                    if (!preg_match("/^[a-zA-Z0-9!@#$%^&*() ~ ™ ® £ © € ¥.+=_\/-:,;?\-<>\'\" ]+$/i", $value)) {
                                        return false;
                                    }
                                }
                        return true;
                    },
                    'message'=>'Title has invalid characters!',
            ]);*/

       
            $validator
                ->requirePresence('description', 'create')
                ->notEmpty('description','Description can not be left blank.');
                /*->add('description','custom',[
                    'rule' => function($value){ //pr($value);die;
                                if ($value) {
                                    if (!preg_match("/^[a-zA-Z0-9\r\n!@#$%^&*() ~ ™ ® £ © € ¥.+=_\/-:,;?\-<>\'\" ]+$/i", $value)) {
                                        return false;
                                    }
                                }
                        return true;
                    },
                    'message'=>'Description has invalid characters!',
            ]);*/


                           
            $validator
                ->requirePresence('interest_keywords_id', 'create')
                ->notEmpty('interest_keywords_id','Please select interest keywords.');

            
            $validator
                ->requirePresence('target_market', 'create')
                ->notEmpty('target_market','Please select target market.');

            $validator
                ->requirePresence('keywords_id', 'create')
                ->notEmpty('keywords_id','Please select keywords.');


            $validator
                ->requirePresence('start_date', 'create')
                ->notEmpty('start_date','Please select start date.');
                /*->add('start_date','custom',[
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
                ]);*/


            $validator
                ->requirePresence('end_date', 'create')
                ->notEmpty('end_date','Please select end date.')
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
                    'message'=> 'End date can not be past date.',
                ]);
            

            return $validator;
    }
    
}
?>
