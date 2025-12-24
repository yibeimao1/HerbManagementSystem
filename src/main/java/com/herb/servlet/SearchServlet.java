package com.herb.servlet;

import com.herb.dao.HerbDAO;
import com.herb.model.Herb;
import com.herb.util.JSONUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private HerbDAO herbDAO = new HerbDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== SearchServlet.doGet() 执行 ===");

        // 1. 接收搜索关键字
        String keyword = request.getParameter("keyword");
        System.out.println("接收到的搜索关键词: " + keyword);

        // 2. 验证参数
        if (keyword == null || keyword.trim().isEmpty()) {
            // 如果没有关键词，返回所有药材（转到herb-list.jsp）
            System.out.println("关键词为空，返回所有药材列表");
            List<Herb> herbs = herbDAO.getAllHerbs();
            request.setAttribute("herbList", herbs);
            request.setAttribute("keyword", "");
            request.getRequestDispatcher("/herb-list.jsp").forward(request, response);
            return;
        }

        keyword = keyword.trim();

        // 3. 查询数据库
        List<Herb> herbs;
        try {
            herbs = herbDAO.searchByKeyword(keyword);
            System.out.println("数据库查询成功，找到 " + herbs.size() + " 个结果");
        } catch (Exception e) {
            System.err.println("数据库查询失败: " + e.getMessage());
            e.printStackTrace();

            // 出错时也返回HTML页面
            request.setAttribute("error", "数据库查询失败: " + e.getMessage());
            request.getRequestDispatcher("/herb-list.jsp").forward(request, response);
            return;
        }

        // 4. 检查请求类型 - 判断是否为AJAX请求
        boolean isAjaxRequest = false;

        // 检查常见的AJAX请求标识
        String acceptHeader = request.getHeader("Accept");
        String requestedWith = request.getHeader("X-Requested-With");
        String requestType = request.getParameter("requestType");

        System.out.println("请求头 Accept: " + acceptHeader);
        System.out.println("请求头 X-Requested-With: " + requestedWith);
        System.out.println("请求参数 requestType: " + requestType);

        // 判断是否为AJAX请求
        if ((acceptHeader != null && acceptHeader.contains("application/json"))
                || "XMLHttpRequest".equals(requestedWith)
                || "ajax".equals(requestType)
                || (requestedWith != null && requestedWith.equals("XMLHttpRequest"))) {
            isAjaxRequest = true;
            System.out.println("识别为AJAX请求");
        } else {
            System.out.println("识别为普通请求");
        }

        if (isAjaxRequest) {
            // AJAX请求 - 返回JSON格式
            handleAjaxRequest(response, keyword, herbs);
        } else {
            // 普通请求 - 转发到JSP页面
            handleNormalRequest(request, response, keyword, herbs);
        }
    }

    /**
     * 处理AJAX请求 - 返回JSON数据
     */
    private void handleAjaxRequest(HttpServletResponse response, String keyword, List<Herb> herbs)
            throws IOException {

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        PrintWriter out = response.getWriter();

        // 构建JSON响应
        Map<String, Object> jsonResult = new HashMap<>();
        jsonResult.put("success", true);
        jsonResult.put("keyword", keyword);
        jsonResult.put("count", herbs.size());
        jsonResult.put("timestamp", System.currentTimeMillis());

        // 构建结果列表
        Map<String, Object>[] results = new HashMap[herbs.size()];
        for (int i = 0; i < herbs.size(); i++) {
            Herb herb = herbs.get(i);
            Map<String, Object> herbMap = new HashMap<>();

            herbMap.put("id", herb.getId());
            herbMap.put("name", herb.getName() != null ? herb.getName() : "");
            herbMap.put("price", herb.getPrice() != null ? herb.getPrice().toString() : "0.00");
            herbMap.put("stock", herb.getStock() != null ? herb.getStock() : 0);

            // 添加库存状态
            Integer stock = herb.getStock();
            if (stock == null || stock <= 0) {
                herbMap.put("stockStatus", "out_of_stock");
                herbMap.put("available", false);
            } else if (stock < 10) {
                herbMap.put("stockStatus", "low_stock");
                herbMap.put("available", true);
            } else {
                herbMap.put("stockStatus", "in_stock");
                herbMap.put("available", true);
            }

            results[i] = herbMap;
        }
        jsonResult.put("results", results);
        jsonResult.put("herbs", herbs); // 保留原始数据，方便前端处理

        // 返回JSON
        String jsonResponse = mapToJson(jsonResult);
        System.out.println("返回JSON数据，长度: " + jsonResponse.length() + " 字符");

        out.write(jsonResponse);
        out.flush();
        out.close();
    }

    /**
     * 处理普通请求 - 转发到JSP页面
     */
    private void handleNormalRequest(HttpServletRequest request, HttpServletResponse response,
                                     String keyword, List<Herb> herbs)
            throws ServletException, IOException {

        // 将结果放到request中
        request.setAttribute("herbList", herbs);
        request.setAttribute("keyword", keyword);

        // 转发到herb-list.jsp页面
        System.out.println("转发到 herb-list.jsp 页面");
        request.getRequestDispatcher("/herb-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 也支持POST请求
        doGet(request, response);
    }

    // 将Map转换为JSON字符串（保持你原有的代码）
    private String mapToJson(Map<String, Object> map) {
        if (map == null) {
            return "{}";
        }

        StringBuilder json = new StringBuilder();
        json.append("{");

        boolean first = true;
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            if (!first) {
                json.append(",");
            }
            first = false;

            json.append("\"").append(entry.getKey()).append("\":");

            Object value = entry.getValue();
            if (value == null) {
                json.append("null");
            } else if (value instanceof String) {
                json.append("\"").append(escapeJson((String) value)).append("\"");
            } else if (value instanceof Number) {
                json.append(value);
            } else if (value instanceof Boolean) {
                json.append(value);
            } else if (value instanceof Map[]) {
                // 处理数组
                json.append("[");
                Map[] array = (Map[]) value;
                for (int i = 0; i < array.length; i++) {
                    if (i > 0) json.append(",");
                    json.append(mapToJson(array[i]));
                }
                json.append("]");
            } else if (value instanceof Map) {
                // 递归处理嵌套Map
                json.append(mapToJson((Map<String, Object>) value));
            } else {
                json.append("\"").append(value.toString()).append("\"");
            }
        }

        json.append("}");
        return json.toString();
    }

    // 转义JSON字符串中的特殊字符
    private String escapeJson(String str) {
        if (str == null) return "";

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            switch (c) {
                case '\"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '/': sb.append("\\/"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }
}