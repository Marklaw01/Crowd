<?php 
     $dAmount='$00.00';
     $dLink='';
    if($userId != $campaign->user_id){

    // Edit link for 
         $campaignDnationC='';
         foreach ($campaign->campaign_donations as $campaignDonations){
         if($campaign->id == $campaignDonations->campaign_id && $userId == $campaignDonations->user_id){
           $dAmount = '$'.$this->Number->precision($campaignDonations->amount,2);
           $dAmount= money_format("$%i", $campaignDonations->amount);
           $dId = $campaignDonations->id;
           $campaignDnationC=1;
           $dLink = '('.$this->Html->link(__('Edit'), ['controller' => 'CampaignDonations', 'action' => 'edit', base64_encode($campaignDonations->id)]).')';
         }  
         } 
    }     
 ?>        
<div id="page-content-wrapper">
<div class="container-fluid">
        
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
            <h1 class="page-header"><i class="fa fa-bullhorn"></i>Campaign View
            </h1>
            </div>
            
          </div>
          <!-- header ends --> 
          <form>
          <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-12 ">
              <div class="form-group">
              <label>Campaign Name</label>
                <span class="form-control"><?= h($campaign->campaigns_name) ?></span>
              </div>
              <div class="form-group">
              <label>Startup Name</label>
                <span class="form-control"><?= $campaign->startup->name; ?> </span>
              </div>
              <div class="form-group">
              <label>Target Market</label>
                <span id="selectedResult" class="form-control textArea">
                  <ul>
                  <?php
                    $skey= explode(',', $campaign->keywords);
                      $cskey=count($skey);
                        if(!empty($skey[0])){
                          for($i=0; $i<$cskey; $i++){
                              $slids=$skey[$i];
                                 //echo $Keywords[$slids].', '; id="selectedResult"
                                 echo '<li id="sel_'.$slids.'"><a href="javascript:void(0)">'.$Keywords[$slids].'</a></li>';
                           }
                        }else {
                                 echo 'Target Market';
                        }
                  ?>
                <?php //h($campaign->keywords) ?>
                </ul>
                </span>
               
              </div>

              <div class="form-group">
              <label>Campaign Keyword</label>
                <span id="selectedResult" class="form-control textArea">
                  <ul>
                  <?php
                    $skey2= explode(',', $campaign->campaign_keywords);
                      $cskey2=count($skey2);
                        if(!empty($skey2[0])){
                          for($ij=0; $ij<$cskey2; $ij++){
                              $slids2=$skey2[$ij];
                                 //echo $Keywords[$slids].', '; id="selectedResult"
                                 echo '<li id="sel_'.$slids2.'"><a href="javascript:void(0)">'.$campKeywords[$slids2].'</a></li>';
                           }
                        }else {
                                 echo 'Target Market';
                        }
                  ?>
                <?php //h($campaign->keywords) ?>
                </ul>
                </span>
               
              </div>
              <div class="form-group">
              <label>Due Date</label>
                <span class="form-control"><?= h($campaign->due_date) ?></span>
                
              </div>
              <div class="form-group">
              <label>Target Amount</label>
                <span class="form-control">$<?= $this->Number->precision($campaign->target_amount,2); ?></span>
                
              </div>
              <div class="form-group">
              <label>Funds Raised So Far</label>
                <span class="form-control">
                <?php //$this->Number->precision($campaign->fund_raised_so_far,2) ?> 
                $<?php $DonatedAmount = $this->Custom->getCampaignTotalDonatedAmountByID($campaign->id);
                    echo $this->Number->precision($DonatedAmount,2);
                ?>
                </span>
               
              </div>
              <div class="form-group">
              <label>Summary</label>
                <span class="form-control textArea">
                <?= h($campaign->summary) ?></span>
                
              </div>
              <?php 
                    if($userId != $campaign->user_id){ ?>
              <div class="form-group">
                <span class="form-control">Your Donated Amount: <?php echo $dAmount; ?>    <?php echo $dLink; ?> </span>
               
              </div>
             <?php } ?> 
              </div>
              <div class="col-lg-6 col-md-6 col-sm-12 ">
                  <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                                    <div class="panel panel-default">
                                      <div class="panel-heading" role="tab" id="headingOne">
                                        <h4 class="panel-title">
                                          <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                            Campaign Graphic
                                          </a>
                                        </h4>
                                      </div>
                                      <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                          <div class="image-Holder">
                                            <?php if(!empty($campaign->campaign_image)){?>
                                              <img src="<?php echo $this->request->webroot.'img/campaign/'.$campaign->campaign_image;?>" alt="Campaign Image" width="480" height="400">
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
                                              $cDocs=json_decode($campaign->file_path);
                                                $cD = count($cDocs); 
                                                  for ($i=0; $i<$cD; $i++) {
                                                      $dType=$cDocs[$i]->file_type;
                                                      if($dType=='doc'){
                                                        
                                                        echo '<li><a href="'.$this->request->webroot.'img/campaign/'.$cDocs[$i]->name.'" target="_blank"> Document <i class="fa fa-eye"></i></a>';
                                                        //echo '<span class="campaign-errors" style="color:green;">'.$viewType.' - '.$cDocs[$i]->name.'</span> ';
                                                     } 
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
                                              $cDocs=json_decode($campaign->file_path);
                                                $cD = count($cDocs);
                                                   for ($i=0; $i<$cD; $i++) {
                                                        $dType=$cDocs[$i]->file_type;
                                                        if($dType=='mp3'){
                                                              
                                                          echo '<li><a href="'.$this->request->webroot.'img/campaign/'.$cDocs[$i]->name.'" target="_blank"> Audio <i class="fa fa-eye"></i></a>';
                                                          //echo '<span class="campaign-errors" style="color:green;">'.$viewType.' - '.$cDocs[$i]->name.'</span> ';
                                                       } 
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
                                              $cDocs=json_decode($campaign->file_path);
                                                $cD = count($cDocs);
                                                   for ($i=0; $i<$cD; $i++) {
                                                       $dType=$cDocs[$i]->file_type;
                                                        if($dType=='mp4'){
                                                              
                                                          echo '<li><a href="'.$this->request->webroot.'img/campaign/'.$cDocs[$i]->name.'" target="_blank"> Video <i class="fa fa-eye"></i></a>';
                                                          //echo '<span class="campaign-errors" style="color:green;">'.$viewType.' - '.$cDocs[$i]->name.'</span> ';
                                                        }  
                                                   } 
                                          ?>
                                     </ul>
                                    </div>
                                  </div>
                                </div>
                                 <div class="panel panel-default">
                                  <div class="panel-heading" role="tab" id="headingTwo">
                                    <h4 class="panel-title">
                                      <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseFive" aria-expanded="false" aria-controls="collapseFive">
                                        View Contractors
                                      </a>
                                    </h4>
                                  </div>
                                  <div id="collapseFive" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                    <div class="panel-body">
                                        <div class="table-responsive">
                                         <table class="table table-striped contractor_list">
                                            <thead>
                                              <tr>
                                                <th>Image</th>
                                                <th>Name</th>
                                                <th>Contribution</th>
                                                <th>Timeperiod</th>
                                              </tr>
                                              
                                            </thead>
                                            <tbody>
                                            <?php //pr($donContractors);
                                                foreach($donContractors as $donContractor){

                                                  //check donation amount public private
                                                  if($userId != $campaign->user_id){
                                                    if($donContractor->status == 0){
                                                     $DonAmount= '$'.$this->Number->precision($donContractor->amount,2);
                                                    }else {
                                                      $DonAmount='xxxx.xx';
                                                    }
                                                  }else {
                                                    $DonAmount= '$'.$this->Number->precision($donContractor->amount,2);
                                                  }  

                                                  //check user image is blank or not
                                                  $UserImage = $this->Custom->getUserImageByID($donContractor->user->id);
                                                  if(!empty($UserImage[0]['image'])){
                                                    $imagePath= $this->request->webroot.'img/profile_pic/'.$UserImage[0]['image'];
                                                  }else {
                                                    $imagePath= $this->request->webroot.'images/dummy-man.png';
                                                  }
                                              ?>    
                                                  <tr>
                                                      <td><div class="userImage circle-img-contractor"><img src="<?php echo $imagePath;?>"></div></td>
                                                      <td><?php echo $donContractor->user->first_name.' '.$donContractor->user->last_name;?></td>
                                                      <td><?php echo $DonAmount;?></td>
                                                      <td><?php echo $donContractor->donation_timeperiod->timeperiod.' '.$donContractor->donation_timeperiod->type;?>
                                                      <!--<td><a href="public_profile.html"><i class="fa fa-eye"></i></a></td>-->
                                                  </tr>

                                              <?php } ?>
                                            </tbody>
     
                                          </table>
                                         </div> 
                                    </div>
                                  </div>
                                </div>
                                    
                  </div> 
              </div>
              
          </div>
          <?= $this->Form->end() ?>
        </div>
        <!-- /#page-content-wrapper --> 
</div>
<?php 
//echo $this->Html->link(__('View Donating Contractors'), ['controller' => 'CampaignDonations','action' => 'donatingContractor',base64_encode($campaign->id)]) ;
?>










































    <div class="related" style="display:none;">
        <h4><?= __('Related Campaign Donations') ?></h4>
        <?php if (!empty($campaign->campaign_donations)): ?>
        <table cellpadding="0" cellspacing="0">
            <tr>
                <th><?= __('Id') ?></th>
                <th><?= __('User Id') ?></th>
                <th><?= __('Campaign Id') ?></th>
                <th><?= __('Amount') ?></th>
                <th><?= __('Time Period') ?></th>
                <th><?= __('Status') ?></th>
                <th><?= __('Created') ?></th>
                <th><?= __('Modified') ?></th>
                <th class="actions"><?= __('Actions') ?></th>
            </tr>
            <?php foreach ($campaign->campaign_donations as $campaignDonations): ?>
            <tr>
                <td><?= h($campaignDonations->id) ?></td>
                <td><?= h($campaignDonations->user_id) ?></td>
                <td><?= h($campaignDonations->campaign_id) ?></td>
                <td><?= h($campaignDonations->amount) ?></td>
                <td><?= h($campaignDonations->time_period) ?></td>
                <td><?= h($campaignDonations->status) ?></td>
                <td><?= h($campaignDonations->created) ?></td>
                <td><?= h($campaignDonations->modified) ?></td>
                <td class="actions">
                    <?= $this->Html->link(__('View'), ['controller' => 'CampaignDonations', 'action' => 'view', $campaignDonations->id]) ?>

                    <?= $this->Html->link(__('Edit'), ['controller' => 'CampaignDonations', 'action' => 'edit', $campaignDonations->id]) ?>

                    <?= $this->Form->postLink(__('Delete'), ['controller' => 'CampaignDonations', 'action' => 'delete', $campaignDonations->id], ['confirm' => __('Are you sure you want to delete # {0}?', $campaignDonations->id)]) ?>

                </td>
            </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
    </div>
    <div class="related" style="display:none;">
        <h4><?= __('Related Campaign Followers') ?></h4>
        <?php if (!empty($campaign->campaign_followers)): ?>
        <table cellpadding="0" cellspacing="0">
            <tr>
                <th><?= __('Id') ?></th>
                <th><?= __('Campaign Id') ?></th>
                <th><?= __('User Id') ?></th>
                <th><?= __('Created') ?></th>
                <th class="actions"><?= __('Actions') ?></th>
            </tr>
            <?php foreach ($campaign->campaign_followers as $campaignFollowers): ?>
            <tr>
                <td><?= h($campaignFollowers->id) ?></td>
                <td><?= h($campaignFollowers->campaign_id) ?></td>
                <td><?= h($campaignFollowers->user_id) ?></td>
                <td><?= h($campaignFollowers->created) ?></td>
                <td class="actions">
                    <?= $this->Html->link(__('View'), ['controller' => 'CampaignFollowers', 'action' => 'view', $campaignFollowers->id]) ?>

                    <?= $this->Html->link(__('Edit'), ['controller' => 'CampaignFollowers', 'action' => 'edit', $campaignFollowers->id]) ?>

                    <?= $this->Form->postLink(__('Delete'), ['controller' => 'CampaignFollowers', 'action' => 'delete', $campaignFollowers->id], ['confirm' => __('Are you sure you want to delete # {0}?', $campaignFollowers->id)]) ?>

                </td>
            </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
    </div>
    <div class="related" style="display:none;">
        <h4><?= __('Related Campaign Recommendations') ?></h4>
        <?php if (!empty($campaign->campaign_recommendations)): ?>
        <table cellpadding="0" cellspacing="0">
            <tr>
                <th><?= __('Id') ?></th>
                <th><?= __('Recommended By') ?></th>
                <th><?= __('Recommended To') ?></th>
                <th><?= __('Campaign Id') ?></th>
                <th><?= __('Status') ?></th>
                <th><?= __('Created') ?></th>
                <th><?= __('Target Amount') ?></th>
                <th class="actions"><?= __('Actions') ?></th>
            </tr>
            <?php foreach ($campaign->campaign_recommendations as $campaignRecommendations): ?>
            <tr>
                <td><?= h($campaignRecommendations->id) ?></td>
                <td><?= h($campaignRecommendations->recommended_by) ?></td>
                <td><?= h($campaignRecommendations->recommended_to) ?></td>
                <td><?= h($campaignRecommendations->campaign_id) ?></td>
                <td><?= h($campaignRecommendations->status) ?></td>
                <td><?= h($campaignRecommendations->created) ?></td>
                <td><?= h($campaignRecommendations->target_amount) ?></td>
                <td class="actions">
                    <?= $this->Html->link(__('View'), ['controller' => 'CampaignRecommendations', 'action' => 'view', $campaignRecommendations->id]) ?>

                    <?= $this->Html->link(__('Edit'), ['controller' => 'CampaignRecommendations', 'action' => 'edit', $campaignRecommendations->id]) ?>

                    <?= $this->Form->postLink(__('Delete'), ['controller' => 'CampaignRecommendations', 'action' => 'delete', $campaignRecommendations->id], ['confirm' => __('Are you sure you want to delete # {0}?', $campaignRecommendations->id)]) ?>

                </td>
            </tr>
            <?php endforeach; ?>
        </table>
    <?php endif; ?>
    </div>
</div>
