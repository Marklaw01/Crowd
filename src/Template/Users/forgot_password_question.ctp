<div class="container container_login">
<div class="login_block">
      <div class="logo_section">
        <img src="<?php echo $this->request->webroot;?>images/logo.png">
      </div>
      <div class="login_section forgot_password col-lg-6 col-md-12">
          <?= $this->Form->create($users,['id'=>'FormField','context' => ['validator' => 'forgotPassQuestion']]) ?>
              <h2>Forgot Password?</h2>
                  <div class="form-group">
                    <div class="input-group">
                    
                        <div class="input-group-addon"><img src="<?php echo $this->request->webroot;?>images/mail.png" alt""></div>
                        <?php
                          echo $this->Form->input('email', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'email','placeholder'=>'Email','maxlength' => '50','readonly','value'=>$users[0]->email));
                       ?>
                    </div>
                  </div>

              <?php if(!empty($questions)){?>     
                  <div class="form-group">
                    <div class="input-group">
                    <div class="input-group-addon" style="height: 50px;"><i class="fa fa-question-circle "> </i></div>
                      <select class="selectpicker form-control show-tick " name="question" title="Select Question" >
                          <option value="<?php echo $questions->id;?>"><?php echo $questions->name;?></option>
                      </select>
                    </div>
                  </div>

                  <div class="form-group">                   
                      <?php
                          echo $this->Form->input('answer', ARRAY('label' => false, 'div' => false, 'class' => 'form-control','autocomplete'=>'off', 'id' => 'answer','type'=>'text'));
                      ?>                    
                  </div>
              <?php }?>

            <!-- Selct for own question -->
              <?php if(!empty($OwnqId)){?>     
                  <div class="form-group">
                    <div class="input-group">
                    <div class="input-group-addon" style="height: 50px;"><i class="fa fa-question-circle "> </i></div>
                      <select class="selectpicker form-control show-tick " name="question" title="Select Question" >
                          <option value="<?php echo $OwnqId;?>"><?php echo $OwnqId;?></option>
                      </select>
                    </div>
                  </div>

                  <div class="form-group">                   
                      <?php
                          echo $this->Form->input('answer', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'answer','type'=>'text'));
                      ?>                    
                  </div>
              <?php }?>

                  <div class="form-group">
                  <?php if(empty($hidebutton)){ ?>
                  <?= $this->Form->button('Reset Password',['class'=> 'customBtn blueBtn width50 pull-left']) ?>
                  <?php } ?>
                  <?= $this->Html->link(__('Back'), ['action' => 'forgotPassword'],['class'=>'pull-right']) ?>
                  </div>            
          <?= $this->Form->end() ?>
      </div>
  </div>
</div>
<script type="text/javascript">
  $( window ).load(function() {
  
   var homepage_height = $(window).height();
  $(".container_login").css("height",homepage_height);
});

</script>


