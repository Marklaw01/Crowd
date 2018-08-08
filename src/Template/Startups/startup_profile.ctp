 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Startups', array('controller'=>'Entrepreneurs','action'=>'listStartup'), array('escape'=>false));
                ?></li>
                <li class="active">Startup Profile</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Startup Profile</h1> 
              </div>
            </div> 
          </div>
          <!-- header ends --> 
 </div>
 <!-- /#page-content-wrapper --> 
