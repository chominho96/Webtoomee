<%@ page import="com.example.login.Login" %>
<%@ page import="com.example.login.LoginForm" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    /**
     *  login_do.jsp
     *  로그인에 대한 로직을 담당합니다.
     */

    // ID와 password를 form으로 넘겨받습니다.
    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");

    // 로그인에 성공했을 경우 true, 실패했을 경우 false를 넘겨받습니다.
    boolean loginResult = Login.login(response, session, new LoginForm(loginId, password));
    // 로그인에 성공한 경우
    if (loginResult) {
        response.sendRedirect("index.jsp");
    }
    // 로그인에 실패한 경우
    else {
%>
    <script>
        alert("아이디 또는 비밀번호가 일치하지 않습니다");
        history.back();
    </script>
<%
    }
%>
