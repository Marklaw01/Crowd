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
                <li class="active">View Business Card</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Business Card Detail</h1> 
              </div>
            </div>
           
            </div>
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="about-section">
                
                <div class="tab-content">
                 <!-- 1Tab-->                 
                 <?php //pr($businessConnection);?>
                  
                  <div role="tabpanel" class="tab-pane active" id="basic">
                  <?= $this->Form->create($saveCardNote , ['enctype' => 'multipart/form-data','id'=>'FormField','class'=>'']) ?>
                    
                      
                       <div class="row">
                          <div class="col-md-6 col-sm-6 col-xs-12">
                              <div class="">
                                <div class="circle-img" >
                                  <?php
                                  $data = $this->Custom->getContractorImage($businessCardDetail->user['id']);
                                  ?>
                                  <?php if(!empty($data['image'])) { ?>
                                        <?php echo $this->Html->image('profile_pic/' .$data['image'],array('id'=>'blah','width'=>'','height'=>'')); ?>
                                  <?php }else { ?>
                                        <img id="blah" src="<?php echo $this->request->webroot;?>images/dummy-man.png" alt="">
                                  <?php } ?>
                                 
                                </div>                       
                            </div> 
                               
                            <div class="form-group">
                              <b> 
                                <?php 

                                echo $this->Custom->contractorName($businessCardDetail->user['id']);
                                //echo $businessCardDetail->user['first_name'].' '.$businessCardDetail->user['last_name']; 
                                ?>
                              </b>
                            </div> 
                              <div class="form-group">
                              <label>Interest</label>
                                <span class="form-control ">
                                    <?php 
                                     if(!empty($businessCardDetail->user_interest)){
                                        echo $businessCardDetail->user_interest; 
                                      }else {
                                        echo "User's Interest";
                                      }    
                                     ?>
                                </span>                             
                              </div>
                              
                              <div class="form-group">
                              <label>Bio</label>
                                 <span class="form-control textArea bioTextArea">
                                   <?php 
                                   if(!empty($businessCardDetail->user_bio)){
                                      echo $businessCardDetail->user_bio; 
                                    }else {
                                      echo "Bio";
                                    }    
                                   ?>
                                 </span>
                              </div>

                              <div class="form-group">
                              <label>Statement</label>
                                <span class="form-control">
                                  <?php 
                                   if(!empty($businessCardDetail->statement)){
                                      echo $businessCardDetail->statement; 
                                    }else {
                                      echo "User's statement";
                                    }    
                                   ?>
                                 </span>
                              </div>

                             
                              
                          </div>

                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              
                              <div class="">
                                <div class="rect-img" >
                                  <?php 
                                    if(!empty($businessCardDetail->image)) { 
                                        echo $this->Html->image('software/' .$businessCardDetail->image,array('id'=>'blah','width'=>'','height'=>'')); 
                                    }else{ 
                                      echo $this->Html->image('business_dummy.png',array('id'=>'blah','width'=>'','height'=>'200px'));
                                    }
                                  ?>
                                 
                                </div>                       
                            </div>
                            <div class="form-group">
                              <b>Business Card Image</b>   
                            </div>

                              
                              <div class="form-group">
                                  <label>Connection Type</label>

                                  <?php
                                  $data = $this->Custom->businessNetwork($businessCardDetail->user['id'],$LoggedUserId);
                                  if(empty($data)){
                                    echo $this->Form->input('connection_type_id', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'Connection','type'=>'select','title'=>'Select Connection Type','data-size'=>'10', 'empty'=>'Select Connection Type','default'=>'', 'options'=>$businessConnection));
                                  }else{
                                  ?>
                                  
                                    <?php 

                                      echo $this->Form->input('connection_type_id', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'Connection','type'=>'select','title'=>'Select Connection Type','data-size'=>'10', 'empty'=>'Select Connection Type','default'=>$data->connection_type_id, 'options'=>$businessConnection));

                                    ?>

                                    <span class="form-control" style="display: none;">
                                      <?php 
                                        if (isset($businessConnection[$data->connection_type_id])) 
                                        {
                                          //echo $businessConnection[$data->connection_type_id]; 
                                        }else{
                                          //echo "No Connection Type";
                                        }
                                      ?>
                                    </span>

                                    <?= $this->Form->button('Save',['class'=> 'customBtn greenBtn  saveType pull-right', 'name'=>'updateconnection']); ?>
                                    
                                <?php  
                                   }
                                ?>
                              </div>


                              <div class="form-group">
                                 <label>Add Note</label>
                                 <?php
                                      echo $this->Form->input('description', ARRAY('label' => false,'error' => false, 'div' => false, 'class' => 'form-control', 'id' => '', 'maxlength' => '5000','placeholder'=>'Add note here ', 'type'=>'textarea'));
                                   ?>
                                  <?php 
                                      echo $this->Form->error('description', null, array('class' => 'error-message'));
                                  ?>
                              </div>

                          </div>    
                             
                          <div class="col-md-12 col-sm-12 col-xs-12"> 
                              <div class="col-md-4 col-sm-4 col-xs-12"> 
                              </div>

                              <div class="col-md-8 col-sm-8 col-xs-12">       
                                <div class="form-group">

                                    <?php 
                                      $data = $this->Custom->businessNetwork($businessCardDetail->user['id'],$LoggedUserId);

                                      if(empty($data))
                                      {

                                        echo  $this->Form->button('Connect',['class'=> 'customBtn greenBtn  ', 'name'=>'connect']);
                                      }else{
                                        echo  $this->Form->button('Disconnect',['class'=> 'customBtn greenBtn  ', 'name'=>'disconnect']);
                                      }
                                    ?>

                                    <?= $this->Html->link('View Note', array('controller'=>'NetworkingOptions', 'action' => 'businessCardNoteList'), array('escape'=>false,'class'=>' blueBtn customBtn viewNotes')); ?>

                                    <?php
                                      echo $this->Form->input('connected_to', ARRAY ('type'=>'hidden', 'value'=>$businessCardDetail->user['id']));
                                   ?>

                                    
                                    <?= $this->Form->button('Add Note',['class'=> 'customBtn greenBtn  pull-right', 'name'=>'add_node']) ?>
                                </div>
                              </div>
                          </div>
                                 
                       </div>  
                  <?= $this->Form->end() ?>
                  </div>
                  <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane" id="professional">
                  </div>
                  <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane" id="startup">                  
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
 </div>
<style type="text/css">
  .blueBtn.customBtn.viewNotes {
    float: right;
    margin-left: 5%;
}
</style>