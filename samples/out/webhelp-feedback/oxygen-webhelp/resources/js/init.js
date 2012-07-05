var dif = 0;
var last = 0;
var start = 0;
function debug(msg) {
	var date = new Date();
	if (start == 0) {
		start = date.getTime();
	}
	dif = date.getTime() - last;
	last = date.getTime();
	var total = last - start;
	console.log(total + ":" + dif + " " + msg);
}
function init(depth) {
	highlightSearchTerm();
	realInclude = depth + 'oxygen-webhelp/resources/comments.html';

	$.get(realInclude, function(data) {

		var text = data.replace(/@relPath@/g, depth);

		/*
		 * var div = document.getElementById("commentsContainer"); div.innerHTML =
		 * text; runScripts(div);
		 */
		$('#commentsContainer').html(text);
	});

}
