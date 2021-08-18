<%@ page   pageEncoding="UTF-8"%>

<%@ include file="include.jsp" %>

<%@ page import="com.ems.common.encrypt.AES256Util"%>

<%


String yyyy = EmsDateUtil.getCurrentDate("yyyy");

if(userinfo!=null){

    String USERNAME = userinfo.getString("USERNAME");

   StringBuffer serverURL = new StringBuffer("http://").append(request.getServerName()).append(":").append(request.getServerPort()).append("/").append(request.getContextPath());


   String TO_DAY = EmsDateUtil.getCurrentDate("yyyy-MM-dd");




   String room_num=request.getParameter("rdate")!=null?request.getParameter("rdate").toString():"";
   String rdate=request.getParameter("rdate")!=null?request.getParameter("rdate").toString():TO_DAY;

   String P_SDATE = request.getParameter("P_SDATE");
   String P_EDATE = request.getParameter("P_EDATE");
   String P_NAME = request.getParameter("P_NAME");

   if(P_NAME==null) P_NAME="";




   if(P_SDATE==null){
       if(rdate!=null)    P_SDATE = rdate;
   }

   if(P_EDATE==null){
       if(rdate!=null)    P_EDATE=rdate;
   }


   String event = request.getParameter("event");
   if (event == null) {
       event = "find";
   }

   int sessionHashCode = session.getId().hashCode();

   new LIST(application,request, userinfo, sessionHashCode);


   EmsHashtable[] hash  = (EmsHashtable[])request.getAttribute("hash");


   DataSource ds = (DataSource)application.getAttribute("jdbc/mysql_ds");

   DBManager dbm = new DBManager(ds);


   String LOGINID = userinfo.getString("LOGINID");


   //어종
   EmsHashtable[] fish = dbm.selectMultipleRecord("SELECT EXT1 AS FISH_TYPE, case when EXT2='' then 0 else ifnull(EXT2,0) end AS MAN FROM comm_info INFO where INFO.CD_GROUP_ID='FISH_TYPE' AND INFO.LOGIN_ID=? AND CD_MEANING =? ",
           new String[] { LOGINID ,rdate.replaceAll("-", "") });

   String fishtype="";
   String fishman="";
   int intMan=0;



   if(fish!=null&& fish.length>0){
       fishtype=fish[0].getString("FISH_TYPE");
       fishman=fish[0].getString("MAN");
       intMan = Integer.parseInt(fishman);

   }

   //배위치사진
   EmsHashtable[] postion = dbm.selectMultipleRecord("SELECT CD_MEANING , EXT1  FROM comm_info INFO where INFO.CD_GROUP_ID='SHIP_POSTION' AND INFO.LOGIN_ID=?  ",
           new String[] { LOGINID });


    AES256Util aes = new AES256Util("asdwsx1031902461");


   String perid=null;


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



		<!-- tableMobilize-->
       <link href="demo/css/theme-default.min.css" rel="stylesheet" />
       <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
	   <script src="demo/js/jquery.tableMobilize.min.js"></script>



<link type="text/css" href="./jquery/css/ui.all.css" rel="stylesheet" />
<script src="https://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>

<script type="text/javascript">
$(function() {

    $.datepicker.setDefaults({
        monthNames: ['년 1월','년 2월','년 3월','년 4월','년 5월','년 6월','년 7월','년 8월','년 9월','년 10월','년 11월','년 12월'],
        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
        showMonthAfterYear:true,
        dateFormat: 'yy-mm-dd',
        showOn: 'both',
        buttonImage: './jquery/ic_03.gif',
        buttonImageOnly: true

    });
    $("#P_SDATE").datepicker({
        buttonText: '시작일',
        showButtonPanel:true


    });
    $("#P_EDATE").datepicker({
        buttonText: '종료일',
        showButtonPanel:true
    });
});

function commonWork() {
    var stdt = document.getElementById("P_SDATE");
    var endt = document.getElementById("P_EDATE");

    if(endt.value != '' && stdt.value > endt.value) {
        alert("종료일이 시작일보다 빠릅니다.\n\n다시 입력해 주십시오.");
        stdt.value = "";
        endt.value = "";
        stdt.focus();
    }
}
</script>
<style type="text/css">
    .ui-datepicker-trigger {
        vertical-align: middle;
        cursor: pointer;
        border-width:1px; background-color:#E9F3FE; border-color:#404040;font:12px;text-align: left; padding-left:2px;

    }

</style>

<!-- 달력관련끝 -->



       <SCRIPT >

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


               var timer = setTimeout(hideMsg, 1000);

               <%}%>

               $('#datatablesSimple').tableMobilize();


               $('.datepicker').datepicker();



           }



           function hideMsg(){
               $.mobile.loading( "hide" );
           }

           function cancel(pk,idx){

               var pw = $("#PASSWD"+idx).val();

               if(pw==""){

                   alert('취소시 PW에 전화번호를 넣어주세요.');
                   return false;

               }

               //alert('취소합니다.');

               document.frmMain.pk_key.value=pk;
               document.frmMain.pk_pw.value=pw;


               setEvent('deletePK');
               return false;

           }


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

}

