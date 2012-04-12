<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Tabs</title>
	<link type="text/css" href="css/smoothness/jquery-ui-1.8.18.custom.css" rel="Stylesheet" />	
	<script type="text/javascript" src="js/jquery-1.7.1.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.js"></script>

	<script type="text/javascript" src="js/shCore.js"></script>
	<script type="text/javascript" src="js/shBrushJava.js"></script>
	<link href="css/shCore.css" rel="stylesheet" type="text/css" />
	<link href="css/shThemeDefault.css" rel="stylesheet" type="text/css" />
	<style>
		.syntaxhighlighter {
			font-size: 14px !important;
		}
		.requirement {
			background-color: #CCCCCC;
			font-family: sans-serif arial;
			font-size: 14pt;
		}
	</style>
</head>
<body>
<div id="tabs">
	<ul>
		<li><a href="#tabs-1">Data model</a></li>
		<li><a href="#tabs-2">Domain objects code</a></li>
		<li><a href="#tabs-3">Logic code</a></li>
		<li><a href="#tabs-4">Architecture</a></li>
		<li><a href="#tabs-5">Links</a></li>
	</ul>
	
	<div id="tabs-1">
		<img src="images/DataModel.png" width="750" height="307"/>
	</div>
	<!-- //////////////////////////////////////////////////////// -->
	<div id="tabs-2">
	<table border="0">
		<tr>
			<td>
				<div id="domainTabs">
					<ul>
						<li><a href="#domainTabs-1">Customer</a></li>
						<li><a href="#domainTabs-2">PurchaseOrder</a></li>
						<li><a href="#domainTabs-3">LineItem</a></li>
						<li><a href="#domainTabs-4">Product</a></li>
					</ul>
					<div id="domainTabs-1">
						<pre class="brush: java">
@Entity
@Table(name="customer")
public class Customer implements java.io.Serializable {

	@Id
	@Column
	public String getName() { return name; }
	public void setName(String name) { this.name = name; }
	private String name;

	@Column
	public BigDecimal getBalance() { return balance; }
	public void setBalance(BigDecimal balance) { this.balance = balance; }
	private BigDecimal balance;

	@Column(name="credit_limit")
	public BigDecimal getCreditLimit() { return this.creditLimit; }
	public void setCreditLimit(BigDecimal creditLimit) { this.creditLimit = creditLimit; }
	private BigDecimal creditLimit;

	/* Relationships */
	@OneToMany(cascade={CascadeType.ALL}, fetch=FetchType.LAZY, mappedBy="customer")
	@OrderBy("orderNumber desc")
	public List&lt;Purchaseorder> getPurchaseorders() { return this.purchaseorders; }
	public void setPurchaseorders(List&lt;Purchaseorder> purchaseorders) { this.purchaseorders = purchaseorders; }
	private List&lt;Purchaseorder> purchaseorders = new Vector&lt;Purchaseorder>();
}</pre>
					</div>
					<div id="domainTabs-2">
						<pre class="brush: java">
@Entity
@Table(name="purchaseorder")
public class Purchaseorder implements java.io.Serializable {

	@Id 
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name="order_number")
	public Long getOrderNumber() { return orderNumber; }
	public void setOrderNumber(Long orderNumber) { this.orderNumber = orderNumber; }
	private Long orderNumber;

	@Column(name="amount_total")
	public BigDecimal getAmountTotal() { return amountTotal; }
	public void setAmountTotal(BigDecimal amountTotal) { this.amountTotal = amountTotal; }
	private BigDecimal amountTotal;

	@Column
	public Boolean getPaid() { return paid; }
	public void setPaid(Boolean paid) { this.paid = paid; }
	private Boolean paid;

	@Column
	public String getNotes() { return notes; }
	public void setNotes(String notes) { this.notes = notes; }
	private String notes;

	// Relationships
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="customer_name", nullable=false)
	public Customer getCustomer() { return customer; }
	public void setCustomer(Customer customer) { this.customer = customer; }
	private Customer customer;

	@OneToMany(mappedBy="purchaseorder", cascade={CascadeType.ALL}, fetch=FetchType.EAGER)
	@OrderBy("lineitemId desc")
	public List&lt;Lineitem> getLineitems() { return lineitems; }
	public void setLineitems(List&lt;Lineitem> lineitems) { this.lineitems = lineitems; }
	private List&lt;Lineitem> lineitems = new Vector&lt;Lineitem>();
}</pre>
					</div>
					<div id="domainTabs-3">
						<pre class="brush: java">
@Entity
@Table(name="lineitem")
public class Lineitem implements java.io.Serializable {
	
