<?php
$cfgFile = '../oxygen-webhelp/resources/php/config/config.php';
if (file_exists($cfgFile)){
	@include_once $cfgFile;
}else{
	@include_once './config-dist.php';
}
	global $dbConnectionInfo;
	$baseUrl = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] != 'off') ? 'https://' : 'http://';
	$baseUrl .= isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : getenv('HTTP_HOST');
	$baseUrl .= isset($_SERVER['SCRIPT_NAME']) ? dirname(dirname($_SERVER['SCRIPT_NAME'])) : dirname(dirname(getenv('SCRIPT_NAME')));
	
  $baseUrl =rtrim($baseUrl, '/\\');
  $baseUrl.="/";
  $baseDir0 = dirname(dirname(__FILE__));
  if (!defined("__BASE_URL__")){	  
  define("__BASE_URL__", $baseUrl);
  }
  
  //require_once DP_BASE_DIR.'/oxygen-webhelp/resources/php/classes/db/RecordSet.php';
  include $baseDir0.'/oxygen-webhelp/resources/php/init.php';
 $ses= Session::getInstance();
 function sval($str,$default){
 	if (isset($_SESSION[$str])){
 		return $_SESSION[$str];
 	}else{
 		return $default;
 	}
 }
function check($id,$name){
	if (isset($_SESSION[$name])){
		if ($_SESSION[$name]=='on'){
			echo "<script type=\"text/javascript\">$('#".$id."').attr('checked','checked');</script>";			
		}else{
		echo "<script type=\"text/javascript\">$('#".$id."').removeAttr('checked');</script>";
		}
	}
}
 
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US">
<head>
	<title>&lt;oXygen/&gt; XML Editor - WebHelp</title>
	<meta name="Description" content="WebHelp Installer"/>
	<META HTTP-EQUIV="CONTENT-LANGUAGE" CONTENT="en-US"/>
 	<link rel="stylesheet" type="text/css" href="install.css"/>
  <script type="text/javascript" src="../oxygen-webhelp/resources/js/jquery.js"> </script>
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
		
      <form id="doInstallData" name="installForm" action="do_install.php" method="post">
<?php 
		$cfgFile = '../oxygen-webhelp/resources/php/config/config.php';
if (file_exists($cfgFile)){
			?>      
<div class="panel">
	<div class="title">Configuration File</div>
	<table>
	 <tr>
	   <td>
	     Overwrite Config File
	     <div class="settingDesc">Replaces the existing config file.</div>
	   </td>
	   <td>
	   			<input type="checkbox" id="ck_OverWrite" name="overWriteConfig" title="Overwrite config file if exists." />
	   			<?php check('ck_OverWrite','overWriteConfig');?>
	   </td>
	 </tr>
	 </table>
	</div>
		<?php 
		}else{
			echo "<input type=\"hidden\" id=\"ck_OverWriteHid\" name=\"overWriteConfig\" value=\"on\"/>";
		}
		?>
  
<div class="panel" id="cfgPanel" style="display: none;">
	<div class="title">Deployment Settings</div>
	<table>
	 <tr>
	   <td>Deployment URL
	     <div class="settingDesc">The URL where the webhelp is installed on.</div>
	   </td>
	   <td>
	     <input type="text" size="25" name="baseUrl"  readonly="readonly" value="<?php echo sval('baseUrl',$baseUrl); ?>" title="The URL where the webhelp is installed on" />
	   </td>
	 </tr>
	 <tr>
	   <td>SMTP server
	     <div class="settingDesc">This can be changed by altering your PHP Runtime Configuration, usually located in "php.ini" file</div>
	   </td>
	   <td>
	     <input type="text" size="25" name="smtp"  readonly="readonly" value="<?php echo ini_get("SMTP")." : ".ini_get("smtp_port") ?>" title=" The email server used " />
	   </td>
	 </tr>
	 <tr>
	   <td>WebHelp E-mail address
  	   <div class="settingDesc">This e-mail address is used as the 'From' address in e-mails.</div>
	   </td>
	   <td><input type="text" size="25" name="email" value="<?php echo sval('email',__EMAIL__); ?>" title="Email address to be used as From in sent emails" /></td>
	 </tr>
	 <tr>
  	<td>
  	 Comment system is moderated
  	 <div class="settingDesc">If the system is moderated each post must be confirmed by moderator.</div>
  	 </td>
		<td>
			<input id="ckModerate" type="checkbox" name="moderated" <?php 
			if (__MODERATE__=="true"){
					echo "checked=checked";
			}?> title="If the system is moderated each post must be confirmed by moderator" />
			<?php check('ckModerate','moderated');?>
		</td>	   
	 </tr>
	 <tr>
		<td>Session lifetime (sec)
		<div class="settingDesc">User session lifetime in seconds, by default is 7 days.</div>
		</td>
		<td>
			<input type="text" size="25" name="sesLifeTime" value="<?php echo sval('sesLifeTime',__SESSION_LIFETIME__); ?>" title="User session lifetime in seconds, by default is 7 days" />
		</td>
	 </tr>
	 <tr>
		<td>Allow posts as 'Anonymous'
		<div class="settingDesc">This allows the unauthenticated user to post comments.</div>
		</td>
		<td>
			<input id="ckAnonPost" type="checkbox" name="anonymousPost" <?php 
			if (__GUEST_POST__=="true"){
					echo "checked=checked";
			}?> title="Is unauthenticated user allowed to post comments" />
			<?php check('ckAnonPost','anonymousPost');?>
		</td>
	 </tr>
  </table>	
