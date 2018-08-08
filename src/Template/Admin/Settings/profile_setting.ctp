<div id="page-content-wrapper">
    <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12 ">
           <h1 class="page-header"><i class=" fa fa-gear"></i>Settings 
           </h1>
           <?php
			      //echo $this->Html->link('Add Campaigns', array('controller'=> 'Campaigns','action'=>'add'), array('escape'=>false, 'title'=>'Add','class'=>'btn redColor'));
		       ?>
        </div>
      </div>
      <?php 

      $public_profile='';
      $beta_tester='';
      $board_member='';
      $early_adopter='';
      $endorsor='';
      $focus_group='';
      $consulting='';

      $feeds_profile='';
      $feeds_startup='';
      $feeds_fund='';
      $feeds_campaign='';
      $feeds_campaign_commited='';
      $feeds_improvement='';
      $feeds_career='';
      $feeds_organization='';
      $feeds_forum='';
      $feeds_group='';
      $feeds_hardware='';
      $feeds_software='';
      $feeds_service='';
      $feeds_audio='';
      $feeds_information='';
      $feeds_productivity='';
      $feeds_conference='';
      $feeds_demoday='';
      $feeds_meetup='';
      $feeds_webinar='';
      $feeds_betatest='';
      $feeds_boardmember='"';
      $feeds_communal='';
      $feeds_consulting='';
      $feeds_earlyadopter='';
      $feeds_endorser='';
      $feeds_focusgroup='';
      $feeds_job='';
      $feeds_launchdeal='';
      $feeds_purchaseorder='';


      if(!empty($betaSignuplists)){
          foreach ($betaSignuplists as $key => $value) {

            if($value->type == 'public_profile'){

              $public_profile='checked="checked"';

            }else if($value->type == 'beta_tester'){

              $beta_tester='checked="checked"';

            }else if($value->type == 'board_member'){

              $board_member='checked="checked"';

            }else if($value->type == 'early_adopter'){

              $early_adopter='checked="checked"';

            }else if($value->type == 'endorsor'){

              $endorsor='checked="checked"';

            }else if($value->type == 'focus_group'){

              $focus_group='checked="checked"';

            }else if($value->type == 'consulting'){

              $consulting='checked="checked"';

            }else if($value->type == 'feeds_profile'){

              $feeds_profile='checked="checked"';

            }else if($value->type == 'feeds_startup'){

              $feeds_startup='checked="checked"';

            }else if($value->type == 'feeds_fund'){

              $feeds_fund='checked="checked"';

            }else if($value->type == 'feeds_campaign'){

              $feeds_campaign='checked="checked"';


            }else if($value->type == 'feeds_campaign_commited'){

              $feeds_campaign_commited='checked="checked"';

            }else if($value->type == 'feeds_improvement'){

              $feeds_improvement='checked="checked"';

            }else if($value->type == 'feeds_career'){

              $feeds_career='checked="checked"';

            }else if($value->type == 'feeds_organization'){

              $feeds_organization='checked="checked"';

            }else if($value->type == 'feeds_forum'){

              $feeds_forum='checked="checked"';

            }else if($value->type == 'feeds_group'){

              $feeds_group='checked="checked"';

            }else if($value->type == 'feeds_hardware'){

              $feeds_hardware='checked="checked"';

            }else if($value->type == 'feeds_software'){

              $feeds_software='checked="checked"';

            }else if($value->type == 'feeds_service'){

              $feeds_service='checked="checked"';

            }else if($value->type == 'feeds_audio'){

              $feeds_audio='checked="checked"';

            }else if($value->type == 'feeds_information'){

              $feeds_information='checked="checked"';

            }else if($value->type == 'feeds_productivity'){

              $feeds_productivity='checked="checked"';

            }else if($value->type == 'feeds_conference'){

              $feeds_conference='checked="checked"';

            }else if($value->type == 'feeds_demoday'){

              $feeds_demoday='checked="checked"';

            }else if($value->type == 'feeds_meetup'){

              $feeds_meetup='checked="checked"';

            }else if($value->type == 'feeds_webinar'){

              $feeds_webinar='checked="checked"';

            }else if($value->type == 'feeds_betatest'){

              $feeds_betatest='checked="checked"';

            }else if($value->type == 'feeds_boardmember'){

              $feeds_boardmember='checked="checked"';

            }else if($value->type == 'feeds_communal'){

              $feeds_communal='checked="checked"';

            }else if($value->type == 'feeds_consulting'){

              $feeds_consulting='checked="checked"';

            }else if($value->type == 'feeds_earlyadopter'){

              $feeds_earlyadopter='checked="checked"';

            }else if($value->type == 'feeds_endorser'){

              $feeds_endorser='checked="checked"';

            }else if($value->type == 'feeds_focusgroup'){

              $feeds_focusgroup='checked="checked"';

            }else if($value->type == 'feeds_job'){

              $feeds_job='checked="checked"';

            }else if($value->type == 'feeds_launchdeal'){

              $feeds_launchdeal='checked="checked"';

            }else if($value->type == 'feeds_purchaseorder'){

              $feeds_purchaseorder='checked="checked"';

            }else{
               
                     
            }  
          }
      }           
     ?>
      <div class=" admin_settings"> 
        <section id="page-content-wrapper">
          <div class="container-fluid">
              <div class="row">
                <ul id="tabbing" class="nav aboutTab nav-tabs" role="tablist">
                    <li role="presentation" class="">
                      <?php 
                        $basic= $this->Url->build(["controller" => "Settings","action" => "index"]); 
                      ?>
                      <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#Star" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">Star</a>
                    </li>

                    <li role="presentation" class="active">
                      <?php 
                        $profess= $this->Url->build(["controller" => "Settings","action" => "profileSetting"]);
                      ?>
                      <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#Default" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">Default Setting</a>
                      
                    </li>
                  </ul>
              </div>
              <div class="row table-responsive-custom">
                <div class="row">
                  <div class="col-lg-8 col-md-8 col-sm-12 ">
                    
                    <?= $this->Form->create($user , ['id'=>'FormField']) ?>

                      <!-- <div class="setting_field">
                          <div class="setting_Name" id="heading"> Public Profile</div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="public_profile">
                            <input type="checkbox" name="public_profile" class="onoffswitch-checkbox ajaxClass" id="myonoffswitch2" <?php echo $public_profile; ?>>
                            <label class="onoffswitch-label" for="myonoffswitch2">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span> -->
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed12']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Audio/Video Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_audio">
                            <input type="checkbox" name="feeds_audio" class="onoffswitch-checkbox ajaxClass" id="feeds_audio" <?php echo $feeds_audio; ?>>
                            <label class="onoffswitch-label" for="feeds_audio">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed19']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Beta Test Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_betatest">
                            <input type="checkbox" name="feeds_betatest" class="onoffswitch-checkbox ajaxClass" id="feeds_betatest" <?php echo $feeds_betatest; ?>>
                            <label class="onoffswitch-label" for="feeds_betatest">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed20']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Board Member Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_boardmember">
                            <input type="checkbox" name="feeds_boardmember" class="onoffswitch-checkbox ajaxClass" id="feeds_boardmember" <?php echo $feeds_boardmember; ?>>
                            <label class="onoffswitch-label" for="feeds_boardmember">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed3']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Campaign Followed Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_campaign">
                            <input type="checkbox" name="feeds_campaign" class="onoffswitch-checkbox ajaxClass" id="feeds_campaign" <?php echo $feeds_campaign; ?>>
                            <label class="onoffswitch-label" for="feeds_campaign">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed31']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Campaign Commited Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_campaign_commited">
                            <input type="checkbox" name="feeds_campaign_commited" class="onoffswitch-checkbox ajaxClass" id="feeds_campaign_commited" <?php echo $feeds_campaign_commited; ?>>
                            <label class="onoffswitch-label" for="feeds_campaign_commited">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed5']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Career Help Tool Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_career">
                            <input type="checkbox" name="feeds_career" class="onoffswitch-checkbox ajaxClass" id="feeds_career" <?php echo $feeds_career; ?>>
                            <label class="onoffswitch-label" for="feeds_career">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed21']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Comunal Asset Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_communal">
                            <input type="checkbox" name="feeds_communal" class="onoffswitch-checkbox ajaxClass" id="feeds_communal" <?php echo $feeds_communal; ?>>
                            <label class="onoffswitch-label" for="feeds_communal">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed15']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Conference Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_conference">
                            <input type="checkbox" name="feeds_conference" class="onoffswitch-checkbox ajaxClass" id="feeds_conference" <?php echo $feeds_conference; ?>>
                            <label class="onoffswitch-label" for="feeds_conference">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> My Connections Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_profile">
                            <input type="checkbox" name="feeds_profile" class="onoffswitch-checkbox ajaxClass" id="feeds_profile" <?php echo $feeds_profile; ?>>
                            <label class="onoffswitch-label" for="feeds_profile">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed22']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Consulting Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_consulting">
                            <input type="checkbox" name="feeds_consulting" class="onoffswitch-checkbox ajaxClass" id="feeds_consulting" <?php echo $feeds_consulting; ?>>
                            <label class="onoffswitch-label" for="feeds_consulting">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed16']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Demo Day Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_demoday">
                            <input type="checkbox" name="feeds_demoday" class="onoffswitch-checkbox ajaxClass" id="feeds_demoday" <?php echo $feeds_demoday; ?>>
                            <label class="onoffswitch-label" for="feeds_demoday">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>


                    <?= $this->Form->create($user , ['id'=>'FormFeed23']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Early Adopter Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_earlyadopter">
                            <input type="checkbox" name="feeds_earlyadopter" class="onoffswitch-checkbox ajaxClass" id="feeds_earlyadopter" <?php echo $feeds_earlyadopter; ?>>
                            <label class="onoffswitch-label" for="feeds_earlyadopter">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>


                    <?= $this->Form->create($user , ['id'=>'FormFeed24']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Endorser Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_endorser">
                            <input type="checkbox" name="feeds_endorser" class="onoffswitch-checkbox ajaxClass" id="feeds_endorser" <?php echo $feeds_endorser; ?>>
                            <label class="onoffswitch-label" for="feeds_endorser">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed25']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Focus Group Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_focusgroup">
                            <input type="checkbox" name="feeds_focusgroup" class="onoffswitch-checkbox ajaxClass" id="feeds_focusgroup" <?php echo $feeds_focusgroup; ?>>
                            <label class="onoffswitch-label" for="feeds_focusgroup">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed7']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Forum Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_forum">
                            <input type="checkbox" name="feeds_forum" class="onoffswitch-checkbox ajaxClass" id="feeds_forum" <?php echo $feeds_forum; ?>>
                            <label class="onoffswitch-label" for="feeds_forum">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed2']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Fund Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_fund">
                            <input type="checkbox" name="feeds_fund" class="onoffswitch-checkbox ajaxClass" id="feeds_fund" <?php echo $feeds_fund; ?>>
                            <label class="onoffswitch-label" for="feeds_fund">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed8']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Group Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_group">
                            <input type="checkbox" name="feeds_group" class="onoffswitch-checkbox ajaxClass" id="feeds_group" <?php echo $feeds_group; ?>>
                            <label class="onoffswitch-label" for="feeds_group">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed28']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Group Buying Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_purchaseorder">
                            <input type="checkbox" name="feeds_purchaseorder" class="onoffswitch-checkbox ajaxClass" id="feeds_purchaseorder" <?php echo $feeds_purchaseorder; ?>>
                            <label class="onoffswitch-label" for="feeds_purchaseorder">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed9']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Hardware Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_hardware">
                            <input type="checkbox" name="feeds_hardware" class="onoffswitch-checkbox ajaxClass" id="feeds_hardware" <?php echo $feeds_hardware; ?>>
                            <label class="onoffswitch-label" for="feeds_hardware">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed13']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Information Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_information">
                            <input type="checkbox" name="feeds_information" class="onoffswitch-checkbox ajaxClass" id="feeds_information" <?php echo $feeds_information; ?>>
                            <label class="onoffswitch-label" for="feeds_information">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed26']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Job Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_job">
                            <input type="checkbox" name="feeds_job" class="onoffswitch-checkbox ajaxClass" id="feeds_job" <?php echo $feeds_job; ?>>
                            <label class="onoffswitch-label" for="feeds_job">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed27']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Launch Deal Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_launchdeal">
                            <input type="checkbox" name="feeds_launchdeal" class="onoffswitch-checkbox ajaxClass" id="feeds_launchdeal" <?php echo $feeds_launchdeal; ?>>
                            <label class="onoffswitch-label" for="feeds_launchdeal">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>


                    <?= $this->Form->create($user , ['id'=>'FormFeed17']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Meetup Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_meetup">
                            <input type="checkbox" name="feeds_meetup" class="onoffswitch-checkbox ajaxClass" id="feeds_meetup" <?php echo $feeds_meetup; ?>>
                            <label class="onoffswitch-label" for="feeds_meetup">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>


                    <?= $this->Form->create($user , ['id'=>'FormFeed6']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Organization Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_organization">
                            <input type="checkbox" name="feeds_organization" class="onoffswitch-checkbox ajaxClass" id="feeds_organization" <?php echo $feeds_organization; ?>>
                            <label class="onoffswitch-label" for="feeds_organization">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>


                    <?= $this->Form->create($user , ['id'=>'FormFeed14']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Productivity Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_productivity">
                            <input type="checkbox" name="feeds_productivity" class="onoffswitch-checkbox ajaxClass" id="feeds_productivity" <?php echo $feeds_productivity; ?>>
                            <label class="onoffswitch-label" for="feeds_productivity">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormField1']) ?>
                      <div class="setting_field">
                        <div class="setting_Name" id="heading"> Register for Beta Tester opportunities</div>
                        <div class="onoffswitch" >
                          <input type="hidden" name="type" id="type" value="beta_tester">
                          <input type="checkbox" name="beta_profile" class="onoffswitch-checkbox ajaxClass" id="beta_profile" <?php echo $beta_tester; ?>>
                          <label class="onoffswitch-label" for="beta_profile" id="buttonClick">
                              <span class="onoffswitch-inner" ></span>
                              <span class="onoffswitch-switch"></span>
                          </label>
                        </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormField2']) ?>
                      <div class="setting_field">
                        <div class="setting_Name" id="heading"> Register for Board Member opportunities</div>
                        <div class="onoffswitch" >
                          <input type="hidden" name="type" id="type" value="board_member">
                          <input type="checkbox" name="board_profile" class="onoffswitch-checkbox ajaxClass" id="board_profile" <?php echo $board_member; ?>>
                          <label class="onoffswitch-label" for="board_profile" id="buttonClick">
                              <span class="onoffswitch-inner" ></span>
                              <span class="onoffswitch-switch"></span>
                          </label>
                        </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>


                    <?= $this->Form->create($user , ['id'=>'FormField3']) ?>
                      <div class="setting_field">
                        <div class="setting_Name" id="heading"> Register for Early Adopter opportunities</div>
                        <div class="onoffswitch" >
                          <input type="hidden" name="type" id="type" value="early_adopter">
                          <input type="checkbox" name="early_profile" class="onoffswitch-checkbox ajaxClass" id="early_profile" <?php echo $early_adopter; ?>>
                          <label class="onoffswitch-label" for="early_profile" id="buttonClick">
                              <span class="onoffswitch-inner" ></span>
                              <span class="onoffswitch-switch"></span>
                          </label>
                        </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormField4']) ?>
                      <div class="setting_field">
                        <div class="setting_Name" id="heading"> Register for Endorser opportunities</div>
                        <div class="onoffswitch" >
                          <input type="hidden" name="type" id="type" value="endorsor">
                          <input type="checkbox" name="endorsor_profile" class="onoffswitch-checkbox ajaxClass" id="endorsor_profile" <?php echo $endorsor; ?>>
                          <label class="onoffswitch-label" for="endorsor_profile" id="buttonClick">
                              <span class="onoffswitch-inner" ></span>
                              <span class="onoffswitch-switch"></span>
                          </label>
                        </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormField5']) ?>
                      <div class="setting_field">
                        <div class="setting_Name" id="heading"> Register for Focus Group opportunities</div>
                        <div class="onoffswitch" >
                          <input type="hidden" name="type" id="type" value="focus_group">
                          <input type="checkbox" name="focus_profile" class="onoffswitch-checkbox ajaxClass" id="focus_profile" <?php echo $focus_group; ?>>
                          <label class="onoffswitch-label" for="focus_profile" id="buttonClick">
                              <span class="onoffswitch-inner" ></span>
                              <span class="onoffswitch-switch"></span>
                          </label>
                        </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormField6']) ?>
                      <div class="setting_field">
                        <div class="setting_Name" id="heading"> Register for Consulting opportunities</div>
                        <div class="onoffswitch" >
                          <input type="hidden" name="type" id="type" value="consulting">
                          <input type="checkbox" name="consulting_profile" class="onoffswitch-checkbox ajaxClass" id="consulting_profile" <?php echo $consulting; ?>>
                          <label class="onoffswitch-label" for="consulting_profile" id="buttonClick">
                              <span class="onoffswitch-inner" ></span>
                              <span class="onoffswitch-switch"></span>
                          </label>
                        </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>


                    <?= $this->Form->create($user , ['id'=>'FormFeed4']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Self Improvement Tool Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_improvement">
                            <input type="checkbox" name="feeds_improvement" class="onoffswitch-checkbox ajaxClass" id="feeds_improvement" <?php echo $feeds_improvement; ?>>
                            <label class="onoffswitch-label" for="feeds_improvement">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>


                    <?= $this->Form->create($user , ['id'=>'FormFeed11']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Service Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_service">
                            <input type="checkbox" name="feeds_service" class="onoffswitch-checkbox ajaxClass" id="feeds_service" <?php echo $feeds_service; ?>>
                            <label class="onoffswitch-label" for="feeds_service">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>


                    <?= $this->Form->create($user , ['id'=>'FormFeed10']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Software Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_software">
                            <input type="checkbox" name="feeds_software" class="onoffswitch-checkbox ajaxClass" id="feeds_software" <?php echo $feeds_software; ?>>
                            <label class="onoffswitch-label" for="feeds_software">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed1']) ?>

                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Startup Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_startup">
                            <input type="checkbox" name="feeds_startup" class="onoffswitch-checkbox ajaxClass" id="feeds_startup" <?php echo $feeds_startup; ?>>
                            <label class="onoffswitch-label" for="feeds_startup">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                    <?= $this->Form->create($user , ['id'=>'FormFeed18']) ?>
                      <div class="setting_field">
                          <div class="setting_Name" id="heading"> Webinar Updates </div>
                          <div class="onoffswitch">
                            <input type="hidden" name="type" id="type" value="feeds_webinar">
                            <input type="checkbox" name="feeds_webinar" class="onoffswitch-checkbox ajaxClass" id="feeds_webinar" <?php echo $feeds_webinar; ?>>
                            <label class="onoffswitch-label" for="feeds_webinar">
                                <span class="onoffswitch-inner"></span>
                                <span class="onoffswitch-switch"></span>
                            </label>
                          </div>
                      </div>
                      <span style="color: red; float: right; margin-bottom: 10px;" id="result"></span>
                    <?= $this->Form->end() ?>

                  </div>
                </div>


              </div>   
          </div>
          <!-- /#page-content-wrapper --> 
        </section>
      </div>

  </div>
  <!-- /#page-content-wrapper --> 
</div>

<!-- /#page-content-wrapper --> 
<script type="text/javascript">
  $(".ajaxClass").change(function(){
    var formId = $(this).closest("form").attr('id');

    if($(this).prop("checked") == true){
       //alert('yes');
       
       var  heading = $('#'+formId+' #heading').html();
       var  usertype = $('#'+formId+' #type').val();
       var  registerStatus = 1;
    }else{
       //alert('no');
       var  heading = $('#'+formId+' #heading').html();
       var  usertype = $('#'+formId+' #type').val();
       var  registerStatus = 0; 
    }

    $.ajax({ 
            url: "<?php echo $this->Url->build(["Controller" => "Settings","action" => "ajaxSettings"]);?>",
            data: {type :usertype,status:registerStatus,title:heading},
            type : 'POST',
            cache: false,
            async : false,
    success: function(data) {
            $('#'+formId+' #result').html(data);
        }
    });

});
</script>