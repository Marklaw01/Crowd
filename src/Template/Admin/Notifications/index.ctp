<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class=" fa fa-bell"></i>Notifications 
          </h1>
          <?php
			     //echo $this->Html->link('Add Campaigns', array('controller'=> 'Campaigns','action'=>'add'), array('escape'=>false, 'title'=>'Add','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive">
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>Sender</th>
                  <th>Receiver</th>
                  <th>Type</th>
                </tr>
              </thead>
              <tbody>
	              <?php $i=0;  foreach ($Notifications as $key => $value) { $i++;?>
                  <tr>
                    <td><?php echo $i;?></td>
                    <td><?php echo $this->Custom->contractorName($value->sender_id); ?></td>
                    <td><?php echo $this->Custom->contractorName($value->receiver_id); ?></td>
                    <td><?php echo str_replace("_"," ",$value->type);?></td>
                  </tr>
                <?php } ?> 
              </tbody>
            </table>
        </div>


      </div>
    </div>

 	  <nav class="pagination-custom">
        <ul class="pagination pagination-sm">
            <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
            <li><?= $this->Paginator->numbers() ?></li>
            <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
        </ul>
    </nav>
    
  </div>
  <!-- /#page-content-wrapper --> 
 
</div>