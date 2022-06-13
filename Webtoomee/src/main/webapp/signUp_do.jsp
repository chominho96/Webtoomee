<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    boolean isAuthor = false;
    try {
        String requestAuthor = request.getParameter("isAuthor");
        if (requestAuthor.equals("true")) {
            isAuthor = true;
        }
    }
    catch (Exception ignored) { }

    try {
        Class.forName("org.mariadb.jdbc.Driver");

        // TODO : 이름 변경
        //String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
        String DB_URL = "jdbc:mariadb://localhost:3307/webtoon?useSSL=false";

        // TODO : 이름 변경
        //String DB_USER = "admin";
        //String DB_PASSWORD= "1234";
        String DB_USER = "root";
        String DB_PASSWORD = "whalsgh9664!";
        // TODO : 이름 변경

        Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); // 연결자 획득

        // 1. ID 중복체크
        String query = "select count(user_id) as 'count' from user where user_login_id = ?";
        PreparedStatement pstmt = con.prepareStatement(query);
        pstmt.setString(1, loginId);
        ResultSet rs = pstmt.executeQuery();

        rs.next();
        int count = rs.getInt("count");
        if (count >= 1)  {
%>
            <script>
                alert("ID가 중복되었습니다. 다시 시도해주세요.");
                history.back();
            </script>
<%
        }


        // 2. 회원 생성
        query = "insert into user(user_type, user_name, user_login_id, user_pwd, created_at) values(?, ?, ?, ?, ?)";
        pstmt = con.prepareStatement(query);
        if (isAuthor) {
            pstmt.setString(1, "author");
        }
        else {
            pstmt.setString(1, "user");
        }
        pstmt.setString(2, name);
        pstmt.setString(3, loginId);
        pstmt.setString(4, password);
        pstmt.setString(5, String.valueOf(LocalDateTime.now()));
        pstmt.executeUpdate();

        response.sendRedirect("login.jsp");

    } catch (Exception e) { e.printStackTrace(); }

%>
