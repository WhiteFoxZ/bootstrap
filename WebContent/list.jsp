<%@ page pageEncoding="UTF-8"%>

<%@ include file="include.jsp"%>

<%@ page import="com.ems.common.encrypt.AES256Util"%>

<%
	String yyyy = EmsDateUtil.getCurrentDate("yyyy");

	if (userinfo != null) {

		String USERNAME = userinfo.getString("USERNAME");

		StringBuffer serverURL = new StringBuffer("http://").append(request.getServerName()).append(":")
				.append(request.getServerPort()).append("/").append(request.getContextPath());

		String TO_DAY = EmsDateUtil.getCurrentDate("yyyy-MM-dd");

		String room_num = request.getParameter("rdate") != null ? request.getParameter("rdate").toString() : "";
		String rdate = request.getParameter("rdate") != null
				? request.getParameter("rdate").toString()
				: TO_DAY;

		String P_SDATE = request.getParameter("P_SDATE");
		String P_EDATE = request.getParameter("P_EDATE");
		String P_NAME = request.getParameter("P_NAME");

		if (P_NAME == null)
			P_NAME = "";

		if (P_SDATE == null) {
			if (rdate != null)
				P_SDATE = rdate;
		}

		if (P_EDATE == null) {
			if (rdate != null)
				P_EDATE = rdate;
		}

		String event = request.getParameter("event");
		if (event == null) {
			event = "find";
		}

		int sessionHashCode = session.getId().hashCode();

		new LIST(application, request, userinfo, sessionHashCode);

		EmsHashtable[] hash = (EmsHashtable[]) request.getAttribute("hash");

		DataSource ds = (DataSource) application.getAttribute("jdbc/mysql_ds");

		DBManager dbm = new DBManager(ds);

		String LOGINID = userinfo.getString("LOGINID");

		//어종
		EmsHashtable[] fish = dbm.selectMultipleRecord(
				"SELECT EXT1 AS FISH_TYPE, case when EXT2='' then 0 else ifnull(EXT2,0) end AS MAN FROM comm_info INFO where INFO.CD_GROUP_ID='FISH_TYPE' AND INFO.LOGIN_ID=? AND CD_MEANING =? ",
				new String[]{LOGINID, rdate.replaceAll("-", "")});

		String fishtype = "";
		String fishman = "";
		int intMan = 0;

		if (fish != null && fish.length > 0) {
			fishtype = fish[0].getString("FISH_TYPE");
			fishman = fish[0].getString("MAN");
			intMan = Integer.parseInt(fishman);

		}

		//배위치사진
		EmsHashtable[] postion = dbm.selectMultipleRecord(
				"SELECT CD_MEANING , EXT1  FROM comm_info INFO where INFO.CD_GROUP_ID='SHIP_POSTION' AND INFO.LOGIN_ID=?  ",
				new String[]{LOGINID});

		AES256Util aes = new AES256Util("asdwsx1031902461");

		String perid = null;
%>



<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title>예약조회</title>

<link href="css/styles.css" rel="stylesheet" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"
	crossorigin="anonymous"></script>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js"
	crossorigin="anonymous"></script>
<script src="js/scripts.js"></script>



<!-- tableMobilize-->
<link href="demo/css/theme-default.min.css" rel="stylesheet" />
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script src="demo/js/jquery.tableMobilize.min.js"></script>

<SCRIPT>

          function setEvent(event){

        	  if(event=="delete"){

        		  //$('input:checkbox[id="chk"]').attr("checked", true);	테스트

        		  $('input:checkbox[id="chk"]').each(function() {
        	       if ($(this).is(":checked")) {

        	    	   if($(this).data("pk-value")==null){

        	    		   $(this).attr("checked", false);
        	    		   console.log("pk-value=null" );

        	    		}else{
        	    			 $(this).attr("checked", false);
        	    			console.log("pk-value=" + $(this).data("pk-value") );

        	    		}


        	       }
        	    });
        	  }


              document.frmMain.event.value=event;
              document.frmMain.submit();

          }

	function init(){

		$('#datatablesSimple').tableMobilize();

	<%
	String msg = request.getAttribute("msg") != null ? request.getAttribute("msg").toString() : null;
	if (msg != null && msg.length() > 0) {
	%>
	var msgText="<%=msg%>";

	//showMsg(msgText);
	<%}%>

	}

	function cancel(pk, idx) {

		var pw = $("#PASSWD" + idx).val();

		if (pw == "") {

			showMsg('취소시 PW에 전화번호를 넣어주세요.');
			return false;

		}

		//alert('취소합니다.');

		document.frmMain.pk_key.value = pk;
		document.frmMain.pk_pw.value = pw;

		setEvent('deletePK');
		return false;

	}

	$(document).ready(function() {

		//toastInit();

	});


</script>



<style>
@font-face {
	font-family: 'Youth';
	font-style: normal;
	font-weight: 400;
	src:
		url('//cdn.jsdelivr.net/korean-webfonts/1/orgs/othrs/kywa/Youth/Youth.woff2')
		format('woff2'),
		url('//cdn.jsdelivr.net/korean-webfonts/1/orgs/othrs/kywa/Youth/Youth.woff')
		format('woff');
}

body {
	font-family: 'Youth';
}

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

.form-control {
	font-size: 0.7em;
	margin-top: 1px;
}

/*
.row > *{
border: 1px;
border:1px solid blue;
}
*/

/*
##Device = Most of the Smartphones Mobiles (Portrait)
##Screen = B/w 320px to 479px
##Device = 대부분의 스마트폰 모바일 기기(세로)
##Screen = 320px에서 479px 사이
*/
@media ( min-width : 320px) and (max-width: 480px) {
	.btn-sm, .btn-group-sm>.btn {
		padding: 0.15rem 0.15rem;
		font-size: 0.75rem;
		border-radius: 0.2rem;
	}
	.my_btn {
		width: 100%;
		max-width: 100%;
	}
	.msearch input, select {
		min-width: 140px;
		max-width: 140px;
		max-height: 25px;
	}
	.msearch  label {
		display: none;
	}
	.msearch  button {
		min-width: 100px;
		margin-top: 3px;
	}
}
</style>
</head>

<body class="sb-nav-fixed" onload="init()">

	<%@ include file="include_sb-topnav.jsp"%>

	<div id="layoutSidenav">

		<%@ include file="include_layoutSidenav_nav.jsp"%>

		<div id="layoutSidenav_content">
			<main>

				<form name="frmMain" method="post">

					<input type="hidden" name="event" value="" /> <input type="hidden"
						name="pk_key" value="" /> <input type="hidden" name="pk_pw"
						value="" /> <input type="hidden" name="rdate" value="<%=rdate%>" />

					<div class="container-fluid px-2 msearch">

						<div class="card mt-1">
							<div class="card-header">
							<div class="row">
							<%if(ADMIN!=null && ADMIN.equals("true")){ %>


							   <div class="col-sm-6">
							   <label for="P_SDATE">예약일</label>
							   <input type="date" id="P_SDATE" name="P_SDATE" value="<%=P_SDATE %>"       onchange="commonWork()" >
							 ~ <input type="date" id="P_EDATE" name="P_EDATE" value="<%=P_EDATE %>"      onchange="commonWork()" >
							   </div>

							   <div class="col-sm-2"  >
							   	<input type="text" id="P_NAME" name="P_NAME" value="<%=P_NAME %>"   placeholder="이름" />
							   </div>

							   <div class="col-sm-4"  >

							     <button type="button" class="btn btn-danger btn-sm" onclick="setEvent('find');"> <i class="fas fa-undo"></i> 조회</button>
							     <button type="button" class="btn btn-danger btn-sm" onclick="setEvent('modify');"> <i class="fas fa-undo"></i> 입금</button>
							     <button type="button" class="btn btn-danger btn-sm" onclick="setEvent('delete');"> <i class="fas fa-undo"></i> 삭제</button>
							   </div>

							<%}else{//어드민이 아닐경우 %>
							        <div class="col-md-6"><i class="fas fa-table me-1"></i><%=rdate %>&nbsp;<b style="color: red;">[<%=fishtype %>]</b>
							        </div>
							        <div class="col-md-6">★자리위치사진 :
							 		<%for(int i=0; i<postion.length; i++){ %>
										<a href="<%=postion[i].getString("CD_MEANING") %>" target="_blank" /><%=postion[i].getString("EXT1")%></a>&nbsp;
									<%=i<postion.length-1?"|&nbsp;":""%>
							 		<%} // for(%>
							        </div>
							    </div><!-- row -->
							<%} %>

							</div><!--card-header-->
						</div>

						<div class="card-body2">
							<%@ include file="include_toast.jsp"%>
						</div>

					</div>


					<div class="container-fluid px-2">

						<div class="card mt-1">
							<table id="datatablesSimple" class="tableMobilize table-striped"	style="width: 100%">
								<thead>
									<tr>
									<%
									int idx=1;
									if(ADMIN!=null && ADMIN.equals("true")){ %>
										<th data-priority="<%=idx++ %>">▼</th>
										<th data-priority="<%=idx++ %>">No</th>
										<th data-priority="<%=idx++ %>">등록일</th>
										<th data-priority="<%=idx++ %>">이름</th>
										<th data-priority="<%=idx++ %>">전화</th>
										<th data-priority="<%=idx++ %>">기간</th>
										<th data-priority="<%=idx++ %>">금액</th>
										<th data-priority="<%=idx++ %>" width="20%">메모</th>
										<th data-priority="<%=idx++ %>">상태</th>
										<th data-priority="<%=idx++ %>" width="20%">버튼</th>
										<%}else{ %>
										<th data-priority="<%=idx++ %>">No</th>
										<th data-priority="<%=idx++ %>">이름</th>
										<th data-priority="<%=idx++ %>">전화</th>
										<th data-priority="<%=idx++ %>">기간</th>
										<th data-priority="<%=idx++ %>">상태</th>
										<!-- <th data-priority="<%=idx++ %>">PW</th> -->
										<th data-priority="<%=idx++%>" width="20%">버튼</th>
										<%
											}
										%>
									</tr>
								</thead>

								<tbody>

							   <%
							   if(hash!=null){

							       String USER_TEL1="";

							       for (int i = 0; i < hash.length && i<intMan ;  i++) {
							           if(hash[i].getString("USER_TEL1").length()>0){
							               USER_TEL1 = aes.decrypt( hash[i].getString("USER_TEL1") );
							           }else{
							               USER_TEL1="";
							           }
								%>

								<tr >
								<%
								if(ADMIN!=null && ADMIN.equals("true")){ //어드민일경우
								%>
								           <td><input type="checkbox" id="chk" name="chk" value="<%=i%>" data-role="none" data-pk-value="<%=hash[i].getString("GROUP_KEY")%>" >        </td>
								           <td><%=EmsNumberUtil.format(hash[i].getString("CD_ID"), "00")%><%=hash[i].getString("EXT1")%></td>
								           <td ><%=hash[i].getString("CREATION_TIMESTAMP")%></td>

								           <td><%=hash[i].getString("USER_NAME")%></td>
								           <td><%=USER_TEL1%></td>
								           <td>
								           <%
								                   if(hash[i].getString("GROUP_KEY").length()>17){
								                       perid = hash[i].getString("GROUP_KEY").substring(0,17);
								                       out.println(perid.replaceAll(yyyy, ""));
								                   }
								           %>
								           <input type="hidden" id="PK_GROUP_KEY" name="PK_GROUP_KEY" value="<%=hash[i].getString("GROUP_KEY")%>" >
								           </td>
								           <td>
											   <%if(hash[i].getString("PRICE_DESC").length()>0){ %>
											    <a href="#POP_PRICE_DESC<%=i%>" data-bs-toggle="modal" data-bs-target="#POP_PRICE_DESC<%=i%>" ><%=hash[i].getString("TOTAL_PAY")%></a>
											    <%}else{ %>
											    <%=hash[i].getString("TOTAL_PAY")%>
											    <%} %>

												<!-- Modal 관리자 금액상세-->
												<div class="modal fade" id="POP_PRICE_DESC<%=i%>" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
												 <div class="modal-dialog">
												   <div class="modal-content">
												     <div class="modal-header">
												       <h5 class="modal-title" id="exampleModalLabel">금액</h5>
												       <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
												     </div>
												     <div class="modal-body">
												         <div class="form-group form-group-xs">
												              <div class="col-xs-12"><%=hash[i].getString("PRICE_DESC")%></div>
												          </div>
												     </div>
												     <div class="modal-footer">
												       <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
												     </div>
												   </div>
												 </div>
												</div>
								           </td>

								           <td  data-toggle="tooltip" data-placement="top" title="<%=hash[i].getString("MEMO")%>"><%=hash[i].getString("MEMO")%></td>

								           <td><%=hash[i].getString("RESERVE_STATE_NAME")%></td>

								           <th>
								           <%
								           		if(fishtype.equals("") ){%>어종을 설정하세요.
									           <%}else if(hash[i].getString("RESERVE_STATE").equals("")) {%>
									           <a href="room_made.jsp?room_num=<%=hash[i].getString("CD_ID")%>&rdate=<%=rdate %>" class="btn btn-primary btn-sm my_btn" ><i class="fas fa-edit"></i> 예약</a>
									           <%} %>
								           </th>

								<%}else{ //일반유저%>
								           <td><%=EmsNumberUtil.format(hash[i].getString("CD_ID"), "00") %><%=hash[i].getString("EXT1")%></td>
								           <td><%
								                   if(hash[i].getString("USER_NAME").length()>2){
								                       out.println("*"+hash[i].getString("USER_NAME").substring(1,2)+"*");
								                   }else if(hash[i].getString("USER_NAME").length()==2){
								                       out.println("*"+hash[i].getString("USER_NAME").substring(1));
								                   }
								               %>
								           </td>
								           <td>
									           <%
									           String tel[] =USER_TEL1.split("-") ;
									           if(tel.length==3){	               out.println(tel[0] +"-****-"+tel[2]);
									           }else {out.println(!USER_TEL1.equals("")?aes.maskify(USER_TEL1):"");}
									           %>
								           </td>
								           <td>
								           <%
								                   if(hash[i].getString("GROUP_KEY").length()>17){
								                       perid = hash[i].getString("GROUP_KEY").substring(0,17);
								                       out.println(perid.replaceAll(yyyy, ""));
								                   }
								           %>
								           </td>
								           <td><%=hash[i].getString("RESERVE_STATE_NAME")%></td>

								           <th>
								           <% if(hash[i].getString("RESERVE_STATE").equals("") && !fishtype.equals("") ){%>
								           <a href="room_made.jsp?room_num=<%=hash[i].getString("CD_ID")%>&rdate=<%=rdate %>" class="btn btn-primary btn-sm" style="width: 100%" ><i class="fas fa-edit"></i> 예약</a>

								           <%}else if(hash[i].getString("RESERVE_STATE").equals("1")) { %>

								           <button type="button" class="btn btn-danger btn-sm" style="width: 100%" data-bs-toggle="modal" data-bs-target="#passwdPOP<%=i%>"> <i class="fas fa-undo"></i> 취소</button>

											<!-- Modal 일반유저 passwdPOP-->

											<div class="modal fade" id="passwdPOP<%=i%>" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
											 <div class="modal-dialog">
											   <div class="modal-content">
											     <div class="modal-header">
											       <h5 class="modal-title" id="exampleModalLabel">예약취소</h5>
											       <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
											     </div>
											     <div class="modal-body">
											         <div class="form-group form-group-xs">
											              <div class="col-xs-12"><input type="text" class="form-control" id="PASSWD<%=i%>" name="PASSWD<%=i%>" placeholder="전화번호"></div>
											          </div>
											     </div>
											     <div class="modal-footer">
											       <button type="button" class="btn  btn-primary btn-sm" data-bs-dismiss="modal"><i class="fas fa-edit"></i>닫기</button>
											       <button type="button" class="btn btn-danger btn-sm" onclick="cancel('<%=hash[i].getString("GROUP_KEY")%>','<%=i%>')" ><i class="fas fa-edit"></i>취소</button>

											     </div>
											   </div>
											 </div>
											</div>

								           <%}else{ %>
								           &nbsp;
								           <%} %>
								           </th>

								<%}//일반유저 end%>
								       </tr>
								   <%
								   		}    //end of for

								   }	//if(hash=null)
								%>


								</tbody>
							</table>

						</div>



					</div>
					<!-- container-fluid px-2 end -->


				</form>
			</main>



			<%@ include file="include_footer.jsp"%>
		</div>
	</div>

</body>
</html>


<%
	} else { //LOGIN 정보가 없을때
%>

<jsp:include page="userinfo.jsp" flush="true" />

<%
	}
%>
