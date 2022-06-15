<%@ page import="java.sql.*" %>
<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    /**
     *  idDuplicateCheck.jsp
     *  회원 가입시, ID 중복체크에 대한 페이지입니다.
     */

    // 체크하고자 하는 ID를 쿼리 파라미터로 넘겨받습니다.
    String loginId = request.getParameter("loginId");
    boolean isDuplicate = false;

    try {

        // 기존에 해당 ID를 가진 사용자가 있는지를 DB에서 확인합니다.
        Connection connection = DbConnect.dbConnect();
        String query = "select count(user_id) as 'count' from user where user_login_id = ?";
        PreparedStatement pstmt = connection.prepareStatement(query);
        pstmt.setString(1, loginId);
        ResultSet rs = pstmt.executeQuery();
        rs.next();
        int count = rs.getInt("count");

        // ID가 중복된 경우
        if (count >= 1) {
            isDuplicate = true;
        }

        rs.close();
        pstmt.close();
        connection.close();
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
