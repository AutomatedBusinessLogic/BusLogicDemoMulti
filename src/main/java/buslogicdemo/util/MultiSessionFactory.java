package buslogicdemo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

/**
 * Please note: this class is used only for hosted demos where each user must have their own
 * copy of the database. This is not the correct way to do this in typical situations.
 */
public class MultiSessionFactory implements HttpSessionListener {
	public static boolean active = false;
	public static Map<String, SessionFactory> sessionFactories = Collections.synchronizedMap(new HashMap<String, SessionFactory>());

	/**
	 * Set up Hibernate. This can be called any number of times, but only the first time per session
	 * will actually do anything.
	 */
	public static void setup(String sessionId) {
		active = true;
		
		SessionFactory sessionFactory = sessionFactories.get(sessionId);
		if (sessionFactory != null)
			return;
		
		Configuration config = new Configuration().configure("/buslogicdemo/data/buslogicdemo.cfg.xml");		
		config.setProperty("hibernate.current_session_context_class", "com.autobizlogic.abl.session.LogicThreadLocalSessionContext");
		config.setProperty("hibernate.connection.url", "jdbc:hsqldb:mem:" + sessionId);

		sessionFactory = config.buildSessionFactory();
		sessionFactories.put(sessionId, sessionFactory);
		
		Session session = sessionFactory.getCurrentSession();
		beginTransaction(sessionId);
		DataLoader.loadData(session);
		commitTransaction(sessionId);
	}
	
	public static Session getSession(String sessionId) {
		SessionFactory sessionFactory = sessionFactories.get(sessionId);
		return sessionFactory.getCurrentSession();
	}

	public static void beginTransaction(String sessionId) {
		Session session = getSession(sessionId);
		if (session == null)
			return;
		session.beginTransaction();
	}
	
	public static void commitTransaction(String sessionId) {
		Session session = getSession(sessionId);
		if (session == null)
			return;
		session.getTransaction().commit();
	}

	public static void rollbackTransaction(String sessionId) {
		Session session = getSession(sessionId);
		if (session == null)
			return;
		session.getTransaction().rollback();
	}
	
	///////////////////////////////////////////////////////////////////////
	// HttpSessionListener methods

	@Override
	public void sessionCreated(HttpSessionEvent evt) {
		System.out.println("Session created: " + evt.getSession().getId());
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent evt) {
		String sessionId = evt.getSession().getId();
		try {
			Connection conn = DriverManager.getConnection("jdbc:hsqldb:mem:" + evt.getSession().getId());
			Statement stmt = conn.createStatement();
			System.out.println("Shutting down database for session " + evt.getSession().getId());
			stmt.execute("shutdown;");
			
		}
		catch(Exception ex) {
			System.err.println("Error shutting down database: " + ex.toString());
		}
		sessionFactories.remove(sessionId);
		System.out.println("Session destroyed: " + evt.getSession().getId());
	}
}
