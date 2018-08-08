<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Opportunities', array('controller'=>'BetaTesters','action'=>'index'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('My Focus Groups', array('controller'=>'FocusGroups','action'=>'myFocusGroup'), array('escape'=>false));
                ?></li>
                <li class="active">Edit Focus Group</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-12 '>
             <div class="page_heading">
               <h1>Edit Focus Group</h1> 
              </div>
            </div>

            <div class='col-lg-6 col-md-6 col-sm-12 '>
              <div class="form-group pull-right">
                <?php 
                    $class= 'greenBtn';
                    $titleCommit='Search Recommended Focus Groups';
                    $CommitLink= $this->Url->build(["controller" => "FocusGroups","action" => "searchRecommendedContacts"]);
                ?>
                <button class="customBtn <?php echo $class;?>" type="button" onclick="location.href='<?php echo $CommitLink;?>'"><?php echo $titleCommit;?></button>
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <?= $this->Form->create($fund,['enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
              

              <div class="form-group">
              <label>Focus Group Title</label>
                <?php
                  echo $this->Form->input('title', ARRAY('label' => false, 'div' => false, 'error' => false, 'id' => '','placeholder'=>'Focus Group Title','class' => 'form-control','type'=>'text','value'=>$fundDetails->title));
                ?>
                <?php 
                      echo $this->Form->error('title', null, array('class' => 'error-message'));
                ?>
              </div>

               <div class="form-group">
              <label>Focus Group Description</label>
                 <?php
                    echo $this->Form->input('description', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Focus Group Description','class' => 'form-control','value'=>$fundDetails->description));
                 ?>
                 <?php 
                      echo $this->Form->error('description', null, array('class' => 'error-message'));
                ?>
              </div>
              
              <div class="form-group">
              <label>Focus Group Start Date</label>
                <?php
                  echo $this->Form->input('start_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Focus Group Start Date','maxlength' => '50','class'=> 'testpicker form-control','value'=>$fundDetails->start_date));
                ?>
                <?php 
                      echo $this->Form->error('start_date', null, array('class' => 'error-message'));
                ?>
              </div>

              <div class="form-group">
              <label>Focus Group End Date</label>
                <?php
                  echo $this->Form->input('end_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Focus Group End Date','maxlength' => '50','class'=> 'testpicker form-control','value'=>$fundDetails->end_date));
                ?>
                <?php 
                      echo $this->Form->error('end_date', null, array('class' => 'error-message'));
                ?>
              </div>

              

              <div class="form-group">
              <label>Target Market</label>
                <?php
                  //$FS= explode(',', $fundDetails->target_market);
                  //echo $this->Form->input('target_market', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'validate[required]form-control selectpicker form-control show-tick','id' => 'target_market','multiple'=>true,'type'=>'select','title'=>"No Target Market Added",'value'=>$FS, 'options'=>$targetMarketLists));
                ?> 
                
                <span class="form-control textAreaKeyword" id="selectedResult21">
                    <ul>
                    <?php 
                        if(isset($_POST['submit'])){
                          if(isset($_POST['target_market'])){
                            $skey21= $_POST['target_market'];
                          }else{
                            $skey21=explode(',', $fundDetails->target_market);
                          }

                        }else{
                            $skey21=explode(',', $fundDetails->target_market);
                        }
                        
                        $cc21 =count($skey21);
                        if(!empty($skey21[0])){
                              for($v21=0; $v21<$cc21; $v21++){
                                    $slids21=$skey21[$v21];
                                    //echo $slids;
                                    //echo $Keywords[$slids];
                                    echo '<li id="sel_'.$slids21.'"><a onClick="removeSelection21('.$slids21.')" href="javascript:void(0)">'.$targetMarketLists[$slids21].'<i class="fa fa-close"></i></a></li>';
                              }
                          }
                    ?>
                    </ul>
                </span>
              
                <?php
                    echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard21','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Target Market", 'options'=>$targetMarketLists));
                ?>  
                  
                <select name="target_market[]" multiple="" id="hiddenKey21" style="display: none;">
                    <?php
                      if(!empty($skey21[0])){
                             for($vv21=0;$vv21<$cc21;$vv21++){?>
                                 <option id="sel_<?php echo $skey21[$vv21]?>" selected="selected" value="<?php echo $skey21[$vv21]?>"></option>
                             <?php }?>
                    <?php }?>
                </select>

                <?php 
                    echo $this->Form->error('target_market', null, array('class' => 'error-message'));
                ?>
                <script type="text/javascript">
                  $(function() {
                    $("#standard21").customselect();
                  });
                  function removeSelection21(id){
                    //alert(id);
                    $('#selectedResult21 #sel_'+id).remove();
                    $('#hiddenKey21 #sel_'+id).remove();
                  }
                </script>

              </div>

              <div class="form-group">
              <label>Focus Group Keywords</label>
                <?php
                  //$FK= explode(',', $fundDetails->focus_group_keywords_id);
                  //echo $this->Form->input('focus_group_keywords_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'validate[required]form-control selectpicker form-control show-tick','id' => 'focus_group_keywords_id','multiple'=>true,'type'=>'select','title'=>"No Focus Group Keywords Added",'value'=>$FK, 'options'=>$keywordsLists));
                ?> 
                
                <span class="form-control textAreaKeyword" id="selectedResult31">
                    <ul>
                    <?php 
                      if(isset($_POST['submit'])){
                          if(isset($_POST['focus_group_keywords_id'])){
                            $skey31= $_POST['focus_group_keywords_id'];
                          }else{
                            $skey31=explode(',', $fundDetails->focus_group_keywords_id);
                          }

                        }else{
                            $skey31=explode(',', $fundDetails->focus_group_keywords_id);
                        }
                        
                        $cc31 =count($skey31);
                        if(!empty($skey31[0])){
                              for($v31=0; $v31<$cc31; $v31++){
                                    $slids31=$skey31[$v31];
                                    //echo $slids;
                                    //echo $Keywords[$slids];
                                    echo '<li id="sel_'.$slids31.'"><a onClick="removeSelection31('.$slids31.')" href="javascript:void(0)">'.$keywordsLists[$slids31].'<i class="fa fa-close"></i></a></li>';
                              }
                          }
                    ?>
                    </ul>
                </span>
              
                <?php
                    echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard31','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Keywords", 'options'=>$keywordsLists));
                ?>  
                  
                <select name="focus_group_keywords_id[]" multiple="" id="hiddenKey31" style="display: none;">
                    <?php
                      if(!empty($skey31[0])){
                             for($vv31=0;$vv31<$cc31;$vv31++){?>
                                 <option id="sel_<?php echo $skey31[$vv31]?>" selected="selected" value="<?php echo $skey31[$vv31]?>"></option>
                             <?php }?>
                    <?php }?>
                </select>

                <?php 
                    echo $this->Form->error('focus_group_keywords_id', null, array('class' => 'error-message'));
                ?>
                <script type="text/javascript">
                  $(function() {
                    $("#standard31").customselect();
                  });
                  function removeSelection31(id){
                    //alert(id);
                    $('#selectedResult31 #sel_'+id).remove();
                    $('#hiddenKey31 #sel_'+id).remove();
                  }
                </script>
                
              </div>  

              <div class="form-group">
              <label>Interest Keywords</label>
                <?php
                   //$FM= explode(',', $fundDetails->focus_group_interest_keywords_id);
                  //echo $this->Form->input('focus_group_interest_keywords_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'validate[required]form-control selectpicker form-control show-tick','id' => 'focus_group_interest_keywords_id','multiple'=>true,'type'=>'select','title'=>"No Interest Keywords Added",'value'=>$FM, 'options'=>$intrestKeywordLists));
                ?> 
                
                <span class="form-control textAreaKeyword" id="selectedResult22">
                    <ul>
                    <?php 
                      if(isset($_POST['submit'])){
                          if(isset($_POST['focus_group_interest_keywords_id'])){
                            $skey22= $_POST['focus_group_interest_keywords_id'];
                          }else{
                            $skey22=explode(',', $fundDetails->focus_group_interest_keywords_id);
                          }

                        }else{
                            $skey22=explode(',', $fundDetails->focus_group_interest_keywords_id);
                        }
                        
                        $cc22 =count($skey22);
                        if(!empty($skey22[0])){
                              for($v22=0; $v22<$cc22; $v22++){
                                    $slids22=$skey22[$v22];
                                    //echo $slids;
                                    //echo $Keywords[$slids];
                                    echo '<li id="sel_'.$slids22.'"><a onClick="removeSelection22('.$slids22.')" href="javascript:void(0)">'.$intrestKeywordLists[$slids22].'<i class="fa fa-close"></i></a></li>';
                              }
                          }
                    ?>
                    </ul>
                </span>
              
                <?php
                    echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard22','type'=>'select','multiple'=>false, 'size'=>'','empty'=>"Select Interest Keywords", 'options'=>$intrestKeywordLists));
                ?>  
                  
                <select name="focus_group_interest_keywords_id[]" multiple="" id="hiddenKey22" style="display: none;">
                    <?php
                      if(!empty($skey22[0])){
                             for($vv22=0;$vv22<$cc22;$vv22++){?>
                                 <option id="sel_<?php echo $skey22[$vv22]?>" selected="selected" value="<?php echo $skey22[$vv22]?>"></option>
                             <?php }?>
                    <?php }?>
                </select>

                <?php 
                    echo $this->Form->error('focus_group_interest_keywords_id', null, array('class' => 'error-message'));
                ?>
                <script type="text/javascript">
                  $(function() {
                    $("#standard22").customselect();
                  });
                  function removeSelection22(id){
                    //alert(id);
                    $('#selectedResult22 #sel_'+id).remove();
                    $('#hiddenKey22 #sel_'+id).remove();
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