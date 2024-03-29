<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%
	String helpShown = (String)session.getAttribute("HelpShown");
	String display = "block";
	if (helpShown != null)
		display = "none";
	session.setAttribute("HelpShown", "true");
%>
<div style="border: 1px solid #666666; background-color: #DDFFFF; padding: 5px; font-size: 11pt; position: absolute; top: 10%; left: 10%; box-shadow: 10px 5px 5px #777777; display: <%= display %>;" id="HelpDiv">
	<h3 align="center">What is this?</h3>
	This is a very simplistic application intended to demonstrate the use of ABL's declarative business logic.
	<p/>
	You can change all editable values (just hit return or tab out to save) and observe the changes in the data.
	<p/>
	Any change will bring up a <i><b>What happened</b></i> dialog showing which business rules have just executed.
	<p/>
	<h3 align="center">What should you do?</h3>
	If this is your first time using this demo, we suggest you try the following:
	<ul>
		<li>mark an order as paid (using the checkbox) and see what results from this simple action
		<li>change the Quantity in a line item
		<li>reassign an order to a different customer
	</ul>
	<p/>
	Further help is available on <a href="http://www.automatedbusinesslogic.com/">ABL's web site</a>.
	<p/>
	This dialog can be re-opened any time by clicking the <i>Help</i> link at the top of this page.
	<p/>
	<div style="width: 100%; text-align: center;"><button type="button" onclick="document.getElementById('HelpDiv').style.display = 'none'">Close</button></div>
</div>
