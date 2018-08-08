<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li>
                <?php
                    echo $this->Html->link('Home', array('controller'=>'SubAdmins','action'=>'dashboard'), array('escape'=>false));
                ?>
                </li> 
                <li class="active">Job Applications</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Job Applications</h1> 
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
                      if(!empty($jobapplications)){
                       foreach($jobapplications as $jobapplication){
                       $useImg = $this->Custom->contractorImage($jobapplication->contractor_id);
                     ?>
                      
                    <!-- [contractor_id] => 111
                     [contractor_first_name] => Julia
                     [contractor_last_name] => Roberts
                     [contractor_image] => 1470218577_183186.jpg
                     [contractor_bio] => This is my Bio
                     [job_id] => 1
                     [id] => 1-->
                    
                      <li>
                       <div class="listingIcon">
                          <div class="circle-img-sidebar">
                          <?php if(isset($jobapplication->contractor_image)
                                   &&($jobapplication->contractor_image!='')
                                   &&(file_exists($useImg))){
                          ?>
                            <img src="<?php echo $this->request->webroot.$useImg; ?>">
                          <?php } else {?>
                          <img src="<?php echo $this->request->webroot?>images/dummy-man.png">
                          <?php } ?>  
                          </div>
                       </div>
                       <div class="listingContent">
                         <div class="headingBar">
                           <h2 class="heading"><?php echo $jobapplication->contractor_first_name.' '.$jobapplication->contractor_last_name; ?>
                            </h2>
                         </div>
                         <p>
                          <?php echo $jobapplication->contractor_bio; ?>
                         </p> 
                        <div class="links alignRight">
                            <?php
                              echo $this->Html->link('<i class="fa fa-eye"></i>Reject','#', array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                            ?>
                         </div>
                        <div class="links alignRight">
                            <?php
                              echo $this->Html->link('<i class="fa fa-eye"></i>Interview','#', array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                            ?>
                         </div>
                        <div class="links alignRight">
                            <?php
                              echo $this->Html->link('<i class="fa fa-eye"></i>Hold','#', array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                            ?>
                         </div>
                        <div class="links alignRight">
                            <?php
                              echo $this->Html->link('<i class="fa fa-eye"></i>Hire','#', array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                            ?>
                         </div>
                      </div>
                      </li> 
                  <?php } ?> 
                  <?php }?>
              </ul>
                  <nav class="pagingNav">
                    <ul class="pagination pagination-sm">
                        <?php if(!empty($jobapplications)){ ?>
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

