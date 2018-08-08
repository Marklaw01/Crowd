 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li class="active">Lean Startup Roadmap<sup>R</sup></li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Lean Startup Roadmap<sup>R</sup></h1> 
              </div>
            </div>
            <div class='col-lg-3 col-md-3 col-sm-3 '>
              <div class="page_heading-lean">
                <?php $venturL= $this->Url->build(["controller" => "Contractors","action" => "ventureCapital"]); ?>
                <h1><a href="<?php echo $venturL;?>" target="_blank">Venture Capital</a></h1> 
              </div>
            </div>
            <div class='col-lg-3 col-md-3 col-sm-3 '>
              <div class="page_heading-lean">
                <?php $roadmapTemplate= $this->request->webroot.'img/sampledoc/0.0_Lean_Startup_Roadmap_Template_v8.0.pdf';?>

                <h1><a href="<?php echo $roadmapTemplate;?>" target="_blank">Roadmap Template</a></h1> 
              </div>
            </div>   
          </div>
          
          <!-- Content Begains -->
          <section class="roadmap">
             <div class="topLinks">
              <?php $i=0; foreach ($leanRoadmapList as $key => $value) { 
                if($value->position =='R1' or $value->position =='R2'){
                  if($value->position =='R1'){ 
                    $class='roadmapBlock-60top'; $class2='verUpLine-135H'; $color='greenBlock'; $image='height140.png';
                  }else{ 
                    $class='roadmapBlock-150top'; $class2='verUpLine-60H'; $color='orangeBlock'; $image='height60.png';
                  }
                  $i++;
                  $aboveLink= $this->Url->build(["controller" => "Contractors","action" => "viewLeanRoadmaps",base64_encode($value->id)]);
              ?>  
                    <div class="roadmapBlock <?php echo $class;?> Block-<?php echo $i;?>">
                      <a id="Id-<?php echo $value->id;?>" target="_blank" class="recBlock <?php echo $color;?>" href="<?php echo $aboveLink;?>">
                      <?php echo $value->title;?>
                      </a>
                      <div class="verUpLine <?php echo $class2;?>">
                        <img src="<?php echo $this->request->webroot;?>images/<?php echo $image;?>" />
                      </div>
                    </div>
                <?php } // End of R1 and R2 If?>
              <?php } ?> 
            </div>   

          <!-- section topLinks--> 
          <div class="bottomLinks">

              <?php $v=0; foreach ($leanRoadmapList as $key => $valueBottom) { 
                if($valueBottom->position =='R3' or $valueBottom->position =='R4'){
                  if($valueBottom->position =='R3'){ 
                    $class='roadmapBlock-256top'; $class2='verbtmLine-60H'; $color='orangeBlock'; $image2='height60.png';
                  }else{ 
                    $class='roadmapBlock-256top'; $class2='verbtmLine-135H'; $color='greenBlock'; $image2='height140.png';
                  }
                  $v++;
                  $belowLink= $this->Url->build(["controller" => "Contractors","action" => "viewLeanRoadmaps",base64_encode($valueBottom->id)]);
              ?>  
                    <div class="roadmapBlock <?php echo $class;?> Block-<?php echo $v;?>">
                      <div class="verbtmLine <?php echo $class2;?>">
                        <img src="<?php echo $this->request->webroot;?>images/<?php echo $image2;?>" />
                      </div>
                      <a id="Id-<?php echo $valueBottom->id;?>" target="_blank" class="recBlock <?php echo $color;?>" href="<?php echo $belowLink;?>">
                      <?php echo $valueBottom->title;?>
                      </a>
                    </div>
                <?php } // End of R1 and R2 If?>
              <?php } ?>

            </div> 
          </section>  
          <div class="row">
              <div class="col-lg-12 col-md-12 col-sm-12 ">
                <h1 style="text-align: center;" class="lic-attri">
                  <a class="customBtn blueBtn" target="_blank" href="https://creativecommons.org/licenses/by-nc-sa/4.0/" style="color: rgb(241, 241, 246);">License - Required Attribution: © <?php echo date("Y"); ?> Crowd Bootstrap</a>
                </h1>
              </div>
            </div> 
                   
          <!-- <div class="row">
            <?php foreach ($leanRoadmapList as $key => $valueDesc) { ?>
              <div class="roadmap-description" id="roadmapId-<?php echo $valueDesc->id;?>" style="display: none;"> 
              <div class="page_heading">
                <h4><?php echo $valueDesc->title;?></h4>
              </div>  
              <p><?php echo $valueDesc->description;?></p>
              </div>
            <?php } ?>  
          </div>   -->       
 </div>
 <script type="text/javascript">
   /*$(document).on("click",".recBlock", function () {
       var clickedBtnID = $(this).attr('id'); // or var clickedBtnID = this.id
       $(".roadmap-description").hide(1000);
       $("#roadmap"+clickedBtnID).show(1000);
       //alert('you clicked on button #' + clickedBtnID);
    });*/
 </script>
 <!-- /#page-content-wrapper --> 
