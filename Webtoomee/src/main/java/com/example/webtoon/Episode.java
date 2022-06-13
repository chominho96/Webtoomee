package com.example.webtoon;

import com.example.db_connect.DbConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class Episode {

    Integer episodeId;
    Integer webtoonId;
    String webtoonTitle;
    String episodeThumbnail;
    String episodeFile;
    LocalDateTime createdAt;

    public Integer getEpisodeId() {
        return episodeId;
    }

    public Integer getWebtoonId() {
        return webtoonId;
    }

    public String getWebtoonTitle() {
        return webtoonTitle;
    }

    public String getEpisodeThumbnail() {
        return episodeThumbnail;
    }

    public String getEpisodeFile() {
        return episodeFile;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public Episode(Integer episodeId, Integer webtoonId, String webtoonTitle, String episodeThumbnail,
                   String episodeFile, String createdAt) {
        this.episodeId = episodeId;
        this.webtoonId = webtoonId;
        this.webtoonTitle = webtoonTitle;
        this.episodeThumbnail = episodeThumbnail;
        this.episodeFile = episodeFile;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        this.createdAt = LocalDateTime.parse(createdAt, formatter);
    }

    public static List<Episode> findAllByWebtoon(Integer webtoonId) {
        try {
            Connection connection = DbConnect.dbConnect();
            String query = "select * from episode where wtn_id=?";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, webtoonId);
            ResultSet rs = pstmt.executeQuery();

            List<Episode> result = new ArrayList<>();

            while (rs.next()) {
                result.add(new Episode(rs.getInt("epi_id"), webtoonId, rs.getString("epi_title"),
                        rs.getString("epi_thb"), rs.getString("epi_file"),
                        rs.getString("created_at")));
            }

            connection.close();
            return result;

        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


}
