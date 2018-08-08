<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('My Forum', array('controller'=>'Forums','action'=>'myForum'), array('escape'=>false));
                ?></li>
                <li class="active">Notes</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Add Notes</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <?= $this->Form->create($note,['id'=>'FormField', 'enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
              
              
              <div class="form-group">
              <select class="selectpicker form-control show-tick" name="startup_id" title="Select Startup">
                <?php
                  //echo $this->Form->input('startup_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'selectpicker form-control show-tick','id' => 'startup_id','type'=>'select','title'=>"Select Startup", 'options'=>$startups));

                  if(!empty($startups)){
                            /*foreach($startups as $SingleUser):
                                if(isset($SingleUser['SID'])&&($SingleUser['SID']!='')){
                                     echo '<option value="'.$SingleUser['SID'].'" >'.$SingleUser['SNAME'].'</option>';
                                }
                            endforeach;*/
                            foreach($startups as $SingleUser):
   
                                     echo '<option value="'.$SingleUser->id.'" >'.$SingleUser->name.'</option>';
                            endforeach;
                  }          
                ?> 
                </select>
                <?php 
                      echo $this->Form->error('startup_id', null, array('class' => 'error-message'));
                ?>
              </div>
              <div class="form-group">
                <?php
                  echo $this->Form->input('title', ARRAY('label' => false, 'div' => false, 'error' => false, 'id' => '','placeholder'=>'Title','class' => 'form-control'));
                ?>
                <?php 
                      echo $this->Form->error('title', null, array('class' => 'error-message'));
                ?>
              </div>
              <div class="form-group">
                <?php
                    echo $this->Form->input('comment', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Comment','class' => 'form-control','maxlength'=>'5000'));
                 ?>
                 <?php 
                      echo $this->Form->error('comment', null, array('class' => 'error-message'));
                ?>
              </div>
              </div>
              
             
              <div class="col-lg-8 col-md-8 col-sm-12 ">
                        <?php
                           echo $this->Html->link('Back', array('controller'=>'Notes','action'=>'index'), array('escape'=>false,'class'=>'customBtn blueBtn  pull-left'));
                        ?>
                <div class="form-group  pull-right">
                   <?= $this->Form->button('Submit',['class'=> 'customBtn blueBtn']) ?>
                </div>
             </div>
          </div>
          <?= $this->Form->end() ?>  
        </div>
        <!-- /#page-content-wrapper --> 


