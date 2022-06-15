package com.example.login;

/**
 *  로그인 form을 받기 위한 클래스입니다.
 */
public class LoginForm {
    private String loginId;
    private String password;

    public String getLoginId() {
        return loginId;
    }

    public String getPassword() {
        return password;
    }

    public LoginForm(String loginId, String password) {
        this.loginId = loginId;
        this.password = password;
    }
}