</div>	

<div class="panel" id="dbPanel" style="display:none;">
	<div class="title">MySql Database Connection Settings</div>
	<div class="desc">If your database is not setup yet, please contact your system administrator. He should create an empty MySQL database, and a user with full rights on that database.</div>	
	<table>
	 <tr>
			<td>Create new database structure
			<div class="settingDesc">If checked, all database tables will be created. Note that if you checked it and you already have tables in place, data in these tables will be lost!</div>
			</td>
			<td>
			 <input id="createDb" type="checkbox" name="createDb" title="Overwrite database if exists!" />
			 <?php check('createDb','createDb');?>
			</td>
	</tr>
	<tr>
			<td>Database Host Name
			<div class="settingDesc"></div>
			</td>			
			<td>
				<input type="text" size="25" name="dbhost" value="<?php echo sval('dbhost',$dbConnectionInfo['dbHost']); ?>" title="The Name of the Host the Database Server is installed on" />
			</td>
	</tr>
	<tr>
			<td>Database Name
			<div class="settingDesc"></div>
			</td>
			<td>
				<input type="text" size="25" name="dbname" value="<?php echo  sval('dbname',$dbConnectionInfo['dbName']); ?>" title="The Name of the Database Weh Help will use and/or install" />
			</td>
	</tr>
	<tr>
			<td>Database Username
			<div class="settingDesc"></div></td>
			<td>
				<input type="text" size="25" name="dbuser" value="<?php echo sval('dbuser',$dbConnectionInfo['dbUser']); ?>" title="The Database User that Web Help uses for Database Connection" />
			</td>
	</tr>
	<tr>
			<td>Database User Password
			<div class="settingDesc"></div>
			</td>
			<td>
				<input type="password"  size="25" name="dbpass" value="<?php echo sval('dbpass',$dbConnectionInfo['dbPassword']); ?>" title="The Password according to the above User." />
			</td>	
	</tr>
	</table>	
</div>

<div class="panel" id="adminPanel" style="display:none;">
	<div class="title">Create Webhelp Administrator Account</div>
	<div class="desc">The administrator has full control over the WebHelp system. Make sure you provide a strong password.</div>
	<table>
	<tr>
			<td>Username
			</td>
			<td>
				<input type="text" size="25" name="adminUserName" value="<?php echo sval('adminUserName','administrator');?>" title="The administrator username." />
			</td>
	</tr>
	 <tr>
     <td>E-mail
      </td>
		<td>
			<input id="aEmail" type="text" size="25" name="adminEmail" value="<?php echo sval('adminEmail',(defined('__ADMIN_EMAIL__') ? __ADMIN_EMAIL__ : "")); ?>" title="Email address to be notified when error occur" />
		</td>
	 </tr>
	 <tr>
			<td>Password
			 </td>
			<td>
			 <input id="aPass" type="password" size="25" name="adminPasswd" title="Initial administrator password." value="<?php echo sval('adminPasswd','');?>" />
			</td>
	</tr>
	<tr>
			<td>Confirm Password
			</td>			
			<td>
			 <input id="cPass" type="password" size="25" name="cadminPasswd" title="Confirm initial administrator password." value="<?php echo sval('cadminPasswd','');?>"/>
			</td>
	</tr>
	 <tr>
	   <td>Send Errors to System Administrator
	       <div class="settingDesc">If checked, the web help system error reports are forwarded to the administrator email address.</div>
	   </td>
	   <td>
        <input id="ckSendErr" type="checkbox" name="sendErrors" <?php 
    		if (__SEND_ERRORS__=="true"){
    				echo "checked=checked";
    		}?> title="Send errors to system administartor" />
    		<?php check('ckSendErr','sendErrors');?>
	   </td>
  </tr>
	
	</table>
</div>		
	
<div class="btActions">
  <input type="submit" value="Next Step" />
  <input type="button" value="Back" onclick="window.location.href ='index.php';" />
</div>

</form>

<script type="text/javascript">
function validateEmail(email) { 
  var re =/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);
} 

$("#doInstallData").submit(function() {
	if ($('#createDb').is(':checked')){
	if ($("#aPass").val().length<5){
		alert('Administrator password must have at least 5 characters !');
  	return false;
	}else if ($("#aEmail").val().length==0 || !validateEmail($("#aEmail").val())){
		alert('Please insert a valid administrator email!');
		return false;
	}else{		
		if ($("#aPass").val()!=$("#cPass").val()){
  	alert('Please confirm administrator password correctly!');
  	return false;
	}else{
		return true;
	}
	}
	}
});
$('#ck_OverWrite').change(function() {
	if ($(this).is(':checked')){
  	$('#dbPanel').show();
  	$('#cfgPanel').show();
	}else{
		$('#dbPanel').hide();
		$('#cfgPanel').hide();
	}
});

if (($('#ck_OverWriteHid').val()=='on')||($('#ck_OverWrite').is(':checked'))){
	$('#dbPanel').show();
	$('#cfgPanel').show();
	//$('#createDb').attr('checked', true);	
}

if ($('#createDb').is(':checked')){
	$('#adminPanel').show();	
}


$('#createDb').change(function() {
	if ($(this).is(':checked')){
  	$('#adminPanel').show();
  	alert("WARNING !! \n By selecting this option the contents of the specified \n database will be dropped,\n and a new table structure will be created!");
	}else{
		$('#aPass').val("");
		$('#cPass').val("");
		$('#adminPanel').hide();
	}
});
			</script>
</body>
</html>
