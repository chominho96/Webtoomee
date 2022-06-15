<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="com.example.webtoon.Episode" %>
<%@ page import="com.example.image.UploadImage" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    /**
     *  deleteUser.jsp
     *  사용자 삭제 (회원 탈퇴)에 대한 로직을 담당합니다.
     */

    // 회원 탈퇴의 경우 로그인된 사용자에 한해 이용할 수 있으므로, 로그인 여부를 확인합니다.
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

      // 1. 웹툰 작가이면 모든 웹툰을 삭제합니다.
      if (findUser.getUserType().equals("author")) {
          List<Webtoon> webtoonList = Webtoon.getAllWebtoonByUser(findUser.getUserId());
          try {
              Connection connection = DbConnect.dbConnect();
              if (webtoonList != null) {
                  for (Webtoon webtoon : webtoonList) {

                      List<Episode> episodeList = Episode.findAllByWebtoon(webtoon.getWebtoonId());
                      if (episodeList != null) {
                          for (Episode episode : episodeList) {
                              // 해당 웹툰의 모든 회차에 대해 저장된 이미지 파일을 삭제합니다.
                              UploadImage.deleteFile(episode.getEpisodeThumbnail(), request.getSession().getServletContext(), "images");
                              UploadImage.deleteFile(episode.getEpisodeFile(), request.getSession().getServletContext(), "images");
                          }
                      }

                      // 해당 웹툰의 썸네일 파일을 삭제합니다.
                      UploadImage.deleteFile(webtoon.getWebtoonFileName(), request.getSession().getServletContext(), "images");

                      // 해당 웹툰을 DB에서 삭제합니다.
                      String query = "delete from webtoon where wtn_id=?";
                      PreparedStatement pstmt = connection.prepareStatement(query);
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
          // 해당 사용자가 작성한 모든 평점 내역을 삭제합니다.
          String query = "delete from rating where user_id=?";
          PreparedStatement pstmt = connection.prepareStatement(query);
          pstmt.setInt(1, findUser.getUserId());
          pstmt.executeUpdate();

          // 해당 사용자가 제출한 모든 신고 내역을 삭제합니다.
          query = "delete from report where user_id=?";
          pstmt = connection.prepareStatement(query);
          pstmt.setInt(1, findUser.getUserId());
          pstmt.executeUpdate();

          // 해당 사용자를 삭제합니다.
          query = "delete from user where user_id=?";
          pstmt = connection.prepareStatement(query);
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