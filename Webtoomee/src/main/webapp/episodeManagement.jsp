<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.example.webtoon.Episode" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

  /**
   *  episodeManagement.jsp
   *  웹툰 작가만 사용할 수 있는 페이지로, 연재 중인 특정 웹툰에 대한 회차를 관리할 수 있는 페이지입니다.
   */

  // 로그인된 사용자를 확인합니다.
  Integer loginUserId = LoginUser.getLoginUser(request, session);
  if (loginUserId == null) {
%>
    <script>
      alert("잘못된 접근입니다");
      location.href="index.jsp";
    </script>
<%
  }
  User findUser = User.findUser(loginUserId);
  if (findUser == null) {
%>
    <script>
      alert("잘못된 접근입니다");
      location.href="index.jsp";
    </script>
<%
  }

  // 웹툰 ID를 쿼리파라미터로 넘겨받습니다.
  Integer webtoonId = Integer.parseInt(request.getParameter("id"));
  Webtoon findWebtoon = Webtoon.findById(webtoonId);
  ResultSet rs = null;

  try {
    // 해당 웹툰에 대한 모든 회차를 DB에서 조회합니다.
    Connection connection = DbConnect.dbConnect();
    String query = "select * from episode where wtn_id=? order by epi_id";
    PreparedStatement pstmt = connection.prepareStatement(query);
    pstmt.setInt(1, webtoonId);
    rs = pstmt.executeQuery();


%>

<html lang="ko">
<head>

  <title>Episode Management</title>
  <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
  <div class="sub-title-box">
    <a class="sub-title" href="index.jsp">Webtoomee</a>
  </div>
  <div class="main-title-box">
    <span class="main-title">회차 관리</span>
  </div>
  <div class="title-bar-menu">
    <div>
          <span
          ><a href="myPage.jsp"><img src="icons/user.png" /></a
          ></span>
      <div><%=findUser.getUserName()%>님 <br />웹툰 작가</div>
    </div>
  </div>
</div>
<!-- title-bar -->

<!-- add new webtoon -->
<div class="add-new-webtoon-bar">
      <span
      ><a href="addEpisode.jsp?id=<%=webtoonId%>"><img src="icons/circle-plus-solid.svg" /></a
      ></span>
  <span>연재하기</span>
</div>
<!-- add new webtoon -->

<div class="underlined-title-box">
  <span><%=findWebtoon.getWebtoonTitle()%></span>
</div>

<!-- webtoon title -->
<%
  while (rs.next()) {
    Double rating = Episode.getRating(rs.getInt("epi_id"));
%>
<div class="webtoon-management-title">
      <span
      ><a href="webtoon.jsp?id=<%=rs.getInt("epi_id")%>"
      ><img width="125" height="137" src="./images/<%=rs.getString("epi_thb")%>" /></a
      ></span>
  <div class="webtoon-management-description-box">
    <div class="webtoon-management-description">
      <%=rs.getString("epi_title")%><br />
      <%=rs.getString("created_at")%><br />
      <span>
        <%
          switch ((int) Math.floor(rating)) {
            case 0:
        %>
        <img width="15" height="15" src="icons/empty_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <%
            break;
          case 1:
        %>
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <%
            break;
          case 2:
        %>
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <%
            break;
          case 3:
        %>
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <%
            break;
          case 4:
        %>
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/empty_star.ico" />
        <%
            break;
          case 5:
        %>
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/full_star.ico" />
        <img width="15" height="15" src="icons/full_star.ico" />
        <%
              break;
          }
        %>
        <%=rating%>
      </span>
    </div>

    <div class="add-edit-bar">
      <div>
        <div>
          <a href="addEpisode.jsp?id=<%=webtoonId%>&epi_id=<%=rs.getInt("epi_id")%>"><img src="icons/pen-solid.svg" /></a>
        </div>
        <div>수정</div>
      </div>
      <div>
        <button style="background-color: antiquewhite" onclick="
                if(confirm('해당 회차를 삭제하시겠습니까?')) {
                  location.href='deleteEpisode.jsp?id=<%=rs.getString("epi_id")%>';
                }
        ">
          <img src="icons/trash-can-solid.svg" />
        </button>
        <div>삭제</div>
      </div>
    </div>
  </div>
</div>
<%
  }
%>


<!-- webtoon title -->
</body>
</html>

<%
  rs.close();
  pstmt.close();
  connection.close();
  }
  catch (Exception e) {
    e.printStackTrace();
  }

%>
