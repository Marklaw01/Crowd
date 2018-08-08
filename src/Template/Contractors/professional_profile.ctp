<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li class="active">My Profile</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>My Profile</h1> 
              </div>
            </div>
            <div class='col-lg-6 col-md-6 col-sm-6'>
              <div class="profileName">
                 <?php
                      $entrepre = '<i><img src="'.$this->request->webroot.'images/professional.png" alt=""></i>';
                      echo $this->Html->link( $entrepre .'ENTREPRENEUR', array('controller'=>'Entrepreneurs','action'=>'myProfile'), array('escape'=>false,'class'=>'navbar-brand'));
                  ?>
                  <?php
                      $entrepre = '<i><img src="'.$this->request->webroot.'images/users.png" alt=""></i>';
                      echo $this->Html->link( $entrepre .'CONTRACTOR', array('controller'=>'Contractors','action'=>'myProfile'), array('escape'=>false,'class'=>'active'));
                  ?>
              </div>
            </div>
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="about-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav aboutTab nav-tabs" role="tablist">

                  <li role="presentation">
                  <?php //echo $this->Html->link("BASIC",ARRAY('controller'=>'contractors','action'=>'MyProfile'),ARRAY('class'=>"focus",'aria-controls'=>'about1', 'role'=>'tab1', 'data-toggle'=>'tab1'));
                  $basic= $this->Url->build(["controller" => "contractors","action" => "MyProfile"]);
                  ?>
                  <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="about" href="#basic" data-parent="" aria-expanded="true" onclick="location.href='<?php echo $basic;?>'">BASIC</a>

                  </li>

                  <li role="presentation" class="active">
                    <?php //echo $this->Html->link("PROFESSIONAL",ARRAY('controller'=>'contractors','action'=>'ProfessionalProfile'),ARRAY('class'=>"",'aria-controls'=>'about1', 'role'=>'tab1', 'data-toggle'=>'tab1'));
                    $profess= $this->Url->build(["controller" => "contractors","action" => "ProfessionalProfile"]);
                    ?>

                    <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="mission" href="#professional" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $profess;?>'">PROFESSIONAL</a>
                  </li>
                  <li role="presentation">
                  <?php //echo $this->Html->link("STARTUPS",ARRAY('controller'=>'startups','action'=>'ListStartup'),ARRAY('class'=>"",'aria-controls'=>'about1', 'role'=>'tab1', 'data-toggle'=>'tab1'));
                   $startu= $this->Url->build(["controller" => "startups","action" => "ListStartup"]);
                  ?>

                   <a class="js-tabcollapse-panel-heading" data-toggle="tab" role="tab" aria-controls="scope" href="#startup" data-parent="" aria-expanded="false" onclick="location.href='<?php echo $startu;?>'">STARTUPS</a>
                  </li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->                 
                 <?php //pr($user);?>
                  
                  <!--  1Tab -->
                  <div role="tabpanel" class="tab-pane active" id="professional">
                    <?= $this->Form->create($professional_user , ['enctype' => 'multipart/form-data','id'=>'FormField','class'=>'profile-basic']) ?>
                    <div class="profileView">
                          
                          <div class="circle-img" >
                            <?php if(!empty($user['image'])) { ?>
                                  <?php echo $this->Html->image('profile_pic/' .$user['image'],array('id'=>'blah','width'=>'','height'=>'')); ?>
                            <?php }else { ?>
                                  <img id="blah" src="<?php echo $this->request->webroot;?>images/dummy-man.png" alt="">
                            <?php } ?>
                            <div id="OpenImgUpload" class="overlay">
                            <i class="fa fa-pencil"></i> </div>
                            <?php
                                echo $this->Form->input('image', ARRAY('style'=>'display:none;', 'label' => false, 'div' => false, "class"=>"validate[checkFileType[jpg|jpeg|gif|JPG|png|PNG],checkFileSize[2000]] form-control", 'id' => 'imgupload','type' => 'file'));
                            ?>
                          </div>
                 
                          <div class="basic-info">
                           
                            <?php  $price= $user['price']; 
                                   $finalPrice= number_format((float)$price, 2, '.', '');
                            ?>
                            <div class="profileHeading">
                                <h3><?php echo $user['first_name'].' '.$user['last_name'];?> </h3>
                                <div class="profileHeadingRight">
                                    <a href="javascript:void(0);" id="hireprice" class="hirePrice"><i class="fa fa-pencil"></i> 
                                      $<?php echo $this->Number->precision($finalPrice,2);?>/HR
                                    </a> 
                                    <span id="custom_dollar" class="custom_dollar" style="display: none;">$ </span>
                                    <?php
                                        echo $this->Form->input('price', ARRAY('label' => false, 'div' => false,'type'=>'text', 'class' => '', 'id' => 'showPrice','placeholder'=>'$00.00/HR','style' => 'display:none;','value'=>$finalPrice));
                                    ?>
                                </div>
                            </div>
                            <div class="clearfix"></div>

                            <ul class="nav stars" style="display: none;">
                              <?php echo $ratingStar;?>
                            </ul>
                            <div class="progress_section">
                                <span class=""><?php echo $proPercentage;?>% Complete</span>
                                <div class="progress">
                                  <div class="progress-bar" role="progressbar" aria-valuenow="<?php echo $proPercentage;?>" aria-valuemin="0" aria-valuemax="100" style="width: <?php echo $proPercentage;?>%;">
                                    <span class="sr-only"><?php echo $proPercentage;?>% Complete</span>
                                </div>
                               </div>  
                            </div>
                            <!-- <p class="award"><img src="<?php //echo $this->request->webroot;?>images/awards.png" alt=""> Excellence Award</p>
                           <div class="links"> 
                              <a class="curveBtn blueBtn customBtn" href="#">FOLLOW</a>
                              <a class="curveBtn greenBtn customBtn" href="#">RATE ENTREPRENEUR</a>
                            </div>-->
                          </div>                          
                    </div>
                  
                       <div class="row">
                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              <div class="form-group">
                              <label>Experience</label>
                                  <?php
                                    echo $this->Form->input('experience_id', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','empty'=>'Experience', 'data-size'=>'5', 'options'=>$Experiences));
                                  ?>
                              </div>
                               <div class="form-group">
                               <label>Qualifications</label>
                                  <?php  
                                  $sqli= explode(',', $professional_user['qualifications']);
                                    echo $this->Form->input('qualifications', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','title'=>'Qualifications', 'data-size'=>'5', 'value'=>$sqli, 'multiple'=>'""', 'options'=>$Qualifications));
                                  ?>  
                              </div>
                              <div class="form-group">
                              <label>Skills</label>
                                  <?php
                                  $skl= explode(',', $professional_user['skills']);
                                    echo $this->Form->input('skills', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','title'=>'Skills', 'data-size'=>'5', 'multiple'=>'""','value'=>$skl, 'options'=>$Skills));
                                  ?>    
                              </div>
                              <div class="form-group">
                              <label>Preferred Startup Stage</label>
                                <?php
                                    $stpStg= explode(',', $professional_user['startup_stage']);
                                    echo $this->Form->input('startup_stage', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','multiple'=>true,'title'=>'Preferred Startup Stage', 'data-size'=>'5','value'=>$stpStg,'options'=>$PrefferStartups));
                                  ?>
                              </div>

                              <div class="form-group">
                              <label>Industry Focus</label>
                                   <?php
                                      echo $this->Form->input('industry_focus', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'Industry Focus','maxlength' => '50'));
                                   ?>
                              </div>

                              <div class="form-group">
                               <div class="radio">
                                 
                                  <span>Accredited Investor </span>
                                    <input type="radio" value="1" <?php if($professional_user->accredited_investor == 1){ echo $checkk= 'checked="checked"';} else{ echo $checkk='';}?> name="accredited_investor" id="yes"> <label for="yes">Yes</label> 
                                    <input type="radio" value="0" <?php if($professional_user->accredited_investor == 0){ echo $nTcheckk= 'checked="checked"';} else{ echo $nTcheckk='';}?> name="accredited_investor" id="no"> <label for="no">No</label> 
                                 
                                 </div>
                               </div>

                              <div class="form-group">
                              <?php 
                                echo $this->Html->link("What is an Accredited Investor?",ARRAY('controller'=>'contractors','action'=>'accreditedInvestor'),ARRAY('class'=>'acc_investor','target'=>'_blank'));
                              ?>
                              </div>
                          </div>
                          <div class="col-md-6 col-sm-6 col-xs-12"> 
                              <div class="form-group">
                              <label>Certifications</label>
                                  <?php
                                  $sCr= explode(',', $professional_user['certifications']);
                                    echo $this->Form->input('certifications', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','title'=>'Certifications', 'data-size'=>'5', 'multiple'=>'""','value'=>$sCr, 'options'=>$Certifications));
                                  ?>   
                              </div>


                            <div class="form-group">
                            <label>Select Keywords</label>
                                <span class="form-control textAreaKeyword" id="selectedResult">
                                    <ul>
                                    <?php 
                                    $skey= explode(',', $professional_user['keywords']);
                                    $cc =count($skey);
                                        if(!empty($skey[0])){
                                              for($vi=0; $vi<$cc; $vi++){
                                                    $slids=$skey[$vi];
                                                    //echo $slids;
                                                    //echo $Keywords[$slids]; selectedResult
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
                          </div>
                              

                               
                              <div class="form-group">
                              <label>Contractor Type</label>
                                  <?php
                                    echo $this->Form->input('contributor_type', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => '','type'=>'select','empty'=>'Contractor Type', 'data-size'=>'5', 'options'=>$ContractorTypes));
                                  ?>  
                              </div>     
                          </div>
                          <div class="col-md-12 col-sm-12 col-xs-12">
                            <div class="form-group">
                              <?= $this->Form->button('Submit',['class'=> 'customBtn blueBtn  pull-right']) ?>
                            </div>
                          </div>       
                       </div>   
                    <?= $this->Form->end() ?>
                  </div>

                  <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane" id="basic">
                  </div>
                  <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane" id="startup">                  
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
</div>
<!-- /#page-content-wrapper --> 
<script>

$(document).ready(function () {
  $("#hireprice").click(function(){
      $('#showPrice').show();
      $('#custom_dollar').show();
      $(this).addClass('hide');
  });

  $('#showPrice').priceFormat({
          prefix: ''
  });

  /*$( "#showPrice" ).change(function() {
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
      $('#showPrice').val(s);

  });*/
///Image upload 
$('#OpenImgUpload').click(function(){ $('#imgupload').trigger('click'); });
    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            
            reader.onload = function (e) {
                $('#blah').attr('src', e.target.result);
            }
            
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    $("#imgupload").change(function(){
       var ext = $('#imgupload').val().split('.').pop().toLowerCase();
        if($.inArray(ext, ['gif','png','jpg','jpeg']) == -1) {
          $('<div id="custerro" class="message error" onclick="return closeError();">Invalid! These files extension are allowed: .jpg, .jpeg, .gif, .png</div>').insertBefore('.container-fluid');
        }else {
           readURL(this);
        }
    });

});
function closeError(){
   $('.message').hide(); 
}
</script>

