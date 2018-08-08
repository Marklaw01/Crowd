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
                <li class="active">Startup Overview</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Startup Overview</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="startup-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs campaignsTab" role="tablist">
                  <?php
                  $ovrVw= $this->Url->build(["controller" => "Startups","action" => "editStartupOverview",$startupId]);
                  ?>
                  <li role="presentation" class="active"><a href="#overview" aria-controls="overview" role="tab" data-toggle="tab" onclick="location.href='<?php echo $ovrVw;?>'">Overview</a></li>
                  <?php
                  $teaM= $this->Url->build(["controller" => "Startups","action" => "editStartupTeam",$startupId]);
                  ?>
                  <li role="presentation"><a href="#team" aria-controls="team" role="tab" data-toggle="tab" onclick="location.href='<?php echo $teaM;?>'">Team</a></li>
                  <?php
                  $workOrd= $this->Url->build(["controller" => "Startups","action" => "editStartupWorkorder",$startupId]);
                  ?>
                  <li role="presentation"><a href="#workOrder" aria-controls="workOrder" role="tab" data-toggle="tab" onclick="location.href='<?php echo $workOrd;?>'">Billed Work Orders</a></li>
                  <?php
                  $dcs= $this->Url->build(["controller" => "Startups","action" => "editStartupDocs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#docs" aria-controls="docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $dcs;?>'">Docs</a></li>
                  <?php
                  $roadDcs= $this->Url->build(["controller" => "Startups","action" => "editStartupRoadmapdocs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#roadmap-docs" aria-controls="roadmap-docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $roadDcs;?>'">Roadmap Docs</a></li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="overview">
                   <?= $this->Form->create($startup,['id'=>'FormField', 'enctype' => 'multipart/form-data']) ?>
                      <div class="row"> 
                        <div class="col-lg-8 col-md-8 col-sm-12 ">
                            <div class="form-group">
                            <label>Startup Name</label>
                                <?php
                                  echo $this->Form->input('name', ARRAY('label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'Startup Name','class' => 'form-control','value'=>$startup->name));
                                ?>
                                <?php 
                                  echo $this->Form->error('name', null, array('class' => 'error-message'));
                                ?>
                            </div>
                            <div class="form-group">
                            <label>Description</label>
                                <?php
                                      echo $this->Form->input('description', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'Description','maxlength' => '5000','value'=>$startup->description));
                                ?>
                                <?php 
                                  echo $this->Form->error('description', null, array('class' => 'error-message'));
                                ?>
      
                            </div>

                            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                                              <div class="panel panel-default">
                                                <div class="panel-heading" role="tab" id="headingOne">
                                                  <h4 class="panel-title">
                                                    <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                                      Roadmap Graphic
                                                    </a>
                                                  </h4>
                                                </div>
                                                <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                                  <div class="panel-body">
                                                    <div class="image-Holder">
                                                    <?php if(!empty($startup->roadmap_graphic)){?>
                                                        <img src="<?php echo $this->request->webroot;?>img/roadmap/<?php echo $startup->roadmap_graphic;?>" alt="">
                                                    <?php }else{ ?>
                                                        <img src="<?php echo $this->request->webroot;?>images/roadMap.png" alt="">
                                                    <?php } ?>
                                                    </div>
                                                    <button  id="roadmapImage" type="button" class=" customBtn greyBtn alignCenter mver20"><i class="fa  fa-cloud-upload"></i>Upload Roadmap Graphic</button> 
                                                    <span class="imgUpload alignCenter" id="imgUpload"></span>
                                                    <?php
                                                      echo $this->Form->input('roadmap_graphic', ARRAY('label' => false, 'div' => false,'type' => 'file','style'=>'display:none;','id'=>'roadmap_graphic'));
                                                    ?>

                                                  </div>
                                                </div>
                                              </div>
                                              <div class="panel panel-default">
                                                <div class="panel-heading" role="tab" id="headingTwo">
                                                  <h4 class="panel-title">
                                                    <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                                      Roadmap Deliverables
                                                    </a>
                                                  </h4>
                                                </div>
                                                <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                                  <div class="panel-body">
                                                   <ul class="listing">
                                                   <?php if(!empty($customRoadmaps)){
                                                          foreach($customRoadmaps as $customRoadmap) {
                                                            if(!empty($customRoadmap['file_path'])){

                                                                echo '<li id="'.$customRoadmap['roadmap_id'].'" class="road_completed"> <a href="'.$this->request->webroot.$customRoadmap['file_path'].'" target="_blank" title="View Doc">'.$customRoadmap['name'].'</a></li>';

                                                             }else {

                                                              echo '<li  id="'.$customRoadmap['roadmap_id'].'">'.$customRoadmap['name'].'</li>';
                                                              

                                                             } 
                                                          }
                                                    }else{
                                                  ?>

                                                   <?php foreach($roadmaps as $roadmap) {?>
                                                     <li id="<?php echo $roadmap->id; ?>"> 
                                                     <?php echo $roadmap->name; ?>
                                                     </li>
                                                   <?php } ?>  

                                                   <?php } ?>
                                                   </ul>
                                                  </div>
                                                </div>
                                              </div>
                                              
                            </div> 
                            <!--accordian --> 

                            <div class="form-group">
                            <label>Next Step</label>
                               <span class="form-control">
                                <?php if(!empty($startup->next_step)){
                                          echo $startup->next_step;
                                      }else {
                                        echo "Next Step";
                                      }
                                ?>
                               </span>
                            </div>

                            <?php
                                //$sKey= explode(',', $startup->keywords);
                                //echo $this->Form->input('keywords', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'multiple' => '""', 'title'=>'Keywords','data-size'=>'10','value'=>$sKey, 'type'=>'select','options' => $Keywords));
                            ?>
                                  
                            <div class="form-group">
                            <label>Select Keywords</label>
                                <span class="form-control textAreaKeyword" id="selectedResult">
                                    <ul>
                                    <?php 
                                    $skey= explode(',', $startup->keywords);
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
                            <label>Support Required</label>
                                <?php
                                  echo $this->Form->input('support_required', ARRAY('label' => false,'error' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'Support Required','maxlength' => '100','value'=>$startup->support_required));
                                ?>
                                 <?php 
                                      echo $this->Form->error('support_required', null, array('class' => 'error-message'));
                                  ?> 
                            </div>
                            
                            <?php if(!empty($funded_by)){?> 
                              <div class="form-group">
                                  <span class="pull-right" style="color: #056a1f; margin-bottom: 2px;">Funded By : <?php echo $funded_by;?></span>
                              </div>
                            <?php } ?>

                            <div class="clearfix" ></div>
                            <div class="form-group">
                               <?= $this->Form->button('Update',['class'=> 'customBtn blueBtn  pull-right']) ?>
                            </div>
                       </div>
                      </div>
                  <?= $this->Form->end() ?>
         
                  </div>
                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="team">
                     
                  </div>
                   <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="workOrder">                  
                   
                  </div>
                   <!--  4Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="docs">
 
                  </div>
                    <!--  5Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="roadmap-docs">

                  </div>


                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /#page-content-wrapper --> 


<?php
     //echo $this->Form->input('roadmap_id', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'Support Required','maxlength' => '50','options'=> $roadmap,'empty'=>'Select Roadmap'));
?>
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

