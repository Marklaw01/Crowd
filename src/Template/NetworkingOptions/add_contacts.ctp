
<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Messaging', array('controller'=>'Messages','action'=>'index'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Networking options', array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false));
                ?></li>
                <li class="active">Search Contact</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Add Contact</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs networkingTab" role="tablist">

                  <?php
                	$currStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "contacts"]);
                  ?>
                  <li role="presentation" ><a href="#current" aria-controls="current" role="tab" data-toggle="tab" onclick="location.href='<?php echo $currStr;?>'">Search Connection</a></li>

                  <?php
                	$compStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "addContacts"]);
                  ?>
                  <li role="presentation" class="active"><a href="#completed" aria-controls="completed" role="tab" data-toggle="tab" onclick="location.href='<?php echo $compStr;?>'">Add New Contacts</a></li>

                  <?php
                  $searStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "newUsers"]);
                  ?>
                  <li role="presentation"><a href="#search" aria-controls="search" role="tab" data-toggle="tab" onclick="location.href='<?php echo $searStr;?>'">Contacts</a></li> 

                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="current">
                    <?= $this->Form->create($businessContactData,['id'=>'FormField','enctype' => 'multipart/form-data']) ?>
                     <div class="row">
                      <div class="col-lg-8 col-md-8 col-sm-12 ">
                        <div class="form-group">
                          <label>Upload Image</label>
                          <div class="upload_frame ">
                              <div class="halfDivisionleft"> 
                                <span class="form-control">Image</span>
                              </div>
                              <div class="halfDivisionright">
                              <button type="button" id="campaign_image_browse" class="uploadBtn">Upload File</button>
                              <span id="filename_camp"></span>
                                <?php
                                    echo $this->Form->input('image', ARRAY('label' => false, 'id'=>'campaign_image', 'div' => false,'type' => 'file', 'style'=>'display:none;'));
                                 ?>
                              </div>
                          </div>
                        </div>    
                          
                        <div class="form-group">
                        <label>Name</label>
                           <?php
                                echo $this->Form->input('name', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'maxlength' => '50','placeholder'=>'Name'));
                             ?>
                           <?php 
                                echo $this->Form->error('name', null, array('class' => 'error-message'));
                          ?>
                        </div>
                        <div class="form-group">
                        <label>Phone Number</label>
                            <?php
                                echo $this->Form->input('phone', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'maxlength' => '50','placeholder'=>'Phone Number'));
                             ?>
                             <?php 
                                echo $this->Form->error('phone', null, array('class' => 'error-message'));
                          ?>
                        </div>
                        
                        <div class="form-group">
                          <label>Email</label>
                            <?php
                                echo $this->Form->input('email', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'maxlength' => '50','placeholder'=>'Email'));
                             ?>
                             <?php 
                                echo $this->Form->error('email', null, array('class' => 'error-message'));
                          ?>
                        </div>

                        <div class="form-group">
                        <label>Connection Type</label>
                            
                            <?php
                                //pr($businessConnection);
                                
                                echo $this->Form->input('connection_type_id', array('options'=>$businessConnection, 'label'=>false,'class' => 'form-control  scrollable custom-select',
                                  'empty'=>'Select connection','selected'=>'Your Value')); 

                            ?>  
                            
                           
                            <?php 
                              echo $this->Form->error('connection_type_id', null, array('class' => 'error-message'));
                            ?>
                        
                            
                        </div> 

                        <div class="form-group">
                        <label>Add Note</label>
                             <?php
                                echo $this->Form->input('note', ARRAY('label' => false,'error' => false, 'div' => false, 'class' => 'form-control', 'id' => '', 'maxlength' => '5000','placeholder'=>'Description', 'type'=>'textarea'));
                             ?>
                             <?php 
                                echo $this->Form->error('support_required', null, array('class' => 'error-message'));
                          ?>
                        </div>
                        <div class="form-group">
                            <?= $this->Form->button('Save',['class'=> 'customBtn blueBtn  pull-right']) ?>
                        </div>
                      </div>
                    </div>
		                <?= $this->Form->end() ?>      
                  </div>

                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="completed">    
                  </div>

                   <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="search">
                  </div>

                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /#page-content-wrapper --> 

<script type="text/javascript">
  //Upload triger
  $('#campaign_image_browse').click(function(){ $('#campaign_image').trigger('click'); });
  $("#campaign_image").change(function(){
    var filename = $('#campaign_image').val();
    $('#filename_camp').html(filename);
  }); 

</script>