package com.ems.action;

import java.sql.Connection;

import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;

import org.apache.log4j.Logger;

import com.ems.common.dbcp.DBManager;
import com.ems.common.dbcp.DataSource;
import com.ems.common.smtp.GMailSender;
import com.ems.common.util.EmsHashtable;
import com.ems.common.util.QueryXMLParser;;


public class UserCreate {

	private static Logger log = Logger.getLogger(UserCreate.class.getName());

	ServletRequest request = null;

	EmsHashtable userinfo=null;
	int sessionHashCode;

	DBManager dbm = null;

	String msg="";




	public UserCreate(ServletContext application,ServletRequest request, EmsHashtable userinfo, int sessionHashCode) {
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

	    }else if(event.equals("insert")){
	    	insert();
	    	list();
	    }else if(event.equals("delete")){
	    	delete();
	    	list();
	    }else if(event.equals("newUser")){
	    	insert();

	    	String USERNAME = request.getParameter("NEW_USERNAME");
	    	String subject = USERNAME+" 신규 가입했습니다.";

	    	new GMailSender().mailSender("예약시스템",subject, "fmjj007@naver.com",subject );

	    }





	}

	public void list() {

		String LOGINID = userinfo.getString("LOGINID");
		String P_USERNAME = request.getParameter("P_USERNAME")==null?"":request.getParameter("P_USERNAME");

		try {

			log.info("LOGINID  "+ LOGINID);

			EmsHashtable[] hash =
				dbm.selectMultipleRecord(QueryXMLParser.getQuery(this.getClass(), "usercreate.xml", "list_sql"),new String[] { P_USERNAME });

			request.setAttribute("hash", hash);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}


	public void insert() {

        String USERNAME = request.getParameter("NEW_USERNAME");
        String TEL1 = request.getParameter("NEW_TEL1");
        String LOGINID = request.getParameter("NEW_LOGINID");
        String LOGINPW = request.getParameter("NEW_LOGINPW");
        String ACCESSPW = request.getParameter("NEW_ACCESSPW");
        String EMAIL = request.getParameter("NEW_EMAIL");

        Connection con = null;

		try {

			 con  = dbm.getConnection();

            dbm.insert(con, QueryXMLParser.getQuery(getClass(), "usercreate.xml", "inser_user1"), new String[] {
            		USERNAME,
            		TEL1,
                    LOGINID,
                    LOGINPW,
                    ACCESSPW,
                    EMAIL
            });


            dbm.insert(con, QueryXMLParser.getQuery(getClass(), "usercreate.xml", "inser_user2"), new String[] {
            		LOGINID
            });

			dbm.commitChange(con);

			msg="등록되었습니다.";

		} catch (Exception e) {
			e.printStackTrace();
			dbm.rollbackChange(con);
			msg="에러발생."+e.getMessage();


		}finally {

			request.setAttribute("msg", msg);
		}

	}




	public void modify() {

		String chk[] = request.getParameterValues("chk");
        String PK_LOGINID[] = request.getParameterValues("PK_LOGINID");
        String USERNAME[] = request.getParameterValues("USERNAME");
        String TEL1[] = request.getParameterValues("TEL1");
        String LOGINID[] = request.getParameterValues("LOGINID");
        String LOGINPW[] = request.getParameterValues("LOGINPW");
        String ACCESSPW[] = request.getParameterValues("ACCESSPW");
        String EMAIL[] = request.getParameterValues("EMAIL");
        String STATUS[] = request.getParameterValues("STATUS");

        Connection con = null;

		try {

			 con  = dbm.getConnection();

			int idx=0;

			for (int i = 0; i < chk.length; i++) {

	  	        idx = Integer.parseInt(chk[i]);

	            dbm.insert(con, QueryXMLParser.getQuery(getClass(), "usercreate.xml", "update_sql"), new String[] {
	            		USERNAME[idx],
	            		TEL1[idx],
	            		LOGINID[idx],
	                    LOGINPW[idx],
	                    ACCESSPW[idx],
	                    EMAIL[idx],
	                    STATUS[idx],
	                    PK_LOGINID[idx]
	            });



			}

			msg="수정되었습니다.";

			dbm.commitChange(con);

		} catch (Exception e) {
			e.printStackTrace();
			dbm.rollbackChange(con);
			msg="에러발생."+e.getMessage();


		}finally {

			request.setAttribute("msg", msg);
		}

	}

	public void delete() {

		String chk[] = request.getParameterValues("chk");
        String PK_LOGINID[] = request.getParameterValues("PK_LOGINID");

        Connection con = null;

		try {

			 con  = dbm.getConnection();

			int idx=0;

			for (int i = 0; i < chk.length; i++) {

	  	        idx = Integer.parseInt(chk[i]);

	            dbm.delete(con, QueryXMLParser.getQuery(getClass(), "usercreate.xml", "delete_user_sql"), new String[] {
	                    PK_LOGINID[idx]
	            });

	            dbm.delete(con, QueryXMLParser.getQuery(getClass(), "usercreate.xml", "delete_user1_sql"), new String[] {
	                    PK_LOGINID[idx]
	            });


			}

			msg="삭제되었습니다.";

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
