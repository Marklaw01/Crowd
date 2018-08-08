<div id="wrapper">
      <nav class="navbar navbar-inverse navbar-fixed-top top-Bar">
        <div class="container-fluid">
          <div class="row">
            <div class="col-lg-2 col-md-2 col-sm-3 col-xs-12"> 
              <div class="navbar-header">
              <?php
                  $thumb_img = $this->Html->image('small-logo.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link( $thumb_img, array('controller'=>'Pages','action'=>'display', 'home'), array('escape'=>false,'class'=>'navbar-brand'));
              ?>
              </div>
            </div>

            <div class="col-lg-8 col-md-8 col-sm-6 col-xs-12 horzontal-advertise">
                <a href="#"><img src="<?php echo $this->request->webroot;?>images/add.png" alt=""> </a> 
            </div>  
          
            <div  class="col-lg-2 col-md-2 col-sm-3 ">
                 <div>
                 <?php 
                  $loginIcon = $this->Html->image('login.png',array('alt'=>'Crowd Bootstrap','class'=>''));
                  echo $this->Html->link('<i>'.$loginIcon.'</i> Login', array('controller'=>'Users','action'=>'login'), array('escape'=>false,'class'=>'customBtn greyBtn'));
                 ?>
                 </div>
                 
            </div>
          </div>
        </div>
      </nav>
  
    <!-- /#page-content-wrapper --> 
        <section id="page-content-wrapper">
          <div class="container-fluid">
              <div class="page_heading">
               <h1>Signup</h1> 
              </div>
              <div class="row">

                  <div class="col-md-2 col-sm-2 col-xs-12 pull-right Ver-advertise">

                     <img src="<?php echo $this->request->webroot;?>images/ver-add.jpg" alt=""> 

                       <img src="<?php echo $this->request->webroot;?>images/ver-add.jpg" alt=""> 

                  </div>
                 <?= $this->Form->create($user , ['id'=>'FormField','class'=>'col-md-10 col-sm-10 col-xs-12 registration_form']) ?>
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <?php
                        echo $this->Form->input('username', ARRAY('label' => false, 'div' => false,'id' => '','class'=>'validate[required]form-control form-control','placeholder'=>'Username','maxlength' => '50'));
                     ?>
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <?php
                           echo $this->Form->input('email', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[email]]form-control form-control', 'id' => '','placeholder'=>'Email','maxlength' => '50'));
                      ?>                       
                      </div>
                    </div>
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">

                        <?php
                          echo $this->Form->input('first_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[onlyLetterSp]]form-control form-control', 'id' => '','placeholder'=>'First Name','maxlength' => '50'));
                       ?>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <?php
                        echo $this->Form->input('last_name', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'Last Name','maxlength' => '50'));
                     ?>

                      </div>
                    </div>
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <?php
                        echo $this->Form->input('password', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[password]]form-control form-control', 'id' => 'txtPassword','placeholder'=>'Password','maxlength' => '50'));
                     ?>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                       <?php
                          echo $this->Form->input('confirm_password', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required]form-control form-control', 'id' => 'ConfirmPassword','placeholder'=>'Confirm Password','maxlength' => '50','type'=>'password'));
                       ?>
                      </div>
                    </div>

                     <!-- <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                       <?php
                          //echo $this->Form->input('date_of_birth', ARRAY('label' => false, 'div' => false, 'class' => 'testpicker  form-control', 'id' => '','placeholder'=>'Date of Birth','maxlength' => '50'));
                       ?>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <?php
                           // echo $this->Form->input('phoneno', ARRAY('label' => false, 'div' => false, 'class' => ' form-control','type'=>'text', 'id' => 'phoneno','placeholder'=>'Phone No','maxlength' => '16'));
                        ?>
                      </div>
                    </div>

                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                       <?php
                          //echo $this->Form->input('country', ARRAY('label' => false, 'div' => false, 'class' => ' selectpicker form-control show-tick', 'id' => 'country','type'=>'select','empty'=>'Select Country','value'=>'231', 'options'=>$countrylist));
                       ?>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <?php
                         // echo $this->Form->input('state', ARRAY('label' => false, 'div' => false, 'class' => ' selectpicker form-control show-tick', 'id' => 'state','type'=>'select','empty'=>'Select State'));
                       ?>
                      </div>
                    </div>

                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                       <?php
                          //echo $this->Form->input('city', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','placeholder'=>'City','maxlength' => '50'));
                       ?>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                          <?php
                              //echo $this->Form->input('best_availablity', ARRAY('label' => false, 'div' => false, 'class' => 'form-control show-tick', 'id' => 'best_availablity','placeholder'=>'Best Availability','maxlength'=>500));
                           ?>
                      </div>
                    </div> -->

                    <div id="preQuestions_1" class="row form-group">
                      <div id="mailSelect" class="col-md-11 col-sm-11 col-xs-10 newPanel">
                         <?php
                          echo $this->Form->input('question_id[1]', ARRAY('label' => false, 'div' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'preQuestionsSelect_1','type'=>'select','empty'=>'Select security question','options'=>$questionlist));
                       ?>
                        <?php
                          echo $this->Form->input('answer[1]', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'type'=>'textarea', 'rows'=>'1', 'id' => 'answer_1','placeholder'=>'Answer','maxlength' => '50'));
                       ?>
                      </div>
                      <div class="col-md-1 col-sm-1 col-xs-2"><a href="javascript:void(0)" onclick="addDivs()" id="addPreScn" class="addNew"><img src="<?php echo $this->request->webroot;?>images/addIcon.png" alt=""></a></div>
                     
                    </div>
                    <div id="addPreQ" class="divider"> OR</div>
                    <div id="ownQuestions_1" class="row form-group">
                      <div class="col-md-11 col-sm-11 col-xs-10 newPanel"  >
                        <?php
                              echo $this->Form->input('own_question[1]', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'own_question_1','placeholder'=>'Please enter your security question','maxlength' => '200'));
                        ?>
                        <?php
                              echo $this->Form->input('own_answer[1]', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'own_answer_1','type'=>'textarea', 'rows'=>'1','placeholder'=>'Please enter your answer','maxlength' => '200'));
                        ?>
                      </div>
                      <div class="col-md-1 col-sm-1 col-xs-2"><a class="addNew" href="javascript:void(0)" onclick="addOwnDivs()" id="addOwnScn"><img src="<?php echo $this->request->webroot;?>images/addIcon.png" alt=""></a></div>                     
                    </div>

                    <span id="addOwnQ"></span>

                    <div class="row form-group">
                      <div class="col-md-12 col-sm-12 col-xs-12">
                      
                       <?php
                             //$this->Form->templates(['nestingLabel' => '{{input}}<label{{attrs}}>{{text}}</label>','formGroup' => '{{input}}{{label}}',]);
                            // echo $this->Form->input('terms',array('type'=>'checkbox', 'label'=>'TERMS & CONDITIONS',));
                        ?> 
                       <div class="input checkbox required">
                        <input type="hidden" value="0" name="terms">
                        <input type="checkbox" id="part1" class="" value="1" name="terms">
                        <label for="part1" > I Agree with the terms & conditions.</label> 
                        <p class="tandc">
                          <?php
                            echo $this->Html->link('Terms & Conditions', array('controller'=>'Users','action'=>'termsAndConditions'), array('escape'=>false));
                          ?>
                          <?php
                            echo $this->Html->link('Privacy Policy', array('controller'=>'Users','action'=>'privacyPolicy'), array('escape'=>false));
                          ?>

                          </p>
                       </div>
                       <?php 
                          echo $this->Form->error('terms', null, array('class' => 'error-message'));
                       ?>
                        
                        <p>* The password must be a minimum of 8 characters with at least one special character or number, at least one uppercase letter & at least one 
                        lower case letter.</p>

                      </div>
                                     
                    </div>

                    <div id="" class="row form-group">
                      <div id="" class="col-md-11 col-sm-11 col-xs-10 newPanel custom-captch">
                        <?php //echo $this->Captcha->create('securitycode', ['type'=>'math', 'theme'=>'random']);?>
                          <script src='https://www.google.com/recaptcha/api.js'></script>
                          <div class="g-recaptcha" data-sitekey="6LfjagsUAAAAANVaOXHD151Sl86GJL_4r0idJFZl"></div>
                          <?php
                              echo $this->Form->input('captcha_value', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => 'captcha_value','type'=>'hidden','value'=>0));
                          ?>
                        <div id="captcha_error" class="error-message" style="display: none;">Please check captcha.</div>
                      </div>                     
                    </div>
                    
                   

                    <div class="row form-group">
                    <?php $actual_link = "http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";?>
                      <div class="col-md-6 col-sm-6 col-xs-6">
                      <ul class="social-share">
                        
                        <li>
                          <a class="facebook customer share" href="http://www.facebook.com/sharer.php?u=<?php echo $actual_link;?>" title="Facebook share" target="_blank"><img src="<?php echo $this->request->webroot;?>img/facebook.png" alt="Facebbok Share"></a>
                        </li>
                        <li>
                          <a class="google_plus customer share" href="https://plus.google.com/share?url=<?php echo $actual_link;?>" title="Google Plus Share" target="_blank"><img src="<?php echo $this->request->webroot;?>img/google-plus.png" alt="Google Plus"></a>
                        </li>
                        <li>
                          <a class="linkedin customer share" href="http://www.linkedin.com/shareArticle?mini=true&url=<?php echo $actual_link;?>" title="linkedin Share" target="_blank"><img src="<?php echo $this->request->webroot;?>img/linkedin.png" alt="Linkedin Share"></a>
                        </li>
                      </ul>    
                      </div>

                      <div class="col-md-6 col-sm-6 col-xs-6">
                       <?= $this->Form->button('SignUp',['name'=>'submit', 'class'=> 'customBtn blueBtn  pull-right']) ?>
                      </div>
                                     
                    </div>

                   <?= $this->Form->end() ?>
                  

              </div>
          </div>
      <!-- /#page-content-wrapper --> 
      </section>

 </div>
