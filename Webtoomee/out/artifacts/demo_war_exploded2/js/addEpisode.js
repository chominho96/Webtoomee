const addEpisode = document.querySelector(".add-episode-form");

function alertEpisodeInfo() {
  const episodeThumbnail =
    document.getElementById("episodeThumbnail").files[0].name;
  const webtoonFile = document.getElementById("webtoonFile").files[0].name;
  const episodeTitle = document.getElementById("epidodeTitle").value;

  alert(
    "회차 썸네일 : " +
      episodeThumbnail +
      "\n" +
      "웹툰 파일   : " +
      webtoonFile +
      "\n" +
      "회차 제목   : " +
      episodeTitle
  );
}

addEpisode.addEventListener("submit", alertEpisodeInfo);
