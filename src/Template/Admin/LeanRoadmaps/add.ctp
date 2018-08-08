<div id="page-content-wrapper">
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Add Lean Milestone 
          </h1>
          <?php
			     echo $this->Html->link('Back', array('controller'=> 'LeanRoadmaps','action'=>'index'), array('escape'=>false, 'title'=>'Back','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive-custom">
           
      <section id="page-content-wrapper">
          <div class="container-fluid">
  
              <div class="row">

                  <div class="col-md-2 col-sm-2 col-xs-12 pull-right Ver-advertise">

                  </div>
                 <?= $this->Form->create($roadmap,['id'=>'FormField','enctype' => 'multipart/form-data','class'=>'col-md-10 col-sm-10 col-xs-12 registration_form']) ?>
       

                    <!-- header ends --> 
                    <div class="row">
                      <div class="col-lg-12 col-md-8 col-sm-12 ">

                        <div class="form-group">
                        <label>Title</label>
                            <?php
                              echo $this->Form->input('title', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Milestone Name','maxlength' => '50'));
                           ?>
                           <?php 
                                echo $this->Form->error('title', null, array('class' => 'error-message'));
                           ?>
                        </div>

                        <div class="form-group">
                        <label>Description</label>
                            <?php
                              echo $this->Form->input('description', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea', 'class' => 'form-control','placeholder'=>'Milestone Name','maxlength' => '50'));
                           ?>
                           <?php 
                                echo $this->Form->error('description', null, array('class' => 'error-message'));
                          ?>
                        </div>

                        <div class="form-group">
                        <label>Position</label>

                        <select name="position" class="form-control">
                          <option value="R1">Row 1</option>
                          <option value="R2">Row 2</option>
                          <option value="R3">Row 3</option>
                          <option value="R4">Row 4</option>
                        </select> 
                          <?php 
                            echo $this->Form->error('position', null, array('class' => 'error-message'));
                          ?>
                        </div>

                        <div class="form-group">
                        <label>Color</label>
                            <?php
                              echo $this->Form->input('color', ARRAY('label' => false, 'div' => false,'error' => false,'type'=>'color','value'=>'#E8A514', 'class' => 'form-control','placeholder'=>'Color','maxlength' => '50'));
                           ?>
                           <?php 
                                echo $this->Form->error('color', null, array('class' => 'error-message'));
                          ?>
                        </div>

                        <div class="form-group">
                        <label>Status</label>

                        <select name="status" class="form-control">
                          <option value="1">Show</option>
                          <option value="0">Hide</option>
                        </select> 
                          <?php 
                            echo $this->Form->error('status', null, array('class' => 'error-message'));
                          ?>
                        </div>

                        <div class="form-group">
                        <label>Sample Doc</label>
                        <?php
                            echo $this->Form->input('sample_doc', ARRAY('label' => false, 'id'=>'sample_doc', 'div' => false,'type' => 'file'));
                         ?>
                         <?php 
                            echo $this->Form->error('sample_doc', null, array('class' => 'error-message'));
                          ?>
                        </div> 

                        <div class="form-group">
                        <label>Template</label>
                        <?php
                            echo $this->Form->input('template_link', ARRAY('label' => false, 'id'=>'template_link', 'div' => false,'type' => 'file'));
                         ?>
                         <?php 
                            echo $this->Form->error('template_link', null, array('class' => 'error-message'));
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
  </div>
  <!-- /#page-content-wrapper --> 
</div>

