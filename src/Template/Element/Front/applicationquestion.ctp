<div id="customDiv<?php echo $id;?>">
    <div class="">
        <a class="addNewApp" id="addPreScn" onclick="bindAlert('customDiv<?php echo $id;?>')" href="javascript:void(0)"><img alt="" src="<?php echo $this->request->webroot;?>images/removeIcon.png"></a>
   </div>


    <?php $c=0; foreach ($QuestionsList->cofounders[0] as $key => $value) { $c++;?> 
        <div class="form-group">
            <label for="text1"><?php echo $key;?></label>
            <?php
                 echo $this->Form->input('cofounders[question]['.$id.'][q_'.$c.']', ARRAY('label' => false,'error' => false, 'div' => false,'type' => 'hidden','value'=>$key));
            ?>
            <?php
                 echo $this->Form->input('cofounders[answer]['.$id.'][ans_'.$c.']', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'Answer','class' => 'form-control'));
            ?>
        </div>
    <?php } ?>    



</div>