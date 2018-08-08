
<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Startups', array('controller'=>'Startups','action'=>'currentStartup'), array('escape'=>false));
                ?></li>
                <li class="active">Search Startups</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Search Startups</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs campaignsTab" role="tablist">

                  <?php
                	$currStr= $this->Url->build(["controller" => "Startups","action" => "currentStartup"]);
                  ?>
                  <li role="presentation"><a href="#current" aria-controls="current" role="tab" data-toggle="tab" onclick="location.href='<?php echo $currStr;?>'">Current</a></li>

                  <?php
                	$compStr= $this->Url->build(["controller" => "Startups","action" => "completedStartup"]);
                  ?>
                  <li role="presentation"><a href="#completed" aria-controls="completed" role="tab" data-toggle="tab" onclick="location.href='<?php echo $compStr;?>'">Completed</a></li>

                  <?php
                	$searStr= $this->Url->build(["controller" => "Startups","action" => "searchStartup"]);
                  ?>
                  <li role="presentation"  class="active"><a href="#search" aria-controls="search" role="tab" data-toggle="tab" onclick="location.href='<?php echo $searStr;?>'">Search</a></li>

                  <?php
                	$MyStrt= $this->Url->build(["controller" => "Startups","action" => "myStartup"]);
                  ?>
                  <li role="presentation"><a href="#myStartups" aria-controls="My Startups" role="tab" data-toggle="tab" onclick="location.href='<?php echo $MyStrt;?>'">My Startups</a></li>

                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="search">
                     <div class="form-group">
                      <div class="row">
                        <?= $this->Form->create('Search',['id'=>'FormField','type'=>'get']) ?>
                            <div class="col-lg-9 col-md-9 col-sm-12 ">
                            <input type="search" placeholder="Search" name="search" class="form-control">
                            </div>
                            <div class="col-lg-3 col-md-3 col-sm-12 no_paddingleftcol ">
                            <button class="searchBtn" type="submit">Search</button>
                            </div>
                        <?= $this->Form->end() ?>
                      </div>
                     </div>


                     <div class="table-responsive">
                         <table class="table table-striped startup-list">
                            <thead>
                              <tr>
                                <th width="33.3%">Startup Name</th>
                                <th width="33.3%">Enterpreneur Name</th>
                                <th width="33.3%">Step</th>
                              </tr>
                                              
                            </thead>
                            <tbody>
	                            <?php if(!empty($startup_detail)){?>
	                            	<?php foreach($startup_detail AS $startup){ ?>
			                              <tr>

			                                <td>
			                                	
                                      <?php 
                                      $id = base64_encode($startup['user_id']);
                                      $startId= base64_encode($startup['id']);
                                      echo $this->Html->link($startup['name'],['controller'=>'Startups','action'=>'viewStartup',$startId],['escape'=>false,'title'=>'Click Here View']);
                                      ?>
			                                </td>

			                                <td>
			                                	<?php if(!empty($startup['user']['entrepreneur_basic']['first_name'])){
												
												                  echo $startup['user']['entrepreneur_basic']['first_name'].' '.$startup['user']['entrepreneur_basic']['last_name'];
												 
												                }else{

												                  echo $startup['user']['first_name'].' '.$startup['user']['last_name'];
												                } ?>
			                                </td>
			                                
			                                <td>
				                                
                                        <?php 
                                        $startId= base64_encode($startup['id']);
                                        echo $this->Html->link('Next Step',['controller'=>'Startups','action'=>'viewStartup',$startId],['class'=>'fa fa-angle-double-right']);
                                        ?>
			                                </td>
			                                
			                              </tr>
	                                <?php }?>
	                            <?php }?>                     
                            </tbody>
                         </table>
                      </div> 

                    <?php 
                    $cc= count($startup_detail);
                    if(!empty($cc)){?>
	                    <nav>
	                      <ul class="pagination pagination-sm">
	                          <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
	                          <li><?= $this->Paginator->numbers() ?></li>
	                          <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
	                      </ul>
	                    </nav>
				   <?php }else {?>
				   		<nav>
	                      <ul class="pagination pagination-sm">
	                      	<li>No Startups Available.</li>
	                      </ul>
	                    </nav>  
				   <?php }?> 
                  </div>

                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="completed">    
                  </div>

                   <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="current">
                  </div>

                   <!--  4Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="myStartups">
                   <div class="clearfix"></div>
                  </div>

                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /#page-content-wrapper --> 
