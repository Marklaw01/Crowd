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

                  <li role="presentation" >
                  <?php //echo $this->Html->link("BASIC",ARRAY('controller'=>'Entrepreneurs','action'=>'MyProfile'),ARRAY('class'=>"focus",'aria-controls'=>'about', 'role'=>'tab', 'data-toggle'=>'tab1'));
                  $basic= $this->Url->build(["controller" => "Entrepreneurs","action" => "MyProfile"]);
                  ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">BASIC</a>
                  </li>

                  <li role="presentation" class="active">
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
                  <?= $this->Form->create($professional_user , ['enctype' => 'multipart/form-data','id'=>'FormField','class'=>'profile-basic']) ?>
                  <!--  1Tab -->
                  <div role="tabpanel" class="tab-pane active" id="professional">
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

                           <!-- <p class="award"><img src="<?php //echo $this->request->webroot;?>images/awards.png" alt=""> Excellence Award</p>
                            <div class="links"> 
                              <a class="curveBtn blueBtn customBtn" href="#">FOLLOW</a>
                              <a class="curveBtn greenBtn customBtn" href="#">RATE ENTREPRENEUR</a>
                            </div>-->
                          </div>                          
                    </div>
                   
                       <div class="row">
                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              <div class="form-group">
                              <label>Company Name</label> 
                                  <?php
                                    echo $this->Form->input('company_name', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','type'=>'text','placeholder'=>'Company Name'));
                                  ?>
                              </div>
                              <div class="form-group">
                              <label>Website Link</label> 
                                  <?php
                                    echo $this->Form->input('website_link', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','type'=>'text','placeholder'=>'Website Link'));
                                  ?>
                              </div>
                              <div class="form-group">
                              <label>Description</label> 
                                  <?php
                                    echo $this->Form->input('description', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','type'=>'textarea','placeholder'=>'Description'));
                                  ?>
                              </div>
                              
                          </div>
                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              
                             
                                  <?php
                                   //$skey= explode(',', $professional_user['keywords']);
                                   // echo $this->Form->input('keywords', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','title'=>'Keywords', 'data-size'=>'5', 'multiple'=>'""','value'=>$skey, 'options'=>$Keywords));
                                  ?>   
                             

                              <div class="form-group">
                              <label>Select Keywords</label> 
                                <span class="form-control textAreaKeyword" id="selectedResult">
                                    <ul>
                                    <?php 
                                    $skey= explode(',', $professional_user['keywords']);
                                    $cc =count($skey);
                                        if(!empty($skey[0])){
                                              for($vi=0; $vi<$cc; $vi++){
                                                    $slids=$skey[$vi];
                                                    //echo $slids;
                                                    //echo $Keywords[$slids];
                                                    echo '<li id="sel_'.$slids.'"><a onClick="removeSelection('.$slids.')" href="javascript:void(0)">'.$Keywords[$slids].'<i class="fa fa-close"></i></a></li>';
                                              }
                                          }
                                    ?>
                                       
                                    </ul>
                                </span>
                            
                                <?php
                                  $cc =count($skey);
                                    echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard','type'=>'select','title'=>'Keywords','multiple'=>false, 'size'=>'','empty'=>'Select Keyword', 'options'=>$Keywords));
                                ?>  
                                
                                <select name="keywords[]" multiple="" id="hiddenKey" style="display: none;">
                                <?php
                                  if(!empty($skey[0])){
                                         for($i=0;$i<$cc;$i++){?>
                                             <option id="sel_<?php echo $skey[$i]?>" selected="selected" value="<?php echo $skey[$i]?>"></option>
                                         <?php }?>
                                  <?php }?> 
                                </select>
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
                              <label>Qualifications</label> 
                                  <?php  
                                  $sqli= explode(',', $professional_user['qualifications']);
                                    echo $this->Form->input('qualifications', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','title'=>'Qualifications', 'data-size'=>'5', 'value'=>$sqli, 'multiple'=>'""', 'options'=>$Qualifications));
                                  ?>  
                              </div>
                              <div class="form-group">
                              <label>Skills</label>
                                  <?php
                                  $skl= explode(',', $professional_user['skills']);
                                    echo $this->Form->input('skills', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','title'=>'Skills', 'data-size'=>'5', 'multiple'=>'""','value'=>$skl, 'options'=>$Skills));
                                  ?>    
                              </div>
                               <div class="form-group">
                               <label>Industry Focus</label>
                                   <?php
                                      echo $this->Form->input('industry_focus', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'Industry Focus','maxlength' => '50'));
                                   ?>
                              </div>
                                  
                          </div>
                          <div class="col-md-12 col-sm-12 col-xs-12">
                            <div class="form-group">
                              <?= $this->Form->button('Submit',['class'=> 'customBtn blueBtn  pull-right']) ?>
                            </div>
                          </div>       
                       </div>   
                 
                  </div>

                  <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane" id="basic">
                  </div>
                  <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane" id="startup">                  
                  </div>
                  <?= $this->Form->end() ?>
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
function closeError(){
   $('.message').hide(); 
}
</script>
