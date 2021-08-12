<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ems.common.util.*"%>
<%@ page import="java.util.*"%>


<%

Cookie cookies[] = request.getCookies();
String cookieName=null;
String id="";
String pw="";

if(cookies!=null && cookies.length>0){
for(int i=0; i<cookies.length; i++){
	
	cookieName = cookies[i].getName();
	
	if(cookieName.equals("LOGINID")){
		id = cookies[i].getValue();
	}
	
	if(cookieName.equals("LOGINPW")){
		pw = cookies[i].getValue();
	}
	
}
}


%>


<script>

alert('로그인 정보가 없습니다.세션이 종료됐습니다.');

<%if(id.equals("")){%>
document.location.href='<%=request.getContextPath()%>/logout_user.jsp';

<%}else{%>
document.location.href='<%=request.getContextPath()%>/logout_admin.jsp';

<%}%>

</script>



