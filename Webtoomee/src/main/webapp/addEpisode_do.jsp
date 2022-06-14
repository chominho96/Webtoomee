<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="com.example.image.UploadImage" %>
<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.example.webtoon.Episode" %>
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

    // 수정 체크
    boolean isRevised = false;
    Integer targetEpisodeId = null;
    try {
        targetEpisodeId = Integer.parseInt(request.getParameter("episodeId"));
        isRevised = true;
    }
    catch (Exception ignore) { }


    Integer webtoonId = Integer.parseInt(request.getParameter("webtoonId"));
    String episodeTitle = request.getParameter("episodeTitle");
    Part episodeThumbnail = request.getPart("episodeThumbnail");
    Part episodeFile = request.getPart("webtoonFile");

    String savedThumbnail = UploadImage.saveWebtoonThumbnail(episodeThumbnail, request);
    String savedFile = UploadImage.saveWebtoonThumbnail(episodeFile, request);

    if (savedThumbnail == null || savedFile == null) {
%>
<script>
    alert("파일 업로드에 실패했습니다.");
    history.back();
</script>
<%
    }

    // 1. 수정된 경우
    if (isRevised) {
        Episode findEpisode = Episode.findById(targetEpisodeId);
        UploadImage.deleteFile(findEpisode.getEpisodeThumbnail(), request.getSession().getServletContext(), "images");
        UploadImage.deleteFile(findEpisode.getEpisodeFile(), request.getSession().getServletContext(), "images");

        try {
            Connection connection = DbConnect.dbConnect();

            String query = "update episode set epi_title=?, epi_thb=?, epi_file=? where epi_id=?";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setString(1, episodeTitle);
            pstmt.setString(2, savedThumbnail);
            pstmt.setString(3, savedFile);
            pstmt.setInt(4, targetEpisodeId);
            pstmt.executeUpdate();


            pstmt.close();
            connection.close();

%>
<script>
    alert("수정에 성공했습니다.");
    location.href="webtoon.jsp?<%=targetEpisodeId%>";
</script>
<%
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    // 2. 수정되지 않은 경우
    else {
        Integer episodeId = null;

        try {
            Connection connection = DbConnect.dbConnect();

            String query = "insert into episode(wtn_id, epi_title, epi_thb, epi_file, created_at) values(?, ?, ?, ?, ?)";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, webtoonId);
            pstmt.setString(2, episodeTitle);
            pstmt.setString(3, savedThumbnail);
            pstmt.setString(4, savedFile);
            pstmt.setString(5, String.valueOf(LocalDateTime.now()));
            pstmt.executeUpdate();

            query = "select epi_id from episode where wtn_id=? order by epi_id desc";
            pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, webtoonId);
            ResultSet rs = pstmt.executeQuery();
            rs.next();
            episodeId = rs.getInt("epi_id");

            pstmt.close();
            connection.close();

%>
        <script>
            alert("업로드에 성공했습니다.");
            location.href="webtoon.jsp?<%=episodeId%>";
        </script>
<%
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
%>





