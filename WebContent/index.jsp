<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.ems.common.util.*"%>
<%@ page import="com.ems.common.box.*"%>
<%@ page import="com.ems.action.util.*"%>
<%@ page import="com.ems.common.dbcp.DBManager"%>
<%@page import="com.ems.common.dbcp.DataSource"%>

<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>


<%

//일반사용자 접근
//http://localhost/sheep/index.jsp?id=fish&pw=fish
//http://localhost/sheep/index.jsp?id=TEST&pw=TEST

int sessionHashCode = session.getId().hashCode();

String remoteIp = request.getRemoteAddr();

String id = request.getParameter("id");
String pw = request.getParameter("pw");

if(id==null ) id="fish";
if(pw==null ) pw="fish";



DBManager dbm = new DBManager((DataSource)application.getAttribute("jdbc/mysql_ds"));


EmsHashtable[] hash = dbm.selectMultipleRecord("select /*+ rule */ * from user_info where LOGINID=UPPER(?)",
		new String[] { id });


String LOGINID="";
String STATUS="";
String ACCESSPW="";

try{



if(hash!=null && hash.length>0){
	STATUS = hash[0].getString("STATUS");
	ACCESSPW = hash[0].getString("ACCESSPW");
	LOGINID = hash[0].getString("LOGINID");

	session.setAttribute("userinfo",hash[0]);		//일반유저세션관리
	session.setAttribute("ADMIN","false");			//일반유저세션관리
	session.setMaxInactiveInterval(60*10);	//10분

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
        <title></title>
        <link rel="stylesheet" href="./css/pub.css" type="text/css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <Script Language="JavaScript" src="./js/common/messcript.js"></script>

<SCRIPT language=javascript>


function init(){


<%
if(ACCESSPW.equals("")){
%>
alert('아이디가 없습니다. 관리자에게 문의하세요');
history.back();
return false;
<%}
%>


<%
if(!ACCESSPW.equals(pw)){
%>
alert('접근비밀번호가 틀립니다.');
history.back();
return false;
<%}
%>



<%
if(!STATUS.equals("1")){
%>
alert('만료상태입니다. 관리자에게 문의하세요.');
history.back();
return false;
<%
}
%>

document.location.href='<%=request.getContextPath()%>/cal.jsp';

}

</SCRIPT>
<body onload="init()">
</body>
