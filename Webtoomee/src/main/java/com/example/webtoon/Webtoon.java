package com.example.webtoon;

import com.example.db_connect.DbConnect;
import com.example.user.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class Webtoon {
    private Integer webtoonid;
    private Integer authorId;
    private String webtoonTitle;
    private String webtoonThumbnailAddr;
    private String webtoonGenre;
    private String webtoonSummary;
    private String webtoonAuthorWord;
    private LocalDateTime createdAt;

    public Integer getWebtoonid() {
        return webtoonid;
    }

    public Integer getAuthorId() {
        return authorId;
    }

    public String getWebtoonTitle() {
        return webtoonTitle;
    }

    public String getWebtoonThumbnailAddr() {
        return webtoonThumbnailAddr;
    }

    public String getWebtoonGenre() {
        return webtoonGenre;
    }

    public String getWebtoonSummary() {
        return webtoonSummary;
    }

    public String getWebtoonAuthorWord() {
        return webtoonAuthorWord;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public Webtoon(Integer webtoonid, Integer authorId, String webtoonTitle, String webtoonThumbnailAddr,
                   String webtoonGenre, String webtoonSummary, String webtoonAuthorWord, String createdAt) {
        this.webtoonid = webtoonid;
        this.authorId = authorId;
        this.webtoonTitle = webtoonTitle;
        this.webtoonThumbnailAddr = webtoonThumbnailAddr;
        this.webtoonGenre = webtoonGenre;
        this.webtoonSummary = webtoonSummary;
        this.webtoonAuthorWord = webtoonAuthorWord;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        this.createdAt = LocalDateTime.parse(createdAt, formatter);
    }

    /**
     *
     * 작가 ID로 모든 웹툰 조회
     */
    public static List<Webtoon> getAllWebtoonByUser(Integer authorId) {
        try {
            User findUser = User.findUser(authorId);
            if (findUser == null) {
                return null;
            }
            Connection connection = DbConnect.dbConnect();
            String query = "select * from webtoon where wtn_author=?";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, authorId);
            ResultSet rs = pstmt.executeQuery();

            List<Webtoon> result = new ArrayList<>();

            while (rs.next()) {
                result.add(new Webtoon(rs.getInt("wtn_id"), authorId, rs.getString("wtn_title"),
                        rs.getString("wtn_thb"), rs.getString("wtn_genre"), rs.getString("wtn_summ"),
                        rs.getString("wtn_auth_word"), rs.getString("created_at")));
            }

            connection.close();
            return result;

        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public static Double getRating (Integer webtoonId) {
        try {
            Connection connection = DbConnect.dbConnect();
            String query = "select ifnull(avg(rt_score), 0) as 'rating' from rating where epi_id in (select epi_id from episode where wtn_id=?)";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, webtoonId);
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
}
