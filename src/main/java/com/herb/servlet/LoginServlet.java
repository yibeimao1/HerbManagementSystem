package com.herb.servlet;

import com.herb.dao.UserDAO;
import com.herb.listener.SessionListener;
import com.herb.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果已登录，直接跳转到对应页面
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                response.sendRedirect("admin.jsp");
            } else {
                response.sendRedirect("user.jsp");
            }
            return;
        }
        // 否则显示登录页面
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String captcha = request.getParameter("captcha");

        System.out.println("登录尝试: " + username + ", 验证码: " + captcha);

        // 1. 验证码校验（固定为1111）
        if (!"1111".equals(captcha)) {
            System.out.println("验证码错误，用户输入: " + captcha + "，应为: 1111");
            request.setAttribute("error", "验证码错误！请输入：1111");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 2. 用户名密码校验
        User user = userDAO.authenticate(username, password);
        if (user == null) {
            request.setAttribute("error", "用户名或密码错误！");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 3. 检查用户是否已在其他地方登录
        if (SessionListener.isUserAlreadyLoggedIn(user.getId())) {
            request.setAttribute("error", "该用户已在其他地方登录！");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 4. 登录成功
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // 5. 限制单用户登录
        SessionListener.invalidateOtherSessions(user.getId(), session);

        System.out.println("登录成功: " + username + ", 角色: " + user.getRole());

        // 6. 获取原始请求URL（如果有）
        String originalURL = (String) session.getAttribute("originalURL");
        if (originalURL != null && !originalURL.isEmpty()) {
            session.removeAttribute("originalURL");
            response.sendRedirect(originalURL);
        } else {
            // 根据角色跳转到不同页面
            if (user.isAdmin()) {
                response.sendRedirect("admin.jsp");
            } else {
                response.sendRedirect("user.jsp");
            }
        }
    }
}