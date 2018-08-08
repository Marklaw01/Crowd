<div class="container container_login">
<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>

    <div class="login_block">
        <div class="logo_section">
          <div class="logo">
            <img src="<?php echo $this->request->webroot;?>images/small-logo.png" width="300">
          </div>
          <div class="login_section">
             <?= $this->Form->create() ?>
              <h2>Login Now!</h2>
              <div class="form-group">
                <div class="input-group">
                <div class="input-group-addon"><img src="<?php echo $this->request->webroot;?>images/mail.png" alt""></div>
                      <?php
                         echo $this->Form->input('email', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'required'=>'required','autocomplete'=>'on','id' => '','placeholder'=>'Email Address'));
                       ?>
                </div>
               </div>
                <div class="form-group">
                <div class="input-group">
                <div class="input-group-addon"><img src="<?php echo $this->request->webroot;?>images/lock.png" alt""></div>
                      <?php
                         echo $this->Form->input('password', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','autocomplete'=>'off', 'required'=>'required','placeholder'=>'Password'));
                       ?>
                </div>
               </div>
                <div class="form-group">

                <?=$this->Html->link('SignUp',['controller'=>'users','action'=>'register'],['class'=>'customBtn greenBtn width45 pull-left']);?>
                <?= $this->Form->button('Login',['class'=> 'customBtn blueBtn width45 pull-right']) ?>

                <div class="clearfix"></div>
                </div>
                <div class="form-group">
                <?=$this->Html->link('Forgot Password?',['controller'=>'users','action'=>'forgot_password'],['class'=>'frgt_paswrd']);?>
                <?=$this->Html->link('About CrowdBootstrap',['controller'=>'Contractors','action'=>'dashboard'],['class'=>'pull-right']);?>
                </div>
                <div class="form-group">

                <?=$this->Html->link('Resend Confirmation Link',['controller'=>'users','action'=>'resend_confirmation'],['class'=>'pull-center']);?>

                <div class="clearfix"></div>
                </div>


            <?= $this->Form->end() ?>
          </div>
        </div>
        <div class="rightbox">
          <h2>
            Crowd Bootstrap&reg; - A Sweat Equity Accelerator<sup>SM</sup>  for Startups 
          </h2>
          <h4 class="smalltext">
            Patent Pending
          </h4>
          <div class="boxmain">
            <div class="entrprenurer">
              <img src="<?php echo $this->request->webroot;?>images/expex.png">
            </div>
            <!---<div class="helper">
              <img src="images/shutterstock.jpg">
            </div> -->
          </div>
          <ul class="points">
            <li>1. We provide a Lean Startup Roadmap&reg; that guides entrepreneurs from idea to revenues.</li>
            <li>2. We invest $100k of sweat equity into each Startup for a minority stake.</li>
            <li>3. Entrepreneurs use the sweat equity to pay for gigs from independent contractors.</li>
            <li>4. The independent contractors receive a stake in our Sweat Equity Fund<sup class="topper">SM</sup>.</li>
          </ul>
          <a href="#" class="signup">Sign up now to join our sharing community and help make entrepreneurial dreams come true.</a>
        </div>
      </div>
      <div class="clearfix"></div>
</div> 
<script type="text/javascript">
  $( window ).load(function() {
  
   var homepage_height = $(window).height();
  $(".container_login").css("height",homepage_height);
});

</script>