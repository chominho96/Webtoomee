<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.example.webtoon.Episode" %>
<%@ page import="com.example.image.UploadImage" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  request.setCharacterEncoding("utf-8");
  Integer episodeId = null;
  try {
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
    // 1. 파일 삭제
    UploadImage.deleteFile(findEpisode.getEpisodeThumbnail(), request.getSession().getServletContext(), "images");
    UploadImage.deleteFile(findEpisode.getEpisodeFile(), request.getSession().getServletContext(), "images");

    // 2. DB에서 삭제
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