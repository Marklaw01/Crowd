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

$cakeDescription = 'Crowd Bootstrap-Admin';
?>
<!DOCTYPE html>
<html>
<?php $useLoggedIn=$this->request->session()->read('Auth.User');
 $action= $this->request->action;
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
    <?= $this->Html->css('jquery.datetimepicker.css'); ?>
    <?= $this->Html->css('admin/css/bootstrap.css');?> 
    <?= $this->Html->css('admin/css/custom-style.css'); ?>
    <?= $this->Html->css('admin/css/font-awesome.css'); ?>
    <?= $this->Html->css('validationEngine.jquery');?> 
    <?= $this->Html->css('search/jquery-customselect.css'); ?>

    <?= $this->fetch('script') ?> 
    <?= $this->Html->script('jquery-1.11.3.min.js');?> 
    <?= $this->Html->script('bootstrap.min.js');?> 
    <?= $this->Html->script('jquery.datetimepicker.full.js');?>
    <?= $this->Html->script('jquery.validationEngine'); ?>
    <?= $this->Html->script('jquery.validationEngine-en'); ?>   
    <?= $this->Html->script('search/jquery-customselect.js'); ?>
    <?= $this->Html->script("tinymce/tinymce.min") ?>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.inputmask/3.1.62/jquery.inputmask.bundle.js"></script>
   <script src="<?php echo $this->request->webroot;?>js/phone.js"></script>

</head>

<?php if($useLoggedIn){ ?> 
<body class="">
    <div id="wrapper" class="toggled">
        <?php    
           echo $this->element('Front/admin_sidebar');
        ?>
            <?= $this->Flash->render() ?>  
            <?= $this->fetch('content') ?>
    </div>        
</body>

<?php } else { ?>  

<body class="loginPanel">  
          <?= $this->Flash->render() ?>  
          <?= $this->fetch('content') ?>
</body>  

<?php } ?>
<script type="text/javascript">
    tinymce.init({
      selector: "textarea",
      plugins: [
        "advlist autolink lists link image charmap print preview anchor",
        "searchreplace visualblocks code fullscreen",
        "insertdatetime media table contextmenu paste"
      ],
      toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image source"
      });
               
    </script>
 
</html>
