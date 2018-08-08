<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li><?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li class="active"><?php
            echo $this->Html->link('Resources', array('controller'=>'Hardwares','action'=>'index'), array('escape'=>false));
        ?></li>
        <li class="active">My Audio Video</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-6 col-md-6 col-sm-6 '>
     <div class="page_heading">
       <h1>My Audio Video</h1> 
      </div>
    </div>
    <div class='col-lg-6 col-md-6 col-sm-6'>
      <div class="profileName">
          <?php
              $entrepre = '<i><img src="'.$this->request->webroot.'img/icons/Funds.png" alt=""></i>';
              echo $this->Html->link( $entrepre .'FIND AUDIO/VIDEO', array('controller'=>'AudioVideos','action'=>'index'), array('escape'=>false,'class'=>'navbar-brand'));
          ?>
          <?php
              $entrepre = '<i><img src="'.$this->request->webroot.'img/icons/Funds.png" alt=""></i>';
              echo $this->Html->link( $entrepre .'MY AUDIO/VIDEO', array('controller'=>'AudioVideos','action'=>'myAudioVideo'), array('escape'=>false,'class'=>'active'));
          ?>
      </div>
    </div>
  </div>
  <!-- header ends --> 
 <div class="row">
    <div class="col-lg-12 col-md-12 col-sm-12">
      <div role="tabpanel" class="campaigns-section">
        <!-- Nav tabs -->
        <ul id="tabbing" class="nav aboutTab nav-tabs hidden-xs" role="tablist">

          <li role="presentation" class="active">
          <?php $mycamp= $this->Url->build(["controller" => "AudioVideos","action" => "myAudioVideo"]);?>
          <a href="#myFund" aria-controls="My Funds" role="tab" data-toggle="tab" onclick="location.href='<?php echo $mycamp;?>'">My Audio Video</a></li>

          <li role="presentation">
          <?php $followi = $this->Url->build(["controller" => "AudioVideos","action" => "myArchived"]);?>
          <a href="#myArchived" aria-controls="My Archived" role="tab" data-toggle="tab" onclick="location.href='<?php echo $followi;?>'">Archived</a></li>

          <li role="presentation">
          <?php $commit= $this->Url->build(["controller" => "AudioVideos","action" => "myDeactivated"]);?>
          <a href="#myDeactivated" aria-controls="myDeactivated" role="tab" data-toggle="tab" onclick="location.href='<?php echo $commit;?>'">Deactivated</a></li>

        </ul>
        <!-- Tab panes -->
        <div class="tab-content">
          <!--  1Tab -->
          <div role="tabpanel" class="tab-pane active whiteBg" id="myFund">
              <div class="form-group">
                <div class="row">
                  <?= $this->Form->create('Search',['id'=>'FormField','type'=>'get']) ?>
                      <div class="col-lg-9 col-md-9 col-sm-12 ">
                      <input type="search" placeholder="Search" name="search" class="form-control">
                      </div>
                      <div class="col-lg-3 col-md-3 col-sm-12 no_paddingleftcol ">
                      <button class="searchBtn" type="submit">Search</button>
                      </div>
                  <?= $this->Form->end() ?>
                </div>
              </div>

              <div class="col-lg-12 col-md-12 col-sm-12 ">
                <div class="form-group">
                  <?= $this->Html->link(__('Add AUDIO/VIDEO'), ['action' => 'add'],['class'=>'customBtn blueBtn  pull-right']) ?>
                </div>
              </div>

              <ul class="contentListing campaignListing"> 
              
                <?php $c=0; 
                $countData= count($myFundsLists);
                foreach ($myFundsLists as $myFundsList): $c++;?>
                      <li>
                       <div class="listingIcon">
                        <?php 
                        $id = base64_encode($myFundsList['user_id']);
                        $fundId= base64_encode($myFundsList['id']);
                        if(!empty($myFundsList['image'])){

                          echo $this->Html->link('<img src="'.$this->request->webroot.'img/audio_video/'.$myFundsList['image'].'" width="50" height="50">',['controller'=>'AudioVideos','action'=>'view',$fundId],['escape'=>false,'title'=>'Click Here View']);

                        }else{

                          echo $this->Html->link('<i class="icon"><img src="'.$this->request->webroot.'images/campaign.png"></i>',['controller'=>'AudioVideos','action'=>'view',$fundId],['escape'=>false,'title'=>'Click Here View']);
                        }
                        ?>
                       </div>
                       <div class="listingContent">
                         <div class="headingBar">
                           <h2 class="heading">
                            <?php 
                              echo $this->Html->link($myFundsList['title'],['controller'=>'AudioVideos','action'=>'view',$fundId],['escape'=>false,'title'=>'Click Here View']);
                            ?>
                           <span>
                           Posted by : <?= h($myFundsList->user->first_name.' '.$myFundsList->user->last_name) ?>
                           </span></h2>

                           <h2 class="likes">
                            <?php echo $likeC = $this->Custom->getAudioLikeCount($myFundsList->id);?> 
                            
                            <?php 
                            if($this->Custom->isAudioLikedbyUser($myFundsList->id,$UserId)){

                              //echo '<a href="javascript:void(0);" title="Like" class="like"><i class="fa fa-thumbs-up"></i></a>';

                              echo $this->Form->postLink('Like',['action' => 'unlikeAudio', base64_encode($myFundsList->id)],['id'=>'likPost'.$c,'class'=>'like']);

                            }else{
                                echo $this->Form->postLink('Like',['action' => 'likeAudio', base64_encode($myFundsList->id)],['id'=>'likPost'.$c,'class'=>'notlike']);
                            }
                            ?>
                            

                            <?php echo $disLikeC = $this->Custom->getAudioDislikeCount($myFundsList->id);?> 
                        
                            <?php 
                              if($this->Custom->isAudioDislikedbyUser($myFundsList->id,$UserId)){

                                //echo '<a href="javascript:void(0);" title="Dislike" class="like"><i class="fa fa-thumbs-down"></i></a>';

                                echo $this->Form->postLink('Dislike',['action' => 'undisLikeAudio', base64_encode($myFundsList->id)],['id'=>'disLikPost'.$c,'class'=>'like']);

                              }else{

                                echo $this->Form->postLink('Dislike',['action' => 'disLikeAudio', base64_encode($myFundsList->id)],['id'=>'disLikPost'.$c,'class'=>'notdislike']);
                              }
                          ?>
                           </h2>
                         </div>
                         <p>
                         <?= h($myFundsList->description) ?> 
                         </p>
                         <p class="date"> Start Date: <?= $myFundsList->start_date; ?>
                         </p>
                         <div class="links alignRight">

                          
                          <?php 

                             echo $this->Form->postLink('Archive',['action' => 'archiveAudio', base64_encode($myFundsList->id)],['id'=>'arcPost'.$c,'class'=>'smallCurveBtnMsg greenBtn customBtnMsg ']);
                          ?>
                          <?php 

                             echo $this->Form->postLink('Deactivate',['action' => 'deactivateAudio', base64_encode($myFundsList->id)],['id'=>'deacPost'.$c,'class'=>'smallCurveBtnMsg blueBtn customBtnMsg']);
                          ?>

                          <?php 
                             echo $this->Html->link('<i class="fa fa-pencil"></i>Edit', array('action' => 'edit', base64_encode($myFundsList->id)), array('escape'=>false,'class'=>'smallCurveBtnMsg blueBtn customBtnMsg'));
                          ?>
                          <?php 

                             echo $this->Form->postLink('Delete',['action' => 'deleteAudio', base64_encode($myFundsList->id)],['id'=>'delPost'.$c,'class'=>'smallCurveBtnMsg redBtn customBtnMsg']);
                          ?>
                         </div>
                      </div>
                        <script type="text/javascript">
                         $(document).ready(function () {
                             $('#delPost<?php echo $c;?>').html('<i class="fa fa-trash-o"></i>Delete');
                             $('#arcPost<?php echo $c;?>').html('<i class="fa fa-download"></i>Archive');
                             $('#deacPost<?php echo $c;?>').html('<i class="fa fa-toggle-off "></i>Deactivate');
                             $('#likPost<?php echo $c;?>').html('<i class="fa fa-thumbs-up"></i>');
                             $('#disLikPost<?php echo $c;?>').html('<i class="fa fa-thumbs-down"></i>');
                          });   
                        </script>
                      </li>  
                <?php endforeach; ?>
            </ul>
            
            <?php if(!empty($countData)){?>

              <nav>
                <ul class="pagination pagination-sm">
                  <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                  <li><?= $this->Paginator->numbers() ?></li>
                  <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                </ul>
              </nav>

            <?php }else { ?>
                <nav>
                  <ul class="pagination pagination-sm">
                    <li>No Audio Video Available.</li>
                  </ul>
                </nav>  
            <?php } ?>
            

            <div class="clearfix"></div>
          </div>

          <!--  2Tab -->
          <div role="tabpanel" class="tab-pane whiteBg" id="myArchived">   
          </div>
          <!--  3Tab -->
          <div role="tabpanel" class="tab-pane whiteBg" id="myDeactivated">   
          </div>

        </div>
      </div>
    </div>
  </div>
</div>
