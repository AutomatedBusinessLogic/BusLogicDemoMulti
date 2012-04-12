<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ABL Click-Along Tutorial</title>
</head>
<frameset cols="370px,*">
	<frame src="videos.jsp" name="videoFrame">
	<frameset rows="0px,*" id="rightFrameset">
		<frame src="tabs.jsp" name="tabsFrame">
 		<frame src="index.jsp?TutorialMode=true" name="demoFrame">
	</frameset>
</frameset>
</html>
