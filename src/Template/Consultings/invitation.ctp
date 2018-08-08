<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li> <?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li> <?php
            echo $this->Html->link('Opportunities', array('controller'=>'BetaTesters','action'=>'index'), array('escape'=>false));
        ?></li>
        <li class="active">Consulting</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-6 col-md-6 col-sm-6 '>
     <div class="page_heading">
       <h1>Invitation</h1> 
      </div>
    </div>
    <div class='col-lg-6 col-md-6 col-sm-6'>
      <div class="profileName">
          <?php
              $entrepre = '<i><img src="'.$this->request->webroot.'img/icons/Funds.png" alt=""></i>';
              echo $this->Html->link( $entrepre .'FIND CONSULTING', array('controller'=>'Consultings','action'=>'index'), array('escape'=>false,'class'=>'active '));
          ?>
          <?php
              $entrepre = '<i><img src="'.$this->request->webroot.'img/icons/Funds.png" alt=""></i>';
              echo $this->Html->link( $entrepre .'ADD PROJECT', array('controller'=>'Consultings','action'=>'myConsulting'), array('escape'=>false,'class'=>'navbar-brand'));
          ?>
      </div>
    </div>
  </div>
  <!-- header ends --> 
 <div class="row">
    <div class="col-lg-12 col-md-12 col-sm-12">
      <div role="tabpanel" class="campaigns-section">
        <!-- Nav tabs -->
        <ul id="tabbing" class="nav consulting nav-tabs hidden-xs" role="tablist">

          <li role="presentation" >
          <?php $mycamp= $this->Url->build(["controller" => "Consultings","action" => "myConsulting"]);?>
          <a href="#myFund" aria-controls="My Assignments" role="tab" data-toggle="tab" onclick="location.href='<?php echo $mycamp;?>'">My Assignments</a></li>

          <li role="presentation">
          <?php $followi = $this->Url->build(["controller" => "Consultings","action" => "myArchived"]);?>
          <a href="#myArchived" aria-controls="My Archived" role="tab" data-toggle="tab" onclick="location.href='<?php echo $followi;?>'">Archived</a></li>

          <li role="presentation">
          <?php $commit= $this->Url->build(["controller" => "Consultings","action" => "myClosed"]);?>
          <a href="#myClosed" aria-controls="myClosed" role="tab" data-toggle="tab" onclick="location.href='<?php echo $commit;?>'">Closed</a></li>

          <li role="presentation" class="active">
          <?php $invi= $this->Url->build(["controller" => "Consultings","action" => "invitation"]);?>
          <a href="#invitation" aria-controls="invitation" role="tab" data-toggle="tab" onclick="location.href='<?php echo $invi;?>'">Invitation</a></li>

        </ul>
        <!-- Tab panes -->
        <div class="tab-content">

          <!--  2Tab -->
          <div role="tabpanel" class="tab-pane whiteBg" id="myFund">   
          </div>
          <!--  3Tab -->
          <div role="tabpanel" class="tab-pane whiteBg" id="myArchived">   
          </div>

          <!--  4Tab -->
          <div role="tabpanel" class="tab-pane whiteBg" id="myClosed">   
          </div>

          <!--  1Tab -->
          <div role="tabpanel" class="tab-pane active whiteBg" id="invitation">

              <ul class="contentListing campaignListing"> 
              
                <?php $c=0; 
                $countData= count($ConsultingInvitations);
                foreach ($ConsultingInvitations as $myFundsList): $c++;?>
                      <li>
                       <div class="listingIcon">
                        <?php 
                        if(!empty($myFundsList->consulting->image)){

                          echo '<img src="'.$this->request->webroot.'img/consulting/'.$myFundsList->consulting->image.'" width="50" height="50">';

                        }else{

                          echo '<i class="icon"><img src="'.$this->request->webroot.'images/campaign.png"></i>';
                        }
                        ?>
                       </div>
                       <div class="listingContent">
                         <div class="headingBar">
                           <h2 class="heading">
                            <?php 
                              echo $myFundsList->consulting->title;
                            ?>
                           <span>
                           Posted by : <?= h($myFundsList->consulting->user->first_name.' '.$myFundsList->consulting->user->last_name) ?>
                           </span></h2>

                           <h2 class="likes">
                            <?php echo $likeC = $this->Custom->getConsultingLikeCount($myFundsList->consulting->id);?> 
                            
                            <?php 
                            if($this->Custom->isConsultingLikedbyUser($myFundsList->consulting->id,$UserId)){

                              //echo '<a href="javascript:void(0);" title="Like" class="like"><i class="fa fa-thumbs-up"></i></a>';

                              echo $this->Form->postLink('Like',['action' => 'unlike', base64_encode($myFundsList->consulting->id)],['id'=>'likPost'.$c,'class'=>'like']);

                            }else{
                                echo $this->Form->postLink('Like',['action' => 'like', base64_encode($myFundsList->consulting->id)],['id'=>'likPost'.$c,'class'=>'notlike']);
                            }
                            ?>
                            

                            <?php echo $disLikeC = $this->Custom->getConsultingDislikeCount($myFundsList->consulting->id);?> 
                        
                            <?php 
                              if($this->Custom->isConsultingDislikedbyUser($myFundsList->consulting->id,$UserId)){

                                //echo '<a href="javascript:void(0);" title="Dislike" class="like"><i class="fa fa-thumbs-down"></i></a>';

                                echo $this->Form->postLink('Dislike',['action' => 'undisLike', base64_encode($myFundsList->consulting->id)],['id'=>'disLikPost'.$c,'class'=>'like']);

                              }else{

                                echo $this->Form->postLink('Dislike',['action' => 'disLike', base64_encode($myFundsList->consulting->id)],['id'=>'disLikPost'.$c,'class'=>'notdislike']);
                              }
                          ?>
                           </h2>
                         </div>
                         <p>
                         <?= h($myFundsList->consulting->overview) ?> 
                         </p>
                         <p class="date"> Start Date: <?= $myFundsList->consulting->project_start_date; ?></p>
                         <p class="date"> Status: 
                          <?php  
                            if(empty($myFundsList->consulting->award_status)){
                                echo "Open";
                            }else{
                                echo "Close";
                            }    
                          ?>
                         </p>
                         <p class="date"> Invitation Sent By: <?= $myFundsList->by_user->first_name.' '.$myFundsList->by_user->last_name; ?></p>
                         <div class="links alignRight">

                          
                          <?php 

                             echo $this->Form->postLink('Accept',['action' => 'accept', base64_encode($myFundsList->consulting->id),base64_encode($myFundsList->sent_by)],['id'=>'arcPost'.$c,'class'=>'smallCurveBtnMsg greenBtn customBtnMsg ']);
                          ?>
                          
                          <?php 
                             echo $this->Form->postLink('Reject',['action' => 'reject', base64_encode($myFundsList->consulting->id),base64_encode($myFundsList->sent_by)],['id'=>'delPost'.$c,'class'=>'smallCurveBtnMsg redBtn customBtnMsg']);
                          ?>
                         </div>
                      </div>
                        <script type="text/javascript">
                         $(document).ready(function () {
                             $('#delPost<?php echo $c;?>').html('Reject');
                             $('#arcPost<?php echo $c;?>').html('Accept');
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
                    <li>No Consulting Invitations Available.</li>
                  </ul>
                </nav>  
            <?php } ?>

            <div class="clearfix"></div>
          </div>

          

        </div>
      </div>
    </div>
  </div>
</div>
