package com.example.db_connect;

import java.sql.Connection;
import java.sql.DriverManager;

public class DbConnect {
    public static Connection dbConnect() throws Exception {
        Class.forName("org.mariadb.jdbc.Driver");

        // TODO : 이름 변경
        //String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
        String DB_URL = "jdbc:mariadb://localhost:3307/webtoon?useSSL=false";

        // TODO : 이름 변경
        //String DB_USER = "admin";
        //String DB_PASSWORD= "1234";
        String DB_USER = "root";
        String DB_PASSWORD = "whalsgh9664!";
        // TODO : 이름 변경
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); // 연결자 획득
    }
}
