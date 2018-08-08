 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Organization', array('controller'=>'Companies','action'=>'index'), array('escape'=>false));
                ?></li>
                <li class="active">Organization Video</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Organization Video</h1> 
              </div>
            </div> 
          </div>
          
          <!-- Content Begains --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <iframe width="100%" height="400px" src="https://www.youtube.com/embed/TWH_aV6WinY" frameborder="0" allowfullscreen></iframe>
            </div>
          </div> 
          
 </div>
 <!-- /#page-content-wrapper --> 
