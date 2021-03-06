<%@ page language="java"  pageEncoding="UTF-8"%>

<%@ include file="include.jsp" %>

<%@page import="com.ems.common.util.EmsDateUtil"%>
<%@page import="com.ems.common.util.EmsNumberUtil"%>


<%


 Calendar cal =Calendar.getInstance();

 int nowYear = cal.get(Calendar.YEAR);
 int nowMonth = cal.get(Calendar.MONTH)+1; // +1
 int nowDay = cal.get(Calendar.DAY_OF_MONTH);


 String strYear = request.getParameter( "year");
 String strMonth = request.getParameter( "month");

   int year = nowYear; // 현재의 년을 받아옴.
   int month = nowMonth; // 현재의 월을 받아옴.
   int i;
   if(strYear != null)
   {
    year = Integer.parseInt(strYear);
   }

   if(strMonth != null)
   {
    month = Integer.parseInt(strMonth);
   }

   cal.set(year,month-1,1);
   int startDay = 1;

   int endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
   int week = cal.get(Calendar.DAY_OF_WEEK);
   String yearMonth = year+"-"+EmsNumberUtil.format(month,"00");
   String yyyyMM = yearMonth.replaceAll("-", "");

   String firstDay = yearMonth+"-01";




   String USERNAME="";

   if(userinfo!=null){

       USERNAME = userinfo.getString("USERNAME");

   DBManager dbm = new DBManager((DataSource)application.getAttribute("jdbc/mysql_ds"));



    //예약정보
   EmsHashtable[] hash = dbm.selectMultipleRecord("SELECT DATE_FORMAT(RESERVE_DATE,'%Y%m%d') RESERVE_DATE, DATE_FORMAT(RESERVE_DATE,'%d') RDATE, count(RESERVE_DATE) CNT FROM reserve_info where LOGIN_ID=? and RESERVE_DATE between ? and LAST_DAY(?) group by DATE_FORMAT(RESERVE_DATE,'%d') ",
           new String[] { userinfo.getString("LOGINID"),firstDay,firstDay });


     //자리갯수
     EmsHashtable[] hash2 = dbm.selectMultipleRecord("select count(CD_ID) CNT  from comm_info where CD_GROUP_ID='ROOM_NUM' and LOGIN_ID=? ",
             new String[] { userinfo.getString("LOGINID") });


       //어종
     EmsHashtable[] hash0 = dbm.selectMultipleRecord("SELECT CD_MEANING as FISH_DAY,EXT1 as FISH_NAME, case when EXT2='' then 0 else ifnull(EXT2,0) end AS MAN FROM fishfox.comm_info where CD_GROUP_ID='FISH_TYPE'  and LOGIN_ID=? and CD_MEANING like concat(?,'%') ",
             new String[] { userinfo.getString("LOGINID"), yyyyMM });

     EmsHashtable fishHash =new EmsHashtable();
     EmsHashtable manHash =new EmsHashtable();


   for(int hashCnt=0; hashCnt<hash0.length; hashCnt++){

       fishHash.put(hash0[hashCnt].getString("FISH_DAY"), hash0[hashCnt].getString("FISH_NAME"));

       manHash.put(hash0[hashCnt].getString("FISH_DAY"), hash0[hashCnt].getString("MAN"));
   }



     String cnt = hash2[0].getString("CNT");

   EmsHashtable dayHash = new EmsHashtable();
   if(hash!=null)
   for(int j=0; j<hash.length; j++){
       dayHash.put(hash[j].getString("RDATE"),hash[j].getString("CNT"));
   }


   EmsHashtable[] hash3 = dbm.selectMultipleRecord("select CD_MEANING from comm_info where CD_GROUP_ID='CALENDAR_CNT' and LOGIN_ID=? ",
             new String[] { userinfo.getString("LOGINID") });

   String CALENDAR_CNT = hash3[0].getString("CD_MEANING");


   String today = EmsDateUtil.getCurrentDate("yyyyMM01");

   String addMonths = EmsDateUtil.addMonths(today, Integer.parseInt(CALENDAR_CNT), "yyyyMMdd");

   String afterDay = EmsDateUtil.addDay(addMonths, -1, "yyyyMMdd");

%>


<!DOCTYPE html>
<html lang="en">
   <head>
       <meta charset="utf-8" />
       <meta http-equiv="X-UA-Compatible" content="IE=edge" />
       <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
       <meta name="description" content="" />
       <meta name="author" content="" />
       <title>달력</title>
       <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
       <link href="css/styles.css" rel="stylesheet" />
       <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>




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

tbody.tr, td {  height:90px; align:center; text-align: center; font-family:'nanum';}


div.Box {position:relative; width:100%; height:100%;}
div.head {float:left; width:100%; height:35%; font-size: 15px;color: red; margin-top: 0px;font-weight: bold;}
div.body {clear:left; float:left; width:100%; height:40%; font-size: 20px;  }
div.foot {position:absolute; clear:left; float:left; width:100%; height:25%; ; bottom:0px; font-size: 15px;color: black;}

div.body2 {clear:left; float:left; width:100px; height:100px; font-size: 18px; display: flex; align-items: center; }


.dataTable-table > thead > tr > th {
 vertical-align: bottom;
 text-align: center;
 border-bottom: none;
}

.dataTable-table > tbody > tr > td,
.dataTable-table > tbody > tr > th,
.dataTable-table > thead > tr > td,
.dataTable-table > thead > tr > th {
 padding: 0.2rem 0.1rem;
}



/*
##Device = Most of the Smartphones Mobiles (Portrait)
##Screen = B/w 320px to 479px
##Device = 대부분의 스마트폰 모바일 기기(세로)
##Screen = 320px에서 479px 사이
*/

@media (min-width: 320px) and (max-width: 480px) {

//CSS

div.Box {position:relative; width:100%; height:100%;;}
div.head {float:left; width:100%; height:30%; font-size: 11px;color: red; margin-top: 0px; font-weight: bold;}
div.body {clear:left; float:left; width:100%; height:45%; font-size: 20px;  }
div.foot {position:absolute; clear:left; float:left; width:100%; height:25%; ; bottom:0px; font-size: 10px;color: black;}

div.body2 {clear:left; float:left; width:100px; height:100px; font-size: 18px; display: flex; align-items: center; }


}

</style>

<%@ include file="include_script.jsp" %>

<script type="text/javascript">


function window_onload()
{

     const datatablesSimple = document.getElementById('datatablesSimple');
    if (datatablesSimple) {
        new simpleDatatables.DataTable(datatablesSimple
        ,{
          "paging":   false,
          "info":     false,
          "searchable": false,
          "fixedHeight": true,
          "fixedColumns":true
            }
        );
    }


   for (var i=2021;i<=2030; i++)
  {
       var op= new Option(i+ "년",i);
        syear.options[i -2021]=op;


        if(i== <%=year %> )
        {
           syear.options[i -2021].selected ="selected" ;
        }

  }

  for (var i=1;i<=12 ; i++)
  {
     var op= new Option(i+ "월",i);
      smonth.options[i -1]=op;

      if(i== <%=month %>)
      {
          smonth.options[i -1].selected = "selected";
      }
  }

  var myselect = $( "#syear" );
  myselect[0].selectedIndex = <%=year%>-2021;
  //myselect.selectmenu( "refresh" );    //jquery mobile

  var myselect = $( "#smonth" );
  myselect[0].selectedIndex =  <%=month%>-1;
  //myselect.selectmenu( "refresh" );


}

function month_onchange()
{
    var month = smonth.value;
    var year = syear.value;
    var addr = "cal.jsp?year=" + year +"&month=" + month;
   // alert(addr);
   //addr 이 가지는 주소값으로  페이지를 이동시킨다.
  location.href = addr;

}

function year_onchange()
{
    var year = syear.value;
    var month = smonth.value;
    var addr = "cal.jsp?year=" + year +"&month=" + month;

       location.href = addr;

}

</script>

   </head>
   <body class="sb-nav-fixed" onload ="window_onload()" >

	<%@ include file="include_sb-topnav.jsp" %>

       <div id="layoutSidenav">

           <%@ include file="include_layoutSidenav_nav.jsp" %>

           <div id="layoutSidenav_content">
               <main>
                   <div class="container-fluid px-2">



                       <div class="card mt-1" >
                           <div class="card-header">
                               <i class="fas fa-table me-1"></i>
                                <select id = "syear" name="syear" data-inline="true"  data-ajax="false" >

                </select >
                &nbsp;
                 <select   id= "smonth" name="smonth" onchange= "month_onchange()" data-inline="true"  >

                </select >
                           </div>


                           <div class="card-body2">


                           </div>
                       </div>


                         <!-- 달력시작 -->

                           <table  id="datatablesSimple"  >

 <thead>
  <tr >
    <th  data-sortable="false"  style=" color: red;" > 일</th >
    <th  data-sortable="false" > 월 </th >
    <th  data-sortable="false" > 화 </th >
    <th  data-sortable="false" > 수 </th >
    <th  data-sortable="false" > 목 </th >
    <th  data-sortable="false" > 금 </th >
    <th  data-sortable="false"  > 토  </th>

  </tr >
  </thead>

  <%
      String tmpDay;

     int newLine=0;

     out.println( "<tr>");

     for(i=1; i<week; i++)
     {
      out.println( "<td  >&nbsp;</td>");
      newLine++;
     }

     for(i=startDay; i<=endDay; i++)
     {
      String fontColor=(newLine==0)?"red":(newLine==6)? "blue": "black";
      String bgColor=(nowYear==year)&&(nowMonth==month) &&(nowDay==i)? " #e6e4e6": "#ffffff";
      StringBuffer sb = new StringBuffer("");

      tmpDay = year + EmsNumberUtil.format(month, "00")  + EmsNumberUtil.format(i, "00");




      if(Integer.parseInt(tmpDay) <= Integer.parseInt(afterDay)  ){    //현재일로 2개월까지만 예약가능
               sb.append("<a href='list.jsp?rdate=").append(yearMonth).append("-").append(EmsNumberUtil.format(i,"00")).append("'>");
      }

       if(dayHash.getString(EmsNumberUtil.format(i,"00")).length()>0){

               //int leftSiteCnt = Integer.parseInt(cnt) - Integer.parseInt(dayHash.getString(EmsNumberUtil.format(i,"00")));

               int totalSiteCnt = Integer.parseInt( manHash.getString(yyyyMM + EmsNumberUtil.format(i,"00")) );

               //남은자리수
               int leftSiteCnt =0;





                 sb.append("<div class='head '>");
                   sb.append( fishHash.getString(yyyyMM + EmsNumberUtil.format(i,"00")) );
                   sb.append("</div>");


                   sb.append("<div class='body'>");    //날짜
                   sb.append(i);    //날짜
                   sb.append("</div>");    //날짜

                   sb.append("<div class='foot'>");


                   leftSiteCnt = Integer.parseInt( manHash.getString(yyyyMM + EmsNumberUtil.format(i,"00")) )
                                      -
                                      Integer.parseInt( dayHash.getString(EmsNumberUtil.format(i,"00"))  );


                if(leftSiteCnt==0){
                    sb.append( "마감" );
                }else{
                    sb.append( leftSiteCnt );
                    sb.append(" 가능");
                }


                sb.append("</div>");    //foot




       }else{



            sb.append("<div class='head '>");
            sb.append( fishHash.getString(yyyyMM + EmsNumberUtil.format(i,"00")) );
            sb.append("</div>");    //head


            sb.append("<div class='body'>");    //날짜
            sb.append(i);    //날짜
            sb.append("</div>");    //날짜 body

            sb.append("<div class='foot'>");

            sb.append( manHash.getString(yyyyMM + EmsNumberUtil.format(i,"00")) );    //낚시 종류별 가능인원수

            sb.append("</div>");//foot



       }

       if(Integer.parseInt(tmpDay) <= Integer.parseInt(afterDay)  ){    //현재일로 2개월까지만 예약가능
          sb.append("</a>");
       }

      out.println( "<td  bgcolor="+bgColor+ " ><font color="+fontColor+ "><div class='Box'>"+sb.toString()+ "</div></font></td>" );    //최종내용
      newLine++;

          if(newLine ==7 &&i!=endDay)
          {
           out.println( "</tr><tr>" );
           newLine=0;
          }
     }
    while(newLine>0 && newLine<7)
    {
     out.println( "<td  >&nbsp;</td>");
     newLine++;
    }
    out.println( "</tr>");

  %>
 </table >

 <!-- 달력끝 -->

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