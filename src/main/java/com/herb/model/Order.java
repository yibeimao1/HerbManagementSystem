package com.herb.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {
    private String orderId;
    private String userName;
    private String address;
    private BigDecimal totalAmount;
    private Date orderTime;
    private String status;  // pending, paid, shipped, completed, cancelled
    private List<OrderItem> items;

    // 构造方法
    public Order() {}

    public Order(String orderId, String userName, String address, BigDecimal totalAmount) {
        this.orderId = orderId;
        this.userName = userName;
        this.address = address;
        this.totalAmount = totalAmount;
        this.status = "pending";
        this.orderTime = new Date();
    }

    // Getter和Setter
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public Date getOrderTime() { return orderTime; }
    public void setOrderTime(Date orderTime) { this.orderTime = orderTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
}