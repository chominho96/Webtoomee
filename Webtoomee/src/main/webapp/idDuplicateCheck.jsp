<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String loginId = request.getParameter("loginId");
    boolean isDuplicate = false;

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
        String query = "select count(user_id) as 'count' from user where user_login_id = ?";
        PreparedStatement pstmt = con.prepareStatement(query);
        pstmt.setString(1, loginId);
        ResultSet rs = pstmt.executeQuery();
        rs.next();
        int count = rs.getInt("count");
        if (count >= 1) {
            isDuplicate = true;
        }

        rs.close();
        pstmt.close();
        con.close();
    }
    catch (Exception ignored) {

    }

%>
<html>
<head>
    <title>ID 중복체크</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<div class="id-duplicate-box">
<%
    if (!isDuplicate) {
%>
    <div>사용 가능한 ID입니다.<br><br></div>
<%
    }
    else {
%>
    <div>중복된 ID입니다.<br><br></div>
<%
    }
%>
<div><input type="button" value="닫기" onclick="window.close()"></div>

</div>


</body>
</html>
