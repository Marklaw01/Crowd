<div class="container-fluid">
  <?= $this->Form->create($team_detail,['id'=>'FormField']) ?>
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li class="active"><?php
                    echo $this->Html->link('Contractors', array('controller'=>'Contractors','action'=>'searchContractors'), array('escape'=>false));
                ?></li>
                <li class="active">Add Contractors</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Add Contractors</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <?php
          $rId='';
          if(isset($_POST['submit'])){
            $rId= $_POST['roadmap_id'];
          }
          ?>
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
              <div class="form-group">
              <label>Select Startup</label>
                    <?php
                      echo $this->Form->input('startup_id', ['label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'startup_id','type'=>'select','options'=>$startup_detail,'empty'=>'Select Startup']);
                    ?>
                    <?php 
                                  echo $this->Form->error('startup_id', null, array('class' => 'error-message'));
                    ?>
              </div>

              <div class="form-group">
              <label>Select Roadmap Deliverables</label>
                    <?php
                      echo $this->Form->input('roadmap_id', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'roadmap_id','type'=>'select','title'=>'Select Roadmap Deliverables','value'=>$rId, 'data-size'=>'5', 'multiple'=>'""', 'options'=>$roadmaps));
                    ?>
                    <?php 
                                  echo $this->Form->error('roadmap_id', null, array('class' => 'error-message'));
                    ?>
              </div>

              <div class="form-group">
              <label>Contractor Name</label>
                  <span class="form-control">
                  <?php  echo $name = $userdetail['first_name'].' '.$userdetail['last_name'];?>
                  </span>

                  <?php
                    //echo $this->Form->input('contractor_name', ['label' => false,'error' => false, 'div' => false,'id' => '','placeholder'=>'Contributor Name','class'=>'validate[required,minSize[4],maxSize[20]]form-control','value'=>$name]);
                  ?>
              </div>

              <div class="form-group">
              <label>Select Role</label>
                    <?php
                      echo $this->Form->input('contractor_role_id',['label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'contractor_role_id','placeholder'=>'Role','type'=> 'select','options'=>$roles,'empty'=>'Select Role']);
                    ?>
                    <?php 
                                  echo $this->Form->error('contractor_role_id', null, array('class' => 'error-message'));
                    ?>
                  
              </div>
              <div class="form-group">
              <label>Hourly Rate</label>
                    <?php
                        $price = $userdetail['price'];
                        echo $this->Form->input('hourly_price', ['label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'id' => 'hourly_price','type'=>'text', 'placeholder'=>'Hourly Rate','maxlength' => '50','value'=>$this->Number->precision($price,2)]);
                      
                    ?>
                    <?php 
                                  echo $this->Form->error('hourly_price', null, array('class' => 'error-message'));
                    ?>
              </div>

              <div class="form-group">
              <label>Work units Allocated</label>
                  <?php
                    echo $this->Form->input('work_units_allocated', ['label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'id' => 'work_units_allocated','type'=>'text','placeholder'=>'Work units Allocated','maxlength' => '50']);
                  ?>
                  <?php 
                      echo $this->Form->error('work_units_allocated', null, array('class' => 'error-message'));
                  ?>
              </div>

              <div class="form-group">
              <label>Work units Approved</label>
                  <?php
                    echo $this->Form->input('work_units_approved', ['label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'id' => 'work_units_approved','type'=>'text','placeholder'=>'Work units Approved','maxlength' => '50']);
                  ?>
                  <?php 
                                echo $this->Form->error('work_units_approved', null, array('class' => 'error-message'));
                  ?>
              </div>
              <div class="form-group">
              <label>Target Date</label>
                <?php
                  echo $this->Form->input('target_date', ARRAY('label' => false, 'div' => false,'error' => false, 'id' => 'target_date','type'=>'text','placeholder'=>'Target Date','maxlength' => '50','class'=> 'testpicker form-control'));
                ?>
                <?php 
                      echo $this->Form->error('target_date', null, array('class' => 'error-message'));
                ?>
              </div>    

              <div class="form-group">
                  <?= $this->Form->button('Save',['name'=>'submit','class'=> 'customBtn blueBtn  pull-right']) ?>
              </div>
            </div>
          </div>
     <?= $this->Form->end() ?>      
</div>

<script>
$('.testpicker').datetimepicker({
  timepicker:false,
  format:'F d, Y',
  minDate: 0,
  scrollInput: false
});


$(document).ready(function () {
    $('#hourly_price').priceFormat({
          prefix: '$'
    });

    $('#work_units_allocated').priceFormat({
          prefix: '',
          centsLimit: 0,
          thousandsSeparator: ','
    });

    $('#work_units_approved').priceFormat({
          prefix: '',
          centsLimit: 0,
          thousandsSeparator: ','
    });
});
<?php //pr($_POST);
if(isset($_POST['submit'])){
  echo '$("#startup_id").val("'.$_POST['startup_id'].'");';
  echo '$("#contractor_role_id").val("'.$_POST['contractor_role_id'].'");';
  echo '$("#hourly_price").val("'.$_POST['hourly_price'].'");';
}
?>  
</script>
