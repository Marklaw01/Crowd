<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Lean Startup Roadmap 
          </h1>
          <?php
			     echo $this->Html->link('Add Milestone', array('controller'=> 'LeanRoadmaps','action'=>'add'), array('escape'=>false, 'title'=>'Add','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive">
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>Name</th>
                  <th>Color</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
	              <?php $count=0; foreach($Roadmaps as $Roadmap){ $count++;?> 
		                <tr>
		                  <td><?php echo $count; ?></td>
		                  <td><?php echo $Roadmap->title; ?></td>
                      <td><span class="" style="border-radius: 50%; background: <?php echo $Roadmap->color; ?>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td>
		                  <td><?php if($Roadmap->status == 1){ echo 'Shown';}else{echo 'Hidden';} ?></td>

		                  <td>
		                  <?php
				                echo $this->Html->link('<i class=" fa fa-pencil"> </i>', array('controller'=> 'LeanRoadmaps','action'=>'edit',base64_encode($Roadmap->id)), array('escape'=>false,'title'=>'Edit'));
				              ?>
				          
    				          <?php
    				            //echo $this->Html->link('<i class="red fa fa-trash"> </i>', array('controller'=> 'LeanRoadmaps','action'=>'delete',base64_encode($Roadmap->id)), array('escape'=>false, 'title'=>'Delete'));
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