<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sign Up</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
    <div class="sub-title-box">
        <a class="sub-title" href="index.jsp">Webtoomee</a>
    </div>
    <div class="main-title-box">
        <a class="main-title" href="signUp.jsp">회원 가입</a>
    </div>
    <div>
    </div>
</div>
<!-- title-bar -->

<div class="login-input-box">
    <div class="login-form">
        <form method="post" action="signUp_do.jsp" >
            <div class="login-input">
                <h2>아이디 / ID</h2>
                <input type="text" id="loginId" name="loginId" required />
                <input type="button" class="login-submit" value="ID 중복체크"
                       onclick="window.open('idDuplicateCheck.jsp?' + document.getElementById('loginId').value,
                       '_blank', 'width=500, height=300, resizable=no, scrollbars=no')"
                />

                <h2>비밀번호 / Password</h2>
                <input type="password" id="password" name="password" required />
                <h2>이름</h2>
                <input type="text" id="name" name="name" required />
                <br>
                <span>웹툰을 그리시는 작가이신가요? </span>
                <input type="checkbox" id="isAuthor" name="isAuthor" value="true">
                <br>
                <br>
                <input type="submit" class="login-submit" value="회원가입" />

            </div>
        </form>
    </div>

</div>

</body>
</html>
