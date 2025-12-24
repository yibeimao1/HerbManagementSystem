package com.herb.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 退出登录Servlet
 * 处理用户退出登录请求
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * 处理GET请求（直接访问/logout时）
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    /**
     * 处理POST请求（通过表单提交退出时）
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }

    /**
     * 处理退出登录的核心逻辑
     */
    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // 获取当前session（如果不存在则不创建新的）
        HttpSession session = request.getSession(false);

        if (session != null) {
            try {
                // 1. 记录日志（可选）
                String username = (String) session.getAttribute("username");
                System.out.println("用户 " + (username != null ? username : "未知用户") + " 退出登录");

                // 2. 移除所有session属性
                session.removeAttribute("user");        // 用户对象
                session.removeAttribute("username");    // 用户名
                session.removeAttribute("userId");      // 用户ID
                session.removeAttribute("userRole");    // 用户角色
                session.removeAttribute("isLoggedIn");  // 登录状态

                // 3. 使session失效（清除所有数据）
                session.invalidate();

                System.out.println("Session已失效，用户成功退出");

            } catch (IllegalStateException e) {
                // session已经失效的情况
                System.out.println("Session已经失效");
            }
        }

        // 4. 重定向到登录页面
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}