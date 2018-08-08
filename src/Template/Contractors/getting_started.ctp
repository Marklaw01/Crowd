<div class="container-fluid">
  <div class="row">
    <div class='col-lg-12 col-md-12 col-sm-12 '>
      <div class="profileName profileNameFeeds <?php echo $widthClass;?>">
          <?php
              echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false,'class'=>'navbar-brand'));
          ?>

          <?php
              echo $this->Html->link("News", array('controller'=>'Contractors','action'=>'news'), array('escape'=>false,'class'=>'navbar-brand'));
          ?>

          <?php
            if(!empty($UserId)){
              echo $this->Html->link("Alerts", array('controller'=>'Contractors','action'=>'feeds'), array('escape'=>false,'class'=>'navbar-brand'));
            }  
          ?>

          <?php
            if(empty($UserId)){
              echo $this->Html->link("Start", array('controller'=>'Contractors','action'=>'gettingStarted'), array('escape'=>false,'class'=>'active'));
            }
          ?>

          <?php
            if(!empty($UserId)){
              echo $this->Html->link("Networking Options", array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false,'class'=>'navbar-brand'));
            }
          ?>

          <?php
            //date_default_timezone_set('America/Los_Angeles');
            //echo date_default_timezone_get() . ' => ' . date('e') . ' => ' . date('T');
            //echo date('d-m-y h:i:s');
          ?>
      </div>
    </div>
  </div>
</div>    
<div id="myicons">
  <div class="container-fluid">
    <div class="row">
      <div class="col-xs-12 col-sm-12 col-md-12">
        <p class="description">
          <span class="crowd">Crowd</span> <span class="crowdBoot">Bootstrap</span><sup class="super">SM</sup> is a startup accelerator App for the iPhone and Android. 
          Entrepreneurs can apply to register their startup and gain access to the Lean 
          Startup Roadmap, which is a sequence of best practices to start a startup. 
          Entrepreneurs also get access to a network of experts who help them complete their
          startup tasks faster and with higher quality. In addition, 
          established companies can sign up for recruitment services to find job candidates whose job performance is rated and validated by clients. 
          Also, organizations can sponsor their own startup accelerator that funds innovative startups in their chosen industry.
        </p>
      </div>
    </div>  

    <div class="row">
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <a href="#" data-toggle="modal" data-target="#entrepreneur" class="">
            <img src="<?php echo $this->request->webroot; ?>images/active.png">
            <h3>If you are a Entrepreneur</h3>
          </a>  
        </div>
      </div>
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <a href="#" data-toggle="modal" data-target="#expert" class="">
            <img src="<?php echo $this->request->webroot; ?>images/activater.png">
            <h3>If you are an Expert</h3>
          </a>  
        </div>
      </div>  
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <a href="#" data-toggle="modal" data-target="#recruiter" class="">
            <img src="<?php echo $this->request->webroot; ?>images/searcher.png">
            <h3>If you are a Recruiter</h3>
          </a>  
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <a href="#" class="" data-toggle="modal" data-target="#organization">
            <img src="<?php echo $this->request->webroot; ?>images/sponser.png">
            <h3>If you are a Organization</h3>
          </a>  
        </div>
      </div>
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <?php 
            $homePage= $this->Url->build(["controller" => "contractors","action" => "feeds"]);
          ?>
          <a href="<?php echo $homePage;?>" class="">
            <img src="<?php echo $this->request->webroot; ?>images/Home.png">
            <h3>Home Page</h3>
          </a>  
        </div>
      </div>
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <?php 
            $getStdVideo= $this->Url->build(["controller" => "contractors","action" => "gettingStartedVideo"]);
          ?>
          <a href="<?php echo $getStdVideo;?>" class="">
            <img src="<?php echo $this->request->webroot; ?>images/pause.png">
            <h3>Getting Started video</h3>
          </a>  
        </div>
      </div>  
    </div>
  </div>
</div>
   
<!-- Modal 1-->
<div class="modal fade" id="entrepreneur" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">If you are a Entrepreneur</h4>
      </div>
      <div class="modal-body">
        If you are an Entrepreneur, click the menu option in the top left corner of the screen then select "My Profile" to create your "Entrepreneur" profile. Then select the "Startup" option on the menu to submit your startup application and create a startup profile.
      </div>  
    </div>
  </div>
</div>

<!-- Modal 2-->
<div class="modal fade" id="expert" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">If you are an Expert</h4>
      </div>
      <div class="modal-body">
         If you are an Expert, click the menu option in the top left corner of the screen then select "My Profile" to create your "Contractor" profile. Then select the "Contractors" option on the menu to start helping innovative startups.
      </div>      
    </div>
  </div>
</div>

<!-- Modal 3-->
<div class="modal fade" id="recruiter" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">If you are a Recruiter</h4>
      </div>
      <div class="modal-body">
          If you are a Recruiter, click the menu option in the top left corner of the screen then select "My Profile" to create a profile. Then select the "Opportunities" option on the menu to submit your job posting or search for job candidates whose job performance has been rated and validated by entrepreneurs.
      </div>   
    </div>
  </div>
</div>

<!-- Modal 4-->
<div class="modal fade" id="organization" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">If you are an Organization</h4>
      </div>
      <div class="modal-body">
    		  If you are an Organization, click the menu option in the top left corner of the screen then select the "Organization" option. You can create a organization page to explain your offerings. You can also sponsor events or even sponsor your own accelerator to access innovative startups in your industry.
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
$('#myicons .entreprenuer a').on('click', function(){
    $('#myicons .entreprenuer.current').removeClass('current');
    $(this).parent().addClass('current');
});
</script>