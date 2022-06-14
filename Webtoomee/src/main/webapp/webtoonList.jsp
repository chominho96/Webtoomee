<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String sortBy = null;
    try {
        sortBy = request.getParameter("by");
    }
    catch (Exception ignore) { }

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
    <title>webtoonList</title>
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
              <a href="myPage.jsp"><img src="icons/user.png" /></a>
          </span>
            <div><%=loginUserName%><br /><%=userType%></div>
        </div>
        <div>
            <%
                if (isLogin) {
                    %>
                    <span>
                        <a href="webtoonManagement.jsp"><img src="icons/pen-to-square-solid.svg" /></a>
                    </span>
                        <div>웹툰 관리</div>
            <%
                }
            %>
        </div>
    </div>
</div>
<!-- title-bar -->

<!-- filter / search bar -->
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
<%
    if (sortBy == null) {
        List<Webtoon> allWebtoon = Webtoon.findAll();
        if (allWebtoon != null) {
%>
            <div class="underlined-title-box">
                <span>전체 웹툰</span>
            </div>
<%
            for (Webtoon webtoon : allWebtoon) {

%>
                <div class="webtoon-list">
                    <div class="single-webtoon">
                        <span><a href="episodeList.jsp?id=<%=webtoon.getWebtoonId()%>">
                            <img src="./images/<%=webtoon.getWebtoonFileName()%>" /></a>
                        </span>
                        <div><%=webtoon.getWebtoonTitle()%><br />
                            <%=User.findUser(webtoon.getAuthorId()).getUserName()%><br />
                            <%=webtoon.getWebtoonGenre()%></div>
                        <img class="rating" src="icons/별점.png" />
                    </div>
                </div>
<%
            }
        }
    }
    else if (sortBy.equals("author")) {
        Map<Integer, List<Webtoon>> webtoonByAuthor = Webtoon.findByAuthor();
        if (webtoonByAuthor != null) {
            Set<Integer> keySet = webtoonByAuthor.keySet();

            for (Integer currentId : keySet) {
%>
                <div class="underlined-title-box">
                    <span><%=User.findUser(currentId).getUserName()%>님의 웹툰</span>
                </div>
<%
                List<Webtoon> currentWebtoonList = webtoonByAuthor.get(currentId);

                for (Webtoon webtoon : currentWebtoonList) {
%>
                    <div class="webtoon-list">
                        <div class="single-webtoon">
                        <span><a href="episodeList.jsp?id=<%=webtoon.getWebtoonId()%>">
                            <img src="./images/<%=webtoon.getWebtoonFileName()%>" /></a>
                        </span>
                            <div><%=webtoon.getWebtoonTitle()%><br />
                            <%=User.findUser(webtoon.getAuthorId()).getUserName()%><br />
                                <%=webtoon.getWebtoonGenre()%></div>
                            <img class="rating" src="icons/별점.png" />
                        </div>
                    </div>
<%
                }

            }
        }
    }

    else {
        Map<String, List<Webtoon>> webtoonByGenre = Webtoon.findByGenre();
        if (webtoonByGenre != null) {
            Set<String> keySet = webtoonByGenre.keySet();

            for (String currentGenre : keySet) {
                String genre = "";
                switch (currentGenre) {
                    case "daily":
                        genre = "일상";
                        break;
                    case "comic":
                        genre = "개그";
                        break;
                    case "fantasy":
                        genre = "판타지";
                        break;
                    default:
                        genre = "액션";
                        break;
                }
%>
                <div class="underlined-title-box">
                    <span><%=genre%> 장르의 웹툰</span>
                </div>
<%
                List<Webtoon> currentWebtoonList = webtoonByGenre.get(currentGenre);

                for (Webtoon webtoon : currentWebtoonList) {
%>
                    <div class="webtoon-list">
                        <div class="single-webtoon">
                            <span><a href="episodeList.jsp?id=<%=webtoon.getWebtoonId()%>">
                                <img src="./images/<%=webtoon.getWebtoonFileName()%>" /></a>
                            </span>
                            <div><%=webtoon.getWebtoonTitle()%><br />
                                <%=User.findUser(webtoon.getAuthorId()).getUserName()%><br />
                                <%=webtoon.getWebtoonGenre()%></div>
                            <img class="rating" src="icons/별점.png" />
                        </div>
                    </div>
<%
                }
            }
        }
    }
%>


<!-- webtoon list -->
</body>
</html>

