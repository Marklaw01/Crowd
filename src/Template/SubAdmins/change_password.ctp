  <div class="login_section forgot_password">
          <?= $this->Form->create($user,['id'=>'FormField','context' => ['validator' => 'resetPass']]) ?>
              <h2>Change Password.</h2>
                  <div class="form-group">
                    <div class="input-group">
                      <div class="input-group-addon"><img src="<?php echo $this->request->webroot;?>images/lock.png" alt""></div>
                      <?php
                          echo $this->Form->input('password1', ARRAY('type' => 'password' ,'label' => false, 'error' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'New Password','autocomplete'=>'off', 'maxlength' => '25'));      
                    ?>
                    </div>
                    <?php 
                      echo $this->Form->error('password1', null, array('class' => 'error-message'));
                    ?>
                   </div>

                   <div class="form-group">
                    <div class="input-group">
                      <div class="input-group-addon"><img src="<?php echo $this->request->webroot;?>images/lock.png" alt""></div>
                      <?php
                          echo $this->Form->input('password2', ARRAY('label' => false,'error' => false, 'div' => false, 'class' => 'form-control', 'id' => 'confirm_password','placeholder'=>'Confirm Password','autocomplete'=>'off','maxlength' => '50','type'=>'password'));
                      ?>
                    </div>
                    <?php 
                      echo $this->Form->error('password1', null, array('class' => 'error-message'));
                    ?>
                   </div>

                  <div class="form-group">
                  <?= $this->Form->button('Update',['class'=> 'customBtn blueBtn width45 pull-left']) ?>
                  <?php //= $this->Html->link(__('Back to Login'), ['action' => 'login'],['class'=>'pull-right']) ?>
                  </div>            
          <?= $this->Form->end() ?>
      </div>
 


