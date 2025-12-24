package com.herb.servlet;

import com.herb.dao.HerbDAO;
import com.herb.dao.OrderDAO;
import com.herb.model.CartItem;
import com.herb.model.Order;
import com.herb.model.OrderItem;
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

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private HerbDAO herbDAO = new HerbDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 检查用户是否登录
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 获取购物车
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            request.setAttribute("error", "购物车为空！");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        // 获取收货地址
        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            request.setAttribute("error", "请输入收货地址！");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        try {
            // 1. 检查库存
            if (!checkStock(cart)) {
                request.setAttribute("error", "部分商品库存不足，请重新调整购物车！");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            // 2. 锁定库存（减少库存）
            if (!lockStock(cart)) {
                request.setAttribute("error", "库存锁定失败，请稍后重试！");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            // 3. 创建订单
            String orderId = orderDAO.generateOrderId();
            BigDecimal totalAmount = CartServlet.calculateTotal(cart);

            Order order = new Order(orderId, user.getUsername(), address, totalAmount);

            // 4. 创建订单项
            List<OrderItem> orderItems = new ArrayList<>();
            for (CartItem cartItem : cart) {
                OrderItem orderItem = new OrderItem(
                        orderId,
                        cartItem.getHerbId(),
                        cartItem.getHerbName(),
                        cartItem.getQuantity(),
                        cartItem.getPrice()
                );
                orderItems.add(orderItem);
            }
            order.setItems(orderItems);

            // 5. 保存订单到数据库
            boolean success = orderDAO.createOrder(order);
            if (!success) {
                // 订单保存失败，恢复库存
                rollbackStock(cart);
                request.setAttribute("error", "订单创建失败，请稍后重试！");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            // 6. 清空购物车
            session.removeAttribute("cart");

            // 7. 跳转到成功页面
            request.setAttribute("orderId", orderId);
            request.getRequestDispatcher("order_success.jsp").forward(request, response);

            System.out.println("订单创建成功: " + orderId + ", 用户: " + user.getUsername() +
                    ", 金额: " + totalAmount);

        } catch (Exception e) {
            e.printStackTrace();
            rollbackStock(cart);
            request.setAttribute("error", "系统错误，请稍后重试！");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }

    // 检查库存
    private boolean checkStock(List<CartItem> cart) {
        for (CartItem item : cart) {
            com.herb.model.Herb herb = herbDAO.getHerbById(item.getHerbId());
            if (herb == null || herb.getStock() == null) {
                return false; // 商品不存在
            }
            // 比较库存和购买数量
            if (herb.getStock() < item.getQuantity()) {  // 这里 Integer 会自动拆箱为 int
                return false; // 库存不足
            }
        }
        return true;
    }

    // 锁定库存（减少库存）
    private boolean lockStock(List<CartItem> cart) {
        for (CartItem item : cart) {
            boolean success = herbDAO.updateStock(item.getHerbId(), item.getQuantity());
            if (!success) {
                return false;
            }
        }
        return true;
    }

    // 回滚库存（订单失败时恢复库存）
    private void rollbackStock(List<CartItem> cart) {
        // 注意：这里需要实现增加库存的逻辑
        // 由于 HerbDAO.updateStock 是减少库存，我们需要一个增加库存的方法
        // 暂时只记录日志
        System.out.println("订单失败，需要恢复库存的商品数量: " + cart.size());
        for (CartItem item : cart) {
            System.out.println("商品ID: " + item.getHerbId() + ", 数量: " + item.getQuantity());
        }
        // TODO: 实现库存恢复逻辑
    }
}