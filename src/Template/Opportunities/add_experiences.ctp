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
                <li class="active">Add Experiences</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Add Experiences</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <?= $this->Form->create($JobExperiences,['enctype' => 'multipart/form-data']) ?>
              <div class="row">
                <div class="col-lg-8 col-md-8 col-sm-12 ">

                  <div class="form-group">
                    <label>Company Name</label>
                    <?php
                      echo $this->Form->input('company_name[1]', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control','id' => 'company_name','type'=>'text', 'placeholder'=>'Company Name'));
                    ?> 
                  </div>  

                  <div class="form-group">
                    <label>Job Title</label>
                    <?php
                      echo $this->Form->input('job_title[1]', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control','id' => 'job_title','type'=>'text', 'placeholder'=>'Job Title'));
                    ?> 
                  </div>

                  <div class="form-group">
                    <label>Start Date</label>
                    <?php
                      echo $this->Form->input('start_date[1]', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control testpickerStart','id' => 'start_date1','type'=>'text', 'placeholder'=>'Start Date'));
                    ?> 
                  </div>  

                  <div class="form-group">
                    <label>End Date</label>
                    <?php
                      echo $this->Form->input('end_date[1]', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control testpicker','id' => 'end_date1','type'=>'text', 'placeholder'=>'End Date'));
                    ?> 
                  </div>  

                  <div class="form-group">
                    <label>Comapany Url</label>
                    <?php
                      echo $this->Form->input('company_url[1]', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control','id' => 'company_url','type'=>'text', 'placeholder'=>'Comapany Url'));
                    ?> 
                  </div>

                  <div class="form-group">
                    <label>Job Role</label>
                    <?php
                      echo $this->Form->input('job_role_id[1]', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'job_role_id','type'=>'select','title'=>'Select Job Role','data-size'=>'10', 'empty'=>'Select Job Role','multiple'=>true, 'options'=>$JobRoles));
                    ?>
                  </div>

                  <div class="form-group">
                    <label>Job Duties</label>
                    <?php
                      echo $this->Form->input('job_duty_id[1]', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'job_duty_id','type'=>'text'));
                    ?>
                    <?php
                      //echo $this->Form->input('job_duty_id[1]', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'job_duty_id','type'=>'select','title'=>'Select Job Duties','data-size'=>'10', 'empty'=>'Select Job Duties','multiple'=>true, 'options'=>$JobDuties));
                    ?>
                  </div>

                  <div class="form-group">
                    <label>Job Achievements</label>
                    <?php
                      echo $this->Form->input('job_achievement_id[1]', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'job_achievement_id','type'=>'text'));
                    ?>
                    <?php
                      //echo $this->Form->input('job_achievement_id[1]', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'job_achievement_id','type'=>'select','title'=>'Select Job Achievements','data-size'=>'10', 'empty'=>'Select Job Achievements','multiple'=>true, 'options'=>$JobAchievements));
                    ?>
                  </div>        

              </div>
              <span id="addHere"></span>
                 <div class="col-lg-8 col-md-8 col-sm-12 ">
                  <a class="addNewApp" id="addPreScn1" href="javascript:void(0)"><img alt="" src="<?php echo $this->request->webroot;?>images/addIcon.png"></a>
                 </div>
              <input type="hidden" id="qId" value="2">
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

// Ajax for states list
$(function(){
    $('#addPreScn1').click(function(){ 
    var val = $('#qId').val();
    $.ajax({ 
    url: "<?php echo $this->Url->build(["Controller" => "Opportunities","action" => "getExperienceList"]);?>",
    data: {id:val},
        type : 'POST',
        cache: false,
        calledByAjax: true,
    success: function(data) {

      $(data).insertBefore('#addHere');

      $('.selectpicker').selectpicker({
          size: 5
      });

      $('.testpickerStart').datetimepicker({
        timepicker:false,
        format:'F d, Y',
        scrollInput: false
      });
      $('.testpicker').datetimepicker({
        timepicker:false,
        format:'F d, Y',
        scrollInput: false
      });
      
     //$("#main_job_role"+val).html(button);

      $('#customDiv'+val).remove();
      
      val++;
      $('#qId').val(val); 
    }
       });

   });
});
function bindAlert(count){
   $('#'+count).remove();

}


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

$('.testpickerStart').datetimepicker({
  timepicker:false,
  format:'F d, Y',
  scrollInput: false
});

$('.testpicker').datetimepicker({
  timepicker:false,
  format:'F d, Y',
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