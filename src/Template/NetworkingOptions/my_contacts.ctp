
<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Messaging', array('controller'=>'Messages','action'=>'index'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Networking options', array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false));
                ?></li>
                <li class="active">Search Contact</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Search</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs networkingTab" role="tablist">

                  <?php
                	$currStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "contacts"]);
                  ?>
                  <li role="presentation" ><a href="#current" aria-controls="current" role="tab" data-toggle="tab" onclick="location.href='<?php echo $currStr;?>'">Search</a></li>

                  <?php
                	$compStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "addContacts"]);
                  ?>
                  <li role="presentation" ><a href="#completed" aria-controls="completed" role="tab" data-toggle="tab" onclick="location.href='<?php echo $compStr;?>'">Add New User</a></li>

                  <?php
                  $searStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "myContacts"]);
                  ?>
                  <li role="presentation" class="active"><a href="#search" aria-controls="search" role="tab" data-toggle="tab" onclick="location.href='<?php echo $searStr;?>'">My Contacts</a></li>

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
	                                               
                            </tbody>
                         </table>
                      </div> 


	                    <nav>
	                      <ul class="pagination pagination-sm">
	                          <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
	                          <li><?= $this->Paginator->numbers() ?></li>
	                          <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
	                      </ul>
	                    </nav>
		
                  </div>

                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="completed">    
                  </div>

                   <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="search">
                  </div>

                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /#page-content-wrapper --> 
