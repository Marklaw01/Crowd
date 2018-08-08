<div id="page-content-wrapper">
    <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
           <h1 class="page-header"><i class=" fa fa-gear"></i>Settings 
           </h1>
           <?php
			      //echo $this->Html->link('Add Campaigns', array('controller'=> 'Campaigns','action'=>'add'), array('escape'=>false, 'title'=>'Add','class'=>'btn redColor'));
		       ?>
        </div>
      </div>
      <div class=" admin_settings"> 
            <section id="page-content-wrapper">
              <div class="container-fluid">
                  <div class="row">
                    <ul id="tabbing" class="nav aboutTab nav-tabs" role="tablist">
                        <li role="presentation" class="active">
                          <?php 
                            $basic= $this->Url->build(["controller" => "Settings","action" => "index"]); 
                          ?>
                          <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">Star</a>
                        </li>

                        <li role="presentation">
                          <?php 
                            $profess= $this->Url->build(["controller" => "Settings","action" => "profileSetting"]);
                          ?>
                          <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#professional" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">Default Setting</a>
                          
                        </li>
                      </ul>
                  </div>
                  <div class="row table-responsive-custom">
                      <?= $this->Form->create($settings,['id'=>'FormField','class'=>'', 'method'=>'post']) ?>

                        <div class="row form-group">
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <label>One Star&nbsp;(<i class=" fa fa-star"></i>) :</label>
                            <?php
                              echo $this->Form->input('one', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'One Star','maxlength' => '5000'));
                            ?>
                            <?php 
                                echo $this->Form->error('one', null, array('class' => 'error-message'));
                            ?>
                             
                          </div>
                        </div>

                        <div class="row form-group">
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <label>Two Star&nbsp;(<i class=" fa fa-star"></i><i class=" fa fa-star"></i>):</label>
                            <?php
                              echo $this->Form->input('two', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Two Star','maxlength' => '5000'));
                            ?>
                            <?php 
                                echo $this->Form->error('two', null, array('class' => 'error-message'));
                            ?>
                                                
                          </div>
                        </div>
                        
                         <div class="row form-group">
                          
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <label>Three Star&nbsp;(<i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i>):</label>
                            <?php
                              echo $this->Form->input('three', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Three Star','maxlength' => '5000'));
                            ?>
                            <?php 
                                echo $this->Form->error('three', null, array('class' => 'error-message'));
                            ?>
                            
                          </div>
                        </div>

                        <div class="row form-group">
                          
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <label>Four Star&nbsp;(<i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i>):</label>
                            <?php
                              echo $this->Form->input('four', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Four Star','maxlength' => '5000'));
                            ?>
                            <?php 
                                echo $this->Form->error('four', null, array('class' => 'error-message'));
                            ?>
                            
                          </div>
                        </div>
                        <div class="row form-group">
                          
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <label>Five Star&nbsp;(<i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i>):</label>
                            
                            <?php
                              echo $this->Form->input('five', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Five Star','maxlength' => '5000'));
                            ?>
                            <?php 
                                echo $this->Form->error('five', null, array('class' => 'error-message'));
                            ?>
                            
                          </div>

                        </div>
                        <div class="row form-group">
                          
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <label>Six Star&nbsp;(<i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i>):</label>
                            
                            <?php
                              echo $this->Form->input('six', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Six Star','maxlength' => '5000'));
                            ?>
                            <?php 
                                echo $this->Form->error('six', null, array('class' => 'error-message'));
                            ?>
                            
                          </div>

                        </div>

                        <div class="row form-group">
                          
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <label>Seven Star&nbsp;(<i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i>):</label>
                            
                            <?php
                              echo $this->Form->input('seven', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Seven Star','maxlength' => '5000'));
                            ?>
                            <?php 
                                echo $this->Form->error('seven', null, array('class' => 'error-message'));
                            ?>
                            
                          </div>

                        </div>

                        <div class="row form-group">
                          
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <label>Eight Star&nbsp;(<i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i>):</label>
                            
                            <?php
                              echo $this->Form->input('eight', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Eight Star','maxlength' => '5000'));
                            ?>
                            <?php 
                                echo $this->Form->error('eight', null, array('class' => 'error-message'));
                            ?>
                            
                          </div>

                        </div>

                        <div class="row form-group">
                          
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <label>Nine Star&nbsp;(<i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i>):</label>
                            
                            <?php
                              echo $this->Form->input('nine', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Nine Star','maxlength' => '5000'));
                            ?>
                            <?php 
                                echo $this->Form->error('nine', null, array('class' => 'error-message'));
                            ?>
                            
                          </div>

                        </div>

                        <div class="row form-group">
                          
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <label>Ten Star&nbsp;(<i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i><i class=" fa fa-star"></i>):</label>
                            
                            <?php
                              echo $this->Form->input('ten', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Ten Star','maxlength' => '5000'));
                            ?>
                            <?php 
                                echo $this->Form->error('ten', null, array('class' => 'error-message'));
                            ?>
                            
                          </div>

                        </div>
                        <div class="form-group">
                          <div class="col-md-6 col-sm-6 col-xs-12">
                            <?= $this->Form->button('Save',['class'=> 'btn redColor  pull-right']) ?>
                          </div>  
                        </div>
                      <?= $this->Form->end() ?>   
                  </div>
              </div>
              <!-- /#page-content-wrapper --> 
            </section>
          </div>

 	    
  </div>
  <!-- /#page-content-wrapper --> 
</div>