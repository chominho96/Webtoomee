<%@ page import="com.example.webtoon.Episode" %>
<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer episodeId = null;
    try {
        episodeId = Integer.parseInt(request.getParameter("id"));
    }
    catch (Exception e) {%>
        <script>
            alert("잘못된 접근입니다");
            location.href = "index.jsp";
        </script>
<%
    }

    Episode episode = Episode.findById(episodeId);
    String loginUserName = "로그인";
    String userType = "";
    boolean isLogin = false;

    Integer loginUser = LoginUser.getLoginUser(request, session);
    if (loginUser != null) {
        isLogin = true;
        User findUser = User.findUser(loginUser);
        loginUserName = findUser.getUserName() + "님";

        switch (findUser.getUserType()) {
            case "author":
                userType = "웹툰 작가";
                break;
            case "admin":
                userType = "관리자";
                break;
            default:
                break;
        }
    }
%>

<html lang="ko">
<head>
    <title>webtoon</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
    <div class="sub-title-box">
        <a class="sub-title" href="index.jsp">Webtoomee</a>
    </div>
    <div class="main-title-box">
        <a class="main-title" href="webtoon.jsp?id=<%=episodeId%>"><%=episode.getEpisodeTitle()%></a>
    </div>
    <div class="title-bar-menu">
        <div>
          <span>
              <%
                  if (isLogin) {
                      %>
                    <a href="myPage.jsp"><img src="icons/user.png" /></a>
              <%
                  }
                  else {
              %>
                    <a href="login.jsp"><img src="icons/user.png" /></a>
              <%
                  }
              %>

          </span>
            <div><%=loginUserName%> <br /><%=userType%></div>
        </div>
    </div>
</div>
<!-- title-bar -->

<!-- episode -->
<div class="episode-box">
    <div class="single-episode">
        <img src="./images/<%=episode.getEpisodeThumbnail()%>" />
        <div>
            <%=episode.getEpisodeTitle()%><br />
            <%=episode.getCreatedAt().toString().substring(0, 10)%><br />
        </div>
    </div>
</div>
<!-- episode -->

<!-- navigation bar -->
<div class="navigation-bar">
      <span
      ><a href="#"><img src="icons/arrow-up-long-solid.svg" /></a
      ></span>
    <div>top<br />bottom</div>
    <span
    ><a href="#bottom"><img src="icons/arrow-down-long-solid.svg" /></a
    ></span>
    <button onclick="
            if(confirm('해당 웹툰을 신고하시겠습니까?')) {
            location.href='reportEpisode.jsp?id=<%=episodeId%>';
            }">
        <img src="icons/신고.png" />
    </button>

    <div>신고</div>
</div>
<!-- navigation bar -->

<!-- webtoon -->
<div class="webtoon-main">
    <img src="./images/<%=episode.getEpisodeFile()%>" />
</div>
<!-- webtoon -->

<!-- review / rating -->
<div class="review-and-rating" id="bottom">
    <div>해당 회차에 별점을 매겨주세요!</div>
    <div>
        <form method="get" action="addRating.jsp">
            <input type="radio" id="star-1" name="star-1" value="1" />
            <label for="star-1">★</label>
            <input type="radio" id="star-2" name="star-2" value="2" />
            <label for="star-2">★★</label>
            <input type="radio" id="star-3" name="star-3" value="3" />
            <label for="star-3">★★★</label>
            <input type="radio" id="star-4" name="star-4" value="4" />
            <label for="star-4">★★★★</label>
            <input type="radio" id="star-5" name="star-5" value="5" />
            <label for="star-5">★★★★★</label>
            <input type="text" id="episode-id" name="id" value="<%=episodeId%>" hidden />
            <button type="submit">✔</button>
        </form>
    </div>
</div>
<!-- review / rating -->
</body>
</html>

