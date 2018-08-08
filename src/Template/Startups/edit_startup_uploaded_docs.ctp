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
                <li class="active">Current Startups</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Edit</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
           <?= $this->Form->create($startups,['id'=>'FormField', 'enctype' => 'multipart/form-data', 'context' =>['validator' => 'editUploadedDocs']]) ?>
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
               <div class="form-group">
                    <div class="row">
                    <div class="col-lg-8 col-md-8 col-sm-12 ">
                    <label>Startup Roadmap</label>
                      <?php 
                          echo $this->Form->input('roadmap_id', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'title'=>'Select Roadmap','data-size'=>'10', 'type'=>'select',  'options' => $roadmaps));
                      ?>
                      <?php 
                           echo $this->Form->error('roadmap_id', null, array('class' => 'error-message'));
                      ?>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-12 no_paddingleftcol ">
                    <label>Select File</label>
                    <button  id="roadmapImage" class="uploadBtn" type="button">Browse File</button>
                    <span class="imgUpload alignCenter" id="imgUpload"></span>
                     <?php
                       echo $this->Form->input('file_path', ARRAY('label' => false, 'div' => false,'type' => 'file','style'=>'display:none;','id'=>'roadmap_graphic'));
                     ?>
                    </div>
                    </div>
               </div>
               <div class="form-group">
               <label>File Name</label>
                <?php
                     echo $this->Form->input('name', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'File Name','class' => 'form-control'));
                ?>
                <?php 
                     echo $this->Form->error('name', null, array('class' => 'error-message'));
                ?>
               </div>
               <p class="subHeading">Document Access Rights for Team Members</p>

               <div class="checkbox">
               <div class="form-group">

                  <?php $c=1; if($UserId != $startupDetails['user_id']){ ?> 
                  <input type="checkbox"  id="part<?php echo $c;?>" class="checkinput"/> 
                  <?php } ?>

                  <label for="part<?php echo $c;?>" >
                    <?php 

                      $startUserId= $startupDetails['user_id'];
                        if(!empty($startupDetails['user']['entrepreneur_basic']['first_name'])){

                             echo $startupDetails['user']['entrepreneur_basic']['first_name'].' '.$startupDetails['user']['entrepreneur_basic']['last_name'];
                        }else {
                              echo $startupDetails['user']['first_name'].' '.$startupDetails['user']['last_name'];;
                        }
                    ?>
                  (Entrepreneur)
                  </label> 
               </div>
               <?php 
                $accessUsers= explode(',',$startups->access);
               foreach($startupMemberLists as $startupsMemberList){ $c++;
                    if(in_array($startupsMemberList->user->id, $accessUsers)) {
                      $checked= 'checked="checked"';
                    }else {
                      $checked='';
                    }
                    ?>
                   <div class="form-group">
                    <input type="checkbox"  id="part<?php echo $c; ?>" name="access[]" class="checkinput" value="<?php echo $startupsMemberList->user->id;?>" <?php echo $checked;?> />
                    <label for="part<?php echo $c; ?>" > <?php echo $startupsMemberList->user->first_name.' '.$startupsMemberList->user->last_name; ?></label> 
                   </div>

               <?php } ?>
               
               <div class="radio">
               <div class="form-group">
                <input type="radio"  id="selectAll" name="radio" /> <label for="selectAll" >Select All Team members</label> 
                <input type="radio"  id="deselectAll" name="radio" /> <label for="deselectAll" >Deselect All Team Members</label> 
               </div>
               </div>
               <div class="checkbox">
                <div class="form-group">
                <input type="checkbox" <?php if($startups->public == 0){ echo 'checked="checked"';}else { }?>  id="part9" name="public"/> <label for="part9" > Public Access to Document</label> 
               </div>
               </div>


                 <div class="form-group  pull-left">

                    <?php
                      if($UserId == $startupDetails['user_id']){
                              echo $this->Html->link('Back ', array('controller'=>'Startups','action'=>'editStartupDocs',$startupId), array('escape'=>false, 'class'=>'customBtn blueBtn'));
                      } else{
                        echo $this->Html->link('Back ', array('controller'=>'Startups','action'=>'viewStartupDocs',$startupId), array('escape'=>false, 'class'=>'customBtn blueBtn'));  
                      }                          
                    ?>
                  
                </div>
                 <div class="form-group  pull-right">
                   <?= $this->Form->button('Update',['class'=> 'customBtn blueBtn']) ?>
                </div>
              </div>
            
            
          </div>
          <?= $this->Form->end() ?>
  </div>
        <!-- /#page-content-wrapper -->

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
        if($.inArray(ext, ["doc", "docx", "pdf","PDF","DOCX","DOC"]) == -1) {
           $('#imgUpload').html('Invalid! Allowed extensions are .PDF, .DOC, .DOCX. Max upload size 5MB');
          //$('<div id="custerro" class="message error" onclick="return closeError();">Invalid! These files extension are allowed: .jpg, .jpeg, .gif, .png</div>').insertBefore('.container-fluid');
        }else {
           readURL(this);
        }
    });

});
</script>       