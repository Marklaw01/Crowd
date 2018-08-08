<div class="container-fluid">
    <div class="row">
      <div class='col-lg-12 col-md-12 col-sm-12 '>
        <div class="profileName profileNameFeeds <?php echo $widthClass;?>">
            <?php
                echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'navbar-brand'));
            ?>

            <?php
                echo $this->Html->link("News", array('controller'=>'Contractors','action'=>'news'), array('escape'=>false,'class'=>'navbar-brand'));
            ?>

            <?php
              if(!empty($UserId)){
                echo $this->Html->link("Alerts", array('controller'=>'Contractors','action'=>'feeds'), array('escape'=>false,'class'=>'active'));
              }  
            ?>

            <?php
              if(empty($UserId)){
                echo $this->Html->link("Start", array('controller'=>'Contractors','action'=>'gettingStarted'), array('escape'=>false,'class'=>'navbar-brand'));
              }
            ?>

            <?php
              if(!empty($UserId)){
                echo $this->Html->link("Networking Options", array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false,'class'=>'navbar-brand'));
              }
            ?>
        </div>
      </div>
      <div class="col-lg-12 ">
        <ol class="breadcrumb">
          <li> <?php
              echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
          ?>
          <li class="active">What's New</li>
        </ol>
      </div>
    </div>
    <div class='row'>
        <div class='col-lg-12 col-md-12 col-sm-12 '>
          <div class="profileName">
              <?php
                  echo $this->Html->link("Post a Message", array('controller'=>'Contractors','action'=>'addFeed'), array('escape'=>false,'class'=>'active'));
              ?>
          </div>
        </div>
    </div>
    <!-- breadcrumb ends --> 
    <div class='row'>
      <div class='col-lg-12 col-md-12 col-sm-12 '>
       <div class="page_heading">
         <h1>What's New</h1> 
        </div>
      </div>
    </div>
    <!-- header ends --> 
  <?php 
    if(isset($_SERVER['HTTPS'])){
      $protocol = ($_SERVER['HTTPS'] && $_SERVER['HTTPS'] != "off") ? "https" : "http";
    }else{
      $protocol = 'http';
    }
    $baseUrl=  $protocol . "://" . $_SERVER['HTTP_HOST'];
  ?>
  <div class='row'>
    <div class='col-lg-11 col-md-12 col-sm-12 ' >
      <ul class="contentListing notification_listing" id="feed_list"> 
     			<?php 
            foreach($feedsLists as $feedsList){ 
              if(!empty($feedsList['sender_image'])){
                   $imagePath= $baseUrl.$feedsList['sender_image'];
              }else {
                   $imagePath= $baseUrl.'/images/dummy-man.png';
              }

              if($feedsList['type'] != 'custom_feed'){
          ?>
                <li class="">
                  <a href="<?php echo $feedsList['link']; ?>" onClick="updateStatus('yes');">  
                    <div class="userImage circle-img-contractor leftone">
                      <img src="<?php echo $imagePath;?>" class="notify-user">
                    </div>
                    <div class="rightone">
                      <span class="feed-title"> 
                        <strong>
                          <?php echo $feedsList['title']; ?> 
                        </strong> 
                      </span>  
                      <span class="feed-date">
                        <?php echo $feedsList['date']; ?>
                      </span>
                      
                      <span class="feed-bio">
                        <?php echo substr($feedsList['sender_bio'], 0, 210); ?>
                      </span>
                      <span class="feed-msg">
                        <strong>Message:</strong> <?php echo $feedsList['message'];?>
                      </span>
                    </div>
                  </a>
                </li>
              <?php }else{ ?> 
               <li class="">
                    
                    <div class="userImage circle-img-contractor leftone">
                      <img src="<?php echo $imagePath;?>" class="notify-user">
                    </div>
                    <div class="rightone">
                      <span class="feed-title"> 
                        <strong>
                          <?php echo $feedsList['title']; ?> 
                        </strong> 
                      </span>  
                      <span class="feed-date">
                        <?php echo $feedsList['date']; ?>
                      </span>
                      
                      <span class="feed-bio">
                        <?php echo substr($feedsList['sender_bio'], 0, 210); ?>
                      </span>
                      <span class="feed-msg">
                        <strong>Message:</strong> <?php echo $feedsList['message'];?>
                      </span>
                    </div>
                    <div class="feed-attachment">
                      <?php $cnt=0; if(!empty($feedsList['file1'])){  $cnt++;?> 
                        <a href="<?php echo $baseUrl.'/'.$feedsList['file1']; ?>" target="_blank" title="View"> Attachment <?php echo $cnt;?></a>
                      <?php }?>

                      <?php if(!empty($feedsList['file2'])){ $cnt++;?> 
                        <a href="<?php echo $baseUrl.'/'.$feedsList['file2']; ?>" target="_blank" title="View"> Attachment <?php echo $cnt;?></a>
                      <?php }?>

                      <?php if(!empty($feedsList['file3'])){ $cnt++; ?> 
                        <a href="<?php echo $baseUrl.'/'.$feedsList['file3']; ?>" target="_blank" title="View"> Attachment <?php echo $cnt;?></a>
                      <?php }?>

                      <?php if(!empty($feedsList['file4'])){ $cnt++; ?> 
                        <a href="<?php echo $baseUrl.'/'.$feedsList['file4']; ?>" target="_blank" title="View"> Attachment <?php echo $cnt;?></a>
                      <?php }?>

                    </div>
                </li>
              <?php } ?>    
          <?php } ?>  
      </ul>
  		<?php
      if(!empty($TotalItems)){
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
          	<li>No feeds list found.</li>
          </ul>
        </nav>  
  	  <?php }?>
    </div>
  </div>
</div>
<!-- /#page-content-wrapper --> 
 
 <script type="text/javascript">
   // Ajax get feeds
   function ajaxGetFeedList () {
      $.ajax({ 
        url: "<?php echo $this->Url->build(["Controller" => "Contractors","action" => "getFeedLists"]);?>",
        data: {},
        type : 'POST',
        cache: false,
        success: function(data) {

          $("#feed_list").html(data);
        }
      });

    }
    <?php if(empty($pageNo)){?>
      setInterval(function(){
        ajaxGetFeedList(); // this will run after every 5 seconds
      }, 10000);
    <?php } ?>    
 </script>
     