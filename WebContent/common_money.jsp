<%@ page   pageEncoding="UTF-8"%>

<%@ include file="include.jsp" %>

<%@ page import="com.ems.common.encrypt.AES256Util"%>

<%

String USERNAME="";

if(userinfo!=null){

	USERNAME = userinfo.getString("USERNAME");

	  String event = request.getParameter("event");
	  if (event == null) {
	      event = "find";
	  }


	  String P_CD_MEANING = request.getParameter("P_CD_MEANING")==null?"":request.getParameter("P_CD_MEANING");



	  int sessionHashCode = session.getId().hashCode();

	  DayMoney book = new DayMoney(application,request, userinfo, sessionHashCode);


	  EmsHashtable[] hash  = (EmsHashtable[])request.getAttribute("hash");



%>



<!DOCTYPE html>
<html lang="en">
  <head>
  <title><%=USERNAME %>예약리스트</title>
      <meta charset="utf-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
      <meta name="description" content="" />
      <meta name="author" content="" />

          <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>

       <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
       <script src="js/scripts.js"></script>
      <script src="https://code.jquery.com/jquery-3.5.1.js"></script>

      <SCRIPT >

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

    	  toastInit();

      	<%
      	String msg = request.getAttribute("msg")!=null?request.getAttribute("msg").toString():null;

      	if(msg!=null && msg.length()>0){
      	%>

      	var msgText="<%=msg%>";

        showMsg(msgText);

      	<%}%>


      	// 전체선택 체크박스 클릭
      	$("#allCheck").click(function(){ //만약 전체 선택
			// 체크박스가 체크된상태일경우
				if($("#allCheck").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다

				$("input[type=checkbox]").prop("checked",true);
				// 전체선택 체크박스가 해제된 경우
				} else {
					//해당화면에 모든 checkbox들의 체크를해제시킨다.
				 	$("input[type=checkbox]").prop("checked",false);
				}
      	});


      }	//init



      $(document).ready(function() {

      });


      </script>



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


input[type=text]
{
width: 100%;
display: inline;
}

table {
    width: 50%;
    border-top: 1px solid #444444;
    border-collapse: collapse;
  }
  th, td {
    border-bottom: 1px solid #444444;
    padding: 5px;
  }



 .msearch input {
	max-width: 100px;
	max-height: 25px;
}


/*
##Device = Most of the Smartphones Mobiles (Portrait)
##Screen = B/w 320px to 479px
##Device = 대부분의 스마트폰 모바일 기기(세로)
##Screen = 320px에서 479px 사이
*/

@media (min-width: 320px) and (max-width: 480px) {


.btn-sm, .btn-group-sm > .btn {
 padding: 0.15rem 0.15rem;
 font-size: 0.75rem;
 border-radius: 0.2rem;
}


table {
    width: 100%;
  }


}





</style>
  </head>

  <body class="sb-nav-fixed" onload ="init()" >

	<%@ include file="include_sb-topnav.jsp" %>

      <div id="layoutSidenav">

          <%@ include file="include_layoutSidenav_nav.jsp" %>

          <div id="layoutSidenav_content">
              <main>


<form name="frmMain" method="post" onsubmit="return false;"  >

<input type="hidden" name="event" value="" />



				<div class="container-fluid px-2 msearch">


				<div class="card mt-1" >
	                <div class="card-header">
<div class="row">

   <div class="col" >
   <label for="P_CD_MEANING">어종</label>
		<input type="text" id="P_CD_MEANING" name="P_CD_MEANING" value="<%=P_CD_MEANING%>"  >
   </div>


   <div class="col"  >
     <button type="button" class="btn btn-danger btn-sm"  onclick="setEvent('find');"> <i class="fas fa-undo"></i> 조회</button>
     <button type="button" class="btn btn-danger btn-sm"  onclick="setEvent('modify');"> <i class="fas fa-undo"></i> 수정</button>
   </div>

 </div><!-- row end -->


<div class="row">

   <div class="col-10">


   </div>


   <div class="col-2"  >

   </div>

 </div><!-- row end -->


	                </div>
				</div>


				</div>


                  <div class="container-fluid px-2" >


                      <div class="card mt-1" >

                        <!-- 달력시작 class="ui very compact table"  -->


                        <table >
                        			<% int idx=1; 	%>
                                    <thead>
                                        <tr >
							           <th data-priority="<%=idx++ %>" width="5%"><input type="checkbox" id="allCheck"  /></th>
							           <th data-priority="<%=idx++ %>" width="50%">어종</th>
							           <th data-priority="<%=idx++ %>" width="*">가격</th>
							       </tr>
                                    </thead>
                                    <tbody>
                                        <%
										if(hash!=null)
											for (int i = 0; i < hash.length; i++) {
									   %>

									       <tr >

									           <th ><input type="checkbox" id="chk" name="chk" value="<%=i%>"  >
									                  <input type="HIDDEN" name="PK_CD_ID" value="<%=hash[i].getString("CD_ID")%>"  ></th>
									           <td ><input type="text"  name="CD_MEANING" value="<%=hash[i].getString("CD_MEANING")%>"  ></td>
									           <td ><input type="text"  name="PRICE" 		   value="<%=hash[i].getString("PRICE")%>"  ></td>

											</tr>
									<%}%>

                                    </tbody>

                                </table>

                  </div>


                    </div><!-- container-fluid px-2 end -->

</form>

              </main>

              <%@ include file="include_footer.jsp" %>
          </div>
      </div>

<%@ include file="include_toast.jsp" %>




  </body>
</html>


<%
}else{    //LOGIN 정보가 없을때
%>

<jsp:include page="userinfo.jsp" flush="true"/>

<%} %>
