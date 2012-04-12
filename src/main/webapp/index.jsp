<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="buslogicdemo.util.HibernateFactory" %>
<%@ page import="buslogicdemo.data.*" %>
<%@ page import="buslogicdemo.util.*" %>
<%@ taglib prefix="demo" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	// Note: the purpose of this code is to be easily understood. This is not an example of how to do things --
	// in a real project, you'd probably use some framework, such as JSF, Struts, etc...

	// We use this to format money
	DecimalFormat nf = new DecimalFormat();
	nf.setDecimalSeparatorAlwaysShown(true);
	nf.setMinimumFractionDigits(2);
	nf.setMaximumFractionDigits(2);
	
	HibernateFactory.setup(false);
	
	// Any updates required?
	RequestProcessor.processRequest(request);
	
	HibernateFactory.beginTransaction();

	String currentCustName = request.getParameter("custName");
	Customer currentCustomer = null;
	if (currentCustName == null) { // No customer specified -- grab the first one by alphabetic order
		@SuppressWarnings("unchecked")
		List<Customer> customers = HibernateFactory.session.createQuery("from Customer order by name").list();
		currentCustomer = customers.get(0);
		currentCustName = currentCustomer.getName();
	}
	else {
		currentCustomer = (Customer)HibernateFactory.session.load(Customer.class, currentCustName);
	}
	
	boolean showLinksToOtherVersions = true;
	if (request.getParameter("TutorialMode") != null) {
		session.setAttribute("TutorialMode", true);
	}
	
	// Get the customer's orders
	List<Purchaseorder> sortedOrders = currentCustomer.getPurchaseorders();
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<% if (session.getAttribute("TutorialMode") != null) { %>
	<link type="text/css" href="css/smoothness/jquery-ui-1.8.18.custom.css" rel="Stylesheet" />
	<script type="text/javascript" src="js/jquery-1.7.1.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.js"></script>
	<% } %>
	<script type="text/javascript" src="js/utils.js"></script>
	<title>Automated Business Logic demo</title>
