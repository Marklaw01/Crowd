<div id="page-content-wrapper">
       <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
          <h1 class="page-header"><i class=" fa fa-arrow-circle-up"></i>Blog Settings 

          <a class="wp-admin" href="http://www.crowdbootstrap.net/wp-admin" target="_blank">Login to Wordpress Admin</a>
          </h1>
          <?php
           //echo $this->Html->link('Add Startup', array('controller'=> 'Startups','action'=>'add'), array('escape'=>false, 'title'=>'Edit','class'=>'btn redColor'));
          ?>
          <div class="table-responsive">
            <div class="" style="margin-bottom: 10px;">
              <ul id="tabbing" class="nav aboutTab nav-tabs" role="tablist">
                  <li role="presentation" >
                    <?php 
                      $basic= $this->Url->build(["controller" => "Blogs","action" => "index"]); 
                    ?>
                    <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">Blog List</a>
                  </li>

                  <li role="presentation" class="active">
                    <?php 
                      $profess= $this->Url->build(["controller" => "Blogs","action" => "blogSetting"]);
                    ?>
                    <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#professional" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">Blog Setting</a>
                    
                  </li>
                </ul>
            </div>
        </div>
        <section id="page-content-wrapper">
          <div class="container-fluid">
            <div class="row">
              <?= $this->Form->create($blogSetting,['id'=>'FormField','class'=>'col-md-10 col-sm-10 col-xs-12 registration_form']) ?>
                <!-- header ends --> 
                  <div class="row">
                    <div class="col-lg-12 col-md-8 col-sm-12 ">
                        <div class="form-group">
                          <label>No of blogs to be posted per day.</label>
                          <?php
                              echo $this->Form->input('limit_per_day', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'No of blogs to be posted per day.','maxlength' => '50','value'=>$limit_per_day));
                          ?>
                          <span style="color: rgb(196, 190, 190);">If its 0 it will not post any blog.</span>
                          <?php 
                              echo $this->Form->error('limit_per_day', null, array('class' => 'error-message'));
                          ?>
                        </div>

                        <div class="form-group">
                            <?= $this->Form->button('Save',['class'=> 'btn redColor  pull-right']) ?>
                        </div>
                      </div>
                    </div>
               <?= $this->Form->end() ?>  
                  

              </div>
          </div>
      <!-- /#page-content-wrapper --> 
      </section>


      </div>
    </div>

  </div>
  <!-- /#page-content-wrapper --> 
 
</div>