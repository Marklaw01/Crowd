<?php
namespace App\Model\Table;

//use App\Model\Entity\Job;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;


class ConsultingsTable extends Table
{
    public function initialize(array $config)
    { 
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('consultings');
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
                ->requirePresence('overview', 'create')
                ->notEmpty('overview','Overview can not be left blank.');
                /*->add('overview','custom',[
                    'rule' => function($value){ //pr($value);die;
                                if ($value) {
                                    if (!preg_match("/^[a-zA-Z0-9\r\n!@#$%^&*() ~ ™ ® £ © € ¥.+=_\/-:,;?\-<>\'\" ]+$/i", $value)) {
                                        return false;
                                    }
                                }
                        return true;
                    },
                    'message'=>'Overview has invalid characters!',
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
                ->requirePresence('target_keywords_id', 'create')
                ->notEmpty('target_keywords_id','Please select target keywords.');

            
            $validator
                ->requirePresence('interest_keyword_id', 'create')
                ->notEmpty('interest_keyword_id','Please select interest market.');

            $validator
                ->requirePresence('client_overview_date', 'create')
                ->notEmpty('client_overview_date','Please select date/time for project overview by client.');

            $validator
                ->requirePresence('bid_intent_deadline_date', 'create')
                ->notEmpty('bid_intent_deadline_date','Please select deadline date/time for intent to bid.');


            $validator
                ->requirePresence('requirement_distribute_date', 'create')
                ->notEmpty('requirement_distribute_date','Please select distribute project requirement date.');

            $validator
                ->requirePresence('bid_commitment_deadline_date', 'create')
                ->notEmpty('bid_commitment_deadline_date','Please select commitment deadline for bid.');

            $validator
                ->requirePresence('question_deadline_date', 'create')
                ->notEmpty('question_deadline_date','Please select deadline date/time for questions.');

            $validator
                ->requirePresence('answer_target_date', 'create')
                ->notEmpty('answer_target_date','Please select target date for answer.');
            

            $validator
                ->requirePresence('proposal_submit_date', 'create')
                ->notEmpty('proposal_submit_date','Please select deadline date to submit proposals.');


            $validator
                ->requirePresence('bidder_presentation_date', 'create')
                ->notEmpty('bidder_presentation_date','Please select date/time for bidder presentations.');

            $validator
                ->requirePresence('project_award_date', 'create')
                ->notEmpty('project_award_date','Please select target date to award project.');
                
            $validator
                ->requirePresence('project_start_date', 'create')
                ->notEmpty('project_start_date','Please select target date to start project.');    

            $validator
                ->requirePresence('project_complete_date', 'create')
                ->notEmpty('project_complete_date','Please select target date to complete project.');    





            /*$validator
                ->requirePresence('assignment_start_date', 'create')
                ->notEmpty('assignment_start_date','Please select assignment start date.');

            $validator
                ->requirePresence('assignment_end_time', 'create')
                ->notEmpty('assignment_end_time','Please select assignment end time.');   

            $validator
                ->requirePresence('bid_deadline_date', 'create')
                ->notEmpty('bid_deadline_date','Please select deadline date/time for bid.'); 


            $validator
                ->requirePresence('answer_date', 'create')
                ->notEmpty('answer_date','Please select deadline date/time for answer.');*/

                    

            return $validator;
    }
    
}
?>
