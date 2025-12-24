package com.herb.servlet;

import com.herb.dao.HerbDAO;
import com.herb.model.Herb;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/herbDetail")
public class DetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("\n\n========== 收到详情页请求 ==========");
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=utf-8");

        String idStr = request.getParameter("id");
        System.out.println("1. 接收到的ID参数：" + idStr);

        if (idStr == null || idStr.trim().isEmpty()) {
            System.out.println("错误：ID参数为空");
            response.getWriter().println("<h2>错误：请提供药材ID</h2>");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            System.out.println("2. 转换后的ID：" + id);

            System.out.println("3. 创建HerbDAO对象...");
            HerbDAO herbDAO = new HerbDAO();

            System.out.println("4. 调用getHerbById(" + id + ")...");
            Herb herb = herbDAO.getHerbById(id);

            System.out.println("5. 查询结果：" + (herb != null ? "成功" : "失败，返回null"));

            if (herb != null) {
                System.out.println("6. 药材信息：");
                System.out.println("   - 名称：" + herb.getName());
                System.out.println("   - 价格：" + herb.getPrice());
                System.out.println("   - 库存：" + herb.getStock());

                System.out.println("7. 将药材对象存入request...");
                request.setAttribute("herb", herb);

                System.out.println("8. 转发到 herb-detail.jsp...");
                request.getRequestDispatcher("herb-detail.jsp").forward(request, response);

                System.out.println("9. 转发完成");
            } else {
                System.out.println("6. 药材不存在，ID=" + id);
                response.getWriter().println("<h2>错误：药材ID=" + id + "不存在</h2>");
                response.getWriter().println("<a href='herb-list.jsp'>返回列表</a>");
            }
        } catch (NumberFormatException e) {
            System.out.println("错误：ID格式不正确 - " + idStr);
            response.getWriter().println("<h2>错误：ID格式不正确</h2>");
        } catch (Exception e) {
            System.out.println("异常：" + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("<h2>服务器错误</h2>");
            response.getWriter().println("<pre>" + e.toString() + "</pre>");
        }

        System.out.println("========== 请求处理结束 ==========\n");
    }
}