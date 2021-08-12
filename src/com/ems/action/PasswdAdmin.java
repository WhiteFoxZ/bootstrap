package com.ems.action;

import java.sql.Connection;
import java.util.HashMap;

import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;

import org.apache.log4j.Logger;

import com.ems.common.dbcp.DBManager;
import com.ems.common.dbcp.DataSource;
import com.ems.common.util.EmsHashtable;;

public class PasswdAdmin {

	private static Logger log = Logger.getLogger(PasswdAdmin.class.getName());

	ServletRequest request = null;

	EmsHashtable userinfo = null;
	int sessionHashCode;

	DBManager dbm = null;

	String msg = "";

	public PasswdAdmin(ServletContext application, ServletRequest request, EmsHashtable userinfo, int sessionHashCode) {
		this.request = request;
		this.userinfo = userinfo;
		this.sessionHashCode = sessionHashCode;

		DataSource ds = (DataSource) application.getAttribute("jdbc/mysql_ds");

		dbm = new DBManager(ds);

		String event = request.getParameter("event");
		if (event == null) {
			event = "find";
		}

		if (event.equals("find")) {
			list();
		} else if (event.equals("modify")) {
			modify();
			list();
		}

	}

	public void list() {

		String LOGINID = userinfo.getString("LOGINID");

		try {

//			log.info("LOGINID  " + LOGINID);

			EmsHashtable[] hash = dbm.selectMultipleRecord("SELECT * FROM user_info where LOGINID=? ",
					new String[] { LOGINID });

			request.setAttribute("hash", hash);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@SuppressWarnings("unchecked")
	public void modify() {

		String PK_LOGINID = request.getParameter("PK_LOGINID");
		String USERNAME = request.getParameter("USERNAME");
		String TEL1 = request.getParameter("TEL1");
		String LOGINPW = request.getParameter("LOGINPW");
		String ACCESSPW = request.getParameter("ACCESSPW");
		String EMAIL = request.getParameter("EMAIL");

		Connection con = null;

		try {

			con = dbm.getConnection();

			HashMap map = new HashMap();

			map.put("USERNAME", USERNAME);
			map.put("TEL1", TEL1);
			map.put("LOGINPW", LOGINPW);
			map.put("ACCESSPW", ACCESSPW);
			map.put("EMAIL", EMAIL);

			dbm.modify(con, map, "user_info", " LOGINID=? ", new String[] { PK_LOGINID });

			msg = "수정되었습니다.";

			dbm.commitChange(con);

		} catch (Exception e) {
			e.printStackTrace();
			dbm.rollbackChange(con);
			msg = "에러발생." + e.getMessage();

		} finally {
			request.setAttribute("msg", msg);

		}

	}

}
