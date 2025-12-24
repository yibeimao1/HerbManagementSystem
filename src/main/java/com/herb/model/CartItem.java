package com.herb.model;

import java.math.BigDecimal;

public class CartItem {
    private Integer herbId;
    private String herbName;
    private BigDecimal price;
    private Integer quantity;

    // 构造方法
    public CartItem() {}

    public CartItem(Integer herbId, String herbName, BigDecimal price, Integer quantity) {
        this.herbId = herbId;
        this.herbName = herbName;
        this.price = price;
        this.quantity = quantity;
    }

    // 计算小计
    public BigDecimal getSubtotal() {
        if (price != null && quantity != null) {
            return price.multiply(BigDecimal.valueOf(quantity));
        }
        return BigDecimal.ZERO;
    }

    // 增加数量
    public void addQuantity(int amount) {
        if (this.quantity == null) {
            this.quantity = 0;
        }
        this.quantity += amount;
    }

    // Getter和Setter
    public Integer getHerbId() { return herbId; }
    public void setHerbId(Integer herbId) { this.herbId = herbId; }

    public String getHerbName() { return herbName; }
    public void setHerbName(String herbName) { this.herbName = herbName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
}