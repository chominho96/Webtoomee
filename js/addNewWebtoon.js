const addWebtoonForm = document.querySelector(".add-webtoon-form");

function alertInfo() {
  const fileName = document.getElementById("webtoonThumbnail").files[0].name;
  const webtoonTitle = document.getElementById("webtoonTitle").value;
  const webtoonGenre = document.getElementById("webtoonGenre").value;
  const webtoonSummary = document.getElementById("webtoonSummary").value;
  const authorWord = document.getElementById("authorWord").value;

  alert(
    "웹툰 썸네일 : " +
      fileName +
      "\n" +
      "웹툰 이름   : " +
      webtoonTitle +
      "\n" +
      "웹툰 장르   : " +
      webtoonGenre +
      "\n" +
      "웹툰 줄거리 : " +
      webtoonSummary +
      "\n" +
      "작가의 말   : " +
      authorWord +
      "\n"
  );
}

addWebtoonForm.addEventListener("submit", alertInfo);
