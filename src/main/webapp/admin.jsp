<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.herb.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>管理员面板 - 中药材销售系统</title>
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
            background: linear-gradient(135deg, #2d3748 0%, #4a5568 100%);
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

        .admin-nav {
            background: white;
            padding: 0 40px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .admin-nav ul {
            list-style: none;
            display: flex;
        }

        .admin-nav li {
            border-bottom: 3px solid transparent;
        }

        .admin-nav a {
            display: block;
            padding: 18px 25px;
            text-decoration: none;
            color: #555;
            font-weight: 500;
            transition: all 0.3s;
        }

        .admin-nav a:hover,
        .admin-nav a.active {
            color: #2d3748;
            border-bottom-color: #667eea;
        }

        .main-content {
            padding: 40px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .dashboard-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .card-title {
            font-size: 18px;
            color: #4a5568;
            font-weight: 600;
        }

        .card-value {
            font-size: 32px;
            font-weight: bold;
            color: #2d3748;
            margin-bottom: 10px;
        }

        .card-change {
            font-size: 14px;
            color: #48bb78;
        }

        .card-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        .icon-sales { background: #667eea; }
        .icon-users { background: #ed64a6; }
        .icon-orders { background: #48bb78; }
        .icon-inventory { background: #f56565; }

        .admin-sections {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
        }

        .section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .section h3 {
            color: #2d3748;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f2f5;
        }

        .quick-actions {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .action-btn {
            padding: 12px 20px;
            background: #edf2f7;
            border: none;
            border-radius: 6px;
            text-align: left;
            color: #4a5568;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .action-btn:hover {
            background: #e2e8f0;
            transform: translateX(5px);
        }

        .recent-orders table {
            width: 100%;
            border-collapse: collapse;
        }

        .recent-orders th {
            text-align: left;
            padding: 12px 0;
            color: #718096;
            font-weight: 500;
            border-bottom: 2px solid #e2e8f0;
        }

        .recent-orders td {
            padding: 15px 0;
            border-bottom: 1px solid #e2e8f0;
            color: #4a5568;
        }

        .status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-pending { background: #fef3c7; color: #92400e; }
        .status-paid { background: #d1fae5; color: #065f46; }
        .status-shipped { background: #dbeafe; color: #1e40af; }

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
    <div class="logo">中药材销售系统 - 管理员面板</div>
    <div class="user-info">
        <div class="welcome">管理员：<strong><%= user.getUsername() %></strong></div>
        <button class="btn-logout" onclick="location.href='logout'">退出登录</button>
    </div>
</div>

<div class="admin-nav">
    <ul>
        <li><a href="admin.jsp" class="active">控制面板</a></li>
        <li><a href="herb-list.jsp">药材管理</a></li>
        <li><a href="orders.jsp">订单管理</a></li>
        <li><a href="#">用户管理</a></li>
        <li><a href="#">库存管理</a></li>
        <li><a href="#">系统设置</a></li>
    </ul>
</div>

<div class="main-content">
    <div class="dashboard-cards">
        <div class="card">
            <div class="card-header">
                <div>
                    <div class="card-title">今日销售额</div>
                    <div class="card-value">¥2,845.00</div>
                    <div class="card-change">+12.5% 昨日</div>
                </div>
                <div class="card-icon icon-sales">¥</div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <div>
                    <div class="card-title">活跃用户</div>
                    <div class="card-value">1,248</div>
                    <div class="card-change">+5.2% 上周</div>
                </div>
                <div class="card-icon icon-users">👥</div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <div>
                    <div class="card-title">待处理订单</div>
                    <div class="card-value">28</div>
                    <div class="card-change">-3 昨日</div>
                </div>
                <div class="card-icon icon-orders">📦</div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <div>
                    <div class="card-title">库存预警</div>
                    <div class="card-value">12</div>
                    <div class="card-change">需及时补货</div>
                </div>
                <div class="card-icon icon-inventory">⚠️</div>
            </div>
        </div>
    </div>

    <div class="admin-sections">
        <div class="section">
            <h3>快捷操作</h3>
            <div class="quick-actions">
                <button class="action-btn" onclick="location.href='herb-add.jsp'">
                    添加新药材
                </button>
                <button class="action-btn" onclick="location.href='orders.jsp'">
                    查看所有订单
                </button>
                <button class="action-btn" onclick="location.href='#'">
                    管理用户
                </button>
                <button class="action-btn" onclick="location.href='#'">
                    库存盘点
                </button>
                <button class="action-btn" onclick="location.href='#'">
                    生成销售报表
                </button>
            </div>
        </div>

        <div class="section">
            <h3>最近订单</h3>
            <div class="recent-orders">
                <table>
                    <thead>
                    <tr>
                        <th>订单号</th>
                        <th>用户</th>
                        <th>金额</th>
                        <th>状态</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>ORD20231220001</td>
                        <td>user1</td>
                        <td>¥389.97</td>
                        <td><span class="status status-pending">待处理</span></td>
                    </tr>
                    <tr>
                        <td>ORD20231219002</td>
                        <td>user2</td>
                        <td>¥159.98</td>
                        <td><span class="status status-paid">已付款</span></td>
                    </tr>
                    <tr>
                        <td>ORD20231218003</td>
                        <td>user3</td>
                        <td>¥539.97</td>
                        <td><span class="status status-shipped">已发货</span></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="footer">
    <p>中药材销售系统 &copy; 2023 - 管理员面板仅供授权人员使用</p>
</div>

<script>
    console.log("管理员面板加载完成");
    console.log("当前用户: <%= user.getUsername() %>");

    // 快捷操作按钮点击效果
    document.querySelectorAll('.action-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            console.log("点击操作: " + this.textContent);
        });
    });

    // 导航栏点击效果
    document.querySelectorAll('.admin-nav a').forEach(link => {
        link.addEventListener('click', function() {
            // 移除所有active类
            document.querySelectorAll('.admin-nav a').forEach(a => {
                a.classList.remove('active');
            });
            // 添加当前active类
            this.classList.add('active');
        });
    });

    // 退出登录确认
    document.querySelector('.btn-logout').addEventListener('click', function(e) {
        if (!confirm('确定要退出登录吗？')) {
            e.preventDefault();
        }
    });
</script>
</body>
</html>