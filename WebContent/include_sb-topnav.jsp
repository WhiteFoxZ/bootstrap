<%@ page   pageEncoding="UTF-8"%>

<%@ page import="com.ems.common.util.*"%>
<%@ page import="java.util.*"%>

<%

EmsHashtable sbTopUserInfo = session.getAttribute("userinfo")!=null?	(EmsHashtable) session.getAttribute("userinfo")	:null;

String sbTopAdmin = session.getAttribute("ADMIN")!=null?	(String) session.getAttribute("ADMIN")	:"false";

String sbTopUserName = "";

if(sbTopUserInfo!=null){
	sbTopUserName = sbTopUserInfo.getString("USERNAME");
}

%>
<style>

 .msearch {
     position: sticky;
     top: 50px;
     z-index: 1029;
 }

</style>
	<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href="cal.jsp"><%=sbTopUserName %></a>
            <!-- Sidebar Toggle-->
            <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
            <!-- Navbar Search
            <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
                <div class="input-group">
                    <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
                    <button class="btn btn-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
                </div>
            </form>
            -->
            <div class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0"></div>
            <!-- Navbar-->
            <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
<% if(sbTopAdmin.equals("true")){ %>

						<li><a class="dropdown-item" href="admin_pass.jsp">Settings</a></li>
                        <li><hr class="dropdown-divider" /></li>

                        <li><a class="dropdown-item" href="logout_admin.jsp">Logout</a></li>
<%}else{ %>
 						<li><a class="dropdown-item" href="logout_user.jsp">Logout</a></li>
<%} %>
                    </ul>
                </li>
            </ul>
        </nav>

