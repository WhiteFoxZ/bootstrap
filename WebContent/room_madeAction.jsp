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

    String link_url = "list.jsp";

%>
<!-- html 시작 -->

<html>
<head>

      <meta charset="utf-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
      <meta name="description" content="" />
      <meta name="author" content="" />

		<link href="css/styles.css" rel="stylesheet" />

       <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
       <script src="js/scripts.js"></script>
      <script src="https://code.jquery.com/jquery-3.5.1.js"></script>



<title>예약등록 처리중...</title>

        <SCRIPT language=javascript>


            function init(){


            	var option= {
                        animation: true,
                        autohide: true,
                        delay: 1500
                      }

                  toastMsg = new bootstrap.Toast($("#toastMsg"), option);



            	<%
            	String msg = request.getAttribute("msg")!=null?request.getAttribute("msg").toString():null;

            	if(msg!=null && msg.length()>0){
            	%>

            		var msgText="<%=msg%>";

              		showMsg(msgText);

            	<%}%>



                $('#toastMsg').on('hidden.bs.toast', function () {

                	location.href="<%=link_url%>?rdate=<%=rdate%>";

                	})



            }







        </script>


</head>


<body onload=init() >


<%@ include file="include_toast.jsp" %>

</body>



</html>


<!-- html 끝 -->
<%


}else{	//LOGIN 정보가 없을때
%>

<jsp:include page="userinfo.jsp" flush="true"/>

<%} %>


