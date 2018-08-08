<div id="page-content-wrapper">
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Add Startup 
          </h1>
          <?php
			     echo $this->Html->link('Back', array('controller'=> 'Startups','action'=>'index'), array('escape'=>false, 'title'=>'Back','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive-custom">
           
      <section id="page-content-wrapper">
          <div class="container-fluid">
  
              <div class="row">

                  <div class="col-md-2 col-sm-2 col-xs-12 pull-right Ver-advertise">

                  </div>
                 <?= $this->Form->create($startup,['id'=>'FormField','class'=>'col-md-10 col-sm-10 col-xs-12 registration_form']) ?>
       

                    <!-- header ends --> 
                    <div class="row">
                      <div class="col-lg-8 col-md-8 col-sm-12 ">
                        <div class="form-group">
                        <label>Startup Name</label>
                            <?php
                              echo $this->Form->input('name', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control','placeholder'=>'Startup Name','maxlength' => '50'));
                           ?>
                           <?php 
                                echo $this->Form->error('name', null, array('class' => 'error-message'));
                          ?>
                        </div>
                        <div class="form-group">
                        <label>Description</label>
                            <?php
                                echo $this->Form->input('description', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'maxlength' => '5000','placeholder'=>'Description', 'type'=>'textarea'));
                             ?>
                             <?php 
                                echo $this->Form->error('description', null, array('class' => 'error-message'));
                          ?>
                        </div>

                            <?php
                              //echo $this->Form->input('keywords', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'multiple' => '""', 'title'=>'Keywords','data-size'=>'10', 'type'=>'select','options' => $Keywords));
                            ?>

                        <div class="form-group">
                        <label>Select Keywords</label>
                            <span class="form-control textAreaKeyword" id="selectedResult">
                                <ul>
                                </ul>
                            </span>
                        
                            <?php
                                echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard','type'=>'select','title'=>'Keywords','multiple'=>false, 'size'=>'','empty'=>'Select Keyword', 'options'=>$Keywords));
                            ?>  
                            
                            <select name="keywords[]" multiple="" id="hiddenKey" style="display: none;">

                            </select>
                            <?php 
                              echo $this->Form->error('keywords', null, array('class' => 'error-message'));
                            ?>
                            <script type="text/javascript">
                                    $(function() {
                                      $("#standard").customselect();
                                    });
                                    function removeSelection(id){
                                      //alert(id);
                                      $('#selectedResult #sel_'+id).remove();
                                      $('#hiddenKey #sel_'+id).remove();
                                    }
                            </script>
                            
                        </div> 

                        <div class="form-group">
                        <label>Support Required</label>
                             <?php
                                echo $this->Form->input('support_required', ARRAY('label' => false,'error' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'Support Required'));
                             ?>
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