	@Id 
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name="lineitem_id")
	public long getLineitemId() { return lineitemId;}
	public void setLineitemId(long lineitemId) { this.lineitemId = lineitemId;}
	private long lineitemId;
	
	@Column(name="qty_ordered")
	public Integer getQtyOrdered() { return qtyOrdered; }
	public void setQtyOrdered(Integer qtyOrdered) { this.qtyOrdered = qtyOrdered; }
	private Integer qtyOrdered;
	
	@Column(name="product_price")
	public BigDecimal getProductPrice() { return productPrice; }
	public void setProductPrice(BigDecimal productPrice) { this.productPrice = productPrice; }
	private BigDecimal productPrice;
	
	@Column
	public BigDecimal getAmount() { return amount; }
	public void setAmount(BigDecimal amount) { this.amount = amount; }
	private BigDecimal amount;
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="product_number")
	public Product getProduct() { return product;}
	public void setProduct(Product product) { this.product = product; }
	private Product product;
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="order_number")
	public Purchaseorder getPurchaseorder() { return purchaseorder; }
	public void setPurchaseorder(Purchaseorder purchaseorder) { this.purchaseorder = purchaseorder; }
	private Purchaseorder purchaseorder;
}</pre>
					</div>
					<div id="domainTabs-4">
						<pre class="brush: java">
@Entity
@Table(name="product")
public class Product implements java.io.Serializable {

	@Id
	@Column(name="product_number")
	public long getProductNumber() { return productNumber; }
	public void setProductNumber(long prodNum) { this.productNumber = prodNum; }
	private long productNumber;

	@Column
	public String getName() { return this.name; }
	public void setName(String name) { this.name = name; }
	private String name;

	@Column
	public BigDecimal getPrice() { return price; }
	public void setPrice(BigDecimal price) { this.price = price; }
	private BigDecimal price;

	
	@OneToMany(cascade={CascadeType.ALL}, fetch=FetchType.LAZY, mappedBy="product")
	public Set&lt;Lineitem> getLineitems() { return lineitems; }
	public void setLineitems(Set&lt;Lineitem> lineitems) { this.lineitems = lineitems; }
	private Set&lt;Lineitem> lineitems = new HashSet&lt;Lineitem>();
}</pre>
					</div>
				</div>
			</td>
		</tr>
	</table>
	</div>
	<!-- Tab 3 -->
	<div id="tabs-3">
	<table border="0">
		<thead style="background-color: #DDDDDD; font-size: 15pt;">
			<tr><td>Code</td><td>Requirements</td></tr>
		</thead>
		<tr>
			<td>
				<pre class="brush: java" id="LogicCode1">
public class CustomerLogic {
	
	@Sum("purchaseorders.amountTotal where paid = false")
	public void deriveBalance() { }

	@Constraint("balance &lt;= creditLimit")
	public void constraintCreditLimit() { }
}</pre>
			</td>
			<td class="requirement">
				<ul>
					<li>Customer balance = sum(unpaid orders)
				</ul>
				<p/>
				<ul>
					<li>Customer balance <= credit limit
				</ul>
			</td>
		</tr>
		<tr>
			<td>
				<pre class="brush: java" id="LogicCode2">
public class PurchaseorderLogic {

	@Sum("lineitems.amount")
	public void deriveAmountTotal() { }
}</pre>
			</td>
			<td class="requirement">
				<ul>
					<li>Order total = sum(line items)
				</ul>
			</td>
		</tr>
		<tr>
			<td>
				<pre class="brush: java" id="LogicCode3">
public class LineitemLogic {
	
	@Formula("productPrice * qtyOrdered")
	public void deriveAmount() { }

	@ParentCopy("product.price")
	public void deriveProductPrice() { }
}</pre>
			</td>
			<td class="requirement">
				<ul>
					<li>Line item total = price * quantity
				</ul>
				<p/>
				<ul>
					<li>Line item price = copy product price
				</ul>
			</td>
		</tr>
	</table>
	</div>
	<div id="tabs-4">
		<img src="images/Architecture.png" />
	</div>
	<div id="tabs-5">
		<h3>Summary and links</h3>
		<table border="0" cellspacing="10">
			<tr>
				<td>
					<ul>
						<li id="Point1" style='padding: 5px;'>ABL automates complex, multi-table transaction logic
						<li id="Point2" style='padding: 5px;'>It automates all dependency management (critical for development and maintenance)
						<li id="Point3" style='padding: 5px;'>It enables automatic reuse and assured integrity
						<li id="Point4" style='padding: 5px;'>It's open source and runs with anything that uses Hibernate
					</ul>
				</td>
			</tr>
			<tr>
				<td>
					<table border="0">
						<tr>
							<td id="WebSiteLink"><a href="http://www.automatedbusinesslogic.com" target="HomeSite">http://www.automatedbusinesslogic.com</a></td>
						</tr>
						<tr>
							<td><a href="http://www.automatedbusinesslogic.com/Getting-Started/downloads" target="HomeSite">Download the product and demos</a></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>


	<script>
	$(function() {
		$( "#tabs" ).tabs();
		$( "#domainTabs" ).tabs();
		SyntaxHighlighter.all();
		SyntaxHighlighter.config.strings.help = "";
	});
	</script>
</body>
</html>