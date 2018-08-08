<nav class="navbar navbar-inverse navbar-fixed-top" id="sidebar-wrapper" role="navigation">
      
       <div id="scrollEvent"> 
        <div class="user_status">

        <?php if(isset($SubAdminDetails['profile_image'])
                     &&($SubAdminDetails['profile_image']!='')
                     &&(file_exists('img/subadmin_profile_image/'.$SubAdminDetails['profile_image']))){?>
         <div class="circle-img-sidebar"><img id="blah1" height="" width="" alt="" src="<?php echo $this->request->webroot.'img/subadmin_profile_image/'.$SubAdminDetails['profile_image'];?>"></div>
         <?php }else{ ?>
         <div class="icon"><i class="fa fa-user"></i> </div>
         <?php }?>

         <div class="userName">
           <span>WELCOME</span>
           <span id="sidebar_username"><?php if(isset($SubAdminDetails['company_name'])){echo $SubAdminDetails['company_name'];}?></span>  
         </div>
        </div>
              <?php  
                    $vieww='';
                    $controller= $this->name;
                    $action= $this->request->action; 
              ?>
        <ul class="nav sidebar-nav">
          
          <li class='<?php if($action == "dashboard"){ echo 'active';}?>'>
              <?php
                  $dashboardIcon = $this->Html->image('icons/home.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$dashboardIcon.'</i> Home', array('controller'=>'SubAdmins','action'=>'dashboard'), array('escape'=>false));
              ?>
          </li>
          
          <li class='<?php if($action == "viewProfile" || $action == "editProfile"){ echo 'active';}?>'>
              <?php
                  $dashboardIcon = $this->Html->image('icons/home.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i></i> Profile', array('controller'=>'SubAdmins','action'=>'viewProfile'), array('escape'=>false));
              ?>
          </li>
          
           <li class='<?php if($action == "addAdmin"){ echo 'active';}?>'>
              <?php
                  $dashboardIcon = $this->Html->image('icons/home.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i></i> Add Admins', array('controller'=>'SubAdmins','action'=>'addAdmin'), array('escape'=>false));
              ?>
          </li>
          
          <li class='<?php if($action == "removeAdmin"){ echo 'active';}?>'>
              <?php
                  $dashboardIcon = $this->Html->image('icons/home.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i></i> Remove Admins', array('controller'=>'SubAdmins','action'=>'removeAdmin'), array('escape'=>false));
              ?>
          </li>
          
          <li class='<?php if($action == "jobApplication"){ echo 'active';}?>'>
              <?php
                  $dashboardIcon = $this->Html->image('icons/home.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i></i> Job Application', array('controller'=>'SubAdmins','action'=>'jobApplication'), array('escape'=>false));
              ?>
          </li>
          
          <li class='<?php  if($action == "changePassword"){ echo 'active';}?>'>
              <?php
                  $dashboardIcon = $this->Html->image('icons/home.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i></i> Change Password', array('controller'=>'SubAdmins','action'=>'ChangePassword'), array('escape'=>false));
              ?>
          </li>
          
          <li>
              <?php
                  echo $this->Html->link('<i></i> Log Out', array('controller'=>'users','action'=>'logout'), array('escape'=>false));
              ?>
          </li>
          
       </ul>
       
       </div>
       
      </nav>
 