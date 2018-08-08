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

                  <li role="presentation" class="active">
                  <?php //echo $this->Html->link("BASIC",ARRAY('controller'=>'Entrepreneurs','action'=>'MyProfile'),ARRAY('class'=>"focus",'aria-controls'=>'about', 'role'=>'tab', 'data-toggle'=>'tab1'));
                  $basic= $this->Url->build(["controller" => "Entrepreneurs","action" => "viewProfile",$viewUserId,$startupId]);
                  ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">BASIC</a>
                  </li>

                  <li role="presentation">
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
                  
                  <div role="tabpanel" class="tab-pane active" id="basic">
                  <?= $this->Form->create($user , ['enctype' => 'multipart/form-data','id'=>'FormField','class'=>'profile-basic']) ?>
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
                              <label>Bio</label>
                                 <span class="form-control textArea">
                                   <?php 
                                   if(!empty($user->bio)){
                                      echo $user->bio; 
                                    }else {
                                      echo "Bio";
                                    }    
                                   ?>
                                 </span>
                                <?php
                                  //echo $this->Form->input('bio', ARRAY('label' => false, 'div' => false,'id' => '','placeholder'=>'Bio','class'=>'form-control','type'=>'textarea'));
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
                                <span class="form-control">
                                  <?php 
                                   if(!empty($user->phoneno)){
                                      echo $user->phoneno; 
                                    }else {
                                      echo "Phone No";
                                    }    
                                   ?>
                                 </span>

                                <?php
                                   // echo $this->Form->input('phoneno', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'Phone Number','maxlength' => '50'));
                                ?>
                              </div>
                              <div class="form-group">
                              <label>DOB</label>
                                <span class="form-control" placeholder="DOB">
                                   <?php 
                                   if(!empty($user->date_of_birth)){
                                      echo $user->date_of_birth; 
                                    }else {
                                      echo "DOB";
                                    }    
                                   ?>
                                 </span>

                               <?php
                                  //echo $this->Form->input('date_of_birth', ARRAY('label' => false, 'div' => false, 'class' => 'testpicker form-control', 'id' => 'date_of_birth','placeholder'=>'DOB','maxlength' => '50'));
                               ?>
                              </div>

                              
                          </div>

                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              
                              <div class="form-group">
                              <label>First Name</label>
                                <span class="form-control">
                                   <?php 
                                   if(!empty($user->first_name)){
                                      echo $user->first_name; 
                                    }else {
                                      echo "First Name";
                                    }    
                                   ?>
                                 </span>
                                  <?php
                                    //echo $this->Form->input('first_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[onlyLetterSp]]form-control form-control', 'id' => 'first_name','placeholder'=>'First Name','maxlength' => '50'));
                                  ?>
                                <?php
                                    //echo $this->Form->input('first_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[custom[onlyLetterSp]]form-control form-control', 'id' => '','placeholder'=>'Name'));
                                ?>
                              </div>
                              <div class="form-group">
                              <label>Last Name</label>
                                <span class="form-control">
                                  <?php 
                                   if(!empty($user->last_name)){
                                      echo $user->last_name; 
                                    }else {
                                      echo "Last Name";
                                    }    
                                   ?>
                                 </span>

                                <?php
                                    //echo $this->Form->input('last_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[custom[onlyLetterSp]]form-control form-control', 'id' => '','placeholder'=>'Last Name','maxlength' => '50'));
                                ?>
                              </div>
                              
                              <div class="form-group">
                              <label>Country</label>
                                 <span class="form-control">
                                    <?php
                                          if(!empty($user->country_id)){
                                              echo $countrylist[$user->country_id];
                                          }else {
                                              echo 'Country';
                                          }
                                   ?>
                                </span>
                   
                                <?php
                                   // echo $this->Form->input('country_id', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'country','type'=>'select','title'=>'Select Country','data-size'=>'10', 'empty'=>'Select Country','default'=>$dc, 'options'=>$countrylist));
                                 ?>
                              </div>
                              <div class="form-group">
                              <label>State</label>
                                <span class="form-control">
                                  <?php
                                        if(!empty($user->state_id)){
                                            echo $statelist[$user->state_id];
                                        }else {
                                            echo 'State';
                                        }
                                 ?>
                                 </span>

                                <?php 
                                   // echo $this->Form->input('state_id', ARRAY('label' => false, 'div' => false, 'class' => ' selectpicker form-control show-tick', 'id' => 'state','title'=>'Select State','data-size'=>'10','type'=>'select', 'empty'=>'Select State', 'default'=>$ds, 'options'=>$statelist));
                                ?>
                              </div>
                              
                              <div class="form-group"> 
                              <label>My Interests</label>
                                <span class="form-control">
                                  <?php 
                                   if(!empty($user->my_interests)){
                                      echo $user->my_interests; 
                                    }else {
                                      echo "My Interests";
                                    }    
                                   ?>
                                 </span> 
                                <?php
                                   //echo $this->Form->input('my_interests', ARRAY('label' => false, 'div' => false, 'class' => 'validate[onlyLetterNumber]form-control form-control', 'id' => '','placeholder'=>'My Interests','maxlength' => '50'));
                                ?>
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
 $("#sidebar_username").html('<?php echo $logedUseName;?>');

});
 //Functions Starts

//Functions Ends
</script>
