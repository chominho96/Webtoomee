package com.example.webtoon;

import com.example.db_connect.DbConnect;
import com.example.user.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.DoubleBinaryOperator;

public class Webtoon {
    private Integer webtoonid;
    private Integer authorId;
    private String webtoonTitle;
    private String webtoonThumbnailAddr;
    private String webtoonGenre;
    private String webtoonSummary;
    private String webtoonAuthorWord;
    private LocalDateTime createdAt;

    public Integer getWebtoonId() {
        return webtoonid;
    }

    public Integer getAuthorId() {
        return authorId;
    }

    public String getWebtoonTitle() {
        return webtoonTitle;
    }

    public String getWebtoonFileName() {
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

    public static Webtoon findById (Integer webtoonId) {
        try {
            Connection connection = DbConnect.dbConnect();
            String query = "select * from webtoon where wtn_id=?";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, webtoonId);
            ResultSet rs = pstmt.executeQuery();
            rs.next();

            return new Webtoon(webtoonId, rs.getInt("wtn_author"), rs.getString("wtn_title"),
                    rs.getString("wtn_thb"), rs.getString("wtn_genre"),
                    rs.getString("wtn_summ"), rs.getString("wtn_auth_word"),
                    rs.getString("created_at"));
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static List<Webtoon> findAll() {
        try {
            List<Webtoon> result = new ArrayList<>();

            Connection connection = DbConnect.dbConnect();
            String query = "select * from webtoon";
            PreparedStatement pstmt = connection.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                result.add(new Webtoon(rs.getInt("wtn_id"), rs.getInt("wtn_author"), rs.getString("wtn_title"),
                        rs.getString("wtn_thb"), rs.getString("wtn_genre"),
                        rs.getString("wtn_summ"), rs.getString("wtn_auth_word"),
                        rs.getString("created_at")));
            }

            connection.close();
            return result;

        }
        catch (Exception e) {
            return null;
        }
    }

    public static Map<String, List<Webtoon>> findByGenre() {
        try {
            Map<String, List<Webtoon>> resultMap = new HashMap<>();
            String[] genreList = { "daily", "comic", "fantasy", "action" };

            Connection connection = DbConnect.dbConnect();
            for (int i = 0; i < genreList.length; i++) {
                List<Webtoon> result = new ArrayList<>();

                String query = "select * from webtoon where wtn_genre=?";
                PreparedStatement pstmt = connection.prepareStatement(query);
                pstmt.setString(1, genreList[i]);
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    result.add(new Webtoon(rs.getInt("wtn_id"), rs.getInt("wtn_author"),
                            rs.getString("wtn_title"), rs.getString("wtn_thb"),
                            rs.getString("wtn_genre"), rs.getString("wtn_summ"),
                            rs.getString("wtn_auth_word"), rs.getString("created_at")));
                }
                resultMap.put(genreList[i], result);

            }

            connection.close();
            return resultMap;

        }
        catch (Exception e) {
            return null;
        }
    }

    public static Map<Integer, List<Webtoon>> findByAuthor() {
        try {
            Map<Integer, List<Webtoon>> resultMap = new HashMap<>();
            List<User> authorList = User.findAllAuthor();

            Connection connection = DbConnect.dbConnect();
            if (authorList != null) {
                for (User author : authorList) {
                    List<Webtoon> result = new ArrayList<>();

                    String query = "select * from webtoon where wtn_author=?";
                    PreparedStatement pstmt = connection.prepareStatement(query);
                    pstmt.setInt(1, author.getUserId());
                    ResultSet rs = pstmt.executeQuery();

                    while (rs.next()) {
                        result.add(new Webtoon(rs.getInt("wtn_id"), rs.getInt("wtn_author"),
                                rs.getString("wtn_title"), rs.getString("wtn_thb"),
                                rs.getString("wtn_genre"), rs.getString("wtn_summ"),
                                rs.getString("wtn_auth_word"), rs.getString("created_at")));
                    }
                    resultMap.put(author.getUserId(), result);
                }
            }
            else {
                return null;
            }

            connection.close();
            return resultMap;

        }
        catch (Exception e) {
            return null;
        }
    }
}
