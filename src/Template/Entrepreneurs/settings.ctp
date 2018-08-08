 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li class="active">Settings</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Settings</h1> 
              </div>
            </div> 
          </div>
          <!-- header ends --> 
          <?= $this->Form->create($user , ['id'=>'FormField']) ?>

            <?php $notiChk =''; $pbpChk='checked="checked"'; 

            if(!empty($settingData)){
                    if(!empty( $settingData->notification)){ $notiChk='checked="checked"';}

                    if(!empty( $settingData->public_profile)){ 
                      $pbpChk='checked="checked"';
                    }else{
                      $pbpChk='';
                    }
            }

            ?>
                  <div class="row">
                    <div class="col-lg-8 col-md-8 col-sm-12 ">
                      <div class="setting_field" style="display:none !important;">
                      <div class="setting_Name"> Notifications</div>
                      <div class="onoffswitch">
                        <input type="hidden" value="0" name="notification">
                        <input type="checkbox" name="notification" class="onoffswitch-checkbox" value="1" id="myonoffswitch" <?php echo $notiChk; ?>>
                        <label class="onoffswitch-label" for="myonoffswitch">
                            <span class="onoffswitch-inner"></span>
                            <span class="onoffswitch-switch"></span>
                        </label>
                      </div>
                      </div>
                       <div class="setting_field">
                      <div class="setting_Name"> Public Profile</div>
                      <div class="onoffswitch">
                        <input type="hidden" value="0" name="public_profile">
                        <input type="checkbox" name="public_profile" class="onoffswitch-checkbox" value="1" id="myonoffswitch2" <?php echo $pbpChk; ?>>
                        <label class="onoffswitch-label" for="myonoffswitch2">
                            <span class="onoffswitch-inner"></span>
                            <span class="onoffswitch-switch"></span>
                        </label>
                      </div>
                      </div>
                   
                        <div class="form-group  pull-right">
                          <?= $this->Form->button('Save',['class'=> 'customBtn blueBtn']) ?>
                        </div>
                     </div>
                  </div>
          <?= $this->Form->end() ?>
          </div>
 </div>
 <!-- /#page-content-wrapper --> 
