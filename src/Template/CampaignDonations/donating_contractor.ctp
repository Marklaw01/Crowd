<div>
<?= $this->Html->link(__('Back to Campaign'), ['controller'=>'Campaigns','action' => 'view',$campId]) ?>

</div>

        
<div class="campaigns index large-12 medium-8 columns content">
    <h3><?= __('Donating Contractors List ') ?></h3>
    <table cellpadding="0" cellspacing="0">
        <thead>
            <tr>
                <th>Id</th>
                <th>Image</th>
                <th>Contractor Name</th>
                <th>Campaign Name</th>
                <th>Donation Amount</th> 

            </tr>
        </thead>
        <tbody>

            <?php $c=0; foreach ($donContractor as $donList): $c++;?>
            <tr>
                <td><?php echo $c; ?></td>
                <td><?php //echo $donList->campaign->campaigns_name; ?></td>
                <td><?php echo $donList->user->first_name; ?> <?php echo $donList->user->last_name; ?></td>
                <td><?php echo $donList->campaign->campaigns_name; ?></td>
                <td><?php if($donList->status == 0){ echo '$'.$donList->amount; }else { echo "xxx.xx"; }?></td>


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
