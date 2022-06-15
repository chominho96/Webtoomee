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
     *  reportEpisode.jsp
     *  특정 웹툰 회차 신고에 대한 로직을 담당합니다.
     */

    // 신고의 경우 로그인된 사용자만 이용할 수 있기 때문에, 로그인 여부를 확인합니다.
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
            history.back();
        </script>
<%
    }

    // 신고하고자 하는 회차에 대한 정보를 넘겨받습니다.
    Integer episodeId = Integer.parseInt(request.getParameter("id"));

    try {
        // 특정 회원은 특정 회차에 대해 1번만 신고할 수 있기 때문에, 기존 신고 이력이 있는지 확인합니다.
        Connection connection = DbConnect.dbConnect();
        String query = "select count(report_id) as 'count' from report where epi_id=? and user_id=?";
        PreparedStatement pstmt = connection.prepareStatement(query);
        pstmt.setInt(1, episodeId);
        pstmt.setInt(2, loginUserId);
        ResultSet rs = pstmt.executeQuery();
        rs.next();
        if (rs.getInt("count") != 0) {
%>
            <script>
                alert("신고는 회차당 한 번만 할 수 있습니다!");
                history.back();
            </script>
<%
        }
        else {
            // report table에 insert문을 통해 데이터를 삽입합니다.
            query = "insert into report(user_id, epi_id, created_at) values(?, ?, ?)";
            pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, loginUserId);
            pstmt.setInt(2, episodeId);
            pstmt.setString(3, String.valueOf(LocalDateTime.now()));
            pstmt.executeUpdate();
        }
        rs.close();
        pstmt.close();
        connection.close();
%>
        <script>
            alert("정상적으로 접수되었습니다.");
            history.back();
        </script>
<%

    }
    catch (Exception ignore) { }
%>