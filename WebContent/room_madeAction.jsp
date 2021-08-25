<%@ page pageEncoding="UTF-8"%>


<%@ include file="include.jsp" %>


<%


if(userinfo!=null){

    String event = request.getParameter("event");
    if (event == null) {
        event = "find";
    }

    int sessionHashCode = session.getId().hashCode();

	new RoomMadeAction(application,request,response, userinfo, sessionHashCode);

    String rdate=request.getParameter("rdate")!=null?request.getParameter("rdate").toString():"";

    String link_url = mobile?"list.jsp":"list.jsp";

%>
<!-- html 시작 -->

<html>
<head>

<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css" />
<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>

<title>예약등록 처리중...</title>

        <SCRIPT language=javascript>


            function setEvent(event){

                document.frmMain.event.value=event;
                document.frmMain.submit();

            }

            function init(){

            	<%
            	String msg = request.getAttribute("msg")!=null?request.getAttribute("msg").toString():null;

            	if(msg!=null && msg.length()>0){
            	%>

            	var msgText="<%=msg%>";
            	var textVisible="true";
            	var textonly="true";
            	var theme="a";
            	var html="";

            	$.mobile.loading( "show", {
            		text: msgText,
            		textVisible: textVisible,
            		theme: theme,
            		textonly: textonly,
            		html: html
            	});


            	var timer = setTimeout(hideMsg, 2000);

            	<%}%>
            }


            function hideMsg(){
            	$.mobile.loading( "hide" );

            	location.href="<%=link_url%>?rdate=<%=rdate%>";

            }

        </script>


</head>


<body onload=init() >

</body>



</html>


<!-- html 끝 -->
<%


}else{	//LOGIN 정보가 없을때
%>

<jsp:include page="userinfo.jsp" flush="true"/>

<%} %>


