<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Campaigns 
          </h1>
          <?php
			     //echo $this->Html->link('Add Campaigns', array('controller'=> 'Campaigns','action'=>'add'), array('escape'=>false, 'title'=>'Add','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive">
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>Name</th>
                  <th>Entrepreneur</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
	              <?php $count=0; foreach($Campaigns as $Campaign){ $count++;?> 
		                <tr>
		                  <td><?php echo $count; ?></td>
		                  <td><?php echo $Campaign->campaigns_name; ?></td>

                      <td><?php if(!empty($Campaign->user->entrepreneur_basic)){echo $Campaign->user->entrepreneur_basic->first_name.' '.$Campaign->user->entrepreneur_basic->last_name;}else {echo $Campaign->user->first_name.' '.$Campaign->user->last_name;} ?>
                      </td>

		                  <td><?php if($Campaign->status == 1){ echo 'Approved';}else if($Campaign->status == 0){echo 'Not Approved';}else{echo 'Pending';} ?></td>

		                  <td>
		                  <?php
				                echo $this->Html->link('<i class=" fa fa-eye"> </i>', array('controller'=> 'Campaigns','action'=>'view',base64_encode($Campaign->id)), array('escape'=>false,'title'=>'Edit'));
				              ?>
				          
    				          <?php
    				            //echo $this->Html->link('<i class="red fa fa-trash"> </i>', array('controller'=> 'Campaigns','action'=>'delete',base64_encode($Campaign->id)), array('escape'=>false, 'title'=>'Delete'));
    				          ?>
		                  
		                  </td>
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