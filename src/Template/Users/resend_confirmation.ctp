<div class="container container_login">
  <div class="login_block">
      <div class="logo_section">
        <img src="<?php echo $this->request->webroot;?>images/logo.png">
      </div>
      <div class="login_section forgot_password">
          <?= $this->Form->create($user,['id'=>'FormField','context' => ['validator' => 'resendConfirmation']]) ?>
              <h2>Resend Confirmation Link</h2>
                  <div class="form-group">
                    <div class="input-group">
                    
                        <div class="input-group-addon">
                          <img src="<?php echo $this->request->webroot;?>images/mail.png" alt"">
                        </div>
                        <?php
                          echo $this->Form->input('email', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'form-control','autocomplete'=>'off', 'id' => 'email','placeholder'=>'Email Address','maxlength' => '50'));
                        ?>
                    </div>
                    <?php 
                          echo $this->Form->error('email', null, array('class' => 'error-message'));
                    ?>
                  </div>

                  <div class="form-group">
                  <?= $this->Form->button('Resend Confirmation',['class'=> 'customBtn blueBtn width50 pull-left']) ?>
                  <?= $this->Html->link(__('Back to Login'), ['action' => 'login'],['class'=>'pull-right']) ?>
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







 
