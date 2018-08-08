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
                <li class="active">Startup Workorders</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Startup Workorders</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs campaignsTab" role="tablist">
                  <?php
                  $ovrVw= $this->Url->build(["controller" => "Startups","action" => "viewStartupOverview",$startupId]);
                  ?>
                  <li role="presentation"><a href="#overview" aria-controls="overview" role="tab" data-toggle="tab" onclick="location.href='<?php echo $ovrVw;?>'">Overview</a></li>
                  <?php
                  $teaM= $this->Url->build(["controller" => "Startups","action" => "viewStartupTeam",$startupId]);
                  ?>
                  <li role="presentation"><a href="#team" aria-controls="team" role="tab" data-toggle="tab" onclick="location.href='<?php echo $teaM;?>'">Team</a></li>
                  <?php
                  $workOrd= $this->Url->build(["controller" => "Startups","action" => "viewStartupWorkorder",$startupId]);
                  ?>
                  <li role="presentation"  class="active"><a href="#workOrder" aria-controls="workOrder" role="tab" data-toggle="tab" onclick="location.href='<?php echo $workOrd;?>'">Billed Work Orders</a></li>
                  <?php
                  $dcs= $this->Url->build(["controller" => "Startups","action" => "viewStartupDocs",$startupId]);
                  ?>
                  <li role="presentation"><a href="#docs" aria-controls="docs" role="tab" data-toggle="tab" onclick="location.href='<?php echo $dcs;?>'">Docs</a></li>
                  
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
                  <div id="workOrder" class="tab-pane whiteBg active" role="tabpanel">
                    <?php 

                        echo $this->Form->postLink('Download work orders',['action' => 'ContractorExcelDownload', $startupId,$week_no,$dateYear],['id'=>'dwnPost','class'=>'customBtn blueBtn']);
                      ?>
                      <script type="text/javascript">
                        $(document).ready(function () {
                            $('#dwnPost').html('<i class="fa fa-download"></i>Download work orders');
                        });   
                      </script>   
                    <div class="fixed-first-coloumn">

                      <?php
                          $dt = new DateTime;
                            if (isset($dateYear) && isset($week_no)) {
                                  $dt->setISODate(''.$dateYear.'', ''.$week_no.'');
                            } else {
                                  $dt->setISODate($dt->format('o'), $dt->format('W'));
                            }
                              $year = $dt->format('o');
                              $week = $dt->format('W');
                      ?>
                              
                     <div class="table-responsive mver20 ">
                         <table class="table table-striped startup-list">
                            <thead>
                              <tr>
                                <th>
                                <?php
                                $preWeek= $this->Url->build(["controller" => "Startups","action" => "viewStartupWorkorder",$startupId,$week_no-1,$dateYear]);
                                ?>
                                <?php
                                $nextWeek= $this->Url->build(["controller" => "Startups","action" => "viewStartupWorkorder",$startupId,$week_no+1,$dateYear]);
                                ?>
                                <a href="<?php echo $preWeek; ?>" class="weekArrow" title="Previous Week"> << </a> 
                                <?php echo $from; ?>
                                <a href="<?php echo $nextWeek; ?>" class="weekArrow" title="Next Week"> >> </a> 
                                </th>

                                <?php 
                                $CoutRodIds='';
                                if(!empty($hiredRoadmapIds)){
                                    $hiredRoadmapIdsArray= explode(',',$hiredRoadmapIds);
                                    $CoutRodIds= count($hiredRoadmapIdsArray);
                                    foreach($roadmaps as $roadmap){ 
                                        if(in_array($roadmap['id'], $hiredRoadmapIdsArray)){
                                ?>
                                                <th><?php echo $roadmap['name'];?></th>
                                        <?php } ?>
                                    <?php } ?>
                                <?php }else {  ?>
                                      <th>No Roadmap Found.</th>
                                <?php } ?>
                              </tr>
                            </thead>
                            <tbody>
                              <?php
                            
                              do {
                                  echo '<tr>';
                                  echo '<td>
                                  <span class="months">'.$dt->format('D').'</span>'.$dt->format('F d, Y').'</td>';

                                  $workCount= count($workorderlits['weekly_update']);
                                  for($i=0;$i<$workCount; $i++){
                                     $InnerCountWork= count ($workorderlits['weekly_update'][$i]);
                                     for($j=0;$j<$InnerCountWork;$j++){

                                         if($dt->format('Y-m-d') ==$workorderlits['weekly_update'][$i][$j]['date']){
                                          echo '<td>';
                                          if(!empty($workorderlits['weekly_update'][$i][$j]['deliverables'])){
                                            //echo $workorderlits[$i][$j]['deliverables'][0]['deliverable_name'];
                                            echo $workorderlits['weekly_update'][$i][$j]['deliverables'][0]['work_units'];
                                           
                                          }else {
                                            echo "0";
                                          }
                                          echo '</td>';
                                        }  

                                     }

                                  }
                                  
                                echo '</tr>';
                                  $dt->modify('+1 day');
                                  } 
                              while ($week == $dt->format('W'));
                              ?>
                              
                               
                               <tr>
                                <td>Total</td>
                                <td><?php echo $workorderlits['unapproved_consumedHours']; //echo $workorderlits['consumedHours'];?></td>
                                <?php
                                if($CoutRodIds>1){
                                  for($v=0;$v<$CoutRodIds-1;$v++){
                                    echo '<td>-</td>';
                                  
                                  }
                                }  
                                ?>
                              </tr>
                               <tr>
                                <td>Remaining</td>
                                <td><?php echo $workorderlits['Approved_hours']-$workorderlits['consumedHours']; ?>
                                <?php //echo $workorderlits['Allocated_hours']-$workorderlits['consumedHours']; ?></td>
                                <?php
                                if($CoutRodIds>1){
                                  for($j=0;$j<$CoutRodIds-1;$j++){
                                    echo '<td>-</td>';
                                  
                                  }
                                }  
                                ?>
                                
                              </tr>
                               <tr>
                                <td>Allocated</td>
                                <td><?php echo $workorderlits['Approved_hours'];?>
                                <?php //echo $workorderlits['Allocated_hours'];?></td>
                                
                                
                              </tr>
                            </tbody>
                         </table>
                     </div>
                     </div>

                  <!-- if user is suspended or removed hide functionality-->
                  <?php if($userApprovStatus == 1){ ?>
                  <div class="links mver20">
                    <?php
                       $updateLink= $this->Url->build(["controller" => "Startups","action" => "updateStartupWorkorder",$startupId,$week_no,$dateYear]);
                    ?>
                    <a href="<?php echo $updateLink;?>" title="Update work orders" class="customBtn greenBtn">Update work orders</a>
                  </div>
              	<?php } ?> 

  
                
                <?= $this->Form->create($updateWorkUnits,['enctype' => 'multipart/form-data']) ?>


                	<div class="row">
	                   <div class="col-md-12 col-sm-12 col-xs-12">
	                    	<div class="form-group">
	                   			<label>Entrepreneur Comment :</label>
	                   			<span class="form-control textArea">
		                   			<?php if(!empty($workorderRatingListEntrewpreneur)){
	                                    	echo $workorderRatingListEntrewpreneur->description;
	                                	}
	                            	?>
	                   			</span>
	                   		</div>	
	                   </div>      
	                </div>

	                <div class="form-group">
                  		<label>Rating Star :</label>
		                    <div id="stars-default">
			                  	<?php
			                  	if(!empty($workorderRatingListEntrewpreneur)){
		                      		 $star= $workorderRatingListEntrewpreneur->rating_star;
		                      	}else{
		                      		$star=0;
		                      	}

			                    	//echo $this->Form->input('rating_star', ['label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'id' => 'rating_star','type'=>'hidden']);
			                    ?>
		                    </div> 
		                  		<?php 
		                            //echo $this->Form->error('rating_star', null, array('class' => 'error-message'));
		                  		?> 
		            </div> 

                    <div class="row">
	                    <div class="col-md-12 col-sm-12 col-xs-12">
	                    	<div class="form-group">
	                    		<label>Contractor Comment :</label>
		                      	<?php
		                      	if(!empty($workorderRatingList)){
		                      		 $description= $workorderRatingList->description;
		                      	}else{
		                      		$description='';
		                      	}		                      		
		                        	if(!empty($daysLeft)){ 
		                        		echo $this->Form->input('work_comment', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'work_comment','type'=>'textarea','placeholder'=>'Comment','value' => $description,'class'=> 'form-control'));
		                      	
		                            	echo $this->Form->error('work_comment', null, array('class' => 'error-message'));
		                            }else{
		                              echo '<span class="form-control textArea">';
		                                  echo $description;
		                              echo '</span>';    
		                            } 
		                      	?>
		                    </div>  
	                    </div>
					</div> 

					<?php if(!empty($daysLeft)){   ?>
	                    <div class="row">
		                    <div class="col-md-12 col-sm-12 col-xs-12">
		                    	<div class="form-group">
				                    <div class="links mver20">
				                    	<?= $this->Form->button('Save',['name'=>'submit','class'=> 'customBtn greenBtn pull-right']) ?>
				                    </div>
				                </div>
				            </div>
				        </div>  
			        <?php } ?>
			        <?php $weekNo= $week_no.'_'.$dateYear;?>
			        <?php
			            echo $this->Form->input('week_no', ['label' => false, 'div' => false,'error' => false,'type'=>'hidden','value'=>$weekNo]);

			            echo $this->Form->input('given_by', ['label' => false, 'div' => false,'error' => false,'type'=>'hidden','value'=>$UserId]);

			            if($UserId == $workorderlits['entrepreneur_id']){
			            	echo $this->Form->input('given_to', ['label' => false, 'div' => false,'error' => false,'type'=>'hidden','value'=>$workorderlits['contractor_id']]);

			            	echo $this->Form->input('is_entrepreneur', ['label' => false, 'div' => false,'error' => false,'type'=>'hidden','value'=>1]);

			            }else{
			            	echo $this->Form->input('given_to', ['label' => false, 'div' => false,'error' => false,'type'=>'hidden','value'=>$workorderlits['entrepreneur_id']]);

			            	echo $this->Form->input('is_entrepreneur', ['label' => false, 'div' => false,'error' => false,'type'=>'hidden','value'=>0]);
			        	}
			            echo $this->Form->input('startup_id', ['label' => false, 'div' => false,'error' => false,'type'=>'hidden','value'=>$startupId]);
			        ?>           

                <?= $this->Form->end() ?> 
                   
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
$('.testpicker').datetimepicker({
  timepicker:false,
  format:'F d, Y',
  scrollInput: false
});


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
<script>
$(document).ready(function () {
    $('#hourly_price').priceFormat({
          prefix: '$'
    });
});

