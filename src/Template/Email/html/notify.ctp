<?php

		if(isset($_SERVER['HTTPS'])){
		    $protocol = ($_SERVER['HTTPS'] && $_SERVER['HTTPS'] != "off") ? "https" : "http";
		}else{
		    $protocol = 'http';
		}
		$baseurl = $protocol . "://" .$_SERVER['SERVER_NAME'];
?>
<html>
	<head>
	<meta name="viewport" content = "width = device-width, initial-scale = 1.0, minimum-scale = 1, maximum-scale = 1.0 , user-scalable = no"/>
	<link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,300italic,400italic,600,600italic,700,700italic,800,800italic' rel='stylesheet' type='text/css'>
	<style>
			.deviceWidth{width:600px;}
			img{max-width:100%; }
			.semiWidth{width:70%;}
			.midWidth{width:90%;}

			@media (max-width:600px)  {
				table.deviceWidth{width:95% ;}
				table.semiWidth{width:100% ;}  
			}
			
	</style>
	</head>
	<body>
		<table cellspacing="0"  cellpadding="0" class="deviceWidth" style="margin:0px auto; 
		font-size:14px;font-family: 'Open Sans',sans-serif; background:#fff; border:1px solid #005d22" >
			<tbody>
				<tr>
					<td colspan="2" style="border-bottom:4px solid #005d22; background:#eaeaea; text-align:center; padding-top:10px; padding-bottom:10px;"><img src="<?php echo $baseurl.'/webroot/img/emaillogo.png'; ?>" alt="logoHeader"> </td>
				
				</tr>
			
				 <!--Header ends and body starts-->
				<tr>
					<td colspan="2">
						<table width="100%" style="padding:10px 10px 10px 10px;font-size:15px;font-family:'Open Sans',sans-serif;">
							<tbody>
								<tr>
									<td>

										<p style="line-height:22px; margin-bottom:10px; font-size:16px;">Dear <?= $userName ?>,</p>
									</td>
								</tr>
								<tr>
									<td>

										<p style="line-height:22px; margin-bottom:20px;  font-size:15px" >
											<?= $notifyContent ?>
                                        </p>
									</td>
								</tr>	
							</tbody>
						</table>
					</td>				
				</tr>
			</tbody>
			<tfoot  style="background:#f1f1f1;font-size:15px;font-family:'Open Sans',sans-serif; font-weight:normal;">
				<tr>
					<td style="padding:10px 10px 10px 10px; ">
						<p style="line-height:25px;font-size:15px;">Thanks,<br>
						Harbor Country Day School</p>
					</td>
				</tr>
			</tfoot>					
		</table>		
	</body>
<html>