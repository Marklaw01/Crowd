<div id="page-content-wrapper">
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>Edit Sub Admin Details
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
    						<label>Username:</label>
                <span class="form-control readonly"><?php echo $users->user->username;?></span>
    						
            </div> 
                       
					   <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Email:</label>
                     <span class="form-control readonly"><?php echo $users->user->email;?></span>
                        
                      </div> 
                    </div>
					 
            <div class="row form-group">
                <div class="col-md-6 col-sm-6 col-xs-12">
                  <label>First Name:</label>
                  <?php
                    echo $this->Form->input('first_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required]form-control form-control', 'id' => 'txtPassword','placeholder'=>'First name','error' => false,'value' => $users->user->first_name));
                  ?>
                  <?php 
                    echo $this->Form->error('first_name', null, array('class' => 'error-message'));
                  ?>
              </div>  
              <div class="col-md-6 col-sm-6 col-xs-12">
                  <label>Last Name:</label>
                  <?php
                    echo $this->Form->input('last_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required]form-control form-control', 'id' => 'txtPassword','placeholder'=>'Last name','error' => false,'value' => $users->user->last_name));
                  ?>
                  <?php 
                    echo $this->Form->error('last_name', null, array('class' => 'error-message'));
                  ?>
              </div>
            </div>

					 <div class="row form-group">
            
  						<div class="col-md-6 col-sm-6 col-xs-12">
    						<label>Company Name:</label>
    						<?php
    						  echo $this->Form->input('company_name', ARRAY('label' => false, 'div' => false, 'class' => 'validate[required]form-control form-control', 'id' => 'txtPassword','placeholder'=>'Company name','error' => false,'value' => $users->company_name));
    					   ?>
    					   <?php 
    						  echo $this->Form->error('company_name', null, array('class' => 'error-message'));
    						?>
  						  
  						</div>  
					  
              <div class="col-md-6 col-sm-6 col-xs-12">
                <label>Status</label>

                <select name="status" class="form-control">
                  <option value="1" <?php if($users->user->status ==1){echo 'selected="selected"';}else {}?> >Active</option>
                  <option value="0" <?php if($users->user->status ==0){echo 'selected="selected"';}else {}?>>In Active</option>
                </select>  
              </div>

            </div>


					  <div class="row form-group">
						<div class="col-md-12 col-sm-12 col-xs-12">
						
						 <?= $this->Form->button('Save',['name'=>'submit', 'class'=> 'btn redColor  pull-right']) ?>
  
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