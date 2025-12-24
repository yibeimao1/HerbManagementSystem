<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.herb.model.CartItem" %>
<%@ page import="com.herb.servlet.CartServlet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
  List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
  BigDecimal totalAmount = CartServlet.calculateTotal(cart);
%>
<!DOCTYPE html>
<html>
<head>
  <title>购物车 - 中药材销售系统</title>
  <style>
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
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .logo {
      font-size: 22px;
      font-weight: bold;
    }

    .nav-links {
      display: flex;
      gap: 25px;
    }

    .nav-links a {
      color: white;
      text-decoration: none;
      font-size: 16px;
      padding: 8px 16px;
      border-radius: 20px;
      transition: background 0.3s;
    }

    .nav-links a:hover {
      background: rgba(255, 255, 255, 0.2);
    }

    .nav-links a.active {
      background: rgba(255, 255, 255, 0.3);
    }

    .main-content {
      padding: 30px 40px;
      max-width: 1200px;
      margin: 0 auto;
    }

    .page-title {
      font-size: 28px;
      color: #333;
      margin-bottom: 30px;
      padding-bottom: 15px;
      border-bottom: 2px solid #e1e5e9;
    }

    .cart-container {
      background: white;
      border-radius: 10px;
      padding: 30px;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
    }

    <% if (cart == null || cart.isEmpty()) { %>
    .empty-cart {
      text-align: center;
      padding: 60px 20px;
    }

    .empty-cart h3 {
      font-size: 24px;
      color: #718096;
      margin-bottom: 20px;
    }

    .empty-cart p {
      color: #a0aec0;
      margin-bottom: 30px;
    }

    .btn-shopping {
      display: inline-block;
      padding: 12px 30px;
      background: #667eea;
      color: white;
      text-decoration: none;
      border-radius: 6px;
      font-weight: 500;
    }
    <% } else { %>
    .cart-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 30px;
    }

    .cart-table th {
      background: #f8f9fa;
      padding: 15px;
      text-align: left;
      color: #555;
      font-weight: 600;
      border-bottom: 2px solid #e1e5e9;
    }

    .cart-table td {
      padding: 20px 15px;
      border-bottom: 1px solid #e1e5e9;
      vertical-align: middle;
    }

    .product-info {
      display: flex;
      align-items: center;
      gap: 15px;
    }

    .product-image {
      width: 60px;
      height: 60px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 20px;
    }

    .product-name {
      font-weight: 500;
      color: #333;
    }

    .product-price {
      color: #ff6b6b;
      font-weight: 600;
    }

    .quantity-controls {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .quantity-btn {
      width: 30px;
      height: 30px;
      border: 1px solid #e1e5e9;
      background: white;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
    }

    .quantity-input {
      width: 60px;
      height: 30px;
      border: 1px solid #e1e5e9;
      border-radius: 4px;
      text-align: center;
      font-size: 14px;
    }

    .btn-update {
      padding: 6px 12px;
      background: #48bb78;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 12px;
    }

    .btn-remove {
      padding: 6px 12px;
      background: #ff4757;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 12px;
    }

    .subtotal {
      color: #333;
      font-weight: 600;
    }

    .cart-summary {
      background: #f8f9fa;
      padding: 25px;
      border-radius: 8px;
      margin-top: 30px;
    }

    .summary-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 15px;
      font-size: 16px;
    }

    .summary-row.total {
      font-size: 20px;
      font-weight: bold;
      color: #333;
      border-top: 2px solid #e1e5e9;
      padding-top: 15px;
      margin-top: 15px;
    }

    .checkout-form {
      margin-top: 30px;
      padding-top: 25px;
      border-top: 2px solid #e1e5e9;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      margin-bottom: 8px;
      color: #555;
      font-weight: 500;
    }

    .form-group input {
      width: 100%;
      padding: 12px 15px;
      border: 2px solid #e1e5e9;
      border-radius: 8px;
      font-size: 16px;
    }

    .form-actions {
      display: flex;
      justify-content: space-between;
      margin-top: 30px;
    }

    .btn-clear {
      padding: 12px 24px;
      background: #a0aec0;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 500;
    }

    .btn-checkout {
      padding: 12px 30px;
      background: #667eea;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 500;
      font-size: 16px;
    }
    <% } %>

    .footer {
      text-align: center;
      padding: 20px;
      color: #718096;
      font-size: 14px;
      margin-top: 40px;
      border-top: 1px solid #e2e8f0;
    }
  </style>
  <script>
    function updateQuantity(herbId, input) {
      var form = document.createElement('form');
      form.method = 'post';
      form.action = 'cart';

      var actionInput = document.createElement('input');
      actionInput.type = 'hidden';
      actionInput.name = 'action';
      actionInput.value = 'update';
      form.appendChild(actionInput);

      var idInput = document.createElement('input');
      idInput.type = 'hidden';
      idInput.name = 'herbId';
      idInput.value = herbId;
      form.appendChild(idInput);

      var quantityInput = document.createElement('input');
      quantityInput.type = 'hidden';
      quantityInput.name = 'quantity';
      quantityInput.value = input.value;
      form.appendChild(quantityInput);

      document.body.appendChild(form);
      form.submit();
    }

    function removeItem(herbId) {
      if (confirm('确定要从购物车中移除这个商品吗？')) {
        var form = document.createElement('form');
        form.method = 'post';
        form.action = 'cart';

        var actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'remove';
        form.appendChild(actionInput);

        var idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'herbId';
        idInput.value = herbId;
        form.appendChild(idInput);

        document.body.appendChild(form);
        form.submit();
      }
    }

    function clearCart() {
      if (confirm('确定要清空购物车吗？')) {
        var form = document.createElement('form');
        form.method = 'post';
        form.action = 'cart';

        var actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'clear';
        form.appendChild(actionInput);

        document.body.appendChild(form);
        form.submit();
      }
    }

    function validateCheckout() {
      var address = document.getElementById('address').value;
      if (!address.trim()) {
        alert('请输入收货地址！');
        return false;
      }
      return true;
    }
  </script>
