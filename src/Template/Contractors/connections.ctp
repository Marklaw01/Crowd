 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                 <li><?php
                    echo $this->Html->link('My Profile', array('controller'=>'Contractors','action'=>'myProfile'), array('escape'=>false));
                ?></li>
                <li class="active">My Connections</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>My Connections</h1> 
              </div>
            </div>
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">

              

              <div role="tabpanel" class="about-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav aboutTab connectionTab nav-tabs" role="tablist">

                  <li role="presentation" class="active">
                  <?php 
                   $basic= $this->Url->build(["controller" => "contractors","action" => "connections"]); ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#connections" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">My Connections</a>
                  <?php 
                  ?>
                  </li>

                  <li role="presentation">
                  <?php 
                    $profess= $this->Url->build(["controller" => "contractors","action" => "myMessages"]);
                  ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#my-messages" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">My Messages</a>
                    
                  </li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->                 
                 <?php //pr($user);?>
                  
                  <div role="tabpanel" class="tab-pane active" id="connections">

                      <div class="form-group"></div>
                        <div class="row">
                          <?= $this->Form->create('Search',['id'=>'FormField','type'=>'get']) ?>
                          
                              <div class="col-lg-9 col-md-9 col-sm-12 ">
                                <input type="search" placeholder="Search connections by name." name="search" class="form-control">
                              </div>

                              <div class="col-lg-3 col-md-3 col-sm-12 no_paddingleftcol ">
                                  <button class="searchBtn" type="submit">Search</button>
                              </div>

                          <?= $this->Form->end() ?>
                        </div>
                      

                      <div class='row'>
                        <div class='col-lg-11 col-md-12 col-sm-12 '>
                            <ul class="contentListing notification_listing"> 
                              <?php $totalCount= count($connectionLists); foreach($connectionLists as $connectionList){ 

                                    if($connectionList->connection_by == $UserId){
                                      $contractorId=$connectionList->connection_to;
                                    }else{
                                      $contractorId=$connectionList->connection_by;
                                    }

                                      $UserImage = $this->Custom->getUserImageByID($contractorId);
                                      if(!empty($UserImage[0]['image'])){
                                           $imagePath= $this->request->webroot.'img/profile_pic/'.$UserImage[0]['image'];
                                      }else {
                                           $imagePath= $this->request->webroot.'images/dummy-man.png';
                                      }

                                      $UserName = $this->Custom->getContractorUserNameById($contractorId);
                              ?>
                                  <li class="">
                                    <div class="userImage circle-img-contractor">
                                      <img src="<?php echo $imagePath;?>" class="notify-user">
                                    </div>
                                    <span> <strong><?php echo $UserName;?></strong> </span>
                                    <span><?php //echo date_format($connectionList['created'],"F d, Y"); ?></span>
                                    <span class="customBtnSndMsg customBtn greenBtn  pull-right">
                                        <?php
                                            echo $this->Html->link('Send Message', array('controller'=>'Contractors','action'=>'sendMessage',base64_encode($contractorId)), array('escape'=>false));
                                        ?>
                                    </span>
                                  </li>
                              <?php } ?>  
                                     
                                   
                            </ul>
                            <?php
                                if(!empty($totalCount)){
                            ?>
                            <nav class="pagingNav">
                                    <ul class="pagination pagination-sm">
                                    <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                                    <li><?= $this->Paginator->numbers() ?></li>
                                    <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                                    </ul>
                            </nav>

                            <?php }else {?>
                            <nav class="pagingNav">
                                      <ul class="pagination pagination-sm">
                                        <li>No Connections Found.</li>
                                      </ul>
                            </nav>  
                         <?php }?>
                      </div>
                      </div>
                  </div>
                  <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane" id="my-messages">
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
 </div>
 <!-- /#page-content-wrapper --> 
<script type="text/javascript">

</script>