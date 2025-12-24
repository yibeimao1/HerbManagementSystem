package com.herb.servlet;

import com.herb.dao.HerbDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/checkCode")
public class CheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=utf-8");

        // 获取参数
        String code = request.getParameter("code");
        String excludeIdStr = request.getParameter("id");

        System.out.println("检查编号请求：code=" + code + ", excludeId=" + excludeIdStr);

        // 验证参数
        if (code == null || code.trim().isEmpty()) {
            sendErrorResponse(response, "缺少编号参数");
            return;
        }

        HerbDAO herbDAO = new HerbDAO();
        boolean exists;

        if (excludeIdStr != null && !excludeIdStr.trim().isEmpty()) {
            try {
                int excludeId = Integer.parseInt(excludeIdStr.trim());
                System.out.println("检查编号（排除ID=" + excludeId + "）：" + code);
                exists = herbDAO.checkCodeExists(code, excludeId);
            } catch (NumberFormatException e) {
                System.err.println("ID格式错误：" + excludeIdStr);
                exists = herbDAO.checkCodeExists(code);
            }
        } else {
            System.out.println("检查编号：" + code);
            exists = herbDAO.checkCodeExists(code);
        }

        // 返回JSON：{exists: true/false}
        String json = "{\"exists\":" + exists + "}";
        System.out.println("返回结果：" + json);

        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
        out.close();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * 发送错误响应
     */
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        String json = "{\"error\":\"" + message + "\"}";

        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
        out.close();
    }
}