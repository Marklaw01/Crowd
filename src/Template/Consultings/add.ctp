<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li><?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li> <?php
            echo $this->Html->link('Opportunities', array('controller'=>'BetaTesters','action'=>'index'), array('escape'=>false));
        ?></li>
        <li class="active">Consulting</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
     <div class="page_heading">
       <h1>Add Consulting Project</h1> 
      </div>
    </div>
    
  </div>
  <!-- header ends --> 
  <?= $this->Form->create($fund,['enctype' => 'multipart/form-data']) ?>
    <div class="row">
      <div class="col-lg-6 col-md-6 col-sm-12 ">
      
        <div class="form-group">
            <label>Consulting Project Title</label>
            <?php
              echo $this->Form->input('title', ARRAY('label' => false, 'div' => false, 'error' => false, 'id' => '','placeholder'=>'Consulting Project Title','class' => 'form-control','type'=>'text'));
            ?>
            <?php 
                  echo $this->Form->error('title', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Project Overview</label>
            <?php
              echo $this->Form->input('overview', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Project Overview','class' => 'form-control'));
            ?>
            <?php 
                echo $this->Form->error('overview', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Description/Condition</label>
            <?php
              echo $this->Form->input('description', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Description/Condition','class' => 'form-control'));
            ?>
            <?php 
                echo $this->Form->error('description', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Target Keywords</label>
            <span class="form-control textAreaKeyword" id="selectedResult31">
              <ul>
              <?php 
                if(isset($_POST['submit'])){
                  
                  if(isset($_POST['target_keywords_id'])){
                    $skey31= $_POST['target_keywords_id'];
                  }else{
                    $skey31=[];
                  }
                  
                  $cc31 =count($skey31);
                  if(!empty($skey31[0])){
                        for($v31=0; $v31<$cc31; $v31++){
                              $slids31=$skey31[$v31];
                              //echo $slids;
                              //echo $Keywords[$slids];
                              echo '<li id="sel_'.$slids31.'"><a onClick="removeSelection31('.$slids31.')" href="javascript:void(0)">'.$keywordsLists[$slids31].'<i class="fa fa-close"></i></a></li>';
                        }
                    }
                }
              ?>
              </ul>
            </span>
        
            <?php
              echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard31','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Keywords", 'options'=>$keywordsLists));
            ?>  
            
            <select name="target_keywords_id[]" multiple="" id="hiddenKey31" style="display: none;">
              <?php
                if(!empty($skey31[0])){
                       for($vv31=0;$vv31<$cc31;$vv31++){?>
                           <option id="sel_<?php echo $skey31[$vv31]?>" selected="selected" value="<?php echo $skey31[$vv31]?>"></option>
                       <?php }?>
              <?php }?>
            </select>

            <?php 
              echo $this->Form->error('target_keywords_id', null, array('class' => 'error-message'));
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
        
        <div class="form-group">
            <label>Interest Keywords</label>
          
            <span class="form-control textAreaKeyword" id="selectedResult22">
              <ul>
              <?php 
                if(isset($_POST['submit'])){
                  
                  if(isset($_POST['interest_keyword_id'])){
                    $skey22= $_POST['interest_keyword_id'];
                  }else{
                    $skey22=[];
                  }
                  
                  $cc22 =count($skey22);
                  if(!empty($skey22[0])){
                        for($v22=0; $v22<$cc22; $v22++){
                              $slids22=$skey22[$v22];
                              //echo $slids;
                              //echo $Keywords[$slids];
                              echo '<li id="sel_'.$slids22.'"><a onClick="removeSelection22('.$slids22.')" href="javascript:void(0)">'.$intrestKeywordLists[$slids22].'<i class="fa fa-close"></i></a></li>';
                        }
                    }
                }
              ?>
              </ul>
            </span>
        
            <?php
              echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard22','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Target Market", 'options'=>$intrestKeywordLists));
            ?>  
            
            <select name="interest_keyword_id[]" multiple="" id="hiddenKey22" style="display: none;">
              <?php
                if(!empty($skey22[0])){
                       for($vv22=0;$vv22<$cc22;$vv22++){?>
                           <option id="sel_<?php echo $skey22[$vv22]?>" selected="selected" value="<?php echo $skey22[$vv22]?>"></option>
                       <?php }?>
              <?php }?>
            </select>

            <?php 
              echo $this->Form->error('interest_keyword_id', null, array('class' => 'error-message'));
            ?>
            <script type="text/javascript">
              $(function() {
                $("#standard22").customselect();
              });
              function removeSelection22(id){
                //alert(id);
                $('#selectedResult22 #sel_'+id).remove();
                $('#hiddenKey22 #sel_'+id).remove();
              }
            </script>
        </div>

        <div class="form-group">
            <label>Target Date to Distribute Project Overview</label>
            <?php
                echo $this->Form->input('client_overview_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Target Date to Distribute Project Overview','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('client_overview_date', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Deadline for Intent to Bid</label>
            <?php
                echo $this->Form->input('bid_intent_deadline_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Deadline for Intent to Bid','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('bid_intent_deadline_date', null, array('class' => 'error-message'));
            ?>
        </div>
        
        <div class="form-group">
            <label>Target Date to Distribute Project Requirements</label>
            <?php
                echo $this->Form->input('requirement_distribute_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Target Date to Distribute Project Requirements','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('requirement_distribute_date', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Deadline for commitment to bid</label>
            <?php
                echo $this->Form->input('bid_commitment_deadline_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Deadline for commitment to bid','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('bid_commitment_deadline_date', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Deadline for Questions</label>
            <?php
                echo $this->Form->input('question_deadline_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Deadline for Questions','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('question_deadline_date', null, array('class' => 'error-message'));
            ?>
        </div>

      </div>

      <div class="col-lg-6 col-md-6 col-sm-12 ">

        <div class="form-group">
            <label>Target Date for Answers</label>
            <?php
                echo $this->Form->input('answer_target_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Target Date for Answers','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('answer_target_date', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Deadline for Proposals</label>
            <?php
                echo $this->Form->input('proposal_submit_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Deadline for Proposals','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('proposal_submit_date', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Target Date for Bidder Presentations</label>
            <?php
                echo $this->Form->input('bidder_presentation_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Target Date for Bidder Presentations','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('bidder_presentation_date', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Target Date to Award the Project</label>
            <?php
                echo $this->Form->input('project_award_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Target Date to Award the Project','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('project_award_date', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Target Project Start Date</label>
            <?php
                echo $this->Form->input('project_start_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Target Project Start Date','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('project_start_date', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group">
            <label>Target Project End Date</label>
            <?php
                echo $this->Form->input('project_complete_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Target Project End Date','maxlength' => '50','class'=> 'testTimePicker form-control'));
            ?>
            <?php 
                echo $this->Form->error('project_complete_date', null, array('class' => 'error-message'));
            ?>
        </div>

        <div class="form-group ">
          <div class="upload_frame ">
              <div class="halfDivisionleft"> 
                <span class="form-control">Image</span>
              </div>
              <div class="halfDivisionright">
              <button type="button" id="campaign_image_browse" class="uploadBtn">Upload File</button>
              <span id="filename_camp"></span>
                <?php
                    echo $this->Form->input('image', ARRAY('label' => false, 'id'=>'campaign_image', 'div' => false,'type' => 'file', 'style'=>'display:none;'));
                 ?>
              </div>
          </div>
        </div> 

        <div class="form-group ">
         <div class="upload_frame " id="uploadMedia">
          <div class="halfDivisionleft"> 
              <select class="form-control" name="file_type[]">
                    <option value="doc">DOC</option>
               </select>
          </div>
          <div class="halfDivisionright">
          <button type="button" id="doc_browse" class="uploadBtn">Upload File</button> 
          <span id="filename_doc"></span>
               <?php
                  echo $this->Form->input('document', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'doc_name'));
               ?>    
          </div> 
         </div>
        </div>

        <div class="form-group">
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
                  echo $this->Form->input('audio', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp3_name'));
               ?>    
          </div> 
         </div> 
        </div>

        <div class="form-group">
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
                  echo $this->Form->input('video', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp4_name'));
               ?>    
          </div> 
         </div>
        </div>

        <div class="form-group">
         <div class="upload_frame " id="">
          <div class="halfDivisionleft"> 
              <select class="form-control" name="file_type[]">
                    <option value="mp4">question</option>
               </select>
          </div>
          <div class="halfDivisionright">
          <button type="button" id="q_browse" class="uploadBtn">Upload File</button> 
          <span id="filename_q"></span> 
               <?php
                  echo $this->Form->input('question', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'q_name'));
               ?>    
          </div> 
         </div>
        </div>

        <div class="form-group">
         <div class="upload_frame " id="">
          <div class="halfDivisionleft"> 
              <select class="form-control" name="file_type[]">
                    <option value="mp4">final bid</option>
               </select>
          </div>
          <div class="halfDivisionright">
          <button type="button" id="fb_browse" class="uploadBtn">Upload File</button> 
          <span id="filename_fb"></span> 
               <?php
                  echo $this->Form->input('final_bid', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'fb_name'));
               ?>    
          </div> 
         </div>
        </div>

      </div>

      <div class="col-lg-12 col-md-12 col-sm-12 ">
        <span style="color: red;">You can only upload the following file types .mp3, mp4 and .pdf. The maximum size for each file is 20 MB.</span>
      </div>

      <div class="col-lg-12 col-md-12 col-sm-12 ">
        <div class="form-group  pull-right">
           <?= $this->Form->button('Submit',['name'=>'submit','class'=> 'customBtn blueBtn']) ?>
        </div>
     </div>

    </div>
 <?= $this->Form->end() ?>            
</div>

<script>
    $(document).ready(function () {

        $('#target_amount').priceFormat({
              prefix: '$'
        });

     });

    //Upload triger
    $('#campaign_image_browse').click(function(){ $('#campaign_image').trigger('click'); });
    $("#campaign_image").change(function(){
      var filename = $('#campaign_image').val();
      $('#filename_camp').html(filename);
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

    $('#q_browse').click(function(){ $('#q_name').trigger('click'); });
    $("#q_name").change(function(){
      var filename = $('#q_name').val();
      $('#filename_q').html(filename);
    });

    $('#fb_browse').click(function(){ $('#fb_name').trigger('click'); });
    $("#fb_name").change(function(){
      var filename = $('#fb_name').val();
      $('#filename_fb').html(filename);
    });

    $('.testpicker').datetimepicker({
      timepicker:false,
      format:'F d, Y',
      minDate: 0,
      scrollInput: false
    });

    $('.testTimePicker').datetimepicker({
      format:'F d, Y, g:i A',
      formatTime: 'g:i A',
      step:30,
      ampm: true,
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