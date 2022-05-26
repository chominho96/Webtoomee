<%@ page contentType="text/html;charset=UTF-8" import="java.sql.*" %>

<%
    ResultSet bestWebtoonRS = null;
    ResultSet risingWebtoonRS = null;
    String loginUserId = null;
    String loginUserName = null;
    String loginUserType = null;

    try {
        Class.forName("org.mariadb.jdbc.Driver");

        // TODO : 이름 변경
        //String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
        String DB_URL = "jdbc:mariadb://localhost:3307/webtoon?useSSL=false";

        // TODO : 이름 변경
        //String DB_USER = "admin";
        //String DB_PASSWORD= "1234";
        String DB_USER = "root";
        String DB_PASSWORD= "whalsgh9664!";
        // TODO : 이름 변경

        Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); // 연결자 획득
        Statement stmt = con.createStatement(); // Statement 객체 생성


        /**
         * 주요 인기 웹툰 쿼리
         * 평균 평점 순으로 10개
         *
         */
        String bestWebtoonQuery = "SELECT wtn_id, wtn_title, (select user_name from user where user_id=T.wtn_author) as 'name', wtn_genre, " +
                "(select avg(rt_score) from rating natural join episode where wtn_id=T.wtn_id) as 'rating' " +
                "FROM webtoon T " +
                "order by rating limit 10";
        bestWebtoonRS = stmt.executeQuery(bestWebtoonQuery);

        /**
         * 인기 급상승 웹툰 쿼리
         * 평균 평점이 4점 이상인 웹툰 중 최근에 연재를 시작한 순, 평균 평점이 높은 순으로 10개
         */
        String risingWebtoonQuery = "SELECT wtn_title, (select user_name from user where user_id=T.wtn_author) as 'name', wtn_genre, " +
                "(select avg(rt_score) from rating natural join episode where wtn_id=T.wtn_id) as 'rating' " +
                "FROM webtoon T " +
                "where (select avg(rt_score) from rating natural join episode where wtn_id=T.wtn_id) > 4 " +
                "order by created_at desc, rating limit 10 ";
        risingWebtoonRS = stmt.executeQuery(risingWebtoonQuery);

        /**
         *  현재 로그인된 사용자 조회
         *  로그인된 사용자 정보는 쿠키에 UUID의 형식으로 저장
         */

        for (Cookie cookie : request.getCookies()) {
            if (cookie.getName().equals("id")) {
                loginUserId = cookie.getValue();
            }
        }
        if (loginUserId != null) {
            // 사용자 ID
            loginUserId = (String) session.getAttribute(loginUserId);

            // 사용자 이름
            // 로그인된 사용자 정보 쿼리
            String loginUserQuery = "select user_name, user_type from user where user_id = ?";
            PreparedStatement pstmt = con.prepareStatement(loginUserQuery);
            pstmt.setString(1, loginUserId);
            ResultSet loginUserRS = pstmt.executeQuery();
            loginUserName = loginUserRS.getString("user_name");

            // 사용자 분류 결정
            loginUserType = loginUserRS.getString("user_type");
            if (loginUserType.equals("admin")) {
                loginUserType = "관리자";
            }
            else if (loginUserType.equals("author")) {
                loginUserType = "웹툰 작가";
            }
            else {
                // 일반 사용자는 표시하지 않음
                loginUserType = "";
            }
        }
        else {
            // 로그인하지 않은 경우
            loginUserName = "로그인";
            loginUserType = "";
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
        <a class="main-title" href="index.html">Webtoomee</a>
    </div>
    <div class="title-bar-menu">
        <div>
          <span
          ><a href="myPage.html"><img src="icons/user.png" /></a
          ></span>
            <div><%=loginUserName%> <br /><%=loginUserType%></div>
        </div>
        <div>
          <span
          ><a href="webtoonManagement.html"
          ><img src="icons/pen-to-square-solid.svg" /></a
          ></span>
            <div>웹툰 관리</div>
        </div>
    </div>
</div>
<!-- title-bar -->

<!-- navigation / search bar -->
<div class="navigation-search-bar">
    <div>
        <span><a href="index.html">홈</a></span>
        <span><a href="webtoonList.html">전체 웹툰</a></span>
        <span><a href="webtoonList.html">장르별 웹툰</a></span>
        <span><a href="webtoonList.html">작가별 웹툰</a></span>
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
        <span
        ><a href="episodeList.html?episode=<%=bestWebtoonRS.getInt("wtn_id")%>"><img src="images/웹툰 썸네일1.png" /></a
        ></span>
        <div><%=bestWebtoonRS.getString("wtn_title")%>><br /><%=bestWebtoonRS.getString("author")%><br /><%=bestWebtoonRS.getString("wtn_genre")%></div>
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
        <span
        ><a href="episodeList.html?episode=<%=risingWebtoonRS.getInt("wtn_id")%>"><img src="images/웹툰 썸네일1.png" /></a
        ></span>
        <div><%=risingWebtoonRS.getString("wtn_title")%>><br /><%=risingWebtoonRS.getString("author")%><br /><%=risingWebtoonRS.getString("wtn_genre")%></div>
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
    throw new RuntimeException(e);
}
%>