<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
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
          <span
          ><a href="myPage.jsp"><img src="icons/user.png" /></a
          ></span>
            <div>조민호님 <br />웹툰 작가</div>
        </div>
    </div>
</div>
<!-- title-bar -->

<!-- add webtoon form -->
<form
        method="post"
        enctype="multipart/form-data"
        action="addNewWebtoon_temp.jsp"
>
    <div class="add-webtoon-form">
        <div class="image-input">
            <label for="webtoonThumbnail"
            ><img src="icons/image-regular.svg"
            /></label>
            <input
                    type="file"
                    id="webtoonThumbnail"
                    name="webtoonThumbnail"
                    accept="image/*"
                    onchange="loadFile(this)"
            />
            <div>웹툰 썸네일을 등록하세요.</div>
        </div>

        <div class="webtoon-info-input">
            <div class="webtoon-info-input-title">웹툰 제목</div>
            <input type="text" id="webtoonTitle" name="webtoonTitle" required />
            <div class="webtoon-info-input-title">장르</div>
            <select name="webtoonGenre">
                <option value="daily">일상</option>
                <option value="comedy">개그</option>
                <option value="fantasy">판타지</option>
                <option value="action">액션</option>
            </select>
            <div class="webtoon-info-input-title">줄거리</div>
            <textarea
                    name="webtoonSummary"
                    cols="55"
                    rows="10"
                    required
            ></textarea>
            <div class="webtoon-info-input-title">작가의 말</div>
            <textarea name="authorWord" cols="55" rows="10" required></textarea>
            <div class="submit-box">
                <button type="submit">저장</button>
            </div>
        </div>
    </div>
</form>

<!-- add webtoon form -->
</body>
</html>

