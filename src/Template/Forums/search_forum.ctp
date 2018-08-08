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
                <li class="active">Forums</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Forums</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="forum-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs campaignsTab" role="tablist">

                  <?php $startupForm= $this->Url->build(["controller" => "Forums","action" => "startupForum"]); ?>

                  <li role="presentation" ><a href="#startups" aria-controls="startups" role="tab" data-toggle="tab" onclick="location.href='<?php echo $startupForm;?>'">Startups</a></li>

                  <?php $searchFor= $this->Url->build(["controller" => "Forums","action" => "searchForum"]); ?>

                  <li role="presentation" class="active"><a href="#forums" aria-controls="forums" role="tab" data-toggle="tab" onclick="location.href='<?php echo $searchFor;?>'">Forums</a></li>

                  <?php $myfrm= $this->Url->build(["controller" => "Forums","action" => "myForum"]); ?>

                  <li role="presentation"><a href="#myForums" aria-controls="myForums" role="tab" data-toggle="tab" onclick="location.href='<?php echo $myfrm;?>'">My Forums</a></li>
                 
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane  whiteBg" id="startups"> 
                  </div>
                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="forums">
                  <div class="form-group">
                      <div class="row">
                        <?= $this->Form->create('Search',['id'=>'FormField','type'=>'get']) ?>
                            <div class="col-lg-9 col-md-9 col-sm-12 ">
                            <input type="search" placeholder="Search your keyword" name="search" class="form-control">
                            </div>
                            <div class="col-lg-3 col-md-3 col-sm-12 no_paddingleftcol ">
                            <button class="searchBtn" type="submit">Search</button>
                            </div>
                        <?= $this->Form->end() ?>
                      </div>
                    </div>
                    <ul class="contentListing startup_listing"> 

                      <?php if(!empty($formLists)){
                        foreach($formLists as $forum){?>

                          <li>
                           <div class="listingIcon"><i class="icon">
                           <img alt="" src="<?php echo $this->request->webroot;?>images/forum.png">
                           </i></div>
                           <div class="listingContent">
                             <div class="headingBar">
                               <h2 class="heading">

                               <?php echo $forum->title;?>

                               </h2>
                               <h2 class="date-right date"><?php echo date_format($forum->created,"F d, Y").' '.date('h:m A', strtotime($forum->created));?></h2>
                             </div>
                             <p><?php echo $string = (strlen($forum->description) > 550) ? substr($forum->description,0, 550).'...' : $forum->description;?>
                             </p>
                            <div class="links alignRight">
                                      
                                 <!-- Delete Button Code -->
                                 <?php
                                 echo $this->Html->link('<i class="fa fa-eye"></i>View', array('controller'=>'Forums','action'=>'viewForum',base64_encode($forum->id)), array('escape'=>false,'class'=>'smallCurveBtnMsg blueBtn customBtnMsg'));
                                 ?>

                             </div>
                          </div>
                          </li> 

                      <?php } ?> 
                      <?php } ?> 
                     
                    </ul>
                     <?php
                        $cc= count($formLists);
                            if(!empty($formLists)){
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
                                  <li>No Forums Available.</li>
                                </ul>
                              </nav>  
                      <?php }?>
                    
                  </div>
                   <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="myForums">
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /#page-content-wrapper --> 

 
     