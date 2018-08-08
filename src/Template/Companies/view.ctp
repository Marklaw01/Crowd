
<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Organization', array('controller'=>'Companies','action'=>'recommended'), array('escape'=>false));
                ?></li>
                <li class="active">View Organization</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1><?= h($companyDetails->company_name) ?></h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <form>
          <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-12 ">
              <div class="form-group">
              <label>Organization Name</label>
                <span class="form-control"><?= h($companyDetails->company_name) ?></span>
              </div>

              <div class="form-group">
              <label>Organization Keyword</label>
                <span id="selectedResult" class="form-control textArea">
                  <ul>
                  <?php
                    $skey2= explode(',', $companyDetails->job_posting_keywords);
                      $cskey2=count($skey2);
                        if(!empty($skey2[0])){
                          for($ij=0; $ij<$cskey2; $ij++){
                              $slids2=$skey2[$ij];
                                 //echo $Keywords[$slids].', '; id="selectedResult"
                                 echo '<li id="sel_'.$slids2.'"><a href="javascript:void(0)">'.$JobPostingKeywords[$slids2].'</a></li>';
                           }
                        }else {
                                 echo 'Organization Keywords';
                        }
                  ?>
                <?php //h($campaign->keywords) ?>
                </ul>
                </span>
               
              </div>

              <div class="form-group">
              <label>Overview</label>
                <span class="form-control textArea">
                <?= h($companyDetails->description) ?></span>
                
              </div>

              </div>
              <div class="col-lg-6 col-md-6 col-sm-12 ">
                  <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                                  
                                  <div class="panel panel-default">
                                      <div class="panel-heading" role="tab" id="headingOne">
                                        <h4 class="panel-title">
                                          <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                            Company Graphic
                                          </a>
                                        </h4>
                                      </div>
                                      <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                          <div class="image-Holder">
                                            <?php if(!empty($companyDetails->profile_image)){?>
                                              <img src="<?php echo $this->request->webroot.'img/subadmin_profile_image/'.$companyDetails->profile_image;?>" alt="Company Image">
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
                                            if(!empty($companyDetails->document)){
                                              echo '<li><a href="'.$this->request->webroot.'img/subadmin_docs/'.$companyDetails->document.'" target="_blank"> Document <i class="fa fa-eye"></i></a>';  
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
                                          if(!empty($companyDetails->audio)){
                                            echo '<li><a href="'.$this->request->webroot.'img/subadmin_audio/'.$companyDetails->audio.'" target="_blank"> Audio <i class="fa fa-eye"></i></a>';
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
                                            if(!empty($companyDetails->video)){
                                              
                                              echo '<li><a href="'.$this->request->webroot.'img/subadmin_video/'.$companyDetails->video.'" target="_blank"> Video <i class="fa fa-eye"></i></a>';
                                            }        
                                          ?>
                                     </ul>
                                    </div>
                                  </div>
                                </div>
                                    
                  </div> 
              </div>
          </div>
          <?= $this->Form->end() ?>
        </div>
        <!-- /#page-content-wrapper --> 

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