(function ( $ ) {
 
    $.fn.rating = function( method, options ) {
    method = method || 'create';
        // This is the easiest way to have default options.
        var settings = $.extend({
            // These are the defaults.
      limit: 10,
      value: <?php echo $star?>,
      glyph: "glyphicon-star",
            coloroff: "gray",
      coloron: "gold",
      size: "2.0em",
      cursor: "default",
      onClick: function () {},
            endofarray: "idontmatter"
        }, options );
    var style = "";
    style = style + "font-size:" + settings.size + "; ";
    style = style + "color:" + settings.coloroff + "; ";
    style = style + "cursor:" + settings.cursor + "; ";
  

    
    if (method == 'create')
    {
      //this.html('');  //junk whatever was there
      
      //initialize the data-rating property
      this.each(function(){
        attr = $(this).attr('data-rating');
        if (attr === undefined || attr === false) { $(this).attr('data-rating',settings.value); }
      })
      
      //bolt in the glyphs
      for (var i = 0; i < settings.limit; i++)
      {
        this.append('<span data-value="' + (i+1) + '" class="ratingicon glyphicon ' + settings.glyph + '" style="' + style + '" aria-hidden="true"></span>');
      }
      
      //paint
      this.each(function() { paint($(this)); });

    }
    if (method == 'set')
    {
      this.attr('data-rating',options);
      this.each(function() { paint($(this)); });
    }
      if (method == 'get')
      {
        return this.attr('data-rating');
      }
      
      //register the click events
      /*this.find("span.ratingicon").click(function() {
        rating = $(this).attr('data-value')
        $(this).parent().attr('data-rating',rating);
        paint($(this).parent());
        settings.onClick.call( $(this).parent() );
      })*/

      function paint(div)
      {
        rating = parseInt(div.attr('data-rating'));
        div.find("input").val(rating);  //if there is an input in the div lets set it's value
        div.find("span.ratingicon").each(function(){  //now paint the stars
          
          var rating = parseInt($(this).parent().attr('data-rating'));
          var value = parseInt($(this).attr('data-value'));
          if (value > rating) { $(this).css('color',settings.coloroff); }
          else { $(this).css('color',settings.coloron); }
        })
      }

    };
 
}( jQuery ));

$(document).ready(function(){

  $("#stars-default").rating();

});
</script>

