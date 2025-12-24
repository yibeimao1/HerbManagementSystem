package com.herb.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.herb.dao.HerbDAO;
import com.herb.model.ResponseData;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/deleteHerb")
public class DeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=utf-8");

        String idStr = request.getParameter("id");
        System.out.println("收到删除请求，ID：" + idStr);

        ResponseData<String> responseData;

        try {
            int id = Integer.parseInt(idStr);
            HerbDAO herbDAO = new HerbDAO();
            boolean success = herbDAO.deleteById(id);

            if (success) {
                responseData = ResponseData.success("删除成功");
            } else {
                responseData = ResponseData.error("删除失败，可能是ID不存在");
            }
        } catch (NumberFormatException e) {
            responseData = ResponseData.error("ID格式错误");
        }

        // 转换为JSON
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(responseData);

        // 输出JSON
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}