<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="jakarta.servlet.http.Part" %>
<%@ page import="com.example.image.UploadImage" %>
<%@ page import="com.example.db_connect.DbConnect" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    request.setCharacterEncoding("utf-8");
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

    boolean isRevise = false;
    Integer targetWebtoonId = null;
    try {
        targetWebtoonId = Integer.parseInt(request.getParameter("webtoonId"));
        isRevise = true;
    }
    catch (Exception ignored) { }

    String webtoonTitle = request.getParameter("webtoonTitle");
    String webtoonGenre = request.getParameter("webtoonGenre");
    String webtoonSummary = request.getParameter("webtoonSummary");
    String authorWord = request.getParameter("authorWord");
    Part part = request.getPart("webtoonThumbnail");
    Integer webtoonId = null;

    // 이미지 업로드
    String uploadedImageURL = UploadImage.saveWebtoonThumbnail(part, request);
    if (uploadedImageURL == null) {
%>
        <script>
            alert("이미지 업로드 실패. 다시 시도해주세요");
            history.back();
        </script>
<%
    }

    // 1. 수정
    if (isRevise) {
        try {
            Connection connection = DbConnect.dbConnect();

            // 기존 이미지 삭제
            String query = "select wtn_thb from webtoon where wtn_id=?";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, targetWebtoonId);
            ResultSet rs = pstmt.executeQuery();
            rs.next();
            String targetFile = rs.getString("wtn_thb");
            UploadImage.deleteFile(targetFile, request.getSession().getServletContext(), "images");


            // 데이터 갱신
            query = "update webtoon set wtn_title=?, wtn_thb=?, wtn_genre=?, wtn_summ=?, wtn_auth_word=?," +
                    "created_at=? where wtn_id=?";
            pstmt = connection.prepareStatement(query);
            pstmt.setString(1, webtoonTitle);
            pstmt.setString(2, uploadedImageURL);
            pstmt.setString(3, webtoonGenre);
            pstmt.setString(4, webtoonSummary);
            pstmt.setString(5, authorWord);
            pstmt.setString(6, String.valueOf(LocalDateTime.now()));
            pstmt.setInt(7, targetWebtoonId);
            pstmt.executeUpdate();

            connection.close();
%>
            <script>
                alert("업로드 되었습니다.");
                location.href="webtoon.jsp?<%=targetWebtoonId%>";
            </script>
<%
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 2. 처음 업로드
    else {
        try {
            Connection connection = DbConnect.dbConnect();

            String query = "insert into webtoon(wtn_author, wtn_title, wtn_thb, wtn_genre, wtn_summ, wtn_auth_word, created_at) values" +
                    "(?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, findUser.getUserId());
            pstmt.setString(2, webtoonTitle);
            pstmt.setString(3, uploadedImageURL);
            pstmt.setString(4, webtoonGenre);
            pstmt.setString(5, webtoonSummary);
            pstmt.setString(6, authorWord);
            pstmt.setString(7, String.valueOf(LocalDateTime.now()).substring(0, 10));
            pstmt.executeQuery();

            query = "select wtn_id from webtoon where wtn_author=? order by wtn_id desc limit 1";
            pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, findUser.getUserId());
            ResultSet rs = pstmt.executeQuery();
            rs.next();
            webtoonId = rs.getInt("wtn_id");
            rs.close();
            connection.close();


%>
            <script>
                alert("업로드 되었습니다.");
                location.href="webtoon.jsp?<%=webtoonId%>";
            </script>
<%
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
