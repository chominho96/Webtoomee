<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <% request.setCharacterEncoding("utf-8"); String stitle =
request.getParameter("webtoonTitle"); String sgenre =
request.getParameter("webtoonGenre"); String ssummary =
request.getParameter("webtoonSummary"); String sauthorWord =
request.getParameter("authorWord"); // TODO : 저자의 경우 로그인된 회원을
이용하여 가져옵니다. // TODO : 파일 업로드 %>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>episodeList</title>
    <link rel="stylesheet" href="css/styles.css" />
  </head>
  <body>
    <!-- title-bar -->
    <div class="title-bar">
      <div class="sub-title-box">
        <a class="sub-title" href="index.html">Webtoomee</a>
      </div>
      <div class="main-title-box">
        <a class="main-title" href="episodeList.html">웹툰 제목</a>
      </div>
      <div class="title-bar-menu">
        <div>
          <span
            ><a href="myPage.html"><img src="icons/user.png" /></a
          ></span>
          <div>조민호님 <br />관리자</div>
        </div>
        <div>
          <span
            ><a href="webtoonManagement.html"
              ><img src="icons/pen-to-square-solid.svg" /></a
          ></span>
          <div>웹툰 관리</div>
        </div>
      </div>
    </div>
    <!-- title-bar -->

    <!-- search bar -->
    <div class="search-bar-box">
      <form>
        <div class="search-bar">
          <input type="text" placeholder="search..." />
          <button type="submit">
            <img src="icons/magnifying-glass-solid.svg" />
          </button>
        </div>
      </form>
    </div>
    <!-- search bar -->

    <!-- webtoon title -->
    <div class="episode-list-webtoon-title">
      <img src="images/웹툰 썸네일1.png" />
      <div class="webtoon-description">
        <div>
          <%=stitle %><br />
          조민호<br />
          <%=sgenre %><br />
          <span><img src="icons/별점0.png" /> 0.0</span>
        </div>
        <div>
          <%=ssummary %><br />
          <%=sauthorWord %>
        </div>
      </div>
    </div>
    <!-- webtoon title -->

    <!-- episode list -->
    <!-- episode list -->
  </body>
</html>
