<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Startups', array('controller'=>'Startups','action'=>'currentStartup'), array('escape'=>false));
                ?></li>
                <li class="active">Submit Application</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>View Application</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
           <?= $this->Form->create($startupDetails,['id'=>'FormField', 'enctype' => 'multipart/form-data']) ?>
           
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">

               <div class="form-group">
                    <span class="form-control">
                        <?php echo $startupDetails->name;?>
                    </span>
               </div>
               <div class="aboveQClass" id="above">

                    <?php $a=0; foreach ($result->above as $key => $value) { $a++;?> 

                        <div class="form-group">
                            <label for="text1"><?php echo $key;?></label>
                            <?php
                                 echo $this->Form->input('above[question][q_'.$a.']', ARRAY('label' => false,'error' => false, 'div' => false,'type' => 'hidden','value'=>$key));
                            ?>
                            <?php
                                 echo $this->Form->input('above[answer][ans_'.$a.']', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'Answer','class' => 'form-control','value'=>$value));
                            ?>
                        </div>

                    <?php } ?>
              </div> 

              <div class="coFounderClass" id="cofounders">
                    <h4 class="heading">Who are you coFounders?
                    </h4>
    <!-- Co-F 1-->  
                <?php 
                $id=0;
                $vj= count($result->cofounders);
                for($i=0;$i<$vj;$i++){ $id++;                 
                ?>
                
                    <?php if($i >0){?> 
                        <div id="customDiv<?php echo $id;?>">
                        <div class="">
                            <a class="addNewApp" id="addPreScn" onclick="bindAlert('customDiv<?php echo $id;?>')" href="javascript:void(0)"><img alt="" src="<?php echo $this->request->webroot;?>images/removeIcon.png"></a>
                       </div>
                    <?php }?>

                        <?php $c=0; foreach ($result->cofounders[$i] as $key => $value) { $c++;?> 
                            <div class="form-group">
                                <label for="text1"><?php echo $key;?></label>
                                <?php
                                     echo $this->Form->input('cofounders[question]['.$id.'][q_'.$c.']', ARRAY('label' => false,'error' => false, 'div' => false,'type' => 'hidden','value'=>$key));
                                ?>
                                <?php
                                     echo $this->Form->input('cofounders[answer]['.$id.'][ans_'.$c.']', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'Answer','class' => 'form-control','value'=>$value));
                                ?>
                            </div>
                        <?php } ?>    
                        
                    <?php if($i >0){?> </div> <?php } ?>

                <?php  } // end of for ?>

                   <span id="addHere"></span>
                   <div class="">
                    <a class="addNewApp" id="addPreScn1" href="javascript:void(0)"><img alt="" src="<?php echo $this->request->webroot;?>images/addIcon.png"></a>
                   </div>


               </div>

               <div class="belowClass" id="below">

                    <?php $b=0; foreach ($result->below as $key => $value) { $b++;?>
                        <div class="form-group">
                            <label for="text1"><?php echo $key;?></label>
                            <?php
                                 echo $this->Form->input('below[question][q_'.$b.']', ARRAY('label' => false,'error' => false, 'div' => false,'type' => 'hidden','value'=> $key));
                            ?>
                            <?php
                                 echo $this->Form->input('below[answer][ans_'.$b.']', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'Answer','class' => 'form-control','value'=>$value));
                            ?>
                        </div>
                    <?php  } ?> 

               </div>


              <div class="belowAClass" id="belowA">

                    <?php $ba=0; foreach ($result->belowA as $key => $value) { $ba++;?>

                        <div class="form-group">
                            <label for="text1"><?php echo $key;?></label>
                            <?php
                                 echo $this->Form->input('belowA[question][q_'.$ba.']', ARRAY('label' => false,'error' => false, 'div' => false,'type' => 'hidden','value'=>$key));
                            ?>
                            <?php
                                 echo $this->Form->input('belowA[answer][ans_'.$ba.']', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'Answer','class' => 'form-control','value'=>$value));
                            ?>
                        </div>
                    <?php  } ?>  
              </div>

              <div class="belowBClass" id="belowB">

                    <?php $bb=0; foreach ($result->belowB as $key => $value) { $bb++;?>

                        <div class="form-group">
                            <label for="text1"><?php echo $key;?></label>
                            <?php
                                 echo $this->Form->input('belowB[question][q_'.$bb.']', ARRAY('label' => false,'error' => false, 'div' => false,'type' => 'hidden','value'=>$key));
                            ?>
                            <?php
                                 echo $this->Form->input('belowB[answer][ans_'.$bb.']', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'Answer','class' => 'form-control','value'=>$value));
                            ?>
                        </div>
                    <?php  } ?> 
              </div>

              <div class="belowCClass" id="belowC">

                    <?php $bc=0; foreach ($result->belowC as $key => $value) { $bc++;?>

                        <div class="form-group">
                            <label for="text1"><?php echo $key;?></label>
                            <?php
                                 echo $this->Form->input('belowC[question][q_'.$bc.']', ARRAY('label' => false,'error' => false, 'div' => false,'type' => 'hidden','value'=>$key));
                            ?>
                            <?php
                                 echo $this->Form->input('belowC[answer][ans_'.$bc.']', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'Answer','class' => 'form-control','value'=>$value));
                            ?>
                        </div>
                    <?php  } ?>
              </div>

              <div class="belowDClass" id="belowD">

                    <?php $bd=0; foreach ($result->belowD as $key => $value) { $bd++;?>

                        <div class="form-group">
                            <label for="text1"><?php echo $key;?></label>
                            <?php
                                 echo $this->Form->input('belowD[question][q_'.$bd.']', ARRAY('label' => false,'error' => false, 'div' => false,'type' => 'hidden','value'=>$key));
                            ?>
                            <?php
                                 echo $this->Form->input('belowD[answer][ans_'.$bd.']', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'Answer','class' => 'form-control','value'=>$value));
                            ?>
                        </div>

                    <?php  } ?> 
              </div>


                <?php 
                    if(!empty($resultSubmit)){
                ?>
                  <div class="form-group">
                   <span style="color: red;">(You have already submitted this application.)</span>
                  </div>
                <?php } ?>
               <div class="form-group  pull-left">
                  <?php
                          echo $this->Html->link('Back ', array('controller'=>'Startups','action'=>'editStartupRoadmapdocs',$startupId), array('escape'=>false, 'class'=>'customBtn blueBtn'));
                  ?>
                </div>

                <div class="form-group  pull-left-custom">
                   <?= $this->Form->button('Save',['name'=>'update', 'class'=> 'customBtn blueBtn']) ?>
                </div>
                <div class="form-group  pull-right">
                   <?= $this->Form->button('Submit',['name'=>'submit','class'=> 'customBtn greenBtn']) ?>
                </div>
            
          </div>
          </div>
          <input type="hidden" id="qId" value="<?php echo $vj+1; ?>">
          <?= $this->Form->end() ?>
  </div>
        <!-- /#page-content-wrapper -->

   
<script>

// Ajax for states list
$(function(){
    $('#addPreScn1').click(function(){ 
    var val = $('#qId').val();
    $.ajax({ 
    url: "<?php echo $this->Url->build(["Controller" => "Startups","action" => "getQuestionList"]);?>",
    data: {id:val},
        type : 'POST',
        cache: false,
        calledByAjax: true,
    success: function(data) {

      $(data).insertBefore('#addHere');
      $('#customDiv'+val).remove();
      
      val++;
      $('#qId').val(val); 
    }
       });

   });
});
function bindAlert(count){
   $('#'+count).remove();

}
</script>






