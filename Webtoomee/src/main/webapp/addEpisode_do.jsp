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
    /**
     *  addEpisode_do.jsp
     *  회차 등록/수정에 대한 로직을 처리합니다.
     */

    // 로그인된 사용자만 접근할 수 있으므로, 로그인되었는지 확인합니다.
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


    /**
     *  수정을 하는 상황인지 확인합니다.
     *  수정의 경우 쿼리 파라미터로 episodeId가 들어옵니다.
     */
    boolean isRevised = false;
    Integer targetEpisodeId = null;
    try {
        targetEpisodeId = Integer.parseInt(request.getParameter("episodeId"));
        isRevised = true;
    }
    catch (Exception ignore) { }


    // 등록하고자 하는 회차가 어느 웹툰에 포함되었는지를 쿼리 파라미터로 넘기고, 이를 확인하여 해당 웹툰의 회차로 삽입될 수 있게 합니다.
    // 또한 입력으로 넘겨진 값들을 변수에 저장합니다.
    Integer webtoonId = Integer.parseInt(request.getParameter("webtoonId"));
    String episodeTitle = request.getParameter("episodeTitle");
    Part episodeThumbnail = request.getPart("episodeThumbnail");
    Part episodeFile = request.getPart("webtoonFile");

    // 회차 썸네일, 회차 웹툰 파일에 대해 저장하고, 저장된 파일 이름을 넘겨받습니다.
    String savedThumbnail = UploadImage.saveWebtoonThumbnail(episodeThumbnail, request);
    String savedFile = UploadImage.saveWebtoonThumbnail(episodeFile, request);

    // 정상적으로 파일 저장이 진행되지 않았을 경우
    if (savedThumbnail == null || savedFile == null) {
%>
<script>
    alert("파일 업로드에 실패했습니다.");
    history.back();
</script>
<%
    }

    /**
     *  1. 수정된 경우
     *  수정된 경우 기존에 존재하던 파일을 삭제하는 로직을 추가합니다.
     */
    if (isRevised) {
        Episode findEpisode = Episode.findById(targetEpisodeId);
        // 기존에 존재하던 파일을 삭제합니다.
        UploadImage.deleteFile(findEpisode.getEpisodeThumbnail(), request.getSession().getServletContext(), "images");
        UploadImage.deleteFile(findEpisode.getEpisodeFile(), request.getSession().getServletContext(), "images");

        try {
            Connection connection = DbConnect.dbConnect();

            // 기존 DB에 대한 업데이트 쿼리를 날립니다.
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
        /**
         *   2. 수정되지 않은 경우
         *      수정되지 않은 경우 새로운 값을 DB에 넣어줍니다.
         */
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
            location.href="webtoon.jsp?id=<%=episodeId%>";
        </script>
<%
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
%>





