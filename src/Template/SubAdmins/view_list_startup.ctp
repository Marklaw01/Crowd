 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
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
                  <?php 
                  $basic= $this->Url->build(["controller" => "SubAdmins","action" => "viewContractorProfile",$viewUserId]);
                  ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">BASIC</a>

                  </li>

                  <li role="presentation" >
                    <?php 
                    $profess= $this->Url->build(["controller" => "SubAdmins","action" => "viewProfessionalProfile",$viewUserId]);
                    ?>

                    <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#professional" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">PROFESSIONAL</a>
                  </li>
                  <li role="presentation" class="active">
                  <?php 
                   $startu= $this->Url->build(["controller" => "startups","action" => "viewListStartup",$viewUserId]);
                  ?>

                   <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="scope" href="#startup" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $startu;?>'">STARTUPS</a>
                  </li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->                 
                 
                  <div role="tabpanel" class="tab-pane active" id="startup">
                  <?php //pr($user);?>
                  <?= $this->Form->create($user , ['enctype' => 'multipart/form-data','id'=>'FormField','class'=>'profile-startup']) ?>
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
                              
                          </div>                          
                    </div>
                   
                       <div class="row">   
                          <div class="col-md-12 col-sm-12 col-xs-12"> 
                            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                               
                            <?php if(!empty($selectedIds)){ $i=1;?> 
                                <?php foreach($startupdata as $startup){ 
                                    if(in_array($startup['id'], $selectedIds)){
                                  ?>
                                    <div class="panel panel-default">
                                      <div class="panel-heading" role="tab" id="headingOne">
                                        <h4 class="panel-title">
                                          <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse<?php echo $startup['id']?>" aria-expanded="true" aria-controls="collapse<?php echo $startup['id']?>">
                                            <?= $startup['name'] ?>
                                          </a>
                                        </h4>
                                      </div>
                                      <div id="collapse<?php echo $startup['id']?>" class="panel-collapse collapse <?php if($i== 1){echo "in"; } ?>" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                         <ul class="listing">
                                           <li><?= $startup['description'] ?></li>
                                           <li><?= $startup['support_required'] ?></li>
                                         </ul>
                                        </div>
                                      </div>
                                    </div>
                                <?php } // if for in array close
                                $i++; } // Foreach close ?>    
                            <?php }else{?>
                                <div class="panel panel-default">
                                  <div class="panel-heading" role="tab" id="headingTwo">
                                    <h4 class="panel-title">
                                      <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                        No Startups Available
                                      </a>
                                    </h4>
                                  </div>
                                  <div id="collapseTwo" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingTwo">
                                    <div class="panel-body">
                                     <ul class="listing">
                                       <li>No Startups Available</li>
                                     </ul>
                                    </div>
                                  </div>
                                </div>
                            <?php } ?>    
                            </div>  
                          </div>
                                                        
                       </div>   
                    <?= $this->Form->end() ?>
                  </div>
                  <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane" id="basic">
                  </div>
                  <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane" id="professional">                  
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
 </div>
 <!-- /#page-content-wrapper --> 
