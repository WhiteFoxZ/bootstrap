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
        <title>Dashboard - SB Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>


<script type="text/javascript">


function window_onload()
 {


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
   myselect.selectmenu( "refresh" );

   var myselect = $( "#smonth" );
   myselect[0].selectedIndex =  <%=month%>-1;
   myselect.selectmenu( "refresh" );


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

tbody.tr, td {  height:90px; align:center; text-align: center; }


div.Box {position:relative; width:100%; height:100%;}
div.head {float:left; width:100%; height:30%; font-size: 15px;color: red; margin-top: 0px;}
div.body {clear:left; float:left; width:100%; height:45%; font-size: 20px;  }
div.foot {position:absolute; clear:left; float:left; width:100%; height:25%; ; bottom:0px; font-size: 15px;color: black;}

div.body2 {clear:left; float:left; width:100px; height:100px; font-size: 18px; display: flex; align-items: center; }


.dataTable-table > thead > tr > th {
  vertical-align: bottom;
  text-align: center;
  border-bottom: none;
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
div.head {float:left; width:100%; height:30%; font-size: 10px;color: red; margin-top: 0px;}
div.body {clear:left; float:left; width:100%; height:45%; font-size: 20px;  }
div.foot {position:absolute; clear:left; float:left; width:100%; height:25%; ; bottom:0px; font-size: 10px;color: black;}

div.body2 {clear:left; float:left; width:100px; height:100px; font-size: 18px; display: flex; align-items: center; }


}

</style>
    </head>
    <body class="sb-nav-fixed" onload ="window_onload()" >
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




       if(Integer.parseInt(tmpDay) <= Integer.parseInt(afterDay)  ){	//현재일로 2개월까지만 예약가능
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


	       		sb.append("<div class='body'>");	//날짜
	       		sb.append(i);	//날짜
	       		sb.append("</div>");	//날짜

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


				sb.append("</div>");	//foot




	   }else{



		    sb.append("<div class='head '>");
			sb.append( fishHash.getString(yyyyMM + EmsNumberUtil.format(i,"00")) );
			sb.append("</div>");	//head


			sb.append("<div class='body'>");	//날짜
			sb.append(i);	//날짜
			sb.append("</div>");	//날짜 body

			sb.append("<div class='foot'>");

			sb.append( manHash.getString(yyyyMM + EmsNumberUtil.format(i,"00")) );	//낚시 종류별 가능인원수

			sb.append("</div>");//foot



	   }

	   if(Integer.parseInt(tmpDay) <= Integer.parseInt(afterDay)  ){	//현재일로 2개월까지만 예약가능
       	sb.append("</a>");
	   }

       out.println( "<td  bgcolor="+bgColor+ " ><font color="+fontColor+ "><div class='Box'>"+sb.toString()+ "</div></font></td>" );	//최종내용
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
                <footer class="py-4 bg-light mt-auto">
                    <div class="container-fluid px-4">
                        <div class="d-flex align-items-center justify-content-between small">
                            <div class="text-muted">Copyright &copy; Your Website 2021</div>
                            <div>
                                <a href="#">Privacy Policy</a>
                                &middot;
                                <a href="#">Terms &amp; Conditions</a>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="js/scripts.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" crossorigin="anonymous"></script>
        <script src="js/datatables-simple-demo.js"></script>
    </body>
</html>


<%
}else{	//LOGIN 정보가 없을때
%>

<jsp:include page="userinfo.jsp" flush="true"/>

<%} %>
