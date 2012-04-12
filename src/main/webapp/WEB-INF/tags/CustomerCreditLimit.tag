<%@ tag language="java" pageEncoding="ISO-8859-1"
	import="java.util.List"
	import="java.text.DecimalFormat"
	import="buslogicdemo.data.Customer"
	import="buslogicdemo.test.*"
	import="buslogicdemo.util.*"
%>
<%@ attribute name="customer" type="buslogicdemo.data.Customer" %>
<%
	DecimalFormat nf = new DecimalFormat();
	nf.setDecimalSeparatorAlwaysShown(true);
	nf.setMinimumFractionDigits(2);
	nf.setMaximumFractionDigits(2);
%>
<input type="text" size="8" style="text-align: right; font-size:10pt;"
			value="$<%= nf.format(customer.getCreditLimit()) %>" 
			onchange="if ( ! isNumber(this.value)) {alert('Invalid number'); return false;} update(null, 'action=update&type=Customer&id=' + currentCustName + '&att=creditLimit&value=' + escape(this.value))"
			/>