package com.ems.action;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.ems.common.dbcp.DBManager;
import com.ems.common.dbcp.DataSource;
import com.ems.common.encrypt.AES256Util;
import com.ems.common.smtp.GMailSender;
import com.ems.common.util.EmsDateUtil;
import com.ems.common.util.EmsHashtable;
import com.ems.common.util.QueryXMLParser;
import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;


public class RoomMadeAction {

	private static Logger log = Logger.getLogger(RoomMadeAction.class.getName());

	HttpServletRequest request = null;
	HttpServletResponse response =null;

	EmsHashtable userinfo=null;
	int sessionHashCode;

	DBManager dbm = null;

	String msg="";

	private AES256Util aes;


	public RoomMadeAction(ServletContext application,HttpServletRequest request, HttpServletResponse response,EmsHashtable userinfo, int sessionHashCode) {
		this.request = request;
		this.response = response;

		this.userinfo = userinfo;
		this.sessionHashCode=sessionHashCode;


		DataSource ds = (DataSource)application.getAttribute("jdbc/mysql_ds");

		dbm = new DBManager(ds);


		try {
			aes = new AES256Util("asdwsx1031902461");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}



	    String event = request.getParameter("event");
	    if (event == null) {
	        event = "find";
	    }



	    if(event.equals("find")){

	    }else if(event.equals("modify")){
	    	try {
				modify();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }

	}

	public void list() {



	}

	/**
	 * 일반사용자가 예약을 했을때 처리
	 */
	public void modify() throws Exception{

		String RESERVE_DATE = request.getParameter("RESERVE_DATE"); // 카드ID
		String USER_TEL1 = request.getParameter("USER_TEL1"); // 카드ID
		String ROOM_NUM = request.getParameter("ROOM_NUM"); // 카드ID
		String MEMO = request.getParameter("MEMO"); // 카드ID
		String USER_NAME = request.getParameter("USER_NAME"); // 카드ID
		String DAY = request.getParameter("DAY"); // 일자

		String PEOPLE_ADD_CNT = request.getParameter("PEOPLE_ADD_CNT");
		String TOTAL_PAY = request.getParameter("TOTAL_PAY");
		String PRICE_DESC = request.getParameter("PRICE_DESC");



		//그룹키 : 예약일자FROM(10) + 예약일자TO(10) +방번호(2) = 22 자리 GROUP_KEY


		log.info("*****************시작 ***************");


		if(!validate()){

			request.setAttribute("RESERVE_DATE", RESERVE_DATE);
			request.setAttribute("USER_TEL1", USER_TEL1 );
			request.setAttribute("ROOM_NUM", ROOM_NUM);
			request.setAttribute("MEMO", MEMO);


			request.setAttribute("USER_NAME", USER_NAME);
            request.setAttribute("PEOPLE_ADD_CNT", PEOPLE_ADD_CNT);
            request.setAttribute("TOTAL_PAY", TOTAL_PAY);



			msg="이미지 인증에 실패했습니다.";

			request.setAttribute("msg", msg);

			log.info(msg);

			try {

				RequestDispatcher rd = request.getRequestDispatcher("room_made.jsp");
				rd.forward(request, response);

			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			return ;


		}else{

			log.info("인증에 성공했습니다.");


		}

		RESERVE_DATE = RESERVE_DATE.replaceAll("-", "");

		String LOGINID = userinfo.getString("LOGINID");
		String toDay="";
		String END_OF_DAY=EmsDateUtil.addDay(Integer.parseInt(RESERVE_DATE),Integer.parseInt(DAY)-1,"yyyyMMdd");
		String GROUP_KEY="";


		USER_TEL1 = converTel(USER_TEL1);

		Connection con=null;

		try {

			 con  = dbm.getConnection();


			 if(con.getAutoCommit()){
				 con.setAutoCommit(false);
			 }



			 log.info("2 RESERVE_DATE----> "+RESERVE_DATE);
			 log.info("2 END_OF_DAY----> "+END_OF_DAY);

			 EmsHashtable[] data = dbm.selectMultipleRecord(con, "select * from reserve_info where LOGIN_ID=? and ROOM_NUM=? and RESERVE_DATE between ? and  ? "
					 , new String[]{LOGINID,ROOM_NUM,RESERVE_DATE,END_OF_DAY});

			 log.info("예약정보 있는지 체크 예약갯수는 ? "+data.length);

			 if(data.length>0){

				 throw new MySQLIntegrityConstraintViolationException("예약 처리실패하였습니다.이미 예약된 내용이 있습니다.");

			 }else{

				for(int i=0; i<Integer.parseInt(DAY); i++){

					log.debug(EmsDateUtil.addDay(Integer.parseInt(RESERVE_DATE),i,"yyyyMMdd"));

					toDay = EmsDateUtil.addDay(Integer.parseInt(RESERVE_DATE),i,"yyyyMMdd");

					GROUP_KEY = RESERVE_DATE+"~"+END_OF_DAY+" "+ROOM_NUM;

					dbm.insert(con, QueryXMLParser.getQuery(getClass(), "list.xml", "insert_sql"), new String[] {
		                USER_NAME,
		                aes.encrypt( USER_TEL1 ),
		                "",//USER_EMAIL
		                "",//ACCONT_NO,
		                toDay,
		                ROOM_NUM,
		                MEMO,
		                "",//CAR_NUM
		                LOGINID,
		                "1",
		                GROUP_KEY,
		                "0",//CAR_ADD_CNT
		                "0",//추가인원
		                TOTAL_PAY.replaceAll(",", ""),
		                PRICE_DESC
		            });


				}


				dbm.commitChange(con);

				msg="예약 처리되었습니다.";

				String subject=USER_NAME+" "+GROUP_KEY+" 번자리 예약이 되었습니다.";

				String to=userinfo.getString("EMAIL");		//관리자 메일

				String content=USER_NAME+" ("+USER_TEL1+")<BR>"+GROUP_KEY+" 번자리 예약이 되었습니다.";

				new GMailSender().mailSender("예약시스템.예약",subject, to, content);



			 }

		}catch(MySQLIntegrityConstraintViolationException mye){


			msg="예약 처리실패하였습니다.이미 예약된 내용이 있습니다.";

			log.info(msg);

			dbm.rollbackChange(con);

			mye.printStackTrace();


		} catch (Exception e) {


			msg="예약 처리실패하였습니다.관리자에게 문의바랍니다.";

			log.info(msg);

			dbm.rollbackChange(con);

			e.printStackTrace();


		}finally{


			request.setAttribute("msg", msg);

		}



	}



	private  boolean validate()
    {

		return true;

//           Boolean isResponseCorrect =Boolean.FALSE;
//           //remenber that we need an id to validate!
//           String captchaId = request.getSession().getId();
//           //retrieve the response
//           String signup = request.getParameter("signup");
//
//           System.out.println("captchaId = "+captchaId+"    signup -> "+signup);
//
//           // Call the Service method
//            try {
//
//                isResponseCorrect = CaptchaServiceSingleton.getInstance().getImgcapa().validateResponseForID(captchaId,signup);
//
//                // 캡차인증을 두번 호출하면 Exception 발행한다.
//
//            } catch (CaptchaServiceException e) {
//                 //should not happen, may be thrown if the id is not valid
//
//                 request.setAttribute("ERROR_MESSAGE",EmsMessage.MESSAGE66);
//                 e.printStackTrace();
//            }
//
//            return isResponseCorrect.booleanValue();
    }


	public static String converTel(String USER_TEL1 ) {
		if(USER_TEL1.indexOf("-")<0){	// -표시가 없을경우

			if(USER_TEL1.length()==10){	//가운데 자리가 3자리

				USER_TEL1 = USER_TEL1.substring(0,3)+"-"+USER_TEL1.substring(3,6)+"-"+USER_TEL1.substring(6);

			}

			if(USER_TEL1.length()==11){	//가운데가 4자리
				USER_TEL1 = USER_TEL1.substring(0,3)+"-"+USER_TEL1.substring(3,7)+"-"+USER_TEL1.substring(7);
			}

		}
		return USER_TEL1;
	}


	public static void main(String[] args){
		String USER_TEL1="0101902461";

		if(USER_TEL1.indexOf("-")<0){


			if(USER_TEL1.length()==10){	//가운데 자리가 3자리
				System.out.println(USER_TEL1.substring(0,3)+"-"+USER_TEL1.substring(3,6)+"-"+USER_TEL1.substring(6));
			}

			if(USER_TEL1.length()==11){	//가운데가 4자리
				System.out.println(USER_TEL1.substring(0,3)+"-"+USER_TEL1.substring(3,7)+"-"+USER_TEL1.substring(7));
			}

		}

		//
	}


}
