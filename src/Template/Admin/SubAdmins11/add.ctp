<div id="page-content-wrapper">
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Add Subadmin 
          </h1>
          <?php
			     echo $this->Html->link('Back', array('controller'=> 'SubAdmins','action'=>'index'), array('escape'=>false, 'title'=>'Back','class'=>'btn redColor'));
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
						<label>Username :</label>
						<?php
						  echo $this->Form->input('username', ARRAY('label' => false, 'div' => false, 'error' => false,'id' => '','class'=>'validate[required]form-control form-control','placeholder'=>'Username','maxlength' => '50'));
						?>
						<?php 
						  echo $this->Form->error('username', null, array('class' => 'error-message error'));
						?>
                      </div> 
                       
					   <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Email :</label>
                      <?php
                        echo $this->Form->input('email', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required]form-control form-control', 'id' => 'txtPassword','placeholder'=>'Email','error' => false,'maxlength' => '50'));
                     ?>
                     <?php 
                        echo $this->Form->error('email', null, array('class' => 'error-message'));
                      ?>
                        
                      </div> 
                    </div>
					 
					 <div class="row form-group">
						<div class="col-md-6 col-sm-6 col-xs-12">
						<label>Company Name :</label>
						<?php
						  echo $this->Form->input('company_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required]form-control form-control', 'id' => 'txtPassword','placeholder'=>'Company name','error' => false,'maxlength' => '50'));
					   ?>
					   <?php 
						  echo $this->Form->error('company_name', null, array('class' => 'error-message'));
						?>
						  
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