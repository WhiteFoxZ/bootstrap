<%@ page   pageEncoding="UTF-8"%>

<%@ include file="include.jsp" %>

<%@ page import="com.ems.common.encrypt.AES256Util"%>

<%

//관리자 패스워드 바꾸는 기능

if(userinfo!=null){

	String USERNAME = userinfo.getString("USERNAME");

  String event = request.getParameter("event");
  if (event == null) {
      event = "find";
  }



  String LOGINID = userinfo.getString("LOGINID");

  int sessionHashCode = session.getId().hashCode();

  PasswdAdmin passwdAdmin = new PasswdAdmin(application,request, userinfo, sessionHashCode);


  EmsHashtable[] hash  = (EmsHashtable[])request.getAttribute("hash");


  String url = "http://" + request.getServerName()
  +""+request.getContextPath()
  +"/index.jsp?id="
  +hash[0].getString("LOGINID")
  +"&pw="
  +hash[0].getString("ACCESSPW");

%>


<!DOCTYPE html>
<html lang="en">
  <head>
  <title>예약등록</title>
      <meta charset="utf-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
      <meta name="description" content="" />
      <meta name="author" content="" />
      <title>Dashboard - SB Admin</title>

          <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>

       <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
       <script src="js/scripts.js"></script>
      <script src="https://code.jquery.com/jquery-3.5.1.js"></script>

      <script src="https://cdn.jsdelivr.net/npm/clipboard@2.0.8/dist/clipboard.min.js"></script>


<style>

@font-face{
font-family:'Youth';
font-style:normal;
font-weight:400;
src:url('//cdn.jsdelivr.net/korean-webfonts/1/orgs/othrs/kywa/Youth/Youth.woff2') format('woff2'),
    url('//cdn.jsdelivr.net/korean-webfonts/1/orgs/othrs/kywa/Youth/Youth.woff') format('woff');
}

body {font-family:'Youth';}

.card-body {
flex: 1 1 auto;
}




.input-sm {
   height: 25px;
   padding: 1px 10px;
   font-size: 12px;
   line-height: 1.5;
   border-radius: 3px;
}


/*
##Device = Most of the Smartphones Mobiles (Portrait)
##Screen = B/w 320px to 479px
##Device = 대부분의 스마트폰 모바일 기기(세로)
##Screen = 320px에서 479px 사이
*/

@media (min-width: 320px) and (max-width: 480px) {



}

</style>




<SCRIPT>



var submitFlag=true;


function setEvent(event){

    if(submitFlag==true){
        document.frmMain.event.value=event;
        submitFlag=false;
        document.frmMain.submit();
        return false;

    }


}




function init(){

		new ClipboardJS('.copybtn');

		toastInit();

        <%
        String msg = request.getAttribute("msg")!=null?request.getAttribute("msg").toString():null;

        if(msg!=null && msg.length()>0){
        %>

        var msgText="<%=msg%>";

        showMsg(msgText);


    <%}%>

}






       </script>

  </head>
  <body class="sb-nav-fixed" onload ="init()" >

  <%@ include file="include_sb-topnav.jsp" %>

      <div id="layoutSidenav">

          <%@ include file="include_layoutSidenav_nav.jsp" %>


          <div id="layoutSidenav_content">

<form name="frmMain" method="post" onsubmit="return false;"  >
<input type="hidden" name="event" value="" />


              <main>
                  <div class="container-fluid px-2" >

                      <div class="card mt-1 " >
                          <div class="card-header">
                              <i class="fas fa-table me-1"></i>

                          </div>

                          <div class="card-body2">


<%@ include file="include_toast.jsp" %>


							 <div class="row m-1 ">
							   <label for="USERNAME" class="col-4 col-form-label">업체명</label>
							   <div class="col-8">
							     <input type="text" class="form-control"  name="USERNAME" id="USERNAME" value="<%=hash[0].getString("USERNAME")%>" placeholder="업체명을 입력하세요." data-enhance="false" >
							     <input type="HIDDEN" name="PK_LOGINID" value="<%=hash[0].getString("LOGINID")%>"  >
							   </div>
							 </div>
							 <div class="row m-1 ">
							   <label for="TEL1" class="col-4 col-form-label">연락처</label>
							   <div class="col-8">
							     <input type="text" class="form-control" name="TEL1" id="TEL1" value="<%=hash[0].getString("TEL1") %>" placeholder="연락처을 입력하세요." data-enhance="false" >

							   </div>
							 </div>
							 <div class="row m-1">
							   <label for="LOGINPW" class="col-4 col-form-label">패스워드</label>
							   <div class="col-8">
							     <input type="text" class="form-control" name="LOGINPW" id="LOGINPW" value="<%=hash[0].getString("LOGINPW") %>" placeholder="패스워드를 입력하세요." data-enhance="true">
							   </div>
							 </div>

							 <div class="row m-1">
							   <label for="inputEmail3" class="col-4 col-form-label">접속패스</label>
							   <div class="col-8">
							     <input type="text" class="form-control" name="ACCESSPW" id="ACCESSPW" value="<%=hash[0].getString("ACCESSPW") %>" placeholder="접속패스를 입력하세요." data-enhance="true">
							   </div>
							 </div>

							 <div class="row m-1">
							   <label for="foo" class="col-4 col-form-label">예약URL</label>
							   <div class="col-8">
							     <input type="text" class="form-control" name="foo" id="foo" value="<%=url%>" data-enhance="true">
							     <button type="button" class="btn btn-info btn-sm copybtn" style="width: 100%" data-clipboard-target="#foo" > <i class="fas fa-undo"></i> 복사</button>
							   </div>
							 </div>

							<div class="row my-2 m-1" >

								<button type="button" class="btn btn-primary btn-sm" style="width: 100%" onclick="javascript:return save('modify');"> <i class="fas fa-undo"></i> 저장</button>

							</div>

							</div>


                          </div><!-- card mt-1 -->
                      </div><!-- container-fluid px-2 -->

</form>
					</main>
                  </div>

              <%@ include file="include_footer.jsp" %>
          </div>
      </div>


  </body>
</html>


<%
}else{    //LOGIN 정보가 없을때
%>

<jsp:include page="userinfo.jsp" flush="true"/>

<%} %>