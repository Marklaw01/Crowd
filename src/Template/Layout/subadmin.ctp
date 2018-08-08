<?php
/**
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @since         0.10.0
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 */

$cakeDescription = 'Crowd Bootstrap';
?>
<!DOCTYPE html>
<html>
<?php $useLoggedIn=$this->request->session()->read('Auth.User');
$action= $this->request->action;
$userRole= $useLoggedIn['role_id'];
?>
<head>
  <?= $this->Html->charset() ?>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>
    <?= $cakeDescription ?>:
    <?= $this->fetch('title') ?>
  </title>
  <?php 
  $this->Html->meta(
    'favicon.ico',
    '/favicon.ico',
    ['type' => 'icon']
    );
    ?>
    <meta name="viewport" content = "width = device-width, initial-scale = 1.0, minimum-scale = 1, maximum-scale = 1.0 , user-scalable = no"/>
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,300italic,400italic,600,600italic,700,700italic,800,800italic' rel='stylesheet' type='text/css'>
    
    <?= $this->Html->meta('icon') ?>
    <?= $this->fetch('meta') ?>
    <?= $this->fetch('css') ?>
    <?= $this->Html->css('validationEngine.jquery');?> 
    <?= $this->Html->css('jquery.datetimepicker.css'); ?>
    
    <?= $this->Html->css('bootstrap.css'); ?>
    <?= $this->Html->css('style.css'); ?>
    <?= $this->Html->css('skdslider.css'); ?>
    <?= $this->Html->css('error.css'); ?>
    <?= $this->Html->css('font-awesome.css'); ?>

    
    <?= $this->Html->css('search/jquery-customselect.css'); ?>

    <?= $this->fetch('script') ?> 

    <?= $this->Html->script('jquery'); ?>
    <?= $this->Html->script('jquery-1.11.3.min.js');?>
    <?= $this->Html->script('jquery.validationEngine'); ?>
    <?= $this->Html->script('jquery.validationEngine-en'); ?>
    <?= $this->Html->script('jquery.slimscroll.min.js');?>
    <?= $this->Html->script('bootstrap.min');?>   
    <?= $this->Html->script('bootstrap-tabcollapse.js');?>
    <?= $this->Html->script('jquery.datetimepicker.js');?>
    <?= $this->Html->script('jquery.price_format.min.js');?>
    <?= $this->Html->script('skdslider.js');?>
    <?php echo $this->Html->script('custom.js');?>
    <?= $this->Html->script('search/jquery-customselect.js'); ?> 
    <?= $this->Html->script("tinymce/tinymce.min") ?>
    <?php if($action !== 'register' && $action !=='myProfile'){ 
     echo $this->Html->css('bootstrap-select.css');
     echo $this->Html->script('bootstrap-select.min.js');  
   }
   ?>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/3.1.62/jquery.inputmask.bundle.js"></script>
   <script src="<?php echo $this->request->webroot;?>js/phone.js"></script>
   
   
   <script>
    $(document).ready(function(){
      $('#demo1').skdslider({'delay':5000, 'animationSpeed': 2000,'showNextPrev':true,'showPlayButton':true,'autoSlide':true,'animationType':'fading'});
    });
  </script>
  <?php //$this->Html->css('base.css') ?>
  <?php //$this->Html->css('cake.css') ?>

</head>

<body class="<?php if($action == 'login' or $action =='forgotPassword' or $action =='forgotPasswordQuestion' or $action =='resetPassword') { echo "homepage_bg"; }?> ">

  <?php if($useLoggedIn){ ?> 
  <!-- If user Logged in -->
  <?php if($userRole == 3){  ?>
  
      <div id="wrapper" class="toggled">
          <button type="button" class="hamburger" data-toggle="offcanvas"> <span class="hamb-top"></span>
          <span class="hamb-middle"></span> <span class="hamb-bottom"></span> 
          </button>
          
          <!-- To header HTML -->
          <nav class="navbar navbar-inverse navbar-fixed-top top-Bar">
            <div class="container-fluid">
              <div class="row">
                <div class="col-lg-2 col-md-2 col-sm-3 col-xs-12">
                  <div class="navbar-header">
                    <?php
                    $thumb_img = $this->Html->image('small-logo.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link( $thumb_img, array('controller'=>'Pages','action'=>'display', 'home'),
                                           array('escape'=>false,'class'=>'navbar-brand'));
                    ?>
                  </div>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-6 col-xs-12 horzontal-advertise">
                  <a href="#"><img src="<?php echo $this->request->webroot;?>images/add.png" alt=""> </a> 
                </div>
 
              </div>
            </div>
          </nav>

          <!-- Include sidebar -->
          <?php    
                        
              echo $this->element('Front/subadmin_sidebar');
 
          ?>

          <div id="page-content-wrapper">

                <?= $this->Flash->render() ?>  
                <?= $this->fetch('content') ?>

          </div><!-- page wraper end --> 
      </div><!-- page wraper end -->     
 

<?php }else{ // if End for admin user check ?>

      <div class="errorMsg" style="text-align: center; margin-top: 50px;">

          <?php echo $this->Html->image('404-error.png'); ?>
            <div class="clearfix"></div>
            <a  onclick="history.back()" class="back-button" style="cursor: pointer;"><i class="fa fa-home"></i> Go Back</a> Default
          </br>
      </div>
<?php  } ?>


<?php } else { ?>  <!-- If user not logged in --> 

              <?= $this->Flash->render() ?>  
              <?= $this->fetch('content') ?>

<?php } ?>

<script type="text/javascript">
    tinymce.init({
      selector: ".refer textarea",
      plugins: [
        "advlist autolink lists link image charmap print preview anchor",
        "searchreplace visualblocks code fullscreen",
        "insertdatetime media table contextmenu paste"
      ],
      toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image source"
      });
               
    </script>

</body>
</html>
