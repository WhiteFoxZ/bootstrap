<%@ page language="java" pageEncoding="UTF-8"%>

<%

String ADMIN_chk = session.getAttribute("ADMIN")!=null?	(String) session.getAttribute("ADMIN")	:"false";

%>

<!--  layoutSidenav_nav -->
        <div id="layoutSidenav_nav">
              <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                  <div class="sb-sidenav-menu">
                      <div class="nav">

                          <div class="sb-sidenav-menu-heading"></div>
<!--
                           <a class="nav-link" href="#">
                              <span class="sb-nav-link-icon"><i class="fas fa-bullhorn"></i></span>
                              공지사항
                          </a>
 -->
                          <a class="nav-link" href="cal.jsp">
                              <span class="sb-nav-link-icon"><i class="fas fa-calendar"></i></span>
                              달력
                          </a>

<% if(!ADMIN_chk.equals("true")){ %>


<%}else{ %>

                           <a class="nav-link" href="list.jsp">
                              <span class="sb-nav-link-icon"><i class="fas fa-book-open"></i></span>
                              예약조회
                          </a>


                           <a class="nav-link" href="list2.jsp?pageid=list2">
                              <span class="sb-nav-link-icon"><i class="fas fa-book-open"></i></span>
                              미입금대상
                          </a>

                           <a class="nav-link" href="common_money.jsp">
                              <span class="sb-nav-link-icon"><i class="fas fa-list-alt"></i></span>
                              기본금액
                          </a>

                           <a class="nav-link" href="fish_type.jsp">
                              <span class="sb-nav-link-icon"><i class="fas fa-list-alt"></i></span>
                              어종설정
                          </a>


                           <a class="nav-link" href="common.jsp">
                              <span class="sb-nav-link-icon"><i class="fas fa-cog"></i></span>
                              환경설정
                          </a>


<%} %>

                      </div>
                  </div>
                  <div class="sb-sidenav-footer">
                      <div class="small "> <%=ADMIN_chk.equals("true")?"관리자":"" %></div>
                  </div>
              </nav>
          </div>
<!--  layoutSidenav_nav -->