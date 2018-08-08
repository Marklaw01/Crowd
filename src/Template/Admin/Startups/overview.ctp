<div id="page-content-wrapper">
<div class="container-fluid">
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
            <h1 class="page-header"><i class=" fa fa-arrow-circle-up"></i>Startup's Overview
            </h1>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs campaignsTab" role="tablist">
                  <?php
                  $ovrVw= $this->Url->build(["controller" => "Startups","action" => "overview",$startupId]);
                  ?>
                  <li role="presentation" class="active"><a href="#overview" aria-controls="overview" role="tab" data-toggle="tab" onclick="location.href='<?php echo $ovrVw;?>'">Overview</a></li>
                  <?php
                  $teaM= $this->Url->build(["controller" => "Startups","action" => "team",$startupId]);
                  ?>
                  <li role="presentation"><a href="#team" aria-controls="team" role="tab" data-toggle="tab" onclick="location.href='<?php echo $teaM;?>'">Team</a></li>
                  <?php
                  $workOrd= $this->Url->build(["controller" => "Startups","action" => "workorder",$startupId]);
                  ?>
                  <li role="presentation"><a href="#workOrder" aria-controls="workOrder" role="tab" data-toggle="tab" onclick="location.href='<?php echo $workOrd;?>'">Work Orders</a></li>
                  <?php
                  $dcs= $this->Url->build(["controller" => "Startups","action" => "docs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#docs" aria-controls="docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $dcs;?>'">Docs</a></li>

                  <?php
                  $roadDcs= $this->Url->build(["controller" => "Startups","action" => "roadmapdocs",$startupId]);
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
                                <span class="form-control">
                                    <?php 
                                      if(!empty($startup->name)){
                                          echo $startup->name;
                                      }else {
                                          echo 'Startup Name';
                                      } 
                                    ?>
                                </span>    
                            </div>

                            <div class="form-group">
                            <label>Description</label>
                                <span class="form-control textArea">
                                    <?php 
                                      if(!empty($startup->description)){
                                          echo $startup->description;
                                      }else {
                                          echo 'Description';
                                      } 
                                    ?>
                                </span>
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

                                                                echo '<li id="'.$customRoadmap['roadmap_id'].'"> <a href="'.$this->request->webroot.$customRoadmap['file_path'].'" target="_blank" title="View Doc">'.$customRoadmap['name'].'</a></li>';

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
                            <div class="form-group">
                                <label>Keywords</label>
                                <span id="selectedResult" class="form-control textArea">
                                <ul>
                                    <?php
                                      $skey= explode(',', $startup->keywords);
                                        $cskey=count($skey);
                                          if(!empty($skey[0])){
                                            for($i=0; $i<$cskey; $i++){
                                                $slids=$skey[$i];
                                                   //echo $Keywords[$slids].', ';id="selectedResult"
                                                    echo '<li id="sel_'.$slids.'"><a href="javascript:void(0)">'.$Keywords[$slids].'</a></li>';
                                             }
                                          }else {
                                                   echo 'Keywords';
                                          }
                                    ?>
                                </ul>    
                                </span>   
                            </div>

                            <div class="form-group">
                            <label>Support Required</label>
                              <span class="form-control">
                                <?php if(!empty($startup->support_required)){
                                          echo $startup->support_required;
                                      }else {
                                        echo "Support Required";
                                      }
                                ?>
                               </span> 
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
</div>        
        <!-- /#page-content-wrapper --> 


<?php
     //echo $this->Form->input('roadmap_id', ARRAY('label' => false, 'div' => false, 'class' => '', 'id' => '','placeholder'=>'Support Required','maxlength' => '50','options'=> $roadmap,'empty'=>'Select Roadmap'));
?>


