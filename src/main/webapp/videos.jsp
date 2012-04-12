<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Click-along videos</title>
	<script src="js/froogaloop.js"></script>

	<link type="text/css" href="css/smoothness/jquery-ui-1.8.18.custom.css" rel="Stylesheet" />	
	<script type="text/javascript" src="js/jquery-1.7.1.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.js"></script>

	<script src="js/demo.js"></script>
	<script>
		var codeShown = false;
		function toggleCode() {
			if (codeShown) {
				parent.document.getElementById('rightFrameset').setAttribute('rows', '0px,*', 0);
				$("#showCodeButton").html("Show code");
				codeShown = false;
			}
			else {
				parent.document.getElementById('rightFrameset').setAttribute('rows', '*,0px', 0);
				$("#showCodeButton").html("Show demo");
				codeShown = true;
			}
		}
	</script>
	<style>
		.ChapterRow {
			border-bottom: 1px solid #444444;
			cursor: pointer;
		}
		.ChapterRowSelected {
			background-color: #FFDDDD;
			border: 3px outset #888888;
		}
	</style>
</head>
<body>
	<h2 style="font-family: sans-serif;"><a href="http://www.automatedbusinesslogic.com" 
			target="HomeSite">Automated Business Logic</a></h2>
	<table style="padding: 3px;">
		<tr>
			<td style="height: 230px;">
				<div class="container" id="videoDiv0">
                	<div>
						<iframe id="player_0" src="http://player.vimeo.com/video/39627036?api=1&amp;player_id=player_0" width="350" height="225" frameborder="0" webkitallowfullscreen></iframe>
					</div>
				</div>
				<div class="container" style="display: none;" id="videoDiv1"><div>
						<iframe id="player_1" src="http://player.vimeo.com/video/39629629?api=1&amp;player_id=player_1" width="350" height="225" frameborder="0" webkitallowfullscreen></iframe>
				</div></div>
				<div class="container" style="display: none;" id="videoDiv2"><div>
						<iframe id="player_2" src="http://player.vimeo.com/video/39627260?api=1&amp;player_id=player_2" width="350" height="225" frameborder="0" webkitallowfullscreen></iframe>
				</div></div>
				<div class="container" style="display: none;" id="videoDiv3"><div>
						<iframe id="player_3" src="http://player.vimeo.com/video/39629773?api=1&amp;player_id=player_3" width="350" height="225" frameborder="0" webkitallowfullscreen></iframe>
				</div></div>
				<div class="container" style="display: none;" id="videoDiv4"><div>
						<iframe id="player_4" src="http://player.vimeo.com/video/39627406?api=1&amp;player_id=player_4" width="350" height="225" frameborder="0" webkitallowfullscreen></iframe>
				</div></div>
				<div class="container" style="display: none;" id="videoDiv5"><div>
						<iframe id="player_5" src="http://player.vimeo.com/video/39627518?api=1&amp;player_id=player_5" width="350" height="225" frameborder="0" webkitallowfullscreen></iframe>
				</div></div>
				<div class="container" style="display: none;" id="videoDiv6"><div>
						<iframe id="player_6" src="http://player.vimeo.com/video/39627617?api=1&amp;player_id=player_6" width="350" height="225" frameborder="0" webkitallowfullscreen></iframe>
				</div></div>
				<div class="container" style="display: none;" id="videoDiv7"><div>
						<iframe id="player_7" src="http://player.vimeo.com/video/39627678?api=1&amp;player_id=player_7" width="350" height="225" frameborder="0" webkitallowfullscreen></iframe>
				</div></div>
<!-- 				<div id="myContent0">
					<h4>Adobe Flash does not seem to be installed</h4>
					<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a></p>
				</div>
				<div id="myContent1" style="display: none;"></div>
				<div id="myContent2" style="display: none;"></div>
 -->			</td>
		</tr>
<!-- 		<tr style="background-color: #DDDDDD; fo">
			<td>
				<div id="VideoComment">Introduction</div>
			</td>
		</tr>
 -->		<tr>
			<td id="Chapters" style="background-color: #CCCCCC; font-family: sans-serif; font-size: 15px;">
				<table border="0" style="padding: 5px;">
					<tr><td class="ChapterRow ChapterRowSelected" id="Chapter0Row" onclick="switchToVideo(0)">Introduction</td></tr>
					<tr><td class="ChapterRow" id="Chapter1Row" onclick="switchToVideo(1)">What the demo does</td></tr>
					<tr><td class="ChapterRow" id="Chapter2Row" onclick="switchToVideo(2)">The data model</td></tr>
					<tr><td class="ChapterRow" id="Chapter3Row" onclick="switchToVideo(3)">@Logic : annotations</td></tr>
					<tr><td class="ChapterRow" id="Chapter4Row" onclick="switchToVideo(4)">Complex multi-table logic</td></tr>
					<tr><td class="ChapterRow" id="Chapter5Row" onclick="switchToVideo(5)">Automated dependency management</td></tr>
					<tr><td class="ChapterRow" id="Chapter6Row" onclick="switchToVideo(6)">Automatic reuse and integrity</td></tr>
					<tr><td class="ChapterRow" id="Chapter7Row" onclick="switchToVideo(7)">Conclusion</td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table border="0">
					<tr>
						<td align="right"><button id="showCodeButton" onclick="toggleCode();">Show code</button></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>