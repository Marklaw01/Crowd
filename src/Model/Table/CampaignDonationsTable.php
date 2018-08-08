<?php
namespace App\Model\Table;

use App\Model\Entity\CampaignDonation;
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
class CampaignDonationsTable extends Table
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

        $this->table('campaign_donations');
        $this->displayField('id');
        $this->primaryKey('id');

        $this->addBehavior('Timestamp');

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id',
            'joinType' => 'INNER'
        ]);
        $this->belongsTo('Campaigns', [
            'foreignKey' => 'campaign_id',
            'joinType' => 'INNER'
        ]);
       
        $this->belongsTo('DonationTimeperiods', [
            'foreignKey' => 'time_period',
            'joinType' => 'INNER'
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
            ->requirePresence('amount', 'create')
            ->notEmpty('amount')
            ->add('amount','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[0-9.]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Invalid amount format!',
            ])
            ->add('amount','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value == '0.00') {
        
                                    return false;

                            }
                    return true;
                },
                'message'=>'Enter a valid Amount!',
            ]);

       $validator
            ->requirePresence('time_period', 'create')
            ->notEmpty('time_period');   
       $validator
            ->requirePresence('status', 'create')
            ->notEmpty('status');        

        return $validator;
    }

    
}
