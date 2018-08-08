<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Messaging', array('controller'=>'Messages','action'=>'index'), array('escape'=>false));
                ?></li>
                <li class="active">Message</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Team Messages</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
       
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
                           <h2 class="date-right">
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
	                      	<li>No Message Found.</li>
	                      </ul>
	                    </nav>  
				   <?php }?>
        </div>
        </div>
        </div>
        <!-- /#page-content-wrapper --> 
 
 
     