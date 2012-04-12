<%@ tag language="java" pageEncoding="ISO-8859-1"
	import="java.util.*"
	import="buslogicdemo.data.Customer"
	import="buslogicdemo.test.*"
	import="buslogicdemo.util.*"
	import="com.autobizlogic.abl.event.LogicEvent" 
%>
<%@ attribute name="currentCustomer" %>
<span id="custNameSelect"><select name="custName" id="custNameControl" onchange="update(this.options[this.selectedIndex].value, null)"
	style="font-size: 13pt;">
<%
	// Cache the list of customers so as not to reselect them every time a page is brought up
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
		String selected = "";
		if (custName.equals(currentCustomer))
			selected = " selected";
%>
	<option <%= selected %>><%= custName %>
<%
	}
%>
</select></span>