<%@ page   pageEncoding="UTF-8"%>

<%@ include file="include.jsp" %>

<%@ page import="com.ems.common.encrypt.AES256Util"%>

<%



if(userinfo!=null){

  String USERNAME = userinfo.getString("USERNAME");
  String LOGINID = userinfo.getString("LOGINID");

  String event = request.getParameter("event");
  if (event == null) {
      event = "find";
  }

	String  yyyyMM =  EmsDateUtil.getCurrentDate("yyyyMM");

  String P_CD_MEANING = request.getParameter("P_CD_MEANING")==null?yyyyMM:request.getParameter("P_CD_MEANING");



  int sessionHashCode = session.getId().hashCode();

  FishType book = new FishType(application,request, userinfo, sessionHashCode);


  EmsHashtable[] hash  = (EmsHashtable[])request.getAttribute("hash");


  DataSource ds = (DataSource)application.getAttribute("jdbc/mysql_ds");

  DBManager dbm = new DBManager(ds);

  //어종명 lov 가져오기
  EmsHashtable[] hash2 =
  dbm.selectMultipleRecord("SELECT CD_MEANING FROM comm_info where LOGIN_ID=? and CD_GROUP_ID='DAY_MONEY' and PRICE>0 ORDER BY SORT_SEQ",
    		new String[] {LOGINID });



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
      <title>Dashboard - SB Admin</title>

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




      	$("[id^='lovFishType_']").on('change', function() {

              var text = this.value;

          	var rownum = $( this ).data( "rownum" );

          	var extName = "#EXT1_"+rownum;

          	//alert(extName +' : '+text);

      		$(extName).val(text);

          });


      	$("#lovPersonAll").on('change', function() {

              var text = this.value;

              $("[id^='chk']").each (function (index, el) {

              	if($(this).prop("checked")){

              		var extName = "#EXT2_"+index;

              		$(extName).val(text);

              	}
              });



      	});	//lovFishTypeAll


      	$("#lovFishTypeAll").on('change', function() {

              var text = this.value;


              $("[id^='chk']").each (function (index, el) {

              	if($(this).prop("checked")){

              		var extName = "#EXT1_"+index;

              		$(extName).val(text);

              	}
              });


      	});	//lovFishTypeAll


      	//조회 년월일 lov
      	$("#lovDay").on('change', function() {

              var text = this.value;

          	var extName = "#P_CD_MEANING";

      		$(extName).val(text);
      	}); //lovDay end



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



.my_btn {

max-width: 140px;
width: 100%;
}

input[type=text]
{
width: 100%;
max-width:70px;
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
.my_btn {

width: 100%;
max-width: 100%;
}


table {
    width: 100%;
  }


}


 .msearch {
     position: sticky;
     top: 50px;
     z-index: 1038;
 }



</style>
  </head>

  <body class="sb-nav-fixed" onload ="init()" >

	<%@ include file="include_sb-topnav.html" %>

      <div id="layoutSidenav">

          <%@ include file="include_layoutSidenav_nav.html" %>

          <div id="layoutSidenav_content">
              <main>


<form name="frmMain" method="post" onsubmit="return false;"  >

<input type="hidden" name="event" value="" />



				<div class="container-fluid px-2 msearch">


				<div class="card mt-1" >
	                <div class="card-header">
<div class="row">

   <div class="col-8" style="padding-left: 0px;    padding-right: 0px;">년월 :
		<input type="text" id="P_CD_MEANING" name="P_CD_MEANING" value="<%=P_CD_MEANING%>"  >

			<select ID="lovDay"      >

			<option value="">선택</option>

			<%
			  String nowway = EmsDateUtil.getCurrentDate("yyyyMM01");

			  String date;
			  for(int i=-1; i<=6; i++){
				  date = EmsDateUtil.addMonths(nowway, i, "yyyyMMdd");
%>
				<option value="<%=EmsDateUtil.getCurrentDate("yyyyMM", date)%>">
				<%=EmsDateUtil.getCurrentDate("yy.MM", date) %></option>
<%
			  }
%>

			</select>

   </div>


   <div class="col-4" style="padding-left: 0px;    padding-right: 0px;" >
     <button type="button" class="btn btn-danger btn-sm" style="margin-top: 1px;" onclick="setEvent('find');"> <i class="fas fa-undo"></i> 조회</button>
     <button type="button" class="btn btn-danger btn-sm" style="margin-top: 1px;" onclick="setEvent('modify');"> <i class="fas fa-undo"></i> 수정</button>
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
                                    <thead>
                                        <tr >
							<%
							int idx=1;
							%>
							           <th data-priority="<%=idx++ %>" width="5%"><input type="checkbox" id="allCheck"  /></th>
							           <th data-priority="<%=idx++ %>" width="10%">날짜</th>
							           <th data-priority="<%=idx++ %>" width="*">
										<select ID="lovFishTypeAll" style="width: 90%; max-width: 160px;" >

										<option value="">어종</option>

										<%=EmsOption.getOption(hash2,"CD_MEANING","CD_MEANING","") %>

										</select>
										</th>
							           <th data-priority="<%=idx++ %>" width="10%">

							<%
							String key    ="0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20";
							String value ="0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20";
							%>

										<select ID="lovPersonAll"    >
										<option value="">승선</option>
										<%=EmsOption.getOption(key,value,"") %>
										</select>

									</th>


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
									           <td ><%=hash[i].getString("FISH_DAY")%></td>
									           <td >
									           			<input type="text" id="EXT1_<%=i %>" name="EXT1"   value="<%=hash[i].getString("EXT1")%>"  >
														<select ID="lovFishType_<%=i %>" data-rownum="<%=i %>"   >
														<option value="">선택하세요</option>
														<%=EmsOption.getOption(hash2,"CD_MEANING","CD_MEANING","") %>
														<option value="선박수리">선박수리</option>
														</select>
												</td>

									           <td ><input type="text" id="EXT2_<%=i %>" name="EXT2" value="<%=hash[i].getString("EXT2")%>"  ></td>

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
