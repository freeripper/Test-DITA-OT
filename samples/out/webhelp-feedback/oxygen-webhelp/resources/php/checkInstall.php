<?php
require_once "init.php";
$cfgFile = './config/config.php';
$cfgInstall = '../../../install/';
$toReturn = new JsonResponse();
if (file_exists($cfgInstall)){
	$toReturn->set("installPresent", "true");
}else{
	$toReturn->set("installPresent", "false");
}
if (file_exists($cfgFile)){
	$toReturn->set("configPresent", "true");
}else{
	$toReturn->set("configPresent", "false");	
}
echo $toReturn;

?>