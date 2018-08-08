<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li><?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li class="active">Post a Message</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
     <div class="page_heading">
       <h1>Post a Message</h1> 
      </div>
    </div>
    
  </div>
  <!-- header ends --> 
  <?= $this->Form->create($UserFeeds,['enctype' => 'multipart/form-data']) ?>
    <div class="row">
      <div class="col-lg-8 col-md-8 col-sm-12 ">
          <!-- <div class="form-group">
            <label>Hardware Title</label>
            <?php
              //echo $this->Form->input('title', ARRAY('label' => false, 'div' => false, 'error' => false, 'id' => '','placeholder'=>'Hardware Title','class' => 'form-control','type'=>'text'));
            ?>
            <?php 
                 // echo $this->Form->error('title', null, array('class' => 'error-message'));
            ?>
          </div> -->
        <div class="form-group">
            <label>Message</label>
             <?php
                echo $this->Form->input('message', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Message','class' => 'form-control'));
             ?>
             <?php 
                  echo $this->Form->error('message', null, array('class' => 'error-message'));
            ?>
        </div>
      </div>
    </div>

    <div class="col-lg-8 col-md-8 col-sm-12 ">
      <div class="upload_frame ">
          <div class="halfDivisionleft"> 
            <select class="form-control" name="file_type[]">
                  <option value="file1">File 1</option>
            </select>
          </div>
          <div class="halfDivisionright">
            <button type="button" id="campaign_image_browse" class="uploadBtn">Upload File</button>
            <span id="filename_camp"></span>
            <?php
                echo $this->Form->input('file1', ARRAY('label' => false, 'id'=>'campaign_image', 'div' => false,'type' => 'file', 'style'=>'display:none;'));
             ?>
          </div>
      </div>
    </div> 
      
    <div class="col-lg-8 col-md-8 col-sm-12 ">
      <div class="upload_frame " id="uploadMedia">
        <div class="halfDivisionleft"> 
            <select class="form-control" name="file_type[]">
                  <option value="file2">File 2</option>
            </select>
        </div>
        <div class="halfDivisionright">
          <button type="button" id="doc_browse" class="uploadBtn">Upload File</button> 
          <span id="filename_doc"></span>
             <?php
                echo $this->Form->input('file2', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'doc_name'));
             ?>    
        </div> 
      </div>
    </div>

    <div class="col-lg-8 col-md-8 col-sm-12 ">
      <div class="upload_frame " id="">
        <div class="halfDivisionleft"> 
            <select class="form-control" name="file_type[]">
                  <option value="file3">File 3</option>
             </select>
        </div>
        <div class="halfDivisionright"> 
          <button type="button" id="mp3_browse" class="uploadBtn">Upload File</button> 
          <span id="filename_mp3"></span>
           <?php
              echo $this->Form->input('file3', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp3_name'));
           ?>    
      </div> 
     </div> 
    </div>

    <div class="col-lg-8 col-md-8 col-sm-12 ">
      <div class="upload_frame " id="">
        <div class="halfDivisionleft"> 
            <select class="form-control" name="file_type[]">
                  <option value="file4">File 4</option>
             </select>
        </div>
        <div class="halfDivisionright">
          <button type="button" id="mp4_browse" class="uploadBtn">Upload File</button> 
          <span id="filename_mp4"></span> 
           <?php
              echo $this->Form->input('file4', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp4_name'));
           ?>    
      </div> 
     </div>
    </div>

    <div class="col-lg-8 col-md-8 col-sm-12 ">
      <span style="color: red;">You can only upload the following file types PNG,GIF,JPEG,JPG, PDF, DOCX, SRS, PPT, MP3,  MP4, MPG, WMV. The maximum size for each file is 20 MB.</span>
    </div>

    <div class="col-lg-8 col-md-8 col-sm-12 ">
      <div class="form-group  pull-right">
         <?= $this->Form->button('Submit',['name'=>'submit','class'=> 'customBtn blueBtn']) ?>
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