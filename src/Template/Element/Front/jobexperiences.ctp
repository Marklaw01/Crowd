
<div class="col-lg-8 col-md-8 col-sm-12 " id="customDiv<?php echo $id;?>" >
    <div class="">
        <a class="addNewApp" id="addPreScn" onclick="bindAlert('customDiv<?php echo $id;?>')" href="javascript:void(0)"><img alt="" src="<?php echo $this->request->webroot;?>images/removeIcon.png"></a>
    </div>

    <div class="form-group">
      <label>Company Name</label>
      <?php
        echo $this->Form->input('company_name['.$id.']', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control','id' => 'company_name','type'=>'text', 'placeholder'=>'Company Name'));
      ?> 
    </div>  

    <div class="form-group">
      <label>Job Title</label>
      <?php
        echo $this->Form->input('job_title['.$id.']', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control','id' => 'job_title','type'=>'text', 'placeholder'=>'Job Title'));
      ?> 
    </div>

    <div class="form-group">
      <label>Start Date</label>
      <?php
        echo $this->Form->input('start_date['.$id.']', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control testpickerStart','id' => 'start_date1','type'=>'text', 'placeholder'=>'Start Date'));
      ?> 
    </div>  

    <div class="form-group">
      <label>End Date</label>
      <?php
        echo $this->Form->input('end_date['.$id.']', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control testpicker','id' => 'end_date1','type'=>'text', 'placeholder'=>'End Date'));
      ?> 
    </div>  

    <div class="form-group">
      <label>Comapany Url</label>
      <?php
        echo $this->Form->input('company_url['.$id.']', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control','id' => 'company_url','type'=>'text', 'placeholder'=>'Comapany Url'));
      ?> 
    </div>

    <div class="form-group">
      <label>Job Role</label>
      <?php
        echo $this->Form->input('job_role_id['.$id.']', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'job_role_id','type'=>'select','title'=>'Select Job Role','data-size'=>'10', 'empty'=>'Select Job Role','multiple'=>true, 'options'=>$JobRoles));
      ?>
    </div>

    <div class="form-group">
      <label>Job Duties</label>
      <?php
        echo $this->Form->input('job_duty_id['.$id.']', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'job_duty_id','type'=>'text','title'=>'Job Duties'));
      ?>
      <?php
        //echo $this->Form->input('job_duty_id['.$id.']', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'job_duty_id','type'=>'select','title'=>'Select Job Duties','data-size'=>'10', 'empty'=>'Select Job Duties','multiple'=>true, 'options'=>$JobDuties));
      ?>
    </div>

    <div class="form-group">
      <label>Job Achievements</label>
      <?php
       echo $this->Form->input('job_achievement_id['.$id.']', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'job_achievement_id','type'=>'text','title'=>'Job Achievements'));
      ?>
      <?php
       // echo $this->Form->input('job_achievement_id['.$id.']', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'job_achievement_id','type'=>'select','title'=>'Select Job Achievements','data-size'=>'10', 'empty'=>'Select Job Achievements','multiple'=>true, 'options'=>$JobAchievements));
      ?>
    </div>        

</div>