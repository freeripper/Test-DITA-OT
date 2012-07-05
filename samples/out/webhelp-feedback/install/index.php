<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US">
<head>
<title>&lt;oXygen/&gt; XML Editor - WebHelp</title>
<meta name="Description" content="WebHelp Installer"/>
<META HTTP-EQUIV="CONTENT-LANGUAGE" CONTENT="en-US"/>
<link rel="stylesheet" type="text/css" href="install.css"/>
</head>
<body>
	 <div id="logo">		
			<img src="./img/LogoOxygen100x22.png" align="middle" alt="OxygenXml Logo" />
			WebHelp Installer
		</div>
		<h1 class="centerH">     
		Installation Settings for  
      <span class="titProduct">dita-help-test</span>&nbsp;<span class="titProduct">1.0</span>           
		</h1>
		<form action="index1.php" method="post" name="form" id="doInstallData">
			
    	<div class="panel"><p>Welcome to the WebHelp Installer! It will setup the
    		database for WebHelp feedback system and create an appropriate config
    		file. In some cases a manual installation cannot be avoided.</p>
    		<p>There is an initial Check for (minimal) Requirements appended down
    		below for troubleshooting. A MySql database connection must be
    		available and ../oxygen-webhelp/resources/php/config.php must be
    		writable for the webserver!</p>		
    	</div>
      <?php include('check.php');  ?>
      
  </form>

</body>
</html>
