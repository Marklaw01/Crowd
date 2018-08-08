<div id="page-content-wrapper">
<div class="container-fluid">

          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
              <h1 class="page-header"><i class=" fa fa-comments-o"></i>View Report</h1> 
            </div>
            
          </div>
          
          <!-- breadcrumb ends --> 
          <div class="row">

          </div>
          <!-- header ends --> 
       
         <div class="row forum_top ">
         <div class="col-lg-5 col-md-4 col-sm-12 ">
         <div class="forum_image">
          <?php if(!empty($forumDetails->image)){?>
                <img src="<?php echo $this->request->webroot; ?>img/forums/<?php echo $forumDetails->image;?>" alt="">
          <?php }else {?>
                <img src="<?php echo $this->request->webroot; ?>images/forum-dummy.png" alt="">
          <?php } ?>
         </div>
        </div>
        <div class="col-lg-7 col-md-8 col-sm-12 ">
         <div class="forum_description">
           <h2><?php echo $forumDetails->title;?></h2>
           <div class="form-group">
           <span class="forum-owner">Created By: <?php echo $userName = $this->Custom->contractorName($forumDetails->user_id); ?></span>
          </div>
           <div class="form-group">
              <label>Keywords :</label>        
                  <?php
                    $skey= explode(',', $forumDetails->keywords);
                      $cskey=count($skey);
                        if(!empty($skey[0])){
                          for($i=0; $i<$cskey; $i++){
                              $slids=$skey[$i];
                                 //echo $Keywords[$slids].', '; id="selectedResult"
                                 echo $Keywords[$slids];
                                 if($i<$cskey-1){
                                 echo ', ';
                                }
                           }
                        }else {
                                 echo 'Keywords';
                        }
                  ?>
                <?php //h($campaign->keywords) ?>    
              </div>
           <p>
           <?php //echo $forumDetails->description;?>
           </p>
         </div>
        </div>
        </div>

        <div class="row">
          <div class="col-lg-12 col-md-12 col-sm-12 ">
            <div class="form-group pull-right">
              <?php 
              if($OneForumReports->status ==1){
                   echo '<span class="customBtn greyBtn">Resolved</span>';
              }else{
                echo $this->Form->postLink(__('Resolve'), ['action' => 'resolve', base64_encode($forumDetails->id)], ['class'=>'customBtn greenBtn']) ;
              }
              ?>
              <?php 
              if($forumDetails->user_status ==2){
                echo '<span class="customBtn greyBtn">Forum Closed</span>';
              }else{  
                echo $this->Form->postLink(__('Close Forum'), ['action' => 'close', base64_encode($forumDetails->id)], ['confirm' => __('Are you sure you want to close this forum? '),'class'=>'customBtn blueBtn']) ;
              }  
              ?>
              <?php 
                echo $this->Form->postLink(__('Delete Forum'), ['action' => 'delete', base64_encode($forumDetails->id)], ['confirm' => __('Are you sure you want to delete this forum? '),'class'=>'customBtn redBtn']) ;
              ?>
            </div>
          </div>
        </div>

        <div class="row">

          <div class="col-lg-6 col-md-6 col-sm-12 ">
            <div class="comment_block report_user">
              <div class="subHeading"> Reported Users: </div>
                <ul class="contentListing comment_listing">
                  <?php 
                    if(!empty($ForumReportDetails)){
                      foreach ($ForumReportDetails as $key => $value) { 
                        if($value->reported_users){
                  ?>    
                        <li>  
                          <div class="form-group">    
                            <label for="part" ><strong><?php echo $value->user->first_name.' '.$value->user->last_name; ?> has reported:</strong> </label> 
                            <div class="clearfix"></div>
                            <?php 
                              $reUser= $value->reported_users;
                              $reUserArray= explode(',', $reUser);
                              $count= count($reUserArray);

                              for ($i=0; $i < $count; $i++) { 
                            ?>
                                
                                <label for="part" >
                                  <?php  echo $userName = $this->Custom->contractorName($reUserArray[$i]); ?>
                                </label> 
                                <!-- Check if user is blocked or not  -->
                                <?php  $isBlocked = $this->Custom->isUserBlockedForForum($forumDetails->id,$reUserArray[$i]); ?>
                                <?php if($isBlocked==0){?> 
                                  <div class="form-group pull-right">
                                      <?php 
                                        echo $this->Form->postLink(__('Block'), ['action' => 'blockuser', base64_encode($forumDetails->id),base64_encode($reUserArray[$i])], ['confirm' => __('Are you sure you want to block/remove this user? '),'id'=>'delPost'.$value->id.$i]) 
                                      ?>
                                      <script type="text/javascript">
                                        $(document).ready(function () {
                                           $('#delPost<?php echo $value->id.$i;?>').html('<i class="red fa">Block</i>');
                                        });   
                                      </script>
                                  </div>
                                <?php }else {?>  
                                  <div class="form-group pull-right">
                                    <?php 
                                        echo $this->Form->postLink(__('Unblock'), ['action' => 'unblockuser', base64_encode($forumDetails->id),base64_encode($reUserArray[$i])], ['confirm' => __('Are you sure you want to unblock this user? '),'id'=>'delPost'.$value->id.$i]) 
                                      ?>
                                      <script type="text/javascript">
                                        $(document).ready(function () {
                                           $('#delPost<?php echo $value->id.$i;?>').html('<i class="green fa">Unblock</i>');
                                        });   
                                      </script>
                                  </div>
                                <?php }?>
                                <div class="clearfix"></div>
                            <?php 
                              }
                            ?>
                                <p>
                                 <strong>Comment:</strong> <?php echo $value->comment;?>
                                </p>
                          </div>
                        </li>  
                  <?php 
                        } // end IF
                      } //End foreach
                    } // end outer If
                  ?>
                </ul>  
            </div>  
          </div>

          <div class="col-lg-6 col-md-6 col-sm-12">
            <div class="comment_block report_user">
              <div class="subHeading"> Forum Reported By: </div>
              <div class="form-group">
                <ul class="contentListing comment_listing">
                  <?php 
                    if(!empty($ForumReportDetails)){
                      foreach ($ForumReportDetails as $key1 => $value1) { 
                        if($value1->is_form_reported == 1){
                  ?>    
                        <li>  
                          <div class="form-group">    
                            <label for="part" ><strong><?php echo $value1->user->first_name.' '.$value1->user->last_name; ?></strong></label> 

                            <!-- Check if user is blocked or not  -->
                            <?php  $isBlocked1 = $this->Custom->isUserBlockedForForum($forumDetails->id,$value1->user->id); ?>
                            <?php if($isBlocked1==0){?> 
                            <div class="form-group pull-right">
                                <?php 
                                  echo $this->Form->postLink(__('Block'), ['action' => 'blockuser', base64_encode($forumDetails->id),base64_encode($value1->user->id)], ['confirm' => __('Are you sure you want to block/remove this user? '),'id'=>'delPost'.$value1->user->id]) 
                                ?>
                                <script type="text/javascript">
                                  $(document).ready(function () {
                                     $('#delPost<?php echo $value1->user->id;?>').html('<i class="red fa">Block</i>');
                                  });   
                                </script>
                            </div>
                            <?php }else {?>  

                              <div class="form-group pull-right">
                                <span style="color: green;">Blocked</span>
                              </div>

                            <?php }?>

                            <p>
                              <strong>Comment:</strong> <?php echo $value1->comment;?>
                            </p>
                          </div>
                        </li>  
                  <?php 
                        } // end IF
                      } //End foreach
                    } // end outer If
                  ?>
                </ul>              </div>
            </div>  
          </div>

        </div>


        <div class="row comment_section">
           <div class="col-lg-12 col-md-12 col-sm-12 ">
             <div class="subHeading">
             Comments

             </div>
             <div class="clearfix"></div>
             <?php if($commentcount >5){?>
             <a href="javascript:void(0);" class="allcomments" title="View All Comments" id="viewAllComments">View All Comments</a>
             <?php } ?>
             <div class="clearfix"></div>
             <div id="all_comments" class="comment_block" style="display: none;">
               <ul class="contentListing comment_listing"> 
                      <?php if(!empty($forumDetails->forum_comments)){ 
                         foreach($allForumComments as $allcomments){?>

                         <?php  $useImg = $this->Custom->contractorImage($allcomments->user_id); 
                             $imagePath= $this->request->webroot.$useImg;
                         ?>
                          <li>
                           <div class="listingIcon">
                            <?php if(!empty($useImg)){?>
                              <div class="userImage circle-img-contractor-comment"><img src="<?php echo $imagePath;?>"></div>
                            <?php }else {?>
                                <i class="icon"><span class="fa fa-user"></span></i>
                            <?php } ?>
                           </div>
                           <div class="listingContent">

                              <div class="headingBar">
                                <h2 class="heading"><?php echo $userName = $this->Custom->contractorName($allcomments->user_id); ?></h2>
                                <h2 class="date-right date"><?php echo date_format($allcomments->created,"F d, Y").' '.date('h:m A', strtotime($allcomments->created));?></h2>
                              </div>
                              <p><?php echo $allcomments->comment; ?>
                              </p>

                              <div class="form-group pull-right">
                                <?php 
                                  echo $this->Form->postLink(__('Delete Comment'), ['action' => 'deletecomment', base64_encode($allcomments->id)], ['confirm' => __('Are you sure you want to delete this comment? '),'id'=>'delPostCm'.$allcomments->id]) 
                                ?>
                                <script type="text/javascript">
                                  $(document).ready(function () {
                                     $('#delPostCm<?php echo $allcomments->id;?>').html('<i class="red fa">Delete Comment</i>');
                                  });   
                                </script>
                              </div>

                            </div>
                          </li> 
                      <?php } ?>
                      <?php }else{ echo "No Comments."; } ?>   
               </ul>
             </div>


             
             <div id="limited_comments" class="comment_block">
               <ul class="contentListing comment_listing"> 
                      <?php if(!empty($forumDetails->forum_comments)){
                         foreach($forumComments as $comments){?>

                         <?php  $useImg = $this->Custom->contractorImage($comments->user_id); 
                             $imagePath= $this->request->webroot.$useImg;
                         ?>
                          <li>
                            <div class="listingIcon">
                              <?php if(!empty($useImg)){?>
                                <div class="userImage circle-img-contractor-comment"><img src="<?php echo $imagePath;?>"></div>
                              <?php }else {?>
                                <i class="icon"><span class="fa fa-user"></span></i>
                              <?php } ?>
                            </div>
                            <div class="listingContent">
                              <div class="headingBar">
                                <h2 class="heading"><?php echo $userName = $this->Custom->contractorName($comments->user_id); ?></h2>
                                <h2 class="date-right date"><?php echo date_format($comments->created,"F d, Y").' '.date('h:m A', strtotime($comments->created));?></h2>
                              </div>
                                <p><?php echo $comments->comment; ?>
                                </p>

                              <div class="form-group pull-right">
                                <?php 
                                  echo $this->Form->postLink(__('Delete Comment'), ['action' => 'deletecomment', base64_encode($comments->id)], ['confirm' => __('Are you sure you want to delete this comment? '),'id'=>'delPostCm'.$comments->id]) 
                                ?>
                                <script type="text/javascript">
                                  $(document).ready(function () {
                                     $('#delPostCm<?php echo $comments->id;?>').html('<i class="red fa">Delete Comment</i>');
                                  });   
                                </script>
                              </div>  
                            </div>
                          </li> 
                      <?php } ?>
                      <?php }else{ echo "No Comments."; } ?>   
               </ul>
             </div>
              <?php
                    //$cc= count($forumComments);
                        //if(!empty($forumComments)){
              ?>
                          <!--<nav class="pagingNav">
                                <ul class="pagination pagination-sm">
                                  <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                                <li><?= $this->Paginator->numbers() ?></li>
                                <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                                </ul>
                          </nav>-->

                  <?php //}else {?>
                          <!--<nav class="pagingNav">
                            <ul class="pagination pagination-sm">
                              <li>No Forums Found.</li>
                            </ul>
                          </nav>-->  
                  <?php //}?>
              <?php if($forumDetails->user_status != 2){ ?>
                  <!--<div class="form-group comment_post">
                   <div class="row">
                    <?= $this->Form->create($commentForm,['id'=>'FormField', 'enctype' => 'multipart/form-data']) ?>
                       <div class="col-lg-10 col-md-10 col-sm-12 ">
                         <?php
                              echo $this->Form->input('comment', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Add your Comment','class' => 'form-control'));
                           ?>
                           <?php 
                                echo $this->Form->error('comment', null, array('class' => 'error-message'));
                          ?>
                       </div>
                       <div class="col-lg-2 col-md-2 col-sm-12 no_paddingleftcol ">
                              <?= $this->Form->button('Post',['class'=> 'uploadBtn']) ?>
                        </div>
                    <?= $this->Form->end() ?>      
                     </div>
                  </div>-->
              <?php } ?>    
           </div>
        </div>


        </div>
</div>        
        <!-- /#page-content-wrapper --> 
        <script type="text/javascript">
          $('#viewAllComments').click(function(){
              $('#limited_comments').hide();
              $('#all_comments').show();
          });
        </script>
<style type="text/css">
  .comment_block.report_user {
  height: 400px;
  min-height: 200px !important;
  overflow-y: scroll;
}
.blueBtn {
  background: #03375c none repeat scroll 0 0;
  box-shadow: 0 4px 0 transparent;
}
.customBtn {
  border-radius: 4px;
  color: #fff;
  display: inline-block;
  font-size: 13px;
  font-weight: bold !important;
  margin-bottom: 5px;
  margin-right: 5px;
  min-width: 100px;
  padding: 12px 18px;
  text-align: center;
  text-transform: uppercase;
  transition: all 0.5s ease-in-out 0s;
}
.redBtn {
  background: #ff0000 none repeat scroll 0 0;
  box-shadow: 0 4px 0 transparent;
}
.greenBtn {
  background: #056a1f none repeat scroll 0 0;
  box-shadow: 0 4px 0 transparent;
}
.greyBtn {
  background: #4e4d4d none repeat scroll 0 0;
  box-shadow: 0 4px 0 transparent;
}


</style>        