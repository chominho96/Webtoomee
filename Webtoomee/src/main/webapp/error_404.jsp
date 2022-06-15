<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%
    /**
     *  error_404.jsp
     *  404 에러에 대한 에러페이지입니다.
     */
    exception.printStackTrace();
%>
<html>
<head>
    <title>에러</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<div id="error-div">
    <img src="icons/error-404.png" />
    <h1 id="error-h1">요청하신 페이지를 찾을 수 없습니다.</h1>
    <button id="error-btn" onclick="location.href='index.jsp'">메인 페이지로 돌아가기</button>
</div>
</body>
</html>
