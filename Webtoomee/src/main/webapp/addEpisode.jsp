<%@ page import="com.example.login.LoginUser" %>
<%@ page import="com.example.user.User" %>
<%@ page import="com.example.webtoon.Webtoon" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    /**
     *  addEpisode.jsp
     *  웹툰 회차를 추가/수정하는 페이지입니다.
     */

    // 로그인된 사용자가 있을 경우 해당 사용자의 ID를 가져옵니다.
    Integer loginUserId = LoginUser.getLoginUser(request, session);
    if (loginUserId == null) {
        %>
        <script>
            alert("잘못된 접근입니다");
            location.href="index.jsp";
        </script>
<%
    }
    // 로그인된 사용자가 있을 경우 해당 사용자의 정보를 가져옵니다.
    User findUser = User.findUser(loginUserId);
    if (findUser == null) {
%>
        <script>
            alert("잘못된 접근입니다");
            location.href="index.jsp";
        </script>
<%
    }
    // 넘겨받은 웹툰에 대한 쿼리 파라미터로 어떤 웹툰의 회차를 추가하는 것인지 알아냅니다.
    Integer webtoonId = Integer.parseInt(request.getParameter("id"));
    Webtoon findWebtoon = Webtoon.findById(webtoonId);

    /**
     *  기존에 존재하던 회차를 수정하는 경우 쿼리 파라미터로 등록된 회차의 ID를 넘깁니다.
     *  따라서 epi_id에 해당하는 파라미터가 있는지 확인하고, 있으면 수정을 진행합니다.
     */
    Integer episodeId = null;
    boolean isRevised = false;
    try {
        episodeId = Integer.parseInt(request.getParameter("epi_id"));
        isRevised = true;
    }
    catch (Exception ignored) { }

%>

<html lang="ko">
<head>
    <title>회차 연재</title>
    <link rel="stylesheet" href="css/styles.css" />
</head>
<body>
<!-- title-bar -->
<div class="title-bar">
    <div class="sub-title-box">
        <a class="sub-title" href="index.jsp">Webtoomee</a>
    </div>
    <div class="main-title-box">
        <span class="main-title">웹툰 연재/수정</span>
    </div>
    <div class="title-bar-menu">
        <div>
          <span
          ><a href="myPage.jsp"><img src="icons/user.png" /></a
          ></span>
            <div><%=findUser.getUserName()%>님 <br />웹툰 작가</div>
        </div>
    </div>
</div>
<!-- title-bar -->

<!-- add episode form -->
<div class="episode-list-webtoon-title">
    <img width="125" height="137" src="./images/<%=findWebtoon.getWebtoonFileName()%>" />
    <div class="webtoon-description">
        <div>
            <%=findWebtoon.getWebtoonTitle()%><br />
            <%=findUser.getUserName()%><br />
            <%=findWebtoon.getWebtoonGenre()%>
        </div>
    </div>
</div>
<form method="post" enctype="multipart/form-data" action="addEpisode_do.jsp">
    <div class="add-webtoon-form">
        <div class="image-input">
            <label for="episodeThumbnail">
                <img src="icons/image-regular.svg"/>
            </label>
            <input
                    type="file"
                    id="episodeThumbnail"
                    name="episodeThumbnail"
                    accept="image/*"
            />
            <div>회차 썸네일을 등록하세요.</div>
        </div>

        <div class="image-input">
            <label for="webtoonFile"><img src="icons/image-regular.svg" /></label>
            <input
                    type="file"
                    id="webtoonFile"
                    name="webtoonFile"
                    accept="image/*"
            />
            <div>웹툰 파일을 등록하세요.</div>
        </div>

        <div class="webtoon-info-input">
            <div class="webtoon-info-input-title">회차 제목</div>
            <input
                    type="text"
                    id="episodeTitle"
                    name="episodeTitle"
                    required
                    value="<%if (isRevised) {%><%=com.example.webtoon.Episode.findById(episodeId).getEpisodeTitle()%><%}%>"/>
            <input type="text" id="webtoonId" name="webtoonId" value="<%=webtoonId%>" hidden />
            <%
                // 수정하는 경우 기존의 값을 넣습니다.
                if (isRevised) {
                    %>
                    <input type="text" id="episodeId" name="episodeId" value="<%=episodeId%>" hidden />
            <%
                }
            %>

            <div class="submit-box">
                <input type="submit" value="저장"/>
            </div>
        </div>
    </div>
</form>

<!-- add episode form -->
</body>
</html>

