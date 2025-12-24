<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.herb.model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>用户主页 - 中药材销售系统</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Microsoft YaHei', Arial, sans-serif;
      background-color: #f5f7fa;
    }

    .header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 20px 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .logo {
      font-size: 24px;
      font-weight: bold;
    }

    .user-info {
      display: flex;
      align-items: center;
      gap: 20px;
    }

    .welcome {
      font-size: 16px;
    }

    .btn-logout {
      padding: 8px 20px;
      background: rgba(255, 255, 255, 0.2);
      color: white;
      border: 1px solid rgba(255, 255, 255, 0.3);
      border-radius: 5px;
      cursor: pointer;
      transition: background 0.3s;
    }

    .btn-logout:hover {
      background: rgba(255, 255, 255, 0.3);
    }

    .nav {
      background: white;
      padding: 15px 40px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    }

    .nav ul {
      list-style: none;
      display: flex;
      gap: 30px;
    }

    .nav a {
      text-decoration: none;
      color: #555;
      font-weight: 500;
      padding: 8px 16px;
      border-radius: 5px;
      transition: all 0.3s;
    }

    .nav a:hover {
      background: #f0f2f5;
      color: #667eea;
    }

    .nav a.active {
      background: #667eea;
      color: white;
    }

    .main-content {
      padding: 40px;
      max-width: 1200px;
      margin: 0 auto;
    }

    .dashboard {
      background: white;
      border-radius: 10px;
      padding: 30px;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
    }

    .dashboard h2 {
      color: #333;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 2px solid #f0f2f5;
    }

    .user-details {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin-bottom: 30px;
    }

    .detail-card {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 8px;
      border-left: 4px solid #667eea;
    }

    .detail-card h3 {
      color: #555;
      font-size: 14px;
      margin-bottom: 10px;
    }

    .detail-card p {
      color: #333;
      font-size: 18px;
      font-weight: 500;
    }

    .quick-actions {
      display: flex;
      gap: 15px;
      flex-wrap: wrap;
    }

    .action-btn {
      padding: 12px 24px;
      background: #667eea;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 14px;
      font-weight: 500;
      transition: background 0.3s;
    }

    .action-btn:hover {
      background: #5a67d8;
    }

    .action-btn.secondary {
      background: #48bb78;
    }

    .action-btn.secondary:hover {
      background: #38a169;
    }

    .footer {
      text-align: center;
      padding: 20px;
      color: #718096;
      font-size: 14px;
      margin-top: 40px;
      border-top: 1px solid #e2e8f0;
    }
  </style>
</head>
<body>
<div class="header">
  <div class="logo">中药材销售系统</div>
  <div class="user-info">
    <div class="welcome">欢迎，<strong><%= user.getUsername() %></strong>！</div>
    <button class="btn-logout" onclick="location.href='logout'">退出登录</button>
  </div>
</div>

<div class="nav">
  <ul>
    <li><a href="user.jsp" class="active">用户主页</a></li>
    <li><a href="mall.jsp">药材商城</a></li>
    <li><a href="cart.jsp">购物车</a></li>
    <li><a href="herb-list.jsp">药材管理</a></li>
  </ul>
</div>

<div class="main-content">
  <div class="dashboard">
    <h2>用户信息</h2>

    <div class="user-details">
      <div class="detail-card">
        <h3>用户名</h3>
        <p><%= user.getUsername() %></p>
      </div>
      <div class="detail-card">
        <h3>用户角色</h3>
        <p><%= "admin".equals(user.getRole()) ? "管理员" : "普通用户" %></p>
      </div>
      <div class="detail-card">
        <h3>邮箱</h3>
        <p><%= user.getEmail() != null ? user.getEmail() : "未设置" %></p>
      </div>
      <div class="detail-card">
        <h3>注册时间</h3>
        <p><%= user.getCreatedTime() != null ?
                new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(user.getCreatedTime()) : "未知" %></p>
      </div>
    </div>

    <h2>快捷操作</h2>
    <div class="quick-actions">
      <button class="action-btn" onclick="location.href='mall.jsp'">开始购物</button>
      <button class="action-btn" onclick="location.href='cart.jsp'">查看购物车</button>
      <button class="action-btn" onclick="location.href='herb-list.jsp'">管理药材</button>
      <button class="action-btn secondary" onclick="location.href='#'">修改资料</button>
    </div>
  </div>
</div>

<div class="footer">
  <p>中药材销售系统 &copy; 2023 - 基于MVC架构的在线销售平台</p>
</div>
</body>
</html>