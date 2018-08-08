<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('My Forum', array('controller'=>'Forums','action'=>'myForum'), array('escape'=>false));
                ?></li>
                <li class="active">Edit Forum</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Edit Forum</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <?= $this->Form->create($forum,['id'=>'FormField', 'enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">

               <div class="form-group">
               <?php
                  echo $this->Form->input('startup_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'selectpicker form-control show-tick','id' => 'startup_id','type'=>'select','title'=>"Select Startup", 'options'=>$startups));
                ?> 
                <?php 
                      echo $this->Form->error('startup_id', null, array('class' => 'error-message'));
                ?>
                
              </div>

              <div class="form-group">
                <?php
                  echo $this->Form->input('title', ARRAY('label' => false, 'div' => false, 'error' => false, 'id' => '','placeholder'=>'Title','class' => 'form-control'));
                ?>
                <?php 
                      echo $this->Form->error('title', null, array('class' => 'error-message'));
                ?>
              </div>
              

                <?php
                  //$sKey= explode(',', $forum->keywords);
                  //echo $this->Form->input('keywords', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','value'=>$sKey,'type'=>'select','title'=>'Keywords', 'data-size'=>'5', 'multiple'=>'""', 'options'=>$Keywords));
                ?>
                
              <div class="form-group">
                  <span class="form-control textAreaKeyword" id="selectedResult">
                      <ul>
                      <?php 
                      $skey= explode(',', $forum->keywords);
                      $cc =count($skey);
                          if(!empty($skey[0])){
                                for($vi=0; $vi<$cc; $vi++){
                                      $slids=$skey[$vi];
                                      //echo $slids;
                                      //echo $Keywords[$slids];
                                      echo '<li id="sel_'.$slids.'"><a onClick="removeSelection('.$slids.')" href="javascript:void(0)">'.$Keywords[$slids].'<i class="fa fa-close"></i></a></li>';
                                }
                            }
                      ?>
                         
                      </ul>
                  </span>
              
                  <?php
                    $cc =count($skey);
                      echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard','type'=>'select','title'=>'Keywords','multiple'=>false, 'size'=>'','empty'=>'Select Keyword', 'options'=>$Keywords));
                  ?>  
                  
                  <select name="keywords[]" multiple="" id="hiddenKey" style="display: none;">
                  <?php
                    if(!empty($skey[0])){
                           for($i=0;$i<$cc;$i++){?>
                               <option id="sel_<?php echo $skey[$i]?>" selected="selected" value="<?php echo $skey[$i]?>"></option>
                           <?php }?>
                    <?php }?> 
                  </select>
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

                <?php 
                      echo $this->Form->error('keywords', null, array('class' => 'error-message'));
                ?>
              </div>

              <div class="form-group">
              <label>Upload Image</label>
              <div class="image-Holder">
              <?php if(!empty($forum->image)){?>
              <img alt="" src="<?php echo $this->request->webroot;?>img/forums/<?php echo $forum->image;?>">
              <?php } else {?>
              <img alt="" src="<?php echo $this->request->webroot;?>images/forum-dummy.png">
              <?php }?>
              </div>

              <input id="file" type="file">
              <button  type="button" id="roadmapImage" class="uploadBtn">Browse Image</button>
                    <span class="imgUpload alignCenter" id="imgUpload"></span>
                    <?php
                        echo $this->Form->input('image', ARRAY('label' => false, 'div' => false,'type' => 'file','style'=>'display:none;','id'=>'roadmap_graphic'));
                    ?>
              </div>
              <div class="form-group">
                 <?php
                    echo $this->Form->input('description', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Description','class' => 'form-control'));
                 ?>
                 <?php 
                      echo $this->Form->error('description', null, array('class' => 'error-message'));
                ?>
                 
              </div>
              </div>
              
             
              <div class="col-lg-8 col-md-8 col-sm-12 ">
                   <?php
                      if($forum->user_status ==1){
                           echo $this->Html->link('Back', array('controller'=>'Forums','action'=>'archivedForum'), array('escape'=>false,'class'=>'customBtn blueBtn  pull-left'));
                      }else {
                           echo $this->Html->link('Back', array('controller'=>'Forums','action'=>'myForum'), array('escape'=>false,'class'=>'customBtn blueBtn  pull-left'));
                      }       
                    ?>
                <div class="form-group  pull-right">
                      <?= $this->Form->button('Save Forum',['class'=> 'customBtn blueBtn']) ?>
                </div>
             </div>
          </div>
          <?= $this->Form->end() ?>  
        </div>
        <!-- /#page-content-wrapper --> 

<script>
$(document).ready(function () {

$('#roadmapImage').click(function(){ $('#roadmap_graphic').trigger('click'); });

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            var nameImg = $('#roadmap_graphic').val(); 
            reader.onload = function (e) {
                //$('#imgUpload').attr('src', e.target.result);
                $('#imgUpload').html(nameImg);
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }
    $("#roadmap_graphic").change(function(){
        var ext = $('#roadmap_graphic').val().split('.').pop().toLowerCase();
        if($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) { 
           $('#imgUpload').html('Invalid! Allowed extensions are .jpg, .jpeg, .gif, .png.. Max upload size 2MB');
          //$('<div id="custerro" class="message error" onclick="return closeError();">Invalid! These files extension are allowed: .jpg, .jpeg, .gif, .png</div>').insertBefore('.container-fluid');
        }else {
           readURL(this);
        }
    });

});
</script>