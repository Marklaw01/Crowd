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

                <li> <?php
                    echo $this->Html->link('Business Cards List', array('controller'=>'NetworkingOptions','action'=>'businessCardList'), array('escape'=>false));
                ?></li>
                <li class="active">Edit Business Card</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Edit Business Card </h1> 
              </div>
            </div>
           
            </div>
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="about-section">
                
                <div class="tab-content">
                <?= $this->Form->create($businessCard,['id'=>'FormField','enctype' => 'multipart/form-data']) ?>
                 <!-- 1Tab-->                 
                 <?php //pr($businessConnection);?>
                  
                  <div role="tabpanel" class="tab-pane active" id="basic">
                     <div class="row">
                          <div class="col-lg-8 col-md-8 col-sm-12">
                            
                          <div class="">
                            <div class="circle-img" >
                                  <?php
                                  if(empty($businessCardDetail->linkedin_image)){
                                    $data = $this->Custom->getContractorImage($user_id);
                                    ?>
                                    <?php if(!empty($data['image'])) { ?>
                                          <?php echo $this->Html->image('profile_pic/' .$data['image'],array('id'=>'blah','width'=>'','height'=>'')); ?>
                                    <?php }else { ?>
                                          <img id="blah" src="<?php echo $this->request->webroot;?>images/dummy-man.png" alt="">
                                    <?php } 
                                    }else {?>
                                      <?php if(!empty($businessCardDetail->linkedin_image)) { ?>
                                          <?php echo $this->Html->image($businessCardDetail->linkedin_image,array('id'=>'blah','width'=>'','height'=>'')); ?>
                                    <?php }else { ?>
                                          <img id="blah" src="<?php echo $this->request->webroot;?>images/dummy-man.png" alt="">
                                    <?php } 
                                    }?>
                                 
                                </div>                       
                          </div> 
                        <div class="form-group">
                          <b> <?php 
                            if(empty($businessCardDetail->linkedin_username)){
                              echo $this->Custom->contractorName($user_id); 
                            }else{
                              echo $businessCardDetail->linkedin_username;
                            }  ?></b>
                        </div>     
                              
                              <div class="form-group">
                              <label>User's Bio</label>
                                <?php
                                    echo $this->Form->input('user_bio', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'maxlength' => '50','placeholder'=>'Bio','value' => @$businessCardDetail->user_bio));
                                ?>
                                <?php 
                                    echo $this->Form->error('user_bio', null, array('class' => 'error-message'));
                                ?>
                              </div>
                                 
                              <div class="form-group">
                              <label>User's Interest</label>
                                <?php
                                  echo $this->Form->input('user_interest', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'maxlength' => '50','placeholder'=>'Interest Number','value' => @$businessCardDetail->user_interest));
                                ?>
                                <?php 
                                  echo $this->Form->error('user_interest', null, array('class' => 'error-message'));
                                ?>                           
                              </div>

                              <div class="form-group">
                              <label>Statement</label>
                               <?php
                                echo $this->Form->input('statement', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'maxlength' => '50','placeholder'=>'   Statement','value' => @$businessCardDetail->statement));
                               ?>
                              </div>
                              
                              <div class="">
                                <div class="rect-img" >
                                  <?php if(!empty($businessCardDetail->image)) { ?>
                                      <?php echo $this->Html->image('businesscards/' .$businessCardDetail->image,array('id'=>'blah','width'=>'','height'=>'')); ?>
                                  <?php }?>
                                  <input type="hidden" name="old_image" value="<?php echo $businessCardDetail->image; ?>" />
                                </div>                       
                              </div>

                              
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

                              
                              
                              
                              
                             
                          <div class='col-lg-12 col-md-12 col-sm-12 '>
                            <div class="form-group">
                              <div class="profileName alignBtn align_margin">
                                <?php    
                                  echo $this->Html->link('Back', array('controller'=>'NetworkingOptions','action'=>'businessCardList'), array('escape'=>false,'class'=>'active'));
                                ?>  


                               </div>
                               <?= $this->Form->button('Save',['class'=> 'customBtn blueBtn addMargin']) ?>
                               <div class="form-group alignBtn">
                                  
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

<script type="text/javascript">
  //Upload triger
  $('#campaign_image_browse').click(function(){ $('#campaign_image').trigger('click'); });
  $("#campaign_image").change(function(){
    var filename = $('#campaign_image').val();
    $('#filename_camp').html(filename);
  }); 

</script>