// build html for messages
function buildMessageHTML(messageText, messageSenderId, messageDateSent, attachmentFileId, messageId, messageSenderUserId, logeUserId, status){
  var messageAttach;
  if(attachmentFileId){
      messageAttach = '<img src="http://api.quickblox.com/blobs/'+attachmentFileId+'/download.xml?token='+token+'" alt="attachment" class="attachments img-responsive" />';
  }

  if(messageSenderUserId == logeUserId){
    var msgClass ='meUser';
  }else{
     var msgClass ='anotherUser';
  }

//alert (JSON.stringify(QBUser1)); 

	var isMessageSticker = stickerpipe.isSticker(messageText);
var base_url = window.location.origin;

var host = window.location.host;

//alert(base_url);
  var delivered = '<img class="icon-small" src="'+base_url+'/quickblox/images/delivered.jpg" alt="" id="delivered_'+messageId+'">';
  var read = '<img class="icon-small" src="'+base_url+'/quickblox/images/read.jpg" alt="" id="read_'+messageId+'">';

	var messageTextHtml = messageText;
	if (messageAttach) {
		messageTextHtml = messageAttach;
	} else if (isMessageSticker) {
		messageTextHtml = '<div class="message-sticker-container"></div>';

		stickerpipe.parseStickerFromText(messageText, function(sticker, isAsync) {
			if (isAsync) {
				$('#' + messageId + ' .message-sticker-container').html(sticker.html);
			} else {
				messageTextHtml = sticker.html;
			}
		});
	}

 /* var messageHtml =
			'<div class="list-group-item" id="'+messageId+'" onclick="clickToAddMsg('+"'"+messageId+"'"+')">'+
				'<time datetime="'+messageDateSent+ '" class="pull-right">'
					+jQuery.timeago(messageDateSent)+
				'</time>'+

				'<h4 class="list-group-item-heading">'+messageSenderId+'</h4>'+
				'<p class="list-group-item-text">'+
					messageTextHtml +
				'</p>'
				+delivered+read+
			'</div>';*/
  var messageHtml ='';
  //if(messageSenderId != null){
    var messageHtml =
      '<div class="chatMsg '+msgClass+'" data="'+logeUserId+'" id="'+messageId+'">'+
        '<time datetime="'+messageDateSent+ '" class="pull-right">'
          +jQuery.timeago(messageDateSent)+
        '</time>'+

        '<span 22>'+messageSenderId+'</span>'+
        '<p class="chat_bubble">'+
          messageTextHtml +
        '</p>'
        +delivered+read+
      '</div>';    
  //}    

  return messageHtml;
}

// build html for dialogs
function buildDialogHtml(dialogId, dialogUnreadMessagesCount, dialogIcon, dialogName, dialogLastMessage,user_id,chatUser) { 
  var UnreadMessagesCountShow = '<span class="badge">'+dialogUnreadMessagesCount+'</span>';
      UnreadMessagesCountHide = '<span class="badge" style="display: none;">'+dialogUnreadMessagesCount+'</span>';

  var isMessageSticker = stickerpipe.isSticker(dialogLastMessage);
  var dialogHtml ='';
  //if(dialogName != null){
    var dialogHtml =
        '<li><a href="javascript:void(0);" class="list-group-item inactive " data="'+chatUser+'" id='+'"'+dialogId+'"'+' onclick="triggerDialog('+"'"+dialogId+"'"+')">'+
                   (dialogUnreadMessagesCount === 0 ? UnreadMessagesCountHide : UnreadMessagesCountShow)+
        '<div class="listingIcon list-group-item-heading">'+ dialogIcon+'</div><div class="listingContent recentChat">' +
            '<h2 class="user_name">'+dialogName+'</h2>' +
        ''+
        '<p class="list-group-item-text last-message">'+
            (dialogLastMessage === null ?  "" : (isMessageSticker ? 'Sticker' : dialogLastMessage.substring(0,15)+ '...'))+
        '</p></div>'+
      '</a></li>';
  //}
  return dialogHtml;
}

// build html for typing status
//'<time class="pull-right">Typing...</time>'+
//'<h4 class="list-group-item-heading">'+ userLogin+'</h4>'+
function buildTypingUserHtml(userId, userLogin) {
  var typingUserHtml =
      '<div id="'+userId+'_typing" class="list-group-item typing">'+ 
        '<p class="list-group-item-text">Typing . . .</p>'+
      '</div>';

  return typingUserHtml;
}

// build html for users list
function buildUserHtml(userLogin, userId, userName, isNew) 
{
    // Check if any user is associated with current user
    for (var index1 = 0; index1 < jqueryarray.length; ++index1) {
    var animal1 = jqueryarray[index1]['quickbloxid'];
      if(animal1 == userId){


                  var userHtml = "<li><a href='javascript:void(0);' id='" + userId;
                  if(isNew){
                    userHtml += "_new'";
                  }else{
                    userHtml += "'";
                  }
                  userHtml += " class='col-md-12 col-sm-12 col-xs-12 users_form' onclick='";
                  userHtml += "clickToAddGroup";
                  userHtml += "(\"";
                  userHtml += userId;
                  if(isNew){
                    userHtml += "_new";
                  }
                  userHtml += "\")'>";
                  userHtml += '<div class="userListingGroup listingIcon list-group-item-heading"><i class="icon"><span class="fa fa-user"></span></i></div> <div class="groupUserName">';
                  userHtml += userName;
                  userHtml +="</div></a></li>";

      }
    } 

    return userHtml;
}


/// custom for contact list
function buildContactHtml(userLogin, userId, userName, isNew) {

  // Check if any user is associated with current user
  for (var index = 0; index < jqueryarray.length; ++index) 
  {
    var animal = jqueryarray[index]['quickbloxid'];

    if(userName != null){
      if(animal== userId){
        
          var userHtml = "<li><a href='javascript:void(0);' id='" + userId;
          if(isNew){
            userHtml += "_new'";
          }else{
            userHtml += "'";
          }
          userHtml += " class='' onclick='";
          userHtml += "createContactDialog";
          userHtml += "(\"";
          userHtml += userId;
          if(isNew){
            userHtml += "_new";
          }
          userHtml += "\")'>";
          userHtml += '<div class="listingIcon list-group-item-heading"><i class="icon"><span class="fa fa-user"></span></i></div>';
          userHtml += userName;
          userHtml +="</a></li>";

      }
    }
  }
  return userHtml;
}
