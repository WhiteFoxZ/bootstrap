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
.row > *{
border: 1px;
border:1px solid blue;
}
*/


.my_btn {

max-width: 140px;
width: 100%;
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


}


 .msearch {
     position: sticky;
     top: 50px;
     z-index: 1038;
 }


</style>
  </head>

  <body class="sb-nav-fixed" onload ="init()" >

	<%@ include file="include_sb-topnav.jsp" %>

      <div id="layoutSidenav">

          <%@ include file="include_layoutSidenav_nav.jsp" %>

          <div id="layoutSidenav_content">
              <main>


<form name="frmMain" method="post" >

<input type="hidden" name="event" value="" />
<input type="hidden" name="pk_key" value="" />
<input type="hidden" name="pk_pw" value="" />
<input type="hidden" name="rdate" value="<%=rdate %>" />

<div class="container-fluid px-2 msearch">


<div class="card mt-1" >
                          <div class="card-header">


<%if(ADMIN!=null && ADMIN.equals("true")){ %>


 <div class="row">

   <div class="col">
   <input type="date" id="P_SDATE" name="P_SDATE" value="<%=P_SDATE %>"   class="form-control"    onchange="commonWork()" style="max-width: 140px;">

   </div>

   <div class="col">
   <input type="date" id="P_EDATE" name="P_EDATE" value="<%=P_EDATE %>"   class="form-control"    onchange="commonWork()" style="max-width: 140px;">
   </div>



    <div class="col">
     <input type="text" id="P_NAME" name="P_NAME" value="<%=P_NAME %>"  class="form-control" style="max-width: 140px;" placeholder="이름" />
   </div>

   <div class="col"  >
     <button type="button" class="btn btn-danger btn-sm" style="margin-top: 1px;" onclick="setEvent('find');"> <i class="fas fa-undo"></i> 조회</button>
     <button type="button" class="btn btn-danger btn-sm" style="margin-top: 1px;" onclick="setEvent('modify');"> <i class="fas fa-undo"></i> 입금</button>
     <button type="button" class="btn btn-danger btn-sm" style="margin-top: 1px;" onclick="setEvent('delete');"> <i class="fas fa-undo"></i> 삭제</button>
   </div>

 </div><!-- row end -->

<%}else{//어드민이 아닐경우 %>

     <div class="row">
        <div class="col-md-6"><i class="fas fa-table me-1"></i><%=rdate %>&nbsp;<b style="color: red;">[<%=fishtype %>]</b>
        </div>
        <div class="col-md-6">
        ★자리위치사진 :

 <%for(int i=0; i<postion.length; i++){ %>

<a href="<%=postion[i].getString("CD_MEANING") %>" target="_blank" /><%=postion[i].getString("EXT1")%></a>&nbsp;
<%=i<postion.length-1?"|&nbsp;":""%>


 <%} %>
        </div>
    </div>

<%} %>


                          </div>
</div>


</div>


                  <div class="container-fluid px-2" >


                      <div class="card mt-1" >

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

           <a href="room_made.jsp?room_num=<%=hash[i].getString("CD_ID")%>&rdate=<%=rdate %>" class="btn btn-primary btn-sm my_btn" ><i class="fas fa-edit"></i> 예약</a>


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




                    </div><!-- container-fluid px-2 end -->

</form>

              </main>



              <%@ include file="include_footer.jsp" %>
          </div>
      </div>

<div id="ask-icon">
   문의하기
</div>

  </body>
</html>


<%
}else{    //LOGIN 정보가 없을때
%>

<jsp:include page="userinfo.jsp" flush="true"/>

<%} %>
