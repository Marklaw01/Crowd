<div id="page-content-wrapper">
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12 ">
          <h1 class="page-header"><i class="fa fa-users"></i>View Block 
          </h1>
          <?php
			     echo $this->Html->link('Back', array('controller'=> 'TopSliders','action'=>'index'), array('escape'=>false, 'title'=>'Back','class'=>'btn redColor'));
		      ?>
          <div class="table-responsive-custom">
           
           <section id="page-content-wrapper">
          <div class="container-fluid">
  
              <div class="row">

                  <div class="col-md-2 col-sm-2 col-xs-12 pull-right Ver-advertise">

                  </div>
                
                    <div class="row form-group">
                      <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>Title :</label>
                        <span class="form-control"> <?php echo $TopSliders->title;?></span>
                      </div>
                    </div>
					<div class="row form-group">
                     <div class="col-md-6 col-sm-6 col-xs-12">
                        <label>Description :</label>
                        <?php echo $TopSliders->description;?> 
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

