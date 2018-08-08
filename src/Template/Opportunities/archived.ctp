<!-- /#page-content-wrapper --> 
<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li> <?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li> <?php
            echo $this->Html->link('Opportunities', array('controller'=>'Opportunities','action'=>'index'), array('escape'=>false));
        ?></li>
        <li class="active">Recruiter</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
     <div class="page_heading">
       <h1>Archived Jobs</h1> 
      </div>
    </div>
    
  </div>
  <!-- header ends --> 
 <div class="row">
    <div class="col-lg-12 col-md-12 col-sm-12">
      <div role="tabpanel" class="campaigns-section">
        <!-- Nav tabs -->
        <ul id="tabbing" class="nav nav-tabs recuiterTab" role="tablist">

          <li role="presentation" class="">
            <?php $myjob= $this->Url->build(["controller" => "Opportunities","action" => "recuiter"]);?>
            <a href="#recuiter" aria-controls="My Jobs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $myjob;?>'">My Jobs</a>
          </li>

          <li role="presentation" class="active">
            <?php $archiv= $this->Url->build(["controller" => "Opportunities","action" => "archived"]); ?>
            <a href="#archived" aria-controls="Archived" role="tab" data-toggle="tab" onclick="location.href='<?php echo $archiv;?>'">Archived</a>
          </li>

          <li role="presentation" class="">
            <?php $deactivate= $this->Url->build(["controller" => "Opportunities","action" => "deactivated"]);?>
            <a href="#deactivated" aria-controls="Deactivated" role="tab" data-toggle="tab" onclick="location.href='<?php echo $deactivate;?>'">Deactivated</a>
          </li>


        </ul>
        <!-- Tab panes -->
        <div class="tab-content">

          <!-- 1Tab-->
          <div role="tabpanel" class="tab-pane active whiteBg" id="recuiter">

            <form action="" id="FormField" accept-charset="utf-8" method="get"> 

                <div class="col-md-3 col-sm-3 col-xs-12">
                  <div class="form-group">
                     <?php
                        echo $this->Form->input('country', ARRAY('label' => false, 'div' => false, 'class' => ' selectpicker1 form-control show-tick1', 'id' => 'country','type'=>'select','empty'=>'Select Country','value'=>'231', 'options'=>$countrylist));
                     ?>
                  </div>   
                </div>

                <div class="col-md-3 col-sm-3 col-xs-12">
                  <div class="form-group">
                    <?php
                      echo $this->Form->input('state', ARRAY('label' => false, 'div' => false, 'class' => ' selectpicker1 form-control show-tick1', 'id' => 'state','type'=>'select','empty'=>'Select State'));
                    ?>
                  </div>  
                </div>

                <div class="col-lg-4 col-md-6 col-sm-12 ">
                  <div class="form-group">
                    <input type="search" class="form-control" name="search" placeholder="Search">
                  </div>  
                </div>
                <div class="col-lg-2 col-md-6 col-sm-12 no_paddingleftcol ">
                  <div class="form-group">
                    <button type="submit" class="searchBtn">Search</button>
                  </div>  
                </div>
            </form>                      
 

            <div class="col-lg-12 col-md-12 col-sm-12 ">
              <div class="form-group">
                  <ul class="contentListing campaignListing"> 
                  
                    <?php $c=0; 
                    $countData= count($myJobs);
                    foreach ($myJobs as $myJob): $c++;?>
                          <li>
                           <div class="listingIcon"><i class="icon"><img src="<?php echo $this->request->webroot;?>images/campaign.png" alt=""></i></div>
                           <div class="listingContent">
                             <div class="headingBar">
                               <h2 class="heading">
                                 <?= h($myJob->job_title) ?>
                                 <span>
                                  <?php if(!empty($myJob->sub_admin_detail)){echo $myJob->sub_admin_detail->company_name.',';} ?>
                                  <?php if(!empty($myJob->country)){echo $myJob->country->name.',';} ?>
                                  <?php if(!empty($myJob->state)){echo $myJob->state->name.',';} ?>
                                  <?php if(!empty($myJob->location)){echo $myJob->location;} ?>
                                 </span>
                               </h2>

                               <h2 class="amount">
                               Position: <?php echo $myJob->role?>
                               <span>
                                <?php 
                                  if(!empty($myJob->job_followers)){ 

                                     echo count($myJob->job_followers);

                                     echo $this->Html->link(' Following', array('controller'=>'Opportunities','action'=>'jobFollowerLists',base64_encode($myJob->id)), array('escape'=>false,'target'=>'_blank'));

                                  }else{ 

                                      echo '0 Following';

                                  }
                                ?>

                               </span></h2>
                             </div>
                             <p>
                             <?php echo substr($myJob->description,0,340).'...'; ?> 
                             </p>
                             <p class="date"> Posted On: <?= $myJob->start_date; ?></p>
                             <div class="links alignRight">
                              
                              <?php 
                                  echo $this->Html->link('<i class="fa fa-eye"></i>', array('action' => 'viewJob', base64_encode($myJob->id)), array('escape'=>false,'class'=>'smallCurveBtnJobs blueBtn customBtn','title'=>'View'));
                              ?>
                              <?php 
                                 //echo $this->Html->link('<i class="fa fa-pencil"></i>', array('action' => 'editJob', base64_encode($myJob->id)), array('escape'=>false,'class'=>'smallCurveBtnJobs blueBtn customBtn','title'=>'Edit'));
                              ?>
                              <?php 
                                 //echo $this->Form->postLink('Archive',['action' => 'archiveJob', base64_encode($myJob->id)],['id'=>'archPost'.$c,'class'=>'smallCurveBtnJobs blueBtn customBtn ','title'=>'Archive']);
                              ?>
                              <?php 
                                 echo $this->Form->postLink('Diactivate',['action' => 'deactivateJob', base64_encode($myJob->id)],['id'=>'deactPost'.$c,'class'=>'smallCurveBtnJobs orangeBtn customBtn ','title'=>'Deactivate']);
                              ?>
                              <?php 
                                 echo $this->Form->postLink('Delete',['action' => 'deleteJob', base64_encode($myJob->id)],['id'=>'delPost'.$c,'class'=>'smallCurveBtnJobs redBtn customBtn ','title'=>'Delete']);
                              ?>
                             </div>
                          </div>
                            <script type="text/javascript">
                             $(document).ready(function () {
                                 $('#delPost<?php echo $c;?>').html('<i class="fa fa-trash-o"></i>');
                                 //$('#archPost<?php echo $c;?>').html('<i class="fa fa-archive"></i>');
                                 $('#deactPost<?php echo $c;?>').html('<i class="fa fa-close"></i>');
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
                        <li>No Jobs Available.</li>
                      </ul>
                     </nav>  
                  <?php } ?>
              </div>
            </div>  

            <div class="col-lg-12 col-md-12 col-sm-12 ">
              <div class="form-group">
                  <?= $this->Html->link(__('Add Job'), ['action' => 'addJobs'],['class'=>'customBtn blueBtn  pull-right']) ?>
              </div>
            </div>

            <div class="clearfix"></div>
          </div>

          <!-- 2Tab-->
          <div role="tabpanel" class="tab-pane whiteBg" id="archived">   
          </div>

           <!--  3Tab -->
          <div role="tabpanel" class="tab-pane whiteBg" id="deactivated">   
          </div>



        </div>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
 $(document).ready(function () {
    $('#delPost').html('<i class="fa fa-trash-o"></i> Delete');
 });

// Ajax for states list
$(function(){
    $('#country').change(function(){
    var val = $(this).val();
    $.ajax({ 
    url: "<?php echo $this->Url->build(["Controller" => "Users","action" => "getOptionsList"]);?>",
    data: {countryId:val},
        type : 'POST',
        cache: false,
    success: function(data) {
    $("#state").html(data);
    }
       });

   });
});

// Ajax for states list on page load
$(document).ready(function(){
  var val = $('#country').val(); //alert(val);
  $.ajax({ 
      url: "<?php echo $this->Url->build(["Controller" => "Users","action" => "getOptionsList"]);?>",
      data: {countryId:val},
          type : 'POST',
          cache: false,
      success: function(data) {
      $("#state").html(data);
             <?php if(!empty($state)){
                echo '$("#state").val("'.$state.'");';
             }?>
      }
  });

  $('ggagag').insertBefore('#custom_terms');

});
</script>        
 
 
     