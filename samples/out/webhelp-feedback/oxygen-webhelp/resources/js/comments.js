var productName = $("#oxy_productID").text();
var productVersion = $("#oxy_productVersion").text();
var pageSearch = window.location.href;
var pageHash= window.location.hash;
var isModerator=false;
var isAnonymous=false;
var pathName = window.location.pathname;

var pageWSearch = pageSearch.replace(window.location.search,"");
pageWSearch = pageWSearch.replace(window.location.hash,"");

$(".bt_close").click(closeDialog);
$(".bt_cancel").click(function(){
	$(".bt_close").click();
});


$("#bt_new div").click(showNewCommentDialog);

// post or edit comment
//$("#l_bt_submit_nc").click(submitComment);

$("#bt_recover").click(recover);
 
//$("#bt_signUp").click(signUp);

//debug("js 4");
$("#bt_yesDelete").click(deleteComment);
//debug("js 5");
$("#bt_noDelete").click(hideDeleteDialog);
//debug("js 5");

$("#bt_approveAll").click(showApproveAllDialog);
//debug("js 6");
$("#bt_yesApprove").click(approveAllComments);

$("#bt_noApprove").click(hideAproveDialog);


$("#bt_logIn").click(showLoggInDialog);

$("#bt_profile").click(updateUserProfile);

$("#bt_logOff").click(loggOffUser);

showComments();