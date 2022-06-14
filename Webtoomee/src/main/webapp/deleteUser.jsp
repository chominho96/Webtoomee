<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer loginUserId = LoginUser.getLoginUser(request, session);
    if (loginUserId == null) {
%>
        <script>
            alert("잘못된 접근입니다");
            location.href = "index.jsp";
        </script>
<%
    }
      User findUser = User.findUser(loginUserId);
      if (findUser == null) {
%>
          <script>
              alert("잘못된 접근입니다");
              location.href = "index.jsp";
          </script>
<%
      }

      // 1. 웹툰 작가이면 모든 웹툰 삭제
      if (findUser.getUserType().equals("author")) {
          List<Webtoon> webtoonList = Webtoon.getAllWebtoonByUser(findUser.getUserId());
          try {
              Connection connection = DbConnect.dbConnect();
              if (webtoonList != null) {
                  for (Webtoon webtoon : webtoonList) {
                      // 모든 회차 삭제
                      String query = "delete from episode where wtn_id=?";
                      PreparedStatement pstmt = connection.prepareStatement(query);
                      pstmt.setInt(1, webtoon.getWebtoonId());
                      pstmt.executeUpdate();
                      // 웹툰 삭제
                      query = "delete from webtoon where wtn_id=?";
                      pstmt = connection.prepareStatement(query);
                      pstmt.setInt(1, webtoon.getWebtoonId());
                      pstmt.executeUpdate();
                      pstmt.close();
                  }
              }
              connection.close();
          }
          catch (Exception ignore) { }
      }
      // 2. 사용자 삭제
      try {
          Connection connection = DbConnect.dbConnect();
          String query = "delete from user where user_id=?";
          PreparedStatement pstmt = connection.prepareStatement(query);
          pstmt.setInt(1, findUser.getUserId());
          pstmt.executeUpdate();

          pstmt.close();
          connection.close();
      }
      catch (Exception ignore) { }
%>

<script>
    alert("삭제가 완료되었습니다.");
    location.href = "index.jsp";
</script>