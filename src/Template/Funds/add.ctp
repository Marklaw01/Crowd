<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('My Funds', array('controller'=>'Funds','action'=>'myFund'), array('escape'=>false));
                ?></li>
                <li class="active">Create Fund</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Create Fund</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <?= $this->Form->create($fund,['enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
              

              <div class="form-group">
              <label>Fund's Title</label>
                <?php
                  echo $this->Form->input('title', ARRAY('label' => false, 'div' => false, 'error' => false, 'id' => '','placeholder'=>"Fund's Title",'class' => 'form-control','type'=>'text'));
                ?>
                <?php 
                      echo $this->Form->error('title', null, array('class' => 'error-message'));
                ?>
              </div>

              <div class="form-group">
              <label>Fund's Description</label>
                 <?php
                    echo $this->Form->input('description', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>"Fund's Description",'class' => 'form-control'));
                 ?>
                 <?php 
                      echo $this->Form->error('description', null, array('class' => 'error-message'));
                ?>
              </div>




              <div class="form-group">
              <label>Fund's Managers</label>
                <?php
                  //echo $this->Form->input('managers_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'validate[required]form-control selectpicker form-control show-tick','id' => 'managers_id','multiple'=>true,'type'=>'select','title'=>"No Fund's Managers Added", 'options'=>$managerLists));
                ?> 
                

                <span class="form-control textAreaKeyword" id="selectedResult11">
                    <ul>
                    <?php 
                      if(isset($_POST['submit'])){
                        
                        if(isset($_POST['managers_id'])){
                          $skey11= $_POST['managers_id'];
                        }else{
                          $skey11=[];
                        }
                        
                        $cc11 =count($skey11);
                        if(!empty($skey11[0])){
                              for($v11=0; $v11<$cc11; $v11++){
                                    $slids11=$skey11[$v11];
                                    //echo $slids;
                                    //echo $Keywords[$slids];
                                    echo '<li id="sel_'.$slids11.'"><a onClick="removeSelection11('.$slids11.')" href="javascript:void(0)">'.$managerLists[$slids11].'<i class="fa fa-close"></i></a></li>';
                              }
                          }
                      }
                    ?>
                    </ul>
                </span>
              
                <?php
                    echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard11','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Fund's Managers", 'options'=>$managerLists));
                ?>  
                  
                <select name="managers_id[]" multiple="" id="hiddenKey11" style="display: none;">
                    <?php
                      if(!empty($skey11[0])){
                             for($vv11=0;$vv11<$cc11;$vv11++){?>
                                 <option id="sel_<?php echo $skey11[$vv11]?>" selected="selected" value="<?php echo $skey11[$vv11]?>"></option>
                             <?php }?>
                    <?php }?>
                </select>

                <?php 
                    echo $this->Form->error('managers_id', null, array('class' => 'error-message'));
                ?>
                <script type="text/javascript">
                  $(function() {
                    $("#standard11").customselect();
                  });
                  function removeSelection11(id){
                    //alert(id);
                    $('#selectedResult11 #sel_'+id).remove();
                    $('#hiddenKey11 #sel_'+id).remove();
                  }
                </script>


              </div>

              <div class="form-group">
              <label>Sponsors</label>
                <?php
                  //echo $this->Form->input('sponsors_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'validate[required]form-control selectpicker form-control show-tick','id' => 'sponsors_id','multiple'=>true,'type'=>'select','title'=>"No Sponsors Added", 'options'=>$sponsorsLists));
                ?> 

                <span class="form-control textAreaKeyword" id="selectedResult12">
                    <ul>
                      <?php 
                        if(isset($_POST['submit'])){
                          if(isset($_POST['sponsors_id'])){
                            $skey12= $_POST['sponsors_id'];
                          }else{
                            $skey12=[];
                          }

                          $cc12 =count($skey12);
                          if(!empty($skey12[0])){
                                for($v12=0; $v12<$cc12; $v12++){
                                      $slids12=$skey12[$v12];
                                      //echo $slids;
                                      //echo $Keywords[$slids];
                                      echo '<li id="sel_'.$slids12.'"><a onClick="removeSelection12('.$slids12.')" href="javascript:void(0)">'.$sponsorsLists[$slids12].'<i class="fa fa-close"></i></a></li>';
                                }
                            }
                        }
                      ?>
                    </ul>
                </span>
              
                <?php
                    echo $this->Form->input('keywordsTh', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard12','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Sponsors", 'options'=>$sponsorsLists));
                ?>  
                  
                <select name="sponsors_id[]" multiple="" id="hiddenKey12" style="display: none;">
                    <?php
                      if(!empty($skey12[0])){
                             for($vv12=0;$vv12<$cc12;$vv12++){?>
                                 <option id="sel_<?php echo $skey12[$vv12]?>" selected="selected" value="<?php echo $skey12[$vv12]?>"></option>
                             <?php }?>
                    <?php }?>
                </select>
                
                <?php 
                    echo $this->Form->error('sponsors_id', null, array('class' => 'error-message'));
                ?>
                <script type="text/javascript">
                  $(function() {
                    $("#standard12").customselect();
                  });
                  function removeSelection12(id){
                    //alert(id);
                    $('#selectedResult12 #sel_'+id).remove();
                    $('#hiddenKey12 #sel_'+id).remove();
                  }
                </script>

              </div>


              <div class="form-group">
              <label>Industry</label>
                <?php
                  //echo $this->Form->input('indusries_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'validate[required]form-control selectpicker form-control show-tick','id' => 'indusries_id','multiple'=>true,'type'=>'select','title'=>"No Industry Added", 'options'=>$industryLists));
                ?> 
                <span class="form-control textAreaKeyword" id="selectedResult13">
                    <ul>
                      <?php 
                        if(isset($_POST['submit'])){
                          if(isset($_POST['indusries_id'])){
                            $skey13= $_POST['indusries_id'];
                          }else{
                            $skey13=[];
                          }
                          $cc13 =count($skey13);
                          if(!empty($skey13[0])){
                                for($v13=0; $v13<$cc13; $v13++){
                                      $slids13=$skey13[$v13];
                                      //echo $slids;
                                      //echo $Keywords[$slids];
                                      echo '<li id="sel_'.$slids13.'"><a onClick="removeSelection13('.$slids13.')" href="javascript:void(0)">'.$industryLists[$slids13].'<i class="fa fa-close"></i></a></li>';
                                }
                            }
                        }
                      ?>
                    </ul>
                </span>
              
                <?php
                    echo $this->Form->input('keywordsFt', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard13','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Industry", 'options'=>$industryLists));
                ?>  
                  
                <select name="indusries_id[]" multiple="" id="hiddenKey13" style="display: none;">
                  <?php
                      if(!empty($skey13[0])){
                             for($vv13=0;$vv13<$cc13;$vv13++){?>
                                 <option id="sel_<?php echo $skey13[$vv13]?>" selected="selected" value="<?php echo $skey13[$vv13]?>"></option>
                             <?php }?>
                    <?php }?>
                </select>
                
                <?php 
                    echo $this->Form->error('indusries_id', null, array('class' => 'error-message'));
                ?>
                <script type="text/javascript">
                  $(function() {
                    $("#standard13").customselect();
                  });
                  function removeSelection13(id){
                    //alert(id);
                    $('#selectedResult13 #sel_'+id).remove();
                    $('#hiddenKey13 #sel_'+id).remove();
                  }
                </script>
              </div>

              <div class="form-group">
              <label>Portfolio Companies</label>
                <?php
                  //echo $this->Form->input('portfolios_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'validate[required]form-control selectpicker form-control show-tick','id' => 'portfolios_id','multiple'=>true,'type'=>'select','title'=>"No Portfolio Companies Added", 'options'=>$portfolioLists));
                ?> 
                <span class="form-control textAreaKeyword" id="selectedResult14">
                    <ul>
                      <?php 
                        if(isset($_POST['submit'])){
                          if(isset($_POST['portfolios_id'])){
                            $skey14= $_POST['portfolios_id'];
                          }else{
                            $skey14=[];
                          }

                          $cc14 =count($skey14);
                          if(!empty($skey14[0])){
                                for($v14=0; $v14<$cc14; $v14++){
                                      $slids14=$skey14[$v14];
                                      //echo $slids;
                                      //echo $Keywords[$slids];
                                      echo '<li id="sel_'.$slids14.'"><a onClick="removeSelection14('.$slids14.')" href="javascript:void(0)">'.$portfolioLists[$slids14].'<i class="fa fa-close"></i></a></li>';
                                }
                            }
                        }
                      ?>
                    </ul>
                </span>
              
                <?php
                    echo $this->Form->input('keywordsFft', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard14','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Portfolio Companies", 'options'=>$portfolioLists));
                ?>  
                  
                <select name="portfolios_id[]" multiple="" id="hiddenKey14" style="display: none;">
                    <?php
                      if(!empty($skey14[0])){
                             for($vv14=0;$vv14<$cc14;$vv14++){?>
                                 <option id="sel_<?php echo $skey14[$vv14]?>" selected="selected" value="<?php echo $skey14[$vv14]?>"></option>
                             <?php }?>
                    <?php }?>
                </select>
                
                <?php 
                    echo $this->Form->error('portfolios_id', null, array('class' => 'error-message'));
                ?>
                <script type="text/javascript">
                  $(function() {
                    $("#standard14").customselect();
                  });
                  function removeSelection14(id){
                    //alert(id);
                    $('#selectedResult14 #sel_'+id).remove();
                    $('#hiddenKey14 #sel_'+id).remove();
                  }
                </script>

              </div>  

              <div class="form-group">
              <label>Investment Start Date</label>
                <?php
                  echo $this->Form->input('start_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Investment Start Date','maxlength' => '50','class'=> 'testpicker form-control'));
                ?>
                <?php 
                      echo $this->Form->error('start_date', null, array('class' => 'error-message'));
                ?>
              </div>

              <div class="form-group">
              <label>Investment End Date</label>
                <?php
                  echo $this->Form->input('end_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Investment End Date','maxlength' => '50','class'=> 'testpicker form-control'));
                ?>
                <?php 
                      echo $this->Form->error('end_date', null, array('class' => 'error-message'));
                ?>
              </div>

              <div class="form-group">
              <label>Fund's Investment Closure Date</label>
                <?php
                  echo $this->Form->input('close_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>"Fund's Investment Closure Date",'maxlength' => '50','class'=> 'testpicker form-control'));
                ?>
                <?php 
                      echo $this->Form->error('close_date', null, array('class' => 'error-message'));
                ?>
              </div>

              <div class="form-group">
              <label>Keywords</label>
                <?php
                  //echo $this->Form->input('keywords_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'validate[required]form-control selectpicker form-control show-tick','id' => 'keywords_id','multiple'=>true,'type'=>'select','title'=>"No Keywords Added", 'options'=>$keywordsLists));
                ?> 
                <span class="form-control textAreaKeyword" id="selectedResult">
                    <ul>
                      <?php 
                        if(isset($_POST['submit'])){
                          if(isset($_POST['keywords_id'])){
                            $skey15= $_POST['keywords_id'];
                          }else{
                            $skey15=[];
                          }

                          $cc15 =count($skey15);
                          if(!empty($skey15[0])){
                                for($v15=0; $v15<$cc15; $v15++){
                                      $slids15=$skey15[$v15];
                                      //echo $slids;
                                      //echo $Keywords[$slids];
                                      echo '<li id="sel_'.$slids15.'"><a onClick="removeSelection('.$slids15.')" href="javascript:void(0)">'.$keywordsLists[$slids15].'<i class="fa fa-close"></i></a></li>';
                                }
                            }
                        }
                      ?>
                    </ul>
                </span>
              
                <?php
                    echo $this->Form->input('keywords6', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Keywords", 'options'=>$keywordsLists));
                ?>  
                  
                <select name="keywords_id[]" multiple="" id="hiddenKey" style="display: none;">
                    <?php
                      if(!empty($skey15[0])){
                             for($vv15=0;$vv15<$cc15;$vv15++){?>
                                 <option id="sel_<?php echo $skey15[$vv15]?>" selected="selected" value="<?php echo $skey15[$vv15]?>"></option>
                             <?php }?>
                    <?php }?>
                </select>
                
                <?php 
                    echo $this->Form->error('keywords_id', null, array('class' => 'error-message'));
                ?>
                <script type="text/javascript">
                  $(function() {
                    $("#standard").customselect();
                  });
                  function removeSelection(id){
                    //alert(id);
                    $('#selectedResult #sel_'+id).remove();
                    $('#hiddenKey #sel_'+id).remove();
                  }
                </script>

              </div>             
          
              

              
              </div>
              </div>
              <div class="col-lg-8 col-md-8 col-sm-12 ">
                <div class="upload_frame ">
                      <div class="halfDivisionleft"> 
                        <span class="form-control">Image</span>
                      </div>
                      <div class="halfDivisionright">
                      <button type="button" id="campaign_image_browse" class="uploadBtn">Upload File</button>
                      <span id="filename_camp"></span>
                        <?php
                            echo $this->Form->input('image', ARRAY('label' => false, 'id'=>'campaign_image', 'div' => false,'type' => 'file', 'style'=>'display:none;'));
                         ?>
                      </div>
                  </div>
                </div> 
              

              <div class="col-lg-8 col-md-8 col-sm-12 ">
               <div class="upload_frame " id="uploadMedia">
                <div class="halfDivisionleft"> 
                    <select class="form-control" name="file_type[]">
                          <option value="doc">DOC</option>
                     </select>
                </div>
                <div class="halfDivisionright">
                <button type="button" id="doc_browse" class="uploadBtn">Upload File</button> 
                <span id="filename_doc"></span>
                     <?php
                        echo $this->Form->input('document', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'doc_name'));
                     ?>    
                </div> 
               </div>
              </div>

              <div class="col-lg-8 col-md-8 col-sm-12 ">
               <div class="upload_frame " id="">
                <div class="halfDivisionleft"> 
                    <select class="form-control" name="file_type[]">
                          <option value="mp3">mp3</option>
                     </select>
                </div>
                <div class="halfDivisionright"> 
                <button type="button" id="mp3_browse" class="uploadBtn">Upload File</button> 
                <span id="filename_mp3"></span>
                     <?php
                        echo $this->Form->input('audio', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp3_name'));
                     ?>    
                </div> 
               </div> 
              </div>

              <div class="col-lg-8 col-md-8 col-sm-12 ">
               <div class="upload_frame " id="">
                <div class="halfDivisionleft"> 
                    <select class="form-control" name="file_type[]">
                          <option value="mp4">mp4</option>
                     </select>
                </div>
                <div class="halfDivisionright">
                <button type="button" id="mp4_browse" class="uploadBtn">Upload File</button> 
                <span id="filename_mp4"></span> 
                     <?php
                        echo $this->Form->input('video', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp4_name'));
                     ?>    
                </div> 
               </div>
              </div>
              <div class="col-lg-8 col-md-8 col-sm-12 ">
                <span style="color: red;">You can only upload the following file types .mp3, mp4 and .pdf. The maximum size for each file is 20 MB.</span>
              </div>

              <div class="col-lg-8 col-md-8 col-sm-12 ">
                <div class="form-group  pull-right">
                   <?= $this->Form->button('Submit',['name'=>'submit','class'=> 'customBtn blueBtn']) ?>
                </div>
             </div>
          </div>
         <?= $this->Form->end() ?>
        </div>
        <!-- /#page-content-wrapper --> 


        

<script>
$(document).ready(function () {

    $('#target_amount').priceFormat({
          prefix: '$'
    });

 });

//Upload triger
$('#campaign_image_browse').click(function(){ $('#campaign_image').trigger('click'); });
$("#campaign_image").change(function(){
  var filename = $('#campaign_image').val();
  $('#filename_camp').html(filename);
}); 

$('#doc_browse').click(function(){ $('#doc_name').trigger('click'); });
$("#doc_name").change(function(){
  var filename = $('#doc_name').val();
  $('#filename_doc').html(filename);
}); 

$('#mp3_browse').click(function(){ $('#mp3_name').trigger('click'); });
$("#mp3_name").change(function(){
  var filename = $('#mp3_name').val();
  $('#filename_mp3').html(filename);
});

$('#mp4_browse').click(function(){ $('#mp4_name').trigger('click'); });
$("#mp4_name").change(function(){
  var filename = $('#mp4_name').val();
  $('#filename_mp4').html(filename);
});

$('.testpicker').datetimepicker({
  timepicker:false,
  format:'F d, Y',
  minDate: 0,
  scrollInput: false
});

// Add More Media Options

$('#addMoreMedia').click(function(e) {
   var y =1;
   var cdivId= 'myMedia_'+y;
   var divId= "'"+cdivId+"'";
   var mediaList = $('#uploadMedia').html();

   $('<div class="upload_frame" id="myMedia_'+y+'">'+mediaList+' <a href="javascript:void(0)" id="remScnt" onclick="bindAlertOwn('+divId+')" class="remove_field">Remove</a></div>').insertBefore('#addMedia');
   y++;
});

//Remove Appended HTML
function bindAlertOwn(count){
   $('#'+count).remove();

}

</script>