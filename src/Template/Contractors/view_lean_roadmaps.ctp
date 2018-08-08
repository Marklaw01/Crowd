 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Lean Startup Roadmap', array('controller'=>'Contractors','action'=>'leanRoadmaps'), array('escape'=>false));
                ?></li>
                <li class="active">View Lean Startup Roadmap<sup>R</sup></li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-8 col-md-8 col-sm-8 '>
              <div class="page_heading">
               <h1>View Lean Startup Roadmap<sup>R</sup></h1> 
              </div>
            </div> 
            <div class='col-lg-2 col-md-2 col-sm-2 '>
              <div class="page_heading-lean">
              <?php if(!empty($leanRoadmapList->sample_link)){ $sample_link= $leanRoadmapList->sample_link;}else{$sample_link='sample_doc_file.pdf';}?> 
                <a href="<?php $this->request->webroot;?>/img/sampledoc/<?php echo $sample_link;?>" target="_blank">Sample</a>
              </div>
            </div>
            <div class='col-lg-2 col-md-2 col-sm-2 '>
              <div class="page_heading-lean">
                <a href="<?php $this->request->webroot;?>/img/sampledoc/<?php echo $leanRoadmapList->template_link;?>" target="_blank">Template</a>
              </div>
            </div>
          </div>
          
          <!-- Content Begains -->    
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12 ">
              <div class="roadmap-description" id=""> 
              <div class="page_heading">
                <h4><?php echo $leanRoadmapList->title;?></h4>
              </div>  
              <p><?php echo $leanRoadmapList->description;?></p>
              </div>
            </div>  
          </div>         
 </div>
 <script type="text/javascript">
   $(document).on("click",".recBlock", function () {
       var clickedBtnID = $(this).attr('id'); // or var clickedBtnID = this.id
       $(".roadmap-description").hide(1000);
       $("#roadmap"+clickedBtnID).show(1000);
       //alert('you clicked on button #' + clickedBtnID);
    });
 </script>
 <!-- /#page-content-wrapper --> 
