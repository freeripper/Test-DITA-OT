<?php
require_once 'init.php';
 
 //$ses=Session::getInstance(); 
  	$json = new JsonResponse();
if (isset($_POST['userName']) && trim($_POST['userName']) != ''){
  // send email to support
  
  $info['username']= $_POST['userName'];
  $info['name'] = $_POST['name'];
  $info['password'] = $_POST['password'];
  $info['email'] = $_POST['email']; 
  
  $user= new User($dbConnectionInfo);
  $return = $user->insertNewUser($info);  
  if ($return->error=="true"){
  	echo $return;  	  	
  }else{
  	$id=base64_encode($user->userId."|".$user->date);
    $link="<a href='".__BASE_URL__."oxygen-webhelp/resources/confirm.html?id=$id'>".__BASE_URL__."oxygen-webhelp/resources/confirm.html?id=$id</a>";
  	$template = new Template("./templates/signUp.html");
  	$confirmationMsg = $template->replace(array("name"=>$info['name'],"username"=>$info['username'],"confirmationLink"=>$link));
  	  	  
  	$mail = new Mail();
  	$mail->Subject("[".$_POST['product']."] ".$translate['signUpEmailSubject']);  
  	$mail->To($info['email']);  	
  	$mail->From(__EMAIL__);  	
  	$mail->Body($confirmationMsg);  	
  	$mail->Send();    	
	$json->set("error", "false");
	$json->set("msg", "SignUp Success");
	echo $json;	  	
  }
}else{
	$json->set("error", "true");
	$json->set("errorCode", "6");
	$json->set("msg", "Invalid username!");
	echo $json;
}
?>