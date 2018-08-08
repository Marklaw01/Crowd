<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Users 
          </h1>
          <?php
			     echo $this->Html->link('Add New User', array('controller'=> 'Users','action'=>'add'), array('escape'=>false, 'title'=>'Edit','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive">
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Role</th>
                  <th>Status</th>
                  <th>Country</th>
                  <th>Created</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
	              <?php $count=0; foreach($users as $user){ $count++;?> 
		                <tr>
		                  <td><?php echo $count; ?></td>
		                  <td><?php echo $user->first_name.' '.$user->last_name; ?></td>
		                  <td><?php echo $user->email; ?></td>
		                  <td><?php echo $user->role->name; ?></td>
		                  <td><?php if($user->status==1){ echo '<span class="green">Active</span>';}else { echo '<span class="red">In Active</span>';} ?></td>
		                  <td><?php if(!empty($user->country)){ echo $user->country->name;} ?></td>
		                  <td><?php echo date_format($user->created,"F d, Y"); ?></td>
		                  <td>
		                  <?php
				            echo $this->Html->link('<i class=" fa fa-eye"> </i>', array('controller'=> 'Users','action'=>'view',base64_encode($user->id)), array('escape'=>false,'title'=>'View'));
				          ?>
				          <?php
				            //echo $this->Html->link('<i class="green fa fa-pencil"> </i>', array('controller'=> 'Users','action'=>'edit',base64_encode($user->id)), array('escape'=>false, 'title'=>'Edit'));
				          ?>
				          <?php
				            //echo $this->Html->link('<i class="red fa fa-trash"> </i>', array('controller'=> 'Users','action'=>'delete',base64_encode($user->id)), array('escape'=>false, 'title'=>'Delete'));
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