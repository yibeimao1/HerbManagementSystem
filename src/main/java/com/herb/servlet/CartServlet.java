package com.herb.servlet;

import com.herb.dao.HerbDAO;
import com.herb.model.CartItem;
import com.herb.model.Herb;
import com.herb.model.User;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private HerbDAO herbDAO = new HerbDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 跳转到购物车页面
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // 获取购物车
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        if ("add".equals(action)) {
            // 添加商品到购物车
            addToCart(request, response, cart);
        } else if ("remove".equals(action)) {
            // 从购物车移除商品
            removeFromCart(request, response, cart);
        } else if ("update".equals(action)) {
            // 更新购物车商品数量
            updateCart(request, response, cart);
        } else if ("clear".equals(action)) {
            // 清空购物车
            cart.clear();
            session.setAttribute("cart", cart);
            response.sendRedirect("cart.jsp");
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response,
                           List<CartItem> cart) throws ServletException, IOException {

        try {
            int herbId = Integer.parseInt(request.getParameter("herbId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // 获取药材信息
            com.herb.model.Herb herb = herbDAO.getHerbById(herbId);
            if (herb == null) {
                request.setAttribute("error", "商品不存在！");
                request.getRequestDispatcher("mall.jsp").forward(request, response);
                return;
            }

            // 检查库存
            if (herb.getStock() < quantity) {
                request.setAttribute("error", "库存不足！当前库存：" + herb.getStock());
                request.getRequestDispatcher("mall.jsp").forward(request, response);
                return;
            }

            // 检查购物车是否已有该商品
            boolean found = false;
            for (CartItem item : cart) {
                if (item.getHerbId().equals(herbId)) {
                    // 更新数量
                    item.addQuantity(quantity);
                    found = true;
                    break;
                }
            }

            // 如果购物车中没有该商品，添加新项
            if (!found) {
                CartItem newItem = new CartItem(herbId, herb.getName(), herb.getPrice(), quantity);
                cart.add(newItem);
            }

            System.out.println("添加到购物车: " + herb.getName() + " x" + quantity);

            // 返回商城页面
            response.sendRedirect("mall.jsp");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "参数错误！");
            request.getRequestDispatcher("mall.jsp").forward(request, response);
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response,
                                List<CartItem> cart) throws IOException {

        try {
            int herbId = Integer.parseInt(request.getParameter("herbId"));

            // 从购物车中移除商品
            cart.removeIf(item -> item.getHerbId().equals(herbId));

            response.sendRedirect("cart.jsp");

        } catch (NumberFormatException e) {
            response.sendRedirect("cart.jsp");
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response,
                            List<CartItem> cart) throws ServletException, IOException {

        try {
            int herbId = Integer.parseInt(request.getParameter("herbId"));
            int newQuantity = Integer.parseInt(request.getParameter("quantity"));

            if (newQuantity <= 0) {
                // 数量为0或负数，移除商品
                cart.removeIf(item -> item.getHerbId().equals(herbId));
            } else {
                // 检查库存
                com.herb.model.Herb herb = herbDAO.getHerbById(herbId);
                if (herb != null && herb.getStock() < newQuantity) {
                    request.setAttribute("error", "库存不足！当前库存：" + herb.getStock());
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                    return;
                }

                // 更新数量
                for (CartItem item : cart) {
                    if (item.getHerbId().equals(herbId)) {
                        item.setQuantity(newQuantity);
                        break;
                    }
                }
            }

            response.sendRedirect("cart.jsp");

        } catch (NumberFormatException e) {
            response.sendRedirect("cart.jsp");
        }
    }

    // 计算购物车总金额
    public static BigDecimal calculateTotal(List<CartItem> cart) {
        if (cart == null || cart.isEmpty()) {
            return BigDecimal.ZERO;
        }

        BigDecimal total = BigDecimal.ZERO;
        for (CartItem item : cart) {
            total = total.add(item.getSubtotal());
        }
        return total;
    }
}