<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Campaigns', array('controller'=>'campaigns','action'=>'myCampaign'), array('escape'=>false));
                ?></li>
                <li class="active">Edit Campaign</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1><?php echo $campaign->campaigns_name;?></h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <?php $cId= base64_encode($campaign->id);
            //$url= $this->Url->build(["action" => "edit",$cId]); ?>
          <?= $this->Form->create($campaign,['enctype' => 'multipart/form-data','url'=>'/campaigns/edit/'.$cId.'']) ?>
          <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-12 ">
                    
                    <div class="form-group">
                    <label>Campaign Name</label>
                        <?php
                          echo $this->Form->input('campaigns_name', ARRAY('label' => false, 'div' => false, 'error' => false, 'id' => '','placeholder'=>'Campaign Name','class' => 'form-control'));
                        ?>
                        <?php 
                              echo $this->Form->error('campaigns_name', null, array('class' => 'error-message'));
                        ?>
                    </div>
               
                        
                    <div class="form-group">
                    <label>Select Startup</label>
                        <?php
                          echo $this->Form->input('startup_id', ARRAY('label' => false, 'div' => false, 'error' => false, 'class' => 'selectpicker form-control show-tick','id' => 'startup_id','type'=>'select','title'=>"Select Startup", 'options'=>$startups));
                        ?> 
                        <?php 
                              echo $this->Form->error('startup_id', null, array('class' => 'error-message'));
                        ?>
                    </div>    
                        <?php
                          //$sKey= explode(',', $campaign->keywords);
                          //echo $this->Form->input('keywords', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','title'=>'Keywords', 'data-size'=>'5', 'multiple'=>'""','value'=>$sKey, 'options'=>$Keywords));
                        ?>
                    <div class="form-group">
                    <label>Target Market</label>
                          <span class="form-control textAreaKeyword" id="selectedResult1">
                              <ul>
                              <?php 
                              $skey= explode(',', $campaign->keywords);
                              $cc =count($skey);
                                  if(!empty($skey[0])){
                                        for($vi=0; $vi<$cc; $vi++){
                                              $slids=$skey[$vi];
                                              //echo $slids;
                                              //echo $Keywords[$slids];
                                              echo '<li id="sel_'.$slids.'"><a onClick="removeSelection1('.$slids.')" href="javascript:void(0)">'.$Keywords[$slids].'<i class="fa fa-close"></i></a></li>';
                                        }
                                    }
                              ?>
                                 
                              </ul>
                          </span>
                      
                          <?php
                            $cc =count($skey);
                              echo $this->Form->input('keywordsTwo', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard1','type'=>'select','title'=>'Target Market','multiple'=>false, 'size'=>'','empty'=>'Target Market', 'options'=>$Keywords));
                          ?>  
                          
                        <select name="keywords[]" multiple="" id="hiddenKey1" style="display: none;">
                          <?php
                            if(!empty($skey[0])){
                                   for($i=0;$i<$cc;$i++){?>
                                       <option id="sel_<?php echo $skey[$i]?>" selected="selected" value="<?php echo $skey[$i]?>"></option>
                                   <?php }?>
                            <?php }?> 
                        </select>
                        <script type="text/javascript">
                            $(function() {
                              $("#standard1").customselect();
                            });
                            function removeSelection1(id){
                              //alert(id);
                              $('#selectedResult1 #sel_'+id).remove();
                              $('#hiddenKey1 #sel_'+id).remove();
                            }
                        </script>

                        <?php 
                              echo $this->Form->error('keywords', null, array('class' => 'error-message'));
                        ?>      
                    </div>

                    <div class="form-group">
                    <label>Campaign Keyword</label>
                        <span class="form-control textAreaKeyword" id="selectedResult2">
                            <ul>
                            <?php 
                              $skey2= explode(',', $campaign->campaign_keywords);
                              $cc2 =count($skey2);
                                  if(!empty($skey2[0])){
                                        for($vij=0; $vij<$cc2; $vij++){
                                              $slids2=$skey2[$vij];
                                              //echo $slids;
                                              //echo $Keywords[$slids];
                                              echo '<li id="sel_'.$slids2.'"><a onClick="removeSelection2('.$slids2.')" href="javascript:void(0)">'.$campKeywords[$slids2].'<i class="fa fa-close"></i></a></li>';
                                        }
                                    }
                              ?>
                            </ul>
                        </span>
                    
                        <?php
                            echo $this->Form->input('keywordsTwo2', ARRAY('label' => false, 'div' => false, 'class' => 'form-control  scrollable custom-select', 'id' => 'standard2','type'=>'select','title'=>'Campaign Keyword','multiple'=>false, 'size'=>'','empty'=>'Campaign Keyword', 'options'=>$campKeywords));
                        ?>  
                        
                        <select name="campaign_keywords[]" multiple="" id="hiddenKey2" style="display: none;">
                            <?php
                            if(!empty($skey2[0])){
                                   for($ik=0;$ik<$cc2;$ik++){?>
                                       <option id="sel_<?php echo $skey2[$ik]?>" selected="selected" value="<?php echo $skey2[$ik]?>"></option>
                                   <?php }?>
                            <?php }?>
                        </select>
                        <?php 
                          echo $this->Form->error('campaign_keywords', null, array('class' => 'error-message'));
                        ?>
                        <script type="text/javascript">
                                $(function() {
                                  $("#standard2").customselect();
                                });
                                function removeSelection2(id){
                                  //alert(id);
                                  $('#selectedResult2 #sel_'+id).remove();
                                  $('#hiddenKey2 #sel_'+id).remove();
                                }
                        </script>
                    </div>


                    <div class="form-group">
                    <label>Due Date</label>
                        <?php
                          echo $this->Form->input('due_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'due_date','type'=>'text','placeholder'=>'Due Date','maxlength' => '50','class'=> 'testpicker form-control'));
                        ?>
                        <?php 
                              echo $this->Form->error('due_date', null, array('class' => 'error-message'));
                        ?>
                    </div>
                    <div class="form-group">
                    <label>Target Amount</label>
                        <?php
                        $target_amount= $campaign->target_amount;
                          echo $this->Form->input('target_amount', ARRAY('label' => false, 'div' => false,'error' => false, 'placeholder'=>'Target Amount','class' => 'form-control', 'type'=>'text','id'=>'target_amount','value'=>$this->Number->precision($target_amount,2)));
                        ?>
                        <?php 
                              echo $this->Form->error('target_amount', null, array('class' => 'error-message'));
                        ?>
                    </div>
                    <div class="form-group">
                    <label>Fund Raised So Far</label>
                        <span class="form-control">
                          <?php //echo $fund_raised_so_far= '$'.$this->Number->precision($campaign->fund_raised_so_far,2); ?>
                          $<?php $DonatedAmount = $this->Custom->getCampaignTotalDonatedAmountByID($campaign->id);
                              echo $this->Number->precision($DonatedAmount,2);
                          ?>
                         </span>
                        <?php
                        $fund_raised_so_far= $campaign->fund_raised_so_far;
                          // echo $this->Form->input('fund_raised_so_far', ARRAY('label' => false, 'error' => false, 'div' => false,'class' => 'form-control','placeholder'=>'Fund Raised So Far', 'type'=>'text','id'=>'fund_raised_so_far'));
                        ?>
                        <?php 
                              echo $this->Form->error('fund_raised_so_far', null, array('class' => 'error-message'));
                        ?>
                    </div>
                    <div class="form-group">
                    <label>Summary</label>
                         <?php
                            echo $this->Form->input('summary', ARRAY('label' => false, 'div' => false,'error' => false,'type' => 'textarea','placeholder'=>'Summary','class' => 'form-control fix-width'));
                         ?>
                         <?php 
                              echo $this->Form->error('summary', null, array('class' => 'error-message'));
                        ?> 
                    </div>


                         <div class="upload_frame " id="uploadMedia">
                          <div class="halfDivisionleft"> 
                              <select class="form-control" name="file_type[]">
                                    <option value="doc">PDF</option>
                               </select>
                          </div>
                          <div class="halfDivisionright">
                          <button type="button" id="doc_browse" class="uploadBtn">Upload File</button> 
                          <span id="filename_doc"></span>
                               <?php
                                  echo $this->Form->input('files[]', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'doc_name'));
                               ?>    
                          </div> 
                         </div>
                         <!--<span id="addMedia"><a href="javascript:void(0)" id="addMoreMedia">Add More</a></span>-->
                       

                         
                       

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
                                  echo $this->Form->input('files[]', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp4_name'));
                               ?>    
                          </div> 
                         </div>
                       

              </div>
              <div class="col-lg-6 col-md-6 col-sm-12 ">
                  <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                                    <div class="panel panel-default">
                                      <div class="panel-heading" role="tab" id="headingOne">
                                        <h4 class="panel-title">
                                          <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                            Campaign Graphic
                                          </a>
                                        </h4>
                                      </div>
                                      <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="panel-body">
                                          <div class="image-Holder">
                                            <?php if(!empty($campaign->campaign_image)){?>
                                              <img src="<?php echo $this->request->webroot.'img/campaign/'.$campaign->campaign_image;?>" alt="Campaign Image">
                                            <?php } ?>
                                          </div>
                                          <?php
                                            echo $this->Form->input('campaign_image', ARRAY('label' => false, 'div' => false,'type' => 'file','style'=>'display:none;','id'=>'campaign_image'));
                                          ?>
                                          <button id='campaignImage' class=" customBtn  greyBtn alignCenter mver20" type="button"><i class="fa  fa-cloud-upload"></i>Upload Campaign Graphic</button>
                                          <span class="imgUpload alignCenter" id="imgUpload"></span>
                                          </div>
                                      </div>
                                    </div>
                                     <div class="panel panel-default">
                                      <div class="panel-heading" role="tab" id="headingTwo">
                                        <h4 class="panel-title">
                                          <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                           View Documents
                                          </a>
                                        </h4>
                                      </div>
                                      <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                        <div class="panel-body">
                                         <ul class="listing ">
                                            <?php 
                                              $cDocs=json_decode($campaign->file_path);
                                                $cD = count($cDocs); 
                                                $d=1;
                                                  for ($i=0; $i<$cD; $i++) {
                                                      $dType=$cDocs[$i]->file_type;
                                                      if($dType=='doc'){

                                                      //echo $delteLink= $this->Html->link(__('<i class="fa fa-trash-o"></i>'), ['action' => 'deleteDoc', base64_encode($campaign->id),base64_encode($i)],['confirm' => __('Are you sure you want to delete ? ')]);

                                                        echo '<li> Document '.$d.'<a href="'.$this->request->webroot.'img/campaign/'.$cDocs[$i]->name.'" target="_blank" class="view alignRight"><i class="fa fa-eye"></i></a>';

                                                        echo $this->Html->link('<i class="fa fa-trash-o"></i>', array('action'=>'deleteDoc', base64_encode($campaign->id),base64_encode($i)), array('escape'=>false,'class'=>'remove alignRight'));

                                                        echo '</li>';
                                                        //echo '<span class="campaign-errors" style="color:green;">'.$viewType.' - '.$cDocs[$i]->name.'</span> ';
                                                  $d++;   } 
                                                  }   
                                          ?>
                                           
                                         </ul>
                                        </div>
                                      </div>
                                </div>
                                 <div class="panel panel-default">
                                  <div class="panel-heading" role="tab" id="headingTwo">
                                    <h4 class="panel-title">
                                      <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                       Play Audio
                                      </a>
                                    </h4>
                                  </div>
                                  <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                    <div class="panel-body">
                                     <ul class="listing ">
                                          <?php 
                                              $cDocs=json_decode($campaign->file_path);
                                                $cD = count($cDocs);
                                                $m3=1;
                                                   for ($i=0; $i<$cD; $i++) {
                                                        $dType=$cDocs[$i]->file_type;
                                                        if($dType=='mp3'){
                                                              
                                                          //echo '<li>Audio <a href="'.$this->request->webroot.'img/campaign/'.$cDocs[$i]->name.'" target="_blank" class="view alignRight"><i class="fa fa-eye"></i></a><a href="#" class="remove alignRight"><i class="fa fa-trash-o"></i></a>';

                                                        echo '<li> Audio '.$m3.'<a href="'.$this->request->webroot.'img/campaign/'.$cDocs[$i]->name.'" target="_blank" class="view alignRight"><i class="fa fa-eye"></i></a>';

                                                        echo $this->Html->link('<i class="fa fa-trash-o"></i>', array('action'=>'deleteDoc', base64_encode($campaign->id),base64_encode($i)), array('escape'=>false,'class'=>'remove alignRight'));

                                                        echo '</li>';
                                                         
                                                    $m3++;   } 
                                                  } 
                                        ?>
                                      
                                     </ul>
                                    </div>
                                  </div>
                                </div>
                                 <div class="panel panel-default">
                                  <div class="panel-heading" role="tab" id="headingTwo">
                                    <h4 class="panel-title">
                                      <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                                        Play Video
                                      </a>
                                    </h4>
                                  </div>
                                  <div id="collapseFour" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                    <div class="panel-body">
                                     <ul class="listing">
                                        <?php 
                                              $cDocs=json_decode($campaign->file_path);
                                                $cD = count($cDocs);
                                                $m4=1;
                                                   for ($i=0; $i<$cD; $i++) {
                                                       $dType=$cDocs[$i]->file_type;
                                                        if($dType=='mp4'){
                                                              
                                                          //echo '<li>Video <a href="'.$this->request->webroot.'img/campaign/'.$cDocs[$i]->name.'" target="_blank" class="view alignRight"> <i class="fa fa-eye"></i></a><a href="#" class="remove alignRight"><i class="fa fa-trash-o"></i></a>';

                                                         echo '<li> Video '.$m4.'<a href="'.$this->request->webroot.'img/campaign/'.$cDocs[$i]->name.'" target="_blank" class="view alignRight"><i class="fa fa-eye"></i></a>';

                                                        echo $this->Html->link('<i class="fa fa-trash-o"></i>', array('action'=>'deleteDoc', base64_encode($campaign->id),base64_encode($i)), array('escape'=>false,'class'=>'remove alignRight'));

                                                        echo '</li>';

                                                     $m4++;   }  
                                                   } 
                                          ?>
                                                                             
                                     </ul>
                                    </div>
                                  </div>
                                </div>
                                 <div class="panel panel-default">
                                  <div class="panel-heading" role="tab" id="headingTwo">
                                    <h4 class="panel-title">
                                      <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseFive" aria-expanded="false" aria-controls="collapseFive">
                                        View Contractors
                                      </a>
                                    </h4>
                                  </div>
                                  <div id="collapseFive" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                                    <div class="panel-body">
                                        <div class="table-responsive">
                                         <table class="table table-striped contractor_list">
                                            <thead>
                                              <tr>
                                                <th>Image</th>
                                                <th>Name</th>
                                                <th>Contribution</th>
                                                <th>Timeperiod</th>
                                                <th>Action</th>
                                              </tr>
                                              
                                            </thead>
                                            <tbody>
                                              <?php //pr($donContractors);
                                                foreach($donContractors as $donContractor){

                                                  //check donation amount public private
                                                  if($userId != $campaign->user_id){
                                                    if($donContractor->status == 0){
                                                     $DonAmount= '$'.$this->Number->precision($donContractor->amount,2);
                                                    }else {
                                                      $DonAmount='xxxx.xx';
                                                    }
                                                  }else {
                                                    $DonAmount= '$'.$this->Number->precision($donContractor->amount,2);
                                                  }  

                                                  //check user image is blank or not
                                                  $UserImage = $this->Custom->getUserImageByID($donContractor->user->id);
                                                  if(!empty($UserImage[0]['image'])){
                                                    $imagePath= $this->request->webroot.'img/profile_pic/'.$UserImage[0]['image'];
                                                  }else {
                                                    $imagePath= $this->request->webroot.'images/dummy-man.png';
                                                  }
                                              ?>    
                                                  <tr>
                                                      <td><div class="userImage circle-img-contractor"><img src="<?php echo $imagePath;?>"></div></td>
                                                      <td><?php echo $donContractor->user->first_name.' '.$donContractor->user->last_name;?></td>
                                                      <td><?php echo $DonAmount;?></td>
                                                      <td><?php echo $donContractor->donation_timeperiod->timeperiod.' '.$donContractor->donation_timeperiod->type;?>
                                                      <td>

                                                      <?php
                                                        $remDon= $this->Url->build(["controller" => "Campaigns","action" => "deleteDonation",base64_encode($donContractor->id)]);
                                                      ?>
                                                        <a href="#remove" onclick="location.href='<?php echo $remDon;?>'"><i class="fa fa-remove"></i></a>
                                                      </td>
                                                  </tr>

                                              <?php } ?>
                                              
                                            </tbody>
     
                                          </table>
                                         </div> 
                                    </div>
                                  </div>
                                </div>

                                
                                    
                  </div>
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
                                  echo $this->Form->input('files[]', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'mp3_name'));
                               ?>    
                          </div> 
                    </div> 

                    <!-- Custom code show upload error -->
                                <?php $view= base64_decode($view); 
                                      if($view =='first' or $view=='editview'){
                                        $cError=json_decode($campaign['errors']);
                                        $c= count($cError);
                                           for ($i=0; $i<$c; $i++) {
                                            echo '<div class="form-group"><span class="campaign-errors" style="color:red;">'.$cError[$i].'</span></div>';
                                          }

                                      }
                               ?>
              </div>
              
              <div class="col-lg-12 col-md-12 col-sm-12 ">
                <div class="form-group  pull-right">
                  <?= $this->Form->button('Update Campaign',['class'=> 'customBtn blueBtn']) ?>
                </div>
             </div>
          </div>
         <?= $this->Form->end() ?>
        </div>

  

<script>
$(document).ready(function () {
       //Custom jquery for fund raised
       $('#target_amount').priceFormat({
          prefix: '$'
       });

      /*var amount1 = '<?php echo $target_amount; ?>';
      var ii = parseFloat(amount1);
      if(isNaN(ii)) { ii = 0.00; }
      var minus = '';
      if(ii < 0) { minus = '-'; }
      ii = Math.abs(ii);
      ii = parseInt((ii + .005) * 100);
      ii = ii / 100;
      ss = new String(ii);
      if(ss.indexOf('.') < 0) { ss += '.00'; }
      if(ss.indexOf('.') == (ss.length - 2)) { ss += '0'; }
      ss = minus + ss; //alert(ss);
      $('#target_amount').val(ss);*/

      

      /*$( "#target_amount" ).change(function() {
          var amount = $(this).val();
          var i = parseFloat(amount);
          if(isNaN(i)) { i = 0.00; }
          var minus = '';
          if(i < 0) { minus = '-'; }
          i = Math.abs(i);
          i = parseInt((i + .005) * 100);
          i = i / 100;
          s = new String(i);
          if(s.indexOf('.') < 0) { s += '.00'; }
          if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
          s = minus + s;
          $('#target_amount').val(s);

      });**/
      //Custom price formarting
      /*$( "#target_amount" ).change(function() {
                var amount = $(this).val();
                var amount = amount.toString().replace("$", ""), output = [], formatted = null;
                var amount = amount.toString().replace(",", "")
                parts = amount.split(".");
                amount = parts[0];
                var i = parseFloat(amount);
                if(isNaN(i)) { i = 0.00; }
                var minus = '';
                if(i < 0) { minus = '-'; }
                i = Math.abs(i);
                i = parseInt((i + .005) * 100);
                i = i / 100;
                s = new String(i);

                str = amount.split("").reverse();
                for(var j = 0, len = str.length; j < len; j++) {
                    if(str[j] != ",") {
                        output.push(str[j]);
                        if(i%3 == 0 && j < (len - 1)) {
                            output.push(",");
                        }
                        i++;
                    }
                }
                s = output.reverse().join("");
                if(s.indexOf('.') < 0) { s += '.00'; }
                if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
                //alert(s);
                s = minus + s;
                $('#target_amount').val('$'+s);

      });*/


      //Custom jquery for fund raised
      var amount = '<?php echo $fund_raised_so_far; ?>';
      var i = parseFloat(amount);
      if(isNaN(i)) { i = 0.00; }
      var minus = '';
      if(i < 0) { minus = '-'; }
      i = Math.abs(i);
      i = parseInt((i + .005) * 100);
      i = i / 100;
      s = new String(i);
      if(s.indexOf('.') < 0) { s += '.00'; }
      if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
      s = minus + s; //alert(s);
      $('#fund_raised_so_far').val(s);

      $( "#fund_raised_so_far" ).change(function() {
          var amount = $(this).val();
          var i = parseFloat(amount);
          if(isNaN(i)) { i = 0.00; }
          var minus = '';
          if(i < 0) { minus = '-'; }
          i = Math.abs(i);
          i = parseInt((i + .005) * 100);
          i = i / 100;
          s = new String(i);
          if(s.indexOf('.') < 0) { s += '.00'; }
          if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
          s = minus + s;
          $('#fund_raised_so_far').val(s);

      });
 });

///
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


/// Image change 
$('#campaignImage').click(function(){ $('#campaign_image').trigger('click'); });

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            var nameImg = $('#campaign_image').val(); 
            reader.onload = function (e) {
                //$('#imgUpload').attr('src', e.target.result);
                $('#imgUpload').html(nameImg);
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }
    $("#campaign_image").change(function(){
        var ext = $('#campaign_image').val().split('.').pop().toLowerCase();
        if($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) {
          $('<div id="custerro" class="message error" onclick="return closeError();">Invalid! These files extension are allowed: .jpg, .jpeg, .gif, .png</div>').insertBefore('.container-fluid');
        }else {
           readURL(this);
        }
    });



$('.testpicker').datetimepicker({
  timepicker:false,
  format:'F d, Y',
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
function closeError(){
  $('#custerro').addClass('hide');
}
//Remove Appended HTML
function bindAlertOwn(count){
   $('#'+count).remove();

}

</script>




