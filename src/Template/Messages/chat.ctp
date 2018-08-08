  <!--<link rel="shortcut icon" href="https://quickblox.com/favicon.ico">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.5/css/bootstrap.min.css">-->

<script type="text/javascript">
  
var QBUser1 = {
        name: '<?php echo $user->first_name; ?>',
        login: '<?php echo $user->username ?>',
        pass: '<?php echo $userPass->password ?>'
    };
var xyz= '<?php echo $userQbId; ?>';  
var jqueryarray = <?php echo json_encode($finalMember); ?>; 
</script>
 <?php //print_r($finalMember);?>
  <link rel="stylesheet" href="<?php echo $this->request->webroot;?>quickblox/libs/stickerpipe/css/stickerpipe.min.css">
  <link rel="stylesheet" href="<?php echo $this->request->webroot;?>quickblox/css/style.css">

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
                <li class="active">Chat</li>
              </ol>
            </div>
          </div>
          <!-- Custom for Quickblox -->
              


    <!-- Modal (login to chat)-->
    <div id="loginForm" class="modal fade chat-loader" role="dialog">
      <div class="modal-dialog">
          <div class="modal-header">
            <img src="<?php echo $this->request->webroot;?>quickblox/images/ajax-loader.gif" class=""></div>
          </div>
      </div>
    </div>

    <!-- end QB -->

          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Chat</h1> 
              </div>
            </div>

            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
                <ul class="profileName">
                    <li><a href="javascript:void(0);" onclick="showGroupChatPoup()">Create Group</a></li>
                </ul>
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
       
       <div class="row"> 
          <div class="col-lg-8 col-md-8 col-sm-12 ">
           <div class="whiteBackground">
             <div class="chat_section_heading">
          User Chat
          </div>
           <div class="chatWindow">
            <div class="chatMessages">
                <div id="mcs_container" class="col-md-12 nice-scroll">
                  <div class="customScrollBox">

                      <ul class="chat-action">
                          <li><a class="" href="javascript:void(0);" onclick="showDialogInfoPopup()">Edit</a></li>
                      </ul>
                   
                  
                    <div class="container del-style">
                      <div class="content list-group pre-scrollable nice-scroll" id="messages-list">
                        <!-- list of chat messages will be here -->
                      </div>
                    </div>
                  </div>
                </div>
             </div>

            <div class="clearfix"></div>
                
             
             <div class="form-group fixedBtm">

                <div><img src="<?php echo $this->request->webroot;?>quickblox/images/ajax-loader.gif" class="load-msg"></div>
                    
                    <form class="form-inline" role="form" method="POST" action="" onsubmit="return submit_handler(this)">

                      <div class="row">

                          <!-- Attach file button -->
                            <div class="col-lg-1 col-md-1 col-sm-6 " style="display: none !important;">
                                <input id="load-img" type="file">
                                <button type="button" id="attach_btn" class="btn btn-default form-control" onclick="$('#load-img').click();">
                                  <i class="icon-photo"></i>
                                </button>
                            </div>

                            <!-- Smily button -->
                            <div class="col-lg-1 col-md-1 col-sm-16 " style="display: none !important;"> 
                                <button type="button" id="stickers_btn" class="btn btn-default form-control" onclick="">
                                   <i class="icon-sticker"></i>
                                </button>
                            </div>

                            
                            <!-- Comment and send button -->  
                                <div class="col-lg-9 col-md-9 col-sm-12 ">
                                  <input type="text" class="form-control" id="message_text" placeholder="Enter message" autocomplete="off">
                                </div>

                                <div class="col-lg-3 col-md-3 col-sm-12 no_paddingleftcol ">
                                    <button  type="submit" id="send_btn" class="btn btn-default searchBtn" onclick="clickSendMessage()">Send</button>
                                 </div>
                      </div>   

                     
                      <img src="<?php echo $this->request->webroot;?>quickblox/images/ajax-loader.gif" id="progress">
                    </form>

              </div>

            </div>
           </div>                  
          </div>
          <div class="col-lg-4 col-md-4 col-sm-12 ">
          <div class="online_users">
          <div class="startup-section chat-section" role="tabpanel">
            <ul id="tabbing" class="nav nav-tabs campaignsTab hidden-xs" role="tablist">
              
              <li class="active" role="presentation" id="li-recent">
              <a data-toggle="tab" role="tab" aria-controls="recent" href="#recent">Recent</a>
              </li>

              <li class="" role="presentation" id="li-contacts">
              <a data-toggle="tab" role="tab" aria-controls="contacts" href="#contacts">Connections</a>
              </li>

            </ul>
            <div class="tab-content hidden-xs">
                <div id="recent" class="tab-pane active whiteBg recent-listing" role="tabpanel">
                  <ul class="listing pre-scrollable nice-scroll" id="dialogs-list">
                    <!-- list of chat dialogs will be here -->
                  </ul>
                </div>

                <div id="contacts" class="tab-pane whiteBg recent-listing" role="tabpanel">
                  <ul class="listing pre-scrollable nice-scroll contact-listing" id="contacts_list">
                    <!-- list of chat dialogs will be here -->

                  </ul>
                </div>

            </div>
          </div>
          <!--<div class="chat_section_heading">
          Recent Chats
          </div>-->

              

           <!-- <ul class="listing"> 
                <li>
                  <div class="listingIcon"><i class="icon"><span class="fa fa-user"></span></i></div>
                    <div class="listingContent">
                      <h2 class="user_name">User1</h2>
                    </div>
                </li>          
            </ul>-->

          </div>
          </div>

        </div>
        </div>
        <!-- /#page-content-wrapper --> 

