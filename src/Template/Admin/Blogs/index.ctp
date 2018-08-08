<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class=" fa fa-arrow-circle-up"></i>Blog List 

          <a class="wp-admin" href="http://www.crowdbootstrap.net/wp-admin" target="_blank">Login to Wordpress Admin</a>
          </h1>
          <?php
			     //echo $this->Html->link('Add Startup', array('controller'=> 'Startups','action'=>'add'), array('escape'=>false, 'title'=>'Edit','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive">
            <div class="" style="margin-bottom: 10px;">
              <ul id="tabbing" class="nav aboutTab nav-tabs" role="tablist">
                  <li role="presentation" class="active">
                    <?php 
                      $basic= $this->Url->build(["controller" => "Blogs","action" => "index"]); 
                    ?>
                    <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">Blog List</a>
                  </li>

                  <li role="presentation">
                    <?php 
                      $profess= $this->Url->build(["controller" => "Blogs","action" => "blogSetting"]);
                    ?>
                    <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#professional" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">Blog Setting</a>
                    
                  </li>
                </ul>
            </div>
            <table class="table table-striped table-bordered">
              <thead>
                <tr>
                  <th>S.No</th>
                  <th>Blog Id</th>
                  <th>Blog Title</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
	              <?php $count=0; foreach($BlogPosts as $BlogPost){ $count++;?> 
		                <tr>
		                  <td><?php echo $count; ?></td>
                      <td><?php echo $BlogPost->blog_id; ?></td>
		                  <td><?php echo $BlogPost->blog_title; ?></td>
                      <td><?php echo $BlogPost->status; ?></td>
		                  <td>
		                    <a href="<?php echo $BlogPost->link;?>" target="_blank"><i class=" fa fa-eye"> </i></a>
				                &nbsp;&nbsp;&nbsp;

                        <?php 
                          echo $this->Form->postLink(__('Delete'), ['action' => 'delete', base64_encode($BlogPost->id)], ['confirm' => __('Are you sure you want to delete this record? '),'id'=>'delPost'.$count]) 
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