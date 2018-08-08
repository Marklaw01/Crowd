<?php
include 'config.php';


// Quickblox endpoints
DEFINE('QB_API_ENDPOINT', "https://api.quickblox.com");
DEFINE('QB_PATH_SESSION', "session.json");

// Generate signature
$nonce = rand();
$timestamp = time(); // time() method must return current timestamp in UTC but seems like hi is return timestamp in current time zone
$signature_string = "application_id=".APPLICATION_ID."&auth_key=".AUTH_KEY."&nonce=".$nonce."&timestamp=".$timestamp."&user[login]=".USER_LOGIN."&user[password]=".USER_PASSWORD;

echo "stringForSignature: " . $signature_string . "<br><br>";
$signature = hash_hmac('sha1', $signature_string , AUTH_SECRET);

// Build post body
$post_body = http_build_query(array(
                'application_id' => APPLICATION_ID,
                'auth_key' => AUTH_KEY,
                'timestamp' => $timestamp,
                'nonce' => $nonce,
                'signature' => $signature,
                'user[login]' => USER_LOGIN,
                'user[password]' => USER_PASSWORD
                ));

 $post_body = "application_id=" . APPLICATION_ID . "&auth_key=" . AUTH_KEY . "&timestamp=" . $timestamp . "&nonce=" . $nonce . "&signature=" . $signature . "&user[login]=" . USER_LOGIN . "&user[password]=" . USER_PASSWORD;

 echo "postBody: " . $post_body . "<br><br>";
// Configure cURL
$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, QB_API_ENDPOINT . '/' . QB_PATH_SESSION); // Full path is - https://api.quickblox.com/session.json
curl_setopt($curl, CURLOPT_POST, true); // Use POST
curl_setopt($curl, CURLOPT_POSTFIELDS, $post_body); // Setup post body
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true); // Receive server response

// Execute request and read responce
$responce = curl_exec($curl);

// Check errors
if ($responce) {
        echo $responce . "\n <br><br>";
        
        //echo $responce['session']['token'];

} else {
        $error = curl_error($curl). '(' .curl_errno($curl). ')';
        echo $error . "\n";
}

// Close connection
curl_close($curl);

$response_a = json_decode($responce);
echo $token= $response_a->session->token;

DEFINE('QB_API_ENDPOINT', "https://api.quickblox.com");
DEFINE('QB_PATH_USER', "users.json");
$post_body = http_build_query(
                        array(
                            'user'=>array(
                                'login' => 'test1436547745678568768',
                                'password' => 'test1234',
                                'email' => 'test1@test1.com',
                                'external_user_id' => '68764641',
                                'facebook_id' => '',
                                'twitter_id' => '',
                                'full_name' => 'test1 test1',
                                'phone' => '',
                                'website' => '',
                                'tag_list' => '',
                                )
                            )
                        );

$signUpCurl = curl_init();
curl_setopt($signUpCurl, CURLOPT_URL, QB_API_ENDPOINT . '/' . QB_PATH_USER);
curl_setopt($signUpCurl, CURLOPT_HTTPHEADER, array("QB-Token: ".$token));
curl_setopt($signUpCurl, CURLOPT_POST, true);
curl_setopt($signUpCurl, CURLOPT_POSTFIELDS, $post_body);
curl_setopt($signUpCurl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($signUpCurl, CURLOPT_SSL_VERIFYPEER, FALSE);

$responce = curl_exec($signUpCurl);

// Check errors
if ($responce) {
  echo $responce . " b \n";
} else {
  $error = curl_error($signUpCurl). '(' .curl_errno($signUpCurl). ')';
  echo $error . " dgfasd \n";
}

?>