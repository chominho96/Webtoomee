<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer loginUserId = LoginUser.getLoginUser(request, session);
    if (loginUserId == null) {
%>
        <script>
            alert("로그인 후 이용해주세요");
            location.href = "login.jsp";
        </script>
<%
    }
    User findUser = User.findUser(loginUserId);
    String userType = "";
    if (findUser == null) {
%>
        <script>
            alert("로그인 후 이용해주세요");
            location.href = "login.jsp";
        </script>
<%
    }

    switch (findUser.getUserType()) {
        case "user":
            userType = "사용자님";
            break;
        case "author":
            userType = "작가님";
            break;
        default:
            userType = "관리자님";
            break;
    }
%>
<html>
<head>
    <title>마이 페이지</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
    <div class="sub-title-box">
        <a class="sub-title" href="index.jsp">Webtoomee</a>
    </div>
    <div class="main-title-box">
        <a class="main-title" href="myPage.jsp">마이 페이지</a>
    </div>
    <div class="title-bar-menu">
    </div>
</div>
<!-- title-bar -->
<div id="my-page-box">
    <div class="my-page-inner-box">
        <div class="underlined-title-box">
            <span><%=findUser.getUserName()%> <%=userType%></span>
        </div>

        <div>ID</div>
        <div class="underlined-title-box">
            <span><%=findUser.getUserLoginId()%></span>
        </div>
        <%
            if (userType.equals("작가님")) {
        %>
        <span>연재 중인 웹툰</span>
        <%
            List<Webtoon> webtoonList = Webtoon.getAllWebtoonByUser(findUser.getUserId());
            if (webtoonList != null) {
                for (Webtoon webtoon : webtoonList) {
        %>
        <img width="125" height="137" src="./images/<%=webtoon.getWebtoonFileName()%>">
        <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <%
                    }
                }
            }
        %>
        <br>
        <br>
        <br>
        <br>
        <div>
            <div id="my-page-delete-box">
                <div></div>
                <button onclick="
            if(confirm('정말 탈퇴하시겠습니까?')) {
            location.href='deleteUser.jsp';
            }">
                    회원 탈퇴
                </button>
            </div>
        </div>
    </div>



</div>



</body>
</html>
