<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Beta Testers', array('controller'=>'BetaTesters','action'=>'myBetaTest'), array('escape'=>false));
                ?></li>
                <li class="active">Search Recommended Beta Testers</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Search Recommended Beta Testers</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
       
         <div class='row'>
          <div class='col-lg-11 col-md-12 col-sm-12 '>
          <div class="form-group">
                      <div class="row">
                        <?= $this->Form->create('Search',['id'=>'FormField','type'=>'get']) ?>
                            <div class="col-lg-9 col-md-9 col-sm-12 ">
                            <input type="search" placeholder="Search by Contractor name or keywords" name="search" class="form-control">
                            </div>
                            <div class="col-lg-3 col-md-3 col-sm-12 no_paddingleftcol ">
                            <button class="searchBtn" type="submit">Search</button>
                            </div>
                        <?= $this->Form->end() ?>
                      </div>
                    </div>
           <ul class="contentListing Contractor_listing"> 

                      <?php
                      if(!empty($users)){
                       foreach($users as $user){
                        $useImg = $this->Custom->contractorImage($user->user->id);
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
                              if(!empty($user->user)){ echo $user->user->first_name.' '.$user->user->last_name; }
                            ?>

                            </h2>

                         </div>
                         <p>
                         <?php 
                          if(!empty($user->user->contractor_basic)){

                              if(!empty($user->user->contractor_basic->bio)){
                                 echo $user->user->contractor_basic->bio;
                              }
                          }
                         ?>
                         </p>
                        <div class="links alignRight">
                            <?php 
                              echo $this->Html->link('<i class="fa fa-eye"></i>View', array('controller'=>'contractors', 'action' => 'viewProfile', base64_encode($user->user->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                            ?>
                         </div>
                      </div>
                      </li> 
                  <?php } ?> 
                  <?php }?>
              </ul>
                  <nav class="pagingNav">
                              <ul class="pagination pagination-sm">
                                  <?php if(!empty($users)){ ?>
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
      </div>
      <!-- page wraper end --> 

