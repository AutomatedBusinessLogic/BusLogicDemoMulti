// Utility function for adding an event. Handles the inconsistencies between the W3C method 
// for adding events (addEventListener) and IE's (attachEvent).
function addEvent(element, eventName, callback) {
    if (element.addEventListener) {
        element.addEventListener(eventName, callback, false);
    }
    else {
        element.attachEvent('on' + eventName, callback);
    }
}

// Show the app frame
function showApp() {
	parent.document.getElementById('rightFrameset').setAttribute('rows', '0px,*', 0);
	currentFrameName = 'demoFrame';
	$("#showCodeButton").html("Show code");
	codeShown = false;
}

// Show the code/diagrams frame
function showTabs() {
	parent.document.getElementById('rightFrameset').setAttribute('rows', '*,0px', 0);
	currentFrameName = 'tabsFrame';
	$("#showCodeButton").html("Show demo");
	codeShown = true;
}

// The specification for what should be highlighted how and when
var timings = [
        {
 		 	// Introduction
        	triggers : 
    		 	[
	 		 	 	[1, 'action', showApp],
	 		 	 	[8, 'frame', 'body'],
	 		 	 	[20, 'frame', '#custNameSelect'],
	 		 	 	[25, 'frame', '#ordersTable'],
	 		 	 	[29, 'frame', '.itemsTable'],
 		 	 	],
        },
        {
	 		// Running the app
        	triggers :
    		 	[
	 		 	 	[2, 'action', function(){
	 		 	 		showApp();
	 					parent.demoFrame.location = "index.jsp?action=reloadData";
	 		 	 	}],
	 		 	 	[6, 'frame', '#productSelect13'],
	 		 	 	[10, 'frame', '#productSelect13'],
	 		 	 	[18, 'frame', '#unitPriceInput13'],
	 		 	 	[25, 'frame', '#lineItemAmountTd13'],
	 		 	 	[33, 'frame', '#orderTotalTd6'],
	 		 	 	[41, 'frame', '#orderPaidCheckbox6'],
	 		 	 	[44, 'frame', '#custBalanceTd'],
	 		 	 ],
        },
        {
 			// The data model
        	triggers:
    		 	[
	 				[1, 'action', function(){
	 					showTabs();
	 					tabsDoc = parent.tabsFrame.document;
	 					$('#tabs', tabsDoc).tabs().tabs('select', 0);
	 				}],
	 				[17, 'action', function(){
	 					tabsDoc = parent.tabsFrame.document;
	 					$('#tabs', tabsDoc).tabs().tabs('select', 1);
	 				}],
 				],
        },
        {
		 	// The transactional logic
        	triggers:
    		 	[
	 				[1, 'action', showTabs],
	 				[9, 'action', function(){
	 					tabsDoc = parent.tabsFrame.document;
	 					var tbs = $('#tabs', tabsDoc).tabs();
	 					tbs.tabs('select', 2);
	 				}],
	 		 	 	[18, 'frame', '#LogicCode1'],
	 		 	 	[23, 'frame', '#LogicCode2'],
	 		 	 	[29, 'frame', '#LogicCode3'],
 		 	 	],
        },
        {
		 	// Complex multi-table logic
        	triggers:
    		 	[
	 				[1, 'action', function(){
	 					showTabs();
	 					tabsDoc = parent.tabsFrame.document;
	 					var tbs = $('#tabs', tabsDoc).tabs();
	 					tbs.tabs('select', 2);
	 				}],
	 		 	 	[11, 'frame', '#LogicCode1'],
	 		 	 	[24, 'frame', '#LogicCode1'],
	 		 	 	[42, 'frame', '#LogicCode3'],
 		 	 	],
        },
        {
		 	// Automated dependency management
        	triggers:
    		 	[
	 				[40, 'action', function(){
	 					showApp();
	 					parent.demoFrame.location = "index.jsp?action=reloadData";
	 				}],
	 		 	 	[49, 'frame', '#productSelect13'],
	 		 	 	[51, 'frame', '#unitPriceInput13'],
	 		 	 	[53, 'frame', '#lineItemAmountTd13'],
	 		 	 	[55, 'frame', '#orderTotalTd6'],
	 		 	 	[57, 'frame', '#custBalanceTd'],
 		 	 	],
        },
        {
		 	// Automatic reuse
        	triggers:
    		 	[
	 				[1, 'action', function(){
	 					showTabs();
	 					tabsDoc = parent.tabsFrame.document;
	 					var tbs = $('#tabs', tabsDoc).tabs();
	 					tbs.tabs('select', 3);
	 				}],
        		],
        },
        {
		 	// Conclusion
        	triggers:
    		 	[
	 				[1, 'action', function(){
	 					showTabs();
	 					tabsDoc = parent.tabsFrame.document;
	 					var tbs = $('#tabs', tabsDoc).tabs();
	 					tbs.tabs('select', 4);
	 				}],
	 		 	 	[7, 'background', '#Point1', '#DDDDFF'],
	 		 	 	[12, 'background', '#Point2', '#CCFFCC'],
	 		 	 	[15, 'background', '#Point3', '#DDDDFF'],
	 		 	 	[18, 'background', '#Point4', '#CCFFCC'],
	 		 	 	[30, 'background', '#WebSiteLink', '#DDDDFF'],
 		 	 	],
        }
];

