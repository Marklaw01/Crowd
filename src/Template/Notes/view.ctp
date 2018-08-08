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
                <li class="active">View Note</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>View Note</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 

          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
              
              
              <div class="form-group">
                <?php
                $sKey= $note->startup_id;
                  echo $this->Form->input('startup_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'selectpicker form-control show-tick','id' => 'startup_id','type'=>'select','title'=>"Select Startup", 'value'=>$note->startup_id, 'disabled'=>true, 'options'=>$startups));
                ?> 
                <?php 
                      echo $this->Form->error('startup_id', null, array('class' => 'error-message'));
                ?>
              </div>
              <div class="form-group">
              <span class="form-control">
                    <?php
                        echo $note->title;
                    ?>    
              </span>

              </div>
              <div class="form-group">
                  <span class="form-control textArea">
                        <?php
                            echo $note->comment;
                        ?>    
                  </span>
               
              </div>
              </div>
              
             
              <div class="col-lg-8 col-md-8 col-sm-12 ">
                        <?php
                           echo $this->Html->link('Back', array('controller'=>'Notes','action'=>'index'), array('escape'=>false,'class'=>'customBtn blueBtn  pull-left'));
                        ?>
                <div class="form-group  pull-right">

                </div>
             </div>
          </div>

        </div>
        <!-- /#page-content-wrapper --> 

