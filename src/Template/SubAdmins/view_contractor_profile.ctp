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
               
            </div>
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="about-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav aboutTab nav-tabs" role="tablist">
                
                  <li role="presentation" class="active">
                    <?php
                      $basic= $this->Url->build(["controller" => "SubAdmins","action" => "viewContractorProfile",$viewUserId]); ?>
                      <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">BASIC</a>
                    <?php ?>
                  </li>

                  <li role="presentation">
                  <?php 
                    $profess= $this->Url->build(["controller" => "SubAdmins","action" => "viewProfessionalProfile",$viewUserId]);
                  ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#professional" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">PROFESSIONAL</a>
                    
                  </li>
                  <li role="presentation">
                  <?php
                  $startu= $this->Url->build(["controller" => "SubAdmins","action" => "viewListStartup",$viewUserId]);
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
                           
                            <?php  $price= $user['price']; 
                                   $finalPrice= number_format((float)$price, 2, '.', '');
                            ?>

                             <div class="profileHeading">
                                <h3><?php echo $user['first_name'].' '.$user['last_name'];?> </h3>
                                <div class="profileHeadingRight">
                                    <a href="javascript:void(0);" id="hireprice" class="hirePrice"> 
                                      $<?php echo $this->Number->precision($finalPrice,2);?>/HR
                                    </a> 
                                </div>
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

                            <div class="links">
                            <?php 
                              if(!empty($viewUserId)){ ?>
                                <a class="chatIcon" href="#"><i class="fa fa-comments-o"></i> Chat</a>
                            <?php } ?>


                            <?php 
                              //$excAward= $this->Url->build(["controller" => "Contractors","action" => "excellenceAwards",$viewUserId]);
                            ?>
                              
                                <!--<a class="award" href="<?php echo $excAward;?>"><i class="fa fa-trophy"></i>  Excellence Award</a>-->

                            </div>

                            <div class="links"> 
                              
                              <?php
                                if(!empty($RatingStarupId)){ 
                                     echo $this->Html->link('RATE Contractor',['controller' => 'Contractors','action' => 'rateContractor',$viewUserId,$RatingStarupId],['class'=>'curveBtn greenBtn customBtn']);
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
                              </div>
                              <div class="form-group">
                              <label>Email</label>
                                <span class="form-control readonly">
                                    <?php echo $userEmail; ?>
                                </span>                             
                              </div>
                              
                              <div class="form-group">
                              <label>Phone Number</label>
                                 <span class="form-control">
                                  <?php 
                                   if(!empty($user->phoneno)){
                                      echo $user->phoneno; 
                                    }else {
                                      echo "Phone Number";
                                    }    
                                   ?>
                                 </span>
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
