<%@ tag language="java" pageEncoding="ISO-8859-1"
	import="java.util.*"
	import="java.text.*"
	import="buslogicdemo.data.Product"
	import="buslogicdemo.test.*"
	import="buslogicdemo.util.*"
%>
<%@ attribute name="lineitem" type="buslogicdemo.data.Lineitem" %>
<select name="custName" id="productSelect<%= lineitem.getLineitemId() %>" autocomplete="off"
	onchange="update(null, 'action=update&type=Lineitem&id=<%= lineitem.getLineitemId() %>&att=product&value=' + this.options[this.selectedIndex].value)"
	style="font-size: 10pt;">
<%
	@SuppressWarnings("unchecked")
	List<String> cachedNames = (List<String>)session.getAttribute("ProductSelectNames");
	@SuppressWarnings("unchecked")
	List<Long> cachedIds = (List<Long>)session.getAttribute("ProductSelectIds");
	
	// Not cached yet? Fetch from database and store in session
	if (cachedNames == null) { // Cached to avoid hitting the database every time

		DecimalFormat nf = new DecimalFormat();
		nf.setDecimalSeparatorAlwaysShown(true);
		nf.setMinimumFractionDigits(2);

		cachedNames = new Vector<String>();
		cachedIds = new Vector<Long>();
		@SuppressWarnings("unchecked")
		List<Product> products = HibernateFactory.session.createQuery("from Product order by name").list();
		for (Product product : products) {
			cachedNames.add(product.getName() + " - $" + nf.format(product.getPrice()));
			cachedIds.add(product.getProductNumber());
		}
		session.setAttribute("ProductSelectNames", cachedNames);
		session.setAttribute("ProductSelectIds", cachedIds);
	}
	
	// Now create the select control
	for (int i = 0; i < cachedNames.size(); i++) {
		String name = cachedNames.get(i);
		Long id = cachedIds.get(i);
		String selected = "";
		if (lineitem.getProduct().getProductNumber() == id)
			selected = " selected='selected'";
%>
	<option value="<%= id %>" <%= selected %>><%= name %>
<%
	}
%>
</select>
