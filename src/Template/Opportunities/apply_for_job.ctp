<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Opportunities', array('controller'=>'Opportunities','action'=>'index'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Jobs', array('controller'=>'Opportunities','action'=>'Jobs'), array('escape'=>false));
                ?></li>
                <li class="active">Apply Job</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Apply Job</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <?= $this->Form->create($JobApplies,['enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
              

              <div class="form-group">
              <label>Job </label>
                <span class="form-control">
                  <strong><?php echo $jobDetails->job_title; ?>, </strong>
                  <?php if(!empty($jobDetails->state_id)){ echo $jobDetails->state->name.', '; }?> 
                  <?php if(!empty($jobDetails->country_id)){ echo $jobDetails->country->name; }?>
                  
                </span>
              </div>

              <div class="form-group">
              <label>Name</label>
                <?php
                 $userName= $jobDetails->user->first_name.' '.$jobDetails->user->last_name; 

                  echo $this->Form->input('name', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control','id' => 'name','type'=>'text', 'placeholder'=>'Name', 'value'=>$loguserName));
                ?> 
                <?php 
                      echo $this->Form->error('name', null, array('class' => 'error-message'));
                ?>
              </div>              

              <div class="form-group">
              <label>Summary</label>
                 <?php
                    echo $this->Form->input('summary', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Summary','class' => 'form-control'));
                 ?>
                 <?php 
                      echo $this->Form->error('summary', null, array('class' => 'error-message'));
                ?>
              </div>

              <div class="form-group">
              <label>Cover Letter</label>
                 <?php
                    echo $this->Form->input('coverletter_text', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Cover Letter','class' => 'form-control'));
                 ?>
                 <?php 
                      echo $this->Form->error('coverletter_text', null, array('class' => 'error-message'));
                ?>
              </div>
            </div>
          </div>

              <div class="col-lg-8 col-md-8 col-sm-12 ">
                <div class="upload_frame ">
                      <div class="halfDivisionleft"> 
                        <span class="form-control">Upload Cover Letter</span>
                      </div>
                      <div class="halfDivisionright">
                      <button type="button" id="campaign_image_browse" class="uploadBtn">Upload Cover Letter</button>
                      <span id="filename_camp"></span>
                        <?php
                            echo $this->Form->input('coverletter_doc', ARRAY('label' => false, 'id'=>'coverletter_doc', 'div' => false,'type' => 'file', 'style'=>'display:none;'));
                        ?>
                      </div>
                  </div>
                </div> 

              

              <div class="col-lg-8 col-md-8 col-sm-12 ">
                <div class="upload_frame ">
                  <div class="halfDivisionleft"> 
                    <span class="form-control">Add Experience</span>
                  </div>
                  <div class="halfDivisionright">
                    
                    <?php
                        echo $this->Html->link('Add Experience', array('controller'=>'Opportunities','action'=>'addExperiences'), array('escape'=>false,'class'=>'uploadBtn'));
                    ?>
                  </div>
                </div>
              </div> 

              <div class="col-lg-8 col-md-8 col-sm-12 ">
                <div class="form-group">
                  <label>Experience </label>
                  <ul class="job-experiences">
                    <?php
                      if(!empty($experienceList)){
                        $job_experience_id= $experienceList->id;
                        $experienceList=json_decode($experienceList->experience_details);
                        foreach ($experienceList as $key => $value) {
                          echo '<li>';
                            echo '<span class="main">';

                                echo '<strong>'.$value->company_name.'</strong>';
                                echo '<br/>';
                                echo '<span class="company">'.$value->company_url.'</span>';
                                echo '<span class="dates">'.$value->start_date.' To '.$value->end_date.'</span>';

                            echo '</span>';
                          echo '</li>';
                        }
                      }else{
                      $job_experience_id= '';
                    ?>
                        <li> No Experience found. </li>

                    <?php } ?>
                  </ul>
                  <?php
                    echo $this->Form->input('job_experience_id', ARRAY('label' => false, 'id'=>'job_experience_id', 'div' => false,'type' => 'hidden', 'value'=>$job_experience_id));
                  ?>
                  <?php 
                      echo $this->Form->error('job_experience_id', null, array('class' => 'error-message'));
                 ?>
               </div>
              </div>

              <div class="col-lg-8 col-md-8 col-sm-12 ">
               <div class="upload_frame " id="uploadMedia">
                <div class="halfDivisionleft"> 
                    <select class="form-control" name="file_type[]">
                          <option value="doc">Resume</option>
                     </select>
                </div>
                <div class="halfDivisionright">
                <button type="button" id="doc_browse" class="uploadBtn">Resume</button> 
                <span id="filename_doc"></span>
                     <?php
                        echo $this->Form->input('resume', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'resume'));
                     ?>    
                </div> 
               </div>
               <!--<span id="addMedia"><a href="javascript:void(0)" id="addMoreMedia">Add More</a></span>-->
              </div>

              <div class="col-lg-8 col-md-8 col-sm-12 ">
                <div class="form-group  pull-right">
                   <?= $this->Form->button('Submit',['class'=> 'customBtn blueBtn']) ?>
                </div>
             </div>
          </div>
         <?= $this->Form->end() ?>
        </div>
        <!-- /#page-content-wrapper --> 


        

<script>
$(document).ready(function () {

    $('#target_amount').priceFormat({
          prefix: '$'
    });

 });

//Upload triger
$('#campaign_image_browse').click(function(){ $('#coverletter_doc').trigger('click'); });
$("#coverletter_doc").change(function(){
  var filename = $('#coverletter_doc').val();
  $('#filename_camp').html(filename);
}); 

$('#doc_browse').click(function(){ $('#resume').trigger('click'); });
$("#resume").change(function(){
  var filename = $('#resume').val();
  $('#filename_doc').html(filename);
}); 


$('.testpicker').datetimepicker({
  timepicker:false,
  format:'F d, Y',
  minDate: 0,
  scrollInput: false
});



// Add More Media Options

$('#addMoreMedia').click(function(e) {
   var y =1;
   var cdivId= 'myMedia_'+y;
   var divId= "'"+cdivId+"'";
   var mediaList = $('#uploadMedia').html();

   $('<div class="upload_frame" id="myMedia_'+y+'">'+mediaList+' <a href="javascript:void(0)" id="remScnt" onclick="bindAlertOwn('+divId+')" class="remove_field">Remove</a></div>').insertBefore('#addMedia');
   y++;
});

//Remove Appended HTML
function bindAlertOwn(count){
   $('#'+count).remove();

}

</script>