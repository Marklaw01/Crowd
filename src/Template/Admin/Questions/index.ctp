<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Security Questions 
          </h1>
          <?php
			     echo $this->Html->link('Add Questions', array('controller'=> 'Questions','action'=>'add'), array('escape'=>false, 'title'=>'Add','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive">
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>Name</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
	              <?php $count=0; foreach($Roadmaps as $Roadmap){ $count++;?> 
		                <tr>
		                  <td><?php echo $count; ?></td>
		                  <td><?php echo $Roadmap->name; ?></td>

		                  <td><?php if($Roadmap->status == 1){ echo 'Shown';}else{echo 'Hidden';} ?></td>

		                  <td>
		                  <?php
				                echo $this->Html->link('<i class=" fa fa-pencil"> </i>', array('controller'=> 'Questions','action'=>'edit',base64_encode($Roadmap->id)), array('escape'=>false,'title'=>'Edit'));
				              ?>
                      &nbsp;&nbsp;
                      <?php 
                        echo $this->Form->postLink(__('Delete'), ['action' => 'delete', base64_encode($Roadmap->id)], ['confirm' => __('Are you sure you want to delete this record? '),'id'=>'delPost'.$count]) 
                      ?>
                      <script type="text/javascript">
                        $(document).ready(function () {
                           $('#delPost<?php echo $count;?>').html('<i class="red fa fa-trash-o"></i>');
                        });   
                      </script>
				          
    				          <?php
    				            //echo $this->Html->link('<i class="red fa fa-trash"> </i>', array('controller'=> 'Questions','action'=>'delete',base64_encode($Roadmap->id)), array('escape'=>false, 'title'=>'Delete'));
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