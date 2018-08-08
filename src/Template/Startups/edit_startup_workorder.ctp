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
                <li class="active">Startup Workorders</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Startup Workorders</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="startup-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs campaignsTab" role="tablist">
                  <?php
                  $ovrVw= $this->Url->build(["controller" => "Startups","action" => "editStartupOverview",$startupId]);
                  ?>
                  <li role="presentation"><a href="#overview" aria-controls="overview" role="tab" data-toggle="tab" onclick="location.href='<?php echo $ovrVw;?>'">Overview</a></li>
                  <?php
                  $teaM= $this->Url->build(["controller" => "Startups","action" => "editStartupTeam",$startupId]);
                  ?>
                  <li role="presentation"><a href="#team" aria-controls="team" role="tab" data-toggle="tab" onclick="location.href='<?php echo $teaM;?>'">Team</a></li>
                  <?php
                  $workOrd= $this->Url->build(["controller" => "Startups","action" => "editStartupWorkorder",$startupId]);
                  ?>
                  <li role="presentation"  class="active"><a href="#workOrder" aria-controls="workOrder" role="tab" data-toggle="tab" onclick="location.href='<?php echo $workOrd;?>'">Billed Work Orders</a></li>
                  <?php
                  $dcs= $this->Url->build(["controller" => "Startups","action" => "editStartupDocs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#docs" aria-controls="docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $dcs;?>'">Docs</a></li>
                  <?php
                  $roadDcs= $this->Url->build(["controller" => "Startups","action" => "editStartupRoadmapdocs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#roadmap-docs" aria-controls="roadmap-docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $roadDcs;?>'">Roadmap Docs</a></li>
                </ul>

                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane whiteBg" id="overview">

                  </div>
                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="team">
                     
                  </div>
                   <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="workOrder">
                    
                    <div class="links"> 
                    <?php 

                        echo $this->Form->postLink('Download',['action' => 'entrepreneurExcelDownload_', $startupId],['id'=>'dwnPost','class'=>'customBtn blueBtn']);
                      ?>
                      <script type="text/javascript">
                        $(document).ready(function () {
                            $('#dwnPost').html('<i class="fa fa-download"></i>Download');
                        });   
                      </script>

           
                  </div>
                    <div class="clearfix"></div>
                    <div class="table-responsive mver20">
                                   <table class="table table-striped startup-list">
                                      <thead>
                                        <tr>
                                          <th>Contractor</th>
                                          <th>Roadmap</th>
                                          <th>Week Start Date</th>
                                          <th>Week End Date</th>
                                          <th>Total Work Units</th>

                                          <th>Actions</th>
                                        </tr>
                                                        
                                      </thead>
                                      <tbody>
                                     <?php 
                                      function getStartAndEndDate($week, $year)
                                      {

                                          $dto = new DateTime();
                                          $dto->setISODate($year, $week);
                                          $ret['week_start'] = $dto->format('F d, Y');
                                          $dto->modify('+6 days');
                                          $ret['week_end'] = $dto->format('F d, Y');
                                          return $ret;
                                      }   
                                      ?>
                                      <?php $c=0; foreach($startups as $startup){ $c++;?>
                                      <?php 
                                      $rss= explode('_', $startup->week_no);
                                      $week= $rss[0];
                                      $year= $rss[1];
                                      $week_array = getStartAndEndDate($week,$year);
                                      $week_start=$week_array['week_start'];
                                      $week_end=$week_array['week_end'];

                                      if($startup->total_work_units >0){ //Check Units Sum not 0
                                      ?>
                                        <tr>
                                          <td><?php echo $startup->first_name.' '.$startup->last_name; ?></td>
                                          <td><?php echo $startup->roadmap; ?></td>
                                          <td><?php echo $week_start; ?></td>
                                          <td><?php echo $week_end; ?></td>
                                          <td><?php echo $startup->total_work_units; ?></td>
                                          
                                       
                                        <td>
                                        <?php
                                          $viewWrk= $this->Url->build(["controller" => "Startups","action" => "entrepreneurStartupWorkorder",$startupId,$week,$year,base64_encode($startup->startup_team_id)]);
                                        ?>
                                        <span><a href="<?php echo $viewWrk;?>">View</a></span>
                                        
                                        <?php if($startup->status==1){?>
                                            <span style="color:#088223"> Accepted </span>
                                        <?php } else if($startup->status==2){?>
                                            <span style="color:#f00"> Rejected</span>
                                        <?php }else { ?>
                                            <?php
                                               echo $this->Form->postLink('Accept',['action' => 'accept',base64_encode($startup->week_no),$startupId,base64_encode($startup->user_id)],['id'=>'delPost'.$c,'class'=>'smallCurveBtn blueBtn customBtn']);
                                            ?>
                                            <script type="text/javascript">
                                             $(document).ready(function () {
                                                 $('#delPost<?php echo $c;?>').html('<i class="fa fa-check-circle-o"></i>Accept');
                                              });   
                                            </script>

                                            <?php
                                               echo $this->Form->postLink('Reject',['action' => 'reject', base64_encode($startup->week_no),$startupId,base64_encode($startup->user_id)],['id'=>'delPost2'.$c,'class'=>'smallCurveBtn redBtn customBtn']);
                                            ?>
                                            <script type="text/javascript">
                                             $(document).ready(function () {
                                                 $('#delPost2<?php echo $c;?>').html('<i class="fa fa-times-circle-o"></i>Reject');
                                              });   
                                            </script>
                                        <?php } //Check Units Sum not 0 End?>
                                        <?php } // for loop End?>
                                        </td>
                                        
                                        </tr>

                                      <?php  } ?>
                                        
                                         

                                                       
                                      </tbody>
               
                                   </table>
                    </div>
                    <nav class="pagingNav">
                      <ul class="pagination pagination-sm">
                          <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                          <li><?= $this->Paginator->numbers() ?></li>
                          <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                      </ul>
                  </nav>
                   
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

