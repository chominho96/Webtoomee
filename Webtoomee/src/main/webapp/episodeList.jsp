<%@ page import="com.example.webtoon.Episode" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    /**
     *  episodeList.jsp
     *  특정 웹툰에 대해 모든 회차를 보여주는 페이지입니다.
     */

    // 웹툰 ID를 쿼리 파라미터로 넘겨받습니다.
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

    // 넘겨받은 웹툰 ID에 대해 해당하는 웹툰 객체를 반환합니다.
    Webtoon findWebtoon = Webtoon.findById(webtoonId);
    List<Episode> episodeList = Episode.findAllByWebtoon(webtoonId);

    // 해당 웹툰의 평균 평점을 조회합니다.
    Double rating = Math.floor(Webtoon.getRating(webtoonId));


    // 상단에 표시되는 사용자 정보를 위해, 로그인 여부를 판단합니다.
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
        <a class="main-title" href="episodeList.jsp?id=<%=webtoonId%>"><%=findWebtoon.getWebtoonTitle()%></a>
    </div>
    <div class="title-bar-menu">
        <div>
          <span>
              <%
                  // 로그인된 경우, 마이페이지로 연결하고, 비로그인의 경우 로그인 페이지로 이동할 수 있게 합니다.
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
                // 로그인된 사용자가 웹툰 작가일 경우, 웹툰 관리로 연결되는 버튼을 생성합니다.
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
    <form method="get" action="searchWebtoon.jsp" id="frm">
        <div class="search-bar">
            <input name="value" type="text" placeholder="search..." />
            <a href="javascript:document.getElementById('frm').submit()"><img src="icons/magnifying-glass-solid.svg" width="13" height="13"/>
            </a>
        </div>
    </form>
</div>
<!-- search bar -->

<!-- webtoon title -->
<div class="episode-list-webtoon-title">
    <img width="135" height="150" src="./images/<%=findWebtoon.getWebtoonFileName()%>" />
    <div class="webtoon-description">
        <div>
            <%=findWebtoon.getWebtoonTitle()%><br />
            <%=User.findUser(findWebtoon.getAuthorId()).getUserName()%><br />
            <%=findWebtoon.getWebtoonGenre()%><br />
            <span>
                <%
                    switch ((int)((double) rating)) {
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
      <span>
          <a href="webtoon.jsp?id=<%=episode.getEpisodeId()%>"><img width="135" height="150" src="./images/<%=episode.getEpisodeThumbnail()%>" /></a>
      </span>

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
