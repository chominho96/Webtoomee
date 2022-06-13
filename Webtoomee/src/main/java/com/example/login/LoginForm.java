package com.example.login;

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
