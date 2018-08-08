 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                 <li><?php
                    echo $this->Html->link('My Profile', array('controller'=>'Contractors','action'=>'myProfile'), array('escape'=>false));
                ?></li>
                <li class="active">Connections</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Connections</h1> 
              </div>
            </div>
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="about-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav aboutTab connectionTab nav-tabs" role="tablist">

                  <li role="presentation" class="">
                  <?php 
                   $basic= $this->Url->build(["controller" => "contractors","action" => "connections"]); ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#connections" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">My Connections</a>
                  <?php 
                  ?>
                  </li>

                  <li role="presentation" class="active">
                  <?php 
                    $profess= $this->Url->build(["controller" => "contractors","action" => "myMessages"]);
                  ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#my-messages" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">My Messages</a>
                    
                  </li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->                 
                 <?php //pr($user);?>
                  
                  <div role="tabpanel" class="tab-pane active" id="connections">
                        <div class='row'>
                          <div class='col-lg-11 col-md-12 col-sm-12 '>
                           <ul class="contentListing notification_listing"> 
                                <?php foreach($MessagesDetails as $MessagesDetail){?>
                                      <li>
                                       <div class="listingIcon"><i class="icon"><span class="fa fa-bell"></span></i></div>
                                       <div class="listingContent">
                                         <div class="headingBar">
                                           <h2 class="heading"><?php echo $MessagesDetail->subject;?></h2>
                                           <h2 class="date-right date"><?php echo date_format($MessagesDetail->created,"F d, Y").' '.date('h:m A', strtotime($MessagesDetail->created));?></h2>
                                         </div>
                                         <p><?php echo $MessagesDetail->comment;?> 
                                         </p> 
                                         <div class="headingBar">
                                           <h3 class="heading">
                                           From : 
                                            <?php 
                                              
                                              if($MessagesDetail->sender_role_id == 1){
                                                if(!empty($MessagesDetail->user->entrepreneur_basic)){
                                                  
                                                  echo $MessagesDetail->user->entrepreneur_basic->first_name.' '.$MessagesDetail->user->entrepreneur_basic->last_name;
                                                
                                                }else {
                                                  
                                                  echo $MessagesDetail->user->first_name.' '.$MessagesDetail->user->last_name;
                                                }

                                              }else {

                                                echo $MessagesDetail->user->first_name.' '.$MessagesDetail->user->last_name;
                                              }
                                            ?>
                                           </h3>
                                           <h2 class="date-right" style="display: none;">
                                                            <?php
                                                               echo $this->Form->postLink('Archive',['action' => 'archiveMessage', base64_encode($MessagesDetail->id)],['id'=>'delPost'.$MessagesDetail->id,'class'=>'smallCurveBtnMsg greenBtn customBtnMsg']);
                                                            ?>
                                                            <script type="text/javascript">
                                                             $(document).ready(function () {
                                                                 $('#delPost<?php echo $MessagesDetail->id;?>').html('<i class="fa fa-download"></i>Archive');
                                                              });   
                                                            </script>

                                                            <?php
                                                               echo $this->Form->postLink('Delete',['action' => 'deleteMessage', base64_encode($MessagesDetail->id)],['id'=>'delPost2'.$MessagesDetail->id,'class'=>'smallCurveBtnMsg redBtn customBtnMsg']);
                                                            ?>
                                                            <script type="text/javascript">
                                                             $(document).ready(function () {
                                                                 $('#delPost2<?php echo $MessagesDetail->id;?>').html('<i class="fa fa-trash-o"></i>Delete');
                                                              });   
                                                            </script>
                                           </h2>
                                         </div>                       
                                      </div>
                                      </li> 
                                    <?php } ?>  
                                       
                                     
                           </ul>
                                <?php
                                $cc= count($MessagesDetails);
                                    if(!empty($cc)){
                                    ?>
                                <nav class="pagingNav">
                                      <ul class="pagination pagination-sm">
                                      <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                                      <li><?= $this->Paginator->numbers() ?></li>
                                      <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                                      </ul>
                              </nav>

                              <?php }else {?>
                              <nav class="pagingNav">
                                        <ul class="pagination pagination-sm">
                                          <li>No Messages Found.</li>
                                        </ul>
                                      </nav>  
                           <?php }?>
                          </div>
                        </div>
                  </div>
                  <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane" id="my-messages">
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
 </div>
 <!-- /#page-content-wrapper --> 
<script type="text/javascript">

</script>