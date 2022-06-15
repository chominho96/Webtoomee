<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.example.webtoon.Episode" %>
<%@ page import="com.example.image.UploadImage" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

  /**
   *  deleteEpisode.jsp
   *  웹툰 회차 삭제에 대한 로직을 담당합니다.
   */

  request.setCharacterEncoding("utf-8");
  Integer episodeId = null;
  try {
    // 정상적으로 회차 ID가 쿼리 파라미터로 넘어왔는지 확인합니다.
    episodeId = Integer.parseInt(request.getParameter("id"));
  }
  catch (Exception e) {
%>
<script charset="utf-8">
  alert("잘못된 접근입니다");
  location.href="index.jsp";
</script>
<%
  }
  try {
    Episode findEpisode = Episode.findById(episodeId);
    // 1. 해당 회차의 썸네일 파일, 웹툰 그림 파일을 삭제합니다.
    UploadImage.deleteFile(findEpisode.getEpisodeThumbnail(), request.getSession().getServletContext(), "images");
    UploadImage.deleteFile(findEpisode.getEpisodeFile(), request.getSession().getServletContext(), "images");

    // 2. DB에서 데이터를 삭제합니다.
    Connection connection = DbConnect.dbConnect();
    String query = "delete from episode where epi_id=?";
    PreparedStatement pstmt = connection.prepareStatement(query);
    pstmt.setInt(1, episodeId);
    pstmt.executeUpdate();

    connection.close();

%>
<script>
  alert("삭제에 성공했습니다.");
  history.back();
</script>
<%
}
catch (Exception e) {
%>
<script charset="utf-8">
  alert("삭제에 실패했습니다.");
  location.href="index.jsp";
</script>
<%
  }

%>