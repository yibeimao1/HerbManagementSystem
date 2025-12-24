package com.herb.filter;

import com.herb.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter({
        "/cart.jsp",
        "/mall.jsp",
        "/user.jsp",
        "/admin.jsp",
        "/cart",
        "/order",
        "/CartServlet",
        "/OrderServlet"
})
public class LoginCheckFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("LoginCheckFilter初始化完成");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        System.out.println("LoginCheckFilter检查: " + requestURI);

        // 检查用户是否登录
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("用户未登录，跳转到登录页面");

            // 保存原始请求URL，登录后跳转回来
            String originalURL = httpRequest.getRequestURI();
            if (httpRequest.getQueryString() != null) {
                originalURL += "?" + httpRequest.getQueryString();
            }
            session = httpRequest.getSession();
            session.setAttribute("originalURL", originalURL);

            // 跳转到登录页面
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        System.out.println("用户已登录: " + user.getUsername() + ", 角色: " + user.getRole());

        // 检查权限（如果需要）
        if (requestURI.contains("/admin") || requestURI.contains("admin.jsp")) {
            if (!user.isAdmin()) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/user.jsp");
                return;
            }
        }

        // 继续执行
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("LoginCheckFilter销毁");
    }
}