<link rel="stylesheet" href="<?php echo $this->request->webroot;?>quickblox/libs/stickerpipe/css/stickerpipe.min.css">
<link rel="stylesheet" href="<?php echo $this->request->webroot;?>quickblox/css/style.css">


<script type="text/javascript">
	QB.init(QBApp.appId, QBApp.authKey, QBApp.authSecret);
	$(document).ready(function() {
		var params = { 'login': login, 'password': password};
	    QB.users.create(params, function(err, user){
	      if (user) {
	      	alert(JSON.stringify(user));
	        //$('#output_place').val(JSON.stringify(user));
	      } else  {
	      	alert(JSON.stringify(err));
	        //$('#output_place').val(JSON.stringify(err));
	      }

	    });

	});
</script>








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




