<div id="page-content-wrapper">
<div class="container-fluid">
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <h1 class="page-header"><i class=" fa fa-arrow-circle-up"></i>Startup's Team
            </h1>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs campaignsTab" role="tablist">
                  <?php
                  $ovrVw= $this->Url->build(["controller" => "Startups","action" => "overview",$startupId]);
                  ?>
                  <li role="presentation" ><a href="#overview" aria-controls="overview" role="tab" data-toggle="tab" onclick="location.href='<?php echo $ovrVw;?>'">Overview</a></li>
                  <?php
                  $teaM= $this->Url->build(["controller" => "Startups","action" => "team",$startupId]);
                  ?>
                  <li role="presentation" class="active"><a href="#team" aria-controls="team" role="tab" data-toggle="tab" onclick="location.href='<?php echo $teaM;?>'">Team</a></li>
                  <?php
                  $workOrd= $this->Url->build(["controller" => "Startups","action" => "workorder",$startupId]);
                  ?>
                  <li role="presentation"><a href="#workOrder" aria-controls="workOrder" role="tab" data-toggle="tab" onclick="location.href='<?php echo $workOrd;?>'">Work Orders</a></li>
                  <?php
                  $dcs= $this->Url->build(["controller" => "Startups","action" => "docs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#docs" aria-controls="docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $dcs;?>'">Docs</a></li>

                  <?php
                  $roadDcs= $this->Url->build(["controller" => "Startups","action" => "roadmapdocs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#roadmap-docs" aria-controls="roadmap-docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $roadDcs;?>'">Roadmap Docs</a></li>
                  
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane whiteBg" id="overview">
                    
                  </div>
                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="team">
                   
                  <!-- if user is suspended or removed hide functionality-->
                  
                     <div class="clearfix"></div>
                     <div class="table-responsive mver20">
                         <table class="table table-striped startup-list">
                            <thead>
                              <tr>
                                <th width="20%">Name</th>
                                <th width="20%">Role</th>
                                <th width="60%"></th>
                              </tr>
                                              
                            </thead>
                            <tbody>
                            <tr>
                                <td>
                                <?php 
                                $startUserId= $startupDetails['user_id'];
                                   if(!empty($startupDetails['user']['entrepreneur_basic']['first_name'])){
                                   
                                    $senderid=$startupDetails['user']['entrepreneur_basic']['user_id'];

                                    echo $entrName= $startupDetails['user']['entrepreneur_basic']['first_name'].' '.$startupDetails['user']['entrepreneur_basic']['last_name'];

                                      if($UserId != $startupDetails['user_id']){ 

                                          //echo $this->Html->link($entrName, array('controller'=>'Entrepreneurs','action'=>'viewProfile',base64_encode($senderid),$startupId), array('escape'=>false));
                                      }else {
                                          //echo $entrName;
                                      }    

                                   }else {
                                     
                                      $senderid=$startupDetails['user']['id'];
                                      echo $entrName= $startupDetails['user']['first_name'].' '.$startupDetails['user']['last_name'];

                                      if($UserId != $startupDetails['user_id']){ 

                                      //echo $this->Html->link($entrName, array('controller'=>'Contractors','action'=>'viewProfile',base64_encode($senderid),$startupId), array('escape'=>false));
                                      }else{
                                        //echo $entrName;
                                      }
                                   }
                                ?>
                                </td>

                                <td>
                                    Entrepreneur
                                </td>

                                <td>

                                 <!-- if user is suspended or removed hide functionality-->
                                  <!--
                                        <?php  $entrQbloxId = $this->Custom->getUserQuickbloxId($UserId); ?>
                                        <?php if($UserId != $startupDetails['user_id']){ ?>
                                               <?php
                                                  $chatLink = $this->Url->build(["controller" => "Messages","action" => "chat",base64_encode($entrQbloxId)]);
                                               ?>
                                              <a class="smallCurveBtn blueBtn customBtn" href="<?php echo $chatLink;?>">
                                                <i class="fa fa-commenting-o"></i>Chat
                                              </a>
                                                <?php
                                                  $mesgLink= $this->Url->build(["controller" => "Startups","action" => "sendMessage",base64_encode($senderid),$startupId]);
                                                ?>
                                                  <a class="smallCurveBtn greenBtn customBtn" href="<?php echo $mesgLink;?>">
                                                    <i class="fa fa-envelope-o"></i>Message
                                                  </a>

                                               <?php
                                                  $mailLink= $this->Url->build(["controller" => "Startups","action" => "sendMail",base64_encode($senderid),$startupId]);
                                                  ?>
                                                  <a class="smallCurveBtn blueBtn customBtn" href="<?php echo $mailLink;?>">
                                                    <i class="fa fa-envelope-o"></i>Mail
                                                  </a>    

                                        <?php } ?>
                                     -->
                                </td>
                            </tr>

                            <?php 
                            $count= count($startups);
                            $c=0; 
                            foreach($startups as $startup){ $c++;?>

                                <!-- Co founder list-->
                                <?php 
                                if($startup->contractor_role_id == 2){?>
                                  <tr>
                                    <td>
                                    <?php //if($startUserId == $UserId) { ?> 
                                          <?php
                                            $rateCont= $this->Url->build(["controller" => "Contractors","action" => "viewProfile",base64_encode($startup->user->id),$startupId]);
                                          ?>
                                          <?php 
                                             echo $startup->user->first_name.' '.$startup->user->last_name; 
                                          ?>


                                    <?php //}else{ ?>
                                          <?php //echo $startup->user->first_name.' '.$startup->user->last_name; ?>
                                    <?php //} ?>
                                    </td>
                                    <td><?php echo $startup->contractor_role->name; ?></td>
                                    <td>
                                <!-- if user is suspended or removed hide functionality-->
                                
                                <!--
                                    <?php if($startup->user_id != $UserId){ ?>
                                    <?php $coFounQbloxId = $this->Custom->getUserQuickbloxId($startup->user->id); ?>
                                          <?php
                                          $chatLink = $this->Url->build(["controller" => "Messages","action" => "chat",base64_encode($coFounQbloxId)]);
                                       ?>
                                      <a class="smallCurveBtn blueBtn customBtn" href="<?php echo $chatLink;?>">
                                        <i class="fa fa-commenting-o"></i>Chat
                                      </a>


                                          <?php
                                          $mesgLink= $this->Url->build(["controller" => "Startups","action" => "sendMessage",base64_encode($startup->user->id),$startupId]);
                                          ?>
                                          <a class="smallCurveBtn greenBtn customBtn" href="<?php echo $mesgLink;?>">
                                            <i class="fa fa-envelope-o"></i>Message
                                          </a>

                                          <?php
                                          $mailLink= $this->Url->build(["controller" => "Startups","action" => "sendMail",base64_encode($startup->user->id),$startupId]);
                                          ?>
                                          <a class="smallCurveBtn blueBtn customBtn" href="<?php echo $mailLink;?>">
                                            <i class="fa fa-envelope-o"></i>Mail
                                          </a>
                                      -->

                                   <?php } ?>
                                    <?php if($startup->hired_by == $UserId or $UserId==$startUserId){ ?>

                                          <?php
                                          if($startup->approved == 2){
                                            $Icon= '<i class="fa fa-play"></i>Resume';
                                            echo $this->Form->postLink('Resume',['action' => 'resume', base64_encode($startup->id)],['id'=>'susPost'.$c,'class'=>'smallCurveBtn greenBtn customBtn']);
                                          }else {
                                            $Icon= '<i class="fa fa-power-off"></i>Suspend';
                                            echo $this->Form->postLink('Suspend',['action' => 'suspend', base64_encode($startup->id)],['id'=>'susPost'.$c,'class'=>'smallCurveBtn greenBtn customBtn']);
                                          }
                                          ?>
                                          <script type="text/javascript">
                                           $(document).ready(function () {
                                               $('#susPost<?php echo $c;?>').html('<?php echo $Icon;?>');
                                            });   
                                          </script>

                                          

                                          <?php
                                            echo $this->Form->postLink('Remove',['action' => 'delete', base64_encode($startup->id)],['id'=>'delPost'.$c,'class'=>'smallCurveBtn redBtn customBtn']);
                                          ?>
                                          <script type="text/javascript">
                                           $(document).ready(function () {
                                               $('#delPost<?php echo $c;?>').html('<i class="fa fa-times-circle-o"></i>Remove');
                                            });   
                                          </script>
                                    <?php } ?>
                                  
                                    </td>     
                                  </tr>
                                <?php } ?>  

                                <?php } ?> 

                                <?php 
                              $count= count($startups);
                              $c=0; 
                              foreach($startups as $startup){ $c++;?>

                                <!-- Team member list-->
                                <?php if($startup->contractor_role_id == 3){?>
                                  <tr>
                                    <td>
                                    <?php //if($startUserId == $UserId) { ?> 
                                          <?php
                                            $rateCont= $this->Url->build(["controller" => "Contractors","action" => "viewProfile",base64_encode($startup->user->id),$startupId]);
                                          ?>
                                          <?php 
                                            echo $startup->user->first_name.' '.$startup->user->last_name; 
                                          ?>
                                    <?php //}else{ ?>
                                          <?php //echo $startup->user->first_name.' '.$startup->user->last_name; ?>
                                    <?php //} ?>
                                    </td>
                                    <td><?php echo $startup->contractor_role->name; ?></td>
                                    <td>

                                <!-- if user is suspended or removed hide functionality-->
                               
                                  <!--  
                                    <?php if($startup->user_id != $UserId){ ?>
                                    <?php $TeamMemQbloxId = $this->Custom->getUserQuickbloxId($startup->user->id); ?>
                                          <?php
                                          $chatLink = $this->Url->build(["controller" => "Messages","action" => "chat",base64_encode($TeamMemQbloxId)]);
                                       ?>
                                      <a class="smallCurveBtn blueBtn customBtn" href="<?php echo $chatLink;?>">
                                        <i class="fa fa-commenting-o"></i>Chat
                                      </a>


                                          <?php
                                          $mesgLink= $this->Url->build(["controller" => "Startups","action" => "sendMessage",base64_encode($startup->user->id),$startupId]);
                                          ?>
                                          <a class="smallCurveBtn greenBtn customBtn" href="<?php echo $mesgLink;?>">
                                            <i class="fa fa-envelope-o"></i>Message
                                          </a>

                                           <?php
                                          $mailLink= $this->Url->build(["controller" => "Startups","action" => "sendMail",base64_encode($startup->user->id),$startupId]);
                                          ?>
                                          <a class="smallCurveBtn blueBtn customBtn" href="<?php echo $mailLink;?>">
                                            <i class="fa fa-envelope-o"></i>Mail
                                          </a>
                                    -->

                                   <?php } ?>

                                    <?php if($startup->hired_by == $UserId or $UserId==$startUserId or $LogUserIsCoFounder==1){ ?>


                                          <?php
                                          if($startup->approved == 2){
                                            $Icon= '<i class="fa fa-play"></i>Resume';
                                            echo $this->Form->postLink('Resume',['action' => 'resume', base64_encode($startup->id)],['id'=>'susPost'.$c,'class'=>'smallCurveBtn greenBtn customBtn']);
                                          }else {
                                            $Icon= '<i class="fa fa-power-off"></i>Suspend';
                                            echo $this->Form->postLink('Suspend',['action' => 'suspend', base64_encode($startup->id)],['id'=>'susPost'.$c,'class'=>'smallCurveBtn greenBtn customBtn']);
                                          }
                                          ?>
                                          <script type="text/javascript">
                                           $(document).ready(function () {
                                               $('#susPost<?php echo $c;?>').html('<?php echo $Icon;?>');
                                            });   
                                          </script>


                                          <?php
                                            echo $this->Form->postLink('Remove',['action' => 'delete', base64_encode($startup->id)],['id'=>'delPost'.$c,'class'=>'smallCurveBtn redBtn customBtn']);
                                          ?>
                                          <script type="text/javascript">
                                           $(document).ready(function () {
                                               $('#delPost<?php echo $c;?>').html('<i class="fa fa-times-circle-o"></i>Remove');
                                            });   
                                          </script>
                                    <?php } ?>

                                   
                                    </td>     
                                  </tr>
                                <?php } ?>

                              <?php } ?>

                                <?php 
                                  $count= count($startups);
                                  $c=0; 
                                  foreach($startups as $startup){ $c++;?>

                                <!-- Contractor list-->
                                <?php if($startup->contractor_role_id == 4){?>
                                  <tr>
                                    <td>
                                    <?php //if($startUserId == $UserId) { ?> 
                                          <?php
                                            $rateCont= $this->Url->build(["controller" => "Contractors","action" => "viewProfile",base64_encode($startup->user->id),$startupId]);
                                          ?>
                                          
                                          <?php 
                                           echo $startup->user->first_name.' '.$startup->user->last_name; 
                                          ?>
                                    <?php //}else{ ?>
                                          <?php //echo $startup->user->first_name.' '.$startup->user->last_name; ?>
                                    <?php //} ?>
                                    </td>
                                    <td><?php echo $startup->contractor_role->name; ?></td>
                                    <td>

                                <!-- if user is suspended or removed hide functionality-->
                                
                                  <!--  
                                    <?php if($startup->user_id != $UserId){ ?>
                                    <?php $ContrQbloxId = $this->Custom->getUserQuickbloxId($startup->user->id); ?>
                                    <?php
                                          $chatLink = $this->Url->build(["controller" => "Messages","action" => "chat",base64_encode($ContrQbloxId)]);
                                       ?>
                                      <a class="smallCurveBtn blueBtn customBtn" href="<?php echo $chatLink;?>">
                                        <i class="fa fa-commenting-o"></i>Chat
                                      </a>

                                    
                                    <?php
                                          $mesgLink= $this->Url->build(["controller" => "Startups","action" => "sendMessage",base64_encode($startup->user->id),$startupId]);
                                          ?>
                                          <a class="smallCurveBtn greenBtn customBtn" href="<?php echo $mesgLink;?>">
                                            <i class="fa fa-envelope-o"></i>Message
                                          </a>

                                           <?php
                                          $mailLink= $this->Url->build(["controller" => "Startups","action" => "sendMail",base64_encode($startup->user->id),$startupId]);
                                          ?>
                                          <a class="smallCurveBtn blueBtn customBtn" href="<?php echo $mailLink;?>">
                                            <i class="fa fa-envelope-o"></i>Mail
                                          </a>

                                      <?php if($startup->hired_by == $UserId or $UserId==$startUserId or $LogUserIsCoFounder==1 or $LogUserIsTeamMember==1){ ?>

                                          <?php
                                          if($startup->approved == 2){
                                            $Icon= '<i class="fa fa-play"></i>Resume';
                                            echo $this->Form->postLink('Resume',['action' => 'resume', base64_encode($startup->id)],['id'=>'susPost'.$c,'class'=>'smallCurveBtn greenBtn customBtn']);
                                          }else {
                                            $Icon= '<i class="fa fa-power-off"></i>Suspend';
                                            echo $this->Form->postLink('Suspend',['action' => 'suspend', base64_encode($startup->id)],['id'=>'susPost'.$c,'class'=>'smallCurveBtn greenBtn customBtn']);
                                          }
                                          ?>
                                          <script type="text/javascript">
                                           $(document).ready(function () {
                                               $('#susPost<?php echo $c;?>').html('<?php echo $Icon;?>');
                                            });   
                                          </script>


                                          <?php
                                            echo $this->Form->postLink('Remove',['action' => 'delete', base64_encode($startup->id)],['id'=>'delPost'.$c,'class'=>'smallCurveBtn redBtn customBtn']);
                                          ?>
                                          <script type="text/javascript">
                                           $(document).ready(function () {
                                               $('#delPost<?php echo $c;?>').html('<i class="fa fa-times-circle-o"></i>Remove');
                                            });   
                                          </script>
                                    <?php } ?>

                                   <?php } ?>

                                  -->
                                    </td>     
                                  </tr>
                                <?php } ?>



                            <?php } ?>
                                         
                            </tbody>
     
                         </table>
                     </div>
                     <?php if(!empty($count)){?>
                        <nav>
                          <ul class="pagination pagination-sm">
                            <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                            <li><?= $this->Paginator->numbers() ?></li>
                            <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                          </ul>
                        </nav>
                     <?php }else { ?>
                        <nav>
                          <ul class="pagination pagination-sm">
                            <li>No Team Found.</li>
                          </ul>
                        </nav>
                     <?php } ?>
                  
                  </div>
                   <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="workOrder">                  
                   
                  </div>
                   <!--  4Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="docs">
 
                  </div>
                    <!--  5Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="roadmap-docs">

                  </div>


                </div>
              </div>
            </div>
          </div>
        </div>
</div>        
        <!-- /#page-content-wrapper --> 


<?php
     //echo $this->Form->input('roadmap_id', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'Support Required','maxlength' => '50','options'=> $roadmap,'empty'=>'Select Roadmap'));
?>
<script>
$(document).ready(function () {

$('#roadmapImage').click(function(){ $('#roadmap_graphic').trigger('click'); });

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            var nameImg = $('#roadmap_graphic').val(); 
            reader.onload = function (e) {
                //$('#imgUpload').attr('src', e.target.result);
                $('#imgUpload').html(nameImg);
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }
    $("#roadmap_graphic").change(function(){
        var ext = $('#roadmap_graphic').val().split('.').pop().toLowerCase();
        if($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) {
           $('#imgUpload').html('Invalid! Allowed extensions are .jpg, .jpeg, .gif, .png.. Max upload size 2MB');
          //$('<div id="custerro" class="message error" onclick="return closeError();">Invalid! These files extension are allowed: .jpg, .jpeg, .gif, .png</div>').insertBefore('.container-fluid');
        }else {
           readURL(this);
        }
    });

});
</script>

