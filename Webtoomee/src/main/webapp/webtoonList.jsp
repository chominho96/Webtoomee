<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    /**
     *  webtoonList.jsp
     *  전체 웹툰 / 장르별 웹툰 / 작가별 웹툰에 대한 페이지입니다.
     */


    String sortBy = null;
    // 정렬 방식입니다. 전체, 장르별, 작가별로 정렬할 수 있습니다.
    try {
        sortBy = request.getParameter("by");
    }
    catch (Exception ignore) { }


    // 로그인한 유저에 대해 표시하기 위해 로그인 여부를 확인합니다.
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
                // 웹툰 작가일 경우 웹툰 관리 페이지로 이동되는 버튼을 출력합니다.
                if (isLogin) {
                    if (userType.equals("웹툰 작가")) {

                    %>
                    %>
                    <span>
                        <a href="webtoonManagement.jsp"><img src="icons/pen-to-square-solid.svg" /></a>
                    </span>
                        <div>웹툰 관리</div>
            <%
                    }
                    else if (userType.equals("관리자")) {
                        %>
                    <span>
                        <a href="adminManagement.jsp">
                            <img src="icons/pen-to-square-solid.svg" />
                        </a>
                    </span>
            <div>웹툰 관리 (관리자)</div>
            <%
                    }
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

    <form method="get" action="searchWebtoon.jsp" id="frm">
        <div class="search-bar">
            <input name="value" type="text" placeholder="search..." />
            <a href="javascript:document.getElementById('frm').submit()"><img src="icons/magnifying-glass-solid.svg" width="13" height="13"/>
            </a>
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
            <div class="webtoon-list">
<%
            for (Webtoon webtoon : allWebtoon) {
                Integer rating = (int) Math.floor(Webtoon.getRating(webtoon.getWebtoonId()));

%>

                    <div class="single-webtoon">
                        <span><a href="episodeList.jsp?id=<%=webtoon.getWebtoonId()%>">
                            <img src="./images/<%=webtoon.getWebtoonFileName()%>" /></a>
                        </span>
                        <div><%=webtoon.getWebtoonTitle()%><br />
                            <%=User.findUser(webtoon.getAuthorId()).getUserName()%><br />
                            <%=webtoon.getWebtoonGenre()%></div>
                        <%
                            switch (rating) {
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
                    </div>

<%
            }
%>
            </div>
<%

        }
    }
    // 작가별로 정렬할 경우, Map<작가 ID, 웹툰 리스트> 의 형식으로 모든 웹툰을 불러오고, 이에 대해 출력합니다.
    else if (sortBy.equals("author")) {
        Map<Integer, List<Webtoon>> webtoonByAuthor = Webtoon.findAllByAuthor();
        if (webtoonByAuthor != null) {
            Set<Integer> keySet = webtoonByAuthor.keySet();

            for (Integer currentId : keySet) {
%>
                <div class="underlined-title-box">
                    <span><%=User.findUser(currentId).getUserName()%>님의 웹툰</span>
                </div>
                <div class="webtoon-list">
<%
                List<Webtoon> currentWebtoonList = webtoonByAuthor.get(currentId);

                for (Webtoon webtoon : currentWebtoonList) {
                    Integer rating = (int) Math.floor(Webtoon.getRating(webtoon.getWebtoonId()));
%>

                        <div class="single-webtoon">
                        <span><a href="episodeList.jsp?id=<%=webtoon.getWebtoonId()%>">
                            <img src="./images/<%=webtoon.getWebtoonFileName()%>" /></a>
                        </span>
                            <div><%=webtoon.getWebtoonTitle()%><br />
                            <%=User.findUser(webtoon.getAuthorId()).getUserName()%><br />
                                <%=webtoon.getWebtoonGenre()%></div>
                            <%
                                switch (rating) {
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
                        </div>

<%
                }
%>
                </div>
<%

            }
        }
    }

    // 장르별로 정렬할 경우, Map<장르, 웹툰 리스트> 와 같은 형식으로 모든 웹툰을 불러오고, 이에 대해 출력합니다.
    else {
        Map<String, List<Webtoon>> webtoonByGenre = Webtoon.findAllByGenre();
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
                <div class="webtoon-list">
<%
                List<Webtoon> currentWebtoonList = webtoonByGenre.get(currentGenre);

                for (Webtoon webtoon : currentWebtoonList) {
                    Integer rating = (int) Math.floor(Webtoon.getRating(webtoon.getWebtoonId()));
%>

                        <div class="single-webtoon">
                            <span><a href="episodeList.jsp?id=<%=webtoon.getWebtoonId()%>">
                                <img src="./images/<%=webtoon.getWebtoonFileName()%>" /></a>
                            </span>
                            <div><%=webtoon.getWebtoonTitle()%><br />
                                <%=User.findUser(webtoon.getAuthorId()).getUserName()%><br />
                                <%=webtoon.getWebtoonGenre()%></div>
                            <%
                                switch (rating) {
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
                        </div>

<%
                }
%>
                </div>
<%
            }
        }
    }
%>


<!-- webtoon list -->
</body>
</html>

