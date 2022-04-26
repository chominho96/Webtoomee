<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@page import="java.util.Date" %> <%@page
import="java.text.SimpleDateFormat" %> <% request.setCharacterEncoding("utf-8");
String stitle = request.getParameter("epidodeTitle"); SimpleDateFormat f = new
SimpleDateFormat("yyyy-MM-dd"); String today = f.format(new Date()); // TODO :
파일 업로드 %>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>webtoon</title>
    <link rel="stylesheet" href="css/styles.css" />
  </head>
  <body>
    <!-- title-bar -->
    <div class="title-bar">
      <div class="sub-title-box">
        <a class="sub-title" href="index.html">Webtoomee</a>
      </div>
      <div class="main-title-box">
        <a class="main-title" href="episodeList.html">웹툰 회차 제목</a>
      </div>
      <div class="title-bar-menu">
        <div>
          <span
            ><a href="myPage.html"><img src="icons/user.png" /></a
          ></span>
          <div>조민호님 <br />관리자</div>
        </div>
      </div>
    </div>
    <!-- title-bar -->

    <!-- episode -->
    <div class="episode-box">
      <div class="single-episode">
        <img src="images/회차 썸네일.png" />
        <div>
          <%=stitle %><br />
          등록일 : <%=today%><br />
        </div>
      </div>
    </div>
    <!-- episode -->

    <!-- navigation bar -->
    <div class="navigation-bar">
      <span
        ><a href="#"><img src="icons/arrow-up-long-solid.svg" /></a
      ></span>
      <div>top<br />bottom</div>
      <span
        ><a href="#bottom"><img src="icons/arrow-down-long-solid.svg" /></a
      ></span>
      <button onclick="alert('신고하시겠습니까?');">
        <img src="icons/신고.png" />
      </button>

      <div>신고</div>
    </div>
    <!-- navigation bar -->

    <!-- webtoon -->
    <div class="webtoon-main">
      <img src="images/웹툰.png" />
    </div>
    <!-- webtoon -->

    <!-- review / rating -->
    <div class="review-and-rating" id="bottom">
      <div>해당 회차에 별점을 매겨주세요!</div>
      <div>
        <form>
          <input type="radio" id="star-1" name="star-1" value="★" />
          <label for="star-1">★</label>
          <input type="radio" id="star-2" name="star-2" value="★★" />
          <label for="star-2">★★</label>
          <input type="radio" id="star-3" name="star-3" value="★★★" />
          <label for="star-3">★★★</label>
          <input type="radio" id="star-4" name="star-4" value="★★★★" />
          <label for="star-4">★★★★</label>
          <input type="radio" id="star-5" name="star-5" value="★★★★★" />
          <label for="star-5">★★★★★</label>
          <button type="submit">✔</button>
        </form>
      </div>
    </div>
    <!-- review / rating -->
  </body>
</html>
