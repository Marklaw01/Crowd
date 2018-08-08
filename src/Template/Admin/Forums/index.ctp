<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Forums 
          </h1>
          <?php
			     //echo $this->Html->link('Add Roadmaps', array('controller'=> 'Forum','action'=>'add'), array('escape'=>false, 'title'=>'Add','class'=>'btn redColor'));
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
	              <?php $count=0; foreach($Forums as $Forum){ $count++;?> 
		                <tr>
		                  <td><?php echo $count; ?></td>
		                  <td><?php echo $Forum->title; ?></td>

		                  <td><?php if($Forum->status == 1){ echo 'Active';}else{echo 'Inactive';} ?></td>

                      <td><?php if(!empty($Forum->user->entrepreneur_basic)){echo $Forum->user->entrepreneur_basic->first_name.' '.$Forum->user->entrepreneur_basic->last_name;}else {echo $Forum->user->first_name.' '.$Forum->user->last_name;} ?>
                      </td>

		                  <td>
		                  <?php
				                echo $this->Html->link('<i class=" fa fa-eye"> </i>', array('controller'=> 'Forums','action'=>'view',base64_encode($Forum->id)), array('escape'=>false,'title'=>'Edit'));
				              ?>
				          
    				          <?php
    				            //echo $this->Html->link('<i class="red fa fa-trash"> </i>', array('controller'=> 'Forums','action'=>'delete',base64_encode($Forum->id)), array('escape'=>false, 'title'=>'Delete'));
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