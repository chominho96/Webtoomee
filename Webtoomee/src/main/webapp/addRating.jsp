<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    /**
     *  addRating.jsp
     *  회차에 대해 평점을 부여했을 때, 이를 처리하는 로직을 담당합니다.
     */

    // 평점 부여의 경우, 로그인한 사용자에 한해 이용할 수 있기 때문에, 로그인 여부를 확인합니다.
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

    // 쿼리 파라미터로 넘겨받은 회차 ID와, 평점을 확인합니다.
    Integer episodeId = Integer.parseInt(request.getParameter("id"));
    Integer rating = null;
    try {
        rating = Integer.parseInt(request.getParameter("star-1"));
    } catch (Exception ignore) { }
    try {
        rating = Integer.parseInt(request.getParameter("star-2"));
    } catch (Exception ignore) { }
    try {
        rating = Integer.parseInt(request.getParameter("star-3"));
    } catch (Exception ignore) { }
    try {
        rating = Integer.parseInt(request.getParameter("star-4"));
    } catch (Exception ignore) { }
    try {
        rating = Integer.parseInt(request.getParameter("star-5"));
    } catch (Exception ignore) { }

    /**
     *  한 회차에 대해 한 회원은 한 번만 평점을 부여할 수 있습니다.
     *  따라서 해당 회원의 ID와 해당 회차의 ID를 이용하여 기존에 이미 부여한 평점이 있는지 확인합니다.
     */
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
            // 정상적인 진행의 경우, rating 테이블에 insert문으로 데이터를 삽입합니다.
            query = "insert into rating(user_id, epi_id, rt_score, created_at) values(?, ?, ?, ?)";
            pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, findUser.getUserId());
            pstmt.setInt(2, episodeId);
            pstmt.setInt(3, rating);
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
