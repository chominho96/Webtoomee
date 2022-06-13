package com.example.login;

import com.example.user.User;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;



public class LoginUser {

    /**
     * @return 로그인된 사용자가 없으면 null return
     * 로그인된 사용자가 있으면 user ID return
     */
    public static Integer getLoginUser(HttpServletRequest request, HttpSession session) {
        String userUUID = null;
        boolean isLogin = false;
        Cookie[] cookies = request.getCookies();
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("id")) {
                isLogin = true;
                userUUID = cookie.getValue();
            }
        }
        if (!isLogin) {
            return null;
        }
        Object attribute = session.getAttribute(userUUID);
        if (attribute == null) {
            return null;
        }

        Integer userId = Integer.parseInt((String) attribute);

        User findUser = User.findUser(userId);
        if (findUser == null) {
            return null;
        }
        return findUser.getUserId();
    }
}
