
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
                <li> <?php
                    echo $this->Html->link('Networking options', array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false));
                ?></li>
                <li class="active">Search Contact</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Search</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">

              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs networkingTab" role="tablist">

                  <?php
                	$currStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "contacts"]);
                  ?>
                  <li role="presentation" class="active"><a href="#current" aria-controls="current" role="tab" data-toggle="tab" onclick="location.href='<?php echo $currStr;?>'">Search Connection</a></li>

                  <?php
                	$compStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "addContacts"]);
                  ?>
                  <li role="presentation" ><a href="#completed" aria-controls="completed" role="tab" data-toggle="tab" onclick="location.href='<?php echo $compStr;?>'">Add New Contacts</a></li>

                  <?php
                  $searStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "newUsers"]);
                 ?>
                  <li role="presentation"><a href="#search" aria-controls="search" role="tab" data-toggle="tab" onclick="location.href='<?php echo $searStr;?>'">Contacts</a></li> 

                </ul>

                <div class="form-group">
                  <div class="row new_search">
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
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="myStartups">
                     <div class="table-responsive">
                         <ul class="contentListing Contractor_listing"> 

                          <?php
                          if(!empty($users)){
                           foreach($users as $user){
                            $useImg = $this->Custom->contractorImage($user->id);
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
                               <h2 class="heading">
                                <?php 
                                if(!empty($user->contractor_basic)){
                                  echo $user->contractor_basic->first_name.' '.$user->contractor_basic->last_name;
                                }else{
                                  echo $user->first_name.' '.$user->last_name; 
                                }

                                ?>
                               <span class="smallText"><?php if(!empty($user->country)) { echo $user->country->name;}?></span></h2>
                               <h2 class="amount">
                                <?php 
                                $data = $this->Custom->businessNetwork($user->id,$looginUserId);
                                
                                if(!empty($data)){
                                  echo "Connected";
                                  
                                }else {
                                  echo "Not Connected";
                                }
                               ?>
                               </h2>
                             </div>
                             <p>
                             <?php 
                             if(!empty($user->contractor_basic)){
                                //echo $user->contractor_basic->bio;
                             }
                             ?>
                             <?php 
                             $keyws = $this->Custom->getUserKeywords($user->id);
                                if(!empty($keyws)){
                                        $skey= explode(',', $keyws);
                                        $cc =count($skey);
                                            if(!empty($skey[0])){
                                                  for($vi=0; $vi<$cc; $vi++){
                                                        $slids=$skey[$vi];
                                                        //echo $slids;
                                                        //echo $Keywords[$slids]; selectedResult
                                                        echo $Keywords[$slids];
                                                        if($vi<$cc-1 && !empty($Keywords[$slids])){ echo ', ';}
                                                  }
                                              }
                                 }              
                            ?> 
                             </p>
                              <div class="links alignRight">
                                  <?php 
                                  $data = $this->Custom->businessCardData($user->id);
                                  if(!empty($data)){ 
                                    echo $this->Html->link('<i class="fa fa-eye"></i>Business Card', array('controller'=>'NetworkingOptions', 'action' => 'businessCardDetail', base64_encode($data[0 ]['id'])/*,base64_encode($data['connection_type_id'])*/), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                                  }else{
                                     echo 'No business card found.';
                                  }
                                  ?>
                                </div>
                            </div>
                          </li> 
                        <?php } ?> 
                        <?php }?>
                        </ul>
                      </div> 

	                    <nav>
	                      <ul class="pagination pagination-sm">
                                  <?php if(!empty($users)){ ?>
                                    <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                                    <li><?= $this->Paginator->numbers() ?></li>
                                    <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                                  <?php } else {?>
                                    <li>No Contact Available.</li>
                                 <?php } ?> 
                              </ul>
	                    </nav>
 
                  </div>

                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="completed">    
                  </div>

                   <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="search">
                  </div>

                   <!--  4Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="current">
                   <div class="clearfix"></div>
                  </div>

                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /#page-content-wrapper --> 
<style type="text/css">
  .alignRight .smallCurveBtn {
    padding: 8px 15px !important;
    min-width: 100px !important;
    border-radius: 50px;
}
</style>