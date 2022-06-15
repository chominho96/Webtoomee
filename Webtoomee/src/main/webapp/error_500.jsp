<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%
    /**
     *  error_500.jsp
     *  500 에러에 대한 에러 페이지입니다.
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
    <img src="icons/error-500.png" />
    <h1 id="error-h1">죄송합니다. 알 수 없는 오류가 발생했습니다.</h1>
    <button id="error-btn" onclick="location.href='index.jsp'">메인 페이지로 돌아가기</button>
</div>
</body>
</html>
