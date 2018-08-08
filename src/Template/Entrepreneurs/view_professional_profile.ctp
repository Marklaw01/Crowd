<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li class="active">Profile View</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Profile View</h1> 
              </div>
            </div>
            <div class='col-lg-6 col-md-6 col-sm-6'>
              <div class="profileName">
              <?php if(empty($startupId)){?>
                 <?php
                      $entrepre = '<i><img src="'.$this->request->webroot.'images/professional.png" alt=""></i>';
                      echo $this->Html->link( $entrepre .'ENTREPRENEUR', array('controller'=>'Entrepreneurs','action'=>'viewProfile',$viewUserId), array('escape'=>false,'class'=>'active'));
                  ?>
                  <?php
                      $entrepre = '<i><img src="'.$this->request->webroot.'images/users.png" alt=""></i>';
                      echo $this->Html->link( $entrepre .'CONTRACTOR', array('controller'=>'Contractors','action'=>'viewProfile',$viewUserId), array('escape'=>false,'class'=>'navbar-brand'));
                  ?>
               <?php } ?>     
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
                  $basic= $this->Url->build(["controller" => "Entrepreneurs","action" => "viewProfile",$viewUserId,$startupId]);
                  ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">BASIC</a>
                  </li>

                  <li role="presentation" class="active">
                    <?php //echo $this->Html->link("PROFESSIONAL",ARRAY('controller'=>'Entrepreneurs','action'=>'ProfessionalProfile'),ARRAY('class'=>"",'aria-controls'=>'about', 'role'=>'tab', 'data-toggle'=>'tab1'));
                    $profess= $this->Url->build(["controller" => "Entrepreneurs","action" => "viewProfessionalProfile",$viewUserId,$startupId]);
                    ?>
                    <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#professional" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">PROFESSIONAL</a>
                  </li>
                  <li role="presentation">
                  <?php //echo $this->Html->link("STARTUPS",ARRAY('controller'=>'Entrepreneurs','action'=>'ListStartup'),ARRAY('class'=>"",'aria-controls'=>'about', 'role'=>'tab', 'data-toggle'=>'tab1'));
                  $startu= $this->Url->build(["controller" => "Entrepreneurs","action" => "viewListStartup",$viewUserId,$startupId]);
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
                            
                          </div>
                 
                          <div class="basic-info">

                            <div class="profileHeading">
                                <h3><?php echo $name= $user['first_name'].' '.$user['last_name'];?></h3>    
                            </div>
                            <div class="clearfix"></div>
                            
                            <ul class="nav stars">
                              <?php echo $ratingStar;?>
                            </ul>

                            <div class="progress_section" style="display: none;">
                                <span class=""><?php echo $proPercentage;?>% Complete</span>
                                <div class="progress">
                                  <div class="progress-bar" role="progressbar" aria-valuenow="<?php echo $proPercentage;?>" aria-valuemin="0" aria-valuemax="100" style="width: <?php echo $proPercentage;?>%;">
                                    <span class="sr-only"><?php echo $proPercentage;?>% Complete</span>
                                </div>
                                </div>
                            </div>

                            
                            <!--<div class="links"> 
                              <a class="curveBtn blueBtn customBtn" href="#">FOLLOW</a>
                              <a class="curveBtn greenBtn customBtn" href="#">RATE ENTREPRENEUR</a>
                            </div>-->
                            <div class="links">
                            <?php 
                              if(!empty($viewUserId)){ ?>
                                <a class="chatIcon" href="#"><i class="fa fa-comments-o"></i> Chat</a>
                            <?php } ?>


                            <?php 
                              $excAward= $this->Url->build(["controller" => "Entrepreneurs","action" => "excellenceAwards",$viewUserId]);
                            ?>

                                <a class="award" href="<?php echo $excAward;?>"><i class="fa fa-trophy"></i>  Excellence Award</a>

                            </div>

                            <div class="links"> 
                            <?php 
                             if(!empty($viewUserId)){ 
                                  if($followStatus == 0){
                                      $folowTitle='Follow';
                                      $class='smallCurveBtn blueBtn customBtn custPad';
                                      $followLink= $this->Url->build(["controller" => "Entrepreneurs","action" => "followUser",$viewUserId]);
                                  }else{
                                      $folowTitle='Unfollow';
                                      $class='smallCurveBtn greenBtn customBtn custPadUnfol';
                                      $followLink= $this->Url->build(["controller" => "Entrepreneurs","action" => "unFollowUser",$viewUserId]);
                                  }
                            ?>
                                  <a href="#" title="<?php echo $folowTitle;?>" class="<?php echo $class;?>" onclick="location.href='<?php echo $followLink;?>'"><?php echo $folowTitle;?></a>
                            <?php } ?>

                              <?php
                                if(!empty($RatingStarupId)){ 
                                     echo $this->Html->link('RATE ENTREPRENEUR',['controller' => 'Entrepreneurs','action' => 'rateEntrepreneur',$viewUserId,$RatingStarupId],['class'=>'curveBtn greenBtn customBtn']);
                                }
                              ?>

                            </div>



                          </div>                          
                    </div>
                   
                       <div class="row">
                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              <div class="form-group">
                              <label>Company Name</label>
                                <span class="form-control">
                                   <?php 
                                   if(!empty($professional_user->company_name)){
                                      echo $professional_user->company_name; 
                                    }else {
                                      echo "Company Name";
                                    }    
                                   ?>
                                 </span>
                                  
                              </div>
                              <div class="form-group">
                              <label>Website Link</label>
                                  <span class="form-control">
                                   <?php 
                                   if(!empty($professional_user->website_link)){
                                      echo $professional_user->website_link; 
                                    }else {
                                      echo "Website Link";
                                    }    
                                   ?>
                                 </span>

                              </div>

                              <div class="form-group">
                              <label>Qualifications</label>
                                  <span class="form-control textArea">
                                    <?php
                                       $sqli= explode(',', $professional_user['qualifications']);
                                       $csqli=count($sqli);
                                          if(!empty($sqli[0])){
                                              for($i=0; $i<$csqli; $i++){
                                                    $slids=$sqli[$i];
                                                    echo $Qualifications[$slids];
                                                    if($i<$csqli-1){ echo ', ';}
                                              }
                                          }else {
                                              echo 'Qualifications';
                                          }
                                    ?>
                                 </span>
                                   
                              </div>
                              
                              <div class="form-group">
                              <label>Description</label>
                                  <span class="form-control textArea">
                                   <?php 
                                   if(!empty($professional_user->description)){
                                      echo $professional_user->description; 
                                    }else {
                                      echo "Description";
                                    }    
                                   ?>
                                 </span>
                                  
                              </div>
                              
                          </div>
                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              
                              <div class="form-group">
                              <label>Keywords</label>
                                  <span id="selectedResult" class="form-control textArea">
                                   <ul>
                                    <?php
                                       $skey= explode(',', $professional_user['keywords']);
                                       $cskey=count($skey);
                                          if(!empty($skey[0])){
                                              for($i=0; $i<$cskey; $i++){
                                                    $slids=$skey[$i];
                                                    //echo $Keywords[$slids].', ';id="selectedResult"
                                                    echo '<li id="sel_'.$slids.'"><a href="javascript:void(0)">'.$Keywords[$slids].'</a></li>';
                                              }
                                          }else {
                                              echo 'Keywords';
                                          }
                                    ?>
                                  </ul>  
                                 </span>
                                    
                              </div>
                              
                              <div class="form-group">
                              <label>Skills</label>
                                   <span class="form-control textArea">
                                    <?php
                                       $skl= explode(',', $professional_user['skills']);
                                       $cskl=count($skl);
                                          if(!empty($skl[0])){
                                              for($i=0; $i<$cskl; $i++){
                                                    $slids=$skl[$i];
                                                    echo $Skills[$slids];
                                                    if($i<$cskl-1){ echo ', ';}
                                              }
                                          }else {
                                              echo 'Skills';
                                          }
                                    ?>
                                 </span>
                                     
                              </div>
                               <div class="form-group">
                               <label>Industry Focus</label>
                                  <span class="form-control">
                                   <?php 
                                   if(!empty($professional_user->industry_focus)){
                                      echo $professional_user->industry_focus; 
                                    }else {
                                      echo "Industry Focus";
                                    }    
                                   ?>
                                 </span>
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
 $("#sidebar_username").html('<?php echo $logedUseName;?>');

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
        readURL(this);
    });




});

</script>
