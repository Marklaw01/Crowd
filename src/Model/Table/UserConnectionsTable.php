<?php
namespace App\Model\Table;

use App\Model\Entity\UserConnection;
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
class UserConnectionsTable extends Table
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

        $this->table('user_connections');
        $this->displayField('id');
        $this->primaryKey('id');

        $this->addBehavior('Timestamp');

        $this->belongsTo('Users', [
            'foreignKey' => 'connection_by',
            'joinType' => 'INNER'
        ]);
        $this->belongsTo('Users', [
            'foreignKey' => 'connection_to',
            'joinType' => 'INNER'
        ]);

    }

}
