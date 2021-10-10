<%@ page   pageEncoding="UTF-8"%>

<%@ include file="include.jsp" %>

<%@ page import="com.ems.common.encrypt.AES256Util"%>

<%



if(userinfo!=null){


	String USERNAME = userinfo.getString("USERNAME");

   String event = request.getParameter("event");
   if (event == null) {
       event = "find";
   }

   String room_num=request.getParameter("room_num")!=null?request.getParameter("room_num").toString():"";
   String rdate=request.getParameter("rdate")!=null?request.getParameter("rdate").toString():"";
   String LOGINID = userinfo.getString("LOGINID");
   String IMG_UPLOAD = userinfo.getString("IMG_UPLOAD");    //이미지 업로드 기능활성화인지 체크

   DataSource ds = (DataSource)application.getAttribute("jdbc/mysql_ds");

   DBManager dbm = new DBManager(ds);

    String RESERVE_DATE = request.getAttribute("RESERVE_DATE")!=null?request.getAttribute("RESERVE_DATE").toString():""; // 카드ID
    String USER_TEL1 = request.getAttribute("USER_TEL1")!=null?request.getAttribute("USER_TEL1").toString():""; // 카드ID
    String ROOM_NUM = request.getAttribute("ROOM_NUM")!=null?request.getAttribute("ROOM_NUM").toString():""; // 카드ID
    String MEMO = request.getAttribute("MEMO")!=null?request.getAttribute("MEMO").toString():""; // 카드ID
    String USER_EMAIL = request.getAttribute("USER_EMAIL")!=null?request.getAttribute("USER_EMAIL").toString():""; // 카드ID

    String USER_NAME = request.getAttribute("USER_NAME")!=null?request.getAttribute("USER_NAME").toString():""; // 카드ID
    String DAY = request.getAttribute("DAY")!=null?request.getAttribute("DAY").toString():""; // 카드ID
    String CAR_NUM = request.getAttribute("CAR_NUM")!=null?request.getAttribute("CAR_NUM").toString():""; // CAR_NUM

    if(ROOM_NUM.length()>0) room_num = ROOM_NUM;


    //메시지
   EmsHashtable[] hash_msg = dbm.selectMultipleRecord("SELECT CD_ID,CD_MEANING,PRICE FROM comm_info WHERE CD_GROUP_ID='MESSAGE' AND LOGIN_ID=? ",
           new String[] { LOGINID });

   String message = hash_msg[0].getString("CD_MEANING");


   EmsHashtable[] hash_deck = dbm.selectMultipleRecord("SELECT CD_ID,CD_MEANING,PRICE FROM comm_info WHERE CD_GROUP_ID='ROOM_NUM' AND LOGIN_ID=? AND CD_ID=? ",
           new String[] { LOGINID,room_num });

   String deck_desc = hash_deck[0].getString("CD_MEANING");    //자리설명

   message =  deck_desc +"<P>"+ message;


    //1박금액 ,고기어종
   EmsHashtable[] hash_money = dbm.selectMultipleRecord(
           "SELECT CD_ID,CD_MEANING as FISH_TYPE ,PRICE FROM comm_info WHERE CD_GROUP_ID='DAY_MONEY'  AND LOGIN_ID=? and CD_MEANING = (SELECT EXT1 FROM comm_info WHERE CD_GROUP_ID='FISH_TYPE' AND LOGIN_ID=?  and CD_MEANING=? ) ",
           new String[] {LOGINID, LOGINID,rdate.replaceAll("-", "") });


    //기간을 몇일까지 가져올지 체크
   EmsHashtable[] hash_day = dbm.selectMultipleRecord("SELECT DATE_FORMAT( RESERVE_DATE, '%m/%d' ) RDATE FROM reserve_info WHERE LOGIN_ID =? AND ROOM_NUM = ? AND RESERVE_DATE > ? AND RESERVE_DATE < DATE_ADD(? , INTERVAL 5 DAY) ",
           new String[] { LOGINID,room_num,rdate,rdate });


    StringBuffer q1 = new StringBuffer("");
    q1.append("SELECT INFO.CD_MEANING as IMG_URL, INFO.EXT1 AS FISH_TYPE, FISH.CD_MEANING AS FISHDAY  FROM comm_info INFO , comm_info FISH");
    q1.append(" where INFO.CD_GROUP_ID='SHIP_POSTION' AND FISH.CD_GROUP_ID='FISH_TYPE' ");
    q1.append(" AND INFO.LOGIN_ID=FISH.LOGIN_ID   ");
    q1.append(" AND (case when INFO.EXT1='타이라바' then INFO.EXT1 else FISH.EXT1 END ) =FISH.EXT1 ");
    q1.append(" AND INFO.LOGIN_ID=? AND FISH.CD_MEANING =? ");
    q1.append(" order by FISH_TYPE desc ");



 //배위치사진
   EmsHashtable[] postion = dbm.selectMultipleRecord(q1.toString(),          new String[] { LOGINID ,rdate.replaceAll("-", "") });



%>



<!DOCTYPE html>
<html lang="en">
  <head>
      <meta charset="utf-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
      <meta name="description" content="" />
      <meta name="author" content="" />
      <title>예약등록</title>

          <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>

       <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
       <script src="js/scripts.js"></script>


      <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
      <script src="jquery-number-2.13/jquery.number.min.js"></script>
      <script src="jquery/js/moment.min.js"></script>





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
               document.frmMain.event.value=event;

               if(event=="modify" && submitFlag==true){

                   document.frmMain.action="room_madeAction.jsp";

                   submitFlag=false;

               }

               document.frmMain.submit();
               return false;
           }


           function emailCheck(email_address){
               email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
               if(!email_regex.test(email_address)){
                   return false;
               }else{
                   return true;
               }
           }



           function save(event){

               if(document.frmMain.USER_NAME.value==""){
                   showMsg('이름(닉네임)을 넣어주세요.');
                   return false;
               }

               if(document.frmMain.USER_TEL1.value==""){
                   showMsg('전화번호를 넣어주세요.');
                   document.frmMain.USER_TEL1.focus();
                   return false;
               }

<%if(ADMIN!=null && ADMIN.equals("false")){
%>
    if(!$("#chk1").is(":checked")){
        showMsg('개인정보 약관을 읽고 동의를 체크해 주세요.');
        return false;

    }
<%
    }
%>


                cal();


               setEvent(event);
           }




       function init(){

               <%
               String msg = request.getAttribute("msg")!=null?request.getAttribute("msg").toString():null;

               if(msg!=null && msg.length()>0){
               %>

               var msgText="<%=msg%>";

               showMsg(msgText);

           <%}%>

       }


       function cal(){


           var DAY =$('select[name="DAY"]').val();


            var rdate = moment('<%=rdate%>',"YYYY-MM-DD");

           var MAIN_PRICE = parseInt($("#price").val());


           var TOTAL_PAY = MAIN_PRICE;


            $("#TOTAL_PAY").val( $.number( TOTAL_PAY ) );

               var html = "<%=hash_money.length>0?hash_money[0].getString("FISH_TYPE"):"" %> :"+" 일["+$.number( TOTAL_PAY )+"]원";


               $("#cal_result").html(html);
               $("#PRICE_DESC").val(html);

       }


       $(document).ready(function(){



            $('select[name="DAY"]').change(function(){
                cal();
              });

               cal();


               toastInit();

       });





       </script>

  </head>
  <body class="sb-nav-fixed" onload ="init()" >

  <%@ include file="include_sb-topnav.jsp" %>

      <div id="layoutSidenav">

          <%@ include file="include_layoutSidenav_nav.jsp" %>

          <div id="layoutSidenav_content">
              <main>
                  <div class="container-fluid px-2" >

                      <div class="card mt-1 " >
                          <div class="card-header">
                              <i class="fas fa-table me-1"></i>

                          </div>

                          <div class="card-body2">