<?php $state='';?>

<script>
 ;(function($){
    
    /**
     * jQuery function to prevent default anchor event and take the href * and the title to make a share popup
     *
     * @param  {[object]} e           [Mouse event]
     * @param  {[integer]} intWidth   [Popup width defalut 500]
     * @param  {[integer]} intHeight  [Popup height defalut 400]
     * @param  {[boolean]} blnResize  [Is popup resizeabel default true]
     */
    $.fn.customerPopup = function (e, intWidth, intHeight, blnResize) {
      
      // Prevent default anchor event
      e.preventDefault();
      
      // Set values for window
      intWidth = intWidth || '500';
      intHeight = intHeight || '400';
      strResize = (blnResize ? 'yes' : 'no');

      // Set title and open popup with focus on it
      var strTitle = ((typeof this.attr('title') !== 'undefined') ? this.attr('title') : 'Social Share'),
          strParam = 'width=' + intWidth + ',height=' + intHeight + ',resizable=' + strResize,            
          objWindow = window.open(this.attr('href'), strTitle, strParam).focus();
    }
    
    /* ================================================== */
    
    $(document).ready(function ($) {
      $('.customer.share').on("click", function(e) {
        $(this).customerPopup(e);
      });
    });
      
  }(jQuery));

jQuery('.creload').on('click', function() {
    var mySrc = $(this).prev().attr('src');
    var glue = '?';
    if(mySrc.indexOf('?')!=-1)  {
        glue = '&';
    }
    $(this).prev().attr('src', mySrc + glue + new Date().getTime());
    return false;
});
</script>

