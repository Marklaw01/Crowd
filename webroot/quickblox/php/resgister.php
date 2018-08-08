<?php
include 'config.php';
// Quickblox endpoints
DEFINE('QB_API_ENDPOINT', "https://api.quickblox.com");
DEFINE('QB_PATH_SESSION', "session.json");

// Generate signature
$nonce = rand();
$timestamp = time(); // time() method must return current timestamp in UTC but seems like hi is return timestamp in current time zone
$signature_string = "application_id=".APPLICATION_ID."&auth_key=".AUTH_KEY."&nonce=".$nonce."&timestamp=".$timestamp."&user[login]=".USER_LOGIN."&user[password]=".USER_PASSWORD;
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
        $responce . "\n <br><br>";
        
        //echo $responce['session']['token'];

} else {
        $error = curl_error($curl). '(' .curl_errno($curl). ')';
        $error . "\n";
}

// Close connection
curl_close($curl);

$response_a = json_decode($responce);
$token= $response_a->session->token;

//DEFINE('QB_API_ENDPOINT', "https://api.quickblox.com");
DEFINE('QB_PATH_USER', "users.json");
$post_body = http_build_query(
                        array(
                            'user'=>array(
                                'login' => $username,
                                'password' => $password,
                                'email' => $emailId,
                                'external_user_id' => $lastInsertId,
                                'facebook_id' => '',
                                'twitter_id' => '',
                                'full_name' => $name,
                                'phone' => '',
                                'website' => '',
                                'tag_list' => '',
                                )
                            )
                        );
//pr($post_body);
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

    
    //echo $responce . " \n";
    $response_b = json_decode($responce);
    //pr($response_b); die;
    if(array_key_exists('user', $response_b)){
        $quickId= $response_b->user->id;
    }else {
        $quickId= 'error';
    }

    
    
    return $quickId;

} else {
    $error = curl_error($signUpCurl). '(' .curl_errno($signUpCurl). ')';
    echo $error . "\n";
    $quickId= 'error';
    return $quickId;
}


?>