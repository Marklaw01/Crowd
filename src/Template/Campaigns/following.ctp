<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li class="active"><?php
                    echo $this->Html->link('Startups', array('controller'=>'Entrepreneurs','action'=>'listStartup'), array('escape'=>false));
                ?></li>
                <li class="active">Campaigns</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Campaigns</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs campaignsTab" role="tablist">

                  <li role="presentation" >
                   <?php $recco= $this->Url->build(["controller" => "Campaigns","action" => "recommended"]); ?>
                  <a href="#recommended" aria-controls="Recommended" role="tab" data-toggle="tab" onclick="location.href='<?php echo $recco;?>'">Recommended</a></li>

                  <li role="presentation" class="active">
                  <?php $followi = $this->Url->build(["controller" => "Campaigns","action" => "following"]);?>
                  <a href="#following" aria-controls="Following" role="tab" data-toggle="tab" onclick="location.href='<?php echo $followi;?>'">Following</a></li>

                  <li role="presentation">
                  <?php $commit= $this->Url->build(["controller" => "campaignDonations","action" => "index"]);?>
                  <a href="#commitments" aria-controls="Commitments" role="tab" data-toggle="tab" onclick="location.href='<?php echo $commit;?>'">Commitments</a></li>

                  <li role="presentation">
                  <?php $mycamp= $this->Url->build(["controller" => "Campaigns","action" => "myCampaign"]);?>
                  <a href="#myCampaings" aria-controls="My Campaigns" role="tab" data-toggle="tab" onclick="location.href='<?php echo $mycamp;?>'">My Campaigns</a></li>

                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane  whiteBg" id="recommended"> 
                  </div>

                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="following">
                    <ul class="contentListing campaignListing"> 

                      <?php $c=0; 
                      $countData= count($campaigns);
                      foreach ($campaigns as $campaign): $c++;?>

                      <li>
                       <div class="listingIcon"><i class="icon"><img src="<?php echo $this->request->webroot;?>images/campaign.png" alt=""></i></div>
                       <div class="listingContent">
                         <div class="headingBar">
                           <h2 class="heading"><?php echo $campaign->campaign->campaigns_name; ?>
                           <span>
                              <?php 
                                $startup_id = $campaign->campaign->startup_id;
                                $startups = $this->Custom->getStartupsDetailByID($startup_id);
                                    echo $startups[0]->name;
                              ?>
                           </span></h2>
                           <h2 class="amount">Target Amount: $<?php echo $this->Number->precision($campaign->campaign->target_amount,2); ?> 
                           <span>
                           FUNDS RAISED SO FAR: 
                           <?php //echo $this->Number->precision($campaign->campaign->fund_raised_so_far,2); ?>
                           $<?php $DonatedAmount = $this->Custom->getCampaignTotalDonatedAmountByID($campaign->campaign->id);
                               echo $this->Number->precision($DonatedAmount,2);
                            ?>
                           </span></h2>
                         </div>
                         <p><?= h($campaign->campaign->summary) ?> </p>
                         <p class="date"> Due Date: <?= $campaign->campaign->due_date; ?></p>
                         <div class="links alignRight">
                              <?php 
                                  echo $this->Html->link('<i class="fa fa-eye"></i> View', array('action' => 'view', base64_encode($campaign->campaign->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                              ?>   
                         </div>
                      </div>
                      </li> 
                    <?php endforeach; ?>

                    </ul>
                    <?php if(!empty($countData)){ ?>
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
                          <li>No Campaigns Available.</li>
                        </ul>
                       </nav>  
                    <?php } ?>
                  </div>
                   <!--  3Tab -->

                  <div role="tabpanel" class="tab-pane whiteBg" id="commitments"> 
                  </div>

                   <!--  4Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="myCampaings">                     
                  </div>


                </div>
              </div>
            </div>
          </div>
</div>
<!-- /#page-content-wrapper --> 
