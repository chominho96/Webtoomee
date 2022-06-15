<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    /**
     *  signUp_do.jsp
     *  회원가입에 대한 로직 처리를 담당합니다.
     */


    // 회원가입 정보 (로그인ID, 비밀번호, 이름)를 넘겨받습니다.
    String loginId = request.getParameter("loginId");
    String password = request.getParameter("password");
    String name = request.getParameter("name");

    // 웹툰 작가일 경우, isAuthor을 포함해서 보냅니다. 따라서 이를 확인합니다.
    boolean isAuthor = false;
    try {
        String requestAuthor = request.getParameter("isAuthor");
        if (requestAuthor.equals("true")) {
            isAuthor = true;
        }
    }
    catch (Exception ignored) { }

    try {
        Connection connection = DbConnect.dbConnect();

        // 1. ID 중복체크
        String query = "select count(user_id) as 'count' from user where user_login_id = ?";
        PreparedStatement pstmt = connection.prepareStatement(query);
        pstmt.setString(1, loginId);
        ResultSet rs = pstmt.executeQuery();

        rs.next();
        // 이미 존재하는 ID일 경우
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
        pstmt = connection.prepareStatement(query);
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

        pstmt.close();
        connection.close();

        response.sendRedirect("login.jsp");

    } catch (Exception e) { e.printStackTrace(); }

%>
