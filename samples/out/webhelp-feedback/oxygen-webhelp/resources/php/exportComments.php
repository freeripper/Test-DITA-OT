<?php
require_once 'init.php';
$ses=Session::getInstance();

function getBaseUrl($product,$version){
	global $dbConnectionInfo;
	$toReturn=__BASE_URL__;
	$db= new RecordSet($dbConnectionInfo,false,true);
	$rows=$db->Open("SELECT value FROM webhelp WHERE parameter='path' AND product='".$product."' AND version='".$version."';");
	if ($rows==1){
		$db->MoveNext();
		$toReturn=$db->Field('value');
	}
	$db->Close();
	return $toReturn;	
}

if ((isset($_POST["productName"]) && trim($_POST["productName"]) !="")		
	&& (isset($_POST["productVersion"]) && trim($_POST["productVersion"]) !="")){
	
	$info= array();
	
	$pName=(isset($_POST['productName']) ? $_POST['productName'] :"");
	$pVersion=(isset($_POST['productVersion']) ? $_POST['productVersion'] : "");
	$fName=(isset($_POST['productN']) ? $_POST['productN'] :"");
	$fVersion=(isset($_POST['productV']) ? $_POST['productV'] : "");
	$fullUser=base64_encode($pName."_".$pVersion."_user");
	
	$info["sessionUserName"]=$fullUser;	
	$info["filter_version"]=$fVersion;
	$info["filter_product"]=$fName;
	
	$comment = new Comment($dbConnectionInfo,"",$fullUser);
	if (isset($_POST["inPage"]) && trim($_POST["inPage"]) =="true"){
		$exporter = new InLineExporter("comments",array('commentId'),array(45,24,16,7));
		$bserUrl = getBaseUrl($fName,$fVersion);
		$cellRenderer = new LinkCellRenderer($bserUrl);
		$cellRenderer->addLinkToField("page");
		$exporter->setCellRenderer($cellRenderer);
		$comment->exportForPage($info,$exporter,array('commentId','text','page','date','state'));
		echo $exporter->getContent();
	}else{
		$exporter = new XmlExporter("comments");
		$comment->exportForPage($info,$exporter);
		header('Content-Description: File Transfer');
		header('Content-Type: text/xml');
		header('Content-Disposition: attachment; filename=comments_'.$fName.'_'.$fVersion.'.xml');
		header('Content-Transfer-Encoding: binary');
		header('Expires: 0');
		header('Cache-Control: must-revalidate');
		header('Pragma: public');
		ob_clean();
		flush();
		echo $exporter->getContent();
  	exit;		
	}		
}else{
	echo "No data to export as comment!";
}
?>