</style>
   </head>
   <body class="sb-nav-fixed" onload ="init()" >
       <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
           <!-- Navbar Brand-->
           <a class="navbar-brand ps-3" href="index.html">Start Bootstrap</a>
           <!-- Sidebar Toggle-->
           <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
           <!-- Navbar Search-->
           <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
               <div class="input-group">
                   <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
                   <button class="btn btn-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
               </div>
           </form>
           <!-- Navbar-->
           <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
               <li class="nav-item dropdown">
                   <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                   <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                       <li><a class="dropdown-item" href="#!">Settings</a></li>
                       <li><a class="dropdown-item" href="#!">Activity Log</a></li>
                       <li><hr class="dropdown-divider" /></li>
                       <li><a class="dropdown-item" href="#!">Logout</a></li>
                   </ul>
               </li>
           </ul>
       </nav>
       <div id="layoutSidenav">
           <div id="layoutSidenav_nav">
               <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                   <div class="sb-sidenav-menu">
                       <div class="nav">
                           <div class="sb-sidenav-menu-heading">Core</div>
                           <a class="nav-link" href="index.html">
                               <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                               Dashboard
                           </a>
                           <div class="sb-sidenav-menu-heading">Interface</div>
                           <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                               <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>
                               Layouts
                               <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                           </a>
                           <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
                               <nav class="sb-sidenav-menu-nested nav">
                                   <a class="nav-link" href="layout-static.html">Static Navigation</a>
                                   <a class="nav-link" href="layout-sidenav-light.html">Light Sidenav</a>
                               </nav>
                           </div>
                           <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages" aria-expanded="false" aria-controls="collapsePages">
                               <div class="sb-nav-link-icon"><i class="fas fa-book-open"></i></div>
                               Pages
                               <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                           </a>
                           <div class="collapse" id="collapsePages" aria-labelledby="headingTwo" data-bs-parent="#sidenavAccordion">
                               <nav class="sb-sidenav-menu-nested nav accordion" id="sidenavAccordionPages">
                                   <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#pagesCollapseAuth" aria-expanded="false" aria-controls="pagesCollapseAuth">
                                       Authentication
                                       <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                                   </a>
                                   <div class="collapse" id="pagesCollapseAuth" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordionPages">
                                       <nav class="sb-sidenav-menu-nested nav">
                                           <a class="nav-link" href="login.html">Login</a>
                                           <a class="nav-link" href="register.html">Register</a>
                                           <a class="nav-link" href="password.html">Forgot Password</a>
                                       </nav>
                                   </div>
                                   <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#pagesCollapseError" aria-expanded="false" aria-controls="pagesCollapseError">
                                       Error
                                       <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                                   </a>
                                   <div class="collapse" id="pagesCollapseError" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordionPages">
                                       <nav class="sb-sidenav-menu-nested nav">
                                           <a class="nav-link" href="401.html">401 Page</a>
                                           <a class="nav-link" href="404.html">404 Page</a>
                                           <a class="nav-link" href="500.html">500 Page</a>
                                       </nav>
                                   </div>
                               </nav>
                           </div>
                           <div class="sb-sidenav-menu-heading">Addons</div>
                           <a class="nav-link" href="charts.html">
                               <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                               Charts
                           </a>
                           <a class="nav-link" href="tables.html">
                               <div class="sb-nav-link-icon"><i class="fas fa-table"></i></div>
                               Tables
                           </a>
                       </div>
                   </div>
                   <div class="sb-sidenav-footer">
                       <div class="small">Logged in as:</div>
                       Start Bootstrap
                   </div>
               </nav>
           </div>
           <div id="layoutSidenav_content">
               <main>
                   <div class="container-fluid px-2" >



                       <div class="card mt-1 " >
                           <div class="card-header">


