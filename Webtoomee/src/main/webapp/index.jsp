<%@ page contentType="text/html;charset=UTF-8" import="java.sql.*" %>
<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>

<%
    ResultSet bestWebtoonRS = null;
    ResultSet risingWebtoonRS = null;
    String loginUserName = null;
    String loginUserType = null;
    boolean isLogin = false;

    try {
        Connection con = DbConnect.dbConnect();
        Statement stmt = con.createStatement(); // Statement 객체 생성

        /**
         * 주요 인기 웹툰 쿼리
         * 평균 평점 순으로 10개
         *
         */
        String bestWebtoonQuery = "SELECT wtn_id, wtn_title, (select user_name from user where user_id=T.wtn_author) as 'author', wtn_genre, " +
                "(select avg(rt_score) from rating natural join episode where wtn_id=T.wtn_id) as 'rating', wtn_thb " +
                "FROM webtoon T " +
                "order by rating limit 10";
        bestWebtoonRS = stmt.executeQuery(bestWebtoonQuery);

        /**
         * 인기 급상승 웹툰 쿼리
         * 평균 평점이 4점 이상인 웹툰 중 최근에 연재를 시작한 순, 평균 평점이 높은 순으로 10개
         */
        String risingWebtoonQuery = "SELECT wtn_title, (select user_name from user where user_id=T.wtn_author) as 'name', wtn_genre, " +
                "(select avg(rt_score) from rating natural join episode where wtn_id=T.wtn_id) as 'rating', wtn_thb " +
                "FROM webtoon T " +
                "where (select avg(rt_score) from rating natural join episode where wtn_id=T.wtn_id) > 4 " +
                "order by created_at desc, rating limit 10 ";
        risingWebtoonRS = stmt.executeQuery(risingWebtoonQuery);


        /**
         *  현재 로그인된 사용자 조회
         *  로그인된 사용자 정보는 쿠키에 UUID의 형식으로 저장
         */
        Integer loginUserId = LoginUser.getLoginUser(request, session);
        if (loginUserId == null) {
            loginUserName = "로그인";
            loginUserType = "";
        }
        else {
            User findUser = User.findUser(loginUserId);
            if (findUser == null) {
                loginUserName = "로그인";
                loginUserType = "";
            }
            else {
                isLogin = true;
                loginUserName = findUser.getUserName() + "님";
                if (findUser.getUserType().equals("admin")) {
                    loginUserType = "관리자";
                }
                else if (findUser.getUserType().equals("author")) {
                    loginUserType = "웹툰 작가";
                }
                else {
                    // 일반 사용자는 표시하지 않음
                    loginUserType = "";
                }
            }

        }

%>

<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Webtoomee</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
    <div class="sub-title-box"></div>
    <div class="main-title-box">
        <a class="main-title" href="index.jsp">Webtoomee</a>
    </div>
    <div class="title-bar-menu">
        <div>
          <span>
              <% if (!isLogin) { %>
              <a href="login.jsp">
              <% }
                 else {%>
              <a href="myPage.jsp"> <%} %>
              <img src="icons/user.png" /></a>
          </span>
            <div><%=loginUserName%> <br /><%=loginUserType%></div>
            <% if (isLogin) { %>
            <a href="logout.jsp" style="color: cadetblue; text-decoration: none;">로그아웃</a>
            <% } %>
        </div>
        <%
            if (loginUserType.equals("웹툰 작가") || loginUserType.equals("관리자")) {
        %>
        <div>
          <span
          ><a href="webtoonManagement.jsp"
          ><img src="icons/pen-to-square-solid.svg" /></a
          ></span>
            <div>웹툰 관리</div>
        </div>
        <%
            }
            else {
        %>
        <div></div>
        <%
            }
        %>

    </div>
</div>
<!-- title-bar -->

<!-- navigation / search bar -->
<div class="navigation-search-bar">
    <div>
        <span><a href="index.jsp">홈</a></span>
        <span><a href="webtoonList.jsp">전체 웹툰</a></span>
        <span><a href="webtoonList.jsp?by=genre">장르별 웹툰</a></span>
        <span><a href="webtoonList.jsp?by=author">작가별 웹툰</a></span>
    </div>

    <form>
        <div class="search-bar">
            <input type="text" placeholder="search..." />
            <button type="submit">
                <img src="icons/magnifying-glass-solid.svg" />
            </button>
        </div>
    </form>
</div>

<!-- filter / search bar -->

<!-- webtoon list -->

<div class="underlined-title-box">
    <span>주요 인기 웹툰</span>
</div>

<%
    while(bestWebtoonRS.next()) {

%>

<div class="webtoon-list">
    <div class="single-webtoon">
        <span>
            <a href="episodeList.jsp?id=<%=bestWebtoonRS.getInt("wtn_id")%>">
                <img width="125" height="137" src="./images/<%=bestWebtoonRS.getString("wtn_thb")%>" />
            </a>
        </span>
        <div>
            <%=bestWebtoonRS.getString("wtn_title")%><br /><%=bestWebtoonRS.getString("author")%><br /><%=bestWebtoonRS.getString("wtn_genre")%>
        </div>
        <img class="rating" src="icons/별점.png" />
    </div>
</div>
<%
    }
%>

<div class="underlined-title-box">
    <span>인기 급상승 웹툰</span>
</div>

<%
    while(risingWebtoonRS.next()) {
%>

<div class="webtoon-list">
    <div class="single-webtoon">
        <span>
            <a href="episodeList.jsp?id=<%=risingWebtoonRS.getInt("wtn_id")%>">
                <img width="125" height="137" src="./images/<%=risingWebtoonRS.getString("wtn_thb")%>" />
            </a>
        </span>
        <div>
            <%=risingWebtoonRS.getString("wtn_title")%><br /><%=risingWebtoonRS.getString("author")%><br /><%=risingWebtoonRS.getString("wtn_genre")%>
        </div>
        <img class="rating" src="icons/별점.png" />
    </div>
</div>
<%
    }
%>

<!-- webtoon list -->
</body>
</html>

<%
    bestWebtoonRS.close();
    risingWebtoonRS.close();
    }

    catch (Exception e) {
    e.printStackTrace();
}
%>