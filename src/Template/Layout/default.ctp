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
<html prefix="og: http://ogp.me/ns#">
<?php $useLoggedIn=$this->request->session()->read('Auth.User');
$action= $this->request->action;
$userRole= $useLoggedIn['role_id'];
$actual_link = "http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
$web="http://$_SERVER[HTTP_HOST]";
?>
<head>
  <meta property="og:title" content="Crowd Bootstrap" />
  <meta property="og:type" content="website" />
  <meta property="og:description" content="Crowd Bootstrap helps entrepreneurs accelerate their journey from a startup idea to initial revenues. It is a free App that enables you to benefit as an entrepreneur or help as an expert" />
  <meta property="og:url" content="<?php echo $actual_link;?>" />
  <meta property="og:image" content="<?php echo $web;?>/images/logo.png" />

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
   <script>
    window.fbAsyncInit = function() {
      FB.init({
        appId      : '1772822902981170',
        xfbml      : true,
        version    : 'v2.8'
      });
    };

    (function(d, s, id){
       var js, fjs = d.getElementsByTagName(s)[0];
       if (d.getElementById(id)) {return;}
       js = d.createElement(s); js.id = id;
       js.src = "//connect.facebook.net/en_US/sdk.js";
       fjs.parentNode.insertBefore(js, fjs);
     }(document, 'script', 'facebook-jssdk'));
  </script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/3.1.62/jquery.inputmask.bundle.js"></script>
   <script src="<?php echo $this->request->webroot;?>js/phone.js"></script>
   
   
   <script>
    $(document).ready(function(){
      $('#demo1').skdslider({'delay':5000, 'animationSpeed': 2000,'showNextPrev':true,'showPlayButton':true,'autoSlide':true,'animationType':'fading'});
    });
  </script>
  
 <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<script>
  (adsbygoogle = window.adsbygoogle || []).push({
    google_ad_client: "ca-pub-8967062168456369",
    enable_page_level_ads: true
  });
</script>
  <?php //$this->Html->css('base.css') ?>
  <?php //$this->Html->css('cake.css') ?>

</head>

