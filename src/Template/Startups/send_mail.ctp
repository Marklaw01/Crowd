<div class="container-fluid">
  <?= $this->Form->create($Messages,['id'=>'FormField']) ?>
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li class="active"><?php
                    echo $this->Html->link('Startups', array('controller'=>'Startups','action'=>'currentStartup'), array('escape'=>false));
                ?></li>
                <li class="active">Send Mail</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Send Mail</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
              <div class="form-group">
                  <span class="form-control">
                    <?php echo $users->first_name.' '.$users->last_name;?> (<?php echo $users->email;?>)
                  </span>
              </div>
              <div class="form-group">
                   <?php
                      echo $this->Form->input('subject', ARRAY('label' => false,'error' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'Subject'));
                   ?>
                   <?php 
                      echo $this->Form->error('subject', null, array('class' => 'error-message'));
                ?>
              </div>
              <div class="form-group">
                  <?php
                      echo $this->Form->input('comment', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'maxlength' => '5000','placeholder'=>'Message', 'type'=>'textarea'));
                   ?>
                   <?php 
                      echo $this->Form->error('comment', null, array('class' => 'error-message'));
                ?>
              </div>
              
              
              
              <div class="form-group">
              <?php
               if($viewType == 'entr'){
                    echo $this->Html->link('BACK', array('controller'=>'Startups','action'=>'editStartupTeam',$startupId), array('escape'=>false,'class'=>'customBtn blueBtn'));
               }else {              
                echo $this->Html->link('BACK', array('controller'=>'Startups','action'=>'viewStartupTeam',$startupId), array('escape'=>false,'class'=>'customBtn blueBtn'));
              }
              ?>

                  <?= $this->Form->button('Send',['class'=> 'customBtn blueBtn  pull-right']) ?>
              </div>
            </div>
          </div>
     <?= $this->Form->end() ?>      
</div>