package com.herb.dao;

import com.herb.model.Order;
import com.herb.model.OrderItem;
import com.herb.util.DBUtil;

import java.sql.*;
import java.util.UUID;

public class OrderDAO {

    // 创建订单
    public boolean createOrder(Order order) {
        Connection conn = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 开始事务

            // 1. 插入订单主表
            String sqlOrder = "INSERT INTO orders (order_id, user_name, address, total_amount, status) VALUES (?, ?, ?, ?, ?)";
            psOrder = conn.prepareStatement(sqlOrder);
            psOrder.setString(1, order.getOrderId());
            psOrder.setString(2, order.getUserName());
            psOrder.setString(3, order.getAddress());
            psOrder.setBigDecimal(4, order.getTotalAmount());
            psOrder.setString(5, order.getStatus());
            psOrder.executeUpdate();

            // 2. 插入订单明细
            String sqlItem = "INSERT INTO order_items (order_id, herb_id, quantity, current_price) VALUES (?, ?, ?, ?)";
            psItem = conn.prepareStatement(sqlItem);

            for (OrderItem item : order.getItems()) {
                psItem.setString(1, order.getOrderId());
                psItem.setInt(2, item.getHerbId());
                psItem.setInt(3, item.getQuantity());
                psItem.setBigDecimal(4, item.getCurrentPrice());
                psItem.addBatch();
            }
            psItem.executeBatch();

            conn.commit(); // 提交事务
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            DBUtil.close(conn, psOrder, null);
            DBUtil.close(null, psItem, null);
        }
    }

    // 生成订单ID（时间戳+随机数）
    public String generateOrderId() {
        String timestamp = String.valueOf(System.currentTimeMillis());
        String random = UUID.randomUUID().toString().substring(0, 8);
        return "ORD" + timestamp + random.toUpperCase();
    }
}