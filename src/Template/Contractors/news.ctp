<div class="container-fluid">
    <div class="row">
      <div class='col-lg-12 col-md-12 col-sm-12 '>
        <div class="profileName profileNameFeeds <?php echo $widthClass;?>">
            <?php
                echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'navbar-brand'));
            ?>

            <?php
                echo $this->Html->link("News", array('controller'=>'Contractors','action'=>'news'), array('escape'=>false,'class'=>'active'));
            ?>

            <?php
              if(!empty($UserId)){
                echo $this->Html->link("Alerts", array('controller'=>'Contractors','action'=>'feeds'), array('escape'=>false,'class'=>'navbar-brand'));
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
          <li class="active">News</li>
        </ol>
      </div>
    </div>
    <!-- breadcrumb ends --> 
    <div class='row'>
      <div class='col-lg-12 col-md-12 col-sm-12 '>
       <div class="page_heading">
         <h1>News</h1> 
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
            foreach($BlogPostLists as $BlogPostList){ 
              $imagePath= $baseUrl.'/img/cbslogo.png';
          ?>
                <li class="">
                  <a href="<?php echo $BlogPostList['link']; ?>" title="" target="_blank">  
                    <div class="userImage circle-img-contractor leftone">
                      <img src="<?php echo $imagePath;?>" class="notify-user">
                    </div>
                    <div class="rightone">
                      <span class="feed-title"> 
                        <strong>
                          <?php echo $BlogPostList['blog_title']; ?> 
                        </strong> 
                      </span>  
                      <span class="feed-date">
                        <?php echo date('M d, Y',strtotime($BlogPostList['date'])); ?>
                      </span>
                      
                      <span class="feed-bio">
                        <?php echo substr($BlogPostList['short_desc'], 0, 210); ?>
                      </span>
                    </div>
                  </a>
                </li>  
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
     