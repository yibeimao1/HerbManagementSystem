<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.herb.dao.HerbDAO" %>
<%@ page import="com.herb.model.Herb" %>
<%@ page import="java.util.List" %>
<%
    // 调试信息
    System.out.println("=== mall.jsp 开始执行 ===");

    HerbDAO herbDAO = new HerbDAO();
    List<Herb> herbs = herbDAO.getAllHerbs();

    System.out.println("商城药材数量: " + herbs.size());
    for (int i = 0; i < herbs.size(); i++) {
        Herb herb = herbs.get(i);
        System.out.println("商城药材" + i + ": " +
                "ID=" + herb.getId() +
                ", 名称=" + herb.getName() +
                ", 价格=" + herb.getPrice() +
                ", 库存=" + herb.getStock());
    }

    // 获取购物车信息
    List<com.herb.model.CartItem> cart = (List<com.herb.model.CartItem>) session.getAttribute("cart");
    int cartCount = 0;
    if (cart != null) {
        cartCount = cart.size();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>药材商城 - 中药材销售系统</title>
    <style>
        /* 保持原有样式不变 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background-color: #f8f9fa;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .logo {
            font-size: 22px;
            font-weight: bold;
        }

        .header-controls {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .cart-link {
            position: relative;
            color: white;
            text-decoration: none;
            font-size: 16px;
            padding: 8px 16px;
            border-radius: 20px;
            background: rgba(255,255,255,0.2);
            transition: background 0.3s;
        }

        .cart-link:hover {
            background: rgba(255,255,255,0.3);
        }

        .cart-count {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #ff4757;
            color: white;
            font-size: 12px;
            padding: 2px 6px;
            border-radius: 10px;
            min-width: 20px;
            text-align: center;
        }

        .main-content {
            padding: 30px 40px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .product-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

        .product-image {
            height: 180px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
        }

        .product-info {
            padding: 20px;
        }

        .product-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            min-height: 54px;
        }

        .product-price {
            font-size: 22px;
            font-weight: bold;
            color: #ff6b6b;
            margin-bottom: 10px;
        }

        .product-stock {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
        }

        .stock-in {
            color: #48bb78;
            font-weight: 500;
        }

        .stock-out {
            color: #ff4757;
        }

        .add-to-cart-form {
            display: flex;
            gap: 10px;
        }

        .quantity-input {
            flex: 1;
            padding: 8px;
            border: 2px solid #e1e5e9;
            border-radius: 5px;
            text-align: center;
        }

        .btn-add-cart {
            flex: 2;
            padding: 8px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.3s;
        }

        .btn-add-cart:hover {
            background: #5a67d8;
        }

        .btn-add-cart:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .footer {
            text-align: center;
            padding: 20px;
            color: #718096;
            font-size: 14px;
            margin-top: 40px;
            border-top: 1px solid #e2e8f0;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #718096;
        }

        .empty-state h3 {
            font-size: 24px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">中药材销售系统</div>
    <div class="header-controls">
        <a href="cart.jsp" class="cart-link">
            购物车
            <% if (cartCount > 0) { %>
            <span class="cart-count"><%= cartCount %></span>
            <% } %>
        </a>
        <div class="user-info">
            <button onclick="location.href='logout'">退出</button>
        </div>
    </div>
</div>

<div class="main-content">
    <% if (herbs.isEmpty()) { %>
    <div class="empty-state">
        <h3>暂无药材商品</h3>
        <p>请管理员添加药材信息</p>
    </div>
    <% } else { %>
    <div class="products-grid">
        <% for (Herb herb : herbs) { %>
        <div class="product-card">
            <div class="product-image">
                <%
                    if (herb.getName() != null && !herb.getName().isEmpty()) {
                        out.print(herb.getName().charAt(0));
                    } else {
                        out.print("药");
                    }
                %>
            </div>
            <div class="product-info">
                <div class="product-name">
                    <%= herb.getName() != null ? herb.getName() : "未知药材" %>
                </div>

                <div class="product-price">
                    <%
                        if (herb.getPrice() != null) {
                            out.print("¥" + herb.getPrice());
                        } else {
                            out.print("价格待定");
                        }
                    %>
                </div>

                <div class="product-stock">
                    库存：<span class="<%= (herb.getStock() != null && herb.getStock() > 0) ? "stock-in" : "stock-out" %>">
                                <%= herb.getStock() != null ? herb.getStock() : 0 %>件
                            </span>
                </div>

                <form action="cart" method="post" class="add-to-cart-form">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="herbId" value="<%= herb.getId() %>">
                    <input type="hidden" name="stock" value="<%= herb.getStock() != null ? herb.getStock() : 0 %>">

                    <input type="number" name="quantity" class="quantity-input"
                           value="1" min="1" max="<%= herb.getStock() != null ? herb.getStock() : 0 %>">

                    <button type="submit" class="btn-add-cart"
                            <%= (herb.getStock() != null && herb.getStock() > 0) ? "" : "disabled" %>>
                        <%= (herb.getStock() != null && herb.getStock() > 0) ? "加入购物车" : "已售罄" %>
                    </button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

<div class="footer">
    <p>中药材销售系统 &copy; 2023 - 诚信经营，质量保证</p>
</div>

<script>
    console.log("商城页面加载完成");
    console.log("药材数量: <%= herbs.size() %>");
</script>
</body>
</html>