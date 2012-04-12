<%@ tag language="java" pageEncoding="ISO-8859-1"
	import="java.util.*"
	import="org.apache.commons.beanutils.BeanMap"
	import="buslogicdemo.util.DemoEventListener"
	import="com.autobizlogic.abl.engine.*" 
	import="com.autobizlogic.abl.businesslogicengine.constraintexcp.*" 
	import="com.autobizlogic.abl.rule.*" 
	import="com.autobizlogic.abl.event.*" 
	%>
<%
	DemoEventListener listener = DemoEventListener.getInstance();
	if (listener == null)
		return;

	// We want to alternate background color to attract attention to changes, otherwise it's easy to miss one.
	String bgColor = (String)session.getAttribute("ChangeSummaryBgColor");
	if ("DDFFDD".equals(bgColor))
		bgColor = "DDDDFF";
	else
		bgColor = "DDFFDD";
	session.setAttribute("ChangeSummaryBgColor", bgColor);
%>
<div style="border: 1px solid #888888; background-color: #<%= bgColor %>; padding: 5px; box-shadow: 10px 5px 5px #777777;" id="ChangeSummaryDiv">
	<h4 style="text-align: center;">What just happened?</h4>
	
	<table style="border: 1px solid #777777; margin: 5px;">
<%
	Map<String, String> changedAttrs = new HashMap<String, String>();
	for (LogicEvent event : listener.events) {
		String eventType = "&lt;unknown&gt;";
		String desc = event.toString();
		switch(event.getEventType()) {
			case AFTER_AGGREGATE: {
				eventType = "Sum";
				LogicAfterAggregateEvent laae = (LogicAfterAggregateEvent)event;
				AbstractAggregateRule rule = laae.getAggregateRule();
				Object oldValue = laae.getOldValue();
				if (oldValue == null)
					oldValue = "<null>";
				String aggregateAttribName = rule.getBeanAttributeName();
				Object newValue = laae.getPersistentBean().get(aggregateAttribName);
				if (newValue == null)
					newValue = "<null>";
				if (rule instanceof CountRule)
					eventType = "Count";
				desc = rule.getLogicMethodName() + " for " + rule.getLogicGroup().getMetaEntity().getEntityName() +
					", old value: " + oldValue + ", new value: " + newValue;
				}
				break;
			case AFTER_FORMULA: {
				eventType = "Formula";
				LogicAfterFormulaEvent lafe = (LogicAfterFormulaEvent)event;
				FormulaRule formula = lafe.getFormulaRule();
				Object oldValue = lafe.getOldValue();
				if (oldValue == null)
					oldValue = "&lt;null>";
				String formulaAttribName = formula.getBeanAttributeName();
				Object newValue = lafe.getPersistentBean().get(formulaAttribName);
				if (newValue == null)
					newValue = "&lt;null>";
				desc = formula.getLogicMethodName() + " for " + formula.getLogicGroup().getMetaEntity().getEntityName() +
					", old value: " + oldValue + ", new value: " + newValue;
				}
				break;
			case BEFORE_ACTION:
				eventType = "Before action";
				break;
			case AFTER_ACTION:
				eventType = "After action";
				break;
			case AFTER_CONSTRAINT: {
				eventType = "Constraint";
				LogicAfterConstraintEvent lace = (LogicAfterConstraintEvent)event;
				ConstraintRule constraint = lace.getConstraintRule();
				ConstraintFailure failure = lace.getFailure();
				desc = constraint.getLogicMethodName() + " for " + constraint.getLogicGroup().getMetaEntity().getEntityName();
				if (failure == null)
					desc += ", OK";
				else
					desc += ", failed: " + failure.getConstraintMessage();
				}
				break;
			case AFTER_PARENT_COPY: {
				eventType = "Parent copy";
				LogicAfterParentCopyEvent lapce = (LogicAfterParentCopyEvent)event;
				ParentCopyRule rule = lapce.getParentCopyRule();
				Object copyValue = lapce.getPersistentBean().get(rule.getChildAttributeName());
				if (copyValue == null)
					copyValue = "&lt;null>";
				desc = "From " + rule.getRoleName() + "." + rule.getParentAttributeName() + " to " + rule.getChildAttributeName() + ", value " + copyValue;
				}
				break;
			case LOGIC_RUNNER: {
				eventType = "Logic event";
				LogicRunnerEvent lre = (LogicRunnerEvent)event;
				if (lre.getLogicRunnerEventType() == LogicRunnerEvent.LogicRunnerEventType.END)
					continue;
				desc = event.getTitle();
				}
				break;
			case BEFORE_COMMIT:
				continue;
				//eventType = "Before commit";
				//break;
			case AFTER_COMMIT:
				continue;
				//eventType = "After commit";
				//break;
			default:
				throw new RuntimeException("Unknown event type:" + event.getEventType());
		}
%>
	<tr>
		<td style="border: 1px solid #777777;"><%= eventType %></td>
		<td style="border: 1px solid #777777;"><%= desc %></td>
	</tr>
<%
	}
	if (listener.events.isEmpty()) {
%>
	<tr><td>No business logic to display (yet).</td></tr>
<%
	}
	listener.resetEvents();
%>
	</table>
</div>