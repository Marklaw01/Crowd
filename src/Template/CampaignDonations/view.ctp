  <li><?= $this->Html->link(__('List Campaigns'), ['action' => 'index']) ?></li>
<div class="campaigns view large-9 medium-8 columns content">
    <h3><?= h($campaign->campaigns_name) ?></h3>
    <table class="vertical-table">
        
        <tr>
            <th><?= __('Campaign Name') ?></th>
            <td><?= h($campaign->campaigns_name) ?></td>
        </tr>
        <tr>
            <th><?= __('Startup Name') ?></th>
            <td><?= $campaign->startup->name; ?></td>
        </tr>
        
        <tr>
            <th><?= __('Keywords') ?></th>
            <td><?= h($campaign->keywords) ?></td>
        </tr>
        
        <tr>
            <th><?= __('Due Date') ?></th>
            <td><?= h($campaign->due_date) ?></td>
        </tr>

        <tr>
            <th><?= __('Fund Raised So Far') ?></th>
            <td><?= $this->Number->format($campaign->fund_raised_so_far) ?></td>
        </tr>

        <tr>
            <th><?= __('Donated Amount') ?></th>
            <td> <a href="">Edit</a></td>
        </tr>

        <tr>
            <th><?= __('Summary') ?></th>
            <td><?= h($campaign->summary) ?></td>
        </tr>
        <tr>
            <th><?= __('Docs') ?></th>
            <td>
            <?php 
                $cDocs=json_decode($campaign->file_path);
                  $cD = count($cDocs);
                     for ($i=0; $i<$cD; $i++) {
                     $dType=$cDocs[$i]->file_type;
                      if($dType=='doc'){
                            $viewType = 'Doc';
                        }else if($dType=='mp3') {
                            $viewType = 'mp3';
                        }else {
                            $viewType = 'mp4';
                        }
                        echo '<span class="campaign-errors" style="color:green;">'.$viewType.' - '.$cDocs[$i]->name.'</span> ';
                        echo "<br/>";
                     } 
                // echo $campaign->id;
            ?>
            </td>
        </tr>
        
        
    </table>
    <div class="related">
        <h4><?= __('Related Campaign Donations') ?></h4>
        <?php if (!empty($campaign->campaign_donations)): ?>
        <table cellpadding="0" cellspacing="0">
            <tr>
                <th><?= __('Id') ?></th>
                <th><?= __('User Id') ?></th>
                <th><?= __('Campaign Id') ?></th>
                <th><?= __('Amount') ?></th>
                <th><?= __('Time Period') ?></th>
                <th><?= __('Status') ?></th>
                <th><?= __('Created') ?></th>
                <th><?= __('Modified') ?></th>
                <th class="actions"><?= __('Actions') ?></th>
            </tr>
            <?php foreach ($campaign->campaign_donations as $campaignDonations): ?>
            <tr>
                <td><?= h($campaignDonations->id) ?></td>
                <td><?= h($campaignDonations->user_id) ?></td>
                <td><?= h($campaignDonations->campaign_id) ?></td>
                <td><?= h($campaignDonations->amount) ?></td>
                <td><?= h($campaignDonations->time_period) ?></td>
                <td><?= h($campaignDonations->status) ?></td>
                <td><?= h($campaignDonations->created) ?></td>
                <td><?= h($campaignDonations->modified) ?></td>
                <td class="actions">
                    <?= $this->Html->link(__('View'), ['controller' => 'CampaignDonations', 'action' => 'view', $campaignDonations->id]) ?>

                    <?= $this->Html->link(__('Edit'), ['controller' => 'CampaignDonations', 'action' => 'edit', $campaignDonations->id]) ?>

                    <?= $this->Form->postLink(__('Delete'), ['controller' => 'CampaignDonations', 'action' => 'delete', $campaignDonations->id], ['confirm' => __('Are you sure you want to delete # {0}?', $campaignDonations->id)]) ?>

                </td>
            </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
    </div>
    <div class="related">
        <h4><?= __('Related Campaign Followers') ?></h4>
        <?php if (!empty($campaign->campaign_followers)): ?>
        <table cellpadding="0" cellspacing="0">
            <tr>
                <th><?= __('Id') ?></th>
                <th><?= __('Campaign Id') ?></th>
                <th><?= __('User Id') ?></th>
                <th><?= __('Created') ?></th>
                <th class="actions"><?= __('Actions') ?></th>
            </tr>
            <?php foreach ($campaign->campaign_followers as $campaignFollowers): ?>
            <tr>
                <td><?= h($campaignFollowers->id) ?></td>
                <td><?= h($campaignFollowers->campaign_id) ?></td>
                <td><?= h($campaignFollowers->user_id) ?></td>
                <td><?= h($campaignFollowers->created) ?></td>
                <td class="actions">
                    <?= $this->Html->link(__('View'), ['controller' => 'CampaignFollowers', 'action' => 'view', $campaignFollowers->id]) ?>

                    <?= $this->Html->link(__('Edit'), ['controller' => 'CampaignFollowers', 'action' => 'edit', $campaignFollowers->id]) ?>

                    <?= $this->Form->postLink(__('Delete'), ['controller' => 'CampaignFollowers', 'action' => 'delete', $campaignFollowers->id], ['confirm' => __('Are you sure you want to delete # {0}?', $campaignFollowers->id)]) ?>

                </td>
            </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
    </div>
    <div class="related">
        <h4><?= __('Related Campaign Recommendations') ?></h4>
        <?php if (!empty($campaign->campaign_recommendations)): ?>
        <table cellpadding="0" cellspacing="0">
            <tr>
                <th><?= __('Id') ?></th>
                <th><?= __('Recommended By') ?></th>
                <th><?= __('Recommended To') ?></th>
                <th><?= __('Campaign Id') ?></th>
                <th><?= __('Status') ?></th>
                <th><?= __('Created') ?></th>
                <th><?= __('Target Amount') ?></th>
                <th class="actions"><?= __('Actions') ?></th>
            </tr>
            <?php foreach ($campaign->campaign_recommendations as $campaignRecommendations): ?>
            <tr>
                <td><?= h($campaignRecommendations->id) ?></td>
                <td><?= h($campaignRecommendations->recommended_by) ?></td>
                <td><?= h($campaignRecommendations->recommended_to) ?></td>
                <td><?= h($campaignRecommendations->campaign_id) ?></td>
                <td><?= h($campaignRecommendations->status) ?></td>
                <td><?= h($campaignRecommendations->created) ?></td>
                <td><?= h($campaignRecommendations->target_amount) ?></td>
                <td class="actions">
                    <?= $this->Html->link(__('View'), ['controller' => 'CampaignRecommendations', 'action' => 'view', $campaignRecommendations->id]) ?>

                    <?= $this->Html->link(__('Edit'), ['controller' => 'CampaignRecommendations', 'action' => 'edit', $campaignRecommendations->id]) ?>

                    <?= $this->Form->postLink(__('Delete'), ['controller' => 'CampaignRecommendations', 'action' => 'delete', $campaignRecommendations->id], ['confirm' => __('Are you sure you want to delete # {0}?', $campaignRecommendations->id)]) ?>

                </td>
            </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
    </div>
</div>
