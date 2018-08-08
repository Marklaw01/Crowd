<div>
<?= $this->Html->link(__('Recommended'), ['action' => 'index']) ?> &nbsp;&nbsp;&nbsp;
<?= $this->Html->link(__('Following'), ['action' => 'following']) ?> &nbsp;&nbsp;&nbsp;
<?= $this->Html->link(__('Commitments'), ['controller'=>'CampaignDonations', 'action' => 'index']) ?>
 &nbsp;&nbsp;&nbsp;
 <?= $this->Html->link(__('My Campaigns'), ['action' => 'myCampaign']) ?> &nbsp;&nbsp;&nbsp;

</div>
        
<div class="campaigns index large-12 medium-8 columns content">
    <h3><?= __('Recommended Campaigns') ?></h3>
    <table cellpadding="0" cellspacing="0">
        <thead>
            <tr>
                <th>Id</th>
                <th><?= $this->Paginator->sort('campaigns_name') ?></th>
                <th>Startup</th> 
                <th>Description</th>
                <th>Target Amount</th>
                <th>Funds Raised So Far</th>
                <th>Due Date</th>
                <th class="actions"><?= __('Actions') ?></th>
            </tr>
        </thead>
        <tbody>
            <?php $c=0; foreach ($campaigns as $campaign): $c++;?>
            <tr>
                <td><?php echo $c; ?></td>
                <td><?= h($campaign->campaigns_name) ?></td>
                <td><?= $campaign->startup->name ?></td>
                
                <td><?= h($campaign->summary) ?></td>

                <td>$<?= $this->Number->format($campaign->target_amount) ?></td>
                <td>$<?= h($campaign->fund_raised_so_far) ?></td>
                <td><?= h($campaign->due_date) ?></td>
                <td class="actions">
                    <?php echo $this->Html->link(__('View'), ['action' => 'view', base64_encode($campaign->id)]); ?>
                    
                </td>
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
