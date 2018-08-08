<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li> <?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li> <?php
            echo $this->Html->link('Events', array('controller'=>'Conferences','action'=>'index'), array('escape'=>false));
        ?></li>

        <li class="active">View Conference</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
     <div class="page_heading">
       <h1><?= h($fundDeatils->title) ?></h1> 
      </div>
    </div>

    <div class='col-lg-8 col-md-8 col-sm-12 '>
      <div class="form-group">
        <span>
          <?php $postedBy= $fundDeatils->user->first_name.' '.$fundDeatils->user->last_name;?>
          <?php
            echo $this->Html->link('Posted By : '.$postedBy, array('controller'=>'Contractors','action'=>'viewProfile',base64_encode($fundDeatils->user->id)), array('escape'=>false,'title'=>'View Profile','style'=>'color: rgb(3, 66, 110);'));
          ?>
        </span>
      </div>
    </div>

    <div class='col-lg-4 col-md-4 col-sm-4 '>
      <div class="form-group">
        <span class="contentListingLikes">
          <h2 class="likes">
            <?php 
              $likeC = $this->Custom->getConferenceLikeCount($fundDeatils->id);
              if(!empty($likeC)){

                  echo $this->Html->link($likeC, array('controller'=>'Conferences','action'=>'likeList',base64_encode($fundDeatils->id)), array('escape'=>false,'title'=>'View','style'=>'color: rgb(3, 66, 110);'));

              }else{
                echo  $likeC;
              }
            ?> 
            &nbsp;
            <?php 
            if($this->Custom->isConferenceLikedbyUser($fundDeatils->id,$userId)){

             // echo '<a href="javascript:void(0);" title="Like" class="like"><i class="fa fa-thumbs-up"></i></a> &nbsp;';
              echo $this->Form->postLink('Like',['action' => 'unlike', base64_encode($fundDeatils->id)],['id'=>'likPost','class'=>'like']);

            }else{
                echo $this->Form->postLink('Like',['action' => 'like', base64_encode($fundDeatils->id)],['id'=>'likPost','class'=>'notlike']);
            }
            ?>
            
            &nbsp;
            <?php 
              $disLikeC = $this->Custom->getConferenceDislikeCount($fundDeatils->id);
              if(!empty($disLikeC)){

                  echo $this->Html->link($disLikeC, array('controller'=>'Conferences','action'=>'dislikeList',base64_encode($fundDeatils->id)), array('escape'=>false,'title'=>'View','style'=>'color: rgb(3, 66, 110);'));

              }else{
                echo  $disLikeC;
              }
            ?> 
            &nbsp;
            <?php 
              if($this->Custom->isConferenceDislikedbyUser($fundDeatils->id,$userId)){

               // echo '<a href="javascript:void(0);" title="Dislike" class="like"><i class="fa fa-thumbs-down"></i></a>';
                echo $this->Form->postLink('Dislike',['action' => 'undisLike', base64_encode($fundDeatils->id)],['id'=>'disLikPost','class'=>'like']);

              }else{

                echo $this->Form->postLink('Dislike',['action' => 'disLike', base64_encode($fundDeatils->id)],['id'=>'disLikPost','class'=>'notdislike']);
              }
          ?>
        </h2>
        </span>
      </div>
    </div>

    
  </div>
  <!-- header ends --> 
  <form>
  <div class="row">
    <div class="col-lg-6 col-md-6 col-sm-12 ">
      <div class="form-group">
      <label>Conference Title</label>
        <span class="form-control"><?= h($fundDeatils->title) ?></span>
      </div>

      <div class="form-group">
          <label>Conference Description</label>
          <span class="form-control textArea">
          <?= h($fundDeatils->description) ?></span>
      </div> 
      
      <div class="form-group">
          <label>Conference Start Date</label>
          <span class="form-control"><?= h($fundDeatils->start_date) ?></span>
          
      </div>
      
      <div class="form-group">
          <label>Conference End Date</label>
          <span class="form-control"><?= h($fundDeatils->end_date) ?></span>
          
      </div>

      <div class="form-group">
        <label>Target Market</label>
        <span id="selectedResult" class="form-control textArea">
          <ul>
          <?php
            $skey4= explode(',', $fundDeatils->target_market);
              $cskey4=count($skey4);
                if(!empty($skey4[0])){
                  for($ij=0; $ij<$cskey4; $ij++){
                      $slids4=$skey4[$ij];
                         echo '<li id="sel_'.$slids4.'"><a href="javascript:void(0)">'.$targetMarketLists[$slids4].'</a></li>';
                   }
                }else {
                         echo 'Target Market Keywords';
                }
          ?>
          </ul>
        </span>
       
      </div>

      <div class="form-group">
        <label>Conference Keywords</label>
        <span id="selectedResult" class="form-control textArea">
          <ul>
          <?php
            $skey5= explode(',', $fundDeatils->keywords_id);
              $cskey5=count($skey5);
                if(!empty($skey5[0])){
                  for($ij=0; $ij<$cskey5; $ij++){
                      $slids5=$skey5[$ij];
                         echo '<li id="sel_'.$slids5.'"><a href="javascript:void(0)">'.$keywordsLists[$slids5].'</a></li>';
                   }
                }else {
                         echo 'Conference Keywords';
                }
          ?>
          </ul>
        </span>
       
      </div>

      


    </div>

    <div class="col-lg-6 col-md-6 col-sm-12 ">
          <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
              <div class="form-group">
                <label>Interest Keywords</label>
                <span id="selectedResult" class="form-control textArea">
                  <ul>
                  <?php
                    $skey3= explode(',', $fundDeatils->interest_keywords_id);
                      $cskey3=count($skey3);
                        if(!empty($skey3[0])){
                          for($ij=0; $ij<$cskey3; $ij++){
                              $slids3=$skey3[$ij];
                                 echo '<li id="sel_'.$slids3.'"><a href="javascript:void(0)">'.$intrestKeywordLists[$slids3].'</a></li>';
                           }
                        }else {
                                 echo 'Interest Keywords';
                        }
                  ?>
                  </ul>
                </span>
               
              </div>

              <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingOne">
                  <h4 class="panel-title">
                    <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                      Graphic
                    </a>
                  </h4>
                </div>
                <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                  <div class="panel-body">
                    <div class="image-Holder">
                      <?php if(!empty($fundDeatils->image)){?>
                        <img src="<?php echo $this->request->webroot.'img/conference/'.$fundDeatils->image;?>" alt="Fund Image">
                      <?php } ?>
                    </div>
                    </div>
                </div>
              </div>

              <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingTwo">
                  <h4 class="panel-title">
                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                     View Documents
                    </a>
                  </h4>
                </div>
                <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                  <div class="panel-body">
                   <ul class="listing anchor">
                    <?php 
                        if(!empty($fundDeatils->document)){
                          
                          echo '<li><a href="'.$this->request->webroot.'img/conference/'.$fundDeatils->document.'" target="_blank"> Document <i class="fa fa-eye"></i></a>';

                       }   
                    ?>
                     
                   </ul>
                  </div>
                </div>
              </div>

              <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingTwo">
                  <h4 class="panel-title">
                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                     Play Audio
                    </a>
                  </h4>
                </div>
                <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                  <div class="panel-body">
                   <ul class="listing anchor">
                     <?php 
                        if(!empty($fundDeatils->audio)){
                          
                          echo '<li><a href="'.$this->request->webroot.'img/conference/'.$fundDeatils->audio.'" target="_blank"> Audio <i class="fa fa-eye"></i></a>';

                       }   
                    ?>
                   </ul>
                  </div>
                </div>
              </div>

              <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingTwo">
                  <h4 class="panel-title">
                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                      Play Video
                    </a>
                  </h4>
                </div>
                <div id="collapseFour" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                  <div class="panel-body">
                   <ul class="listing anchor">
                      <?php 
                        if(!empty($fundDeatils->video)){
                          
                          echo '<li><a href="'.$this->request->webroot.'img/conference/'.$fundDeatils->video.'" target="_blank"> Video <i class="fa fa-eye"></i></a>';

                        }   
                      ?>
                   </ul>
                  </div>
                </div>
              </div>  

              
         
          </div> 
      </div>

      <div class="col-lg-12 col-md-12 col-sm-12 ">
       <div class="form-group pull-right">
        
        <?php 
            if($userId != $fundDeatils->user_id){
            
              // Follow and unfollow button
              if(!empty($is_follwed_by_user)){
                  $class1= 'greenBtn';
                  $titleFollow='Unfollow';
                    $followLink= $this->Url->build(["controller" => "Conferences","action" => "unfollow",base64_encode($fundDeatils->id),base64_encode($userId)]);                      
              }else {
                $class1= 'blueBtn';
                $titleFollow='Follow';
                    $followLink= $this->Url->build(["controller" => "Conferences","action" => "follow",base64_encode($fundDeatils->id),base64_encode($userId)]);   
              }


              // Follow and unfollow button
              if(!empty($is_commited_by_user)){
                  $class= 'greenBtn';
                  $titleCommit='Thank you. You have registered your interest.';
                    $CommitLink= $this->Url->build(["controller" => "Conferences","action" => "uncommit",base64_encode($fundDeatils->id),base64_encode($userId)]);                      
              }else {
                $class= 'blueBtn';
                $titleCommit='Click here to register your interest.';
                    $CommitLink= $this->Url->build(["controller" => "Conferences","action" => "commit",base64_encode($fundDeatils->id),base64_encode($userId)]);   
              }

        ?>

        <button class="customBtn <?php echo $class;?>" type="button" onclick="location.href='<?php echo $CommitLink;?>'"><?php echo $titleCommit;?></button>

        <button class="customBtn <?php echo $class1;?>" type="button" onclick="location.href='<?php echo $followLink;?>'"><?php echo $titleFollow;?></button>
        
        <?php } ?> 
      </div>
      </div>
  </div>
</div>
<!-- /#page-content-wrapper --> 
<script type="text/javascript">
 $(document).ready(function () {
     $('#likPost').html('<i class="fa fa-thumbs-up"></i>');
     $('#disLikPost').html('<i class="fa fa-thumbs-down"></i>');
  });   
</script>