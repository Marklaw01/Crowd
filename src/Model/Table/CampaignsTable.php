<?php
namespace App\Model\Table;

use App\Model\Entity\Campaign;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

/**
 * Campaigns Model
 *
 * @property \Cake\ORM\Association\BelongsTo $Users
 * @property \Cake\ORM\Association\BelongsTo $Startups
 * @property \Cake\ORM\Association\HasMany $CampaignDonations
 * @property \Cake\ORM\Association\HasMany $CampaignFollowers
 * @property \Cake\ORM\Association\HasMany $CampaignRecommendations
 */
class CampaignsTable extends Table
{

    /**
     * Initialize method
     *
     * @param array $config The configuration for the Table.
     * @return void
     */
    public function initialize(array $config)
    {
        parent::initialize($config);

        $this->table('campaigns');
        $this->displayField('id');
        $this->primaryKey('id');

        $this->addBehavior('Timestamp');

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id',
            'joinType' => 'INNER'
        ]);
        $this->belongsTo('Startups', [
            'foreignKey' => 'startup_id',
            'joinType' => 'INNER'
        ]);
        $this->hasMany('CampaignDonations', [
            'foreignKey' => 'campaign_id'
        ]);
        $this->hasMany('CampaignFollowers', [
            'foreignKey' => 'campaign_id'
        ]);
        $this->hasMany('CampaignRecommendations', [
            'foreignKey' => 'campaign_id'
        ]);
        $this->belongsTo('CampaignTargetKeywords', [
            'foreignKey' => 'keywords'
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
            ->add('id', 'valid', ['rule' => 'numeric'])
            ->allowEmpty('id', 'create');

        $validator
            ->requirePresence('startup_id', 'create')
            ->notEmpty('startup_id','Please select startup.');

        $validator
            ->requirePresence('campaigns_name', 'create')
            ->notEmpty('campaigns_name','Name can not be left blank.');
            /*->add('campaigns_name','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9!@#$%^&*()  ~ ™ ® £ © € ¥.+=_\/-:,;?\-<>\'\" ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Campaign name has invalid characters!',
            ]);*/

        $validator
            ->requirePresence('keywords', 'create')
            ->notEmpty('keywords','Please select keywords.');

        $validator
            ->requirePresence('due_date', 'create')
            ->notEmpty('due_date','')
            ->add('due_date','custom',[
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
                'message'=> 'Due date can not be past date.',
            ]);


        $validator
            /*->add('target_amount', 'valid', ['rule' => 'numeric'])*/
            ->requirePresence('target_amount', 'create')
            ->notEmpty('target_amount')
            ->add('target_amount','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[0-9.]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Invalid Target Amount!',
            ]);

       /* $validator
            ->add('fund_raised_so_far', 'valid', ['rule' => 'numeric'])
            ->requirePresence('fund_raised_so_far', 'create')
            ->allowEmpty('fund_raised_so_far')
            ->add('fund_raised_so_far','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[0-9.]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Invalid Funds Raised So Far Amount!',
            ]);*/

        $validator
            ->requirePresence('summary', 'create')
            ->notEmpty('summary');
            /*->add('summary','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-<>\'\" ]+$/", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Summary has invalid characters!',
            ]);*/

       /*  $validator
            ->requirePresence('files', 'create')
            ->notEmpty('files');

       $validator
            ->add('status', 'valid', ['rule' => 'numeric'])
            ->requirePresence('status', 'create')
            ->notEmpty('status');

        $validator
            ->add('hold', 'valid', ['rule' => 'numeric'])
            ->requirePresence('hold', 'create')
            ->notEmpty('hold');*/

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
        $rules->add($rules->existsIn(['user_id'], 'Users'));
        $rules->add($rules->existsIn(['startup_id'], 'Startups'));
        return $rules;
    }
}
