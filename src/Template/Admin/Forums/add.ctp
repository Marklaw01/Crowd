<div id="page-content-wrapper">
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Add Roadmap 
          </h1>
          <?php
			     echo $this->Html->link('Back', array('controller'=> 'Roadmaps','action'=>'index'), array('escape'=>false, 'title'=>'Back','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive-custom">
           
      <section id="page-content-wrapper">
          <div class="container-fluid">
  
              <div class="row">

                  <div class="col-md-2 col-sm-2 col-xs-12 pull-right Ver-advertise">

                  </div>
                 <?= $this->Form->create($roadmap,['id'=>'FormField','class'=>'col-md-10 col-sm-10 col-xs-12 registration_form']) ?>
       

                    <!-- header ends --> 
                    <div class="row">
                      <div class="col-lg-8 col-md-8 col-sm-12 ">
                        <div class="form-group">
                        <label>Roadmap Name</label>
                            <?php
                              echo $this->Form->input('name', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Roadmap Name','maxlength' => '50'));
                           ?>
                           <?php 
                                echo $this->Form->error('name', null, array('class' => 'error-message'));
                          ?>
                        </div>

                        <div class="form-group">
                        <label>Status</label>

                        <select name="status" class="form-control">
                          <option value="1">Show</option>
                          <option value="0">Hide</option>
                        </select> 
                          <?php 
                            echo $this->Form->error('support_required', null, array('class' => 'error-message'));
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

