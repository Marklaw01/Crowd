<div id="page-content-wrapper">
<div class="container-fluid">
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <h1 class="page-header"><i class=" fa fa-arrow-circle-up"></i>Startup's Workorder
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
                  <li role="presentation" ><a href="#team" aria-controls="team" role="tab" data-toggle="tab" onclick="location.href='<?php echo $teaM;?>'">Team</a></li>
                  <?php
                  $workOrd= $this->Url->build(["controller" => "Startups","action" => "workorder",$startupId]);
                  ?>
                  <li role="presentation" class="active"><a href="#workOrder" aria-controls="workOrder" role="tab" data-toggle="tab" onclick="location.href='<?php echo $workOrd;?>'">Work Orders</a></li>
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
                  <div role="tabpanel" class="tab-pane  whiteBg" id="team">

                  </div>

                  <div role="tabpanel" class="tab-pane active whiteBg" id="workOrder">
                    
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

                                          <th>Status</th>
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

                                        
                                          <?php if($startup->status==1){?>
                                              <span style="color:#088223"> Accepted </span>
                                          <?php } else if($startup->status==2){?>
                                              <span style="color:#f00"> Rejected</span>
                                          <?php }else { ?>
                                              <span style="color:#337ab7"> Pending</span>
                                          <?php } //Check Units Sum not 0 End ?>

                                        
                                        </td>
                                        
                                        </tr>
                                      <?php } // for loop End?>  
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

