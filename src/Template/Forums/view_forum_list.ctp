<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Forum Startups', array('controller'=>'Forums','action'=>'startupForum'), array('escape'=>false));
                ?></li>
                <li class="active">Startup Forum List</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Startup Forum List</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
       
         <div class='row'>
          <div class='col-lg-11 col-md-12 col-sm-12 '>
           <ul class="contentListing archivedForums_listing"> 
                      
                      <?php if(!empty($forums)){
                        foreach($forums as $forum){?>

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

                  <nav class="pagingNav">
                      <?php
                        $cc= count($forums);
                            if(!empty($cc)){
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
                                  <li>No Forums Found.</li>
                                </ul>
                              </nav>  
                      <?php }?>
                      </ul>
                  </nav>
        </div>
        </div>
        </div>
        <!-- /#page-content-wrapper --> 

     