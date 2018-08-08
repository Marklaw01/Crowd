<div id="page-content-wrapper">
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Add User 
          </h1>
          <?php
			     echo $this->Html->link('Back', array('controller'=> 'Users','action'=>'index'), array('escape'=>false, 'title'=>'Back','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive-custom">
           
           <section id="page-content-wrapper">
          <div class="container-fluid">
  
              <div class="row">

                  <div class="col-md-2 col-sm-2 col-xs-12 pull-right Ver-advertise">

                  </div>
                 <?= $this->Form->create($user ,['id'=>'FormField','class'=>'col-md-10 col-sm-10 col-xs-12 registration_form']) ?>
                    <div class="row form-group">
                    
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Username:</label>
                      <?php
                        echo $this->Form->input('username', ARRAY('label' => false, 'div' => false, 'error' => false,'id' => '','class'=>'validate[required]form-control form-control','placeholder'=>'Username','maxlength' => '50'));
                      ?>
                      <?php 
                        echo $this->Form->error('username', null, array('class' => 'error-message error'));
                      ?>
                      </div>

                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Email:</label>
                      <?php
                           echo $this->Form->input('email', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[email]]form-control form-control', 'id' => '','placeholder'=>'Email', 'error' => false,'maxlength' => '50'));
                      ?> 
                      <?php 
                        echo $this->Form->error('email', null, array('class' => 'error-message'));
                      ?>                      
                      </div>
                    </div>
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>First Name:</label>
                        <?php
                          echo $this->Form->input('first_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[onlyLetterSp]]form-control form-control', 'id' => '','placeholder'=>'First Name','error' => false,'maxlength' => '50'));
                       ?>
                       <?php 
                        echo $this->Form->error('first_name', null, array('class' => 'error-message'));
                      ?>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Last Name:</label>
                      <?php
                        echo $this->Form->input('last_name', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','error' => false,'placeholder'=>'Last Name','maxlength' => '50'));
                      ?>
                      <?php 
                        echo $this->Form->error('last_name', null, array('class' => 'error-message'));
                      ?>

                      </div>
                    </div>
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Password:</label>
                      <?php
                        echo $this->Form->input('password', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required,custom[password]]form-control form-control', 'id' => 'txtPassword','placeholder'=>'Password','error' => false,'maxlength' => '50'));
                     ?>
                     <?php 
                        echo $this->Form->error('password', null, array('class' => 'error-message'));
                      ?>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Confirm Password:</label>
                       <?php
                          echo $this->Form->input('confirm_password', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required]form-control form-control', 'id' => 'ConfirmPassword','placeholder'=>'Confirm Password','error' => false,'maxlength' => '50','type'=>'password'));
                       ?>
                       <?php 
                        echo $this->Form->error('confirm_password', null, array('class' => 'error-message'));
                      ?>
                      </div>
                    </div>
                     <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Date of Birth:</label>
                       <?php
                          echo $this->Form->input('date_of_birth', ARRAY('label' => false, 'div' => false, 'class' => 'testpicker  form-control', 'id' => 'datetimepicker','error' => false,'placeholder'=>'Date of Birth','maxlength' => '50'));
                       ?>
                       <?php 
                        echo $this->Form->error('date_of_birth', null, array('class' => 'error-message'));
                      ?>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Phone No:</label>
                        <?php
                            echo $this->Form->input('phoneno', ARRAY('label' => false, 'div' => false, 'class' => ' form-control','type'=>'text', 'id' => 'phoneno','error' => false,'placeholder'=>'Phone No','maxlength' => '16'));
                        ?>
                        <?php 
                        echo $this->Form->error('phoneno', null, array('class' => 'error-message'));
                      ?>
                      </div>
                    </div>
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Country:</label>
                       <?php
                          echo $this->Form->input('country', ARRAY('label' => false, 'div' => false, 'class' => ' selectpicker form-control show-tick', 'id' => 'country','type'=>'select','empty'=>'Select Country','error' => false,'value'=>'231', 'options'=>$countrylist));
                       ?>
                       <?php 
                        echo $this->Form->error('country', null, array('class' => 'error-message'));
                      ?>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>State:</label>
                        <?php
                          echo $this->Form->input('state', ARRAY('label' => false, 'div' => false, 'class' => ' selectpicker form-control show-tick','error' => false, 'id' => 'state','type'=>'select','empty'=>'Select State'));
                       ?>
                       <?php 
                        echo $this->Form->error('state', null, array('class' => 'error-message'));
                      ?>
                      </div>
                    </div>
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>City:</label>
                       <?php
                          echo $this->Form->input('city', ARRAY('label' => false, 'div' => false, 'class' => 'form-control', 'id' => '','error' => false,'placeholder'=>'City','maxlength' => '50'));
                       ?>
                       <?php 
                        echo $this->Form->error('city', null, array('class' => 'error-message'));
                      ?>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Best Availability:</label>
                          <?php
                              echo $this->Form->input('best_availablity', ARRAY('label' => false, 'div' => false, 'class' => 'form-control show-tick', 'id' => 'best_availablity','placeholder'=>'Best Availability','error' => false,'maxlength'=>500));
                           ?>
                           <?php 
                            echo $this->Form->error('best_availablity', null, array('class' => 'error-message'));
                          ?>
                      </div>
                     
                    </div>
                    <div id="preQuestions_1" class="row form-group">
                      <div id="mailSelect" class="col-md-11 col-sm-11 col-xs-10 newPanel">
                      <label>Security Question:</label>
                         <?php
                          echo $this->Form->input('question_id[1]', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required]form-control selectpicker form-control show-tick', 'id' => 'preQuestionsSelect_1','type'=>'select','empty'=>'Select security question','error' => false,'options'=>$questionlist));
                       ?>
                        <?php
                          echo $this->Form->input('answer[1]', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required]form-control form-control', 'type'=>'textarea', 'rows'=>'1', 'id' => 'answer_1','placeholder'=>'Answer','maxlength' => '50'));
                       ?>
                        <?php 
                            echo $this->Form->error('question_id[1]', null, array('class' => 'error-message'));
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
                             $this->Form->templates(['nestingLabel' => '{{input}}<label{{attrs}}>{{text}}</label>','formGroup' => '{{input}}{{label}}',]);
                            // echo $this->Form->input('terms',array('type'=>'checkbox', 'label'=>'TERMS & CONDITIONS',));
                        ?> 
                       <!--<div class="input checkbox required">
                        <input type="hidden" value="0" name="terms">
                        <input type="checkbox" required="required" id="part1" class="" value="1" name="terms">
                        <label for="part1" > TERMS & CONDITIONS</label> 
                       </div>-->
                        
                        <p>* The password must be a minimum of 8 characters with at least one special character or number, at least one uppercase letter & at least one 
                        lower case letter.</p>

                      </div>
                                     
                    </div>
                    <div class="row form-group">
                      <div class="col-md-12 col-sm-12 col-xs-12">
                      
                       <?= $this->Form->button('SignUp',['name'=>'submit', 'class'=> 'btn redColor  pull-right']) ?>

                      </div>
                                     
                    </div>

                   <?= $this->Form->end() ?>
                  

              </div>
          </div>
      <!-- /#page-content-wrapper --> 
      </section>
          </div>
      </div>
    </div>
  </div>
  <!-- /#page-content-wrapper --> 
</div>

<?php $state='';?>
<script>
$('#datetimepicker').datetimepicker({
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
  $state= $_POST['state'];
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
        var arr = data.split('---');
        $("#state").html(arr[1]);
        //$("#state").html(data);
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
        var arr = data.split('---');
        $("#state").html(arr[1]);
               <?php if(!empty($state)){
                  echo '$("#state").val("'.$state.'");';
               }?>
        }
    });

    $('ggagag').insertBefore('#custom_terms');

   });


</script>