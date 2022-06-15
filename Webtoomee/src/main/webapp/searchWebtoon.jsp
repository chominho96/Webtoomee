<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    /**
     *  searchWebtoon.jsp
     *  웹툰 검색 결과에 대한 페이지입니다.
     */

    /**
     *  정렬 방식에 대해 선택합니다.
     *  author인 경우 작가별로 검색합니다.
     *  webtoon인 경우 웹툰별로 검색합니다.
     *
     *  기본적으로 index.jsp 등의 다른 페이지에서의 검색을 통해 들어오게 되면, by 파라미터를 넣지 않을 채로 들어오게 됩니다.
     *  이 때 기본적으로 작가별로 먼저 선택되어 검색이 이루어집니다.
     */
    String sortBy = null;
    try {
        sortBy = request.getParameter("by");
    }
    catch (Exception ignore) {
        sortBy = "author";
    }
    if (sortBy == null) {
        sortBy = "author";
    }

    // 로그인된 사용자별로 다르게 출력하기 위해 사용자 분류를 확인합니다.
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

    // 검색 결과에 해당하는 값을 넘겨받습니다.
    String searchValue = null;
    try {
        searchValue = request.getParameter("value");
    }
    catch (Exception e) {
%>
        <script>
            alert("잘못된 접근입니다");
            history.back();
        </script>
<%
    }
%>

<html lang="ko">
<head>
  <title>검색 결과</title>
  <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
  <div class="sub-title-box">
    <a class="sub-title" href="index.jsp">Webtoomee</a>
  </div>
  <div class="main-title-box">
    <span class="main-title">검색 결과</span>
  </div>
  <div class="title-bar-menu">
    <div>
          <span>
            <%
                  // 로그인된 경우 마이페이지, 비로그인의 경우 로그인 페이지로 연결됩니다.
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
          // 해당 사용자가 웹툰 작가일 경우 웹툰 관리에 대한 버튼을 생성합니다.
          if (userType.equals("웹툰 작가")) {
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
    <span>
        <a href="searchWebtoon.jsp?by=author&value=<%=searchValue%>"
        style="<%
            // 현재 작가별 검색일 경우 "작가"에 색깔이 칠해집니다.
            if (sortBy.equals("author")) {
                %>
                color: darkgoldenrod;
                <%
            }
        %>">작가</a>
    </span>
    <span>
        <a href="searchWebtoon.jsp?by=webtoon&value=<%=searchValue%>"
           style="<%
            // 현재 웹툰별 검색일 경우 "웹툰"에 색깔이 칠해집니다.
            if (sortBy.equals("webtoon")) {
                %>
                   color: darkgoldenrod;
               <%
            }
        %>">웹툰</a>
    </span>
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
  if (sortBy.equals("author")) {
        // 검색한 키워드가 이름에 포함되는 작가를 검색합니다.
        List<Webtoon> webtoonList = Webtoon.findByAuthor(searchValue);
        if (webtoonList != null) {
%>
<div class="underlined-title-box">
  <span><%=searchValue%> 작가에 대한 검색 결과</span>
</div>
<div class="webtoon-list">
<%
                // 검색 결과를 바탕으로 출력합니다.
                for (Webtoon webtoon : webtoonList) {
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
else if (sortBy.equals("webtoon")) {
        // 키워드가 포함되는 웹툰 이름을 검색합니다.
        List<Webtoon> webtoonList = Webtoon.findByName(searchValue);
        if (webtoonList != null) {
%>
<div class="underlined-title-box">
    <span><%=searchValue%> 웹툰에 대한 검색 결과</span>
</div>
<div class="webtoon-list">
<%
                // 검색 결과를 출력합니다.
                for (Webtoon webtoon : webtoonList) {
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
%>
<!-- webtoon list -->
</body>
</html>

