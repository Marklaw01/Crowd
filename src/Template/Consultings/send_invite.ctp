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
       <h1>Send Invite</h1> 
      </div>
    </div>
  </div>
  
  <div class="row">

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
  </div>    

  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
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
      <?= $this->Form->create('Close',['id'=>'FormField']) ?>
        <ul class="contentListing Contractor_listing"> 
          <?php
            if(!empty($ConsultingCommitmentsList)){
              foreach($ConsultingCommitmentsList as $user){
                $useImg = $this->Custom->contractorImage($user->id);

                if($ConsultingDetails->user_id !=$user->id){
                
          ?>
              <li>
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

                          <h2 class="heading"><?php echo $user->first_name.' '.$user->last_name; ?>
                          </span></h2>
                       </div>
                          <div class="links alignRight">
                             <?php 
                                  $sentStatus= $this->Custom->checkInvitationSent($ConsultingDetails->id,$loggedUserId,$user->id); 
                                    if(empty($sentStatus)){
                             ?>
                                
                                    <?php 
                                      $InviteLink= $this->Url->build(["controller" => "Consultings","action" => "invite",base64_encode($user->id),$ConslId]); 
                                    ?>
                                    <button class="smallCurveBtn blueBtn customBtn" type="button" onclick="location.href='<?php echo $InviteLink;?>'">Invite</button>
                                
                            <?php } else{ ?>

                                    <button class="smallCurveBtn greyBtnn customBtn" type="button">Invited</button>

                            <?php } ?>    
                          </div>
                    </div>
              </li> 
                <?php } ?>
            <?php } // foreach end ?> 
          <?php } //if end ?>
        </ul>
      <?= $this->Form->end() ?>
      <nav class="pagingNav">
        <ul class="pagination pagination-sm"> 
            <?php if(!empty($ConsultingCommitmentsList)){ ?>
              <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
              <li><?= $this->Paginator->numbers() ?></li>
              <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
            <?php } else {?>
              <li>No Contractors Available.</li>
           <?php } ?> 
        </ul>
      </nav>
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
.greyBtnn {
  border: 1px solid #ddd;
  color: #000;
  float: right;
  font-weight: 500 !important;
  margin-top: 30px;
  padding: 7px 30px;
  text-transform: capitalize;
}
.greyBtnn {
  background: #ddd none repeat scroll 0 0;
  box-shadow: 0 4px 0 transparent;
}
.greyBtnn:hover{
  color: #000;
}
</style>