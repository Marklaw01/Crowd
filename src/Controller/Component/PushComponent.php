<?php
namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Controller\ComponentRegistry;
use Cake\Network\Exception\InternalErrorException;
use Cake\Utility\Text;
use Cake\ORM\TableRegistry;

class PushComponent extends Component
{
	
	/*it returns the profile image of a particular user*/
		
		public function sendAndroidPushNotification($user_id=null,$message=null,$values=null,$tag=null){
			/*$keywords = TableRegistry::get('contractor_basics');
		  
			$keywordsValue = $keywords->find('all',['conditions'=>['user_id'=>$user_id]])
										->select(['image'])
										->first();*/
			 
		//-------------------------------------------------------------
			
			$pushMessage= $message;
			
			$deviceTokens = $user_id;
			//$deviceTokens = array('enyQVisYgic:APA91bGqGBeulqWb6NgEY0yjjwl7di7PWUopVElxH5s4c5Gs4FtMZ3dDxNd2d7jVzBWMPVOi8bB3xpF6KipS6I2ok272vQOx59WjhoiCKxWGiGNBN3RYBO10f1XsVNElt52wwhHXqm5o');
			//$result =query("SELECT DeviceToken FROM tblDeviceInfo WHERE Platform='android' ");
			
			/*for($i=0;$i<count($result['result']);$i++){
				$deviceTokens[] = $result['result'][$i]['DeviceToken'];
			}*/
			 
			 
			 if($values!=null):
				$custom_value = $values;
			 else:
				$custom_value = []; 
			 endif;
			
			foreach($deviceTokens as $key => $registatoin_id){
				
				$gcmRegIds = array($registatoin_id);
				
				//CHECKING WHETHER THE FORUM IS OWN FORUM OR NOT
				
				/*if(!empty($custom_value)):
					if(isset($custom_value['own_forum'])
					   &&($custom_value['own_forum']=='DONTKNOW')
					   &&(!empty($custom_value['owner_tokens']))):
							
							if(in_array($registatoin_id,$custom_value['owner_tokens'])):
								$custom_value['own_forum'] = 'true';
							else:
								$custom_value['own_forum'] = 'false';
							endif;
							
							$link = $custom_value['link'];
							$logged_in_user = $custom_value['logged_in_user'];
							
							unset($custom_value['owner_tokens']);
							unset($custom_value['link']);
							unset($custom_value['logged_in_user']);
							
							$this->Contractor->saveNotification($logged_in_user,$single_userid,'Report_Abuse_Forum','has report abused <strong> you.</strong>',$link,json_encode($custom_value));
							
					endif;
				endif;*/
				
				$message = array("message" => $pushMessage,
								 "tag" => $tag,
								 "values"=>$custom_value);
				
				$this->sendPushNotificationToGCM($gcmRegIds, $message);
			}
			
			
		}
	
		function sendPushNotificationToGCM($gcmRegIds, $message) {
			
				//Google cloud messaging GCM-API url
				$url = 'https://android.googleapis.com/gcm/send';
				$fields = array(
					'registration_ids' => $gcmRegIds,
					'data' => $message,
				);
				// Google Cloud Messaging GCM API Key
				//define("GOOGLE_API_KEY", "AIzaSyDQ18y3vc76UXoSLtQuv7NHurrsVVklByE");
				
				$headers = array(
					'Authorization: key=AIzaSyDQ18y3vc76UXoSLtQuv7NHurrsVVklByE',
					'Content-Type: application/json'
				);
				$ch = curl_init();
				curl_setopt($ch, CURLOPT_URL, $url);
				curl_setopt($ch, CURLOPT_POST, true);
				curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
				curl_setopt ($ch, CURLOPT_SSL_VERIFYHOST, 0);	
				curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
				curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));
				$result = curl_exec($ch);				
				if ($result === FALSE) {
					die('Curl failed: ' . curl_error($ch));
				}
				
				curl_close($ch);
				//echo $result;
		}
		
	
	// Using to send push message to all iphone devices.
		function sendIphonePushMessage($tokens=null,$message=null,$values=null,$tag=null){
			
			//$message='Database has been updated on server.Please refresh your phone local database.';
			$streamContext = stream_context_create();
			stream_context_set_option($streamContext, 'ssl', 'local_cert', 'applepem/PushCert.pem');
			$deviceTokens = $tokens;
			 
			foreach($deviceTokens as $key => $token){
				$apns = stream_socket_client(

					'ssl://gateway.sandbox.push.apple.com:2195',

					//'ssl://gateway.push.apple.com:2195',

				$error,
				$errorString,
				60,
				STREAM_CLIENT_CONNECT, $streamContext);
				
				/*$load = array(
						  'aps' => array(
							  'alert' => $message,
							  'badge' => 0,
							  'sound' => 'default',
							  'pushType' => $tag
						  )
					  );*/
				
				$load = array(
						  'aps' => array(
							  'alert' => $message,
							  'badge' => 0,
							  'sound' => 'default',
							  'category' => $tag,
							  'values'=>$values
						  )
					  );
				
				$payload = json_encode($load);
		
				$apnsMessage = chr(0) . chr(0) . chr(32);
				 
				$apnsMessage .= pack('H*', str_replace(' ', '', $token));
				$apnsMessage .= chr(0) . chr(strlen($payload)) . $payload;
				fwrite($apns, $apnsMessage);
			}
		
			//echo $payload = json_encode($load);		
			fclose($apns);
		}
}
?>