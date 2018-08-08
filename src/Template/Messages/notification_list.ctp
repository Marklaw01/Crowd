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
                <li class="active">Notifications</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Notifications Recieved</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
       
         <div class='row'>
          <div class='col-lg-11 col-md-12 col-sm-12 '>
           <ul class="contentListing notification_listing"> 
           			<?php foreach($notifications as $notification){ 
                        $UserImage = $this->Custom->getUserImageByID($notification['sender_id']);
                        if(!empty($UserImage[0]['image'])){
                             $imagePath= $this->request->webroot.'img/profile_pic/'.$UserImage[0]['image'];
                        }else {
                             $imagePath= $this->request->webroot.'images/dummy-man.png';
                        }
                        if($notification['read']== 0){
                          $class='unseen-notification';
                        }else{
                          $class='';
                        }
                        $UserName = $this->Custom->getContractorUserNameById($notification['sender_id']);
                ?>
                    <li class="<?php echo $class;?>"><a href="<?php echo $notification['link']; ?>" onClick="updateStatus('yes');">  <div class="userImage circle-img-contractor"><img src="<?php echo $imagePath;?>" class="notify-user"></div><span> <strong><?php echo $UserName;?></strong> <?php echo $notification['title']; ?> </span></a><span><?php echo date_format($notification['created'],"F d, Y"); ?></span></li>
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
	                      	<li>No Notifications Found.</li>
	                      </ul>
	                    </nav>  
				   <?php }?>
        </div>
        </div>
        </div>
        <!-- /#page-content-wrapper --> 
 
 
     