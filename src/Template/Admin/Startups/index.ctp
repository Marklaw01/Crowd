<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class=" fa fa-arrow-circle-up"></i>Startups 
          </h1>
          <?php
			     //echo $this->Html->link('Add Startup', array('controller'=> 'Startups','action'=>'add'), array('escape'=>false, 'title'=>'Edit','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive">
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>Name</th>
                  <th>Entrepreneur</th>
                  <th>Approve</th>
                  <th>Actions</th>
                  <th>Profile</th>
                </tr>
              </thead>
              <tbody>
	              <?php $count=0; foreach($Startups as $Startups){ $count++;?> 
		                <tr>
		                  <td><?php echo $count; ?></td>
		                  <td><?php echo $Startups->name; ?></td>

		                  <td><?php if(!empty($Startups->user->entrepreneur_basic)){echo $Startups->user->entrepreneur_basic->first_name.' '.$Startups->user->entrepreneur_basic->last_name;}else {echo $Startups->user->first_name.' '.$Startups->user->last_name;} ?></td>

		                  <td>

                        <?php //if(($Startups->questionnaire_status == 1) && ($Startups->startup_profile_status == 1)){ echo 'Yes';}else{echo 'No';} ?>


                        <?php
                        if($Startups->status == 0){

                          echo $this->Html->link('Approve', array('controller'=> 'Startups','action'=>'approve',base64_encode($Startups->id)), array('escape'=>false, 'title'=>'Approve'));
                          
                          echo ' / ';
                         
                          echo $this->Html->link('Disapprove', array('controller'=> 'Startups','action'=>'disapprove',base64_encode($Startups->id)), array('escape'=>false, 'title'=>'Disapprove', 'class'=>'red'));
                        }else if($Startups->status == 1) {
                          echo 'Approved';
                        }else{
                          echo 'Disapproved';
                        } 
                        ?>

                      </td>

		                  <td>
		                  <?php
				                echo $this->Html->link('<i class=" fa fa-eye"> </i>', array('controller'=> 'Startups','action'=>'overview',base64_encode($Startups->id)), array('escape'=>false,'title'=>'View'));
				              ?>
				              &nbsp;
    				          <?php
    				            //echo $this->Html->link('<i class="red fa fa-trash"> </i>', array('controller'=> 'Startups','action'=>'delete',base64_encode($Startups->id)), array('escape'=>false, 'title'=>'Delete'));
    				          ?>
		                  
		                  </td>

                      <td>

                        <?php 

                          $filePath = $this->Custom->getStartupProfile($Startups->id); 

                          if(!empty($filePath)){
                        ?>
                          <a href="<?php echo $this->request->webroot; ?>img/startup_profile_docs/<?php echo $filePath;?>" target="_blank"> View Profile </a>
                        <?php } ?>
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