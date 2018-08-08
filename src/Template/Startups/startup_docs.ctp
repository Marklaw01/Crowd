<div>
<?php echo $this->Html->link("Intro",ARRAY('controller'=>'startups','action'=>'EditStartup/'.$project_id),ARRAY('class'=>"focus"));?>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<?php echo $this->Html->link("Team",ARRAY('controller'=>'startups','action'=>'EditStartup/'.$project_id),ARRAY('class'=>""));?>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<?php echo $this->Html->link("Work Orders",ARRAY('controller'=>'startups','action'=>'EditStartup/'.$project_id),ARRAY('class'=>""));?>&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<?php echo $this->Html->link("Docs",ARRAY('controller'=>'startups','action'=>'EditStartup/'.$project_id),ARRAY('class'=>""));?>&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<?php echo $this->Html->link("StartupDocs",ARRAY('controller'=>'startups','action'=>'StartupDocs/'.$project_id),ARRAY('class'=>""));?>&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</div>
<br/>

<div>
  <h5 style = "text-align: center;color:#FF5333 ;"><?php echo "Approve Your Startup";?></h5>
<?php echo $this->Html->link('Upload Startup Profile',['controller'=>'Startups','action'=>'UploadStartupProfile/'.$project_id]);?><br/>
<?php echo $this->Html->link('Submit Application',['controller'=>'Startups','action'=>'UploadStartupProfile']);?>
</div>
 
 <h5 style = "text-align: center;color:#FF5333 ;"><?php echo "Upload Roadmap";?></h5>
 <?= $this->Form->create($startup,['id'=>'FormField','enctype'=>'multipart/form-data']) ?>

 <?php $options = ['Problem' => 'Problem', 'Solution' => 'Solution','Implementation'=>'Implementation'];?>

<input type="hidden" name="user_id" value=<?php echo $this->request->Session()->read('Auth.User.id'); ?>>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Previous Roadmap Deliverable:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          if(!empty($startup['previous_roadmap'])){
          echo $this->Form->input('previous_roadmap', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => 'old_roadmap','placeholder'=>'Support Required','maxlength' => '50'));
          }
          else{
            echo $this->Form->input('previous_roadmap', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => 'old_roadmap','placeholder'=>'Support Required','maxlength' => '50','value'=>'Problem'));
          }
       ?>
      </div>
</div>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Current Roadmap Deliverable:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          
          echo $this->Form->input('roadmap_id', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'State','maxlength' => '50','type'=>'select','empty'=>'Select Roadmap','options'=>$roadmap));
          
       ?>
      </div>
</div>

<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Select Document:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          echo $this->Form->input('file_path', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'keyword','maxlength' => '50','type'=>'file'));
       ?>
      </div>
</div>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Complete ?:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
           $radio = [1=>'Yes', 0=>'No'];
          echo $this->Form->input('complete', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'Support Required','type' => 'radio','options'=>$radio));
       ?>
      </div>
</div>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Next Step:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php

       echo $this->Form->input('next_step', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'State','maxlength' => '50','type'=>'select','empty'=>'Select Roadmap','options'=>$options));
       ?>
      </div>
</div>

</div>
<div id="endform">
 <?= $this->Form->button(__('Submit')) ?>
 <?= $this->Form->end() ?>
</div>
<script>
$(document).ready(function () {
$("#old_roadmap").keypress(function(event) {event.preventDefault();});
});
</script>