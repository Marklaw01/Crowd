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
              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs campaignsTab" role="tablist">
                  <?php
                  $ovrVw= $this->Url->build(["controller" => "Startups","action" => "viewStartupOverview",$startupId]);
                  ?>
                  <li role="presentation"><a href="#overview" aria-controls="overview" role="tab" data-toggle="tab" onclick="location.href='<?php echo $ovrVw;?>'">Overview</a></li>
                  <?php
                  $teaM= $this->Url->build(["controller" => "Startups","action" => "viewStartupTeam",$startupId]);
                  ?>
                  <li role="presentation"><a href="#team" aria-controls="team" role="tab" data-toggle="tab" onclick="location.href='<?php echo $teaM;?>'">Team</a></li>
                  <?php
                  $workOrd= $this->Url->build(["controller" => "Startups","action" => "updateStartupWorkorder",$startupId]);
                  ?>
                  <li role="presentation"  class="active"><a href="#workOrder" aria-controls="workOrder" role="tab" data-toggle="tab" onclick="location.href='<?php echo $workOrd;?>'">Billed Work Orders</a></li>
                  <?php
                  $dcs= $this->Url->build(["controller" => "Startups","action" => "viewStartupDocs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#docs" aria-controls="docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $dcs;?>'">Docs</a></li>
                  
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
                  <div id="workOrder" class="tab-pane whiteBg active" role="tabpanel">
                      
                    <div class="fixed-first-coloumn">

                      <?php
                      if($week_no == 52){
                          $week_no = 00;
                          $dateYear = $dateYear+1;
                      }
                          $dt = new DateTime;
                            if (isset($dateYear) && isset($week_no)) {
                                  $dt->setISODate(''.$dateYear.'', ''.$week_no.'');
                            } else {
                                  $dt->setISODate($dt->format('o'), $dt->format('W'));
                            }
                              $year = $dt->format('o');
                              $week = $dt->format('W');


                      ?>
                              
                     <div class="table-responsive mver20 ">
                     <?= $this->Form->create($updateWorkUnits,['id'=>'whereEntry', 'enctype' => 'multipart/form-data']) ?>
                         <table class="table table-striped startup-list">
                            <thead>
                              <tr>
                                <th>
                                <?php

                                  $week_no_next= $week_no;
                                  $week_no_prev= $week_no;

                                  $dateYear_next= $dateYear; 
                                  $dateYear_prev= $dateYear;

                                  if($week_no == 01){
                                    $week_no_prev=53;
                                    $dateYear_prev=$dateYear-1;
                                  }

                                  $week_no_prev= $week_no_prev-1;
                                  if($week_no_prev<10){ 
                                    $week_no_prev= '0'.$week_no_prev;
                                  }

                                  $week_no_next= $week_no_next+1;
                                  if($week_no_next<10){
                                    $week_no_next= '0'.$week_no_next;
                                  } 
                                $preWeek= $this->Url->build(["controller" => "Startups","action" => "updateStartupWorkorder",$startupId,$week_no_prev,$dateYear_prev]);
                                ?>
                                <?php
                                $nextWeek= $this->Url->build(["controller" => "Startups","action" => "updateStartupWorkorder",$startupId,$week_no_next,$dateYear_next]);
                                ?>
                                <a href="<?php echo $preWeek; ?>" class="weekArrow" title="Previous Week"> << </a> 
                                <?php echo $from; ?>
                                <a href="<?php echo $nextWeek; ?>" class="weekArrow" title="Next Week"> >> </a> 
                                </th>

                                <?php 
                                $CoutRodIds='';
                                if(!empty($hiredRoadmapIds)){
                                    $hiredRoadmapIdsArray= explode(',',$hiredRoadmapIds);
                                    $CoutRodIds= count($hiredRoadmapIdsArray);
                                    foreach($roadmaps as $roadmap){ 
                                        if(in_array($roadmap['id'], $hiredRoadmapIdsArray)){
                                ?>
                                                <th><?php echo $roadmap['name'];?></th>
                                        <?php } ?>
                                    <?php } ?>
                                <?php }else {  ?>
                                      <th>No Roadmap Found.</th>
                                <?php } ?>
                              </tr>
                            </thead>
                            <tbody>
                            
                              <?php
                            //pr($workorderlits);die;
                              do {
                                  echo '<tr>';
                                  echo '<td>
                                  <span class="months">'.$dt->format('D').'</span>'.$dt->format('F d, Y').'</td>';

                                  $workCount= count($workorderlits['weekly_update']);
                                  for($i=0;$i<$workCount; $i++){
                                     $InnerCountWork= count ($workorderlits['weekly_update'][$i]);
                                     for($j=0;$j<$InnerCountWork;$j++){

                                         if($dt->format('Y-m-d') ==$workorderlits['weekly_update'][$i][$j]['date']){
                                          echo '<td>';

                                          $inptId= 'stp_'.$workorderlits['startup_id'].'_delv_'.$workorderlits['weekly_update'][$i][$j]['roadmap_id'];

                                          $dateForNam=$dt->format('Y_m_d');
                                          $stpId=$workorderlits['startup_id'];
                                          $delvId=$workorderlits['weekly_update'][$i][$j]['roadmap_id'];

                                          if(!empty($workorderlits['weekly_update'][$i][$j]['deliverables'])){
                                            //echo $workorderlits[$i][$j]['deliverables'][0]['deliverable_name'];
                                            $approv_status=$workorderlits['weekly_update'][$i][$j]['deliverables'][0]['approv_status'];
                                             $approvClass='';
                                            if(!empty($approv_status)){
                                                $approvClass='approvClss';
                                            }else{
                                              if(!empty($workorderlits['weekly_update'][$i][$j]['deliverables'][0]['work_units'])){
                                                $approvClass='pendingClss';
                                              }
                                            }  
                                            ?>
                                            <input type="text" id="<?php echo $inptId;?>" class="w_units <?php echo $approvClass;?>" value="<?php echo $workorderlits['weekly_update'][$i][$j]['deliverables'][0]['work_units'];?>" name="units_<?php echo $dateForNam.'_'.$inptId; ?>" onkeypress="return isNumber(event)"></input>
                                            
                                         <?php }else {

                                            echo '<input id="'.$inptId.'" name="units_'.$dateForNam.'_'.$inptId.'" type="text" class="w_units" value="0" onkeypress="return isNumber(event)"></input>';
                                          }
                                          echo '</td>';
                                        }  

                                     }

                                  }
                                  
                                echo '</tr>';
                                  $dt->modify('+1 day');
                                  } 
                              while ($week == $dt->format('W'));
                              ?>
                              
                               
                               <tr style="display:none;">
                                <td>Total</td>
                                <td><?php echo $workorderlits['consumedHours'];?></td>
                                <?php
                                if($CoutRodIds>1){
                                  for($v=0;$v<$CoutRodIds-1;$v++){
                                    echo '<td>-</td>';
                                  
                                  }
                                }  
                                ?>
                              </tr>
                              <tr style="display:none;">
                                <td>Consumed</td>
                                <td><?php echo $workorderlits['Approved_hours'];?></td>
                                <?php
                                if($CoutRodIds>1){
                                  for($v=0;$v<$CoutRodIds-1;$v++){
                                    echo '<td>-</td>';
                                  
                                  }
                                }  
                                ?>
                              </tr>
                               <tr style="display:none;">
                                <td>Remaining</td>
                                <td><?php echo $workorderlits['Allocated_hours']-$workorderlits['consumedHours']; ?></td>
                                <?php
                                if($CoutRodIds>1){
                                  for($j=0;$j<$CoutRodIds-1;$j++){
                                    echo '<td>-</td>';
                                  
                                  }
                                }  
                                ?>
                                
                              </tr>
                               <tr style="display:none;">
                                <td>Allocated</td>
                                <td><?php echo $workorderlits['Allocated_hours'];?></td>
                                
                                
                              </tr>
                            </tbody>
                            
                         </table>

                          <div class="links mver20">                     
                            <?= $this->Form->button('Save',['name'=>'update','class'=> 'customBtn blueBtn pull-left-custom']) ?>

                            <?= $this->Form->button('Submit',['name'=>'submit','class'=> 'customBtn greenBtn pull-right']) ?>
                           </div>
                        <?= $this->Form->end() ?>    
                     </div>
                     </div>

                  <!-- if user is suspended or removed hide functionality-->   
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
<?php 
$wrkD='';
if(isset($_POST['submit'])){
 //echo $wrkD= $_POST['work_date'];
}
?>
<script>
function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

$(document).ready(function () {
  $('.testpicker').datetimepicker({
    timepicker:false,
    format:'F d, Y',
    scrollInput: false
  });
  //$('#work_date').val('<?php echo $wrkD;?>');
});


var $form = $('#whereEntry'),
$summands = $form.find('.startup-list input'),
$sumDisplay = $('#income_sum');

$form.delegate('.income_count input', 'change', function ()
{ alert('sa');
  var sum = 0;
  $summands.each(function ()
  {
    var value = Number($(this).val());
    if (!isNaN(value)) sum += value;
  });

  $sumDisplay.val(sum);
});
</script>

