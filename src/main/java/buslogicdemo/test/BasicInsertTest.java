package buslogicdemo.test;

import static org.junit.Assert.*;

import java.math.BigDecimal;
import java.util.Date;

import org.junit.Test;

import buslogicdemo.data.*;

/**
 * Sample test cases for business logic.
 */
public class BasicInsertTest extends LogicTest {
	public static void main(String[] args) {
		
		BasicInsertTest instance = new BasicInsertTest();
		instance.runTest2();
	}
	
	@Test
	public void runTest() {
		setup();
		
		beginTransaction();
		Customer cust = new Customer();
		String key = "Test " + (new Date()).toString().substring(10, 20);
		cust.setName(key);
		cust.setBalance(BigDecimal.ZERO);
		cust.setCreditLimit(new BigDecimal("100"));
		saveObject(cust);
		commitTransaction();

		beginTransaction();
		cust = getObjectById(Customer.class, key);
		assertNotNull("Customer does not seem to have been persisted", cust);
		deleteObject(cust);
		commitTransaction();
		
		cleanup();
	}
	
	@Test
	public void runTest2() {
		setup();
		
		beginTransaction();
		Customer cust = new Customer();
		String key = "Test2 " + (new Date()).toString().substring(10, 20);
		cust.setName(key);
		cust.setBalance(BigDecimal.ZERO);
		cust.setCreditLimit(new BigDecimal("100"));
		saveObject(cust);
		
		long ts = System.currentTimeMillis();
		Purchaseorder order = new Purchaseorder();
		order.setCustomer(cust);
		order.setOrderNumber(ts);
		saveObject(order);
		
		Product product = new Product();
		product.setProductNumber(ts);
		product.setName("Test product");
		product.setPrice(new BigDecimal(123.45));
		saveObject(product);
		
		Lineitem lineitem = new Lineitem();
		lineitem.setLineitemId(ts);
		lineitem.setProduct(product);
		lineitem.setPurchaseorder(order);
		lineitem.setQtyOrdered(2);
		saveObject(lineitem);
		long lineitemNum = lineitem.getLineitemId();
		commitTransaction();
		
		cleanup();
		
		beginTransaction();
		lineitem = getObjectById(Lineitem.class, lineitemNum);
		float lineAmt = lineitem.getAmount().floatValue();
		float price = lineitem.getProductPrice().floatValue();
		int qty = lineitem.getQtyOrdered();
		assertEquals("Line item amount is not equal to price times quantity", lineAmt, price * qty, 0.000001);
		commitTransaction();
	}
}
