<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Forums', array('controller'=>'Forums','action'=>'startupForum'), array('escape'=>false));
                ?></li>
                <li class="active">Forum View</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
             <div class="page_heading">
               <h1>Forum View</h1> 
              </div>
            </div>
            
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
           <?php echo $forumDetails->description;?>
           </p>
         </div>
        </div>
        </div>
        <div class="row comment_section">
           <div class="col-lg-12 col-md-12 col-sm-12 ">
             <div class="subHeading">
             Comments

             <?php if($forumDetails->user_status != 2){ ?>
                  <?php if($forumDetails->user_id != $UserId){?>
                    <div class="form-group pull-right">
                        <?php
                              echo $this->Html->link('Report Forum', array('controller'=>'Forums','action'=>'reportForum',base64_encode($forumDetails->id)), array('escape'=>false,'class'=>'customBtn blueBtn'));
                        ?>
                    </div>
                    <?php } ?>
             <?php } ?>  

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
                  <div class="form-group comment_post">
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
                  </div>
              <?php } ?>    
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