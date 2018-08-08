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
             
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="about-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav aboutTab nav-tabs" role="tablist">

                  <li role="presentation">
                  <?php //echo $this->Html->link("BASIC",ARRAY('controller'=>'contractors','action'=>'MyProfile'),ARRAY('class'=>"focus",'aria-controls'=>'about1', 'role'=>'tab1', 'data-toggle'=>'tab1'));
                  $basic= $this->Url->build(["controller" => "SubAdmins","action" => "viewContractorProfile",$viewUserId,$startupId]);
                  ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">BASIC</a>

                  </li>

                  <li role="presentation" class="active">
                    <?php //echo $this->Html->link("PROFESSIONAL",ARRAY('controller'=>'contractors','action'=>'ProfessionalProfile'),ARRAY('class'=>"",'aria-controls'=>'about1', 'role'=>'tab1', 'data-toggle'=>'tab1'));
                    $profess= $this->Url->build(["controller" => "SubAdmins","action" => "viewProfessionalProfile",$viewUserId,$startupId]);
                    ?>

                    <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#professional" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">PROFESSIONAL</a>
                  </li>
                  <li role="presentation">
                  <?php //echo $this->Html->link("STARTUPS",ARRAY('controller'=>'startups','action'=>'ListStartup'),ARRAY('class'=>"",'aria-controls'=>'about1', 'role'=>'tab1', 'data-toggle'=>'tab1'));
                    $startu= $this->Url->build(["controller" => "SubAdmins","action" => "viewListStartup",$viewUserId]);
                  ?>

                   <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="scope" href="#startup" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $startu;?>'">STARTUPS</a>
                  </li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->                 
                 <?php //pr($user);?>
                  
                  <!--  1Tab -->
                  <div role="tabpanel" class="tab-pane active" id="professional">
                    <?= $this->Form->create($professional_user , ['enctype' => 'multipart/form-data','id'=>'FormField','class'=>'profile-basic']) ?>
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
                              //$excAward= $this->Url->build(["controller" => "Contractors","action" => "excellenceAwards",$viewUserId]);
                            ?>

                                <!--<a class="award" href="<?php echo $excAward;?>"><i class="fa fa-trophy"></i>  Excellence Award</a>-->

                            </div>
                              
                          </div>                          
                    </div>
                  
                       <div class="row">
                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              <div class="form-group">
                              <label>Experience</label>
                                <span class="form-control">
                                    <?php
                                          if(!empty($professional_user->experience_id)){
                                              echo $Experiences[$professional_user->experience_id];
                                          }else {
                                              echo 'Experience';
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
                                <label>Preferred Startup Stage</label>
                                 <span class="form-control">
                                    <?php
                                       $sstpSg= explode(',', $professional_user['startup_stage']);
                                       $cstp=count($sstpSg);
                                          if(!empty($sstpSg[0])){
                                              for($i=0; $i<$cstp; $i++){
                                                    $slidss=$sstpSg[$i];
                                                    echo $PrefferStartups[$slidss];
                                                    if($i<$cstp-1){ echo ', ';}
                                              }
                                          }else {
                                              echo 'Preferred Startup Stage';
                                          }
                                    ?>

                                    <?php
                                          /*if(!empty($professional_user->startup_stage)){
                                              echo $PrefferStartups[$professional_user->startup_stage];
                                          }else {
                                              echo 'Preferred Startup Stage';
                                          }*/
                                    ?>
                                 </span>
                                <?php
                                    //echo $this->Form->input('startup_stage', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','empty'=>'Preferred Startup Stage', 'data-size'=>'5','options'=>$PrefferStartups));
                                  ?>
                              </div>

                              <div class="form-group">

                               <div class="radio">
                              
                                  <span>Accredited Investor </span>
                                    <input type="radio" value="1" <?php if($professional_user->accredited_investor == 1){ echo $checkk= 'checked="checked"';} else{ echo $checkk='';}?> name="accredited_investor" id="yes"> <label for="yes">Yes</label> 
                                    <input type="radio" value="0" <?php if($professional_user->accredited_investor == 0){ echo $nTcheckk= 'checked="checked"';} else{ echo $nTcheckk='';}?> name="accredited_investor" id="no"> <label for="no">No</label> 
                                 
                                 </div>
                               </div>

                                      <?php
                                        //echo $this->Form->radio('accredited_investor',
                                         //         [
                                         //             ['value' => '1', 'text' => 'Yes'],
                                         //             ['value' => '0', 'text' => 'No',],     
                                          //        ]
                                           //   );
                                      ?> 
                                

                          </div>
                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              <div class="form-group">
                              <label>Certifications</label>
                                <span class="form-control textArea">
                                    <?php
                                       $sCr= explode(',', $professional_user['certifications']);
                                       $csCr=count($sCr);
                                          if(!empty($sCr[0])){
                                              for($i=0; $i<$csCr; $i++){
                                                    $slids=$sCr[$i];
                                                    echo $Certifications[$slids];
                                                    if($i<$csCr-1){ echo ', ';}
                                              }
                                          }else {
                                              echo 'Certifications';
                                          }
                                    ?>
                                 </span>
                                     
                              </div>
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
                                                    //echo $Keywords[$slids].', '; id="selectedResult"
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
                               <label>Industry Focus</label>
                                  <span class="form-control">
                                  <?php 
                                      if(!empty($professional_user['industry_focus'])){
                                        echo $professional_user['industry_focus'];
                                      }else {
                                        echo "Industry Focus";
                                      }
                                  ?>
                                  </span>
                                   
                              </div>
                              <div class="form-group">
                                <label>Contractor Type</label>
                                  <span class="form-control">
                                    <?php
                                          if(!empty($professional_user->contributor_type)){
                                              echo $ContractorTypes[$professional_user->contributor_type];
                                          }else {
                                              echo 'Contractor Type';
                                          }
                                    ?>
                                 </span>  
                              </div>     
                          </div>
                                 
                       </div>   
                    <?= $this->Form->end() ?>
                  </div>

                  <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane" id="basic">
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
