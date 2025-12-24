package com.herb.listener;

import com.herb.model.User;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.HashMap;
import java.util.Map;

@WebListener
public class SessionListener implements HttpSessionListener {

    // 存储用户ID和会话的映射（限制同一用户只能有一个活跃会话）
    private static final Map<Integer, HttpSession> userSessions = new HashMap<>();

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        System.out.println("会话创建: " + se.getSession().getId());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        System.out.println("会话销毁: " + session.getId());

        // 从映射中移除
        User user = (User) session.getAttribute("user");
        if (user != null) {
            synchronized (userSessions) {
                HttpSession oldSession = userSessions.get(user.getId());
                if (oldSession == session) {
                    userSessions.remove(user.getId());
                    System.out.println("移除用户会话映射: " + user.getUsername());
                }
            }
        }
    }

    // 检查用户是否已在其他地方登录
    public static boolean isUserAlreadyLoggedIn(Integer userId) {
        synchronized (userSessions) {
            return userSessions.containsKey(userId);
        }
    }

    // 使同一用户的其他会话失效
    public static void invalidateOtherSessions(Integer userId, HttpSession currentSession) {
        synchronized (userSessions) {
            HttpSession oldSession = userSessions.get(userId);
            if (oldSession != null && !oldSession.getId().equals(currentSession.getId())) {
                try {
                    System.out.println("使用户的其他会话失效: " + oldSession.getId());
                    oldSession.invalidate();
                } catch (IllegalStateException e) {
                    // 会话已过期
                }
            }
            // 保存当前会话
            userSessions.put(userId, currentSession);
            System.out.println("保存用户会话映射: " + userId + " -> " + currentSession.getId());
        }
    }
}