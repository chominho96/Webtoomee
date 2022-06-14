<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer loginUserId = LoginUser.getLoginUser(request, session);
    if (loginUserId == null) {
%>
        <script>
            alert("로그인 후 이용해주세요.");
            location.href = "login.jsp";
        </script>
<%
    }
    User findUser = User.findUser(loginUserId);
    if (findUser == null) {
%>
        <script>
            alert("로그인 후 이용해주세요.");
            location.href = "login.jsp";
        </script>
<%
    }

    Integer episodeId = Integer.parseInt(request.getParameter("id"));
    String rating = null;
    try {
        rating = request.getParameter("star-1");
    } catch (Exception ignore) { }
    try {
        rating = request.getParameter("star-2");
    } catch (Exception ignore) { }
    try {
        rating = request.getParameter("star-3");
    } catch (Exception ignore) { }
    try {
        rating = request.getParameter("star-4");
    } catch (Exception ignore) { }
    try {
        rating = request.getParameter("star-5");
    } catch (Exception ignore) { }

    try {
        Connection connection = DbConnect.dbConnect();
        String query = "select count(rt_id) as 'count' from rating where user_id=? and epi_id=?";
        PreparedStatement pstmt = connection.prepareStatement(query);
        pstmt.setInt(1, findUser.getUserId());
        pstmt.setInt(2, episodeId);
        ResultSet rs = pstmt.executeQuery();
        rs.next();
        if (rs.getInt("count") != 0) {
%>
        <script>
            alert("같은 회차에 한 번만 평점을 메길 수 있습니다!");
            history.back();
        </script>
<%
        }
        else {
            query = "insert into rating(user_id, epi_id, rt_score, created_at) values(?, ?, ?, ?)";
            pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, findUser.getUserId());
            pstmt.setInt(2, episodeId);
            switch (rating) {
                case "1":
                    pstmt.setInt(3, 1);
                    break;
                case "2":
                    pstmt.setInt(3, 2);
                    break;
                case "3":
                    pstmt.setInt(3, 3);
                    break;
                case "4":
                    pstmt.setInt(3, 4);
                    break;
                case "5":
                    pstmt.setInt(3, 5);
                    break;
            }
            pstmt.setString(4, String.valueOf(LocalDateTime.now()));
            pstmt.executeUpdate();
%>
            <script>
                alert("평점이 제출되었습니다.");
                history.back();
            </script>
<%

        }
        rs.close();
        pstmt.close();
        connection.close();

    }
    catch (Exception e) {

    }

%>
