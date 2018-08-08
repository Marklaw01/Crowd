
 <?= $this->Form->create($startup,['id'=>'FormField']) ?>
<!-- <div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Select User:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
         // echo $this->Form->input('role_id', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'Lastname','maxlength' => '50','type'=>'select','empty'=>'Select User','options'=>$rolelist));
       ?>
      </div>
</div> -->
<input type="hidden" name="user_id" value=<?php echo $this->request->Session()->read('Auth.User.id'); ?>>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Name:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          echo $this->Form->input('name', ARRAY('label' => false, 'div' => false,'id' => '','placeholder'=>'Username','maxlength' => '50'));
       ?>
      </div>
</div>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Description:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          echo $this->Form->input('description', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'FirstName','maxlength' => '50'));
       ?>
      </div>
</div>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Roadmap:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          echo $this->Form->input('roadmap', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'Lastname','maxlength' => '50'));
       ?>
      </div>
</div>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Next step:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          echo $this->Form->input('next_step', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'Email','maxlength' => '50'));
       ?>
      </div>
</div>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Keyword:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          echo $this->Form->input('keywords', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'keyword','maxlength' => '50'));
       ?>
      </div>
</div>
<div class="formGroup">
      <label class="controLabel col3 textLeft" for="username">Support Required:<span class="required-start">*</span></label>
      <div class="col9">          
       <?php
          echo $this->Form->input('support_required', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'Support Required','maxlength' => '50'));
       ?>
      </div>
</div>
<div id="endform">
 <?= $this->Form->button(__('Submit')) ?>
 <?= $this->Form->end() ?>
</div
