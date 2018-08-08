<div>
<?= $this->Html->link(__('Recommended'), ['controller'=>'Campaigns','action' => 'index']) ?> &nbsp;&nbsp;&nbsp;
<?= $this->Html->link(__('Following'), ['controller'=>'Campaigns','action' => 'following']) ?> &nbsp;&nbsp;&nbsp;
<?= $this->Html->link(__('Commitments'), ['controller'=>'CampaignDonations', 'action' => 'index']) ?> &nbsp;&nbsp;&nbsp;
<?= $this->Html->link(__('My Campaigns'), ['controller'=>'Campaigns','action' => 'myCampaign']) ?> &nbsp;&nbsp;&nbsp;
</div>

        
<div class="campaigns index large-12 medium-8 columns content">
    <h3><?= __('Campaign Commitments ') ?></h3>
    <table cellpadding="0" cellspacing="0">
        <thead>
            <tr>
                <th>Id</th>
                <th>Campaign Name</th>
                <th>Donation Amount</th> 
                <th>Timeperiod</th>
                <th>Timeperiod Satrt</th>
                <th>Timeperiod End</th>
                <th class="actions"><?= __('Actions') ?></th>
            </tr>
        </thead>
        <tbody>
<?php //echo "<pre>"; pr($commitments);?>
            <?php $c=0; foreach ($commitments as $commitment): $c++;?>
            <tr>
                <td><?php echo $c; ?></td>
                <td><?php echo $commitment->campaign->campaigns_name; ?></td>
                <td>$<?php echo $commitment->amount; ?></td>
                <td><?php echo $commitment->donation_timeperiod->timeperiod; ?> <?php echo $commitment->donation_timeperiod->type; ?></td>
                <td><?php echo $commitment->time_period_start; ?></td>
                <td><?php echo $commitment->time_period_end; ?></td>
                <td></td>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
    <div class="paginator">
        <ul class="pagination">
            <?= $this->Paginator->prev('< ' . __('previous')) ?>
            <?= $this->Paginator->numbers() ?>
            <?= $this->Paginator->next(__('next') . ' >') ?>
        </ul>
        <p><?= $this->Paginator->counter() ?></p>
    </div>
</div>
