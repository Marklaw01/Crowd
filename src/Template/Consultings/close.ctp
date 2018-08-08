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
  <!-- header ends --> 

  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-6 col-md-6 col-sm-6 '>
     <div class="page_heading">
       <h1>Close Consulting</h1> 
      </div>
    </div>
  </div>

  <div class="row">

    <div class="col-lg-6 col-md-6 col-sm-12 ">
      <div class="form-group">
        <span class="page_heading">
          <h1><?= h($ConsultingDetails->title) ?></h1> 
        </span>
      </div>

    </div>

  </div> 
  
  <!-- <div class="row">

    <div class="col-lg-6 col-md-6 col-sm-12 ">
      <div class="form-group">
        <label>Consulting Project Title</label>
        <span class="form-control"><?= h($ConsultingDetails->title) ?></span>
      </div>

    </div>

    <div class="col-lg-6 col-md-6 col-sm-12 ">
      <div class="form-group">
          <label>Assignment Start Date Time</label>
          <span class="form-control ">
          <?= h($ConsultingDetails->assignment_start_date) ?></span>
      </div> 

    </div>
  </div>  -->   

  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
      <!-- <div class="form-group">
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
      </div> -->
      
        <ul class="contentListing Contractor_listing"> 
          <?php
            if(!empty($ConsultingCommitmentsList)){
              foreach($ConsultingCommitmentsList as $user){
                $useImg = $this->Custom->contractorImage($user->user_id);
          ?>
              <li>
                <?= $this->Form->create('Close',['id'=>'FormField']) ?>
                  <div class="search_radio">
                    <input type="hidden" name="contractor_id" value="<?php echo $user->user_id; ?>">
                  </div>

                  <div class="toppp">

                      <div class="listingIcon">
                        <div class="circle-img-sidebar">
                        <?php if(!empty($useImg)){?>
                          <img src="<?php echo $this->request->webroot.$useImg; ?>">
                        <?php }else {?>
                        <img src="<?php echo $this->request->webroot?>images/dummy-man.png">
                        <?php } ?>  
                        </div>
                      </div>
                
                      <div class="listingContent">
                       <div class="headingBar">

                          <h2 class="heading"><?php echo $user->user->first_name.' '.$user->user->last_name; ?>
                          </span></h2>
                          <!-- <h2 class="amount">
                          $
                          <?php 
                              //if(!empty($user->user->contractor_basic)){
                                //echo $this->Number->precision($user->user->contractor_basic->price,2);
                             // }else{
                                //echo '00';  
                             // }
                          ?>
                          /hr</h2> -->
                       </div>
                       <p>
                       <?php 
                       if(!empty($user->contractor_basic)){
                          //echo $user->contractor_basic->bio;
                       }
                       ?>
                       <?php 
                       $keyws = $this->Custom->getUserKeywords($user->user_id);
                          if(!empty($keyws)){
                                  $skey= explode(',', $keyws);
                                  $cc =count($skey);
                                      if(!empty($skey[0])){
                                            for($vi=0; $vi<$cc; $vi++){
                                                  $slids=$skey[$vi];
                                                  //echo $slids;
                                                  //echo $Keywords[$slids]; selectedResult
                                                  echo $Keywords[$slids];
                                                  if($vi<$cc-1){ echo ', ';}
                                            }
                                        }
                           }              
                      ?> 
                       </p>
                        <div class="links alignRight">
                          <?php 
                            echo $this->Html->link('<i class="fa fa-eye"></i>View', array('controller'=>'contractors', 'action' => 'viewProfile', base64_encode($user->user_id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                          ?>

                          <?= $this->Form->button('Award',['name'=>'award','class'=> 'smallCurveBtnMsg greenBtn customBtnMsg ']) ?>

                        </div>
                    </div>
                  </div>
                <?= $this->Form->end() ?>
              </li> 

            <?php } // foreach end ?> 
          <?php } //if end ?>
        </ul>
      
        <nav class="pagingNav">
          <ul class="pagination pagination-sm"> 
              <?php if(!empty(count($ConsultingCommitmentsList))){ ?>
                <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                <li><?= $this->Paginator->numbers() ?></li>
                <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
              <?php } else {?>
                <li>No Contractors Available.</li>
             <?php } ?> 
          </ul>
        </nav> 

        <?= $this->Form->create('Close',['id'=>'FormField']) ?>  
        <div class="col-lg-12 col-md-12 col-sm-12 ">
          <div class="form-group  pull-right">
             <?= $this->Form->button('Close Without Awarding',['name'=>'submit','class'=> 'customBtn blueBtn']) ?>
          </div>
        </div>
      <?= $this->Form->end() ?>

    </div>
  </div>
</div>
<!-- /#page-content-wrapper --> 

<style type="text/css">
  .listingContent {
  width: 87%;
}
.toppp {
  margin-left: 40px;
}
.contentListing.Contractor_listing > li {
  position: relative;
}
.search_radio {
  position: absolute;
  top: 59px;
}
.search_radio > input {
  left: 0 !important;
  position: absolute !important;
}
</style>