<script>
$('.testpicker').datetimepicker({
  timepicker:false,
  maxDate: 0,
  format:'F d, Y',
  scrollInput: false
});
$('.testtimepicker').datetimepicker({
  datepicker:false,
  format:'H:i ',
  
});

var x =2;
function addDivs(){
  
             var optList = $('#preQuestionsSelect_1').html();
             //var ulList = $('#mailSelect .dropdown-menu').html();
             var cdivId= 'preQuestions_'+x;
             var divId= "'"+cdivId+"'";
                   //e.preventDefault();

                $('<div id="preQuestions_'+x+'" class="row form-group"><div class="col-md-11 col-sm-11 col-xs-10 newPanel"><select id="preQuestionsSelect_'+x+'" class="validate[required]form-control selectpicker form-control show-tick" name="question_id['+x+']">'+optList+'</select><textarea rows="1" required="required" placeholder="Answer" id="answer_'+x+'" class="validate[required]form-control form-control" name="answer['+x+']"></textarea></div><div class="col-md-1 col-sm-1 col-xs-2"><a href="javascript:void(0)" id="remScnt" onclick="bindAlert('+divId+')" class="remove_field centerClass"><img src="<?php echo $this->request->webroot;?>images/removeIcon.png" alt=""></a></div></div>').insertBefore('#addPreQ');
                
            x++;
}

