
<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li><?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li><?php
            echo $this->Html->link('Opportunities', array('controller'=>'Opportunities','action'=>'index'), array('escape'=>false));
        ?></li>
        <li><?php
            echo $this->Html->link('My Jobs', array('controller'=>'Opportunities','action'=>'recuiter'), array('escape'=>false));
        ?></li>
        <li class="active">View Job</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
     <div class="page_heading">
       <h1><?= h($JobsDetails->job_title) ?></h1> 
      </div>
    </div>
    
  </div>
  <!-- header ends --> 
  <div class="row">
    <div class="col-lg-6 col-md-6 col-sm-12 ">
      
        <div class="form-group">
          <label>Job Title</label>
          <span class="form-control"><?php echo $JobsDetails->job_title;?></span>
        </div>

        <div class="form-group">
          <label>Company Name</label>
          <span class="form-control"><?php echo $JobsDetails->sub_admin_detail->company_name; ?> </span>
        </div>

        <div class="form-group">
          <label>Industry</label>
          <span id="selectedResult" class="form-control textArea">
            <ul>
              <?php
                $skey5= explode(',', $JobsDetails->industry_id);
                  $cskey5=count($skey5);
                    if(!empty($skey5[0])){
                      for($i=0; $i<$cskey5; $i++){
                          $slids5=$skey5[$i];
                             //echo $Keywords[$slids].', '; id="selectedResult"
                             echo '<li id="sel_'.$slids5.'"><a href="javascript:void(0)">'.$jobindustry[$slids5].'</a></li>';
                       }
                    }else {
                             echo 'Industry';
                    }
              ?>
            </ul>
          </span>
        </div>

        <div class="form-group">
          <label>Role</label>
          <span class="form-control"><?php echo $JobsDetails->role; ?> </span>
        </div>

        <div class="form-group">
          <label>Job Type</label>
          <span class="form-control"><?php if(!empty($JobsDetails->job_type)){ echo $JobsDetails->job_type->name;} ?> </span>
        </div>

        <div class="form-group">
          <label>Minimum Work NPS</label>
          <span class="form-control"><?php echo $JobsDetails->min_work_nps; ?> </span>
        </div>

        <div class="form-group">
          <label>Country</label>
          <span class="form-control"><?php if(!empty($JobsDetails->country_id)){ echo $JobsDetails->country->name;} ?> </span>
        </div>

        <div class="form-group">
          <label>State</label>
          <span class="form-control"><?php if(!empty($JobsDetails->state_id)){ echo $JobsDetails->state->name;} ?> </span>
        </div>

        <div class="form-group">
          <label>Location</label>
          <span class="form-control"><?php echo $JobsDetails->location; ?> </span>
        </div>

        <div class="form-group">
          <label>Travel</label>
          <span class="form-control"><?php echo $JobsDetails->travel; ?> </span>
        </div>

        <div class="form-group">
          <label>Description</label>
          <span class="form-control textArea"><?php echo $JobsDetails->description; ?> </span>
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
                    <?php if(!empty($JobsDetails->sub_admin_detail->profile_image)){?>
                      <img src="<?php echo $this->request->webroot.'img/subadmin_profile_image/'.$JobsDetails->sub_admin_detail->profile_image;?>" alt="Campaign Image">
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
                      if(!empty($JobsDetails->document)){
                          
                        echo '<li><a href="'.$this->request->webroot.'img/jobs/'.$JobsDetails->document.'" target="_blank"> Document <i class="fa fa-eye"></i></a>';

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

                        if(!empty($JobsDetails->audio)){    
                          echo '<li><a href="'.$this->request->webroot.'img/jobs/'.$JobsDetails->audio.'" target="_blank"> Audio <i class="fa fa-eye"></i></a>';
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
                          if(!empty($JobsDetails->video)){  
                                          
                            echo '<li><a href="'.$this->request->webroot.'img/jobs/'.$JobsDetails->video.'" target="_blank"> Video <i class="fa fa-eye"></i></a>';

                          }  
                      ?>
                 </ul>
                </div>
              </div>
            </div>

            <div class="form-group">
              <label>Start Date</label>
              <span class="form-control"><?php echo $JobsDetails->start_date; ?> </span>
            </div>

            <div class="form-group">
              <label>End Date</label>
              <span class="form-control"><?php echo $JobsDetails->end_date; ?> </span>
            </div>

            <div class="form-group">
              <label>Requirements</label>
              <span class="form-control"><?php echo $JobsDetails->requirements; ?> </span>
            </div>

            <div class="form-group">
              <label>Skills</label>
              <span id="selectedResult" class="form-control textArea">
                <ul>
                  <?php
                    $skey= explode(',', $JobsDetails->skills);
                      $cskey=count($skey);
                        if(!empty($skey[0])){
                          for($i=0; $i<$cskey; $i++){
                              $slids=$skey[$i];
                                 //echo $Keywords[$slids].', '; id="selectedResult"
                                 echo '<li id="sel_'.$slids.'"><a href="javascript:void(0)">'.$Skills[$slids].'</a></li>';
                           }
                        }else {
                                 echo 'Skills';
                        }
                  ?>
                </ul>
              </span>
            </div>

            <div class="form-group">
              <label>Job Posting Keywords</label>
              <span id="selectedResult" class="form-control textArea">
                <ul>
                  <?php
                    $skey= explode(',', $JobsDetails->posting_keywords);
                      $cskey=count($skey);
                        if(!empty($skey[0])){
                          for($i=0; $i<$cskey; $i++){
                              $slids=$skey[$i];
                                 //echo $Keywords[$slids].', '; id="selectedResult"
                                 echo '<li id="sel_'.$slids.'"><a href="javascript:void(0)">'.$jobpostingkeyword[$slids].'</a></li>';
                           }
                        }else {
                                 echo 'Job Posting Keywords';
                        }
                  ?>
                </ul>
              </span>
            </div>

        </div> 
    </div>
  </div>
</div>