<form>

  <div class="row">

    <div class="col">
    <input type="date" id="date2" class="form-control" style="max-width: 140px;">
    </div>
    <div class="col">
      <input type="date" id="date2" class="form-control" style="max-width: 140px;">
    </div>

 <div class="col">
      <input type="text" class="form-control" placeholder="First name" style="max-width: 140px;">
    </div>

    <div class="col"  >
      <button type="button" class="btn btn-danger btn-sm" style="margin-top: 1px;" > <i class="fas fa-undo"></i> 조회</button>
      <button type="button" class="btn btn-danger btn-sm" style="margin-top: 1px;" > <i class="fas fa-undo"></i> 입금</button>
      <button type="button" class="btn btn-danger btn-sm" style="margin-top: 1px;" > <i class="fas fa-undo"></i> 삭제</button>

    </div>

  </div>

  <div class="row">


  </div>

</form>



                           </div>


                           <div class="card-body2">


                           </div>
                       </div>


                         <!-- 달력시작 class="ui very compact table"  -->

                           <table  id="datatablesSimple"  class="tableMobilize table-striped" style="width: 100%">

<thead>
        <tr >
<%
int idx=1;
if(ADMIN!=null && ADMIN.equals("true")){ %>
            <th data-priority="<%=idx++ %>">▼</th>
            <th data-priority="<%=idx++ %>">No</th>
            <th data-priority="<%=idx++ %>">등록일</th>
            <th data-priority="<%=idx++ %>">이름</th>
            <th data-priority="<%=idx++ %>">전화</th>
            <!-- <th data-priority="<%=idx++ %>">차량</th> -->
            <th data-priority="<%=idx++ %>">기간</th>
            <th data-priority="<%=idx++ %>">금액</th>
            <th data-priority="<%=idx++ %>">메모</th>
            <th data-priority="<%=idx++ %>">상태</th>
            <th data-priority="<%=idx++ %>" width="20%">버튼</th>
<%}else{ %>
            <th data-priority="<%=idx++ %>">No</th>
            <th data-priority="<%=idx++ %>">이름</th>
            <th data-priority="<%=idx++ %>">전화</th>
            <th data-priority="<%=idx++ %>">기간</th>
            <th data-priority="<%=idx++ %>">상태</th>
            <!-- <th data-priority="<%=idx++ %>">PW</th> -->
            <th data-priority="<%=idx++ %>" width="20%">버튼</th>
<%}%>
        </tr>
    </thead>

    <tbody >
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
<% //어드민일경우
if(ADMIN!=null && ADMIN.equals("true")){ %>


            <td><input type="checkbox" id="chk" name="chk" value="<%=i%>" data-role="none"  >        </td>
            <td><%=EmsNumberUtil.format(hash[i].getString("CD_ID"), "00")%><%=hash[i].getString("EXT1")%></td>
            <td ><%=hash[i].getString("CREATION_TIMESTAMP")%></td>

            <td><%=hash[i].getString("USER_NAME")%></td>
            <td><%=USER_TEL1%></td>
             <!--
            <td>
                <%=hash[i].getString("CAR_NUM")%>
            </td>
             -->

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
     <a href="#POP_PRICE_DESC<%=i%>" data-bs-toggle="modal" data-bs-target="#POP_PRICE_DESC<%=i%>" >
     <%=hash[i].getString("TOTAL_PAY")%>
     </a>
     <%}else{ %>
     <%=hash[i].getString("TOTAL_PAY")%>
     <%} %>


