 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'SubAdmins','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('View Profile', array('controller'=>'SubAdmins','action'=>'viewProfile'), array('escape'=>false));
                ?></li>
                <li class="active">Edit Profile</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Edit Profile</h1> 
              </div>
            </div>
          </div>
          <!-- header ends -->
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="about-section">
                
                <div class="tab-content">
                 <!-- 1Tab-->
                  
                  <div role="tabpanel" class="tab-pane active" id="basic">
                  <?= $this->Form->create($subAdminDetails , ['enctype' => 'multipart/form-data','id'=>'FormField','class'=>'profile-basic']) ?>
                     
                      <div role="tabpanel" class="tab-pane active" id="professional">
                    <div class="profileView">
                          
                          <div class="circle-img" >
                            <?php if(isset($subAdminDetails->profile_image)) { ?>
                                  <?php echo $this->Html->image('subadmin_profile_image/' .$subAdminDetails->profile_image,array('id'=>'blah','width'=>'','height'=>'')); ?>
                            <?php }else { ?>
                                  <img id="blah" src="<?php echo $this->request->webroot;?>images/dummy-man.png" alt="">
                            <?php } ?>
                            <div id="OpenImgUpload" class="overlay">
                            <i class="fa fa-pencil"></i> </div>
                            <?php
                                echo $this->Form->input('profile_image', ARRAY('style'=>'display:none;', 'label' => false, 'div' => false,
                                    "class"=>"validate[checkFileType[jpg|jpeg|gif|JPG|png|PNG],checkFileSize[2000]] form-control",
                                    'id' => 'imgupload','type' => 'file'));
                            ?>
                          </div>
                              
                          </div>                          
                    </div>
                      
                       <div class="row">
                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              
                              <div class="form-group">
                              <label>Company</label>
                                <?php
                                  echo $this->Form->input('company_name', ARRAY('label' => false,
                                             'div' => false,'id' => '','placeholder'=>'Company name','class'=>'form-control', 'type'=>'text'));
                               ?>
                              </div>
                              
                              <div class="form-group">
                              <label>Overview</label>
                               <?php
                                  echo $this->Form->input('description', ARRAY('label' => false, 'div' => false,
                                             'type'=>'textarea','class' => 'form-control', 'id' => 'description',
                                             'placeholder'=>'Overview'));
                               ?>
                              </div>
                              
                              <div class="form-group">
                              <label>Company Keywords</label>
                               <?php
                                  $jpk = explode(',', $subAdminDetails->job_posting_keywords);
                                    echo $this->Form->input('job_posting_keywords', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '',
                                    'type'=>'select','title'=>'Company Keywords', 'data-size'=>'5', 'multiple'=>'""',
                                    'value'=>$jpk,'options'=>$JobPostingKeywords));
                               ?>
                              </div>
                                
                               <div class="form-group" style="display: none;"> 
                                    <div class="row upload-profile">
                                   
                                    <div class="col-lg-12 col-md-12 col-sm-12 ">
                                    <button  id="audio_button" class="audio_button" type="button">Audio</button>
                                    <span class="imgUpload alignCenter" id="audioUpload"></span>
                                     <?php
                                       echo $this->Form->input('audio', ARRAY('label' => false, 'div' => false,'type' => 'file',
                                                                              'style'=>'','id'=>'audio'));
                                     ?>
                                    </div>
                                    </div>
                               </div>
                               
                          </div>
                           
                          <div class="col-md-6 col-sm-6 col-xs-12"  style="display: none;"> 
                            
                            <div class="form-group">
                                    <div class="row upload-profile">
                                   
                                    <div class="col-lg-12 col-md-12 col-sm-12 ">
                                    <button  id="video_button" class="video_button" type="button">Video</button>
                                    <span class="imgUpload alignCenter" id="videoUpload"></span>
                                     <?php
                                       echo $this->Form->input('video', ARRAY('label' => false, 'div' => false,'type' => 'file',
                                                                              'style'=>'','id'=>'video'));
                                     ?>
                                    </div>
                                    </div>
                               </div>
                            
                              <div class="form-group">
                                    <div class="row upload-profile">
                                   
                                    <div class="col-lg-12 col-md-12 col-sm-12 ">
                                    <button  id="video_button" class="video_button" type="button">Document</button>
                                    <span class="imgUpload alignCenter" id="documentUpload"></span>
                                     <?php
                                       echo $this->Form->input('document', ARRAY('label' => false, 'div' => false,'type' => 'file',
                                                                              'style'=>'','id'=>'document'));
                                     ?>
                                    </div>
                                    </div>
                               </div>
                               
                              
                          </div>
                          
                          <div class="col-md-12 col-sm-12 col-xs-12">
                            <div class="form-group">
                              <?= $this->Form->button('Submit',['class'=> 'customBtn blueBtn  pull-right']) ?>
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
 <!-- /#page-content-wrapper --> 
<script>

$(document).ready(function () {
  
  $('.testpicker').datetimepicker({
    timepicker:false,
    maxDate: 0,
    format:'F d, Y',
    scrollInput: false
  });
  
  $(".testpicker").keypress(function(event) {event.preventDefault();});
  
  $("#FormField").validationEngine();
  
  $("#hireprice").click(function(){
      $('#showPrice').show();
      $('#custom_dollar').show();
      $(this).addClass('hide');
  });

    $('#showPrice').priceFormat({
          prefix: ''
    });

   
   $('#OpenImgUpload').click(function(){ $('#imgupload').trigger('click'); });
   
    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function (e) {
                $('#blah').attr('src', e.target.result);
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    $("#imgupload").change(function(){
        var ext = $('#imgupload').val().split('.').pop().toLowerCase();
        if($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) {
          $('<div id="custerro" class="message error" onclick="return closeError();">Invalid! These files extension are allowed: .jpg, .jpeg, .gif, .png</div>').insertBefore('.container-fluid');
        }else {
           readURL(this);
        }
    });

   
    });

function closeError(){
   $('.message').hide(); 
}
</script>