<!-- Modal (new dialog)-->
    <div id="add_new_dialog" class="modal fade" role="dialog">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Choose users to create group</h3>
          </div>
          <div class="modal-body">
            <div class="col-md-12 col-sm-12 col-xs-12 new-info">
              <h5 class="col-md-12 col-sm-12 col-xs-12">Name:</h5>
              <input type="text" class="form-control" id="custom_name_group" placeholder="New Group" value="">
            </div>

            <div class="list-group pre-scrollable for-scroll">
              <ul class="listing pre-scrollable nice-scroll" id="users_list">

              </ul>
            </div>
            <div class="img-place"><img src="images/ajax-loader.gif" id="load-users"></div>
              <input type="text" class="form-control" id="dlg_name" placeholder="Enter dialog name">
            <button id="add-dialog" type="button" value="Confirm" id="" class="btn btn-success btn-lg btn-block" onclick="createNewDialog()">Create Group</button>
            <div class="progress">
              <div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%">
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

   <!-- Modal (update dialog)-->
    <div id="update_dialog" class="modal fade row" role="dialog">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h3 class="modal-title">Dialog info</h3>
          </div>
          <div class="modal-body">
            <div class="col-md-12 col-sm-12 col-xs-12 new-info">
              <h5 class="col-md-12 col-sm-12 col-xs-12">Name:</h5>
              <input type="text" class="form-control" id="dialog-name-input">
            </div>
            <h5 class="col-md-12 col-sm-12 col-xs-12 push" style="display: none;">Add more user (select to add):</h5>
            <div class="list-group pre-scrollable occupants" id="push_usersList" style="display: none;">
              <ul id="add_new_occupant" class="clearfix"></ul>
            </div>
            <h5 class="col-md-12 col-sm-12 col-xs-12 dialog-type-info"></h5>
            <h5 class="col-md-12 col-sm-12 col-xs-12" id="all_occupants"></h5>
            <button id="update_dialog_button" type="button" value="Confirm" id="" class="btn btn-success btn-ms btn-block"
              onclick="onDialogUpdate()" style="display: none;">Update</button>
            <button id="delete_dialog_button" type="button" value="Confirm" id="for_width" class="btn btn-danger btn-ms btn-block"
              onclick="onDialogDelete()">Delete dialog</button>
          </div>
        </div>
      </div>
    </div> 


  <!--<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.4/jquery.min.js" type="text/javascript"></script>-->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.nicescroll/3.6.0/jquery.nicescroll.min.js" type="text/javascript"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-timeago/1.4.1/jquery.timeago.min.js" type="text/javascript"></script>
  <!--<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.5/js/bootstrap.min.js" type="text/javascript"></script>-->
  <script src="<?php echo $this->request->webroot;?>quickblox/quickblox.min.js"></script>
  <script src="<?php echo $this->request->webroot;?>quickblox/libs/stickerpipe/js/stickerpipe.js"></script>
  <script src="<?php echo $this->request->webroot;?>quickblox/js/config.js"></script>
  <script src="<?php echo $this->request->webroot;?>quickblox/js/connection.js"></script>
  <script src="<?php echo $this->request->webroot;?>quickblox/js/messages.js"></script>
  <script src="<?php echo $this->request->webroot;?>quickblox/js/stickerpipe.js"></script>
  <script src="<?php echo $this->request->webroot;?>quickblox/js/ui_helpers.js"></script>
  <script src="<?php echo $this->request->webroot;?>quickblox/js/dialogs.js"></script>
  <script src="<?php echo $this->request->webroot;?>quickblox/js/users.js"></script>
 <script type="text/javascript">
   jQuery(document).ready(function(){
        
   });

 </script>