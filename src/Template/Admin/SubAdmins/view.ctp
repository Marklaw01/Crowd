<div id="page-content-wrapper">
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>View Subadmin 
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
                    
					<div class="row form-group">
                    
                      <div class="col-md-6 col-sm-6 col-xs-12">
            						<label>Username:</label>
            						<span class="form-control"><?php echo $users->user->username;?></span>
                      </div> 
                       
					          <div class="col-md-6 col-sm-6 col-xs-12">
                      <label>Email:</label>
                      <span class="form-control"><?php echo $users->user->email;?></span>
                      </div> 
                    </div>
					 
            <div class="row form-group">
                <div class="col-md-6 col-sm-6 col-xs-12">
                  <label>First Name:</label>
                  <span class="form-control"><?php echo $users->user->first_name;?></span>
              </div>  
              <div class="col-md-6 col-sm-6 col-xs-12">
                  <label>Last Name:</label>
                  <span class="form-control"><?php echo $users->user->last_name;?></span>
              </div>
            </div>

					 <div class="row form-group">
						<div class="col-md-6 col-sm-6 col-xs-12">
						<label>Company Name:</label>
  						<span class="form-control"><?php echo $users->company_name;?></span>
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