<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class=" fa fa-sticky-note-o"></i>Pages 
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