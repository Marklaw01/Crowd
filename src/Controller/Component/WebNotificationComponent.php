<?php
namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Controller\ComponentRegistry;
use Cake\Network\Exception\InternalErrorException;
use Cake\Utility\Text;
use Cake\ORM\TableRegistry;

class WebNotificationComponent extends Component
{
	function sendNotification($sender,$receiver,$type,$title,$link,$values)
	{
			  
      
        //$this->loadModel('userNotifications'); 
        if($type == 'Add_member'){
          //pr($values);
          $finaAnroidMsg= ['startup_id'=>$values['startup_id'],'extra_message'=>$values['android_message']];
          
          $finaiOsMsg= ['startup_id'=>$values['startup_id'], 'extra_message'=>$values['ios_message']];

          $saveValue=json_encode($finaAnroidMsg);
          $title=$values['android_message'];
          $message = $this->entrepreneurName($sender)." has sent you an invitation for the startup ".$this->startupName($values['startup_id']); 
        }else {

          $finaAnroidMsg=$values;
          $finaiOsMsg=$values;

          if(!empty($values)){
            $saveValue=json_encode($values);
          }else{
            $saveValue=json_encode((object)$values);
          }
          $message = $this->contractorName($sender).' '.strip_tags($title); 
        }  

        
			        $userNotifications = TableRegistry::get('userNotifications');
              $notification = $userNotifications->newEntity();
              $notification->sender_id = $sender;
              $notification->receiver_id = $receiver;
              $notification->type = $type;
              $notification->title = $title;
              $notification->link = $link;
              $notification->data = $saveValue;
              $cc=$userNotifications->save($notification);
                  if ($cc) {
                    if($type=='Add_member'){  

                      $finaAnroidMsg['notification_id'] = $cc['id'];
                      $finaiOsMsg['notification_id'] = $cc['id'];
                      
                    } 
                  }else {
                    
                  }

                 
              $UserTokens = TableRegistry::get('UserTokens');    
              $userToken = $UserTokens->find('all',['conditions'=>['UserTokens.user_id'=>$receiver]])->select(['device_type','access_token']);
              
              $finalTokens = [];
              $finalIosTokens = [];
              $blankArray=[];

              if($userToken->toArray()):
                
                $tokens = $userToken->toArray();
                
                foreach($tokens as $single_token):
                
                  if($single_token['access_token']!=''):
                      //$finalTokens[] = $single_token['access_token'];

                    if (!in_array($single_token['access_token'], $blankArray)){

                      if($single_token['device_type']=='android'):
                        $finalTokens[] = $single_token['access_token'];
                      else:
                        if($single_token['device_type']=='ios'){
                      		$length = strlen($single_token['access_token']);
                      		if($length >60){
                        		$finalIosTokens[] = $single_token['access_token'];
                        	}	
                        } 
                      endif;
                    }  
                    array_push($blankArray,$single_token['access_token']);  

                  endif;
                  
                endforeach;
              endif;
       //print_r($finaAnroidMsg);
       //print_r($finaiOsMsg); die;   
       //$finaAnroidMsg=[];
       //$finaiOsMsg=['startup_id'=>1,'extra_message'=>'hello'];
              if(!empty($finalTokens)):
                $this->sendAndroidPushNotification($finalTokens,$message,$finaAnroidMsg,$type);  
              endif;  

              if(!empty($finalIosTokens)):
                $this->sendIphonePushMessage($finalIosTokens,$message,$finaiOsMsg,$type);
              endif; 
      //print_r($finalIosTokens);
      //print_r($message);
      //print_r($finaiOsMsg);
      //print_r($type);   die;     
	}		

