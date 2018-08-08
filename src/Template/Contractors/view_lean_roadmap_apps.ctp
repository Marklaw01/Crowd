
 <div class="container-fluid roadmap-description-apps">
          <!-- breadcrumb ends --> 
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
