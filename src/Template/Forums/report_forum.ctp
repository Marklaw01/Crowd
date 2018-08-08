<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Forum View', array('controller'=>'Forums','action'=>'viewForum',base64_encode($forumDetails->id)), array('escape'=>false));
                ?></li>
                <li class="active">Report Forum</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
             <div class="page_heading">
               <h1>Report Forum</h1> 
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
           <p>
           <?php echo $forumDetails->description;?>
           </p>
         </div>
        </div>
        </div>
        <div class="row comment_section">
           <div class="col-lg-12 col-md-12 col-sm-12 ">
             <div class="subHeading2">
             Please select the people that you want to report for Forum abuse.
              <div class="form-group pull-right">
              <?php
                    echo $this->Html->link('Back', array('controller'=>'Forums','action'=>'viewForum',base64_encode($forumDetails->id)), array('escape'=>false,'class'=>'customBtn blueBtn'));
              ?>
              </div>
             </div>

<?php if($forumDetails->user_status != 2){ ?>

            <?= $this->Form->create($reportForm,['id'=>'FormField', 'enctype' => 'multipart/form-data']) ?>
           <div class="col-lg-10 col-md-10 col-sm-12 report-form">
             <div class="checkbox">

                    <?php if($UserId != $forumDetails->user_id){?>
                      <div class="form-group report-myform">
                          <input type="checkbox"  id="part<?php echo $forumDetails->user_id; ?>" name="is_form_reported" class="checkinput" value="<?php echo $forumDetails->user_id;?>"/>

                          <label for="part<?php echo $forumDetails->user_id; ?>" > <?php echo $forumDetails->title;?><?php //echo $userName = $this->Custom->contractorName($forumDetails->user_id); ?> <strong>(Forum)</strong></label> 
                      </div>
                    <?php } ?>

                      <?php if(!empty($forumDetails->forum_comments)){
                         foreach($forumCommentUsers as $comments){ if($forumDetails->user_id != $comments->user_id){?>

                         <?php  $useImg = $this->Custom->contractorImage($comments->user_id); 
                             $imagePath= $this->request->webroot.$useImg;
                         ?>
                         <div class="form-group">
                          <input type="checkbox"  id="part<?php echo $comments->user_id; ?>" name="reported_users[]" class="checkinput" value="<?php echo $comments->user_id;?>"/>

                          <label for="part<?php echo $comments->user_id; ?>" > <?php echo $userName = $this->Custom->contractorName($comments->user_id); ?></label> 
                         </div>
 
                      <?php }  } ?>
                      <?php }else{ echo "No user list found."; } ?>   
             
              </div>
              </div>
              
                  <div class="form-group comment_post">
                   <div class="row">
                    
                       <div class="col-lg-10 col-md-10 col-sm-12 ">
                         <?php
                              echo $this->Form->input('comment', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Why do you want to report abuse?','class' => 'form-control'));
                           ?>
                           <?php 
                                echo $this->Form->error('comment', null, array('class' => 'error-message'));
                          ?>
                       </div>
                       <div class="col-lg-2 col-md-2 col-sm-12 no_paddingleftcol ">
                              <?= $this->Form->button('Post',['class'=> 'uploadBtn']) ?>
                        </div>
                         
                     </div>
                  </div>
               

           <?= $this->Form->end() ?>    
<?php } ?>              
           </div>
        </div>


        </div>
        <!-- /#page-content-wrapper --> 