<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	</head>
	<body style="margin-top: 30px;" yahoo="fix" >
		<table border="0" cellspacing="0" cellpadding="0" class="deviceWidth" style="margin:0 auto;   background: #e5e5e5;padding:20px;box-sizing:border-box;">
			<tr class="mail_header" style="background:#03375c none repeat scroll 0 0; width: 95%; margin: 0px auto; padding-left: 2%; padding-right: 2%; min-height: 100px; background-repeat: repeat; height: 100px;">
				<td><p style="text-align: center; margin: 0px 0px 15px; padding: 9px 0px 0px 13px;"><img class="" width="143px" alt="Crowd Bootstrap" src="https://nodatplace.com/images/logo.png"></p></td>
			</tr>
			<tr>
				<td style="padding:10px;">
					<br/>
					<p style="margin: 10px 0;line-height: 1.2;">Dear <?php echo $fullname;?>:</P>
					<br/>
					<p style="margin: 10px 0;line-height: 1.2;">Please click the link below to complete the registration process.</p>
					<br/>
					<a href="<?php echo $url;?>" target="_blank" title="Click Here">Activate Account</a> or Copy & Paste below url to browser.
					<br/>
					<p style="margin: 10px 0;line-height: 1.2;"> <?php echo $url;?> </p>
					<br/>
					<!-- <p style="margin: 10px 0;line-height: 1.2;">Gain the competitive advantage exclusive to Fortune 500 companies</p> -->
				</td>
			</tr>
			<tr>
				<td  style="padding:10px;" class="cellwidth2">
					Thanks,<br/><br/>
					Crowd Bootstrap Team
					<br/>
					<br/>
					<br/>	
				</td>
			</tr>
			<tr class="mail_footer" style="background:#03375c none repeat scroll 0 0; width: 95%; margin: 0px auto; padding-left: 2%; padding-right: 2%; background-repeat: repeat-x; min-height: 100px; height: 100px;">
				<td><p style="text-align:center;padding-top:9px;color:#ffffff;font-size:11px;font-weight:bold">&copy; Copyright 2017 &nbsp; <?php echo 'www.'.$_SERVER['SERVER_NAME'];?> &nbsp; All Rights Reserved.</p></td>
			</tr>
		</table>
	</body>
<html>