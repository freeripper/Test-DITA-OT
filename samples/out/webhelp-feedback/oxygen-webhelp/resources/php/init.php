<?php

	$baseDir = dirname(dirname(__FILE__));

	if (file_exists($baseDir.'/php/config/config.php')){
  	include_once $baseDir.'/php/config/config.php';
  	$ses=Session::getInstance();
  	if (!isset($ses->errBag)){
  		$ses->errBag= new OxyBagHandler();
  	}  	  	
	}
	
	global $dbConnectionInfo;
	
	if (file_exists($baseDir.'/localization/strings.php')){
  	include_once $baseDir.'/localization/strings.php';
	}

//set error handler
set_error_handler("OxyHandler::error");
set_exception_handler("OxyHandler::exception");


// if (!isset($dbConnectionInfo)){
// 	throw new Exception("DB connection info not available!");
// }


/**
 * Loads a class form a specified directory 
 * @param String $dirToCheck directory to cheeck for class
 * @param String $fileName class to load
 * @return boolean
 */
function loadClassFromDir($dirToCheck,$fileName){
	$toReturn=FALSE;
	if ($handle = opendir($dirToCheck)) {
		/* recurse through directory. */
		while (false !== ($directory = readdir($handle)) && !$toReturn) {
			if (is_dir($dirToCheck.$directory)){
				if ($directory!="." && $directory!=".."){
					$path = trim($dirToCheck.$directory."/".$fileName.".php");
// 					echo "check: ".$path."<br/>";
					if(file_exists($path)){
						require_once $path;						
						$toReturn=TRUE;											
					}
					if (!$toReturn){						
						$toReturn=loadClassFromDir($dirToCheck.$directory."/",$fileName);
					}
				}
			}
		}
		closedir($handle);
	}
	return $toReturn;
}

/**
 * @param String $name
 * @throws Exception
 */
function __autoload($name) {
	$found=FALSE;
	
	$baseDir = dirname(dirname(__FILE__));
	
	if (defined('__BASE_URL__')){
		$parts=explode("/", __BASE_URL__,4);
	 if (count($parts)<4){
		  $classPath = $_SERVER['DOCUMENT_ROOT']."/oxygen-webhelp/resources/php/classes/";
    }else{
      $classPath = $_SERVER['DOCUMENT_ROOT']."/".$parts[3]."/oxygen-webhelp/resources/php/classes/";
    }
	}else{
		
		$classPath = $baseDir."/php/classes/";
	}
	
	$directory=$classPath;
	$path = $classPath.$name.".php";
	if(file_exists($path)){
		require_once $path;		
		$found =TRUE;		
	}else{
		$found = loadClassFromDir($classPath,$name);
	}
	
	if (!$found){
		echo "Want to load $name.\n";
		throw new Exception("Unable to load $name.");
	}
}

?>