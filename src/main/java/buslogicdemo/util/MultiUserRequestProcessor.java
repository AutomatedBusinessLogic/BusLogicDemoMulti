package buslogicdemo.util;

import java.math.BigDecimal;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.Session;

import buslogicdemo.data.Customer;
import buslogicdemo.data.Lineitem;
import buslogicdemo.data.Product;
import buslogicdemo.data.Purchaseorder;

import com.autobizlogic.abl.engine.ConstraintException;

public class MultiUserRequestProcessor {

	public static void processRequest(HttpServletRequest request) {
		
		String action = request.getParameter("action");
		if (action == null || action.trim().length() == 0)
			return;
		
		String sessionId = request.getSession().getId();
		
		MultiSessionFactory.beginTransaction(sessionId);

		if ("update".equals(action))
			processUpdate(request);
		else if ("insert".equals(action))
			processInsert(request);
		else if ("delete".equals(action))
			processDelete(request);
		else if ("reloadData".equals(action)) {
			DataLoader.reloadData(MultiSessionFactory.getSession(sessionId));
		}
		
		try {
			MultiSessionFactory.commitTransaction(sessionId);
		}
		catch(ConstraintException cex) {
			request.setAttribute("errors", cex.getMessage());
			MultiSessionFactory.rollbackTransaction(sessionId);
		}
		catch(Exception ex) {
			ex.printStackTrace();
			request.setAttribute("errors", ex.toString());
			MultiSessionFactory.rollbackTransaction(sessionId);
		}
	}
	
	private static void processUpdate(HttpServletRequest request) {
		String sessionId = request.getSession().getId();
		Session session = MultiSessionFactory.getSession(sessionId);
		String type = request.getParameter("type");
		if (type == null || type.trim().length() == 0)
			return;
		String id = request.getParameter("id");
		String att = request.getParameter("att");
		String value = request.getParameter("value");
		if ("Order".equals(type)) {
			Purchaseorder order = (Purchaseorder)session.load(Purchaseorder.class, new Long(id));
			if ("paid".equals(att)) {
				Boolean oldValue = order.getPaid();
				if (oldValue == null)
					oldValue = Boolean.FALSE;
				order.setPaid( ! oldValue);
			}
			else if ("customer".equals(att)) {
				if (value == null || value.startsWith("- ")) // Do nothing if somehow the "- select a customer -" item was selected
					return;
				Customer customer = (Customer)session.load(Customer.class, value);
				order.setCustomer(customer);
				request.setAttribute("message", "The order has been reassigned to customer " + customer.getName());
			}
			else if ("notes".equals(att)) {
				order.setNotes(value);
			}
			session.saveOrUpdate(order);
		}
		else if ("Customer".equals(type)) {
			Customer customer = (Customer)session.load(Customer.class, id);
			if ("creditLimit".equals(att)) {
				BigDecimal val = FormatUtil.parseMoney(value);
				customer.setCreditLimit(val);
			}
			session.saveOrUpdate(customer);
		}
		else if ("Lineitem".equals(type)) {
			Lineitem lineitem = (Lineitem)session.load(Lineitem.class, new Long(id));
			if ("quantity".equals(att)) {
				Integer val = FormatUtil.parseNumber(value);
				lineitem.setQtyOrdered(val);
			}
			else if ("unitPrice".equals(att)) {
				BigDecimal val = FormatUtil.parseMoney(value);
				lineitem.setProductPrice(val);
			}
			else if ("product".equals(att)) {
				Product product = (Product)session.load(Product.class, new Long(value));
				lineitem.setProduct(product);
			}
			session.saveOrUpdate(lineitem);
		}
	}
	
	private static void processInsert(HttpServletRequest request) {
		Session session = MultiSessionFactory.getSession(request.getSession().getId());
		String type = request.getParameter("type");
		if (type == null || type.trim().length() == 0)
			return;
		String id = request.getParameter("id");
		if ("Lineitem".equals(type)) {
			Purchaseorder order = (Purchaseorder)session.load(Purchaseorder.class, new Long(id));
			Product product = (Product)session.load(Product.class, new Long(2));
			Lineitem newItem = new Lineitem();
			newItem.setPurchaseorder(order);
			newItem.setProduct(product);
			newItem.setQtyOrdered(1);
			session.saveOrUpdate(newItem);
		}
		else if ("Order".equals(type)) {
			String custName = request.getParameter("custName");
			Customer customer = (Customer)session.load(Customer.class, custName);
			Purchaseorder newOrder = new Purchaseorder();
			newOrder.setCustomer(customer);
			newOrder.setPaid(Boolean.FALSE);
			newOrder.setNotes("");
			session.saveOrUpdate(newOrder);
		}
	}

	private static void processDelete(HttpServletRequest request) {
		Session session = MultiSessionFactory.getSession(request.getSession().getId());
		String type = request.getParameter("type");
		if (type == null || type.trim().length() == 0)
			return;
		String id = request.getParameter("id");
		if ("Lineitem".equals(type)) {
			Lineitem lineitem = (Lineitem)session.load(Lineitem.class, new Long(id));
			session.delete(lineitem);
		}
		else if ("Order".equals(type)) {
			Purchaseorder order = (Purchaseorder)session.get(Purchaseorder.class, new Long(id));
			session.delete(order);
		}
	}
}
