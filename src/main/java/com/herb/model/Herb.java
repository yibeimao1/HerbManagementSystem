package com.herb.model;

import java.math.BigDecimal;

public class Herb {
    private Integer id;
    private String code;
    private String name;
    private String alias;
    private String source;
    private String growthEnvironment;
    private String propertyTaste;
    private String mainFunction;
    private String usageDosage;
    private BigDecimal price;
    private Integer stock;

    // 构造方法
    public Herb() {}

    public Herb(Integer id, String name, BigDecimal price, Integer stock) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.stock = stock;
    }

    // Getter 和 Setter - 所有字段
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAlias() { return alias; }
    public void setAlias(String alias) { this.alias = alias; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public String getGrowthEnvironment() { return growthEnvironment; }
    public void setGrowthEnvironment(String growthEnvironment) { this.growthEnvironment = growthEnvironment; }

    public String getPropertyTaste() { return propertyTaste; }
    public void setPropertyTaste(String propertyTaste) { this.propertyTaste = propertyTaste; }

    public String getMainFunction() { return mainFunction; }
    public void setMainFunction(String mainFunction) { this.mainFunction = mainFunction; }

    public String getUsageDosage() { return usageDosage; }
    public void setUsageDosage(String usageDosage) { this.usageDosage = usageDosage; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }
}