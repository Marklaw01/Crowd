 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Entrepreneurs','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('My Profile', array('controller'=>'Entrepreneurs','action'=>'listStartup'), array('escape'=>false));
                ?></li>
                <li class="active">Startup</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Add Startup</h1> 
              </div>
            </div>
            <div class='col-lg-6 col-md-6 col-sm-6'>
              <div class="profileName">   
              </div>
            </div>
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="about-section">
                                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->                 
                 
                  <div role="tabpanel" class="tab-pane active" id="startup">
                  <?php //pr($user);?>
                  <?= $this->Form->create($user , ['class'=>'add-startup-list']) ?>
                    
                   
                       <div class="row">
                         <div class="col-lg-6 col-md-6 col-sm-6 "></div>
                         <div class="col-lg-6 col-md-6 col-sm-6 ">
                            <div class="profileName">
                              <?php
                                  
                                  echo $this->Html->link('BACK', array('controller'=>'Entrepreneurs','action'=>'listStartup'), array('escape'=>false,'class'=>'active'));
                              ?>
                            </div>  
                         </div>   
                          <div class="col-md-12 col-sm-12 col-xs-12"> 

                               
                            <?php if(!empty($startupdata)){ $i=1;?> 

                                <?php 
                                if(!empty($startup_profileData)) { 
                                  $selectedStartup = explode(',',$startup_profileData['startup_id']);
                                  }else { $selectedStartup=array();} 
                                ?>

                                <div class="checkbox">
                                  <?php foreach($startupdata as $startup){ 
                                    if(in_array($startup['id'], $selectedStartup)){ $checked= 'checked="checked"';}else { $checked='';}
                                  ?>
                                        <div class="form-group">
                                          <input type="checkbox" name="startup_id[]" <?php echo $checked;?> class="checkinput" id="startup_id_<?= $startup['id'] ?>" value="<?= $startup['id'] ?>"> 

                                          <label for="startup_id_<?= $startup['id'] ?>"><?= $startup['name'] ?></label> 
                                        </div>
                                  <?php $i++; } // Foreach close ?> 
                            </div>

                            <div class="form-group">
                               <?= $this->Form->button('Submit',['class'=> 'customBtn blueBtn  pull-right']) ?>
                            </div>
                            <?php }else{?>
                                <div class="panel panel-default">
                                  <div class="panel-heading" role="tab" id="headingTwo">
                                    <h4 class="panel-title">
                                      <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                        No Startup Found
                                      </a>
                                    </h4>
                                  </div>
                                  <div id="collapseTwo" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingTwo">
                                    <div class="panel-body">
                                    </div>
                                  </div>
                                </div>
                            <?php } ?>    
                           
                          </div>
                                                        
                       </div>   
                    <?= $this->Form->end() ?>
                  </div>
                  <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane" id="basic">
                  </div>
                  <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane" id="professional">                  
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
 </div>
 <!-- /#page-content-wrapper --> 
