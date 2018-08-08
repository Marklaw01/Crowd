<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li><?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li class="active">Refer a friend</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
     <div class="page_heading">
       <h1>Refer a friend</h1> 
      </div>
    </div>
    
  </div>
  <!-- header ends --> 

  <?= $this->Form->create($Messages,['id'=>'FormField','class'=>'refer']) ?>
    <div class="row">
      <div class="col-lg-8 col-md-8 col-sm-12 ">
        <div class="form-group">
            <span class="form-control">
              From: <?php echo $users->first_name.' '.$users->last_name;?> (<?php echo $users->email;?>)
            </span>
        </div>
        <div class="form-group">
             <?php
                echo $this->Form->input('to', ARRAY('label' => false,'error' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'To:','value'=>''));
             ?>
             <?php 
                echo $this->Form->error('to', null, array('class' => 'error-message'));
          ?>
        </div>
        <div class="form-group">
             <?php
                echo $this->Form->input('subject', ARRAY('label' => false,'error' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'Subject','value'=>'Crowd Bootstrap Invitation'));
             ?>
             <?php 
                echo $this->Form->error('subject', null, array('class' => 'error-message'));
          ?>
        </div>
        <div class="form-group">
            <?php
                $url= 'https://'.$_SERVER['SERVER_NAME'].'/users/register'; 
                $link= $this->Html->link('Link', array('controller'=>'Users','action'=>'register'), array('escape'=>false));
                echo $this->Form->input('comment', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'maxlength' => '5000','placeholder'=>'Message', 'type'=>'textarea','contenteditable'=>'true', 'value'=>'Dear $friend:
<br/><br/>
Crowd Bootstrap helps entrepreneurs accelerate their journey from a startup idea to initial revenues. It is a free App that enables you to benefit as an entrepreneur or help as an expert.
<br/><br/>
Please click the following link to sign-up and help an entrepreneur realize their dream.
<br/><br/>
Link : '.$url.'
<br/><br/>
Regards,
<br/><br/>
The Crowd Bootstrap Team'));
             ?>
             <?php 
                echo $this->Form->error('comment', null, array('class' => 'error-message'));
          ?>
        </div>
        
        
        
        <div class="form-group">
          <?= $this->Form->button('Send',['class'=> 'customBtn blueBtn  pull-right']) ?>
        </div>

      </div>
    </div>
  <?= $this->Form->end() ?>      
</div>