<%@ page import="com.example.webtoon.Episode" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer webtoonId = null;
    try {
        webtoonId = Integer.parseInt(request.getParameter("id"));
    }
    catch (Exception e) {
%>
        <script>
            alert("잘못된 접근입니다");
            location.href="index.jsp";
        </script>
<%
    }
    Webtoon findWebtoon = Webtoon.findById(webtoonId);
    List<Episode> episodeList = Episode.findAllByWebtoon(webtoonId);

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
    <title>episodeList</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
    <div class="sub-title-box">
        <a class="sub-title" href="index.jsp">Webtoomee</a>
    </div>
    <div class="main-title-box">
        <a class="main-title" href="episodeList.jsp?<%=webtoonId%>"><%=findWebtoon.getWebtoonTitle()%></a>
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
            <div><%=loginUserName%><br /><%=userType%></div>
        </div>
        <div>
            <%
                if(userType.equals("웹툰 작가")) {
                    %>
                    <span>
                        <a href="webtoonManagement.jsp">
                            <img src="icons/pen-to-square-solid.svg" />
                        </a>
                    </span>
                    <div>웹툰 관리</div>
            <%
                }
            %>

        </div>
    </div>
</div>
<!-- title-bar -->

<!-- search bar -->
<div class="search-bar-box">
    <form method="get" action="webtoonList.jsp">
        <div class="search-bar">
            <input type="text" name="search" placeholder="search..." />
            <button type="submit">
                <img src="icons/magnifying-glass-solid.svg" />
            </button>
        </div>
    </form>
</div>
<!-- search bar -->

<!-- webtoon title -->
<div class="episode-list-webtoon-title">
    <img src="./images/<%=findWebtoon.getWebtoonFileName()%>" />
    <div class="webtoon-description">
        <div>
            <%=findWebtoon.getWebtoonTitle()%><br />
            <%=User.findUser(findWebtoon.getAuthorId()).getUserName()%><br />
            <%=findWebtoon.getWebtoonGenre()%><br />
            <span><img src="icons/별점.png" /> <%=Webtoon.getRating(webtoonId)%></span>
        </div>
        <div>
            <%=findWebtoon.getWebtoonSummary()%><br />
            <%=findWebtoon.getWebtoonAuthorWord()%>
        </div>
    </div>
</div>
<!-- webtoon title -->

<!-- episode list -->
<%
    if (episodeList != null) {
        for (Episode episode : episodeList) {
%>
<div class="single-episode">
      <span
      ><a href="webtoon.jsp?id=<%=episode.getEpisodeId()%>"><img src="./images/<%=episode.getEpisodeThumbnail()%>" /></a
      ></span>

    <div>
        <%=episode.getEpisodeTitle()%><br />
        <%=episode.getCreatedAt().toString().substring(0, 10)%><br />
    </div>
</div>
<%
        }
    }
%>

<!-- episode list -->
</body>
</html>
