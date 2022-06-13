<%@ page import="com.example.login.Login" %>
<%@ page import="com.example.login.LoginForm" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");

    boolean loginResult = Login.login(response, session, new LoginForm(loginId, password));
    if (loginResult) {
        response.sendRedirect("index.jsp");
    }
    else {
%>
    <script>
        alert("아이디 또는 비밀번호가 일치하지 않습니다");
        history.back();
    </script>
<%
    }
%>