  public function sendAndroidPushNotification($user_id=null,$message=null,$values=null,$tag=null)
  {
         $pushMessage= $message;
      
         $deviceTokens = $user_id;
    		if($values!=null):
            $custom_value = $values;
        else:
            $custom_value = []; 
        endif;
       
        foreach($deviceTokens as $key => $registatoin_id){
          $gcmRegIds = array($registatoin_id);
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
        
        //Api Key For Staging 
        /*$headers = array(
          'Authorization: key=AIzaSyDQ18y3vc76UXoSLtQuv7NHurrsVVklByE',
          'Content-Type: application/json'
        );*/
        
        //Api Key For Production

        $headers = array(
          'Authorization: key=AIzaSyABVL3JTP0h_jN0JYCFkeHxiGfbneg6Qck',
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
        'ssl://gateway.push.apple.com:2195',
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
         
         /*$bindata="";
        for ($i=0;$i<strlen($token);$i+=2) {
            $bindata.=chr(hexdec(substr($token,$i,2)));
        }
        $apnsMessage .=$bindata;*/

        $apnsMessage .= pack('H*', str_replace(' ', '', $token));
        $apnsMessage .= chr(0) . chr(strlen($payload)) . $payload;
        fwrite($apns, $apnsMessage);
      }
    
      //echo $payload = json_encode($load);   
      fclose($apns);
    }



  public function contractorName($user_id=null)
  {
      $users = TableRegistry::get('users');
      
      $userValue = $users->find('all',['conditions'=>['users.id'=>$user_id]])
                    ->contain(['ContractorBasics'])
                    ->first();
      
      if(!empty($userValue['contractor_basic'])&& isset($userValue['contractor_basic'])){
        
        $first_name = ($userValue['contractor_basic']->first_name!='')?$userValue['contractor_basic']->first_name:' ';
        $last_name = ($userValue['contractor_basic']->last_name!='')?$userValue['contractor_basic']->last_name:' ';
        
        return $first_name.' '.$last_name;
        
      }elseif(!empty($userValue)){
        
        $first_name = ($userValue->first_name!='')?$userValue->first_name:' ';
        $last_name = ($userValue->last_name!='')?$userValue->last_name:' ';
        
        return $first_name.' '.$last_name;          
      }else{
        return '';  
      }
      
    }


  /*it returns the entrepreneur name from entrprnr or user table*/
    
    public function entrepreneurName($user_id=null){
      $users = TableRegistry::get('users');
      
      $userValue = $users->find('all',['conditions'=>['users.id'=>$user_id]])
                    ->contain(['EntrepreneurBasics'])
                    ->first();
      
      if(!empty($userValue['entrepreneur_basic'])&& isset($userValue['entrepreneur_basic'])){
        
        $first_name = ($userValue['entrepreneur_basic']->first_name!='')?$userValue['entrepreneur_basic']->first_name:' ';
        $last_name = ($userValue['entrepreneur_basic']->last_name!='')?$userValue['entrepreneur_basic']->last_name:' ';
        
        return $first_name.' '.$last_name;
        
      }elseif(!empty($userValue)){
        
        $first_name = ($userValue->first_name!='')?$userValue->first_name:' ';
        $last_name = ($userValue->last_name!='')?$userValue->last_name:' ';
        
        return $first_name.' '.$last_name;          
      }else{
        return '';  
      }
      
    }


   /*getting the consumed hours by a team member*/
    
    public function startupName($startup_id=null){
      $camapigns = TableRegistry::get('startups');
       
      $query = $camapigns->find();
      $keywordsValue = $query->select(['name'])
                  ->where(['id'=>$startup_id])
                  ->first(); 
      
      if(!empty($keywordsValue)&&($keywordsValue['name']!='')):
        return $keywordsValue['name'];
      else:
        return '0';
      endif;
      
    } 
    

  public function getUserQuickbloxId($user_id=null)
  {
      $users = TableRegistry::get('users'); 
      $userValue = $users->find('all',['conditions'=>['users.id'=>$user_id]])
                    ->select(['quickbloxid'])
                    ->first();
      $userQuickbloxId = $userValue->quickbloxid;   
      
      return  $userQuickbloxId;       
  }  


  public function getUserTimeZoneByIp()
  {

  
    $usertimeZone = 'UTC';
    $ip_address = getenv('HTTP_CLIENT_IP') ?: getenv('HTTP_X_FORWARDED_FOR') ?: getenv('HTTP_X_FORWARDED') ?: getenv('HTTP_FORWARDED_FOR') ?: getenv('HTTP_FORWARDED') ?: getenv('REMOTE_ADDR');

      // Get JSON object
      $jsondata = file_get_contents("http://timezoneapi.io/api/ip/?" . $ip_address);

      // Decode
      $data = json_decode($jsondata, true);

      // Request OK?
      if($data['meta']['code'] == '200'){

          // Example: Get the city parameter
          //echo "Ip Address: " . $ip_address . "<br>";

          //echo "City: " . $data['data']['city'] . "<br>";

          // Example: Get the users time
          //echo "Time: " . $data['data']['datetime']['date_time_txt'] . "<br>";

          $usertimeZone = $data['data']['timezone']['id'];
          //echo "Time Zone: " . $data['data']['timezone']['id'] . "<br>";

      }

      return $usertimeZone;
  }


}
?>