</head>
<body>
<div class="header">
  <div class="logo">中药材销售系统</div>
  <div class="nav-links">
    <a href="user.jsp">用户主页</a>
    <a href="mall.jsp">药材商城</a>
    <a href="cart.jsp" class="active">购物车</a>
  </div>
</div>

<div class="main-content">
  <h1 class="page-title">我的购物车</h1>

  <div class="cart-container">
    <% if (cart == null || cart.isEmpty()) { %>
    <div class="empty-cart">
      <h3>购物车是空的</h3>
      <p>快去商城挑选喜欢的药材吧！</p>
      <a href="mall.jsp" class="btn-shopping">去购物</a>
    </div>
    <% } else { %>
    <table class="cart-table">
      <thead>
      <tr>
        <th width="40%">商品信息</th>
        <th width="15%">单价</th>
        <th width="20%">数量</th>
        <th width="15%">小计</th>
        <th width="10%">操作</th>
      </tr>
      </thead>
      <tbody>
      <% for (CartItem item : cart) { %>
      <tr>
        <td>
          <div class="product-info">
            <div class="product-image">
              <%= item.getHerbName().charAt(0) %>
            </div>
            <div>
              <div class="product-name"><%= item.getHerbName() %></div>
            </div>
          </div>
        </td>
        <td class="product-price">¥<%= item.getPrice() %></td>
        <td>
          <div class="quantity-controls">
            <input type="number" class="quantity-input"
                   value="<%= item.getQuantity() %>" min="1"
                   onchange="updateQuantity(<%= item.getHerbId() %>, this)">
          </div>
        </td>
        <td class="subtotal">¥<%= item.getSubtotal() %></td>
        <td>
          <button class="btn-remove"
                  onclick="removeItem(<%= item.getHerbId() %>)">
            移除
          </button>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>

    <div class="cart-summary">
      <div class="summary-row">
        <span>商品总计：</span>
        <span>¥<%= totalAmount %></span>
      </div>
      <div class="summary-row">
        <span>运费：</span>
        <span>¥0.00</span>
      </div>
      <div class="summary-row total">
        <span>应付总额：</span>
        <span>¥<%= totalAmount %></span>
      </div>
    </div>

    <form action="order" method="post" class="checkout-form"
          onsubmit="return validateCheckout()">
      <div class="form-group">
        <label for="address">收货地址：</label>
        <input type="text" id="address" name="address"
               placeholder="请输入详细的收货地址" required>
      </div>

      <div class="form-actions">
        <button type="button" class="btn-clear" onclick="clearCart()">
          清空购物车
        </button>
        <button type="submit" class="btn-checkout">
          提交订单（¥<%= totalAmount %>）
        </button>
      </div>
    </form>
    <% } %>
  </div>
</div>

<div class="footer">
  <p>中药材销售系统 &copy; 2023 - 品质保证，假一赔十</p>
</div>
</body>
</html>