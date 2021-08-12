
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.ems.common.util.*"%>
<%@ page import="com.ems.common.util.*"%>
<%@ page import="com.ems.common.dbcp.DBManager"%>
<%@page import="com.ems.common.dbcp.DataSource"%>
<%@ page import="com.ems.action.*"%>

<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>



<%	
//모바일인지 체크
String ua=request.getHeader("User-Agent").toLowerCase();

String s = CommUtil.getClientOS(ua);
boolean mobile=CommUtil.isMoblie(s);

EmsHashtable userinfo = session.getAttribute("userinfo")!=null?	(EmsHashtable) session.getAttribute("userinfo")	:null;

String ADMIN = session.getAttribute("ADMIN")!=null?	(String) session.getAttribute("ADMIN")	:"false";


	
%>	

