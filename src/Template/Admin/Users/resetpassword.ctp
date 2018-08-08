 <!--wrapper starts here-->
 <div class="loginWrapper">
  <div class="logo">
    <img src="<?php echo $this->request->webroot;?>img/small-logo.png" alt="Crowdbootstrap">
  </div>

  <!--form starts here--> 
  <?= $this->Form->create($user,['id'=>'FormField','class'=>'loginForm', 'context' => ['validator' => 'resetPass']]) ?>
    <div class="form-group">
     <label for="exampleInputEmail1">New Password</label>
     <div class="input-group">
      <span class="input-group-addon" >
        <i class="fa fa-envelope"></i>
      </span>
      
      <?php
          echo $this->Form->input('password1', ARRAY('type' => 'password' ,'label' => false, 'error' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'New Password','autocomplete'=>'off', 'maxlength' => '25'));      
      ?>
    </div>
    <?php 
      echo $this->Form->error('password1', null, array('class' => 'error-message'));
    ?>
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Confirm Password</label>
    <div class="input-group">
      <span class="input-group-addon" >
        <i class="fa fa-lock"></i>
      </span>
      <?php
          echo $this->Form->input('password2', ARRAY('label' => false,'error' => false, 'div' => false, 'class' => 'form-control', 'id' => 'confirm_password','placeholder'=>'Confirm Password','autocomplete'=>'off','maxlength' => '50','type'=>'password'));
      ?>
    </div>
    <?php 
      echo $this->Form->error('password1', null, array('class' => 'error-message'));
    ?>
  </div>
  <div class="form-group"> 
   <a href="login" class="forgotLink">Back to Login</a>
   <button type="submit" class="btn redColor alignRight">Reset Password</button>

 </div>
<?= $this->Form->end() ?>
<!--form ends here--> 
</div>