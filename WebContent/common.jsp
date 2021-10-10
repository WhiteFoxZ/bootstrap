<%@ page   pageEncoding="UTF-8"%>

<%@ include file="include.jsp" %>

<%@ page import="com.ems.common.encrypt.AES256Util"%>

<%


String yyyy = EmsDateUtil.getCurrentDate("yyyy");

if(userinfo!=null){

    String USERNAME = userinfo.getString("USERNAME");

    String P_CD_GROUP_ID = request.getParameter("P_CD_GROUP_ID")==null?"MESSAGE":request.getParameter("P_CD_GROUP_ID");

    String P_CD_MEANING = request.getParameter("P_CD_MEANING")==null?"":request.getParameter("P_CD_MEANING");

    int sessionHashCode = session.getId().hashCode();

    COMMON book = new COMMON(application,request, userinfo, sessionHashCode);

    EmsHashtable[] hash  = (EmsHashtable[])request.getAttribute("hash");

    DataSource ds = (DataSource)application.getAttribute("jdbc/mysql_ds");

    DBManager dbm = new DBManager(ds);

    EmsHashtable[] hash2 = dbm.selectMultipleRecord("SELECT CD_GROUP_ID,CD_GROUP_NM FROM comm_info where CD_GROUP_ID!='FISH_TYPE'  group by CD_GROUP_ID,CD_GROUP_NM  order by CD_GROUP_ID",
      		new String[] { });


%>



<!DOCTYPE html>
<html lang="en">
  <head>

      <meta charset="utf-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
      <meta name="description" content="" />
      <meta name="author" content="" />
      <title>환경설정</title>

          <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>

       <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
       <script src="js/scripts.js"></script>



        <!-- tableMobilize-->
      <link href="demo/css/theme-default.min.css" rel="stylesheet" />
      <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
       <script src="demo/js/jquery.tableMobilize.min.js"></script>

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

              $('#datatablesSimple').tableMobilize();

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


input[type=text]
{
width: 100%;

}


 .msearch input,select {
min-width: 200px;
max-width: 200px;
max-height: 25px;
 }

  .msearch  label {
 min-width: 100px;
 margin-left: 10px;
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



 .msearch input,select {
min-width: 200px;
max-width: 200px;
max-height: 25px;
 }

  .msearch  label {
 min-width: 100px;
  margin-left: 0px;
 }

 .msearch  button {
 min-width: 70px;
}

.btn {
text-align: right;
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


<div class="container-fluid px-2 msearch">


<div class="card mt-1" >
                          <div class="card-header">

<div class="row">

   <div class="col-sm">

   <label for="P_CD_GROUP_ID">그룹명</label>

<select name="P_CD_GROUP_ID"   >

<option value="%">선택하세요</option>

<%=EmsOption.getOption(hash2,"CD_GROUP_ID","CD_GROUP_NM",P_CD_GROUP_ID) %>

</select>

<label for="P_CD_MEANING">코드설명</label>
<input type="text" name="P_CD_MEANING" value="<%=P_CD_MEANING%>" >

   </div>



      <div class="col-sm btn">
	 <button type="button" class="btn btn-danger btn-sm" onclick="setEvent('find');"> <i class="fas fa-undo"></i> 조회</button>
     <button type="button" class="btn btn-danger btn-sm" onclick="setEvent('modify');"> <i class="fas fa-undo"></i> 수정</button>

   </div>




 </div><!-- row end -->





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
%>
           <th data-priority="<%=idx++ %>">▼</th>
           <th data-priority="<%=idx++ %>">CD_GROUP_ID</th>
           <th data-priority="<%=idx++ %>">CD_GROUP_NM</th>
           <th data-priority="<%=idx++ %>">CD_ID</th>
           <th data-priority="<%=idx++ %>">CD_MEANING</th>
           <th data-priority="<%=idx++ %>">PRICE</th>
           <th data-priority="<%=idx++ %>">EXT1</th>
           <th data-priority="<%=idx++ %>">EXT2</th>
           <th data-priority="<%=idx++ %>">SORT</th>

       </tr>
   </thead>

   <tbody >
   <%
   if(hash!=null){
       for (int i = 0; i < hash.length ;  i++) {
   %>

       <tr >


           <td><input type="checkbox" id="chk" name="chk" value="<%=i%>"  ><input type="HIDDEN" name="PK_CD_ID" value="<%=hash[i].getString("CD_ID")%>"  >    </td>

           <td><input type="text" name="CD_GROUP_ID"   value="<%=hash[i].getString("CD_GROUP_ID")%>"  ></td>
           <td><input type="text" name="CD_GROUP_NM"   value="<%=hash[i].getString("CD_GROUP_NM")%>"  ></td>
           <td><input type="text" name="CD_ID"   value="<%=hash[i].getString("CD_ID")%>"  ></td>
           <td><input type="text" name="CD_MEANING"   value="<%=hash[i].getString("CD_MEANING")%>"  ></td>
           <td><input type="text" name="PRICE"   value="<%=hash[i].getString("PRICE")%>"  ></td>
           <td><input type="text" name="EXT1"   value="<%=hash[i].getString("EXT1")%>"  ></td>
           <td><input type="text" name="EXT2"   value="<%=hash[i].getString("EXT2")%>"  ></td>
           <td><input type="text" name="SORT"   value="<%=hash[i].getString("SORT")%>"  ></td>




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


<%@ include file="include_toast.jsp" %>

  </body>
</html>


<%
}else{    //LOGIN 정보가 없을때
%>

<jsp:include page="userinfo.jsp" flush="true"/>

<%} %>
