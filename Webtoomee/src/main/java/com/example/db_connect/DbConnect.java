package com.example.db_connect;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *  데이터베이스 연결을 위한 클래스입니다.
 */
public class DbConnect {
    /**
     *  데이터베이스 연결을 하고, Connection을 반환합니다.
     */
    public static Connection dbConnect() throws Exception {
        Class.forName("org.mariadb.jdbc.Driver");

        // TODO : 이름 변경
        //String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
        String DB_URL = "jdbc:mariadb://localhost:3307/webtoon?useSSL=false";

        String DB_USER = "admin";
        String DB_PASSWORD= "1234";
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD); // 연결자 획득
    }
}
