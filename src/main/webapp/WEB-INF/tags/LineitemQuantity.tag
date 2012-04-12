<%@ tag language="java" pageEncoding="ISO-8859-1"
	import="java.util.List"
	import="java.text.DecimalFormat"
	import="buslogicdemo.data.Lineitem"
	import="buslogicdemo.test.*"
	import="buslogicdemo.util.*"
%>
<%@ attribute name="lineitem" type="buslogicdemo.data.Lineitem" %>
<input type="text" size="5" style="text-align: right; font-size:10pt;"
			value="<%= lineitem.getQtyOrdered() %>" 
			onchange="if ( ! isNumber(this.value)) {alert('Invalid number:' + this.value); this.focus(); return false;} update(null, 'action=update&type=Lineitem&id=<%= lineitem.getLineitemId() %>&att=quantity&value=' + escape(this.value))"
			id="lineItemQuantity<%= lineitem.getLineitemId() %>" />