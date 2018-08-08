<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li><?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li><?php
            echo $this->Html->link('Funds', array('controller'=>'Funds','action'=>'index'), array('escape'=>false));
        ?></li>
        <li class="active">View Fund</li>
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
                  $likeC = $this->Custom->getFundLikeCount($fundDeatils->id);

                  if(!empty($likeC)){

                  echo $this->Html->link($likeC, array('controller'=>'Funds','action'=>'likeList',base64_encode($fundDeatils->id)), array('escape'=>false,'title'=>'View','style'=>'color: rgb(3, 66, 110);'));

                  }else{
                    echo  $likeC;
                  }
            ?> 
            
            <?php 
            if($this->Custom->isFundLikedbyUser($fundDeatils->id,$userId)){

              //echo '<a href="javascript:void(0);" title="Like" class="like"><i class="fa fa-thumbs-up"></i></a>';
              echo $this->Form->postLink('Like',['action' => 'unLikeFund', base64_encode($fundDeatils->id)],['id'=>'likPost','class'=>'like']);

            }else{
                echo $this->Form->postLink('Like',['action' => 'likeFund', base64_encode($fundDeatils->id)],['id'=>'likPost','class'=>'notlike']);
            }
            ?>
            

            <?php 
              $disLikeC = $this->Custom->getFundDislikeCount($fundDeatils->id);
              if(!empty($disLikeC)){

                  echo $this->Html->link($disLikeC, array('controller'=>'Funds','action'=>'dislikeList',base64_encode($fundDeatils->id)), array('escape'=>false,'title'=>'View','style'=>'color: rgb(3, 66, 110);'));

              }else{
                echo  $disLikeC;
              }

            ?> 
        
            <?php 
              if($this->Custom->isFundDislikedbyUser($fundDeatils->id,$userId)){

                //echo '<a href="javascript:void(0);" title="Dislike" class="like"><i class="fa fa-thumbs-down"></i></a>';
                echo $this->Form->postLink('Dislike',['action' => 'undisLikeFund', base64_encode($fundDeatils->id)],['id'=>'disLikPost','class'=>'like']);

              }else{

                echo $this->Form->postLink('Dislike',['action' => 'disLikeFund', base64_encode($fundDeatils->id)],['id'=>'disLikPost','class'=>'notdislike']);
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
      <label>Fund's Title</label>
        <span class="form-control"><?= h($fundDeatils->title) ?></span>
      </div>

      <div class="form-group">
          <label>Fund's Description</label>
          <span class="form-control textArea">
          <?= h($fundDeatils->description) ?></span>
      </div> 

      <div class="form-group">
      <label>Fund's Managers</label>
        <span id="selectedResult" class="form-control textArea">
          <ul>
          <?php
            $skey= explode(',', $fundDeatils->managers_id);
              $cskey=count($skey);
                if(!empty($skey[0])){
                  for($i=0; $i<$cskey; $i++){
                      $slids=$skey[$i];
                         echo '<li id="sel_'.$slids.'"><a href="javascript:void(0)">'.$managerLists[$slids].'</a></li>';
                   }
                }else {
                         echo "No Fund's Managers Added";
                }
          ?>
        </ul>
        </span>
       
      </div>

      <div class="form-group">
      <label>Sponsors</label>
        <span id="selectedResult" class="form-control textArea">
          <ul>
          <?php
            $skey2= explode(',', $fundDeatils->sponsors_id);
              $cskey2=count($skey2);
                if(!empty($skey2[0])){
                  for($ij=0; $ij<$cskey2; $ij++){
                      $slids2=$skey2[$ij];
                         echo '<li id="sel_'.$slids2.'"><a href="javascript:void(0)">'.$sponsorsLists[$slids2].'</a></li>';
                   }
                }else {
                         echo 'No Sponsors Sponsors';
                }
          ?>
        </ul>
        </span>
       
      </div>


      <div class="form-group">
      <label>Industry</label>
        <span id="selectedResult" class="form-control textArea">
          <ul>
          <?php
            $skey3= explode(',', $fundDeatils->indusries_id);
              $cskey3=count($skey3);
                if(!empty($skey3[0])){
                  for($ij=0; $ij<$cskey3; $ij++){
                      $slids3=$skey3[$ij];
                         echo '<li id="sel_'.$slids3.'"><a href="javascript:void(0)">'.$industryLists[$slids3].'</a></li>';
                   }
                }else {
                         echo 'No Industry';
                }
          ?>
        </ul>
        </span>
       
      </div>

      <div class="form-group">
      <label>Portfolio Companies</label>
        <span id="selectedResult" class="form-control textArea">
          <ul>
          <?php
            $skey4= explode(',', $fundDeatils->portfolios_id);
              $cskey4=count($skey4);
                if(!empty($skey4[0])){
                  for($ij=0; $ij<$cskey4; $ij++){
                      $slids4=$skey4[$ij];
                         echo '<li id="sel_'.$slids4.'"><a href="javascript:void(0)">'.$portfolioLists[$slids4].'</a></li>';
                   }
                }else {
                         echo 'No Portfolio Companies Added';
                }
          ?>
        </ul>
        </span>
       
      </div>

      

      
      
    </div>

    <div class="col-lg-6 col-md-6 col-sm-12 ">
          <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
              <div class="form-group">
                  <label>Investment Start Date</label>
                  <span class="form-control"><?= h($fundDeatils->start_date) ?></span>
                  
              </div>
              
              <div class="form-group">
                  <label>Investment End Date</label>
                  <span class="form-control"><?= h($fundDeatils->end_date) ?></span>
                  
              </div>
              
              <div class="form-group">
                  <label>Fund's Investment Closure Date</label>
                  <span class="form-control"><?= h($fundDeatils->close_date) ?></span>
              </div>
              <div class="form-group">
                <label>Keywords</label>
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
                                   echo 'No Keywords Added';
                          }
                    ?>
                  </ul>
                  </span>
                 
                </div>

              <div class="panel panel-default">
                <div class="panel-heading" role="tab" id="headingOne">
                  <h4 class="panel-title">
                    <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                      Image
                    </a>
                  </h4>
                </div>
                <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                  <div class="panel-body">
                    <div class="image-Holder">
                      <?php if(!empty($fundDeatils->image)){?>
                        <img src="<?php echo $this->request->webroot.'img/funds/'.$fundDeatils->image;?>" alt="Fund Image">
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
                          
                          echo '<li><a href="'.$this->request->webroot.'img/funds/'.$fundDeatils->document.'" target="_blank"> Document <i class="fa fa-eye"></i></a>';

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
                          
                          echo '<li><a href="'.$this->request->webroot.'img/funds/'.$fundDeatils->audio.'" target="_blank"> Audio <i class="fa fa-eye"></i></a>';

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
                          
                          echo '<li><a href="'.$this->request->webroot.'img/funds/'.$fundDeatils->video.'" target="_blank"> Video <i class="fa fa-eye"></i></a>';

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
                  $class= 'greenBtn';
                  $titleFollow='Unfollow';
                    $followLink= $this->Url->build(["controller" => "Funds","action" => "unfollowFund",base64_encode($fundDeatils->id),base64_encode($userId)]);                      
              }else {
                $class= 'blueBtn';
                $titleFollow='Follow';
                    $followLink= $this->Url->build(["controller" => "Funds","action" => "followFund",base64_encode($fundDeatils->id),base64_encode($userId)]);   
              }

        ?>

         <button class="customBtn <?php echo $class;?>" type="button" onclick="location.href='<?php echo $followLink;?>'"><?php echo $titleFollow;?></button>
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