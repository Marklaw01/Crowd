<?php 
foreach($notifications as $notification){ 
	$UserImage = $this->Custom->getUserImageByID($notification['sender_id']);
	if(!empty($UserImage[0]['image'])){
	     $imagePathCheck= $this->request->webroot.'img/profile_pic/'.$UserImage[0]['image'];
	     //chmod($imagePathCheck, 0777);
	      if(file_exists($imagePathCheck)) {
	      		$imagePath=$imagePathCheck;
	      }else{
	      		$imagePath= $this->request->webroot.'images/dummy-man.png';
	      }	
	      $imagePath=$imagePathCheck;
	}else {
	     $imagePath= $this->request->webroot.'images/dummy-man.png';
	}
	if($notification['read']== 0){
		$class='unseen-notification';
	}else{
		$class='';
	}
	if($notification['type']== 'Add_member'){
	$UserName = $this->Custom->entrepreneurName($notification['sender_id']);
	}else{
	$UserName = $this->Custom->getContractorUserNameById($notification['sender_id']);
	}
	//$data['notiList']='<li class="'.$class.'"><a href="#"><img src="'.$imagePath.'" class="notify-user"><span> <strong>'.$UserName.'</strong>'.$notification['title'].'</span></a></li>';

	
?>
<li class="<?php echo $class;?>"><a href="<?php echo $notification['link']; ?>" onClick="updateStatus('yes');">  <img src="<?php echo $imagePath;?>" class="notify-user"><span> <strong><?php echo $UserName;?></strong> <?php echo $notification['title']; ?> </span></a></li>

<?php } ?>

<?php 
$nCount= count($notifications);
if(empty($nCount)){
	echo "<li class=''><a href='javascript:void();'>No notifications found.</a></li>";
}
?>
<?php //echo $totalCount;
	if($totalCount >10){
		echo $this->Html->link('View all...', array('controller'=>'Messages','action'=>'notificationList'), array('escape'=>false,'class'=>'view_all'));
	} 
?>
                      