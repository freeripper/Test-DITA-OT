<?php
require_once 'init.php';
if (isset($_POST["qInfo"]) && trim($_POST["qInfo"]) !="" && ($_POST["qInfo"]=="true")){	
	$pName=(isset($_POST['productName']) ? $_POST['productName'] :"");
	$pVersion=(isset($_POST['productVersion']) ? $_POST['productVersion'] : "");
	$fullUser=base64_encode($pName."_".$pVersion."_user");
	$comment = new Comment($dbConnectionInfo,"",$fullUser);
	$vList=$comment->queryInfo();
	$toPrint="";	
	if (count($vList)>0){
	$idx=0;
	$toPrint.="<div class='listTitle'>".Utils::translate("productsListTitle")."</div>";
	$toPrint.="<div class='listTitleV'>".Utils::translate("versionsListTitle")."</div>";
	$toPrint.="<div class='products'>";
	foreach ($vList as $origProduct => $versions){	
		$product=$origProduct;		
		$toPrint.="<div class='p_selectable' id='p_$idx' onclick=\"showVersions('$idx','$product');\">".$product."</div>";					
		$idx++;
	}
	$toPrint.="</div>";
	$toPrint.="<div class='versions' style='display:none;'>";
	$idx=0;
	foreach ($vList as $origProduct => $versions){
		$toPrint.="<div class='product_Versions' id='v_$idx' style='display:none;'>";
		$vidx=0;
		foreach ($versions as $version){
			$toPrint.="<div id='ver_".$idx."_".$vidx."' class='selectable' onclick=\"setExpVersion(this,'$version');\">".$version."</div>";			
			$vidx++;
		}
		$toPrint.="</div>";	
		$idx++;
	}
	$toPrint.="</div>";
	}else{
		$toPrint.="<div class='listTitle'>".Utils::translate("info.noComments")."</div>";
	}
	echo $toPrint;
} else{
	echo "No data to query!";
}
?>