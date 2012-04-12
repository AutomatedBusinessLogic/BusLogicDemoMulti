<%@ tag language="java" pageEncoding="ISO-8859-1"
	import="java.util.*"
	import="buslogicdemo.data.Customer"
	import="buslogicdemo.test.*"
	import="buslogicdemo.util.*"
%>
<%@ attribute name="order" type="buslogicdemo.data.Purchaseorder" %>
<select name="custName" onchange="update(null, 'action=update&type=Order&id=<%= order.getOrderNumber() %>&att=customer&value=' + this.options[this.selectedIndex].value)"
	style="font-size: 10pt;">
	<option selected>- select a customer -
<%
	@SuppressWarnings("unchecked")
	List<String> cachedNames = (List<String>)session.getAttribute("CustomerSelectNames");
	if (cachedNames == null) { // Cached to avoid hitting the database every time
		cachedNames = new Vector<String>();
		StringBuffer selTxt = new StringBuffer();
		@SuppressWarnings("unchecked")
		List<Customer> customers = HibernateFactory.session.createQuery("from Customer order by name").list();
		for (Customer customer : customers) {
			cachedNames.add(customer.getName());
		}
		session.setAttribute("CustomerSelectNames", cachedNames);
	}
	for (String custName : cachedNames) {
		if (custName.equals(order.getCustomer().getName()))
			continue;
%>
	<option><%= custName %>
<%
	}
%>
</select>
