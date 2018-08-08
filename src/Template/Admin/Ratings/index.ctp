<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class=" fa fa-star"></i>Ratings 
          </h1>
          <?php
			     //echo $this->Html->link('Add Campaigns', array('controller'=> 'Campaigns','action'=>'add'), array('escape'=>false, 'title'=>'Add','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive admin_settings">
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>Given By</th>
                  <th>Given To</th>
                  <th>Stars</th>
                  <th>Description</th>
                </tr>
              </thead>
              <tbody>
	              <?php $i=0;  foreach ($Ratings as $key => $value) { $i++;?>
                  <tr>
                    <td><?php echo $i;?></td>
                    <td><?php echo $this->Custom->contractorName($value->given_by); ?></td>
                    <td><?php echo $this->Custom->contractorName($value->given_to); ?></td>
                    <td><?php for($j=0; $j<$value->rating_star;$j++){ echo '<i class=" fa fa-star"></i>';}?></td>
                    <td><?php echo $value->description; ?></td>
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