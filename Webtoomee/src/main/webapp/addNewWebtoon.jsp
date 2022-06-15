<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    /**
     *  addNewWebtoon.jsp
     *  웹툰을 추가/수정하는 페이지입니다.
     */

    // 웹툰 추가, 수정의 경우 로그인된 사용자만 할 수 있기 때문에, 로그인 여부를 확인합니다.
    Integer loginUserId = LoginUser.getLoginUser(request, session);
    if (loginUserId == null) {
%>
        <script>
            alert("로그인해주세요.");
            location.href="login.jsp";
        </script>
<%
    }
    User findUser = User.findUser(loginUserId);
    if (findUser == null) {
%>
        <script>
            alert("로그인해주세요.");
            location.href="login.jsp";
        </script>
<%
    }
    boolean isRevise = false;
    Integer webtoonId = null;
    Webtoon findWebtoon = null;

    /**
     *  등록이 아닌 수정일 경우
     *  수정의 경우 쿼리파라미터로 해당 웹툰의 id를 넘깁니다.
     *  따라서 이를 가지고 수정을 진행합니다.
     */
    try {
        webtoonId = Integer.parseInt(request.getParameter("id"));
        isRevise = true;

    }
    catch (Exception ignored) { }

    if (isRevise) {
        findWebtoon = Webtoon.findById(webtoonId);
    }
%>

<html lang="ko">
<head>
    <title>웹툰 등록 / 수정</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
    <div class="sub-title-box">
        <a class="sub-title" href="index.jsp">Webtoomee</a>
    </div>
    <div class="main-title-box">
        <span class="main-title">웹툰 등록/수정</span>
    </div>
    <div class="title-bar-menu">
        <div>
          <span>
              <a href="myPage.jsp"><img src="icons/user.png" /></a>
          </span>
            <div><%=findUser.getUserName()%>님 <br />웹툰 작가</div>
        </div>
    </div>
</div>
<!-- title-bar -->

<!-- add webtoon form -->
<form
        method="post"
        enctype="multipart/form-data"
        action="addNewWebtoon_do.jsp"
>
    <div class="add-webtoon-form-box">
        <div class="image-input">
            <label for="webtoonThumbnail">
                <img src="icons/image-regular.svg"/>
            </label>
            <input
                    type="file"
                    id="webtoonThumbnail"
                    name="webtoonThumbnail"
                    accept="image/*"
            />
            <div>웹툰 썸네일을 등록하세요.</div>
        </div>

        <div class="webtoon-info-input">
            <div class="webtoon-info-input-title">웹툰 제목</div>
            <input type="text" id="webtoonTitle" name="webtoonTitle"
                   value="<%
                   if (isRevise) {
                       // 수정인 경우, 기존에 존재하던 값을 미리 입력해 놓습니다.
                       %><%=findWebtoon.getWebtoonTitle()%>
                       <%
                   }
                   %>"
                   required />
            <div class="webtoon-info-input-title">장르</div>
            <select name="webtoonGenre">
                <option value="daily"
                        <%
                            // 수정인 경우, 기존에 존재하던 값을 미리 선택해 놓습니다.
                            if (isRevise && findWebtoon.getWebtoonGenre().equals("daily")) {
                        %>
                                selected
                        <%
                            }
                        %>
                >일상</option>
                <option value="comedy"
                        <%
                            if (isRevise && findWebtoon.getWebtoonGenre().equals("comedy")) {
                        %>
                        selected
                        <%
                            }
                        %>
                >개그</option>
                <option value="fantasy"
                        <%
                            if (isRevise && findWebtoon.getWebtoonGenre().equals("fantasy")) {
                        %>
                        selected
                        <%
                            }
                        %>
                >판타지</option>
                <option value="action"
                        <%
                            if (isRevise && findWebtoon.getWebtoonGenre().equals("action")) {
                        %>
                        selected
                        <%
                            }
                        %>
                >액션</option>
            </select>
            <div class="webtoon-info-input-title">줄거리</div>
            <textarea name="webtoonSummary" cols="55" rows="10" required><%if (isRevise) {%><%=findWebtoon.getWebtoonSummary()%><%}%>
            </textarea>
            <div class="webtoon-info-input-title">작가의 말</div>
            <textarea name="authorWord" cols="55" rows="10" required><%if (isRevise) {%><%=findWebtoon.getWebtoonAuthorWord()%><%}%>
            </textarea>
            <%
                if (isRevise) {
                    // 수정인 경우, 기존에 존재하던 값을 미리 입력해 놓습니다.
                    %>
            <input type="text" name="webtoonId" value="<%=findWebtoon.getWebtoonId()%>" hidden />
            <%
                }
            %>
            <div class="submit-box">
                <input type="submit" class="submit-new-webtoon" value="저장" />
            </div>
        </div>
    </div>
</form>

<!-- add webtoon form -->
</body>
</html>

