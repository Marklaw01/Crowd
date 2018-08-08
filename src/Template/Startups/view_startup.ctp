<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Startups', array('controller'=>'Startups','action'=>'currentStartup'), array('escape'=>false));
                ?></li>
                <li class="active">Search Overview</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Startup Overview</h1> 
              </div>
            </div>
          </div>
          <!-- header ends --> 
          <?php //$this->Form->create($startup,['id'=>'FormField', 'enctype' => 'multipart/form-data']) ?>
              <div class="row"> 
                      <div class="col-lg-8 col-md-8 col-sm-12 ">
                          <div class="form-group">
                          <label>Startup Name</label>
                                <span class="form-control">
                                    <?php 
                                      if(!empty($startup->name)){
                                          echo $startup->name;
                                      }else {
                                          echo 'Startup Name';
                                      } 
                                    ?>
                                </span>
                          </div>
                          <div class="form-group">
                          <label>Description</label>
                                <span class="form-control textArea">
                                    <?php 
                                      if(!empty($startup->description)){
                                          echo $startup->description;
                                      }else {
                                          echo 'Description';
                                      } 
                                    ?>
                                </span>
                          </div>

                          <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                                            <div class="panel panel-default">
                                              <div class="panel-heading" role="tab" id="headingOne">
                                                <h4 class="panel-title">
                                                  <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                                    Roadmap Graphic
                                                  </a>
                                                </h4>
                                              </div>
                                              <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                                <div class="panel-body">
                                                  <div class="image-Holder">
                                                  <?php if(!empty($startup->roadmap_graphic)){?>
                                                        <img src="<?php echo $this->request->webroot;?>img/roadmap/<?php echo $startup->roadmap_graphic;?>" alt="">
                                                    <?php }else{ ?>
                                                        <img src="<?php echo $this->request->webroot;?>images/roadMap.png" alt="">
                                                    <?php } ?>

                                                  </div>
                                                  

                                                </div>
                                              </div>
                                            </div>
                                            <div class="panel panel-default">
                                              <div class="panel-heading" role="tab" id="headingTwo">
                                                <h4 class="panel-title">
                                                  <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                                    Roadmap Deliverables
                                                  </a>
                                                </h4>
                                              </div>
                                              <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                                <div class="panel-body">
                                                 <ul class="listing">
                                                    <?php if(!empty($customRoadmaps)){
                                                          foreach($customRoadmaps as $customRoadmap) {
                                                            if(!empty($customRoadmap['file_path'])){

                                                                echo '<li id="'.$customRoadmap['roadmap_id'].'"> <a href="'.$this->request->webroot.$customRoadmap['file_path'].'" target="_blank" title="View Doc">'.$customRoadmap['name'].'</a></li>';

                                                             }else {

                                                              echo '<li  id="'.$customRoadmap['roadmap_id'].'">'.$customRoadmap['name'].'</li>';
                                                              

                                                             } 
                                                          }
                                                    }else{
                                                  ?>

                                                   <?php foreach($roadmaps as $roadmap) {?>
                                                     <li id="<?php echo $roadmap->id; ?>"> 
                                                     <?php echo $roadmap->name; ?>
                                                     </li>
                                                   <?php } ?>  

                                                   <?php } ?> 
                                                 </ul>
                                                </div>
                                              </div>
                                            </div>
                                            
                          </div> 
              <!--accordian --> 

                          <div class="form-group">
                          <label>Next Step</label>
                            <span class="form-control">
                                <?php if(!empty($startup->next_step)){
                                          echo $startup->next_step;
                                      }else {
                                        echo "Next Step";
                                      }
                                ?>
                               </span>
                          </div>
                          <div class="form-group">
                          <label>Keywords</label>
                             <span id="selectedResult" class="form-control textArea">
                             <ul>
                                    <?php
                                      $skey= explode(',', $startup->keywords);
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
                          <label>Support Required</label>
                            <span class="form-control">
                                <?php if(!empty($startup->support_required)){
                                          echo $startup->support_required;
                                      }else {
                                        echo "Support Required";
                                      }
                                ?>
                               </span>
                          </div>
                          <div class="form-group  pull-right">
                            <?php 
                              $entreId= base64_encode($startup->user_id);
                              echo $this->Html->link('View EnterPreneur'."'".'s Profile',['controller'=>'Entrepreneurs','action'=>'viewProfile',$entreId],['class'=>'customBtn blueBtn']);
                            ?>
                          </div>
                     
                     </div>

                     <div class="col-lg-4 col-md-4 col-sm-12 " id="invitation_block">
                       <?php if(!empty($startupsTeam)){ //pr($startupsTeam); ?>
                          <div class="form-group">
                             <div class="page_heading">
                               <h1>Invitation</h1> 
                             </div>
                             <div class="userImage circle-img-contractor">
                             <?php
                               $UserImage = $this->Custom->getUserImageByID($startupsTeam->hired_by);
                                if(!empty($UserImage[0]['image'])){
                                     $imagePath= $this->request->webroot.'img/profile_pic/'.$UserImage[0]['image'];
                                }else {
                                     $imagePath= $this->request->webroot.'images/dummy-man.png';
                                }
                                $UserName = $this->Custom->getContractorUserNameById($startupsTeam->hired_by);
                              ?>
                                <img src="<?php echo $imagePath;?>" alt="User Image">
                             </div>
                             <div class="user-details">
                                 <span class="name-inv"> <h3><?php echo $UserName; ?></h3></span>
                                 <span class="country-inv">  </span>
                             </div>
                          </div> 
                          <div class="form-group">
                           Price:   <span class="hirePrice">$<?php echo $startupsTeam->hourly_price;?>/HR</span> 
                          </div>
                          <div class="form-group">
                           Allocated Work Units:   <span class="hirePrice"><?php echo $startupsTeam->work_units_allocated;?></span> 
                          </div>
                          <div class="form-group">
                          <?php if($startupsTeam->approved ==0){?>
                              <?php
                                $Icon= '<i class="fa fa-check"></i>Accept';
                                echo $this->Form->postLink('Accept',['action' => 'acceptInvitation', $startupId],['id'=>'susPost','class'=>'smallCurveBtn greenBtn customBtn invitationBtn']);
                              ?>
                              <script type="text/javascript">
                                  $(document).ready(function () {
                                      $('#susPost').html('<?php echo $Icon;?>');
                                  });   
                              </script>
                              <?php
                                $Icon1= '<i class="fa fa-close"></i>Decline';
                                echo $this->Form->postLink('Decline',['action' => 'declineInvitation', $startupId],['id'=>'susPost2','class'=>'smallCurveBtn redBtn customBtn invitationBtn']);
                              ?>
                              <script type="text/javascript">
                                  $(document).ready(function () {
                                        $('#susPost2').html('<?php echo $Icon1;?>');
                                  });   
                              </script>                
                          <?php } ?>

                          <?php if($startupsTeam->approved ==1){?>
                                <a href="javascript:void(0);" title="Accepted" class="smallCurveBtn blueBtn customBtn invitationBtn">Accepted</a>
                          <?php } ?> 
                          <?php if($startupsTeam->approved ==2){?>
                                <a href="javascript:void(0);" title="Suspended" class="smallCurveBtn redBtn customBtn invitationBtn">Suspended</a>
                          <?php } ?>    

                          </div>
                       <?php } ?>
                     </div>
                    </div>
                    <?php //$this->Form->end() ?>
        </div>
        <!-- /#page-content-wrapper --> 
      </div>


