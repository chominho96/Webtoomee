package com.example.login;

import com.example.db_connect.DbConnect;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;

public class Login {

    /**
     *
     * 실패 시 false return
     * 성공 시 쿠키, 세션에 값 설정 및 true return
     */
    public static boolean login(HttpServletResponse response, HttpSession session, LoginForm loginForm) {
        try {
            Connection connection = DbConnect.dbConnect();
            String query = "select * from user where user_login_id=?";
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setString(1, loginForm.getLoginId());
            ResultSet rs = pstmt.executeQuery();

            rs.last();
            if (rs.getRow() == 0) {
                return false;
            }
            rs.beforeFirst();
            rs.next();

            String uuid = String.valueOf(UUID.randomUUID());
            session.setAttribute(uuid, rs.getString("user_id"));
            response.addCookie(new Cookie("id", uuid));

            connection.close();
            return true;
        }
        catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
