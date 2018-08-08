
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
                <li class="active">My Startups</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>My Startups</h1> 
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
                  <li role="presentation" ><a href="#completed" aria-controls="completed" role="tab" data-toggle="tab" onclick="location.href='<?php echo $compStr;?>'">Completed</a></li>

                  <?php
                  $searStr= $this->Url->build(["controller" => "Startups","action" => "searchStartup"]);
                  ?>
                  <li role="presentation"><a href="#search" aria-controls="search" role="tab" data-toggle="tab" onclick="location.href='<?php echo $searStr;?>'">Search</a></li>

                  <?php
                	$MyStrt= $this->Url->build(["controller" => "Startups","action" => "myStartup",$viewApp]);
                  ?>
                  <li role="presentation" class="active"><a href="#myStartups" aria-controls="My Startups" role="tab" data-toggle="tab" onclick="location.href='<?php echo $MyStrt;?>'">My Startups</a></li>

                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="myStartups">
                     <div class="table-responsive">
                         <table class="table table-striped startup-list">
                            <thead>
                              <tr>
                                <th width="25%">Startup Name</th>
                                <th width="30%">Enterpreneur Name</th>
                                <th width="45%">Action</th>
                              </tr>
                                              
                            </thead>
                            <tbody>
	                            <?php if(!empty($startup_detail)){ $c=0;?>
	                            	<?php foreach($startup_detail AS $startup){ $c++;?>
			                              <tr>

			                                <td>
			                                <?php
			                                 
                                      $id = base64_encode($startup['user_id']);
                                      $startId= base64_encode($startup->id);

                                      //Check if come from Startup Application menu
                                      if($viewApp=='appView'){
                                        echo $this->Html->link($startup->name,['controller'=>'Startups','action'=>'submitApplication',$startId],['escape'=>false,'title'=>'Click Here View']);
                                      }else if($viewApp=='profileView'){
                                        echo $this->Html->link($startup->name,['controller'=>'Startups','action'=>'uploadStartupProfile',$startId],['escape'=>false,'title'=>'Click Here View']);
                                      }else{
                                        echo $this->Html->link($startup->name,['controller'=>'Startups','action'=>'editStartupOverview',$startId],['escape'=>false,'title'=>'Click Here View']);
                                      }
                                      ?>
			                                </td>

			                                <td>
			                            <?php //echo $startup->entrepreneur_basic->first_name;
                                            if(!empty($startup->user->entrepreneur_basic)){
    												
                    							echo $startup->user->entrepreneur_basic->first_name.' '.$startup->user->entrepreneur_basic->last_name;
                                              //echo $startup['startup']['entrepreneur_basic']['first_name'].' '.$startup['startup']['entrepreneur_basic']['last_name'];
                    												 
                    						}else{

                                              echo $startup->user->first_name.' '.$startup->user->last_name;
                    												// echo $startup['startup']['user']['first_name'].' '.$startup['startup']['user']['last_name'];
                    						} 
                                        ?>
			                                </td>
			                                
			                                <td>
                                      <?php 
                                      //echo $this->Html->link('<i class="fa fa-eye"></i> View', array('action' => 'viewStartupOverview', base64_encode($startup->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                                      ?>
                                      <?php 
                                        //Check if come from Startup Application menu
                                        if($viewApp=='appView'){
                                          echo $this->Html->link('<i class="fa fa-pencil"></i>Upload Application &nbsp;&nbsp;', array('action' => 'submitApplication', base64_encode($startup->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn', 'style'=> "padding: 8px !important;"));
                                        }else if($viewApp=='profileView'){
                                          echo $this->Html->link('<i class="fa fa-pencil"></i>Upload Profile &nbsp; &nbsp;', array('action' => 'uploadStartupProfile', base64_encode($startup->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                                        }else{

                                          echo $this->Html->link('<i class="fa fa-pencil"></i>Edit &nbsp;', array('action' => 'editStartupOverview', base64_encode($startup->id)), array('escape'=>false,'class'=>'smallCurveBtn blueBtn customBtn'));
                                        }  
                                      ?>
                                      <?php 

                                         echo $this->Form->postLink('Delete',['action' => 'deleteStartup', base64_encode($startup->id)],['id'=>'delPost'.$c,'class'=>'smallCurveBtn blueBtn customBtn ']);
                                      ?>
				                                <?php 
				                               // echo $this->Html->link('Next Step',['controller'=>'Startups','action'=>'ViewStartupTeam/'. $startup['startup']['id']],['class'=>'fa fa-angle-double-right']);
				                                ?>
			                                </td>
			                                <script type="text/javascript">
                                       $(document).ready(function () {
                                           $('#delPost<?php echo $c;?>').html('<i class="fa fa-trash-o"></i> Delete');
                                        });   
                                      </script>
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
                  <div role="tabpanel" class="tab-pane whiteBg" id="search">
                  </div>

                   <!--  4Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="current">
                   <div class="clearfix"></div>
                  </div>

                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /#page-content-wrapper --> 
