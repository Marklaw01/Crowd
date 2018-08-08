 <!--wrapper starts here-->
 <div class="loginWrapper">
  <div class="logo">
    <img src="<?php echo $this->request->webroot;?>img/small-logo.png" alt="Crowdbootstrap">
  </div>

  <!--form starts here--> 
  <?= $this->Form->create('',['class'=>'loginForm']) ?>
    <div class="form-group">
     <label for="exampleInputEmail1">Email address</label>
     <div class="input-group">
      <span class="input-group-addon" >
        <i class="fa fa-envelope"></i>
      </span>
      <?php
            echo $this->Form->input('email', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'required'=>'required','autocomplete'=>'on','id' => '','placeholder'=>'Email Address'));
      ?>
    </div>
  </div>

  <div class="form-group"> 
   <a href="login" class="forgotLink">Back to Login.</a>
   <button type="submit" class="btn redColor alignRight">Reset Password</button>

 </div>
<?= $this->Form->end() ?>
<!--form ends here--> 
</div>