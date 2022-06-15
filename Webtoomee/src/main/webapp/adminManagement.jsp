<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%

    /**
     *  adminManagement.jsp
     *  (관리자 전용) 웹툰 작가 전용 페이지로, 웹툰 관리를 담당하는 페이지입니다.
     *  ㄷ
     */


    // 로그인한 작가 정보를 불러옵니다.
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
// 해당 사용자의 분류가 작가가 맞는지 확인합니다.
else {
    User findUser = User.findUser(loginUserId);
    if (findUser == null || !findUser.getUserType().equals("admin")) {
%>
<script>
    alert("관리자만 접근할 수 있습니다.");
    location.href="index.jsp";
</script>
<%
        }
        // 모든 웹툰을 불러옵니다.
        else {
            username = "관리자";
            allWebtoon = Webtoon.findAll();
        }
    }

%>

<html lang="ko">
<head>
    <title>관리자 웹툰 관리 페이지</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
    <div class="sub-title-box">
        <a class="sub-title" href="index.jsp">Webtoomee</a>
    </div>
    <div class="main-title-box">
        <a class="main-title" href="adminManagement.jsp">웹툰 관리 (Admin)</a>
    </div>
    <div class="title-bar-menu">
        <div>
          <span
          ><a href="myPage.jsp"><img src="icons/user.png" /></a
          ></span>
            <div><%=username%>님 <br /></div>
        </div>
    </div>
</div>
<!-- title-bar -->


<div class="underlined-title-box">
    <span>전체 웹툰</span>
</div>

<!-- webtoon title -->
<%
    // 불러온 모든 웹툰에 대해 출력합니다.
    for (Webtoon webtoon : allWebtoon) {
        Double rating = Webtoon.getRating(webtoon.getWebtoonId());
        Integer reportNum = Webtoon.getReportNum(webtoon);
%>
<div class="webtoon-management-title">
      <span><a href="adminWebtoon.jsp?id=<%=webtoon.getWebtoonId()%>">
          <img width="100" height="100" src="./images/<%=webtoon.getWebtoonFileName()%>" /></a>
      </span>
    <div class="webtoon-management-description-box">
        <div>
            <div class="webtoon-management-description">
                <%=webtoon.getWebtoonTitle()%><br />
                <%=User.findUser(webtoon.getAuthorId()).getUserName()%><br />
                <%=webtoon.getWebtoonGenre()%><br />
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
                    <%=rating%></span>
            </div>
            <div><img width="50" height="50" src="./icons/신고.png" />신고 수 : <%=reportNum%></div>
        </div>

        <div class="add-edit-bar">
            <div>
                <button
                        style="background-color: antiquewhite"
                        onclick="
                                if(confirm('해당 웹툰을 삭제하시겠습니까?')) {
                                location.href='deleteWebtoon.jsp?id=<%=webtoon.getWebtoonId()%>';
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