<body class="<?php if($action == 'login' or $action =='forgotPassword' or $action =='forgotPasswordQuestion' or $action =='resetPassword' or $action =='resendConfirmation') { echo "homepage_bg"; }?> ">

  

  <?php if($useLoggedIn){ ?> 
  <!-- If user Logged in n -->
  <?php if($userRole == 2){ // if End for user check  ?>

      <div id="wrapper" class="<?php  //if(strtolower($this->request->params['action']) !='gettingstarted'){ ?> toggled <?php //} ?>">
          <button type="button" class="hamburger" data-toggle="offcanvas"> <span class="hamb-top"></span> <span class="hamb-middle"></span> <span class="hamb-bottom"></span> 
          </button>

          <!-- To header HTML -->
          <nav class="navbar navbar-inverse navbar-fixed-top top-Bar">
            <div class="container-fluid">
              <div class="row">
                <div class="col-lg-2 col-md-2 col-sm-3 col-xs-12">
                  <div class="navbar-header">
                    <?php
                    $thumb_img = $this->Html->image('small-logo.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link( $thumb_img, array('controller'=>'Pages','action'=>'display', 'home'), array('escape'=>false,'class'=>'navbar-brand'));
                    ?>
                  </div>
                </div>
                <div class="col-lg-7 col-md-7 col-sm-6 col-xs-12 horzontal-advertise">
                  <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>

                  <!-- <ins class="adsbygoogle"
                       style="display:inline-block;width:728px;height:90px"
                       data-ad-client="ca-pub-8877526086007040"
                       data-ad-slot="8484280015"></ins>
                  <script>
                  (adsbygoogle = window.adsbygoogle || []).push({});
                  </script> -->
                  <a href="#"><img src="<?php echo $this->request->webroot;?>images/add.png" alt=""> </a> 
                </div>

                <div  class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
                  <div class="notifiaction-count">
                    <div class="circle-icon">
                      <a href="javascript:void(0);" onclick="updateCounter('no');"><i class="fa fa-bell-o"></i></a>
                    </div>
                    <div class="product-count" style="display: none;">
                      <span id="notify_counter">0</span>
                    </div>
                    <div class="notify-droppdown">
                      <div class="arrow-up"></div>
                      <ul class="navbar" id="notify">

                      </ul>
                    </div>
                  </div>
                  <?php 
                  if($this->request->session()->read('Auth.User')) {
                    $loginIcon = $this->Html->image('logout.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i class="fa fa-power-off"></i><span class="hidden-sm hidden-xs"> Logout</span>', array('controller'=>'Users','action'=>'logout'), array('escape'=>false,'class'=>'customBtn greyBtn user-power'));
                  }else{     
                    $loginIcon = $this->Html->image('login.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$loginIcon.'</i> Login', array('controller'=>'Users','action'=>'login'), array('escape'=>false,'class'=>'customBtn greyBtn'));
                  } 
                  ?>
                </div>
              </div>
            </div>
          </nav>

          <!-- Include sidebar -->
          <?php    
                $UserIdLogg = $this->request->Session()->read('Auth.User.id');

                //if(strtolower($this->request->params['action']) !='gettingstarted') 
                //{      
                    if(strtolower($this->request->params['controller'])=='entrepreneurs') 
                    {           
                     echo $this->element('Front/entrepreneur_sidebar');

                    }else {
                     echo $this->element('Front/contractor_sidebar');        
                    }
                //}  
          ?>

          <div id="page-content-wrapper">

                <?= $this->Flash->render() ?>  
                <?= $this->fetch('content') ?>

          </div><!-- page wraper end --> 
      </div><!-- page wraper end -->     


      <script type="text/javascript">
       // Ajax for states list on page load
       function ajaxGetNotificationList () {
          var val = <?php echo $UserIdLogg;?>; //alert(val);
          $.ajax({ 
            url: "<?php echo $this->Url->build(["Controller" => "App","action" => "getNotifications"]);?>",
            data: {loginUserId:val},
            type : 'POST',
            cache: false,
            success: function(data) {

              $("#notify").html(data);
            }
          });

        }

         //Notification Counter
         function ajaxGetNewNotificationCount () {
          var val = <?php echo $UserIdLogg;?>; //alert(val);
          $.ajax({ 
            url: "<?php echo $this->Url->build(["Controller" => "App","action" => "getNotificationsCount"]);?>",
            data: {loginUserId:val},
            type : 'POST',
            cache: false,
            success: function(data) {
              if(data > 0){
                $('.product-count').show();
                $('#notify_counter').html(data);
              }else{
                $('.product-count').hide();
              }
            }
          });

        }

        ajaxGetNotificationList(); // This will run on page load
        ajaxGetNewNotificationCount();
        setInterval(function(){
          ajaxGetNotificationList(); // this will run after every 5 seconds
          ajaxGetNewNotificationCount();
        }, 5000); 

        
        // On click remove notification counter
        function updateCounter (status) {
          $('.product-count').hide();
          var val = <?php echo $UserIdLogg;?>; //alert(val);
          var status = status;
          $.ajax({ 
            url: "<?php echo $this->Url->build(["Controller" => "App","action" => "updateNotifications"]);?>",
            data: {loginUserId:val, readStatus:status},
            type : 'POST',
            cache: false,
            success: function(data) {

                    //$("#notify").html(data);
                  }
                });

        }

      </script>

<?php }else{ // if End for admin user check ?>

      <div class="errorMsg" style="text-align: center; margin-top: 50px;">

          <?php echo $this->Html->image('404-error.png'); ?>
            <div class="clearfix"></div>
            <a  onclick="history.back()" class="back-button" style="cursor: pointer;"><i class="fa fa-home"></i> Go Back</a> Default
          </br>
      </div>
<?php  } ?>


<?php } else { ?>  <!-- If user not logged in jj --> 

          <?php if(strtolower($this->request->params['action']) =='gettingstarted' or strtolower($this->request->params['action']) =='dashboard' or strtolower($this->request->params['action']) =='news'){ ?>
            <nav class="navbar navbar-inverse navbar-fixed-top top-Bar">
              <div class="container-fluid">
                <div class="row">
                  <div class="col-lg-2 col-md-2 col-sm-3 col-xs-12">
                    <div class="navbar-header">
                      <?php
                      $thumb_img = $this->Html->image('small-logo.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link( $thumb_img, array('controller'=>'Pages','action'=>'display', 'home'), array('escape'=>false,'class'=>'navbar-brand'));
                      ?>
                    </div>
                  </div>
                  <div class="col-lg-7 col-md-7 col-sm-6 col-xs-12 horzontal-advertise">
                    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
                    <!-- CrowdBootstrap -->
                    <!-- <ins class="adsbygoogle"
                         style="display:inline-block;width:728px;height:90px"
                         data-ad-client="ca-pub-8877526086007040"
                         data-ad-slot="8484280015"></ins>
                    <script>
                    (adsbygoogle = window.adsbygoogle || []).push({});
                    </script> -->
                   <a href="#"><img src="<?php echo $this->request->webroot;?>images/add.png" alt=""> </a>
                  </div>

                  <div  class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
                    <?php 
                    if($this->request->session()->read('Auth.User')) {
                      $loginIcon = $this->Html->image('logout.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i class="fa fa-power-off"></i><span class="hidden-sm hidden-xs"> Logout</span>', array('controller'=>'Users','action'=>'logout'), array('escape'=>false,'class'=>'customBtn greyBtn user-power'));
                    }else{     
                      $loginIcon = $this->Html->image('login.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$loginIcon.'</i> Login', array('controller'=>'Users','action'=>'login'), array('escape'=>false,'class'=>'customBtn greyBtn'));
                    } 
                    ?>
                  </div>
                </div>
              </div>
            </nav>
          <?php } ?>

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
