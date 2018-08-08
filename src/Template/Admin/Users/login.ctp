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
    <label for="exampleInputPassword1">Password</label>
    <div class="input-group">
      <span class="input-group-addon" >
        <i class="fa fa-lock"></i>
      </span>
      <?php
            echo $this->Form->input('password', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','autocomplete'=>'off', 'required'=>'required','placeholder'=>'Password'));
      ?>
    </div>
  </div>
  <div class="form-group"> 
   <a href="forgotpassword" class="forgotLink">Forgot Password?</a>
   <button type="submit" class="btn redColor alignRight">Login</button>

 </div>
<?= $this->Form->end() ?>
<!--form ends here--> 
</div>