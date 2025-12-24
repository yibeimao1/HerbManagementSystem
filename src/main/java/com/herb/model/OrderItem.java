package com.herb.model;

import java.math.BigDecimal;

public class OrderItem {
    private Integer id;
    private String orderId;
    private Integer herbId;
    private String herbName;
    private Integer quantity;
    private BigDecimal currentPrice;

    // 构造方法
    public OrderItem() {}

    public OrderItem(String orderId, Integer herbId, String herbName, Integer quantity, BigDecimal currentPrice) {
        this.orderId = orderId;
        this.herbId = herbId;
        this.herbName = herbName;
        this.quantity = quantity;
        this.currentPrice = currentPrice;
    }

    // 计算小计
    public BigDecimal getSubtotal() {
        if (currentPrice != null && quantity != null) {
            return currentPrice.multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }

    // Getter和Setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public Integer getHerbId() { return herbId; }
    public void setHerbId(Integer herbId) { this.herbId = herbId; }

    public String getHerbName() { return herbName; }
    public void setHerbName(String herbName) { this.herbName = herbName; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public BigDecimal getCurrentPrice() { return currentPrice; }
    public void setCurrentPrice(BigDecimal currentPrice) { this.currentPrice = currentPrice; }
}