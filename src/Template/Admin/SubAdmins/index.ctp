<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class=" fa fa-user"></i>Sub Admin
          </h1>
          <?php
			     echo $this->Html->link('Add Sub Admin', array('controller'=> 'SubAdmins','action'=>'add'), array('escape'=>false, 'title'=>'Add','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive">
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>Company Name</th>
                  <th>Email</th>

                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <?php $count=0; foreach($users as $user){ $count++;?> 
                    <tr>
                      <td><?php echo $count; ?></td>
                      <td><?php echo $user->company_name; ?></td>
                      <td><?php echo $user->user->email; ?></td>
                      <td><?php if($user->user->status==1){ echo '<span class="green">Active</span>';}else { echo '<span class="red">In Active</span>';} ?></td>
                      <td>
                          <?php
                              echo $this->Html->link('<i class=" fa fa-eye"> </i>', array('controller'=> 'SubAdmins','action'=>'view',base64_encode($user->id)), array('escape'=>false,'title'=>'View'));
                          ?>
                          &nbsp;&nbsp;
                          <?php
                              echo $this->Html->link('<i class="green fa fa-pencil"> </i>', array('controller'=> 'SubAdmins','action'=>'edit',base64_encode($user->id)), array('escape'=>false, 'title'=>'Edit'));
                          ?>
                          &nbsp;&nbsp;
                          <?php 
                            echo $this->Form->postLink(__('Delete'), ['action' => 'delete', base64_encode($user->user->id)], ['confirm' => __('Are you sure you want to delete this record? '),'id'=>'delPost'.$user->id]) 
                          ?>
                          <script type="text/javascript">
                            $(document).ready(function () {
                               $('#delPost<?php echo $user->id;?>').html('<i class="red fa fa-trash-o"></i>');
                            });   
                          </script>
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
            <!--<li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
            <li><?= $this->Paginator->numbers() ?></li>
            <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>-->
        </ul>
    </nav>
    
  </div>
  <!-- /#page-content-wrapper --> 
 
</div>