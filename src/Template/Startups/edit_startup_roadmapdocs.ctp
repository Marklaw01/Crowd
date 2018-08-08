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
                <li class="active">Startup Roadmap Docs</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Startup Roadmap Docs</h1> 
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
                  <li role="presentation"  ><a href="#workOrder" aria-controls="workOrder" role="tab" data-toggle="tab" onclick="location.href='<?php echo $workOrd;?>'">Billed Work Orders</a></li>
                  <?php
                  $dcs= $this->Url->build(["controller" => "Startups","action" => "editStartupDocs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#docs" aria-controls="docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $dcs;?>'">Docs</a></li>
                  <?php
                  $roadDcs= $this->Url->build(["controller" => "Startups","action" => "editStartupRoadmapdocs",$startupId]);
                  ?>
                  <li role="presentation" class="active"><a href="#roadmap-docs" aria-controls="roadmap-docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $roadDcs;?>'">Roadmap Docs</a></li>
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
                  <div id="workOrder" class="tab-pane whiteBg" role="tabpanel">
                  
                  </div>
                   <!--  4Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="docs">
 
                  </div>
                    <!--  5Tab -->
                   <div role="tabpanel" class="tab-pane whiteBg active" id="roadmap-docs">
                      <div class="links"> 
                        <?php
                        if($ApplicationStatus !=1){
                          echo $this->Html->link('<i class="fa fa-external-link"></i>Submit Application', array('controller'=>'Startups','action'=>'submitApplication',$startupId), array('escape'=>false, 'class'=>'customBtn blueBtn'));
                        }
                        ?>

                         
                         <?php
                         if($ProfileStatus !=1){
                          echo $this->Html->link('<i class="fa  fa-cloud-upload"></i>Upload Startup Profile ', array('controller'=>'Startups','action'=>'UploadStartupProfile',$startupId), array('escape'=>false, 'class'=>'customBtn greenBtn'));
                        }
                         ?>
                        
                      </div>
                      <p class="subHeading">Upload Roadmap</p>
                      <?= $this->Form->create($roadmap,['id'=>'FormField', 'enctype' => 'multipart/form-data' ]) ?>
                        <div class="row">
                           <div class="col-lg-9 col-md-9 col-sm-12 ">

                             <div class="form-group">
                                <label for="text1">Preferred Startup Stage</label>
                                <span class="form-control">
                                 <?php
                                  $ccount= count($PreferredAndNextStep);
                                  if(!empty($PreferredAndNextStep)){
                                    if($ccount>0){
                                      echo $first_key = $PreferredAndNextStep[0];
                                    }else {
                                      echo $first_key= $roadmaplist[0]['name'];
                                    }
                                  }else {
                                      echo $first_key= $roadmaplist[0]['name'];
                                  }
                                    echo $this->Form->input('preffered_startup_stage',['label' => false,'error' => false, 'div' => false,'id' => 'preffered_startup_stage','placeholder'=>'Preferred Startup Stage','type'=>'hidden', 'class'=>'form-control', 'value'=>$first_key]);
                                 ?>
                                 </span>
                                 <?php 
                                        echo $this->Form->error('preffered_startup_stage', null, array('class' => 'error-message'));
                                 ?>
                              </div>

                              <div class="form-group">
                                <label for="text2">Current Roadmap Deliverable</label>
                                <select id="current-roadmap" class="selectpicker form-control show-tick" required="required" data-size="10" title="Current Roadmap Deliverable" name="current_roadmap">
                                  <?php
                                  foreach($roadmaplist as $roadmaplistId){

                                    if(!in_array($roadmaplistId->id, $finalCompletedRoadmapIds)){ 
                                      //$PreferredAndNext[]= $roadmaplistId->name;
                                    ?>

                                    <option value="<?php echo $roadmaplistId->id; ?>"><?php echo $roadmaplistId->name; ?></option>  
                                   
                                  <?php    
                                    }
                                    
                                  }

                                    //echo $this->Form->input('current_roadmap', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'title'=>'Select Roadmap','data-size'=>'10', 'type'=>'select','options' => $roadmaplist));
                                  ?>
                                </select> 
                                
                                  <?php 
                                      echo $this->Form->error('current_roadmap', null, array('class' => 'error-message'));
                                  ?>
                               
                              </div>
                              <div class="form-group upload-roadmapdocs">
                                <label for="text3">Browse File (*)</label>

                                <button  id="roadmapImage" class="uploadBtn" type="button">Browse</button>
                                <span class="imgUpload alignCenter" id="imgUpload"></span>
                                 <?php
                                   echo $this->Form->input('file_path', ARRAY('label' => false,'error' => false, 'div' => false,'type' => 'file','style'=>'','id'=>'roadmap_graphic'));
                                 ?>
                                <?php 
                                      echo $this->Form->error('file_path', null, array('class' => 'error-message'));
                                  ?>
                              </div>
                              <div class="form-group">
                                <label for="text5">Completed</label>
                             <div class="radio">
                                <div class="form-group">
                                  <input id="radio1" type="radio" name="complete" value="1">
                                  <label for="radio1">Yes</label>
                                  <input id="radio2" type="radio" name="complete" value="0">
                                  <label for="radio2">No</label>
                                  <?php 
                                      echo $this->Form->error('complete', null, array('class' => 'error-message'));
                                  ?>
                                </div>
                             </div>
                              </div>

                               <div class="form-group">
                                <label for="text5">Next Step</label>
                                <!--<select name="next_step" class="selectpicker form-control show-tick " id="text5" title="solution"  >
                                  <option>Solution1</option>
                                  <option>Solution2</option>
                                  <option>Solution3</option>
                                </select>-->
                                
                                  <?php 
                                  $ccount= count($PreferredAndNextStep);
                                  $next='';
                                      if($ccount>1){
                                        $next = $PreferredAndNextStep[1];
                                      }else{
                                        $next= $roadmaplist[1]['name'];
                                      }
                                  ?>
                                

                                <select id="next_step" class="selectpicker form-control show-tick" required="required" data-size="10" title="Select Roadmap" name="next_step">
                                  <?php 
                                  foreach($roadmaplist as $roadmaplistId){

                                    if(!in_array($roadmaplistId->id, $finalCompletedRoadmapIds)){ 
                                      //$PreferredAndNext[]= $roadmaplistId->name;
                                    ?>

                                    <option <?php if($next ==$roadmaplistId->name){echo 'selected="selected"';} ?> value="<?php echo $roadmaplistId->name; ?>"><?php echo $roadmaplistId->name; ?></option>  
                                   
                                  <?php    
                                    }
                                    
                                  }
                                    //echo $this->Form->input('next_step',['label' => false,'error' => false, 'div' => false,'id' => 'next_step','placeholder'=>'Preferred Startup Stage','type'=>'hidden', 'class'=>'form-control', 'value'=>$next]);
                                  ?>  
                                  </select>
                                  <?php 
                                      echo $this->Form->error('next_step', null, array('class' => 'error-message'));
                                  ?>
                              </div>
                              <div class="form-group">
                                <?= $this->Form->button('Update',['id'=>'upload_button','class'=> 'customBtn blueBtn pull-right']) ?>
                              </div>
                           </div> 
                         </div>
                      <?= $this->Form->end() ?>
                  
                   <div class="clearfix"></div>
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

$('#upload_button').click(function(){
var iselct= $('#roadmap_graphic').val();
  if(iselct == ''){
   $('#imgUpload').html('Please select file.');
  }
});

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
        if($.inArray(ext, ["doc", "docx", "pdf","PDF","DOCX","DOC"]) == -1) {
           $('#imgUpload').html('Invalid! Allowed extensions are .PDF, .DOC, .DOCX. Max upload size 5MB');
          //$('<div id="custerro" class="message error" onclick="return closeError();">Invalid! These files extension are allowed: .jpg, .jpeg, .gif, .png</div>').insertBefore('.container-fluid');
        }else {
           readURL(this);
        }
    });

});
</script>
