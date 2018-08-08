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
                <li class="active">Archived Forums</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Archived Forums</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
       
         <div class='row'>
          <div class='col-lg-11 col-md-12 col-sm-12 '>
           <ul class="contentListing archivedForums_listing"> 
                     <?php foreach($forums as $forum){?>

                          <li>
                           <div class="listingIcon"><i class="icon">
                           <img alt="" src="<?php echo $this->request->webroot;?>images/forum.png">
                           </i></div>
                           <div class="listingContent">
                             <div class="headingBar">
                               <h2 class="heading">

                               <?php //echo $forum->title;
                                    echo $this->Html->link($forum->title, array('controller'=>'Forums','action'=>'editForum',base64_encode($forum->id)), array('escape'=>false,'class'=>'','title'=>'Edit'));
                               ?>


                               </h2>
                               <h2 class="date-right date"><?php echo date_format($forum->created,"F d, Y").' '.date('h:m A', strtotime($forum->created));?></h2>
                             </div>
                             <p><?php echo $forum->description;?>
                             </p>
                            <div class="links alignRight">

                                <?php
                                   //echo $this->Html->link('<i class="fa fa-eye"></i>View', array('controller'=>'Forums','action'=>'viewForum',base64_encode($forum->id)), array('escape'=>false,'class'=>'smallCurveBtnMsg greenBtn customBtnMsg'));
                                ?>

                                 <!-- Close Button Code -->
                                <?php if($forum->user_status==1 ){?>       
                                      <?php
                                          echo $this->Form->postLink('Close',['action' => 'closeForum', base64_encode($forum->id)],['id'=>'delPost3'.$forum->id,'class'=>'smallCurveBtnMsg blueBtn customBtnMsg']);
                                      ?>
                                      <script type="text/javascript">
                                                   $(document).ready(function () {
                                                       $('#delPost3<?php echo $forum->id;?>').html('<i class="fa fa-close"></i>Close');
                                                    });   
                                      </script>
                                
                                <?php } else {?>

                          <?php } ?>      
                                 <!-- Delete Button Code -->
                                <?php
                                    echo $this->Form->postLink('Delete',['action' => 'deleteForum', base64_encode($forum->id)],['id'=>'delPost2'.$forum->id,'class'=>'smallCurveBtnMsg redBtn customBtnMsg']);
                                ?>
                                <script type="text/javascript">
                                             $(document).ready(function () {
                                                 $('#delPost2<?php echo $forum->id;?>').html('<i class="fa fa-trash-o"></i>Delete');
                                              });   
                                </script>

                          

                             </div>
                          </div>
                          </li> 

                      <?php } ?> 
                     
           </ul>
                      <?php
                        $cc= count($forums);
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
                                  <li>No Forums Available.</li>
                                </ul>
                              </nav>  
                      <?php }?>
        </div>
        </div>
        </div>
        <!-- /#page-content-wrapper --> 





