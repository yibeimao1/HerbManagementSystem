package com.herb.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.herb.dao.HerbDAO;
import com.herb.model.Herb;
import com.herb.model.ResponseData;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;

@WebServlet("/addHerb")
public class AddServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=utf-8");

        System.out.println("===== 收到添加药材请求 =====");

        // 获取表单参数
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String alias = request.getParameter("alias");
        String source = request.getParameter("source");
        String growthEnvironment = request.getParameter("growthEnvironment");
        String propertyTaste = request.getParameter("propertyTaste");
        String mainFunction = request.getParameter("mainFunction");
        String usageDosage = request.getParameter("usageDosage");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");

        // 打印接收到的参数（调试用）
        System.out.println("code: " + code);
        System.out.println("name: " + name);
        System.out.println("price: " + priceStr);
        System.out.println("stock: " + stockStr);

        // 验证必填字段
        if (code == null || code.trim().isEmpty()) {
            sendError(response, "药材编号不能为空");
            return;
        }
        if (name == null || name.trim().isEmpty()) {
            sendError(response, "药材名称不能为空");
            return;
        }

        // 检查编号是否已存在
        HerbDAO herbDAO = new HerbDAO();
        if (herbDAO.checkCodeExists(code)) {
            sendError(response, "药材编号 \"" + code + "\" 已存在，请使用其他编号");
            return;
        }

        // 创建Herb对象
        Herb herb = new Herb();
        herb.setCode(code.trim());
        herb.setName(name.trim());
        herb.setAlias(alias != null ? alias.trim() : null);
        herb.setSource(source != null ? source.trim() : null);
        herb.setGrowthEnvironment(growthEnvironment != null ? growthEnvironment.trim() : null);
        herb.setPropertyTaste(propertyTaste != null ? propertyTaste.trim() : null);
        herb.setMainFunction(mainFunction != null ? mainFunction.trim() : null);
        herb.setUsageDosage(usageDosage != null ? usageDosage.trim() : null);

        // 处理价格
        try {
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                herb.setPrice(new BigDecimal(priceStr.trim()));
            } else {
                herb.setPrice(BigDecimal.ZERO);
            }
        } catch (NumberFormatException e) {
            sendError(response, "价格格式错误，请输入数字（如：88.50）");
            return;
        }

        // 处理库存
        try {
            if (stockStr != null && !stockStr.trim().isEmpty()) {
                herb.setStock(Integer.parseInt(stockStr.trim()));
            } else {
                herb.setStock(0);
            }
        } catch (NumberFormatException e) {
            sendError(response, "库存格式错误，请输入整数");
            return;
        }

        System.out.println("准备添加药材：" + herb);

        // 添加药材到数据库
        boolean success = herbDAO.addHerb(herb);

        ResponseData<String> responseData;
        if (success) {
            responseData = ResponseData.success("药材添加成功！");
            System.out.println("药材添加成功：" + code + " - " + name);
        } else {
            responseData = ResponseData.error("药材添加失败，请稍后重试");
            System.out.println("药材添加失败：" + code + " - " + name);
        }

        // 转换为JSON
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(responseData);
        System.out.println("返回JSON：" + json);

        // 输出JSON
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
        out.close();
    }

    /**
     * 发送错误响应
     */
    private void sendError(HttpServletResponse response, String message) throws IOException {
        System.out.println("添加失败：" + message);

        ResponseData<String> responseData = ResponseData.error(message);
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(responseData);

        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
        out.close();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET请求时重定向到添加页面
        response.sendRedirect("herb-add.jsp");
    }
}