<!-- Modal -->

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
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>

      </div>
    </div>
  </div>
</div>


            </td>

            <td class="">
     <%

     if(hash[i].getString("MEMO").length()>0){
     %>

       <button type="button" class="btn btn-danger btn-sm" style="width: 100%" data-bs-toggle="modal" data-bs-target="#POP_MENO<%=i%>"> <i class="fas fa-undo"></i> 클릭</button>

<!-- Modal -->

<div class="modal fade" id="passwdPOP<%=i%>" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
          <div class="form-group form-group-xs">
			  <div class="col-xs-12"><pre class="pre_con"><%=hash[i].getString("MEMO")%></pre></div>
		  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary btn-sm" onclick="cancel('<%=hash[i].getString("GROUP_KEY")%>','<%=i%>')" ><i class="fas fa-edit"></i>취소</button>

      </div>
    </div>
  </div>
</div>


     <%}else{%>

     <%}%>
            </td>

            <td><%=hash[i].getString("RESERVE_STATE_NAME")%></td>
            <th>
            <%

            if(fishtype.equals("") ){%>
            어종을 설정하세요.
            <%}else if(hash[i].getString("RESERVE_STATE").equals("")) {%>

            <a href="room_made.jsp?room_num=<%=hash[i].getString("CD_ID")%>&rdate=<%=rdate %>" class="btn btn-primary btn-sm" ><i class="fas fa-edit"></i> 예약</a>

            <!-- <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#passwdPOP<%=i%>"> <i class="fas fa-undo"></i> 삭제</button>
             -->

            <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#passwdPOP<%=i%>"> <i class="fas fa-undo"></i> 확정</button>



            <%} %>

            </th>
<%}else{ %>
            <!-- 일반유저 -->
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

            if(tel.length==3)
                out.println(tel[0] +"-****-"+tel[2]);
            else
                out.println(!USER_TEL1.equals("")?aes.maskify(USER_TEL1):"");

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
            <!--
            <td></td>
            -->

            <th>
            <% if(hash[i].getString("RESERVE_STATE").equals("") && !fishtype.equals("") ){%>
            <a href="room_made.jsp?room_num=<%=hash[i].getString("CD_ID")%>&rdate=<%=rdate %>" class="btn btn-primary btn-sm" style="width: 100%" ><i class="fas fa-edit"></i> 예약</a>

            <%}else if(hash[i].getString("RESERVE_STATE").equals("1")) { %>

            <button type="button" class="btn btn-danger btn-sm" style="width: 100%" data-bs-toggle="modal" data-bs-target="#passwdPOP<%=i%>"> <i class="fas fa-undo"></i> 취소</button>




<!-- Modal -->

<div class="modal fade" id="passwdPOP<%=i%>" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
          <div class="form-group form-group-xs">
			  <div class="col-xs-12"><input type="text" class="form-control" id="PASSWD<%=i%>" name="PASSWD<%=i%>" placeholder="전화번호"></div>
		  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary btn-sm" onclick="cancel('<%=hash[i].getString("GROUP_KEY")%>','<%=i%>')" ><i class="fas fa-edit"></i>취소</button>

      </div>
    </div>
  </div>
</div>

            <%}else{ %>
            &nbsp;
            <%} %>
            </th>
<%}%>
        </tr>
    <%    }    //end of for

    }%>
    </tbody>


                             </table>






                   </div>






               </main>
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