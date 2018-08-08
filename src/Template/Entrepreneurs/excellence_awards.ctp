<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Profile View', array('controller'=>'Contractors','action'=>'viewProfile',$viewUserId), array('escape'=>false));
                ?></li>
                <li class="active">Excellence Award</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Excellence Award</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
       
         <div class='row'>
          <div class='col-lg-11 col-md-12 col-sm-12 '>
          <div class="form-group">
                     
           <ul class="contentListing Contractor_listing"> 

                      <?php
                      $cu= count($excellenceAwards);
                      if(!empty($cu)){
                       foreach($excellenceAwards as $user){
                        $useImg = $this->Custom->contractorImage($user->given_by);
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
                           <h2 class="heading"><?php echo $user->user->first_name.' '.$user->user->last_name; ?>
                           <span class="smallText"><?php //echo $user->country->name;?></span></h2>
                           <h2 class="amount nav stars">
                           <?php 
                              $star= $user->rating_star;
                              for($i=0;$i<10;$i++){
                                if($i<$star){
                                  echo '<i class="fa fa-star"></i>';
                                }else{
                                  echo '<i class="fa fa-star-o"></i>';
                                }
                              }
                           ?>
                           </h2>
                         </div>
                         <p>
                         <?php 
             
                            echo $user->description;

                         ?> 
                         </p>
                        
                      </div>
                      </li> 
                  <?php } ?> 
                  <?php }?>
              </ul>
                  <nav class="pagingNav">
                              <ul class="pagination pagination-sm">
                                  <?php if(!empty($cu)){ ?>
                                    <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                                    <li><?= $this->Paginator->numbers() ?></li>
                                    <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                                  <?php } else {?>
                                    <li>No Excellence Award Found.</li>
                                 <?php } ?> 
                              </ul>
                  </nav>
        </div>
        </div>
        </div>
        <!-- /#page-content-wrapper --> 
      </div>
      <!-- page wraper end --> 

