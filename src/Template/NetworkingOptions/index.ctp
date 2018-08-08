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
              echo $this->Html->link("Start", array('controller'=>'Contractors','action'=>'gettingStarted'), array('escape'=>false,'class'=>'navbar-brand'));
            }
          ?>

          <?php
            if(!empty($UserId)){
              echo $this->Html->link("Networking Options", array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false,'class'=>'active'));
            }
          ?>
      </div>
    </div>
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li> <?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li> <?php
            echo $this->Html->link('Messaging', array('controller'=>'Messages','action'=>'index'), array('escape'=>false));
        ?></li>
        <li class="active">Networking Options</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
     <div class="page_heading">
       <h1>Networking Options</h1> 
      </div>
    </div>
  </div>
</div>

<div id="myicons">
  <div class="container-fluid">  
    <div class="row">
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <a href="#" data-toggle="modal" data-target="#Map" class="">
            <img src="<?php echo $this->request->webroot; ?>images/Map.png">
            <h3>Map</h3>
          </a>  
        </div>
      </div>
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
            <?php
                echo $this->Html->link('<img src="'.$this->request->webroot.'images/add-contact.png">
            <h3>Search/Add Contact</h3>', array('controller'=>'NetworkingOptions','action'=>'contacts'), array('escape'=>false));
            ?>
        </div>
      </div>  
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <?php 
            $homePage= $this->Url->build(["controller" => "NetworkingOptions","action" => "businessConnections"]);
          ?>
          <a href="<?php echo $homePage; ?>"  class="">
            <img src="<?php echo $this->request->webroot; ?>images/manage-groups.png">
            <h3>Manage Groups</h3>
          </a>  
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <?php 
            $homePage= $this->Url->build(["controller" => "NetworkingOptions","action" => "businessCardNoteList"]);
          ?>
          <a href="<?php echo $homePage;?>" class="" >
            <img src="<?php echo $this->request->webroot; ?>images/manage-notes.png">
            <h3>Contractor Notes</h3>
          </a>  
        </div>
      </div>
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <?php 
            $homePage= $this->Url->build(["controller" => "NetworkingOptions","action" => "businessCardList"]);
          ?>
          <a href="<?php echo $homePage;?>" class="">
            <img src="<?php echo $this->request->webroot; ?>images/business-cards.png">
            <h3>My Business Cards</h3>
          </a>  
        </div>
      </div>
      <div class="col-xs-12 col sm-4 col-md-4">
        <div class="entreprenuer">
          <?php 
            $getStdVideo= $this->Url->build(["controller" => "NetworkingOptions","action" => "auth"]);
          ?>
          <a href="<?php echo $getStdVideo;?>" class="">
            <img src="<?php echo $this->request->webroot; ?>images/social-media.png">
            <h3>Social Media Connect</h3>
          </a>  
        </div>
      </div>  
    </div>
  </div>
</div>
   
<!-- Modal 1-->
<div class="modal fade" id="Map" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Map</h4>
      </div>
      <div class="modal-body">
        Coming Soon
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
        <h4 class="modal-title" id="myModalLabel">If you are a Expert</h4>
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