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
    /**
     *  addNewWebtoon_do.jsp
     *  웹툰을 추가/수정하는 로직 처리를 담당합니다.
     *
     */
    request.setCharacterEncoding("utf-8");
    // 로그인된 사용자만 접근할 수 있도록, 로그인 여부를 확인합니다.
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
     *  수정의 경우, 쿼리 파라미터로 webtoonId를 받아서 해당 ID를 가지고 수정을 진행합니다.
     */
    boolean isRevise = false;
    Integer targetWebtoonId = null;
    try {
        targetWebtoonId = Integer.parseInt(request.getParameter("webtoonId"));
        isRevise = true;
    }
    catch (Exception ignored) { }

    // 넘겨받은 값을 저장합니다.
    String webtoonTitle = request.getParameter("webtoonTitle");
    String webtoonGenre = request.getParameter("webtoonGenre");
    String webtoonSummary = request.getParameter("webtoonSummary");
    String authorWord = request.getParameter("authorWord");
    Part part = request.getPart("webtoonThumbnail");
    Integer webtoonId = null;

    // 파일을 저장하고, 저장된 파일의 이름을 넘겨받습니다.
    String uploadedImageURL = UploadImage.saveWebtoonThumbnail(part, request);
    if (uploadedImageURL == null) {
%>
        <script>
            alert("이미지 업로드 실패. 다시 시도해주세요");
            history.back();
        </script>
<%
    }

    /**
     *  1. 수정
     *  수정의 경우 기존에 존재하던 파일을 삭제하는 로직을 추가합니다.
     */
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


            // DB에 업데이트 쿼리를 날립니다.
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

        /**
         *  2. 처음 업로드
         *  처음 업로드하는 경우 insert 문을 통해 DB에 삽입합니다.
         */
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
                location.href="webtoonManagement.jsp";
            </script>
<%
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
