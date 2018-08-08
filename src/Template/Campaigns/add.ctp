<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Campaigns', array('controller'=>'campaigns','action'=>'myCampaign'), array('escape'=>false));
                ?></li>
                <li class="active">Add Campaign</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Add Campaign</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <?= $this->Form->create($campaign,['enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
              

              <div class="form-group">
              <label>Campaign Name</label>
                <?php
                  echo $this->Form->input('campaigns_name', ARRAY('label' => false, 'div' => false, 'error' => false, 'id' => '','placeholder'=>'Campaign Name','class' => 'form-control'));
                ?>
                <?php 
                      echo $this->Form->error('campaigns_name', null, array('class' => 'error-message'));
                ?>
              </div>

              <div class="form-group">
              <label>Select Startup</label>
                <?php
                  echo $this->Form->input('startup_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'validate[required]form-control selectpicker form-control show-tick','id' => 'startup_id','type'=>'select','title'=>"Select Startup", 'options'=>$startups));
                ?> 
                <?php 
                      echo $this->Form->error('startup_id', null, array('class' => 'error-message'));
                ?>
              </div>
              
                <?php
                  //echo $this->Form->input('keywords', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','title'=>'Keywords', 'data-size'=>'5', 'multiple'=>'""', 'options'=>$Keywords));
                ?>
              <div class="form-group">
              <label>Target Market</label>
                  <span class="form-control textAreaKeyword" id="selectedResult1">
                      <ul>
                      </ul>
                  </span>
              
                  <?php
                      echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard1','type'=>'select','title'=>'Target Market','multiple'=>false, 'size'=>'','empty'=>'Target Market', 'options'=>$Keywords));
                  ?>  
                  
                  <select name="keywords[]" multiple="" id="hiddenKey1" style="display: none;">

                  </select>
                  <?php 
                    echo $this->Form->error('keywords', null, array('class' => 'error-message'));
                  ?>
                  <script type="text/javascript">
                          $(function() {
                            $("#standard1").customselect();
                          });
                          function removeSelection1(id){
                            //alert(id);
                            $('#selectedResult1 #sel_'+id).remove();
                            $('#hiddenKey1 #sel_'+id).remove();
                          }
                  </script>
              </div> 

              <div class="form-group">
              <label>Campaign Keyword</label>
                  <span class="form-control textAreaKeyword" id="selectedResult2">
                      <ul>
                      </ul>
                  </span>
              
                  <?php
                      echo $this->Form->input('keywordsTwo2', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard2','type'=>'select','title'=>'Campaign Keyword','multiple'=>false, 'size'=>'','empty'=>'Campaign Keyword', 'options'=>$campKeywords));
                  ?>  
                  
                  <select name="campaign_keywords[]" multiple="" id="hiddenKey2" style="display: none;">

                  </select>
                  <?php 
                    echo $this->Form->error('campaign_keywords', null, array('class' => 'error-message'));
                  ?>
                  <script type="text/javascript">
                          $(function() {
                            $("#standard2").customselect();
                          });
                          function removeSelection2(id){
                            //alert(id);
                            $('#selectedResult2 #sel_'+id).remove();
                            $('#hiddenKey2 #sel_'+id).remove();
                          }
                  </script>
              </div>               
          
              <div class="form-group">
              <label>Due Date</label>
                <?php
                  echo $this->Form->input('due_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Due Date','maxlength' => '50','class'=> 'testpicker form-control'));
                ?>
                <?php 
                      echo $this->Form->error('due_date', null, array('class' => 'error-message'));
                ?>
              </div>
              <div class="form-group">
              <label>Target Amount</label>
                <?php
                  echo $this->Form->input('target_amount', ARRAY('label' => false, 'div' => false,'error' => false, 'placeholder'=>'Target Amount','class' => 'form-control', 'type'=>'text','id'=>'target_amount'));
                ?>
                <?php 
                      echo $this->Form->error('target_amount', null, array('class' => 'error-message'));
                ?>
              </div>
             <!-- <div class="form-group">
                <?php
                   //echo $this->Form->input('fund_raised_so_far', ARRAY('label' => false, 'error' => false, 'div' => false,'class' => 'form-control','placeholder'=>'Fund Raised So Far', 'type'=>'text'));
                ?>
                <?php 
                     // echo $this->Form->error('fund_raised_so_far', null, array('class' => 'error-message'));
                ?>
              </div>--> 
              <div class="form-group">
              <label>Summary</label>
                 <?php
                    echo $this->Form->input('summary', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Summary','class' => 'form-control'));
                 ?>
                 <?php 
                      echo $this->Form->error('summary', null, array('class' => 'error-message'));
                ?>
              </div>
              </div>
              </div>
              <div class="col-lg-8 col-md-8 col-sm-12 ">
                <div class="upload_frame ">
                      <div class="halfDivisionleft"> 
                        <span class="form-control">Campaign Image</span>
                      </div>
                      <div class="halfDivisionright">
                      <button type="button" id="campaign_image_browse" class="uploadBtn">Upload File</button>
                      <span id="filename_camp"></span>
                        <?php
                            echo $this->Form->input('campaign_image', ARRAY('label' => false, 'id'=>'campaign_image', 'div' => false,'type' => 'file', 'style'=>'display:none;'));
                         ?>
                      </div>
                  </div>
                </div> 
              

              <div class="col-lg-8 col-md-8 col-sm-12 ">
               <div class="upload_frame " id="uploadMedia">
                <div class="halfDivisionleft"> 
                    <select class="form-control" name="file_type[]">
                          <option value="doc">PDF</option>
                     </select>
                </div>
                <div class="halfDivisionright">
                <button type="button" id="doc_browse" class="uploadBtn">Upload File</button> 
                <span id="filename_doc"></span>
                     <?php
                        echo $this->Form->input('files[]', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'doc_name'));
                     ?>    
                </div> 
               </div>
               <!--<span id="addMedia"><a href="javascript:void(0)" id="addMoreMedia">Add More</a></span>-->
              </div>

              <div class="col-lg-8 col-md-8 col-sm-12 ">
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
                        echo $this->Form->input('files[]', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp3_name'));
                     ?>    
                </div> 
               </div> 
              </div>

              <div class="col-lg-8 col-md-8 col-sm-12 ">
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
                        echo $this->Form->input('files[]', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp4_name'));
                     ?>    
                </div> 
               </div>
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

    /* $( "#target_amount" ).change(function() {
          var amount = $(this).val();
          var i = parseFloat(amount);
          if(isNaN(i)) { i = 0.00; }
          var minus = '';
          if(i < 0) { minus = '-'; }
          i = Math.abs(i);
          i = parseInt((i + .005) * 100);
          i = i / 100;
          s = new String(i);
          if(s.indexOf('.') < 0) { s += '.00'; }
          if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
          s = minus + s;
          $('#target_amount').val(s);

      });*/

      /*$( "#fund_raised_so_far" ).change(function() {
          var amount = $(this).val();
          var i = parseFloat(amount);
          if(isNaN(i)) { i = 0.00; }
          var minus = '';
          if(i < 0) { minus = '-'; }
          i = Math.abs(i);
          i = parseInt((i + .005) * 100);
          i = i / 100;
          s = new String(i);
          if(s.indexOf('.') < 0) { s += '.00'; }
          if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
          s = minus + s;
          $('#fund_raised_so_far').val(s);

      });*/

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