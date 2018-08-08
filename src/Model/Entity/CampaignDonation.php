<?php
namespace App\Model\Entity;

use Cake\ORM\Entity;

/**
 * Campaign Entity.
 *
 * @property int $id
 * @property int $user_id
 * @property \App\Model\Entity\User $user
 * @property int $startup_id
 * @property \App\Model\Entity\Startup $startup
 * @property string $campaigns_name
 * @property string $keywords
 * @property \Cake\I18n\Time $due_date
 * @property float $target_amount
 * @property float $fund_raised_so_far
 * @property string $summary
 * @property string $file_path
 * @property int $status
 * @property int $hold
 * @property \Cake\I18n\Time $created
 * @property \Cake\I18n\Time $modified
 * @property \App\Model\Entity\CampaignDonation[] $campaign_donations
 * @property \App\Model\Entity\CampaignFollower[] $campaign_followers
 * @property \App\Model\Entity\CampaignRecommendation[] $campaign_recommendations
 */
class CampaignDonation extends Entity
{

    /**
     * Fields that can be mass assigned using newEntity() or patchEntity().
     *
     * Note that when '*' is set to true, this allows all unspecified fields to
     * be mass assigned. For security purposes, it is advised to set '*' to false
     * (or remove it), and explicitly make individual fields accessible as needed.
     *
     * @var array
     */
    protected $_accessible = [
        '*' => true,
        'id' => false,
    ];
}
