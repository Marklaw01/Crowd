<?php
namespace App\Model\Table;

/*use App\Model\Entity\UserConnection;*/
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
class UserFeedsTable extends Table
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

        $this->table('user_feeds');
        $this->displayField('id');
        $this->primaryKey('id');

        $this->addBehavior('Timestamp');

        $this->belongsTo('Sender', [
            'className' => 'Users', 
            'foreignKey' => 'sender_id',
            'joinType' => 'INNER'
        ]);
        $this->belongsTo('Receiver', [
            'className' => 'Users', 
            'foreignKey' => 'receiver_id',
            'joinType' => 'INNER'
        ]);

    }

}
