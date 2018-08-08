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
                <li class="active">Upload Startup Profile</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Upload Startup Profile</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
           <?= $this->Form->create($startup,['id'=>'FormField', 'enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
               <div class="form-group">
                    <div class="row upload-profile">
                   
                    <div class="col-lg-12 col-md-12 col-sm-12 ">
                    <button  id="roadmapImage" class="uploadBtn" type="button">Browse File</button>
                    <span class="imgUpload alignCenter" id="imgUpload"></span>
                     <?php
                       echo $this->Form->input('file_path', ARRAY('label' => false, 'div' => false,'type' => 'file','style'=>'','id'=>'roadmap_graphic'));
                     ?>
                    </div>
                    </div>
               </div>
               <div class="form-group">
               <label>File Name</label>
                <?php
                     echo $this->Form->input('file_name', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'File Name','class' => 'form-control'));
                ?>
                <?php 
                     echo $this->Form->error('file_name', null, array('class' => 'error-message'));
                ?>
               </div>
               
               <div class="form-group">
               <label>Startup Name</label>
                    <span class="form-control">
                        <?php echo $startupDetails->name;?>
                    </span>
               </div>
               <div class="form-group  pull-left">
                  <?php
                          echo $this->Html->link('Back ', array('controller'=>'Startups','action'=>'editStartupRoadmapdocs',$startupId), array('escape'=>false, 'class'=>'customBtn blueBtn'));
                  ?>
                </div>
                <div class="form-group  pull-right">
                   <?= $this->Form->button('Upload',['id'=>'upload_button', 'class'=> 'customBtn blueBtn']) ?>
                </div>
            
          </div>
          </div>
          <?= $this->Form->end() ?>
  </div>
        <!-- /#page-content-wrapper -->

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
           $('#imgUpload').html('Invalid! Allowed extensions are .PDF, .DOC, .DOCX. Max upload size 5MB.');
          //$('<div id="custerro" class="message error" onclick="return closeError();">Invalid! These files extension are allowed: .jpg, .jpeg, .gif, .png</div>').insertBefore('.container-fluid');
        }else {
           readURL(this);
        }
    });

});
</script>       










