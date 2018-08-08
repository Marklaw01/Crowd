<!-- /#page-content-wrapper --> 
<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li> <?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li> <?php
            echo $this->Html->link('Opportunities', array('controller'=>'Opportunities','action'=>'index'), array('escape'=>false));
        ?></li>
        <li> <?php
            echo $this->Html->link('My Jobs', array('controller'=>'Opportunities','action'=>'recuiter'), array('escape'=>false));
        ?></li>
        <li class="active">Edit Jobs</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
     <div class="page_heading">
       <h1>Edit Jobs</h1> 
      </div>
    </div>
    
  </div>
 <!-- header ends --> 
 <div class="row">
  <?= $this->Form->create($jobs,['enctype' => 'multipart/form-data']) ?>  
    <div class="col-md-6 col-sm-6 col-xs-12"> 

        <div class="form-group">
            <label>Company</label>
            <select name="company_id" id="company" class="selectpicker form-control show-tick">
              <option value="">Select Company</option>
              <?php 
                foreach ($company as $key => $value) { ?>
                  <option value="<?php echo $value->sub_admin_detail->id;?>" <?php if($jobDetails->company_id == $value->sub_admin_detail->id){ echo 'selected="selected"';}else{}?> >
                    <?php echo $value->sub_admin_detail->company_name;?>
                  </option>
              <?php  } ?>
            </select>
              <?php 
                  echo $this->Form->error('company_id', null, array('class' => 'error-message'));
              ?>
        </div>

        <div class="form-group">
            <label>Industry</label>
            <?php
              $qali= explode(',', $jobDetails->industry_id);
              echo $this->Form->input('industry_id', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'industry_id','type'=>'select','title'=>'Select Industry','data-size'=>'10', 'empty'=>'Select Industry','multiple'=>true,'value'=>$qali, 'options'=>$jobindustry));
            ?>
        </div>

        <div class="form-group">
            <label>Job Title</label>
            <?php
              echo $this->Form->input('job_title', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[onlyLetterSp]]form-control form-control', 'id' => 'job_title','placeholder'=>'Job Title','value'=>$jobDetails->job_title));
            ?>
        </div>

        <div class="form-group">
            <label>Role</label>
            <?php
              echo $this->Form->input('role', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[onlyLetterSp]]form-control form-control', 'id' => 'role','placeholder'=>'Role', 'type'=>'text','value'=>$jobDetails->role));
            ?>
        </div>

        <div class="form-group">
            <label>Job Type</label>
            <?php
              echo $this->Form->input('job_type', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'job_type','type'=>'select','title'=>'Select Job Type','data-size'=>'10', 'empty'=>'Select Job Type','default'=>$jobDetails->job_type->id, 'options'=>$jobtype));
            ?>
        </div>

        <div class="form-group">
            <label>Minimum Work NPS</label>
            <?php
              echo $this->Form->input('min_work_nps', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'min_work_nps','placeholder'=>'Minimum Work NPS','type'=>'text','value'=>$jobDetails->min_work_nps));
            ?>
        </div>

        <div class="form-group">
            <label>Select Country</label>
            <?php
              echo $this->Form->input('country_id', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker1 form-control show-tick1', 'id' => 'country','type'=>'select','title'=>'Select Country','data-size'=>'10', 'empty'=>'Select Country','default'=>$jobDetails->country_id, 'options'=>$countrylist));
            ?>
        </div>

        <div class="form-group">
            <label>Select State</label>
            <?php
                echo $this->Form->input('state_id', ARRAY('label' => false, 'div' => false, 'class' => ' selectpicker1 form-control show-tick1', 'id' => 'state_id','type'=>'select','default'=>$jobDetails->state_id,'empty'=>'Select State'));
            ?>
        </div>

        <div class="form-group">
            <label>Location</label>
            <?php
              echo $this->Form->input('location', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[onlyLetterSp]]form-control form-control', 'id' => 'role','placeholder'=>'Location', 'type'=>'text','value'=>$jobDetails->location));
            ?>
        </div>

        <div class="form-group">
              <label>Description</label>
              <?php
                  echo $this->Form->input('description', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Description','class' => 'form-control','value'=>$jobDetails->description));
              ?>
              <?php 
                  echo $this->Form->error('description', null, array('class' => 'error-message'));
              ?>
        </div>
           
    </div>

    <div class="col-md-6 col-sm-6 col-xs-12"> 

          <div class="upload_frame " id="uploadMedia">
            <div class="halfDivisionleft"> 
                <select class="form-control" name="file_type[]">
                    <option value="doc">Doc</option>
                </select>
            </div>
            <div class="halfDivisionright">
              <button type="button" id="doc_browse" class="uploadBtn">Upload File</button> 
              <span id="filename_doc"></span>
               <?php
                  echo $this->Form->input('doc_name', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'doc_name'));
               ?>    
            </div> 
          </div>


          <div class="upload_frame " id="">
            <div class="halfDivisionleft"> 
                <select class="form-control" name="file_type[]">
                      <option value="mp3">mp3</option>
                 </select>
            </div>
            <div class="halfDivisionright"> 
              <button type="button" id="mp3_browse" class="uploadBtn">Upload File</button> 
              <span id="filename_mp3"></span>
                 <?php
                    echo $this->Form->input('mp3_name', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp3_name'));
                 ?>    
            </div> 
          </div> 

          <div class="upload_frame " id="">
            <div class="halfDivisionleft"> 
                <select class="form-control" name="file_type[]">
                      <option value="mp4">mp4</option>
                 </select>
            </div>
            <div class="halfDivisionright">
            <button type="button" id="mp4_browse" class="uploadBtn">Upload File</button> 
            <span id="filename_mp4"></span> 
                 <?php
                    echo $this->Form->input('mp4_name', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp4_name'));
                 ?>    
            </div> 
          </div>

          <div class="form-group">
            <label>Travel</label>
            <?php
              echo $this->Form->input('travel', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'travel','placeholder'=>'Travel','value'=>$jobDetails->travel));
            ?>
          </div>

          <div class="form-group">
                <label>Start Date</label>
                <?php
                  echo $this->Form->input('start_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'start_date','type'=>'text','placeholder'=>'Start Date','maxlength' => '50','class'=> 'testpicker form-control','value'=>$jobDetails->start_date));
                ?>
                <?php 
                      echo $this->Form->error('start_date', null, array('class' => 'error-message'));
                ?>
          </div>

          <div class="form-group">
                <label>End Date</label>
                <?php
                  echo $this->Form->input('end_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'end_date','type'=>'text','placeholder'=>'End Date','class'=> 'testpicker form-control','value'=>$jobDetails->end_date));
                ?>
                <?php 
                      echo $this->Form->error('end_date', null, array('class' => 'error-message'));
                ?>
          </div>

          <div class="form-group">
            <label>Skills</label>
            <?php
              $skl= explode(',', $jobDetails->skills);
              echo $this->Form->input('skills', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'skills','type'=>'select','title'=>'Skills','data-size'=>'10', 'empty'=>'Skills','multiple'=>true,'value'=>$skl, 'options'=>$skill));
            ?>
          </div>


          <div class="form-group">
              <label>Requirements</label>
              <?php
                echo $this->Form->input('requirements', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[onlyLetterSp]]form-control form-control', 'id' => 'requirements','placeholder'=>'Requirements','value'=>$jobDetails->requirements));
              ?>
          </div>
        
          <div class="form-group">
            <label>Job Posting Keywords</label>
            <?php
              //$jpkey = explode(',', $jobDetails->posting_keywords);
              //echo $this->Form->input('posting_keywords', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'posting_keywords','type'=>'select','title'=>'Select Job Posting Keywords','data-size'=>'10','value'=>$jpkey, 'empty'=>'Select Job Posting Keywords','multiple'=>true, 'options'=>$jobpostingkeyword));
            ?>

            <span class="form-control textAreaKeyword" id="selectedResult31">
                    <ul>
                    <?php 
                      if(isset($_POST['submit'])){
                          if(isset($_POST['posting_keywords'])){
                            $skey31= $_POST['posting_keywords'];
                          }else{
                            $skey31=explode(',', $jobDetails->posting_keywords);
                          }

                        }else{
                            $skey31=explode(',', $jobDetails->posting_keywords);
                        }
                        
                        $cc31 =count($skey31);
                        if(!empty($skey31[0])){
                              for($v31=0; $v31<$cc31; $v31++){
                                    $slids31=$skey31[$v31];
                                    //echo $slids;
                                    //echo $Keywords[$slids];
                                    echo '<li id="sel_'.$slids31.'"><a onClick="removeSelection31('.$slids31.')" href="javascript:void(0)">'.$jobpostingkeyword[$slids31].'<i class="fa fa-close"></i></a></li>';
                              }
                          }
                    ?>
                    </ul>
                </span>
              
                <?php
                    echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard31','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Keywords", 'options'=>$jobpostingkeyword));
                ?>  
                  
                <select name="posting_keywords[]" multiple="" id="hiddenKey31" style="display: none;">
                    <?php
                      if(!empty($skey31[0])){
                             for($vv31=0;$vv31<$cc31;$vv31++){?>
                                 <option id="sel_<?php echo $skey31[$vv31]?>" selected="selected" value="<?php echo $skey31[$vv31]?>"></option>
                             <?php }?>
                    <?php }?>
                </select>

                <?php 
                    echo $this->Form->error('posting_keywords', null, array('class' => 'error-message'));
                ?>
                <script type="text/javascript">
                  $(function() {
                    $("#standard31").customselect();
                  });
                  function removeSelection31(id){
                    //alert(id);
                    $('#selectedResult31 #sel_'+id).remove();
                    $('#hiddenKey31 #sel_'+id).remove();
                  }
                </script>


          </div>

        <div class="col-md-12 col-sm-12 col-xs-12">
          <div class="form-group">
            <?= $this->Form->button('Submit',['class'=> 'customBtn blueBtn  pull-right']) ?>
          </div>
        </div>       
    </div> 
 <?= $this->Form->end() ?>
</div>

<script type="text/javascript">
$('.testpicker').datetimepicker({
  timepicker:false,
  format:'F d, Y',
  minDate: 0,
  scrollInput: false
});


$('#doc_browse').click(function(){ $('#doc_name').trigger('click'); });
$("#doc_name").change(function(){
  var filename = $('#doc_name').val();
  $('#filename_doc').html(filename);
}); 

$('#mp3_browse').click(function(){ $('#mp3_name').trigger('click'); });
$("#mp3_name").change(function(){
  var filename = $('#mp3_name').val();
  $('#filename_mp3').html(filename);
});

$('#mp4_browse').click(function(){ $('#mp4_name').trigger('click'); });
$("#mp4_name").change(function(){
  var filename = $('#mp4_name').val();
  $('#filename_mp4').html(filename);
});
// Ajax for states list
$(function(){
    $('#country').change(function(){
    var val = $(this).val();
    $.ajax({ 
    url: "<?php echo $this->Url->build(["Controller" => "Users","action" => "getOptionsList"]);?>",
    data: {countryId:val},
        type : 'POST',
        cache: false,
    success: function(data) {
    $("#state_id").html(data);
        <?php if(!empty($state)){
             echo '$("#state").val("'.$state.'");';
        }?>
    }
       });

   });
});

// Ajax for states list on page load
$(document).ready(function(){
  var val = $('#country').val(); //alert(val);
  $.ajax({ 
      url: "<?php echo $this->Url->build(["Controller" => "Users","action" => "getOptionsList"]);?>",
      data: {countryId:val},
          type : 'POST',
          cache: false,
      success: function(data) {
      $("#state_id").html(data);
             <?php if(!empty($jobDetails->state_id)){
                echo '$("#state_id").val("'.$jobDetails->state_id.'");';
             }?>
      }
  });

  $('ggagag').insertBefore('#custom_terms');

});
</script>        
 
 
     