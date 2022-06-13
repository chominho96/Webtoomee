<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String username = null;
    List<Webtoon> allWebtoon = null;

    Integer loginUserId = LoginUser.getLoginUser(request, session);
    if (loginUserId == null) {
%>
<script>
    alert("로그인해주세요");
    location.href="login.jsp";
</script>
<%
    }
    else {
        User findUser = User.findUser(loginUserId);
        if (findUser == null || findUser.getUserType().equals("user")) {
%>
<script>
    alert("웹툰 작가만 접근할 수 있습니다.");
    location.href="index.jsp";
</script>
<%
        }
        else {
            username = findUser.getUserName();
            allWebtoon = Webtoon.getAllWebtoonByUser(findUser.getUserId());
        }
    }

%>

<html lang="ko">
<head>
    <title>Webtoon Management</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
    <div class="sub-title-box">
        <a class="sub-title" href="index.jsp">Webtoomee</a>
    </div>
    <div class="main-title-box">
        <a class="main-title" href="webtoonManagement.jsp">웹툰 관리</a>
    </div>
    <div class="title-bar-menu">
        <div>
          <span
          ><a href="myPage.jsp"><img src="icons/user.png" /></a
          ></span>
            <div><%=username%>님 <br />웹툰 작가</div>
        </div>
    </div>
</div>
<!-- title-bar -->

<!-- add new webtoon -->
<div class="add-new-webtoon-bar">
      <span
      ><a href="addNewWebtoon_temp.jsp"
      ><img src="icons/circle-plus-solid.svg" /></a
      ></span>
    <span>새 웹툰 연재 시작하기</span>
</div>
<!-- add new webtoon -->

<div class="underlined-title-box">
    <span><%=username%>님의 웹툰</span>
</div>

<!-- webtoon title -->
<%
    for (Webtoon webtoon : allWebtoon) {
        Double rating = Webtoon.getRating(webtoon.getWebtoonid());
%>
<div class="webtoon-management-title">
      <span
      ><a href="episodeManagement.jsp?id="
      ><img src="images/<%=webtoon.getWebtoonThumbnailAddr()%>>" /></a
      ></span>
    <div class="webtoon-management-description-box">
        <div class="webtoon-management-description">
            <%=webtoon.getWebtoonTitle()%><br />
            <%=username%><br />
            <%=webtoon.getWebtoonGenre()%><br />
            <span><img src="icons/별점.png" /><%=rating%></span>
        </div>

        <div class="add-edit-bar">
            <div>
                <div>
                    <a href="addEpisode.jsp?id=<%=webtoon.getWebtoonid()%>"><img src="icons/plus-solid.svg" /></a>
                </div>
                <div>회차 연재</div>
            </div>
            <div>
                <div>
                    <a href="addNewWebtoon_temp.jsp"><img src="icons/pen-solid.svg" /></a>
                </div>
                <div>정보 수정</div>
            </div>
            <div>
                <button
                        onclick="
                        if(confirm('해당 웹툰을 삭제하시겠습니까?')) {
                            location.href='deleteWebtoon.jsp?id=<%=webtoon.getWebtoonid()%>';
                        }
                        ">
                    <img src="icons/trash-can-solid.svg" />
                </button>
                <div>웹툰 삭제</div>
            </div>
        </div>
    </div>
</div>
<!-- webtoon title -->
<%
    }
%>
</body>
</html>
