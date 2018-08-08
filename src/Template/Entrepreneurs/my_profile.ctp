 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li class="active">My Profile</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>My Profile</h1> 
              </div>
            </div>
            <div class='col-lg-6 col-md-6 col-sm-6'>
              <div class="profileName">
                  <?php
                      $entrepre = '<i><img src="'.$this->request->webroot.'images/professional.png" alt=""></i>';
                      echo $this->Html->link( $entrepre .'ENTREPRENEUR', array('controller'=>'Entrepreneurs','action'=>'myProfile'), array('escape'=>false,'class'=>'active'));
                  ?>
                  <?php
                      $entrepre = '<i><img src="'.$this->request->webroot.'images/users.png" alt=""></i>';
                      echo $this->Html->link( $entrepre .'CONTRACTOR', array('controller'=>'Contractors','action'=>'myProfile'), array('escape'=>false,'class'=>'navbar-brand'));
                  ?>
              </div>
            </div>
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="about-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav aboutTab nav-tabs" role="tablist">

                  <li role="presentation" class="active">
                  <?php //echo $this->Html->link("BASIC",ARRAY('controller'=>'Entrepreneurs','action'=>'MyProfile'),ARRAY('class'=>"focus",'aria-controls'=>'about', 'role'=>'tab', 'data-toggle'=>'tab1'));
                  $basic= $this->Url->build(["controller" => "Entrepreneurs","action" => "MyProfile"]);
                  ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">BASIC</a>
                  </li>

                  <li role="presentation">
                    <?php //echo $this->Html->link("PROFESSIONAL",ARRAY('controller'=>'Entrepreneurs','action'=>'ProfessionalProfile'),ARRAY('class'=>"",'aria-controls'=>'about', 'role'=>'tab', 'data-toggle'=>'tab1'));
                    $profess= $this->Url->build(["controller" => "Entrepreneurs","action" => "ProfessionalProfile"]);
                    ?>
                    <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#professional" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">PROFESSIONAL</a>
                  </li>
                  <li role="presentation">
                  <?php //echo $this->Html->link("STARTUPS",ARRAY('controller'=>'Entrepreneurs','action'=>'ListStartup'),ARRAY('class'=>"",'aria-controls'=>'about', 'role'=>'tab', 'data-toggle'=>'tab1'));
                  $startu= $this->Url->build(["controller" => "Entrepreneurs","action" => "ListStartup"]);
                  ?>
                   <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="scope" href="#startup" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $startu;?>'">STARTUPS</a>
                  </li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->                 
                 <?php //pr($user);?>
                  
                  <div role="tabpanel" class="tab-pane active" id="basic">
                  <?= $this->Form->create($user , ['enctype' => 'multipart/form-data','id'=>'FormField','class'=>'profile-basic']) ?>
                    <div class="profileView">
                          
                          <div class="circle-img" >
                            <?php if(!empty($user['image'])) { ?>
                                  <?php echo $this->Html->image('profile_pic/' .$user['image'],array('id'=>'blah','width'=>'','height'=>'')); ?>
                            <?php }else { ?>
                                  <img id="blah" src="<?php echo $this->request->webroot;?>images/dummy-man.png" alt="">
                            <?php } ?>
                            <div id="OpenImgUpload" class="overlay">
                            <i class="fa fa-pencil"></i> </div>
                            <?php
                                echo $this->Form->input('image', ARRAY('style'=>'display:none;', 'label' => false, 'div' => false, "class"=>"validate[checkFileType[jpg|jpeg|gif|JPG|png|PNG],checkFileSize[2000]] form-control", 'id' => 'imgupload','type' => 'file'));
                            ?>
                          </div>
                 
                          <div class="basic-info">

                            <div class="profileHeading">
                                <h3><?php echo $name= $user['first_name'].' '.$user['last_name'];?></h3>    
                            </div>
                            <div class="clearfix"></div>

                            <ul class="nav stars" style="display: none;">
                              <?php echo $ratingStar;?>
                            </ul>

                            <div class="progress_section">
                                <span class=""><?php echo $proPercentage;?>% Complete</span>
                                <div class="progress">
                                  <div class="progress-bar" role="progressbar" aria-valuenow="<?php echo $proPercentage;?>" aria-valuemin="0" aria-valuemax="100" style="width: <?php echo $proPercentage;?>%;">
                                    <span class="sr-only"><?php echo $proPercentage;?>% Complete</span>
                                </div>
                                </div>
                            </div>

                            <!--<p class="award"><img src="<?php //echo $this->request->webroot;?>images/awards.png" alt=""> Excellence Award</p>
                            <div class="links"> 
                              <a class="curveBtn blueBtn customBtn" href="#">FOLLOW</a>
                              <a class="curveBtn greenBtn customBtn" href="#">RATE ENTREPRENEUR</a>
                            </div>-->
                          </div>                          
                    </div>
                 
                       <div class="row">
                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              <div class="form-group">
                              <label>Bio</label>
                                <?php
                                  echo $this->Form->input('bio', ARRAY('label' => false, 'div' => false,'id' => '','placeholder'=>'Bio','class'=>'form-control','type'=>'textarea','maxlength' => '50000'));
                               ?>
                              </div>
                              
                              <div class="form-group">
                              <label>Email</label>
                                <span class="form-control readonly">
                                    <?php echo $userEmail; ?>
                                </span>                             
                              </div>
                              
                              <div class="form-group">
                                
                              <label>Phone No</label>
                                <?php
                                    echo $this->Form->input('phoneno', ARRAY('label' => false, 'div' => false, 'class' => 'form-control ', 'id' => 'phoneno1','type'=>'text','placeholder'=>'Phone No', 'maxlength' => '16'));
                                ?>
                               
                                <?php 
                                  echo $this->Form->error('phoneno', null, array('class' => 'error-message'));
                                ?>
                              </div>


                              <div class="form-group">
                              <label>DOB</label>
                               <?php
                                  echo $this->Form->input('date_of_birth', ARRAY('label' => false, 'div' => false, 'class' => 'testpicker form-control', 'id' => 'date_of_birth','placeholder'=>'DOB','maxlength' => '50'));
                               ?>
                              </div>   
                          </div>

                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              
                              <div class="form-group">
                              <label>First Name</label>
                                  <?php
                                    echo $this->Form->input('first_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[onlyLetterSp]]form-control form-control', 'id' => 'first_name','placeholder'=>'First Name','maxlength' => '50'));
                                  ?>
                                <?php
                                    //echo $this->Form->input('first_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[custom[onlyLetterSp]]form-control form-control', 'id' => '','placeholder'=>'Name'));
                                ?>
                              </div>
                              <div class="form-group">
                              <label>Last Name</label>
                                <?php
                                    echo $this->Form->input('last_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[custom[onlyLetterSp]]form-control form-control', 'id' => '','placeholder'=>'Last Name','maxlength' => '50'));
                                ?>
                              </div>
                              
                              <div class="form-group">
                                <label>Select Country</label>
                                <?php
                                    echo $this->Form->input('country_id', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'country','type'=>'select','title'=>'Select Country','data-size'=>'10', 'empty'=>'Select Country','default'=>$dc, 'options'=>$countrylist));
                                 ?>
                              </div>
                              <div class="form-group">
                              <label>State</label>
                                <?php 
                                    echo $this->Form->input('state_id', ARRAY('label' => false, 'div' => false, 'class' => ' selectpicker form-control show-tick', 'id' => 'state','title'=>'Select State','data-size'=>'10','type'=>'select', 'empty'=>'Select State', 'default'=>$ds, 'options'=>$statelist));
                                ?>
                              </div>
                              
                              <div class="form-group"> 
                              <label>My Interests</label> 
                                <?php
                                   echo $this->Form->input('my_interests', ARRAY('label' => false, 'div' => false, 'class' => 'validate[onlyLetterNumber]form-control form-control', 'id' => '','placeholder'=>'My Interests','maxlength' => '50'));
                                ?>
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

  /// Change Sidebar name 
 $("#sidebar_username").html('<?php echo $name;?>');

 
  $('.testpicker').datetimepicker({
    timepicker:false,
    maxDate: 0,
    format:'F d, Y',
    scrollInput: false
  });

  $("#FormField").validationEngine();
  $("#date").keypress(function(event) {event.preventDefault();});

// Ajax for states list     
  $('#country').change(function(){
    
    var val = $(this).val();
    $.ajax({ 
    url: "<?php echo $this->Url->build(["Controller" => "Enterpreneurs","action" => "getOptionsList"]);?>",
    data: {countryId:val},
    type : 'POST',
    cache: false,
    success: function(data) {
    $("#state").html(data);
    }
    
    });

   });

  $("#remove_image").on('click','.cross_image',function(){
    var image_id = $(this).attr('id');/* get the id of image */
    $.ajax({ 
    url: "<?php echo $this->Url->build(["Controller" => "Enterpreneurs","action" => "remove_image"]);?>",
    data: {image_id:image_id},
    type : 'POST',
    cache: false,
    success: function(data) {
        $('#remove_image').remove();
    }
       });


 });

///Image upload 
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
 //Functions Starts

//Functions Ends
</script>
