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

@WebServlet("/editHerb")
public class EditServlet extends HttpServlet {

    // GET请求：获取药材信息
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=utf-8");

        String idStr = request.getParameter("id");
        System.out.println("获取药材信息请求，ID：" + idStr);

        ResponseData<Herb> responseData;

        try {
            int id = Integer.parseInt(idStr);
            HerbDAO herbDAO = new HerbDAO();
            Herb herb = herbDAO.getHerbById(id);

            if (herb != null) {
                responseData = ResponseData.success(herb);
            } else {
                responseData = ResponseData.error("药材不存在");
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

    // POST请求：更新药材信息
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=utf-8");

        System.out.println("===== 收到更新药材请求 =====");

        // 获取表单参数
        String idStr = request.getParameter("id");
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
        System.out.println("id: " + idStr);
        System.out.println("code: " + code);
        System.out.println("name: " + name);

        ResponseData<String> responseData;

        try {
            int id = Integer.parseInt(idStr);

            // 验证必填字段
            if (code == null || code.trim().isEmpty()) {
                responseData = ResponseData.error("药材编号不能为空");
                sendResponse(response, responseData);
                return;
            }
            if (name == null || name.trim().isEmpty()) {
                responseData = ResponseData.error("药材名称不能为空");
                sendResponse(response, responseData);
                return;
            }

            // 检查编号是否已存在（排除当前ID）
            HerbDAO herbDAO = new HerbDAO();
            if (herbDAO.checkCodeExists(code, id)) {
                responseData = ResponseData.error("药材编号 \"" + code + "\" 已被其他药材使用");
                sendResponse(response, responseData);
                return;
            }

            // 创建Herb对象
            Herb herb = new Herb();
            herb.setId(id);
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
                responseData = ResponseData.error("价格格式错误，请输入数字（如：88.50）");
                sendResponse(response, responseData);
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
                responseData = ResponseData.error("库存格式错误，请输入整数");
                sendResponse(response, responseData);
                return;
            }

            System.out.println("准备更新药材：" + herb);

            // 更新药材到数据库
            boolean success = herbDAO.updateHerb(herb);

            if (success) {
                responseData = ResponseData.success("药材更新成功！");
                System.out.println("药材更新成功：" + id + " - " + name);
            } else {
                responseData = ResponseData.error("药材更新失败，请稍后重试");
                System.out.println("药材更新失败：" + id + " - " + name);
            }

        } catch (NumberFormatException e) {
            responseData = ResponseData.error("ID格式错误");
        }

        sendResponse(response, responseData);
    }

    /**
     * 发送响应
     */
    private void sendResponse(HttpServletResponse response, ResponseData<String> responseData) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(responseData);
        System.out.println("返回JSON：" + json);

        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
        out.close();
    }
}