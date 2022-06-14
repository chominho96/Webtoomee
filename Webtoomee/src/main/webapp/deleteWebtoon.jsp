<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.example.webtoon.Episode" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.image.UploadImage" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  request.setCharacterEncoding("utf-8");
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
    // 1. 모든 회차 삭제
    List<Episode> episodeList = Episode.findAllByWebtoon(webtoonId);
    for (Episode episode : episodeList) {
      // 파일 삭제
      UploadImage.deleteFile(episode.getEpisodeFile(), request.getSession().getServletContext(), "images");
      UploadImage.deleteFile(episode.getEpisodeThumbnail(), request.getSession().getServletContext(), "images");
    }

    // DB에서 삭제
    String query = "delete from episode where wtn_id=?";
    PreparedStatement pstmt = connection.prepareStatement(query);
    pstmt.setInt(1, webtoonId);
    pstmt.executeUpdate();

    // 2. 웹툰 삭제
    Webtoon findWebtoon = Webtoon.findById(webtoonId);
    // 파일 삭제
    UploadImage.deleteFile(findWebtoon.getWebtoonFileName(), request.getSession().getServletContext(), "images");

    // DB에서 삭제
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