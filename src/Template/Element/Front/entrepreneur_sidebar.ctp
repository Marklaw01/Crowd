<nav class="navbar navbar-inverse navbar-fixed-top" id="sidebar-wrapper" role="navigation">
      
       <div id="scrollEvent"> 
        <div class="user_status">

         <?php if(!empty($entrepreneurImage)){?>
         <div class="circle-img-sidebar"><img id="blah1" height="" width="" alt="" src="<?php echo $this->request->webroot.$entrepreneurImage;?>"><i class="fa fa-user"></i> </div>
         <?php }else{ ?>
         <div class="icon"><i class="fa fa-user"></i> </div>
         <?php }?>

         <div class="userName">
           <span>WELCOME</span>
           <?php $loguser = $this->request->session()->read('Auth.User');?>
           <span id="sidebar_username"><?php echo $user = $loguser['first_name'].' '.$loguser['last_name'];?></span>     
           <p class="refer-friend"><?php echo $this->Html->link('Refer a Friend?', array('controller'=>'Contractors','action'=>'referFriends'), array('escape'=>false,'class'=>'greenBtn customBtnRefer' ));?></p>      
         </div> 
        </div>
         <?php 
         $controller= $this->name;
         $action= $this->request->action;?>
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
              echo $this->Html->link('<i>'.$dashboardIcon.'</i> Home', array('controller'=>'Entrepreneurs','action'=>'dashboard'), array('escape'=>false));
          ?>
          </li>

          <li class="<?php if($action == "myProfile" or $action == "professionalProfile" or $action == "listStartup" or $action == "settings" or $action == "entrepreneurVideo"){ echo 'active show';}?> dropdown">
            <?php
                $profileIcon = $this->Html->image('icons/profile.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$profileIcon.'</i> My Profile <span class="caret"></span>', array('controller'=>'Entrepreneurs','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
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
                      echo $this->Html->link('<i>'.$subprofileIcon.'</i>Profile', array('controller'=>'Entrepreneurs','action'=>'myProfile'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action == "connections" or $action == "myMessages" or $action == "sendMessage"){ echo 'active';}?>">
                  <?php
                      $subprofileIcon = $this->Html->image('icons/USER.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$subprofileIcon.'</i>My Connections', array('controller'=>'Contractors','action'=>'connections'), array('escape'=>false));
                  ?>
                </li>
                <li>
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
                      echo $this->Html->link('<i>'.$settingIcon.'</i> Settings', array('controller'=>'Entrepreneurs','action'=>'settings'), array('escape'=>false));
                  ?>
                </li>
             </ul> 
          </li>
          
          <li class="<?php if($action == "addStartup" or $action =='recommended' or $action =='add' or $action =='following' or $action == 'commitment' or $action =='myCampaign'){ echo 'active show';}?> dropdown">
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
              <li class="<?php if($action == "startupApplication" or $action == "editSubmitApplication"){ echo 'active';}?>">
              <?php
                  $viewApp= base64_encode('appView');
                  $StartupApplication = $this->Html->image('icons/StartupApplication.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$StartupApplication.'</i> Upload Application', array('controller'=>'Startups','action'=>'myStartup',$viewApp), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if($action == "startupProfile" ){ echo 'active';}?>">
              <?php
                  $profileView= base64_encode('profileView');
                  $StartupProfile = $this->Html->image('icons/StartupProfile.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$StartupProfile.'</i> Upload Profile', array('controller'=>'Startups','action'=>'myStartup',$profileView), array('escape'=>false));
              ?>
              </li>

              
              <li>
              <?php
                  $currentIcon = $this->Html->image('icons/current-startup.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$currentIcon.'</i> Current Startups', array('controller'=>'Startups','action'=>'myStartup'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if($action == 'funds'){ echo 'active';}?>">
              <?php
                  $Funds = $this->Html->image('icons/Funds.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$Funds.'</i> Funds', array('controller'=>'Funds','action'=>'index'), array('escape'=>false));
              ?>
              </li>

              <li class="<?php if($action == "recommended" or $action =='add' or $action =='following' or $action == 'commitment' or $action =='myCampaign'){ echo 'active';}?>">
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
          <li class="<?php if($action == "viewProfile" or $action == "viewProfessionalProfile" or $action == "viewListStartup"){ echo 'active show';}?> dropdown">
            <?php
                $contractorIcon = $this->Html->image('icons/contractor.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$contractorIcon.'</i> Contractors <span class="caret"></span>', array('controller'=>'Entrepreneurs','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?>
            
            <ul class="dropdown-menu" role="menu">
              <li class="<?php if($action == "contractorVideo" ){ echo 'active';}?>">
                  <?php
                      $ContractorVideo = $this->Html->image('icons/ContractorVideo.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$ContractorVideo.'</i>Contractor Video', array('controller'=>'Contractors','action'=>'contractorVideo'), array('escape'=>false));
                  ?>
                </li>
              <li>
              <?php
                  $search_contractorIcon = $this->Html->image('icons/search_contractor.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$search_contractorIcon.'</i> Search Contractors', array('controller'=>'Contractors','action'=>'searchContractors'), array('escape'=>false));
              ?>
              </li>
              <li class="<?php if($action == "viewProfile" or $action == "viewProfessionalProfile" or $action == "viewListStartup"){ echo 'active';}?>">
               <?php
                  $viewprofileIcon = $this->Html->image('icons/view-profile.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$viewprofileIcon.'</i> View Public profile', array('controller'=>'Entrepreneurs','action'=>'viewProfile'), array('escape'=>false));
               ?>
              </li>
              <li>
              <?php
                  $workordersIcon = $this->Html->image('icons/work-orders.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  $view= base64_encode('workView');
                  echo $this->Html->link('<i>'.$workordersIcon.'</i> Work Orders', array('controller'=>'Contractors','action'=>'currentStartup',$view), array('escape'=>false));
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
          <li class="dropdown">
            <?php
                $messageIcon = $this->Html->image('icons/message.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$messageIcon.'</i> Messaging <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?>
            <ul class="dropdown-menu" role="menu">
              <li>
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
              <li>
              <?php
                  $chatIcon = $this->Html->image('icons/chat.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$chatIcon.'</i> Chat', array('controller'=>'Messages','action'=>'chat'), array('escape'=>false));
              ?>
              </li>
              <li>
              <?php
                  $forumIcon = $this->Html->image('icons/forum.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$forumIcon.'</i> Forums', array('controller'=>'Forums','action'=>'startupForum'), array('escape'=>false));
              ?>
              </li>
              <li class="<?php if(($controller=='Messages'&& $action =='groups')  ){ echo 'active'; } ?>">
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
              <li>
              <?php
                  $notesIcon = $this->Html->image('icons/notes.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$notesIcon.'</i> Notes', array('controller'=>'Notes','action'=>'index'), array('escape'=>false));
              ?>
              </li>
              <li class="<?php if( ($controller=='NetworkingOptions'&& $action =='index') ){ echo 'active';}?>">
                  <?php
                      $settingIcon = $this->Html->image('icons/setting.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                      echo $this->Html->link('<i>'.$settingIcon.'</i> Networking Options', array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false));
                  ?>
              </li>
              
            </ul>
          </li>
          
          <li class="<?php if($action =='hardware' or $action =='software' or $action =='services' or $action =='audioVideo' or $action =='information' or $action =='productivity'){ echo 'active show'; } ?> dropdown">
            <?php
                $resourcesIcon = $this->Html->image('icons/resources.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$resourcesIcon.'</i> Resources <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?>
            <ul class="dropdown-menu" role="menu">
              <li class="<?php if($action =='hardware'){ echo 'active'; } ?> grey">
                <?php
                  $hardwareIcom = $this->Html->image('icons/hardware.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$hardwareIcom.'</i> Hardware', array('controller'=>'Hardwares','action'=>'index'), array('escape'=>false));
                ?>
              </li>
              <li class="<?php if($action =='software'){ echo 'active'; } ?>">
                <?php
                  $softwareIcon = $this->Html->image('icons/software.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$softwareIcon.'</i> Software', array('controller'=>'Softwares','action'=>'index'), array('escape'=>false));
                ?>
              </li>
              <li class="<?php if($action =='services'){ echo 'active'; } ?>">
                <?php
                  $servicesIcon = $this->Html->image('icons/services.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$servicesIcon.'</i> Services', array('controller'=>'Services','action'=>'index'), array('escape'=>false));
                ?>
              </li>
              <li class="<?php if($action =='audioVideo'){ echo 'active'; } ?>">
                <?php
                  $audioIcon = $this->Html->image('icons/audio.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$audioIcon.'</i> Audio Video', array('controller'=>'AudioVideos','action'=>'index'), array('escape'=>false));
                ?>
              </li>
              <li class="<?php if($action =='information'){ echo 'active'; } ?> grey">
                <?php
                  $infoIcon = $this->Html->image('icons/info.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$infoIcon.'</i> Information', array('controller'=>'Informations','action'=>'index'), array('escape'=>false));
                ?>
                </li>
              <li class="<?php if($action =='productivity'){ echo 'active'; } ?> grey">
                <?php
                  $productivityIcon = $this->Html->image('icons/productivity.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$productivityIcon.'</i> Productivity', array('controller'=>'Productivities','action'=>'index'), array('escape'=>false));
                ?>
              </li>

              <li class="<?php if($action =='communalAssets'){ echo 'active';} ?> " >
                  <?php
                    $betaTest = $this->Html->image('icons/CommunalAsset.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$betaTest.'</i> Communal Assets', array('controller'=>'CommunalAssets','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
              
            </ul>
          </li>
          <li class=" dropdown">
            <?php
                $eventsIcon = $this->Html->image('icons/events.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$eventsIcon.'</i> Events <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?> 
            <ul class="dropdown-menu" role="menu">
                
                <li class="<?php if($action =='conferences'){ echo 'active'; } ?> ">
                  <?php
                    $conferenceIcon = $this->Html->image('icons/conference.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$conferenceIcon.'</i> Conferences', array('controller'=>'Conferences','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='demoDays'){ echo 'active'; } ?> ">
                  <?php
                    $demodaysIcon = $this->Html->image('icons/demodays.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$demodaysIcon.'</i> Demo Days', array('controller'=>'Demodays','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='meetUps'){ echo 'active'; } ?> ">
                  <?php
                    $handshakeIcon = $this->Html->image('icons/handshake.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$handshakeIcon.'</i> Meet Ups', array('controller'=>'Meetups','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='webinars'){ echo 'active'; } ?> ">
                  <?php
                    $webinarsIcon = $this->Html->image('icons/webinars.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$webinarsIcon.'</i> Webinars', array('controller'=>'Webinars','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                            
            </ul>
          </li>


          <li class="<?php if($action =='betaTester' or $action =='boardMembers' or $action =='consulting' or $action =='communalAssets' or $action =='earlyAdopters' or $action =='focusGroup' or $action =='endorsers' or $action =='jobs' or $action =='recuiter'){ echo 'active show ';} ?> dropdown">
            <?php
                $optrtuIcon = $this->Html->image('icons/opportunity.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$optrtuIcon.'</i> Opportunities <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?> 
            <ul class="dropdown-menu" role="menu">
                
                <li class="<?php if($action =='betaTester'){ echo 'active';} ?>" >
                  <?php
                    $betaTest = $this->Html->image('icons/BetaTester.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$betaTest.'</i> Beta Testers', array('controller'=>'BetaTesters','action'=>'betaTester'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='boardMembers'){ echo 'active';} ?>" >
                  <?php
                    $betaTest = $this->Html->image('icons/BoardMember.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$betaTest.'</i> Board Members', array('controller'=>'BoardMembers','action'=>'index'), array('escape'=>false));
                  ?>
                </li>

                

                <li class="<?php if($action =='consulting'){ echo 'active';} ?> grey">
                  <?php
                    $consultig = $this->Html->image('icons/consulting.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$consultig.'</i> Consulting', array('controller'=>'Consultings','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='earlyAdopters'){ echo 'active';} ?> grey">
                  <?php
                    $earlyAdap = $this->Html->image('icons/early-adopter.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$earlyAdap.'</i> Early Adopters', array('controller'=>'EarlyAdopters','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='endorsers'){ echo 'active';} ?> grey">
                  <?php
                    $Endorsers = $this->Html->image('icons/beta-tester.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$Endorsers.'</i> Endorsers', array('controller'=>'Endorsers','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='focusGroup'){ echo 'active';} ?>">
                  <?php
                    $fcsgrup = $this->Html->image('icons/focus-group.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$fcsgrup.'</i> Focus Groups', array('controller'=>'FocusGroups','action'=>'index'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='jobs'){ echo 'active';} ?>">
                  <?php
                    $jobs = $this->Html->image('icons/white/jobs.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$jobs.'</i> Jobs', array('controller'=>'Opportunities','action'=>'jobs'), array('escape'=>false));
                  ?>
                </li>
                <li class="<?php if($action =='recuiter'){ echo 'active';} ?>">
                  <?php
                    $Recruiter = $this->Html->image('icons/white/Recruiter.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$Recruiter.'</i> Recruiter', array('controller'=>'Opportunities','action'=>'recuiter'), array('escape'=>false));
                  ?>
                </li>
                            
            </ul>
          </li>


          <li class="<?php if($action =='groupBuying' or $action =='launchDeals' or $action =='productServiceExchange' or $action =='recommendedSuppliers' or $action =='cbsAppStore' or $action =='recommendedApps'){ echo 'active show ';} ?> dropdown">
            <?php
                $shoppingIcon = $this->Html->image('icons/shopping-cart.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                echo $this->Html->link('<i>'.$shoppingIcon.'</i> Shopping Cart <span class="caret"></span>', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'dropdown-toggle','data-toggle'=>'dropdown'));
            ?>
              <ul class="dropdown-menu" role="menu">
                
                <li class="<?php if($action =='groupBuying'){ echo 'active';} ?>" >
                    <?php
                    $conferenceIcon = $this->Html->image('icons/conference.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                    echo $this->Html->link('<i>'.$conferenceIcon.'</i> Group Buying', array('controller'=>'GroupBuyings','action'=>'index'), array('escape'=>false));
                  ?>
                </li> 

                <li class="<?php if($action =='launchDeals'){ echo 'active';} ?> grey" >
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