<%@ include file="include_toast.jsp" %>


<form name="frmMain" method="post" onsubmit="return false;" >
<input type="hidden" name="event" value="" />
<input type="hidden" name="ROOM_NUM" id="ROOM_NUM" value="<%=room_num %>" >
<input type="hidden" name="rdate" id="rdate" value="<%=rdate %>" >
<input type="hidden" name="price" id="price" value="<%=hash_money.length>0?hash_money[0].getString("PRICE"):"0" %>" >




 <div class="row m-1 ">
   <label for="RESERVE_DATE" class="col-4 col-form-label">예약일</label>
   <div class="col-8">
     <input type="text" class="form-control"  name="RESERVE_DATE" id="RESERVE_DATE" value="<%=rdate %>" readonly="readonly">
   </div>
 </div>
 <div class="row m-1 ">
   <label for="USER_NAME" class="col-4 col-form-label">이름(닉네임)</label>
   <div class="col-8">
     <input type="text" class="form-control" name="USER_NAME" id="USER_NAME" value="<%=USER_NAME %>" placeholder="이름(닉네임)을 입력하세요." data-enhance="false" >
   </div>
 </div>
 <div class="row m-1">
   <label for="inputEmail3" class="col-4 col-form-label">연락처</label>
   <div class="col-8">
     <input type="text" class="form-control" name="USER_TEL1" id="USER_TEL1" value="<%=USER_TEL1 %>" placeholder="연락처를 입력하세요." data-enhance="true">
   </div>
 </div>

 <div class="row m-1">
   <label for="TOTAL_PAY" class="col-4 col-form-label">비용</label>
   <div class="col-8">
         <div id="cal_result"></div>
         <input type="text"  class="form-control" name="TOTAL_PAY" id="TOTAL_PAY"  readonly="readonly" required >
        <input type="HIDDEN" class="form-control" name="PRICE_DESC" id="PRICE_DESC"  readonly="readonly" >

   </div>
 </div>


   <div class="row m-1">
    <label for="TOTAL_PAY" class="col-4 col-form-label">메모</label>
   <div class="col-8">
         <textarea id="MEMO" class="form-control"  rows="4" name="MEMO" placeholder="메모" ><%=MEMO %></textarea>
   </div>
 </div>

