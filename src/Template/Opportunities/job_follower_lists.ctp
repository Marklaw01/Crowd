<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Opportunities', array('controller'=>'Opportunities','action'=>'recuiter'), array('escape'=>false));
                ?></li>
                <li class="active">Job Followers List</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1><?php echo $JobFollowers->job_title; ?> - Job Followers List</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
       
         <div class='row'>
          <div class='col-lg-11 col-md-12 col-sm-12 '>
          <!-- <div class="form-group">
                      <div class="row">
                        <?php //echo $this->Form->create('Search',['id'=>'FormField','type'=>'get']); ?>
                            <div class="col-lg-9 col-md-9 col-sm-12 ">
                            <input type="search" placeholder="Search by Contractor name or keywords" name="search" class="form-control">
                            </div>
                            <div class="col-lg-3 col-md-3 col-sm-12 no_paddingleftcol ">
                            <button class="searchBtn" type="submit">Search</button>
                            </div>
                        <?php //echo $this->Form->end(); ?>
                      </div>
                    </div> -->
           <ul class="contentListing Contractor_listing"> 

                      <?php
                      if(!empty($JobFollowers)){
                        foreach($JobFollowers->job_followers as $JobFollower){

                          $useImg = $this->Custom->contractorImage($JobFollower->user_id);
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
                               <h2 class="heading"><?php echo $JobFollower->user->first_name.' '.$JobFollower->user->last_name; ?>
                               <span class="smallText"><?php //if(!empty($JobFollower->user->country)) { echo $JobFollower->user->country->name;}?></span></h2>
                               <h2 class="amount">
                               $
                               <?php 
                                if(!empty($JobFollower->user->contractor_basic)){
                                  echo $this->Number->precision($JobFollower->user->contractor_basic->price,2);
                                }
                               ?>
                               /hr</h2>
                              </div>
                              <p>
                              <?php 
                              if(!empty($JobFollower->user->contractor_basic)){
                                echo $JobFollower->user->contractor_basic->bio;
                              }
                              ?>
                              </p>
                              <p>
                              <?php 
                              $keyws = $this->Custom->getUserKeywords($JobFollower->user->id);
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
                                    echo $this->Html->link('<i class="fa fa-eye"></i>View', array('controller'=>'contractors', 'action' => 'viewProfile', base64_encode($JobFollower->user->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                                  ?>
                               </div>
                          </div>
                          </li> 
                  <?php } ?> 
                  <?php } else { 'No Followers found.';}?>
              </ul>
        </div>
        </div>
        </div>
        <!-- /#page-content-wrapper --> 
      </div>
      <!-- page wraper end --> 

