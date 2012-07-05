<?php
  include_once "config.php";
  include_once "../localization/strings.php";
  global $localization;
  $toReturn=new JsonResponse();
  foreach ($localization as $key => $translation){
  	$toReturn->set($key, $translation);  	
  }  
  echo $toReturn;
?>