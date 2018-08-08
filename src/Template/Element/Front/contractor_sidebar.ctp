<nav class="navbar navbar-inverse navbar-fixed-top" id="sidebar-wrapper" role="navigation">
      
       <div id="scrollEvent"> 
        <div class="user_status">

        <?php if(!empty($contractorImage)){?>
         <div class="circle-img-sidebar"><img id="blah1" height="" width="" alt="" src="<?php echo $this->request->webroot.$contractorImage;?>"></div>
         <?php }else{ ?>
         <div class="icon"><i class="fa fa-user"></i> </div>
         <?php }?>

         <div class="userName">
           <span>WELCOME</span>
           <?php $loguser = $this->request->session()->read('Auth.User');?>
           <span id="sidebar_username"><?php if(isset($contNam)){ echo $contNam; }//$user = $loguser['first_name'].' '.$loguser['last_name'];?></span>  

           <p class="refer-friend"><?php echo $this->Html->link('Refer a Friend?', array('controller'=>'Contractors','action'=>'referFriends'), array('escape'=>false,'class'=>'greenBtn customBtnRefer'));?></p>
         </div>
        </div>
        <?php  
        $vieww='';
        $controller= $this->name;
        $action= $this->request->action; 
        if($action=='viewStartupWorkorder'){
          @$vieww = base64_decode($this->request->pass['1']);
        }

        if($action=='myStartup'){
          if(isset($this->request->pass['0'])){
            $vieww = base64_decode($this->request->pass['0']); 
          }
        }
       

        ?>
        <ul class="nav sidebar-nav">

          <li class='<?php if($action == "gettingStarted"){ echo 'active';}?>'>
          <?php
              $startIcon = $this->Html->image('icons/audio.png',array('alt'=>'Crowd Bootstrap','class'=>''));
              echo $this->Html->link('<i>'.$startIcon.'</i> Start', array('controller'=>'Contractors','action'=>'gettingStarted'), array('escape'=>false));
          ?>
          </li>

          <li class='<?php if($action == "dashboard"){ echo 'active';}?>'>
          <?php
              $dashboardIcon = $this->Html->image('icons/home.png',array('alt'=>'Crowd Bootstrap','class'=>''));
              echo $this->Html->link('<i>'.$dashboardIcon.'</i> Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
          ?>
          </li>

          <li class="<?php if($action == "myProfile" or $action == "professionalProfile" or $action == "listStartup" or $action == "settings" or $action == "entrepreneurVideo" or $action == "connections" or $action == "myMessages" or ($controller=='Contractors'&& $action =='sendMessage') or $action == "suggestKeywords"){ echo 'active show';}?> dropdown">
            <?php
                $profileIcon = $this->Html->image('icons/profile.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$profileIcon.'</i> My Profile <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?>
             <ul class="dropdown-menu" role="menu">
                <li class="<?php if($action == "entrepreneurVideo" ){ echo 'active';}?>">
                  <?php
                      $EntrepreneurVideo = $this->Html->image('icons/EntrepreneurVideo.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$EntrepreneurVideo.'</i>Entrepreneur Video', array('controller'=>'Contractors','action'=>'entrepreneurVideo'), array('escape'=>false));
                  ?>
                </li>

                <li class="<?php if($action == "myProfile" or $action == "professionalProfile" or $action == "listStartup"){ echo 'active';}?>">
                  <?php
                      $subprofileIcon = $this->Html->image('icons/USER.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$subprofileIcon.'</i>Profile', array('controller'=>'Contractors','action'=>'myProfile'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action == "connections" or $action == "myMessages" or $action == "sendMessage"){ echo 'active';}?>">
                  <?php
                      $subprofileIcon = $this->Html->image('icons/USER.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$subprofileIcon.'</i>My Connections', array('controller'=>'Contractors','action'=>'connections'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action == 'searchContractors'){ echo 'active';}?>">
                <?php
                    $search_contractorIcon = $this->Html->image('icons/search_contractor.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$search_contractorIcon.'</i> Add Connection', array('controller'=>'Contractors','action'=>'searchContractors'), array('escape'=>false));
                ?>
                </li>

                <li class="<?php if($action == "suggestKeywords"){ echo 'active';}?>">
                  <?php
                      $subprofileIcon = $this->Html->image('icons/USER.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$subprofileIcon.'</i>Suggest Keywords', array('controller'=>'Contractors','action'=>'suggestKeywords'), array('escape'=>false));
                  ?>
                </li>

                <li class="<?php if($action == "settings"){ echo 'active';}?>">
                  <?php
                      $settingIcon = $this->Html->image('icons/setting.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$settingIcon.'</i> Settings', array('controller'=>'Contractors','action'=>'settings'), array('escape'=>false));
                  ?>
                </li>
             </ul> 
          </li>
          
          <li class="<?php if($action == "addStartup" or $action =='recommended' or ($controller=='Campaigns'&& $action =='add') or ($controller=='Campaigns'&& $action =='edit') or $action =='following' or $action == 'commitment' or $action =='myCampaign' or($controller=='Campaigns'&&$action =='view')or ($controller=='CampaignDonations'&& $action =='add')or ($controller=='CampaignDonations'&& $action =='edit')  or ($controller=='Startups'&& $action =='currentStartup') or $action =='completedStartup' or $action =='searchStartup' or $action =='myStartup' or $action =='editStartupOverview' or $action =='editStartupTeam' or $action =='editStartupWorkorder' or $action =='editStartupDocs' or $action =='editStartupRoadmapdocs' or $action == 'addStartupDocs' or $action == 'editStartupUploadedDocs' or $action=='viewStartupOverview' or $action=='viewStartupTeam' or ($action=='viewStartupWorkorder' && $vieww !='workView') or $action=='viewStartupDocs' or $action == 'addStartupDocsContractor' or $action == 'recommendedContractors' or $action == 'searchStartups' or $action == 'viewStartup' or $action == 'uploadStartupProfile' or $action == 'submitApplication' or ($controller=='Startups'&& $action =='sendMessage') or $action == 'sendMail' or $action == 'editSubmitApplication' or $action == "roadmapVideo" or $action == "startupApplication" or $action == "startupProfile" or ($controller=='Funds'&& $action =='index') or ($controller=='Funds'&& $action =='view') or ($controller=='Funds'&& $action =='myFund') or ($controller=='Funds'&& $action =='myArchived') or ($controller=='Funds'&& $action =='myDeactivated') or($controller=='Funds'&& $action =='add') or ($controller=='Funds'&& $action =='edit') or $action == 'searchCampaigns' or $action == 'assignWorkUnits' or $action == 'updateStartupWorkorder'){ echo 'active show';}?> dropdown">
          <?php
              $start_upIcon = $this->Html->image('icons/start_up.png',array('alt'=>'Crowd Bootstrap','class'=>''));
              echo $this->Html->link('<i>'.$start_upIcon.'</i> Startups <span class="caret"></span>', array('controller'=>'Startups','action'=>'addStartup'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
          ?>
            <ul class="dropdown-menu" role="menu">

              <li class="<?php if($action == "roadmapVideo"){ echo 'active';}?>">
              <?php
                  $RoadmapVideo = $this->Html->image('icons/RoadmapVideo.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$RoadmapVideo.'</i> Roadmap Video', array('controller'=>'Startups','action'=>'roadmapVideo'), array('escape'=>false));
              ?>
              </li>


              <li class="<?php if($action == "addStartup"){ echo 'active';}?>">
              <?php
                  $addstartupIcon = $this->Html->image('icons/add-startup.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$addstartupIcon.'</i> Create Startup', array('controller'=>'Startups','action'=>'addStartup'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if( ($action == "myStartup" && $vieww == 'appView') or $action == "startupApplication" or $action =="submitApplication" or $action == "editSubmitApplication"){ echo 'active';}?>">
              <?php
                  $viewApp= base64_encode('appView');
                  $StartupApplication = $this->Html->image('icons/StartupApplication.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$StartupApplication.'</i> Upload Application', array('controller'=>'Startups','action'=>'myStartup',$viewApp), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if( ($action == "myStartup" && $vieww == 'profileView') or $action == "startupProfile" or $action == 'uploadStartupProfile' ){ echo 'active';}?>">
              <?php
                  $profileView= base64_encode('profileView');
                  $StartupProfile = $this->Html->image('icons/StartupProfile.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$StartupProfile.'</i> Upload Profile', array('controller'=>'Startups','action'=>'myStartup',$profileView), array('escape'=>false));
              ?>
              </li>

              
              <li class="<?php if(($controller=='Startups'&& $action =='currentStartup') or $action =='completedStartup' or $action =='searchStartup' or ($controller=='Startups'&& $action =='myStartup' && ($vieww !== 'appView' && $vieww !== 'profileView') ) or $action =='editStartupOverview' or $action =='editStartupTeam' or $action =='editStartupWorkorder' or $action =='editStartupDocs' or $action =='editStartupRoadmapdocs' or $action == 'addStartupDocs' or $action == 'editStartupUploadedDocs' or $action=='viewStartupOverview' or $action=='viewStartupTeam' or ($action=='viewStartupWorkorder' && $vieww !='workView') or $action=='viewStartupDocs' or $action == 'addStartupDocsContractor' or $action == 'recommendedContractors' or $action == 'viewStartup'  or $action == 'sendMessage' or $action == 'sendMail' or $action == 'updateStartupWorkorder'){ echo 'active';}?>">
              <?php
                  $currentIcon = $this->Html->image('icons/current-startup.png',array('alt'=>'Crowd Bootstrap','class'=>''));

                  echo $this->Html->link('<i>'.$currentIcon.'</i> Current Startups', array('controller'=>'Startups','action'=>'myStartup'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if(($controller=='Funds'&& $action =='index') or ($controller=='Funds'&& $action =='view') or ($controller=='Funds'&& $action =='myFund') or ($controller=='Funds'&& $action =='myArchived') or ($controller=='Funds'&& $action =='myDeactivated') or ($controller=='Funds'&& $action =='add') or ($controller=='Funds'&& $action =='edit') ){ echo 'active';}?>">
              <?php
                  $Funds = $this->Html->image('icons/Funds.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$Funds.'</i> Funds', array('controller'=>'Funds','action'=>'index'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if($action == "recommended" or ($controller=='Campaigns'&& $action =='add') or ($controller=='Campaigns'&& $action =='edit') or $action =='following' or $action == 'commitment' or $action =='myCampaign' or ($controller=='Campaigns' && $action =='view')or ($controller=='CampaignDonations' && $action =='add')or ($controller=='CampaignDonations'&& $action =='edit') ){ echo 'active';}?>">
              <?php
                  $campaignIcon = $this->Html->image('icons/campaign.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$campaignIcon.'</i> Campaigns', array('controller'=>'Campaigns','action'=>'index'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if($action == 'searchCampaigns'){ echo 'active';}?>">
              <?php
                  $SearchCampaign = $this->Html->image('icons/SearchCampaign.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$SearchCampaign.'</i> Search Campaigns', array('controller'=>'Startups','action'=>'searchCampaigns'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if($action == 'assignWorkUnits'){ echo 'active';}?>">
              <?php
                  $ManageWorkorder = $this->Html->image('icons/ManageWorkorder.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$ManageWorkorder.'</i> Assign Work Units', array('controller'=>'Startups','action'=>'assignWorkUnits'), array('escape'=>false));
              ?>
              </li>
              
            </ul>
          </li>
          <li class="<?php if($action == "viewProfile" or $action == "viewProfessionalProfile" or $action == "viewListStartup" or $action == 'searchContractors' or $action == 'addContractor' or $action == 'rateContractor'  or ($action=='viewStartupWorkorder' && $vieww =='workView') or $action == "contractorVideo" or ($controller=='CareerAdvancements' && $action =='index') or ($controller=='CareerAdvancements' && $action =='view') or $action =='myCareer' or ($controller=='CareerAdvancements' && $action =='myArchived')  or ($controller=='CareerAdvancements' && $action =='myDeactivated') or ($controller=='CareerAdvancements' && $action =='add') or ($controller=='CareerAdvancements' && $action =='edit') or ($controller=='CareerAdvancements' && $action =='dislikeList') or ($controller=='CareerAdvancements' && $action =='likeList') or ($controller=='SelfImprovements' && $action =='index') or ($controller=='SelfImprovements' && $action =='view') or ($controller=='SelfImprovements' && $action =='myImprovement') or ($controller=='SelfImprovements' && $action =='myArchived')  or ($controller=='SelfImprovements' && $action =='myDeactivated') or ($controller=='SelfImprovements' && $action =='add') or ($controller=='SelfImprovements' && $action =='edit') or ($controller=='SelfImprovements' && $action =='dislikeList') or ($controller=='SelfImprovements' && $action =='likeList') or $action == 'addWorkUnits'){ echo 'active show';}?> dropdown">
            <?php
                $contractorIcon = $this->Html->image('icons/contractor.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$contractorIcon.'</i> Contractors <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?>
            
            <ul class="dropdown-menu" role="menu">
              <li class="<?php if($action == "contractorVideo" ){ echo 'active';}?>">
                  <?php
                      $ContractorVideo = $this->Html->image('icons/ContractorVideo.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$ContractorVideo.'</i>Contractor Video', array('controller'=>'Contractors','action'=>'contractorVideo'), array('escape'=>false));
                  ?>
                </li>
              <li class="<?php if($action == 'searchContractors'){ echo 'active';}?>">
              <?php
                  $search_contractorIcon = $this->Html->image('icons/search_contractor.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$search_contractorIcon.'</i> Search Contractors', array('controller'=>'Contractors','action'=>'searchContractors'), array('escape'=>false));
              ?>
              </li>
              <li class="<?php if($action == "viewProfile" or $action == "viewProfessionalProfile" or $action == "viewListStartup" or $action == 'addContractor' or $action == 'rateContractor'){ echo 'active';}?>">
               <?php
                  $viewprofileIcon = $this->Html->image('icons/view-profile.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$viewprofileIcon.'</i> View Public profile', array('controller'=>'Contractors','action'=>'viewProfile'), array('escape'=>false));
               ?>
              </li>
              <li class="<?php if(($action=='viewStartupWorkorder' && $vieww =='workView')){ echo 'active'; }?>">
              <?php
                  $workordersIcon = $this->Html->image('icons/work-orders.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  $view= base64_encode('workView');
                  echo $this->Html->link('<i>'.$workordersIcon.'</i> Work Orders', array('controller'=>'Startups','action'=>'currentStartup',$view), array('escape'=>false));
               ?>
              </li>

              <li class="<?php if($action == 'addWorkUnits'){ echo 'active';}?>">
              <?php
                  $ManageWorkorder = $this->Html->image('icons/ManageWorkorder.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$ManageWorkorder.'</i> Add Work Units', array('controller'=>'Startups','action'=>'addWorkUnits'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if( ($controller=='SelfImprovements' && $action =='index') or ($controller=='SelfImprovements' && $action =='view') or ($controller=='SelfImprovements' && $action =='myImprovement') or ($controller=='SelfImprovements' && $action =='myArchived')  or ($controller=='SelfImprovements' && $action =='myDeactivated') or ($controller=='SelfImprovements' && $action =='add') or ($controller=='SelfImprovements' && $action =='edit') or ($controller=='SelfImprovements' && $action =='dislikeList') or ($controller=='SelfImprovements' && $action =='likeList') ){ echo 'active';}?>">
              <?php
                  $search_contractorIcon = $this->Html->image('icons/search_contractor.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$search_contractorIcon.'</i> Self Improvement', array('controller'=>'SelfImprovements','action'=>'index'), array('escape'=>false));
              ?>
              </li>
              
              <li class="<?php if( ($controller=='CareerAdvancements' && $action =='index') or ($controller=='CareerAdvancements' && $action =='view') or $action =='myCareer' or ($controller=='CareerAdvancements' && $action =='myArchived')  or ($controller=='CareerAdvancements' && $action =='myDeactivated') or ($controller=='CareerAdvancements' && $action =='add') or ($controller=='CareerAdvancements' && $action =='edit') or ($controller=='CareerAdvancements' && $action =='dislikeList') or ($controller=='CareerAdvancements' && $action =='likeList') ){ echo 'active';}?>">
              <?php
                  $search_contractorIcon = $this->Html->image('icons/search_contractor.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$search_contractorIcon.'</i> Career Help', array('controller'=>'CareerAdvancements','action'=>'index'), array('escape'=>false));
              ?>
              </li>

              

            </ul>
          </li>


          <li class="<?php if(($controller=='Companies' && $action =='index') or ($controller=='Companies' && $action =='view') or $action =='companyVideo' ){ echo 'active show';}?> dropdown">
            <?php
                $contractorIcon = $this->Html->image('icons/contractor.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$contractorIcon.'</i> Organizations <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?>
            
            <ul class="dropdown-menu" role="menu">
              <li class="<?php if($action == "companyVideo" ){ echo 'active';}?>">
                  <?php
                      $ContractorVideo = $this->Html->image('icons/ContractorVideo.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$ContractorVideo.'</i>Organization Video
', array('controller'=>'Companies','action'=>'companyVideo'), array('escape'=>false));
                  ?>
              </li>
              <li class="<?php if(($controller=='Companies' && $action =='index') or ($controller=='Companies' && $action =='view')){ echo 'active';}?>">
              <?php
                  $search_contractorIcon = $this->Html->image('icons/search_contractor.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$search_contractorIcon.'</i> Organization Search', array('controller'=>'Companies','action'=>'index'), array('escape'=>false));
              ?>
              </li>
            </ul>
          </li>


          <li class="<?php if(($controller=='Messages'&& $action =='index') or ($controller=='Messages'&& $action =='archiveMessageList') or $action =='startupForum' or $action =='searchForum' or $action =='myForum' or $action =='viewForumList' or $action =='viewForum' or $action =='addForum' or $action =='editForum' or $action =='archivedForum' or $action =='reportForum' or ($controller=='Notes'&& $action =='index') or ($controller=='Notes'&& $action =='add') or ($controller=='Notes'&& $action =='edit') or ($controller=='Notes'&& $action =='view') or ($controller=='Messages'&& $action =='chat') or $action =='notificationList' or $action =='groups'  or ($controller=='Groups' && $action =='index') or ($controller=='Groups' && $action =='view') or $action =='myGroup' or ($controller=='Groups' && $action =='myArchived')  or ($controller=='Groups' && $action =='myDeactivated') or ($controller=='Groups' && $action =='add') or ($controller=='Groups' && $action =='edit') or ($controller=='Groups' && $action =='dislikeList') or ($controller=='Groups' && $action =='likeList') or ($controller=='NetworkingOptions'&& $action =='index') or ($controller=='NetworkingOptions'&& $action =='businessCardNoteList') or ($controller=='NetworkingOptions'&& $action =='contacts') or ($controller=='NetworkingOptions'&& $action =='businessConnections') or ($controller=='NetworkingOptions'&& $action =='businessCardList')or ($controller=='NetworkingOptions'&& $action =='auth') or ($controller=='NetworkingOptions'&& $action =='addContacts') or ($controller=='NetworkingOptions'&& $action =='addBusinessCard') or ($controller=='NetworkingOptions'&& $action =='editBusinessCard') or ($controller=='NetworkingOptions'&& $action =='businessCardDetail') or ($controller=='NetworkingOptions'&& $action =='newUsers') ){ echo 'active show'; } ?> dropdown">
            <?php
                $messageIcon = $this->Html->image('icons/message.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$messageIcon.'</i> Messaging <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?>
            <ul class="dropdown-menu" role="menu">
              <li class="<?php if($action =='archivedForum'){ echo 'active';}?>">
              <?php
                  $archivedIcon = $this->Html->image('icons/archived.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$archivedIcon.'</i> Archived Forums', array('controller'=>'Forums','action'=>'archivedForum'), array('escape'=>false));
               ?>
              </li>
              <li class="<?php if(($controller=='Messages'&& $action =='archiveMessageList')  ){ echo 'active'; } ?>">
              <?php

                  $messageIcon = $this->Html->image('icons/message.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$messageIcon.'</i> Archived Messages', array('controller'=>'Messages','action'=>'archiveMessageList'), array('escape'=>false));
              ?>
              </li>
              <li class="<?php if(($controller=='Messages'&& $action =='notificationList')  ){ echo 'active'; } ?>">
              <?php
                  $Notifications = $this->Html->image('icons/Notifications.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$Notifications.'</i> Notifications', array('controller'=>'Messages','action'=>'notificationList'), array('escape'=>false));
              ?>
              </li>
              <li class="<?php if(($controller=='Messages'&& $action =='chat')){ echo 'active'; }?>">
              <?php
                  $chatIcon = $this->Html->image('icons/chat.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$chatIcon.'</i> Chat', array('controller'=>'Messages','action'=>'chat'), array('escape'=>false));
              ?>
              </li>
              <li class="<?php if($action =='startupForum' or $action =='searchForum' or $action =='myForum' or $action =='viewForumList' or $action =='viewForum' or $action =='addForum' or $action =='editForum' or $action =='reportForum'){ echo 'active'; } ?>">
              <?php
                  $forumIcon = $this->Html->image('icons/forum.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$forumIcon.'</i> Forums', array('controller'=>'Forums','action'=>'startupForum'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if( ($controller=='Groups' && $action =='index') or ($controller=='Groups' && $action =='view') or $action =='myGroup' or ($controller=='Groups' && $action =='myArchived')  or ($controller=='Groups' && $action =='myDeactivated') or ($controller=='Groups' && $action =='add') or ($controller=='Groups' && $action =='edit') or ($controller=='Groups' && $action =='dislikeList') or ($controller=='Groups' && $action =='likeList')  ){ echo 'active'; } ?>">
              <?php
                  $Groups = $this->Html->image('icons/Groups.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$Groups.'</i> Groups', array('controller'=>'Groups','action'=>'index'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if(($controller=='Messages'&& $action =='index')  ){ echo 'active'; } ?>">
              <?php
                  $messageIcon = $this->Html->image('icons/message.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$messageIcon.'</i> Team Messages', array('controller'=>'Messages','action'=>'index'), array('escape'=>false));
              ?>
              </li>
              <li class="<?php if( ($controller=='Notes'&& $action =='index') or ($controller=='Notes'&& $action =='add') or ($controller=='Notes'&& $action =='edit') or ($controller=='Notes'&& $action =='view')){ echo 'active'; }?>">
              <?php
                  $notesIcon = $this->Html->image('icons/notes.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$notesIcon.'</i> Notes', array('controller'=>'Notes','action'=>'index'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if( ($controller=='NetworkingOptions'&& $action =='index') or ($controller=='NetworkingOptions'&& $action =='businessCardNoteList') or ($controller=='NetworkingOptions'&& $action =='contacts') or ($controller=='NetworkingOptions'&& $action =='businessConnections') or ($controller=='NetworkingOptions'&& $action =='businessCardList')or ($controller=='NetworkingOptions'&& $action =='auth') or ($controller=='NetworkingOptions'&& $action =='addContacts') or ($controller=='NetworkingOptions'&& $action =='addBusinessCard') or ($controller=='NetworkingOptions'&& $action =='editBusinessCard') or ($controller=='NetworkingOptions'&& $action =='businessCardDetail') or ($controller=='NetworkingOptions'&& $action =='newUsers')){ echo 'active';}?>">
                  <?php
                      $settingIcon = $this->Html->image('icons/setting.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$settingIcon.'</i> Networking Options', array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false));
                  ?>
              </li>
              
            </ul>
          </li>
          
          <li class="<?php if($action =='hardware' or $action =='software' or $action =='services' or $action =='audioVideo' or $action =='information' or $action =='productivity' or ($controller=='AudioVideos' && $action =='index') or ($controller=='AudioVideos' && $action =='view') or ($controller=='AudioVideos' && $action =='myAudioVideo') or ($controller=='AudioVideos' && $action =='myArchived')  or ($controller=='AudioVideos' && $action =='myDeactivated')  or ($controller=='AudioVideos' && $action =='add') or ($controller=='AudioVideos' && $action =='edit') or ($controller=='AudioVideos' && $action =='dislikeList') or ($controller=='AudioVideos' && $action =='likeList') or ($controller=='Softwares' && $action =='index') or ($controller=='Softwares' && $action =='view') or $action =='mySoftware' or ($controller=='Softwares' && $action =='myArchived')  or ($controller=='Softwares' && $action =='myDeactivated') or ($controller=='Softwares' && $action =='add') or ($controller=='Softwares' && $action =='edit') or ($controller=='Softwares' && $action =='dislikeList') or ($controller=='Softwares' && $action =='likeList') or ($controller=='Services' && $action =='index') or ($controller=='Services' && $action =='view') or $action =='myService' or ($controller=='Services' && $action =='myArchived')  or ($controller=='Services' && $action =='myDeactivated') or ($controller=='Services' && $action =='add') or ($controller=='Services' && $action =='edit') or ($controller=='Services' && $action =='dislikeList') or ($controller=='Services' && $action =='likeList') or ($controller=='Informations' && $action =='index') or ($controller=='Informations' && $action =='view') or $action =='myInformation' or ($controller=='Informations' && $action =='myArchived')  or ($controller=='Informations' && $action =='myDeactivated') or ($controller=='Informations' && $action =='add') or ($controller=='Informations' && $action =='edit') or ($controller=='Informations' && $action =='dislikeList') or ($controller=='Informations' && $action =='likeList') or ($controller=='Productivities' && $action =='index') or ($controller=='Productivities' && $action =='view') or $action =='myProductivity' or ($controller=='Productivities' && $action =='myArchived')  or ($controller=='Productivities' && $action =='myDeactivated') or ($controller=='Productivities' && $action =='add') or ($controller=='Productivities' && $action =='edit') or ($controller=='Productivities' && $action =='dislikeList') or ($controller=='Productivities' && $action =='likeList') or ($controller=='Hardwares' && $action =='index') or ($controller=='Hardwares' && $action =='view') or $action =='myHardware' or ($controller=='Hardwares' && $action =='myArchived')  or ($controller=='Hardwares' && $action =='myDeactivated') or ($controller=='Hardwares' && $action =='add') or ($controller=='Hardwares' && $action =='edit') or ($controller=='Hardwares' && $action =='dislikeList') or ($controller=='Hardwares' && $action =='likeList') or ($controller=='CommunalAssets' && $action =='index') or ($controller=='CommunalAssets' && $action =='myCommunalAsset') or ($controller=='CommunalAssets' && $action =='myArchived') or ($controller=='CommunalAssets' && $action =='myDeactivated') or ($controller=='CommunalAssets' && $action =='view') or ($controller=='CommunalAssets' && $action =='edit') or ($controller=='CommunalAssets' && $action =='add') or ($controller=='CommunalAssets' && $action =='likeList') or ($controller=='CommunalAssets' && $action =='dislikeList')){ echo 'active show'; } ?> dropdown">
            <?php
                $resourcesIcon = $this->Html->image('icons/resources.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$resourcesIcon.'</i> Resources <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?>
            <ul class="dropdown-menu" role="menu">
              <li class="<?php if( ($controller=='Hardwares' && $action =='index') or ($controller=='Hardwares' && $action =='view') or $action =='myHardware' or ($controller=='Hardwares' && $action =='myArchived')  or ($controller=='Hardwares' && $action =='myDeactivated') or ($controller=='Hardwares' && $action =='add') or ($controller=='Hardwares' && $action =='edit') or ($controller=='Hardwares' && $action =='dislikeList') or ($controller=='Hardwares' && $action =='likeList') ){ echo 'active'; } ?>">
                <?php
                  $hardwareIcom = $this->Html->image('icons/hardware.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$hardwareIcom.'</i> Hardware', array('controller'=>'Hardwares','action'=>'index'), array('escape'=>false));
                ?>
              </li>
              <li class="<?php if( ($controller=='Softwares' && $action =='index') or ($controller=='Softwares' && $action =='view') or $action =='mySoftware' or ($controller=='Softwares' && $action =='myArchived')  or ($controller=='Softwares' && $action =='myDeactivated') or ($controller=='Softwares' && $action =='add') or ($controller=='Softwares' && $action =='edit') or ($controller=='Softwares' && $action =='dislikeList') or ($controller=='Softwares' && $action =='likeList') ){ echo 'active'; } ?> ">
                <?php
                  $softwareIcon = $this->Html->image('icons/software.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$softwareIcon.'</i> Software', array('controller'=>'Softwares','action'=>'index'), array('escape'=>false));
                ?>
              </li>
              <li class="<?php if( ($controller=='Services' && $action =='index') or ($controller=='Services' && $action =='view') or $action =='myService' or ($controller=='Services' && $action =='myArchived')  or ($controller=='Services' && $action =='myDeactivated') or ($controller=='Services' && $action =='add') or ($controller=='Services' && $action =='edit') or ($controller=='Services' && $action =='dislikeList') or ($controller=='Services' && $action =='likeList') ){ echo 'active'; } ?>">
                <?php
                  $servicesIcon = $this->Html->image('icons/services.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$servicesIcon.'</i> Services', array('controller'=>'Services','action'=>'index'), array('escape'=>false));
                ?>
              </li>
              <li class="<?php if( ($controller=='AudioVideos' && $action =='index') or ($controller=='AudioVideos' && $action =='view') or $action =='myAudioVideo' or ($controller=='AudioVideos' && $action =='myArchived')  or ($controller=='AudioVideos' && $action =='myDeactivated') or ($controller=='AudioVideos' && $action =='add') or ($controller=='AudioVideos' && $action =='edit') or ($controller=='AudioVideos' && $action =='dislikeList') or ($controller=='AudioVideos' && $action =='likeList') ){ echo 'active'; } ?> ">
                <?php
                  $audioIcon = $this->Html->image('icons/audio.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$audioIcon.'</i> Audio Video', array('controller'=>'AudioVideos','action'=>'index'), array('escape'=>false));
                ?>
              </li>
              <li class="<?php if( ($controller=='Informations' && $action =='index') or ($controller=='Informations' && $action =='view') or $action =='myInformation' or ($controller=='Informations' && $action =='myArchived')  or ($controller=='Informations' && $action =='myDeactivated') or ($controller=='Informations' && $action =='add') or ($controller=='Informations' && $action =='edit') or ($controller=='Informations' && $action =='dislikeList') or ($controller=='Informations' && $action =='likeList') ){ echo 'active'; } ?>">
                <?php
                  $infoIcon = $this->Html->image('icons/info.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$infoIcon.'</i> Information', array('controller'=>'Informations','action'=>'index'), array('escape'=>false));
                ?>
                </li>
              <li class="<?php if( ($controller=='Productivities' && $action =='index') or ($controller=='Productivities' && $action =='view') or $action =='myProductivity' or ($controller=='Productivities' && $action =='myArchived')  or ($controller=='Productivities' && $action =='myDeactivated') or ($controller=='Productivities' && $action =='add') or ($controller=='Productivities' && $action =='edit') or ($controller=='Productivities' && $action =='dislikeList') or ($controller=='Productivities' && $action =='likeList') ){ echo 'active'; } ?>">
                <?php
                  $productivityIcon = $this->Html->image('icons/productivity.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$productivityIcon.'</i> Productivity', array('controller'=>'Productivities','action'=>'index'), array('escape'=>false));
                ?>
              </li>

              <li class="<?php if(($controller=='CommunalAssets' && $action =='index') or ($controller=='CommunalAssets' && $action =='myCommunalAsset') or ($controller=='CommunalAssets' && $action =='myArchived') or ($controller=='CommunalAssets' && $action =='myDeactivated') or ($controller=='CommunalAssets' && $action =='view') or ($controller=='CommunalAssets' && $action =='edit') or ($controller=='CommunalAssets' && $action =='add') or ($controller=='CommunalAssets' && $action =='likeList') or ($controller=='CommunalAssets' && $action =='dislikeList')){ echo 'active';} ?>" >
                  <?php
                    $betaTest = $this->Html->image('icons/CommunalAsset.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$betaTest.'</i> Communal Assets', array('controller'=>'CommunalAssets','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
              
            </ul>
          </li>
          <li class="<?php if( ($controller=='Conferences' && $action =='index') or ($controller=='Conferences' && $action =='view') or $action =='myConference' or ($controller=='Conferences' && $action =='myArchived')  or ($controller=='Conferences' && $action =='myDeactivated') or ($controller=='Conferences' && $action =='add') or ($controller=='Conferences' && $action =='edit') or ($controller=='Conferences' && $action =='dislikeList') or ($controller=='Conferences' && $action =='likeList') or ($controller=='Demodays' && $action =='index') or ($controller=='Demodays' && $action =='view') or $action =='myDemoday' or ($controller=='Demodays' && $action =='myArchived')  or ($controller=='Demodays' && $action =='myDeactivated') or ($controller=='Demodays' && $action =='add') or ($controller=='Demodays' && $action =='edit') or ($controller=='Demodays' && $action =='dislikeList') or ($controller=='Demodays' && $action =='likeList') or ($controller=='Meetups' && $action =='index') or ($controller=='Meetups' && $action =='view') or $action =='myMeetup' or ($controller=='Meetups' && $action =='myArchived')  or ($controller=='Meetups' && $action =='myDeactivated') or ($controller=='Meetups' && $action =='add') or ($controller=='Meetups' && $action =='edit') or ($controller=='Meetups' && $action =='dislikeList') or ($controller=='Meetups' && $action =='likeList') or ($controller=='Webinars' && $action =='index') or ($controller=='Webinars' && $action =='view') or $action =='myWebinar' or ($controller=='Webinars' && $action =='myArchived')  or ($controller=='Webinars' && $action =='myDeactivated') or ($controller=='Webinars' && $action =='add') or ($controller=='Webinars' && $action =='edit') or ($controller=='Webinars' && $action =='dislikeList') or ($controller=='Webinars' && $action =='likeList')){ echo 'active show'; } ?> dropdown">
            <?php
                $eventsIcon = $this->Html->image('icons/events.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$eventsIcon.'</i> Events <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?> 
            <ul class="dropdown-menu" role="menu">
                
                <li class="<?php if( ($controller=='Conferences' && $action =='index') or ($controller=='Conferences' && $action =='view') or $action =='myConference' or ($controller=='Conferences' && $action =='myArchived')  or ($controller=='Conferences' && $action =='myDeactivated') or ($controller=='Conferences' && $action =='add') or ($controller=='Conferences' && $action =='edit') ){ echo 'active'; } ?> ">
                  <?php
                    $conferenceIcon = $this->Html->image('icons/conference.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$conferenceIcon.'</i> Conferences', array('controller'=>'Conferences','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if( ($controller=='Demodays' && $action =='index') or ($controller=='Demodays' && $action =='view') or $action =='myDemoday' or ($controller=='Demodays' && $action =='myArchived')  or ($controller=='Demodays' && $action =='myDeactivated') or ($controller=='Demodays' && $action =='add') or ($controller=='Demodays' && $action =='edit') or ($controller=='Demodays' && $action =='dislikeList') or ($controller=='Demodays' && $action =='likeList') ){ echo 'active'; } ?> " >
                  <?php
                    $demodaysIcon = $this->Html->image('icons/demodays.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$demodaysIcon.'</i> Demo Days', array('controller'=>'Demodays','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if( ($controller=='Meetups' && $action =='index') or ($controller=='Meetups' && $action =='view') or $action =='myMeetup' or ($controller=='Meetups' && $action =='myArchived')  or ($controller=='Meetups' && $action =='myDeactivated') or ($controller=='Meetups' && $action =='add') or ($controller=='Meetups' && $action =='edit') or ($controller=='Meetups' && $action =='dislikeList') or ($controller=='Meetups' && $action =='likeList') ){ echo 'active'; } ?> ">
                  <?php
                    $handshakeIcon = $this->Html->image('icons/handshake.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$handshakeIcon.'</i> Meet Ups', array('controller'=>'Meetups','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if( ($controller=='Webinars' && $action =='index') or ($controller=='Webinars' && $action =='view') or $action =='myWebinar' or ($controller=='Webinars' && $action =='myArchived')  or ($controller=='Webinars' && $action =='myDeactivated') or ($controller=='Webinars' && $action =='add') or ($controller=='Webinars' && $action =='edit') or ($controller=='Webinars' && $action =='dislikeList') or ($controller=='Webinars' && $action =='likeList') ){ echo 'active'; } ?>">
                  <?php
                    $webinarsIcon = $this->Html->image('icons/webinars.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$webinarsIcon.'</i> Webinars', array('controller'=>'Webinars','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                            
            </ul>
          </li>

          <li class="<?php if($action =='betaTester' or $action =='boardMembers' or $action =='consulting' or $action =='communalAssets' or $action =='earlyAdopters' or $action =='focusGroup' or $action =='endorsers' or $action =='jobs' or $action =='recuiter' or $action =='viewJob' or $action =='viewJobDetails' or $action =='applyForJob' or $action =='viewJobs' or $action =='addJobs' or $action =='editJob' or $action =='archived' or $action =='deactivated' or $action =='addExperiences' or $action =='editExperiences'       or ($controller=='BetaTesters' && $action =='index') or ($controller=='BetaTesters' && $action =='myBetaTest') or ($controller=='BetaTesters' && $action =='myArchived') or ($controller=='BetaTesters' && $action =='myDeactivated') or ($controller=='BetaTesters' && $action =='view') or ($controller=='BetaTesters' && $action =='edit') or ($controller=='BetaTesters' && $action =='add') or ($controller=='BetaTesters' && $action =='likeList') or ($controller=='BetaTesters' && $action =='dislikeList') or ($controller=='BoardMembers' && $action =='index') or ($controller=='BoardMembers' && $action =='myBoardMember') or ($controller=='BoardMembers' && $action =='myArchived') or ($controller=='BoardMembers' && $action =='myDeactivated') or ($controller=='BoardMembers' && $action =='view') or ($controller=='BoardMembers' && $action =='edit') or ($controller=='BoardMembers' && $action =='add') or ($controller=='BoardMembers' && $action =='likeList') or ($controller=='BoardMembers' && $action =='dislikeList') or ($controller=='EarlyAdopters' && $action =='index') or ($controller=='EarlyAdopters' && $action =='myEarlyAdopter') or ($controller=='EarlyAdopters' && $action =='myArchived') or ($controller=='EarlyAdopters' && $action =='myDeactivated') or ($controller=='EarlyAdopters' && $action =='view') or ($controller=='EarlyAdopters' && $action =='edit') or ($controller=='EarlyAdopters' && $action =='add') or ($controller=='EarlyAdopters' && $action =='likeList') or ($controller=='EarlyAdopters' && $action =='dislikeList') or ($controller=='Endorsers' && $action =='index') or ($controller=='Endorsers' && $action =='myEndorser') or ($controller=='Endorsers' && $action =='myArchived') or ($controller=='Endorsers' && $action =='myDeactivated') or ($controller=='Endorsers' && $action =='view') or ($controller=='Endorsers' && $action =='edit') or ($controller=='Endorsers' && $action =='add') or ($controller=='Endorsers' && $action =='likeList') or ($controller=='Endorsers' && $action =='dislikeList') or ($controller=='FocusGroups' && $action =='index') or ($controller=='FocusGroups' && $action =='myFocusGroup') or ($controller=='FocusGroups' && $action =='myArchived') or ($controller=='FocusGroups' && $action =='myDeactivated') or ($controller=='FocusGroups' && $action =='view') or ($controller=='FocusGroups' && $action =='edit') or ($controller=='FocusGroups' && $action =='add') or ($controller=='FocusGroups' && $action =='likeList') or ($controller=='FocusGroups' && $action =='dislikeList')  or ($controller=='Consultings' && $action =='index') or ($controller=='Consultings' && $action =='myConsulting') or ($controller=='Consultings' && $action =='myArchived') or ($controller=='Consultings' && $action =='myDeactivated') or ($controller=='Consultings' && $action =='view') or ($controller=='Consultings' && $action =='edit') or ($controller=='Consultings' && $action =='add') or ($controller=='Consultings' && $action =='likeList') or ($controller=='Consultings' && $action =='dislikeList') or ($controller=='Consultings' && $action =='invitation') or ($controller=='Consultings' && $action =='apply') or ($controller=='Consultings' && $action =='sendInvite') or ($controller=='Consultings' && $action =='close') or ($controller=='BetaTesters' && $action =='searchRecommendedContacts') or ($controller=='BoardMembers' && $action =='searchRecommendedContacts') or ($controller=='EarlyAdopters' && $action =='searchRecommendedContacts') or ($controller=='Endorsers' && $action =='searchRecommendedContacts') or ($controller=='FocusGroups' && $action =='searchRecommendedContacts') ){ echo 'active show ';} ?> dropdown">
            <?php
                $optrtuIcon = $this->Html->image('icons/opportunity.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$optrtuIcon.'</i> Opportunities <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?> 
            <ul class="dropdown-menu" role="menu">
                
                <li class="<?php if(($controller=='BetaTesters' && $action =='index') or ($controller=='BetaTesters' && $action =='myBetaTest') or ($controller=='BetaTesters' && $action =='myArchived') or ($controller=='BetaTesters' && $action =='myDeactivated') or ($controller=='BetaTesters' && $action =='view') or ($controller=='BetaTesters' && $action =='edit') or ($controller=='BetaTesters' && $action =='add') or ($controller=='BetaTesters' && $action =='likeList') or ($controller=='BetaTesters' && $action =='dislikeList') or ($controller=='BetaTesters' && $action =='searchRecommendedContacts')){ echo 'active';} ?>" >
                  <?php
                    $betaTest = $this->Html->image('icons/BetaTester.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$betaTest.'</i> Beta Testers', array('controller'=>'BetaTesters','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if(($controller=='BoardMembers' && $action =='index') or ($controller=='BoardMembers' && $action =='myBoardMember') or ($controller=='BoardMembers' && $action =='myArchived') or ($controller=='BoardMembers' && $action =='myDeactivated') or ($controller=='BoardMembers' && $action =='view') or ($controller=='BoardMembers' && $action =='edit') or ($controller=='BoardMembers' && $action =='add') or ($controller=='BoardMembers' && $action =='likeList') or ($controller=='BoardMembers' && $action =='dislikeList') or ($controller=='BoardMembers' && $action =='searchRecommendedContacts')){ echo 'active';} ?>" >
                  <?php
                    $betaTest = $this->Html->image('icons/BoardMember.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$betaTest.'</i> Board Members', array('controller'=>'BoardMembers','action'=>'index'), array('escape'=>false));
                  ?>
                </li>

                

                <li class="<?php if(($controller=='Consultings' && $action =='index') or ($controller=='Consultings' && $action =='myConsulting') or ($controller=='Consultings' && $action =='myArchived') or ($controller=='Consultings' && $action =='myDeactivated') or ($controller=='Consultings' && $action =='view') or ($controller=='Consultings' && $action =='edit') or ($controller=='Consultings' && $action =='add') or ($controller=='Consultings' && $action =='likeList') or ($controller=='Consultings' && $action =='dislikeList') or ($controller=='Consultings' && $action =='invitation') or ($controller=='Consultings' && $action =='apply') or ($controller=='Consultings' && $action =='sendInvite') or ($controller=='Consultings' && $action =='close')){ echo 'active';} ?>">
                  <?php
                    $consultig = $this->Html->image('icons/consulting.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$consultig.'</i> Consulting', array('controller'=>'Consultings','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if(($controller=='EarlyAdopters' && $action =='index') or ($controller=='EarlyAdopters' && $action =='myEarlyAdopter') or ($controller=='EarlyAdopters' && $action =='myArchived') or ($controller=='EarlyAdopters' && $action =='myDeactivated') or ($controller=='EarlyAdopters' && $action =='view') or ($controller=='EarlyAdopters' && $action =='edit') or ($controller=='EarlyAdopters' && $action =='add') or ($controller=='EarlyAdopters' && $action =='likeList') or ($controller=='EarlyAdopters' && $action =='dislikeList') or ($controller=='EarlyAdopters' && $action =='searchRecommendedContacts')){ echo 'active';} ?>">
                  <?php
                    $earlyAdap = $this->Html->image('icons/early-adopter.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$earlyAdap.'</i> Early Adopters', array('controller'=>'EarlyAdopters','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if(($controller=='Endorsers' && $action =='index') or ($controller=='Endorsers' && $action =='myEndorser') or ($controller=='Endorsers' && $action =='myArchived') or ($controller=='Endorsers' && $action =='myDeactivated') or ($controller=='Endorsers' && $action =='view') or ($controller=='Endorsers' && $action =='edit') or ($controller=='Endorsers' && $action =='add') or ($controller=='Endorsers' && $action =='likeList') or ($controller=='Endorsers' && $action =='dislikeList') or ($controller=='Endorsers' && $action =='searchRecommendedContacts')){ echo 'active';} ?>">
                  <?php
                    $Endorsers = $this->Html->image('icons/beta-tester.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$Endorsers.'</i> Endorsers', array('controller'=>'Endorsers','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if(($controller=='FocusGroups' && $action =='index') or ($controller=='FocusGroups' && $action =='myFocusGroup') or ($controller=='FocusGroups' && $action =='myArchived') or ($controller=='FocusGroups' && $action =='myDeactivated') or ($controller=='FocusGroups' && $action =='view') or ($controller=='FocusGroups' && $action =='edit') or ($controller=='FocusGroups' && $action =='add') or ($controller=='FocusGroups' && $action =='likeList') or ($controller=='FocusGroups' && $action =='dislikeList') or ($controller=='FocusGroups' && $action =='searchRecommendedContacts')){ echo 'active';} ?>">
                  <?php
                    $fcsgrup = $this->Html->image('icons/focus-group.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$fcsgrup.'</i> Focus Groups', array('controller'=>'FocusGroups','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='jobs' or $action =='viewJobDetails' or $action =='applyForJob' or $action =='addExperiences' or $action =='editExperiences'){ echo 'active';} ?>">
                  <?php
                    $jobs = $this->Html->image('icons/white/jobs.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$jobs.'</i> Jobs', array('controller'=>'Opportunities','action'=>'jobs'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='recuiter' or $action =='viewJob' or $action =='addJobs' or $action =='editJob' or $action =='archived' or $action =='deactivated'){ echo 'active';} ?>">
                  <?php
                    $Recruiter = $this->Html->image('icons/white/Recruiter.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$Recruiter.'</i> Recruiter', array('controller'=>'Opportunities','action'=>'recuiter'), array('escape'=>false));
                  ?>
                </li>
                            
            </ul>
          </li>


          <li class="<?php if(($controller=='GroupBuyings' && $action =='index') or ($controller=='GroupBuyings' && $action =='myGroupBuying') or ($controller=='GroupBuyings' && $action =='myArchived') or ($controller=='GroupBuyings' && $action =='myDeactivated') or ($controller=='GroupBuyings' && $action =='view') or ($controller=='GroupBuyings' && $action =='edit') or ($controller=='GroupBuyings' && $action =='add') or ($controller=='GroupBuyings' && $action =='likeList') or ($controller=='GroupBuyings' && $action =='dislikeList') or ($controller=='LaunchDeals' && $action =='index') or ($controller=='LaunchDeals' && $action =='myLaunchDeal') or ($controller=='LaunchDeals' && $action =='myArchived') or ($controller=='LaunchDeals' && $action =='myDeactivated') or ($controller=='LaunchDeals' && $action =='view') or ($controller=='LaunchDeals' && $action =='edit') or ($controller=='LaunchDeals' && $action =='add') or ($controller=='LaunchDeals' && $action =='likeList') or ($controller=='LaunchDeals' && $action =='dislikeList')){ echo 'active show ';} ?> dropdown">
            <?php
                $shoppingIcon = $this->Html->image('icons/shopping-cart.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$shoppingIcon.'</i> Shopping Cart <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?>
              <ul class="dropdown-menu" role="menu">
                
                <li class="<?php if(($controller=='GroupBuyings' && $action =='index') or ($controller=='GroupBuyings' && $action =='myGroupBuying') or ($controller=='GroupBuyings' && $action =='myArchived') or ($controller=='GroupBuyings' && $action =='myDeactivated') or ($controller=='GroupBuyings' && $action =='view') or ($controller=='GroupBuyings' && $action =='edit') or ($controller=='GroupBuyings' && $action =='add') or ($controller=='GroupBuyings' && $action =='likeList') or ($controller=='GroupBuyings' && $action =='dislikeList')){ echo 'active';} ?>" >
                    <?php
                    $conferenceIcon = $this->Html->image('icons/conference.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$conferenceIcon.'</i> Group Buying', array('controller'=>'GroupBuyings','action'=>'index'), array('escape'=>false));
                  ?>
                </li> 

                <li class="<?php if(($controller=='LaunchDeals' && $action =='index') or ($controller=='LaunchDeals' && $action =='myLaunchDeal') or ($controller=='LaunchDeals' && $action =='myArchived') or ($controller=='LaunchDeals' && $action =='myDeactivated') or ($controller=='LaunchDeals' && $action =='view') or ($controller=='LaunchDeals' && $action =='edit') or ($controller=='LaunchDeals' && $action =='add') or ($controller=='LaunchDeals' && $action =='likeList') or ($controller=='LaunchDeals' && $action =='dislikeList')){ echo 'active';} ?>" >
                    <?php
                    $conferenceIcon = $this->Html->image('icons/conference.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$conferenceIcon.'</i> Launch Deals', array('controller'=>'LaunchDeals','action'=>'index'), array('escape'=>false));
                  ?>
                </li> 

                <li class="<?php if($action =='productServiceExchange'){ echo 'active';} ?> grey" >
                    <?php
                    $conferenceIcon = $this->Html->image('icons/conference.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$conferenceIcon.'</i> Product/Service Exchange', array('controller'=>'ShoppingCarts','action'=>'productServiceExchange'), array('escape'=>false));
                  ?>
                </li>

                <li class="<?php if($action =='recommendedSuppliers'){ echo 'active';} ?> grey" >
                    <?php
                    $conferenceIcon = $this->Html->image('icons/conference.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$conferenceIcon.'</i> Recommended Suppliers', array('controller'=>'ShoppingCarts','action'=>'recommendedSuppliers'), array('escape'=>false));
                  ?>
                </li> 

                <li class="<?php if($action =='cbsAppStore'){ echo 'active';} ?> grey" >
                    <?php
                    $conferenceIcon = $this->Html->image('icons/conference.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$conferenceIcon.'</i> CBS App Store', array('controller'=>'ShoppingCarts','action'=>'cbsAppStore'), array('escape'=>false));
                  ?>
                </li> 

                <li class="<?php if($action =='recommendedApps'){ echo 'active';} ?> grey" >
                    <?php
                    $conferenceIcon = $this->Html->image('icons/conference.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$conferenceIcon.'</i> Recommended Apps', array('controller'=>'ShoppingCarts','action'=>'recommendedApps'), array('escape'=>false));
                  ?>
                </li>   


              </ul> 
          </li>

          <li>
          <?php
                $logoutIcon = $this->Html->image('icons/logout.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$logoutIcon.'</i> Logout', array('controller'=>'Users','action'=>'logout'), array('escape'=>false));
          ?>
         </li>
        </ul>
        </div>
       
      </nav>

