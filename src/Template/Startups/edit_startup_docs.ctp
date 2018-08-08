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
                <li class="active">Startup Docs</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Startup Docs</h1> 
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
                  <li role="presentation"><a href="#overview" aria-controls="overview" role="tab" data-toggle="tab" onclick="location.href='<?php echo $ovrVw;?>'">Overview</a></li>
                  <?php
                  $teaM= $this->Url->build(["controller" => "Startups","action" => "editStartupTeam",$startupId]);
                  ?>
                  <li role="presentation"><a href="#team" aria-controls="team" role="tab" data-toggle="tab" onclick="location.href='<?php echo $teaM;?>'">Team</a></li>
                  <?php
                  $workOrd= $this->Url->build(["controller" => "Startups","action" => "editStartupWorkorder",$startupId]);
                  ?>
                  <li role="presentation" ><a href="#workOrder" aria-controls="workOrder" role="tab" data-toggle="tab" onclick="location.href='<?php echo $workOrd;?>'">Billed Work Orders</a></li>
                  <?php
                  $dcs= $this->Url->build(["controller" => "Startups","action" => "editStartupDocs",$startupId]);
                  ?>
                  <li role="presentation" class="active"><a href="#docs" aria-controls="docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $dcs;?>'">Docs</a></li>
                  <?php
                  $roadDcs= $this->Url->build(["controller" => "Startups","action" => "editStartupRoadmapdocs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#roadmap-docs" aria-controls="roadmap-docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $roadDcs;?>'">Roadmap Docs</a></li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane whiteBg" id="overview">

                  </div>
                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="team">
                     
                  </div>
                   <!--  3Tab -->
                  <div id="workOrder" class="tab-pane whiteBg" role="tabpanel">
 
                  </div>
                   <!--  4Tab -->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="docs">
                      <div class="links"> 
                      <?php
                          echo $this->Html->link('<i class="fa fa-copy"></i>Add ', array('controller'=>'Startups','action'=>'addStartupDocs',$startupId), array('escape'=>false, 'class'=>'customBtn blueBtn'));
                      ?>
                       
                         </div>
                     <div class="table-responsive">
                         <table class="table table-striped startup-list">
                            <thead>
                              <tr>
                                <th>Name</th>
                                <th>Date</th>
                                <th>Doc Name</th>
                                <th>Roadmap</th>
                                <th>Actions</th>
                              </tr>
                                              
                            </thead>
                            <tbody>
                            <?php $c=0; foreach($startupDocLists as $startupDocList) { $c++;?>
                              <tr>
                                    <td>
                                      <?php 
                                            if(!empty($startupDocList->user->entrepreneur_basic)) {
                                              echo $startupDocList->user->entrepreneur_basic->first_name.' '.$startupDocList->user->entrepreneur_basic->last_name ; 
                                            }else {
                                              echo $startupDocList->user->first_name.' '.$startupDocList->user->last_name ;
                                            }
                                      ?>
                                    </td>  
                                    <td><?php echo date_format($startupDocList->created,"F m, Y");?> </td> 
                                    <td><?php echo $startupDocList->name;?> </td> 
                                    <td><?php echo $startupDocList->roadmap->name;?> </td> 
                                    <td>
                                    <?php if($startupDocList->user_id==$UserId){?>
                                      <?php
                                      //echo $startupDocList->file_path;
                                          //echo $this->Html->link('<i class="fa fa-eye"></i>View ', array('controller'=>'Startups','action'=>'editStartupUploadedDocs',base64_encode($startupDocList->id),$startupId), array('escape'=>false, 'class'=>'smallCurveBtn blueBtn customBtn'));
                                      ?>

                                      <?php
                                          echo $this->Html->link('<i class="fa fa-pencil"></i>Edit ', array('controller'=>'Startups','action'=>'editStartupUploadedDocs',base64_encode($startupDocList->id),$startupId), array('escape'=>false, 'class'=>'smallCurveBtn blueBtn customBtn'));
                                      ?>
                                      <?php 

                                         echo $this->Form->postLink('Delete',['action' => 'deleteUploadedDocs', base64_encode($startupDocList->id)],['id'=>'delPost'.$c,'class'=>'smallCurveBtn blueBtn customBtn ']);
                                      ?>
                                      <script type="text/javascript">
                                       $(document).ready(function () {
                                           $('#delPost<?php echo $c;?>').html('<i class="fa fa-trash-o"></i> Delete');
                                        });   
                                      </script>

                                      <?php 

                                         echo $this->Form->postLink('Download',['action' => 'downloadStartupDoc', base64_encode($startupDocList->id)],['id'=>'downPost'.$c,'class'=>'smallCurveBtn blueBtn customBtn ']);
                                         ?>
                                         <script type="text/javascript">
                                       $(document).ready(function () {
                                           $('#downPost<?php echo $c;?>').html('<i class="fa fa-download"></i> Download');
                                        });   
                                      </script>


                                      <?php }else {?>

                                      <?php 

                                         echo $this->Form->postLink('Download',['action' => 'downloadStartupDoc', base64_encode($startupDocList->id)],['id'=>'downPost'.$c,'class'=>'smallCurveBtn blueBtn customBtn ']);
                                         ?>
                                         <script type="text/javascript">
                                       $(document).ready(function () {
                                           $('#downPost<?php echo $c;?>').html('<i class="fa fa-download"></i> Download');
                                        });   
                                      </script>
                                      
                                      <?php } ?>

                                    <!--<a href="<?php //echo $this->request->webroot.'img/roadmap/'.$startupDocList->file_path;?>" target="_blank" class="smallCurveBtn blueBtn customBtn"><i class="fa fa-download"></i> Download</a>-->
                                    </td> 
                              </tr>

                            <?php } ?>  
                                             
                            </tbody>
     
                         </table>
                      </div>
                    <nav>
                      <ul class="pagination pagination-sm">
                        <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                        <li><?= $this->Paginator->numbers() ?></li>
                        <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                      </ul>
                    </nav>
                  
                   <div class="clearfix"></div>
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

