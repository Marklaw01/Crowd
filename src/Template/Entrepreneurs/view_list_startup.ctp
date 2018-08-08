 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li>
                <?php
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

                  <li role="presentation" >
                    <?php //echo $this->Html->link("PROFESSIONAL",ARRAY('controller'=>'Entrepreneurs','action'=>'ProfessionalProfile'),ARRAY('class'=>"",'aria-controls'=>'about', 'role'=>'tab', 'data-toggle'=>'tab1'));
                    $profess= $this->Url->build(["controller" => "Entrepreneurs","action" => "viewProfessionalProfile",$viewUserId,$startupId]);
                    ?>
                    <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#professional" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">PROFESSIONAL</a>
                  </li>
                  <li role="presentation" class="active">
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
                  
                  <div role="tabpanel" class="tab-pane active" id="startup">
                  <?= $this->Form->create($user , ['enctype' => 'multipart/form-data','id'=>'FormField','class'=>'profile-basic']) ?>
                    <div class="profileView">
                          
                          <div class="circle-img" >
                            <?php if(!empty($user['image'])) { ?>
                                  <?php echo $this->Html->image('profile_pic/' .$user['image'],array('id'=>'blah','width'=>'','height'=>'')); ?>
                            <?php }else { ?>
                                  <img id="blah" src="<?php echo $this->request->webroot;?>images/dummy-man.png" alt="">
                            <?php } ?>
                            <div id="OpenImgUpload" class="overlay">
                            </div>
                            <?php
                                echo $this->Form->input('image', ARRAY('style'=>'display:none;', 'label' => false, 'div' => false, "class"=>"validate[checkFileType[jpg|jpeg|gif|JPG|png|PNG],checkFileSize[2000]] form-control", 'id' => 'imgupload','type' => 'file'));
                            ?>
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
                            
                           
                            <!-- <div class="links"> 
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
                          <div class="col-md-12 col-sm-12 col-xs-12"> 
                            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                               
                            <?php if(!empty($startupdata)){ $i=1;?> 
                                <?php foreach($startupdata as $startup){?>
                                    <div class="panel panel-default">
                                      <div class="panel-heading" role="tab" id="headingOne">
                                        <h4 class="panel-title">
                                          <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse<?php echo $startup['id'];?>" aria-expanded="true" aria-controls="collapse<?php echo $startup['id'];?>">
                                            <?= $startup['name'] ?>
                                          </a>
                                        </h4>
                                      </div>
                                      <div id="collapse<?php echo $startup['id'];?>" class="panel-collapse collapse <?php if($i== 1){echo "in"; } ?>" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                         <ul class="listing">
                                           <li><?= $startup['description'] ?></li>
                                           <li><?= $startup['support_required'] ?></li>
                                         </ul>
                                        </div>
                                      </div>
                                    </div>
                                <?php $i++; } // Foreach close ?>    
                            <?php }else{?>
                                <div class="panel panel-default">
                                  <div class="panel-heading" role="tab" id="headingTwo">
                                    <h4 class="panel-title">
                                      <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                        No Record Found
                                      </a>
                                    </h4>
                                  </div>
                                  <div id="collapseTwo" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingTwo">
                                    <div class="panel-body">
                                     <ul class="listing">
                                       <li>No Record Found</li>
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
                  <div role="tabpanel" class="tab-pane" id="professional">
                  </div>
                  <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane" id="basic">                  
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
 </div>
 <!-- /#page-content-wrapper --> 
 <script>
$(document).ready(function () {
  $("#sidebar_username").html('<?php echo $logedUseName;?>');
});

</script>
