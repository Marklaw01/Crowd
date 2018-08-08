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

                  <li role="presentation" class="">
                   <?php $recco= $this->Url->build(["controller" => "Campaigns","action" => "recommended"]); ?>
                  <a href="#recommended" aria-controls="Recommended" role="tab" data-toggle="tab" onclick="location.href='<?php echo $recco;?>'">Recommended</a></li>

                  <li role="presentation">
                  <?php $followi = $this->Url->build(["controller" => "Campaigns","action" => "following"]);?>
                  <a href="#following" aria-controls="Following" role="tab" data-toggle="tab" onclick="location.href='<?php echo $followi;?>'">Following</a></li>

                  <li role="presentation">
                  <?php $commit= $this->Url->build(["controller" => "campaignDonations","action" => "index"]);?>
                  <a href="#commitments" aria-controls="Commitments" role="tab" data-toggle="tab" onclick="location.href='<?php echo $commit;?>'">Commitments</a></li>

                  <li role="presentation" class="active">
                  <?php $mycamp= $this->Url->build(["controller" => "Campaigns","action" => "myCampaign"]);?>
                  <a href="#myCampaings" aria-controls="My Campaigns" role="tab" data-toggle="tab" onclick="location.href='<?php echo $mycamp;?>'">My Campaigns</a></li>

                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane whiteBg" id="recommended">   
                  </div>

                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="following">   
                  </div>
                   <!--  3Tab -->

                  <div role="tabpanel" class="tab-pane whiteBg" id="commitments">   
                  </div>

                   <!--  4Tab -->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="myCampaings">
                     <ul class="contentListing campaignListing"> 
                      
                        <?php $c=0; 
                        $countData= count($campaigns);
                        foreach ($campaigns as $campaign): $c++;?>
                              <li>
                               <div class="listingIcon"><i class="icon"><img src="<?php echo $this->request->webroot;?>images/campaign.png" alt=""></i></div>
                               <div class="listingContent">
                                 <div class="headingBar">
                                   <h2 class="heading">
                                   <?= h($campaign->campaigns_name) ?>
                                   <span>
                                   <?= $campaign->startup->name; ?>
                                   </span></h2>

                                   <h2 class="amount">
                                   Target Amount: $<?= $this->Number->precision($campaign->target_amount,2) ?> 
                                   <?php /// $this->Number->format(4521526.91873645, 2);?>
                                   <span>
                                   FUNDS RAISED SO FAR: 
                                   <?php //$this->Number->precision($campaign->fund_raised_so_far,2) ?>

                                   $<?php $DonatedAmount = $this->Custom->getCampaignTotalDonatedAmountByID($campaign->id);
                                      echo $this->Number->precision($DonatedAmount,2);
                                  ?>
                                   </span></h2>
                                 </div>
                                 <p>
                                 <?= h($campaign->summary) ?> 
                                 </p>
                                 <p class="date"> Due Date: <?= $campaign->due_date; ?></p>
                                 <div class="links alignRight">
                                  
                                  <?php 
                                      echo $this->Html->link('<i class="fa fa-eye"></i>View', array('action' => 'view', base64_encode($campaign->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                                  ?>
                                  <?php 
                                     echo $this->Html->link('<i class="fa fa-pencil"></i>Edit', array('action' => 'edit', base64_encode($campaign->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                                  ?>
                                  <?php 
                                     //echo $this->Html->link('<i class="fa fa-trash-o"></i> Delete', array('action' => 'delete', base64_encode($campaign->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn '));

                                     echo $this->Form->postLink('Delete',['action' => 'delete', base64_encode($campaign->id)],['id'=>'delPost'.$c,'class'=>'smallCurveBtn blueBtn customBtn ']);
                                  ?>
                                 </div>
                              </div>
                                <script type="text/javascript">
                                 $(document).ready(function () {
                                     $('#delPost<?php echo $c;?>').html('<i class="fa fa-trash-o"></i>Delete');
                                  });   
                                </script>
                              </li>  
                        <?php endforeach; ?>
                    </ul>
                    
                    <?php if(!empty($countData)){?>
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
                   <div class="col-lg-12 col-md-12 col-sm-12 ">
                      <div class="form-group">
                      <?= $this->Html->link(__('Add Campaign'), ['action' => 'add'],['class'=>'customBtn blueBtn  pull-right']) ?>
                      </div>
                   </div>
                   <div class="clearfix"></div>
                  </div>


                </div>
              </div>
            </div>
          </div>
        </div>
<!-- /#page-content-wrapper --> 
<?php //echo $this->Html->link(__('View'), ['action' => 'view', base64_encode($campaign->id)]); ?>
<?php //$this->Html->link(__('Edit'), ['action' => 'edit', base64_encode($campaign->id)]) ?>
<?php //$this->Form->postLink(__('Delete'), ['action' => 'delete', base64_encode($campaign->id)], ['confirm' => __('Are you sure you want to delete ? ')]) ?>
<?php //echo $this->Paginator->counter() ?>
<script type="text/javascript">
 $(document).ready(function () {
    $('#delPost').html('<i class="fa fa-trash-o"></i> Delete');
 });
</script>