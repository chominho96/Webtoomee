package com.example.user;

import com.example.db_connect.DbConnect;
import com.example.webtoon.Webtoon;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class User {
    private Integer userId;
    private String userType;
    private String userName;
    private String userLoginId;
    private String userPassword;
    private LocalDateTime createdAt;

    public Integer getUserId() {
        return userId;
    }

    public String getUserType() {
        return userType;
    }

    public String getUserName() {
        return userName;
    }

    public String getUserLoginId() {
        return userLoginId;
    }

    public String getUserPassword() {
        return userPassword;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public User(Integer userId, String userType, String userName, String userLoginId, String userPassword, String createdAt) {
        this.userId = userId;
        this.userType = userType;
        this.userName = userName;
        this.userLoginId = userLoginId;
        this.userPassword = userPassword;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        this.createdAt = LocalDateTime.parse(createdAt, formatter);
    }

    public static User findUser(Integer userId) {
        try {
            Connection connection = DbConnect.dbConnect();
            String query = "select * from user where user_id=?";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            rs.next();
            rs.last();

            if (rs.getRow() == 0) {
                connection.close();
                return null;
            }
            else {
                rs.beforeFirst();
                rs.next();
                connection.close();
                return new User(rs.getInt("user_id"), rs.getString("user_type"),
                        rs.getString("user_name"), rs.getString("user_login_id"),
                        rs.getString("user_pwd"), rs.getString("created_at"));
            }

        }
        catch (Exception e) {
            return null;
        }

    }

    public static List<User> findAllAuthor() {
        try {
            List<User> result = new ArrayList<>();

            Connection connection = DbConnect.dbConnect();
            String query = "select * from user where user_type='author'";
            PreparedStatement pstmt = connection.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                result.add(new User(rs.getInt("user_id"), rs.getString("user_type"),
                        rs.getString("user_name"), rs.getString("user_login_id"),
                        rs.getString("user_pwd"), rs.getString("created_at")));
            }

            connection.close();
            return result;

        }
        catch (Exception e) {
            return null;
        }
    }

}
