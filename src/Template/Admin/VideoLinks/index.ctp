<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-blocks"></i>VideoLinks Details
          </h1>
          <?php
	          //echo $this->Html->link('Add New VideoLink', array('controller'=> 'VideoLinks','action'=>'add'), array('escape'=>false, 'title'=>'Edit','class'=>'btn redColor'));
	      ?>
          <div class="table-responsive">
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>link</th>
                  <!--<th>Description</th>-->
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
	              <?php $count=0; foreach($blocks as $block){ $count++;?> 
		                <tr>
		                  <td><?php echo $count; ?></td> 
		                  <td><?php echo $block->link; ?></td>
		                  <td>
		                  <?php
				            echo $this->Html->link('<i class=" fa fa-eye"> </i>', array('controller'=> 'VideoLinks','action'=>'view',base64_encode($block->id)), array('escape'=>false,'title'=>'View'));
				          ?>
				          <?php
				            echo $this->Html->link('<i class="green fa fa-pencil"> </i>', array('controller'=> 'VideoLinks','action'=>'edit',base64_encode($block->id)), array('escape'=>false, 'title'=>'Edit'));
				          ?>
				          <?php
				            //echo $this->Html->link('<i class="red fa fa-trash"> </i>', array('controller'=> 'blocks','action'=>'delete',base64_encode($block->id)), array('escape'=>false, 'title'=>'Delete'));
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