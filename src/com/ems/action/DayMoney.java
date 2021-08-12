package com.ems.action;

import java.sql.Connection;

import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;

import org.apache.log4j.Logger;

import com.ems.common.dbcp.DBManager;
import com.ems.common.dbcp.DataSource;
import com.ems.common.util.EmsHashtable;
import com.ems.common.util.QueryXMLParser;;


public class DayMoney {

	private static Logger log = Logger.getLogger(DayMoney.class.getName());

	ServletRequest request = null;

	EmsHashtable userinfo=null;
	int sessionHashCode;

	DBManager dbm = null;

	String msg="";




	public DayMoney(ServletContext application,ServletRequest request, EmsHashtable userinfo, int sessionHashCode) {
		this.request = request;
		this.userinfo = userinfo;
		this.sessionHashCode=sessionHashCode;


		DataSource ds = (DataSource)application.getAttribute("jdbc/mysql_ds");

		dbm = new DBManager(ds);


	    String event = request.getParameter("event");
	    if (event == null) {
	        event = "find";
	    }



	    if(event.equals("find")){
	    	list();
	    }else if(event.equals("modify")){
	    	modify();
	    	list();
	    }

	}

	public void list() {



		String LOGINID = userinfo.getString("LOGINID");
		String P_CD_MEANING = request.getParameter("P_CD_MEANING")==null?"":request.getParameter("P_CD_MEANING");



		try {

			log.info("LOGINID  "+ LOGINID);

			EmsHashtable[] hash =
				dbm.selectMultipleRecord(QueryXMLParser.getQuery(this.getClass(), "daymoney.xml", "list_sql"),new String[] {  LOGINID,P_CD_MEANING });

			request.setAttribute("hash", hash);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}


	public void modify() {

		String chk[] = request.getParameterValues("chk");
        String PK_CD_ID[] = request.getParameterValues("PK_CD_ID");
        String CD_MEANING[] = request.getParameterValues("CD_MEANING");
        String PRICE[] = request.getParameterValues("PRICE");
        String LOGINID = userinfo.getString("LOGINID");
        Connection con = null;

		try {

			 con  = dbm.getConnection();

			int idx=0;

			for (int i = 0; i < chk.length; i++) {

  	        idx = Integer.parseInt(chk[i]);
            log.info(Integer.valueOf(idx));
            dbm.insert(con, QueryXMLParser.getQuery(getClass(), "daymoney.xml", "update_sql"), new String[] {
                CD_MEANING[idx],  PRICE[idx],  PK_CD_ID[idx], LOGINID
            });

				msg="수정되었습니다.";

			}


			dbm.commitChange(con);

		} catch (Exception e) {
			e.printStackTrace();
			dbm.rollbackChange(con);
			msg="에러발생."+e.getMessage();


		}finally {

			request.setAttribute("msg", msg);
		}

	}


}
