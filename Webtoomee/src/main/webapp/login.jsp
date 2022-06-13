<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>

<!-- title-bar -->
<div class="title-bar">
    <div class="sub-title-box">
        <a class="sub-title" href="index.html">Webtoomee</a>
    </div>
    <div class="main-title-box">
        <a class="main-title" href="episodeList.html">로그인</a>
    </div>
    <div>
    </div>
</div>
<!-- title-bar -->
<div class="login-input-box">
    <div class="login-form">
        <form method="post" action="login_do.jsp" >
            <div class="login-input">
                <h2>아이디 / ID</h2>
                <input type="text" id="loginId" name="loginId" required />

                <h2>비밀번호 / Password</h2>
                <input type="password" id="password" name="password" required />
                <br>
                <input type="submit" class="login-submit" value="로그인" />
            </div>
        </form>
        <span>Webtoomee에 처음 방문하셨나요?</span>
        <input type="button" class="login-submit" value="회원가입" onclick="location.href='signUp.jsp'"/>
    </div>

</div>



</body>
</html>
