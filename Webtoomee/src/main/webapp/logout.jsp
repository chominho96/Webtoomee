<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String sessionId = null;

    Cookie[] cookies = request.getCookies();
    if (cookies.length != 0) {
        for (Cookie cookie : request.getCookies()) {
            if (cookie.getName().equals("id")) {
                sessionId = cookie.getValue();
                cookie.setMaxAge(0);
            }
        }
    }

    session.removeAttribute(sessionId);
%>
<script>
    alert("로그아웃 되었습니다.");
    location.href="index.jsp";
</script>