</head>
<body style="font-family: arial; padding: 10px;" onload="showMessage()">
	<script type="text/javascript">
		function update(custName, arg) {
			if ( ! custName || custName == '')
				custName = "<%= currentCustName %>";
			window.location='index.jsp?custName=' + escape(custName) + '&' + arg;
		}
		
		function showHelp() {
			document.getElementById("HelpDiv").style.display = '';
		}
		
		var currentCustName = escape("<%= currentCustName %>");

		function showMessage() {
	<%
		if (request.getAttribute("message") != null) {
	%>
			alert('<%= request.getAttribute("message") %>');
	<%
		}
	%>
		}
	</script>
	
	<% if (session.getAttribute("TutorialMode") == null) { %>
	<demo:HelpDialog />
	<% } %>
	<div style="display:none; position:absolute; font-size: 12px; padding: 5px; opacity: 0.7;" 
		id="hiddenDiv"></div> <!-- Used for pointing things out -->
	
	<h3>Orders for customer :&nbsp;<demo:CustomerSelect currentCustomer="<%= currentCustName %>"/>
	<% if (session.getAttribute("TutorialMode") == null) { %>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<font style="font-size: 8pt;"><a href="#" onclick="showHelp(); return false;">Help</a></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<font style="font-size: 8pt;">ABL version - <a href="manual/index.jsp">go to manual version</a></font>
		&nbsp;&nbsp;<font style="font-size: 8pt;"><a href="indexJPA.jsp">go to JPA version</a></font>
	<% } %>
	</h3>
	
	<table border="0" cellspacing="10"><tr><td valign="top">

	<%
		if (request.getAttribute("errors") != null) {
	%>
		<div style="border: 2px solid #FF0000; background-color: #FFDDDD; padding: 4px;">
			<%= request.getAttribute("errors") %>
			<br/>
			All data has been reset to its latest value.
		</div>
	<%
		}
	%>

	<table border="0" cellspacing="5">
		<tr>
			<td>
				<table border="0">
					<tr>
						<td>Name:</td>
						<td><%= currentCustomer.getName() %></td>
					</tr>
					<tr>
						<td>Balance:</td>
						<td align="right" id="custBalanceTd">$<%= nf.format(currentCustomer.getBalance()) %></td>
					</tr>
					<tr>
						<td>Credit limit:</td>
						<td align="right"> <demo:CustomerCreditLimit customer="<%= currentCustomer %>" /></td>
					</tr>
				</table>
			</td>
			<td style="font-size: 10pt; color: #777777; width: 500px; padding-left: 40px;">
				Suggestions:
				<ul>
					<li>Change the quantity of an item and see how that affects the item's amount, the order's amount and, 
					if the order is not paid, the customer's balance 
					(<a href="http://www.automatedbusinesslogic.com/home/bus-logic-demo#TOC-Example:-Change-Lineitem-Quantity" target="Tutorial">what does this mean?</a>)
					<li>Check/uncheck Order paid and notice how the Customer's balance changes
					<li>Reassign an order to a different customer
					<li>Change an order's description and notice how 
						<a href="http://www.automatedbusinesslogic.com/overview#TOC-Execution-architected-for-high-perf">pruning</a>
						keeps the transaction to a bare minimum.
				</ul>
				You can also browse <a href="http://www.automatedbusinesslogic.com/home/bus-logic-demo/code-comparison" target="Tutorial">the source code for this demo.</a>
			</td>
	</table>
	
	<table cellpadding="3" cellspacing="0" id="ordersTable">
		<%
			for (Purchaseorder order : sortedOrders) {
				List<Lineitem> sortedItems = order.getLineitems();

				String checked = "";
				if (order.getPaid() != null && order.getPaid())
					checked = " checked ";
		%>
		<thead style="background-color: #555555; color: #DDDDFF;">
			<tr>
				<td>&nbsp;</td>
				<td nowrap style="border-right: 1px solid #AAAAAA;">Order #</td>
				<td nowrap style="border-right: 1px solid #AAAAAA;">Amount total</td>
				<td nowrap>Order paid</td>
				<td>&nbsp;</td>
			</tr>
		</thead>
			<tr valign="top" style="background-color: #E4E4E4;">
				<td style="font-size: 9pt;">
					<a href="#" onclick="if ( ! confirm('Delete this order?')) return false; update(null, 'action=delete&type=Order&id=<%= order.getOrderNumber() %>'); return false;">Delete</a>
				</td>
				<td align="center"><%= order.getOrderNumber() %></td>
				<td align="right" id="orderTotalTd<%= order.getOrderNumber() %>">$<%= nf.format(order.getAmountTotal()) %></td>
				<td align="center" id="orderPaidCheckbox<%= order.getOrderNumber() %>"><input type="checkbox" 
						onclick="update(null, 'action=update&type=Order&id=<%= order.getOrderNumber() %>&att=paid');" <%= checked %> /></td>
				<td rowspan="2">
					<table cellspacing="0" cellpadding="4" class="itemsTable">
						<thead>
							<tr style="background-color: #BBBBBB;"><td>&nbsp;</td><td nowrap>Item #</td><td>Product</td><td>Quantity</td><td nowrap>Unit price</td><td>Amount</td></tr>
						</thead>
						<%
							for (Lineitem item: sortedItems) {
						%>
							<tr>
								<td style="font-size: 9px; border: 1px solid #888888;">
									<a href="#" onclick="if ( ! confirm('Delete this line item?')) return false; update(null, 'action=delete&type=Lineitem&id=<%= item.getLineitemId() %>'); return false;">Delete</a>
								</td>
								<td style="border: 1px solid #888888;"><%= item.getLineitemId() %></td>
								<td style="border: 1px solid #888888;"><demo:ProductSelect lineitem="<%= item %>" /></td>
								<td style="border: 1px solid #888888;"><demo:LineitemQuantity lineitem="<%= item %>"/></td>
								<td style="border: 1px solid #888888;"><demo:LineitemUnitPrice lineitem="<%= item %>"/></td>
								<td align="right" style="border: 1px solid #888888;" id="lineItemAmountTd<%= item.getLineitemId() %>">$<%= nf.format(item.getAmount()) %></td>
							</tr>
						<%
							}
							if (sortedItems.size() == 0) {
						%>
							<tr><td colspan="6"><center><i>No line items</i></center></td></tr>
						<%
							}
						%>
					</table>
				</td>
			</tr>
			<tr><td colspan="4" valign="top">
				<input type="text" size="30" style="font-size:10pt;" value="<%= order.getNotes() %>" 
					onchange="update(null, 'action=update&type=Order&id=<%= order.getOrderNumber() %>&att=notes&value=' + escape(this.value))"
			/>
			</td></tr>
			<tr style="background-color: #CCCCCC;"><td colspan="6"><center>
				Reassign this order to customer: <demo:ReassignCustomerSelect order="<%= order %>" />
				&nbsp;&nbsp;&nbsp;
				<a href="index.jsp?custName=<%= FormatUtil.escapeIdent(currentCustName) %>&action=insert&type=Lineitem&id=<%= order.getOrderNumber() %>">Create line item</a>
			</center></td></tr>
			<tr><td colspan="5">&nbsp;</td></tr>
		<%
			}
			if (sortedOrders.size() == 0) {
		%>
			<tr><td colspan="6"><center><i>No orders</i></center></td></tr>
		<%
			}
		%>
		<tr>
			<td colspan="3"><a id="newOrderButton" href="index.jsp?custName=<%= FormatUtil.escapeIdent(currentCustName) %>&action=insert&type=Order">Create new order</a></td>
			<td nowrap>
		<%
		
		if (request.getParameter("showTxSummary") != null) {
			session.setAttribute("showTxSummary", request.getParameter("showTxSummary"));
			if (DemoEventListener.getInstance() != null)
				DemoEventListener.getInstance().resetEvents();
		}

		String showTxSummaryValue = "true";
		String showTxSummary = "";
		if ("true".equals(session.getAttribute("showTxSummary"))) {
			showTxSummaryValue = "false";
			showTxSummary = " checked ";
		}
		%>
			<input type="checkbox" id="showTxSummary" <%= showTxSummary %> onchange="update(null, 'showTxSummary=<%= showTxSummaryValue %>'); return false;"/>
			<label for="showTxSummary">Show transaction summary</label>
		</td>
		<td style="width: 60px; text-align: right;">
			<a href="index.jsp?action=reloadData" onclick="return confirm('This will delete all data and reload the sample data set. Do you want to do that?')">Reload data</a>
		</td>
		</tr>
	</table>
	</td><td valign="top" style="padding: 15px;">
	<%
		if ("true".equals(session.getAttribute("showTxSummary"))) {
	%>
		<demo:ChangeSummary></demo:ChangeSummary>
	<%
		}
	%>
	</td></tr></table>
</body>
</html>
<%
	HibernateFactory.commitTransaction();
%>
