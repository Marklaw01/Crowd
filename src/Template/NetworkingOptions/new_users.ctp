
<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Messaging', array('controller'=>'Messages','action'=>'index'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Networking options', array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false));
                ?></li>
                <li class="active">New Users</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>New Users</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
         <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">

              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                <ul id="tabbing" class="nav nav-tabs networkingTab" role="tablist">

                  <?php
                	$currStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "contacts"]);
                  ?>
                  <li role="presentation" class=""><a href="#current" aria-controls="current" role="tab" data-toggle="tab" onclick="location.href='<?php echo $currStr;?>'">Search Connection</a></li>

                  <?php
                	$compStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "addContacts"]);
                  ?>
                  <li role="presentation" ><a href="#completed" aria-controls="completed" role="tab" data-toggle="tab" onclick="location.href='<?php echo $compStr;?>'">Add New Contacts</a></li>

                  <?php
                  $searStr= $this->Url->build(["controller" => "NetworkingOptions","action" => "newUsers"]);
                 ?>
                  <li role="presentation" class="active"><a href="#search" aria-controls="search" role="tab" data-toggle="tab" onclick="location.href='<?php echo $searStr;?>'">Contacts</a></li> 

                </ul>

                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="myStartups">
                     <div class="table-responsive">
                         <ul class="contentListing Contractor_listing"> 

                          <?php
                          if(!empty($users)){
                           foreach($users as $user){
                            
                         ?>

                        
                          <li>
                           <div class="listingIcon">
                              <div class="circle-img-sidebar">
                              <?php if(!empty($user->image)){?>

                              <a href="#" title="<?php echo $user->name; ?> - Business Card">
                                <img src="<?php echo $this->request->webroot.'img/software/'.$user->image; ?>" class="thumbnail-1 img-responsive">
                              </a>
                              <?php }else {?>
                              <img src="<?php echo $this->request->webroot?>images/dummy-man.png">
                              <?php } ?>  
                              </div>
                           </div>
                           <div class="listingContent">
                             <div class="headingBar">
                               <h2 class="heading"><?php echo $user->name; ?>
                               <span class="smallText"><?php if(!empty($user->country)) { echo $user->country->name;}?></span></h2>
                               <h2 class="connectionType">
                                <STRONG>Connection Type: </STRONG>
                                <?php 
                                  echo $this->Custom->getConnectionTypeById($loggedInUserId,$user->connection_type_id);
                                ?>
                               </h2>
                             </div>
                            
                              <div class="links alignRight">
                                <strong>Phone:</strong>
                                  <?php 
                                    echo $user->phone;
                                  ?>
                                </div>
                                <p>
                                 <strong>Email:</strong>  
                                 <?php 
                                    echo $user->email;
                                  ?>                               
                                </p>
                                <p>
                                   <strong>Note:</strong>  
                                   <?php 
                                    echo $user->note;
                                  ?>                          
                                </p>
                                <?php 
                                  echo $this->Form->postLink('Delete',['action' => 'delete', base64_encode($user->id)],['confirm' => __('Are you sure you want to delete this contact? '),'id'=>'delPost'.$user->id,'class'=>'smallCurveBtnMsg redBtn customBtnMsg pull-right']);
                                ?>
                                <script type="text/javascript">
                                 $(document).ready(function () {
                                     $('#delPost<?php echo $user->id;?>').html('<i class="fa fa-trash-o"></i>Delete');
                                  });   
                                </script>
                            </div>
                          </li> 
                        <?php } ?> 
                        <?php }?>
                        </ul>
                      </div> 

	                    <nav>
	                      <ul class="pagination pagination-sm">
                                  <?php if(!empty($users)){ ?>
                                    <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                                    <li><?= $this->Paginator->numbers() ?></li>
                                    <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                                  <?php } else {?>
                                    <li>No Contact Available.</li>
                                 <?php } ?> 
                              </ul>
	                    </nav>
 
                  </div>

                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="completed">    
                  </div>

                   <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="search">
                  </div>

                   <!--  4Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="current">
                   <div class="clearfix"></div>
                  </div>

                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /#page-content-wrapper --> 

        <div id="myModal" class="modal fade" tabindex="-1" role="dialog">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">×</button>
                <h3 class="modal-title">Heading</h3>
              </div>
              <div class="modal-body">
                
              </div>
            </div>
          </div>
        </div>
<style type="text/css">
  .alignRight .smallCurveBtn {
    padding: 8px 15px !important;
    min-width: 100px !important;
    border-radius: 50px;
}
.modal-dialog {width:600px;}
.thumbnail-1 {margin-bottom:6px;}
</style>

<script type="text/javascript">
  $('.thumbnail-1').click(function(){
    $('.modal-body').empty();
    var title = $(this).parent('a').attr("title");
    $('.modal-title').html(title);
    $($(this).parents('div').html()).appendTo('.modal-body');
    $('#myModal').modal({show:true});
});
</script>