var lastTime = 0;

// This gets called by the Vimeo player every half second or so
function eventReceived(data) {
	
	var demoDoc = parent[currentFrameName].document;
	for (timing in timings[videoIndex].triggers) {
		var t = timings[videoIndex].triggers[timing];
		if (lastTime <= t[0] && data.seconds >= t[0]) {
			if (t[1] == 'frame') {
				h = $(t[2], demoDoc);
				h.css("border-color", "#FF0000");
				h.css("border-style", "solid");
				h.css("border-width", "4px");
				setTimeout(function() { h.css("border-color", "#000000"); }, 400);
				setTimeout(function() { h.css("border-color", "#FF0000"); }, 800);
				setTimeout(function() { h.css("border-color", "#000000"); }, 1200);
				setTimeout(function() { h.css("border-color", "#FF0000"); }, 1600);
				setTimeout(function() { h.css("border", "0px"); }, 2000);
			}
			else if (t[1] == 'action') {
				t[2]();
			}
			else if (t[1] == 'background') {
				h = $(t[2], demoDoc);
				h.css('background-color', t[3]);
			}
		}
	}
	lastTime = data.seconds;
}

// Called by Vimeo when a video ends. Registered in playerReady()
function videoFinished(data) {
	if (videoIndex == timings.length - 1)
		return;
	document.getElementById('videoDiv' + videoIndex).style.display = 'none';
	videoIndex++;
	selectVideo();
}

// Hide the current video and show the next one
function selectVideo() {
	playerIframe = document.getElementById('player_' + videoIndex);
	videoDiv = document.getElementById('videoDiv' + videoIndex);
	videoDiv.style.display = '';
	froogaloop = $f(playerIframe);
	froogaloop.addEvent('play', playerReady);

	$(".ChapterRow").removeClass('ChapterRowSelected');
	$('#Chapter' + videoIndex + 'Row').addClass('ChapterRowSelected');
}

// Called when the user selects a different video to play
function switchToVideo(videoNum) {
	// Stop and hide current video
	playerIframe = document.getElementById('player_' + videoIndex);
	froogaloop = $f(playerIframe);
	froogaloop.api('unload');
	document.getElementById('videoDiv' + videoIndex).style.display = 'none';

	videoIndex = videoNum;
	selectVideo();
	froogaloop = $f(playerIframe);
	setTimeout(function() { froogaloop.api('play'); }, 2000);
}

// This gets called when the player is ready. We register our listeners,
// and start the video if it's the first one.
function playerReady(player_id) {
	playerIframe = document.getElementById('player_' + videoIndex);
	froogaloop = $f(playerIframe);
	froogaloop.addEvent('playProgress', eventReceived);
	froogaloop.addEvent('finish', videoFinished);
	if (videoIndex == 0)
		froogaloop.api('play');	
}

var videoIndex = 0; // Keep track of which video player is currently showing
var demoDoc = null;
var playerIframe = null;
var froogaloop = null;
var currentFrameName = 'demoFrame';

// And finally, get everything going once the page is loaded
$(document).ready(function(){
	demoDoc = parent.demoFrame.document;
	
	playerIframe = document.getElementById('player_0');
	froogaloop = $f(playerIframe);
	froogaloop.addEvent('ready', playerReady);
});
