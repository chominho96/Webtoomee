<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    /**
     *  logout.jsp
     *  로그아웃에 대한 로직을 담당합니다.
     */

    // 서버에 저장된 세션을 삭제하기 위해, 쿠키에서 세션ID를 받아옵니다.
    String sessionId = null;

    // 쿠키 조회
    Cookie[] cookies = request.getCookies();
    if (cookies.length != 0) {
        for (Cookie cookie : request.getCookies()) {
            if (cookie.getName().equals("id")) {
                sessionId = cookie.getValue();
                // 로그인 관련 쿠키를 삭제합니다.
                cookie.setMaxAge(0);
            }
        }
    }

    // 해당 세션을 삭제합니다.
    session.removeAttribute(sessionId);
%>
<script>
    alert("로그아웃 되었습니다.");
    location.href="index.jsp";
</script>

