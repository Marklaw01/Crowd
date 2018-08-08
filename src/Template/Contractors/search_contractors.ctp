<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Contractors', array('controller'=>'Contractors','action'=>'searchContractors'), array('escape'=>false));
                ?></li>
                <li class="active">Search Contractors</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Search Contractors</h1> 
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
                           $
                           <?php 
                            if(!empty($user->contractor_basic)){
                              echo $this->Number->precision($user->contractor_basic->price,2);
                            }
                           ?>
                           /hr</h2>
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
                                                    if($vi<$cc-1){ echo ', ';}
                                              }
                                          }
                             }              
                        ?> 
                         </p>
                        <div class="links alignRight">
                            <?php 
                              echo $this->Html->link('<i class="fa fa-eye"></i>View', array('controller'=>'contractors', 'action' => 'viewProfile', base64_encode($user->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
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