<select name="DAY" id="DAY"  style="display:none;">
                     <option value="1">1</option>
</select>


<%if(ADMIN!=null && ADMIN.equals("false")){
%>


   <div class="row m-1 card">

<label for="info" class="col-12 col-form-label card-header ">개인정보 동의 <input type="checkbox" name="chk1" id="chk1" class="ms-1"></label>
<textarea id="info" class="form-control" rows="4" name="info">
개인정보 취급방침
1. 수집하는 개인정보(예약에 필요한 최소한의 정보를 수집합니다.)
1)성명,닉네임
2)휴대폰번호(예약확인및취소)
3)예약정보

2. 개인정보의 보유 및 이용기간
- 예약에 관한 개인정보는 낚시 예약에 필요한 개인정보만을 관리합니다.(예약일 기준1달)
- 예약에 관한 모든 개인정보는 예약일 기준 1달까지만 보유하면 이후 모두 자동삭제 되어 파기됩니다.
- 개인정보를 원칙적으로 외부에 제공하지 않습니다.
- 개인정보 취급방침 내용을 읽었습니다. 이에 동의 하시면 상단에 동의를 체크해주세요.
                  </textarea>

     </div>
<%} %>


<div class="row my-2 m-1" >

<button type="button" class="btn btn-primary btn-sm" style="width: 100%" onclick="javascript:return save('modify');"> <i class="fas fa-undo"></i> 저장</button>

</div>

</form>

                          </div>
                      </div>



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