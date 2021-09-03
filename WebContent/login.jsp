<%@ page  pageEncoding="UTF-8"%>


<%@ include file="include.jsp" %>

<%

Cookie cookies[] = request.getCookies();
String cookieName=null;
String id="";
String pw="";


String superuser=null;
if(session.getAttribute("superuser")==null){

	superuser=request.getHeader("Referer");	//밴드에서 링크타고 왔을때만 슈퍼관리자로 로그인

	log(superuser);

}else{

	superuser = session.getAttribute("superuser").toString();

}




if(cookies!=null && cookies.length>0){

for(int i=0; i<cookies.length; i++){

	cookieName = cookies[i].getName();

	if(cookieName.equals("LOGINID")){
		id = cookies[i].getValue();
	}

	if(cookieName.equals("LOGINPW")){
		pw = cookies[i].getValue();
	}

}

}

String referrer = "https://band.us/band/84018939";	//https://band.us/band/84018939/post/3?showBandInfoCard=false

EmsHashtable[] users=null;

if(superuser!=null && superuser.indexOf(referrer)>=0){

	session.setAttribute("superuser", referrer);

	DataSource ds = (DataSource)application.getAttribute("jdbc/mysql_ds");

	DBManager dbm = new DBManager(ds);

	users = dbm.selectMultipleRecord("SELECT USERNAME, concat(LOGINID,'|',LOGINPW,'|',ACCESSPW) LOGINID FROM fishfox.user_info where LOGINID!='ADMIN' order by USERNAME ",
    		new String[] {  });

}

%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Login - SB Admin</title>
        <link href="css/styles.css" rel="stylesheet" />
        <script src="https://code.jquery.com/jquery-1.11.1.min.js"></script>

<SCRIPT language="JavaScript">
    function sendData()
    {
     var f = document.frmMain;
     if(f.id.value == "")
     {
      window.alert("ID를 반드시 입력해야 합니다.");
      f.id.focus();
      return false;
     }
     if(f.id.value.length < 4 || f.id.value.length > 10)
     {
      window.alert("ID는 4자 이상 10자 이하 입니다.");
      f.id.select();
      return false;
     }

     if(f.pw.value == "")
     {
      window.alert("비밀번호를 반드시 입력해야 합니다.");
      f.pw.focus();
      return false;
     }

     if(f.pw.value.length < 4 || f.pw.value.length > 10)
     {
      window.alert("비밀번호를 4자 이상 10자 이하 입니다.");
      f.pw.select();
      return false;
     }

     <%if(superuser==null){%>
     	if(id=="ADMIN") return false;
	 <%}%>

     f.submit();
    }

    function sendLogin(){

    	location.href = "userCreate.jsp";

    }

    //예약자로그인
    function sendLogin2(){
    	var f = document.frmMain2;
    	f.submit();

    }


    function init(){

		$("#userLov").on('change', function() {

	        var text = this.value;

	        var arrText = text.split("|");

	        //alert(arrText[0] +", "+arrText[1]);

	        $("#id").val(arrText[0]);
	        $("#pw").val(arrText[1]);

	        $("#frmMain2_id").val(arrText[0]);
	        $("#frmMain2_pw").val(arrText[2]);

		});	//userLov
    }

  </SCRIPT>



    </head>
    <body class="bg-primary" onload="document.frmMain.id.focus();init();">
        <div id="layoutAuthentication">
            <div id="layoutAuthentication_content">
                <main>
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-5">
                                <div class="card shadow-lg border-0 rounded-lg mt-5">

                                <div class="card-header"><h3 class="text-center font-weight-light my-4">낚시예약</h3></div>


                                    <div class="card-header"><h3 class="text-center font-weight-light my-1">Login</h3></div>

                                    <div class="card-body">
                                        <form name="frmMain" method=post action="loginAction.jsp" target="_self">
                                            <div class="form-floating mb-3">
                                                <input class="form-control" type="text"  id="id" name="id"  value="<%=id %>" required="required" />
                                                <label for="id">ID</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" type="text" id="pw" name="pw" value="<%=pw %>" required="required" />
                                                <label for="pw">Password</label>
                                            </div>
                                            <div class="form-check mb-3">
                                                <input class="form-check-input" type="checkbox" name="remember" id="gr_login_rememberme"  <%=pw.equals("")?"":"checked" %>  />
                                                <label class="form-check-label" for="gr_login_rememberme">로그인유지</label>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between mt-4 mb-0">
                                                <a class="small" href="password.jsp">비번찾기?</a>

                                                 <button type="button" class="btn btn-success "  onclick="sendData();"><i class="bi bi-cloud-arrow-up" role="img" ></i> 로그인</button>
                                                 <button type="button" class="btn btn-warning "  onclick="sendLogin();"><i class="bi bi-cloud-arrow-up" role="img" ></i> 신규가입</button>


                                            </div>
                                        </form>
                                    </div>
                                    <div class="card-footer text-center py-3">
                                        <div class="small"><a href='tel:010-3190-2461'>가입문의 ☎ 010-3190-2461</a></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
            <div id="layoutAuthentication_footer">
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
    </body>
</html>


