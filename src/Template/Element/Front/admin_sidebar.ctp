<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
      <div class="navbar-header">
       <?php
          //$thumb_img = $this->Html->image('small-logo.png',array('alt'=>'Crowd Bootstrap','class'=>''));
          echo $this->Html->link('Crowdbootstrap', array('action'=>'index'), array('escape'=>false,'class'=>'navbar-brand'));
       ?>
      </div>
       <button type="button" class="hamburger is-closed animated fadeInLeft" data-toggle="offcanvas"> <span class="hamb-top"></span> <span class="hamb-middle"></span> <span class="hamb-bottom"></span> </button>
      <div id="navbar">
        <ul class="nav navbar-nav navbar-right">
          <li class="dropdown">
            <a href="#" id="navbarDrop3" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><i class="fa fa-user"></i> <span class="caret"></span></a>
            <ul class="dropdown-menu" aria-labelledby="navbarDrop3">
              <li><a href="#"><i class="fa fa-user"></i>Profile</a></li>
              <li><a href="#"><i class="fa fa-cog"></i>Setting</a></li>
              <li role="separator" class="divider"></li>
              <li>
                <?php 
                echo $this->Html->link('<i class="fa fa-power-off"></i>Logout</span>', array('controller'=>'Users','action'=>'logout'), array('escape'=>false,'class'=>'customBtn greyBtn user-power'));
                ?>
              </ul>
            </li> 
          </ul>
       
      </div>
    </div>
</nav>
<?php 
 $controller= $this->name;
 $action= $this->request->action; 
?>
<!-- Sidebar -->
  <nav class="navbar navbar-inverse navbar-fixed-top" id="sidebar-wrapper" role="navigation">
    <ul class="nav sidebar-nav">
      <li class='<?php if($controller == "Dashboard" && $action == "index"){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-dashboard"> </i>DashBoard', array('controller'=> 'Dashboard','action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Blogs" && $action == "index") or ($controller == "Blogs" && $action == "blogSetting")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-arrow-circle-up"> </i>Blogs', array('controller'=> 'Blogs', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Startups" && $action == "index") or ($controller == "Startups" && $action == "overview")or ($controller == "Startups" && $action == "team")or ($controller == "Startups" && $action == "workorder")or ($controller == "Startups" && $action == "docs")or ($controller == "Startups" && $action == "roadmapdocs")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-arrow-circle-up"> </i>Manage Startups', array('controller'=> 'Startups', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Roadmaps" && $action == "index") or ($controller == "Roadmaps" && $action == "add")or ($controller == "Roadmaps" && $action == "edit")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-area-chart"> </i>Modify Milestone', array('controller'=> 'Roadmaps', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Questions" && $action == "index") or ($controller == "Questions" && $action == "add") or ($controller == "Questions" && $action == "edit")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-area-chart"> </i>Modify Questions', array('controller'=> 'Questions', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "LeanRoadmaps" && $action == "index") or ($controller == "LeanRoadmaps" && $action == "add")or ($controller == "LeanRoadmaps" && $action == "edit")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-area-chart"> </i>Lean Roadmap', array('controller'=> 'leanRoadmaps', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Forums" && $action == "index") or ($controller == "Forums" && $action == "view")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-comments-o"> </i>Manage Forums', array('controller'=> 'Forums', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Users" && $action == "index") or ($controller == "Users" && $action == "add")or ($controller == "Users" && $action == "edit")or ($controller == "Users" && $action == "view")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-group"> </i>Manage Users', array('controller'=> 'Users', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Campaigns" && $action == "index") or ($controller == "Campaigns" && $action == "view")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-bullhorn"> </i>Manage Campaigns', array('controller'=> 'Campaigns', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Notifications" && $action == "index")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-bell"> </i>Notifications', array('controller'=> 'Notifications', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Settings" && $action == "index")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-gear"> </i>Settings', array('controller'=> 'Settings', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>
      <li class='<?php if(($controller == "Tickets" && $action == "index")or ($controller == "Tickets" && $action == "view")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-ticket"> </i>Forum Abuse', array('controller'=> 'Tickets', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>
      <li class='<?php if(($controller == "Ratings" && $action == "index")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-star"> </i>Ratings', array('controller'=> 'Ratings', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>
      <li class='<?php if(($controller == "Entrepreneur" && $action == "index") or ($controller == "Entrepreneur" && $action == "view")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-user-md"> </i>Entrepreneurs', array('controller'=> 'Entrepreneur', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Contractor" && $action == "index") or ($controller == "Contractor" && $action == "view")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-user"> </i>Contractors', array('controller'=> 'Contractor', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "SubAdmins" && $action == "index") or ($controller == "SubAdmins" && $action == "add") or ($controller == "SubAdmins" && $action == "view") or ($controller == "SubAdmins" && $action == "edit")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-user"> </i>Sub Admin', array('controller'=> 'SubAdmins', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>

      <li class='<?php if(($controller == "Pages" && $action == "index")){ echo 'active';}?>'>
          <?php
            echo $this->Html->link('<i class=" fa fa-sticky-note-o"> </i>Manage Pages', array('controller'=> 'Pages', 'action'=>'index'), array('escape'=>false));
          ?>
      </li>


    </ul>
  </nav>
  <!-- /#sidebar-wrapper -->

<script>
$(document).ready(function () {
  var trigger = $('.hamburger'),
    isClosed = false;
    trigger.click(function () {
   hamburger_cross();      
    });

    function hamburger_cross() {

      if (isClosed == true) {          
         trigger.removeClass('is-open');
        trigger.addClass('is-closed');
        isClosed = false;
      } else {   
       trigger.removeClass('is-closed');
        trigger.addClass('is-open');
        isClosed = true;
      }
  }
  
  $('[data-toggle="offcanvas"]').click(function () {
        $('#wrapper').toggleClass('toggled');
  });  
});
</script>