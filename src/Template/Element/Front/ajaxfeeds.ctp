<?php 
	if(isset($_SERVER['HTTPS'])){
	  $protocol = ($_SERVER['HTTPS'] && $_SERVER['HTTPS'] != "off") ? "https" : "http";
	}else{
	  $protocol = 'http';
	}
	$baseUrl=  $protocol . "://" . $_SERVER['HTTP_HOST'];
	foreach($ajaxfinalConnections as $feedsList){ 
		if(!empty($feedsList['sender_image'])){
		    $imagePath= $baseUrl.$feedsList['sender_image'];
		}else {
		    $imagePath= $baseUrl.'/images/dummy-man.png';
		}

	  	if($feedsList['type'] != 'custom_feed'){
?>
				<li class="">
					<a href="<?php echo $feedsList['link']; ?>">  
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
                      <?php $cnt=0; if(!empty($feedsList['file1'])){ $cnt++; ?> 
                        <a href="<?php echo $baseUrl.'/'.$feedsList['file1']; ?>" target="_blank" title="View"> Attachment <?php echo $cnt;?></a>
                      <?php }?>

                      <?php if(!empty($feedsList['file2'])){ $cnt++; ?> 
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