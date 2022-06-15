package com.example.webtoon;

import com.example.db_connect.DbConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 *  웹툰 회차에 대한 클래스입니다.
 */
public class Episode {

    Integer episodeId;
    Integer webtoonId;
    String episodeTitle;
    String episodeThumbnail;
    String episodeFile;
    LocalDateTime createdAt;

    public Integer getEpisodeId() {
        return episodeId;
    }

    public Integer getWebtoonId() {
        return webtoonId;
    }

    public String getEpisodeTitle() {
        return episodeTitle;
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
        this.episodeTitle = webtoonTitle;
        this.episodeThumbnail = episodeThumbnail;
        this.episodeFile = episodeFile;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        this.createdAt = LocalDateTime.parse(createdAt, formatter);
    }

    /**
     *
     * 웹툰 ID를 넘겨받아, 해당 웹툰의 모든 회차를 리스트 형태로 반환합니다.
     */
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

    /**
     *
     *  회차 ID를 넘겨받아, 해당 회차의 평균 평점을 반환합니다.
     */
    public static Double getRating (Integer episodeId) {
        try {
            Connection connection = DbConnect.dbConnect();
            String query = "select ifnull(avg(rt_score), 0) as 'rating' from rating where epi_id=?";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, episodeId);
            ResultSet rs = pstmt.executeQuery();
            rs.next();
            double result = rs.getDouble("rating");

            connection.close();
            return result;

        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     *
     *  회차 ID를 넘겨받아, 해당 ID에 해당하는 회차 객체를 반환합니다.
     */
    public static Episode findById (Integer episodeId) {
        try {
            Connection connection = DbConnect.dbConnect();
            String query = "select * from episode where epi_id=?";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, episodeId);
            ResultSet rs = pstmt.executeQuery();
            rs.next();
            Episode episode = new Episode(episodeId, rs.getInt("wtn_id"), rs.getString("epi_title"),
                    rs.getString("epi_thb"), rs.getString("epi_file"), rs.getString("created_at"));

            connection.close();
            return episode;

        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     *
     *  회차ID를 넘겨받아, 해당 회차의 누적 신고 수를 반환합니다.
     */

    public static Integer getReportNum(Integer episodeId) {
        try {
            Connection connection = DbConnect.dbConnect();
            String query = "select count(*) as 'count' from report where epi_id=?";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, episodeId);
            ResultSet rs = pstmt.executeQuery();
            rs.next();
            Integer result = rs.getInt("count");

            rs.close();
            pstmt.close();
            connection.close();
            return result;

        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


}
