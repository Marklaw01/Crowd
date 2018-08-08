<h3><?php echo "Entrepreneur Detail"; ?></h3>
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
<?php echo $this->Html->link("Basic",['controller'=>'entrepreneurs','action'=>'ViewBasicProfile'],ARRAY('class'=>"focus"));?>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<?php echo $this->Html->link("Professional",['controller'=>'entrepreneurs','action'=>'ViewProfessionalProfile'],ARRAY('class'=>""));?>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<?php echo $this->Html->link("Startups",['controller'=>'startups','action'=>'ListStartup'],ARRAY('class'=>""));?></div>


<?php //if(!empty($enterpreneurdata)){
//pr($enterpreneurdata);?>
<div>
    <?php if(!empty($enterpreneurdata['image'])){ ?>
    <?php echo $this->Html->image('entrepreneur/' .$enterpreneurdata['image'],array('width'=>'150px','height'=>'100px')); ?>
    <?php }else{
     $filename = "userdummy.jpg";
     echo $this->Html->image('default/'.$filename,array('width'=>'150px','height'=>'100px')); ?>
    <?php } ?>
</div>
<div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Bio:</label>
        <span class="col3"><?= $enterpreneurdata['bio'] ?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Name:</label>
        <span><?= $enterpreneurdata['first_name'].'  '.$enterpreneurdata['last_name'] ?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Email Address:</label>
        <span><?= $enterpreneurdata['email'] ?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Date Of Birth:</label>
        <span><?=  date("F jS, Y",strtotime($enterpreneurdata['date_of_birth'] )) ?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Phone Number:</label>
        <span><?= $enterpreneurdata['phoneno'] ?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Country : </label>
        <span><?= $enterpreneurdata['country']['name']?></span>
    </div>

    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">State :</label>
        <span><?= $enterpreneurdata['state']['name']?></span>
    </div>
    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Security Question :</label>
        <span><?= $enterpreneurdata['question']['name']; ?></span>
    </div>
    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">City :</label>
        <span><?= $enterpreneurdata['city'] ?></span>
    </div>
     <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">Answer :</label>
        <span><?= $enterpreneurdata['answer']; ?></span>
    </div>
    <div class="formGroup">
        <label class="controLabel col3 textLeft" for="username">My Interests :</label>
        <span><?= $enterpreneurdata['my_interests']; ?></span>
    </div>
    
    

    
</div>


<?php //}else{
            //echo $this->Html->link("Add Detail",ARRAY('controller'=>'contractors','action'=>'EditBasicProfile'),ARRAY('class'=>""));
         // }
?>