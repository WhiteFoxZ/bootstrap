<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="com.ems.common.util.*"%>
<%@ page import="com.ems.common.box.*"%>
<%@ page import="com.ems.action.util.*"%>
<%@ page import="com.ems.common.dbcp.DBManager"%>
<%@page import="com.ems.common.dbcp.DataSource"%>

<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>


<%


int sessionHashCode = session.getId().hashCode();

String remoteIp = request.getRemoteAddr();

String id = request.getParameter("id");
String pw = request.getParameter("pw");
String remember = request.getParameter("remember");

DBManager dbm = new DBManager((DataSource)application.getAttribute("jdbc/mysql_ds"));

EmsHashtable[] hash = dbm.selectMultipleRecord("select /*+ rule */ USERNAME, TEL1, TEL2, LOGINID, LOGINPW, ACCESSPW, EMAIL, STATUS, IMG_UPLOAD from user_info where LOGINID=UPPER(?)",
		new String[] { id });


String LOGINID="";
String STATUS="";
String LOGINPW="";

try{



if(hash!=null && hash.length>0){
	STATUS = hash[0].getString("STATUS");
	LOGINPW = hash[0].getString("LOGINPW");
	LOGINID = hash[0].getString("LOGINID");

	session.setAttribute("userinfo",hash[0]);
	session.setAttribute("ADMIN","true");		//어드민세션관리
	session.setMaxInactiveInterval(60*15);	//15분
	//session.setMaxInactiveInterval(10);	//10초
	//log(hash[0].toString());

	Cookie cookie1 = new Cookie("LOGINID",LOGINID);
	Cookie cookie2 = new Cookie("LOGINPW",LOGINPW);


	if(remember!=null){

		cookie1.setMaxAge(60*60*24*1);			//3600 1시간
		cookie2.setMaxAge(60*60*24*1);			//3600 1시간
		response.addCookie(cookie1);
		response.addCookie(cookie2);
	}else{

		cookie1.setMaxAge(0);
		cookie2.setMaxAge(0);
		response.addCookie(cookie1);
		response.addCookie(cookie2);
	}
}


}catch(Exception e){
	e.printStackTrace();
}


/**
패스워드가 맞으면 상태를 체크한다.
**/
%>

<html>
    <head>
        <title>로그인중...</title>
        <link rel="stylesheet" href="./css/pub.css" type="text/css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <Script Language="JavaScript" src="./js/common/messcript.js"></script>

<SCRIPT language=javascript>


function init(){


<%
if(LOGINPW.equals("")){
%>
alert('아이디가 없습니다. 관리자에게 문의하세요');
document.location.href='<%=request.getContextPath()%>/login.jsp';
return false;
<%}
%>


<%
if(!LOGINPW.equals(pw)){
%>
alert('비밀번호가 틀립니다.');
document.location.href='<%=request.getContextPath()%>/login.jsp';
return false;
<%}
%>



<%
if(!STATUS.equals("1")){
%>
alert('만료상태입니다. 관리자에게 문의하세요.');
document.location.href='<%=request.getContextPath()%>/login.jsp';
//document.location.href='<%=request.getContextPath()%>/login.jsp';
return false;
<%
}
%>

document.location.href='<%=request.getContextPath()%>/cal.jsp';
//document.location.href='<%=request.getContextPath()%>/list.jsp';

}

</SCRIPT>
<body onload="init()">
</body>
