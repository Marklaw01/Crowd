<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'SubAdmins','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Edit Profile', array('controller'=>'SubAdmins','action'=>'editprofile'), array('escape'=>false));
                ?></li>
                <li class="active">Profile View</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Profile View</h1> 
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
                 <?php //pr($user);?>
                  
                  <!--  1Tab -->
                  <div role="tabpanel" class="tab-pane active" id="professional">
                    <div class="profileView">
                          
                          <div class="circle-img" >
                            <?php if(isset($subAdminDetails['profile_image'])
                                     &&($subAdminDetails['profile_image']!='')) { ?>
                                  <?php echo $this->Html->image('subadmin_profile_image/' .$subAdminDetails['profile_image'],
                                                                array('id'=>'blah','width'=>'','height'=>'')); ?>
                            <?php }else { ?>
                                  <img id="blah" src="<?php echo $this->request->webroot;?>images/dummy-man.png" alt="">
                            <?php } ?>

                          </div>
                   
                          </div>                          
                    </div>
                       
                       <div class="row">
                          <div class="col-md-6 col-sm-6 col-xs-12">
                              
                              <div class="form-group">
                              <label>Company</label>
                                <span class="form-control">
                                    <?php
                                          if(!empty($subAdminDetails['company_name'])){
                                              echo $subAdminDetails['company_name'];
                                          }else {
                                              echo 'Company name';
                                          }
                                    ?>
                                 </span>
                              </div>
                               
                                <div class="form-group">
                              <label>Overview</label>
                                 <span class="form-control textArea">
                                     <?php
                                          if(isset($subAdminDetails['description'])
                                             &&($subAdminDetails['description']!='')){
                                              echo $subAdminDetails['description'];
                                          }else {
                                              echo 'Overview';
                                          }
                                    ?>
                                 </span>
                              </div>
                                
                              <div class="form-group">
                              <label>Company Keywords</label>
                                <span id="selectedResult" class="form-control textArea"> 
                                <ul>
                                    <?php
                                          if(!empty($job_posting_keywords)){
                                              foreach($job_posting_keywords as $job_posting_keyword){
                                                    echo '<li id="sel_'.$job_posting_keyword->id.'"><a href="javascript:void(0)">'.$job_posting_keyword->name.'</a></li>';
                                              }
                                          }else {
                                              echo 'Job Posting Keywords';
                                          }
                                    ?>
                                  </ul>
                                 </span>
                                 
                              </div>
                              
                          </div>
                          
                          <div class="col-md-6 col-sm-6 col-xs-12">
                              
                             
                              
                          </div>
                                 
                       </div>   
                    <?= $this->Form->end() ?>
                  </div>

                  <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane" id="basic">
                  </div>
                  <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane" id="startup">                  
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
</div>
<!-- /#page-content-wrapper --> 
