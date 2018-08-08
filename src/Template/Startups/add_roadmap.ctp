
 <?= $this->Form->create($roadmap,['id'=>'FormField']) ?>

<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Roadmap:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          echo $this->Form->input('roadmap_id',['label' => false, 'div' => false,'id' => '','placeholder'=>'Username','type'=>'select','options'=>$roadmaplist,'empty'=>'Select Roadmap']);
       ?>
      </div>
</div>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Next Step:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          echo $this->Form->input('next_step_1',['label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'FirstName','maxlength' => '50']);
       ?>
      </div>
</div>

<div id="endform">
 <?= $this->Form->button(__('Submit')) ?>
 <?= $this->Form->end() ?>
</div
