<h3><?php echo "Contractor Detail"; ?></h3>
<style type="text/css">
a
{color:#1798A5;}
a:hover
{color:#1798A5;}
a:active, div a:first-child 
{color:#8b814c;}
.content-container{margin-top: 23px;}
.content-container .formGroup {
  display: inline-flex;
  width: 100%;
}
.content-container .formGroup label {
  width: 20%;
}
.content-container .formGroup span {
  width: 50%;
}
.edit-link {
  float: right;
}
</style>
<div>
<?php  $login_id = $this->request->session()->read('Auth.User.id');?>
<?php echo $this->Html->link("Basic",ARRAY('controller'=>'contractors','action'=>'my_profile'),ARRAY('class'=>"focus"));?>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 <?php if(!empty($contractordata['price']) && ($contractordata['user_id']!=$login_id)){
          
          // $user_id =$contractordata['user_id'];
           $id = base64_encode($contractordata['user_id']);
           echo '<a href="/crowdbootstrap/Contractors/view_professional_profile/'.$id.'"> Professional</a>';

          //echo $this->Html->link('Add Contractor',['controller'=>'Contractors','action'=>'add_contractor/'.base64_encode($contractordata->user_id)]);
  }else{?>
 
<?php echo $this->Html->link("Professional",ARRAY('controller'=>'contractors','action'=>'ViewProfessionalProfile'),ARRAY('class'=>""));?>
<?php }?>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<?php echo $this->Html->link("Startups",ARRAY('controller'=>'startups','action'=>'ListStartup'),ARRAY('class'=>""));?></div>


<?php //if(!empty($contractordata)){
//pr($contractordata);?>
<div>
    <?php if(!empty($contractordata['image'])){ ?>

    <?php echo $this->Html->image('profile_pic/' .$contractordata['image'],array('width'=>'150px','height'=>'100px')); ?>
    <?php }else{
       
     $filename = "userdummy.jpg";
     echo $this->Html->image('default/'.$filename,array('width'=>'150px','height'=>'100px')); ?>
    <?php } ?>
</div>

<div class="content-container">
    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Price:</label>
        <?php if(!empty($contractordata['price'])){?>
        <span class="col3"><?= '$'.$contractordata['price'].'/hr' ?></span>
        <?php } ?>
    </div>
    <div class="col9">          
       <?php 
      
          if(!empty($contractordata['price']) && ($contractordata['user_id']!=$login_id)){
          
           // $id = base64_encode($contractordata['user_id']);
           //echo '<a href="/crowdbootstrap/contractors/add-contractor/'.$id.'"> Add Contractor</a>';
   echo $this->Html->link('Add Contractor',['controller'=>'Contractors','action'=>'add_contractor/'.$contractordata['user_id']]);
          }
       ?>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Bio:</label>
        <span class="col3"><?= $contractordata['bio'] ?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Name:</label>
        <span><?= $contractordata['first_name'] ?> <?= $contractordata['last_name'] ?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Email Address:</label>
        <span><?= $contractordata['email'] ?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Date Of Birth:</label>
        <span><?=  date("F jS, Y",strtotime($contractordata['date_of_birth'])) ?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Phone Number:</label>
        <span><?= $contractordata['phoneno'] ?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Country : </label>
        <span><?= $contractordata['country']['name']?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">State :</label>
        <span><?= $contractordata['state']['name']?></span>
    </div>
    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Security Question :</label>
        <span><?= $contractordata['question']['name']; ?></span>
    </div>
    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">City :</label>
        <span><?= $contractordata['city'] ?></span>
    </div>
     <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Answer :</label>
        <span><?= $contractordata['answer']; ?></span>
    </div>
    
    

    
</div>


<?php //}else{
	        //echo $this->Html->link("Add Detail",ARRAY('controller'=>'contractors','action'=>'EditBasicProfile'),ARRAY('class'=>""));
	     // }
?>