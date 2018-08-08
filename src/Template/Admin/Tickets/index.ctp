<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class=" fa fa-ticket"></i>Forum Abuse 
          </h1>
          <?php
			     //echo $this->Html->link('Add Campaigns', array('controller'=> 'Campaigns','action'=>'add'), array('escape'=>false, 'title'=>'Add','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive">
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>Forum Name</th>
                  <th>Forum Owner</th>
                  <th>Reported By</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
              <?php $c=0; foreach($Forums as $forum){ $c++?>
                <tr>
                  <td><?php echo $c; ?></td>
                  <td><?php echo $forum->forum->title;?></td>
                  <td><?php echo $forum->forum->user->first_name.' '.$forum->forum->user->last_name;?></td>
                  <td><?php echo $forum->user->first_name.' '.$forum->user->last_name;?></td>
                  <td><?php if($forum->status == 1){echo '<span style="color : #056a1f;">Resolved </span>';}else{echo 'In Progress';}?></td>
                  <td><?php 
                        echo $this->Html->link('<i class=" fa fa-eye"> </i>', array('controller'=> 'Tickets','action'=>'view',base64_encode($forum->id)), array('escape'=>false,'title'=>'View'));
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
            <!--<li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
            <li><?= $this->Paginator->numbers() ?></li>
            <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>-->
        </ul>
    </nav>
    
  </div>
  <!-- /#page-content-wrapper --> 
 
</div>