var y =2;
function addOwnDivs() {

             var cdivId= 'ownQuestions_'+y;
             var divId= "'"+cdivId+"'";
                   //e.preventDefault();

                $('<div class="row form-group" id="ownQuestions_'+y+'"><div class="col-md-11 col-sm-11 col-xs-10 newPanel"  ><div class="input text"><input type="text" placeholder="Please enter your security question" id="own_question_'+y+'" class="form-control" name="own_question['+y+']"></div><div class="input text"><textarea rows="1" placeholder="Please enter your answer" id="own_answer_'+y+'" class="form-control" name="own_answer['+y+']"></textarea></div></div><div class="col-md-1 col-sm-1 col-xs-2"><a href="javascript:void(0)" id="remScnt" onclick="bindAlertOwn('+divId+')" class="remove_field centerClass"><img src="<?php echo $this->request->webroot;?>images/removeIcon.png" alt=""></a></div></div>').insertBefore('#addOwnQ');
          

          y++;                   
}
<?php //pr($_POST);
if(isset($_POST['submit'])){
  //$state= $_POST['state'];
  $postQ =count($_POST['question_id']);
    echo '$("#preQuestionsSelect_1").val("'.$_POST['question_id'][1].'");';
    echo '$("#answer_1").val("'.$_POST['answer'][1].'");';
  // retain Pre questions
  if($postQ>1){
      for($i=2; $i<=$postQ;$i++){
        echo "addDivs();";
        echo '$("#preQuestionsSelect_'.$i.'").val("'.$_POST['question_id'][$i].'");';
        echo '$("#answer_'.$i.'").val("'.$_POST['answer'][$i].'");';
      }
  }

  // Retain own questions
  $postOwnQ =count($_POST['own_question']);
  if(!empty($postOwnQ)){
    echo '$("#own_question_1").val("'.$_POST['own_question'][1].'");';
    echo '$("#own_answer_1").val("'.$_POST['own_answer'][1].'");';
  }

  if($postOwnQ>1){
      for($j=2; $j<=$postOwnQ;$j++){
        echo "addOwnDivs();";
        echo '$("#own_question_'.$j.'").val("'.$_POST['own_question'][$j].'");';
        echo '$("#own_answer_'.$j.'").val("'.$_POST['own_answer'][$j].'");';
      }
  }
}
?>
$(function() {
         
           $("#FormField").validationEngine();
           $(".testpicker").keypress(function(event) {event.preventDefault();});
           $(".testtimepicker").keypress(function(event) {event.preventDefault();});
           //$("#txtConfirmPassword").focusout(checkPasswordMatch);

// Append Predefine Question Drop down HTML           
         
       /*  $('#addPreScn1').click(function(e) {
             var x =2;
             var optList = $('#preQuestionsSelect_1').html();
             //var ulList = $('#mailSelect .dropdown-menu').html();
             var cdivId= 'preQuestions_'+x;
             var divId= "'"+cdivId+"'";
                   e.preventDefault();

                $('<div id="preQuestions_'+x+'" class="row form-group"><div class="col-md-11 col-sm-11 col-xs-10 newPanel"><select id="preQuestionsSelect_'+x+'" class="validate[required]form-control selectpicker form-control show-tick" name="question_id['+x+']">'+optList+'</select><input type="text" required="required" placeholder="Answer" id="answer_'+x+'" class="validate[required]form-control form-control" name="answer['+x+']"></div><div class="col-md-1 col-sm-1 col-xs-2"><a href="javascript:void(0)" id="remScnt" onclick="bindAlert('+divId+')" class="remove_field">Remove</a></div></div>').insertBefore('#addPreQ');
                
            x++;            
        });*/



// Append Own Question's HTML   
       /* var y =2;
        $('#addOwnScn').click(function(e) {
             
             var cdivId= 'ownQuestions_'+y;
             var divId= "'"+cdivId+"'";
                   e.preventDefault();

                $('<div class="row form-group" id="ownQuestions_'+y+'"><div class="col-md-11 col-sm-11 col-xs-10 newPanel"  ><div class="input text"><input type="text" placeholder="Please enter your question here" id="" class="form-control" name="own_question['+y+']"></div><div class="input text"><input type="text" placeholder="Please enter your answer here" id="own_answer_'+y+'" class="form-control" name="own_answer['+y+']"></div></div><div class="col-md-1 col-sm-1 col-xs-2"><a href="javascript:void(0)" id="remScnt" onclick="bindAlertOwn('+divId+')" class="remove_field">Remove</a></div></div>').insertBefore('#addOwnQ');
          

          y++;                   
        });  */

  });

//Remove Appended HTML
function bindAlert(count){
   $('#'+count).remove();

}
function bindAlertOwn(count){
   $('#'+count).remove();

}

// Ajax for states list
$(function(){
    $('#country').change(function(){
    var val = $(this).val();
    $.ajax({ 
    url: "<?php echo $this->Url->build(["Controller" => "Users","action" => "getOptionsList"]);?>",
    data: {countryId:val},
        type : 'POST',
        cache: false,
    success: function(data) {
    $("#state").html(data);
    }
       });

   });
});

// Ajax for states list on page load
  $(document).ready(function(){
    var val = $('#country').val(); //alert(val);
    $.ajax({ 
        url: "<?php echo $this->Url->build(["Controller" => "Users","action" => "getOptionsList"]);?>",
        data: {countryId:val},
            type : 'POST',
            cache: false,
        success: function(data) {
        $("#state").html(data);
               <?php if(!empty($state)){
                  echo '$("#state").val("'.$state.'");';
               }?>
        }
    });

    $('ggagag').insertBefore('#custom_terms');

  });

 $("#FormField").submit(function(e){
      if (grecaptcha.getResponse() == ""){
         //alert("You can't proceed!");
         $('#captcha_error').show();
         e.preventDefault();
      } else {
          $('#captcha_value').val('1');
          $('#captcha_error').hide();
          //alert("Thank you");
      }
        
});

</script>
