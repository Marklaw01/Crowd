<div id="page-content-wrapper">
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>View User 
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
            
                    <div class="row form-group">
                    
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>Username:</label>
                        <span class="form-control"> <?php echo $users->username;?> </span>
                      </div>

                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>Email:</label>
                        <span class="form-control"> <?php echo $users->email;?> </span>
                                            
                      </div>
                    </div>
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>First Name:</label>
                        <span class="form-control"> <?php echo $users->first_name;?> </span>
                         
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>Last Name:</label>
                        <span class="form-control"> <?php echo $users->last_name;?> </span>
                        
                      </div>
                    </div>
                    
                     <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>Date of Birth:</label>
                        <span class="form-control"> <?php echo $users->date_of_birth;?> </span>
                        
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>Phone No:</label>
                        <span class="form-control"> <?php echo $users->phoneno;?> </span>
                        
                      </div>
                    </div>
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>Country:</label>
                        <span class="form-control"> <?php if(!empty($users->country)){echo $users->country->name;}?> </span>
                       
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>State:</label>
                        <span class="form-control"> <?php if(!empty($users->state) && ($users->state != null)){echo $users->state->name;}?> </span>
                        
                      </div>
                    </div>
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>City:</label>
                        <span class="form-control"> <?php echo $users->city;?> </span>
                       
                      </div>
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>Best Availability:</label>
                        <span class="form-control"> <?php echo $users->best_availablity;?> </span>

                      </div>
                     
                    </div>

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

