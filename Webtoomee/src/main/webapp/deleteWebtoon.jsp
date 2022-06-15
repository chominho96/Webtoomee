<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.example.webtoon.Episode" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.image.UploadImage" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

  /**
   *  deleteWebtoon.jsp
   *  웹툰 삭제에 대한 로직을 담당합니다.
   */

  request.setCharacterEncoding("utf-8");

  // 삭제할 웹툰 ID를 쿼리 파라미터로 넘겨받습니다.
  Integer webtoonId = null;
  try {
    webtoonId = Integer.parseInt(request.getParameter("id"));
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
    Connection connection = DbConnect.dbConnect();
    // 해당 웹툰에 대한 모든 회차를 삭제합니다.
    List<Episode> episodeList = Episode.findAllByWebtoon(webtoonId);
    for (Episode episode : episodeList) {

      // 해당 회차에 대해 저장되어 있는 파일을 삭제합니다.
      UploadImage.deleteFile(episode.getEpisodeFile(), request.getSession().getServletContext(), "images");
      UploadImage.deleteFile(episode.getEpisodeThumbnail(), request.getSession().getServletContext(), "images");
    }

    // 해당 웹툰의 모든 회차를 삭제합니다.
    String query = "delete from episode where wtn_id=?";
    PreparedStatement pstmt = connection.prepareStatement(query);
    pstmt.setInt(1, webtoonId);
    pstmt.executeUpdate();


    Webtoon findWebtoon = Webtoon.findById(webtoonId);
    // 해당 웹툰에 대해 저장되어 있는 파일을 삭제합니다.
    UploadImage.deleteFile(findWebtoon.getWebtoonFileName(), request.getSession().getServletContext(), "images");

    // 해당 웹툰을 DB에서 삭제합니다.
    query = "delete from webtoon where wtn_id=?";
    pstmt = connection.prepareStatement(query);
    pstmt.setInt(1, webtoonId);
    pstmt.executeUpdate();

    connection.close();
    String printStr = "삭제에 성공했습니다.";

    %>
    <script>
      alert("<%=printStr%>");
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