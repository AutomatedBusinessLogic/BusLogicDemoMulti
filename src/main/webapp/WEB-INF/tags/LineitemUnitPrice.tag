<%@ tag language="java" pageEncoding="ISO-8859-1"
	import="java.util.List"
	import="java.text.DecimalFormat"
	import="buslogicdemo.data.Lineitem"
	import="buslogicdemo.test.*"
	import="buslogicdemo.util.*"
%>
<%@ attribute name="lineitem" type="buslogicdemo.data.Lineitem" %>
<%
	DecimalFormat nf = new DecimalFormat();
	nf.setDecimalSeparatorAlwaysShown(true);
	nf.setMinimumFractionDigits(2);
%>
<input type="text" size="8" style="text-align: right; font-size:10pt;" id="unitPriceInput<%= lineitem.getLineitemId() %>"
			value="$<%= nf.format(lineitem.getProductPrice()) %>" 
			onchange="if ( ! isNumber(this.value)) {alert('Invalid number'); return false;} update(null, 'action=update&type=Lineitem&id=<%= lineitem.getLineitemId() %>&att=unitPrice&value=' + escape(this.value))"
			/>