<%@ page   pageEncoding="UTF-8"%>
<!--  layoutSidenav_nav -->
        <div id="layoutSidenav_nav">
              <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                  <div class="sb-sidenav-menu">
                      <div class="nav">

                          <div class="sb-sidenav-menu-heading"></div>

                           <a class="nav-link" href="index.html">
                              <span class="sb-nav-link-icon"><i class="fas fa-bullhorn"></i></span>
                              공지사항
                          </a>

                          <a class="nav-link" href="cal.jsp">
                              <span class="sb-nav-link-icon"><i class="fas fa-calendar"></i></span>
                              달력
                          </a>

<% if(!ADMIN.equals("true")){ %>

                           <a class="nav-link" href="index.html">
                              <span class="sb-nav-link-icon"><i class="fas fa-book-open"></i></span>
                              예약확인(취소)
                          </a>

<%}else{ %>




                           <a class="nav-link" href="index.html">
                              <span class="sb-nav-link-icon"><i class="fas fa-book-open"></i></span>
                              예약조회
                          </a>


                           <a class="nav-link" href="index.html">
                              <span class="sb-nav-link-icon"><i class="fas fa-book-open"></i></span>
                              미입금대상
                          </a>

                           <a class="nav-link" href="index.html">
                              <span class="sb-nav-link-icon"><i class="fas fa-list-alt"></i></span>
                              기본금액
                          </a>

                           <a class="nav-link" href="index.html">
                              <span class="sb-nav-link-icon"><i class="fas fa-list-alt"></i></span>
                              어종설정
                          </a>


                           <a class="nav-link" href="index.html">
                              <span class="sb-nav-link-icon"><i class="fas fa-cog"></i></span>
                              환경설정
                          </a>


<%} %>

                      </div>
                  </div>
                  <div class="sb-sidenav-footer">
                      <div class="small">Logged in as:</div>
                      Start Bootstrap
                  </div>
              </nav>
          </div>
<!--  layoutSidenav_nav -->