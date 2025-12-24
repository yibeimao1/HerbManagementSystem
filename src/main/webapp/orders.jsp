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
    <title>订单管理 - 中药材销售系统</title>
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
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .admin-nav {
            background: white;
            padding: 0 40px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
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

        .page-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e1e5e9;
        }

        .orders-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .orders-table th {
            background: #2d3748;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 500;
        }

        .orders-table td {
            padding: 15px;
            border-bottom: 1px solid #e2e8f0;
            color: #4a5568;
        }

        .orders-table tr:hover {
            background-color: #f7fafc;
        }

        .order-id {
            font-family: monospace;
            color: #667eea;
            font-weight: 500;
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
        .status-completed { background: #dcfce7; color: #166534; }
        .status-cancelled { background: #fee2e2; color: #991b1b; }

        .amount {
            color: #2d3748;
            font-weight: 600;
        }

        .action-btn {
            padding: 6px 12px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            margin-right: 5px;
        }

        .action-btn:hover {
            background: #5a67d8;
        }

        .action-btn.view {
            background: #48bb78;
        }

        .action-btn.view:hover {
            background: #38a169;
        }

        .action-btn.delete {
            background: #f56565;
        }

        .action-btn.delete:hover {
            background: #e53e3e;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .empty-state h3 {
            font-size: 24px;
            color: #718096;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #a0aec0;
        }

        .filters {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-group select,
        .filter-group input {
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn-filter {
            padding: 8px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-filter:hover {
            background: #5a67d8;
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">中药材销售系统 - 订单管理</div>
    <div class="user-info">
        <button onclick="location.href='logout'">退出登录</button>
    </div>
</div>

<div class="admin-nav">
    <ul>
        <li><a href="admin.jsp">控制面板</a></li>
        <li><a href="herb-list.jsp">药材管理</a></li>
        <li><a href="orders.jsp" class="active">订单管理</a></li>
        <li><a href="#">用户管理</a></li>
    </ul>
</div>

<div class="main-content">
    <h1 class="page-title">订单管理</h1>

    <div class="filters">
        <div class="filter-group">
            <label>订单状态：</label>
            <select>
                <option value="">全部状态</option>
                <option value="pending">待处理</option>
                <option value="paid">已付款</option>
                <option value="shipped">已发货</option>
                <option value="completed">已完成</option>
                <option value="cancelled">已取消</option>
            </select>
        </div>

        <div class="filter-group">
            <label>订单号：</label>
            <input type="text" placeholder="输入订单号">
        </div>

        <div class="filter-group">
            <label>用户名：</label>
            <input type="text" placeholder="输入用户名">
        </div>

        <button class="btn-filter">搜索</button>
    </div>

    <table class="orders-table">
        <thead>
        <tr>
            <th width="15%">订单号</th>
            <th width="15%">用户</th>
            <th width="25%">收货地址</th>
            <th width="15%">金额</th>
            <th width="15%">状态</th>
            <th width="15%">操作</th>
        </tr>
        </thead>
        <tbody>
        <!-- 示例订单数据 -->
        <tr>
            <td class="order-id">ORD20231220001</td>
            <td>user1</td>
            <td>北京市海淀区中关村大街1号</td>
            <td class="amount">¥389.97</td>
            <td><span class="status status-pending">待处理</span></td>
            <td>
                <button class="action-btn view">查看</button>
                <button class="action-btn">处理</button>
                <button class="action-btn delete">删除</button>
            </td>
        </tr>
        <tr>
            <td class="order-id">ORD20231219002</td>
            <td>user2</td>
            <td>上海市浦东新区张江高科技园区</td>
            <td class="amount">¥159.98</td>
            <td><span class="status status-paid">已付款</span></td>
            <td>
                <button class="action-btn view">查看</button>
                <button class="action-btn">发货</button>
            </td>
        </tr>
        <tr>
            <td class="order-id">ORD20231218003</td>
            <td>user3</td>
            <td>广州市天河区珠江新城</td>
            <td class="amount">¥539.97</td>
            <td><span class="status status-shipped">已发货</span></td>
            <td>
                <button class="action-btn view">查看</button>
                <button class="action-btn">完成</button>
            </td>
        </tr>
        </tbody>
    </table>

    <%-- 如果没有订单数据
    <div class="empty-state">
        <h3>暂无订单数据</h3>
        <p>还没有用户下单购买</p>
    </div>
    --%>
</div>

<script>
    // 页面加载完成日志
    console.log("订单管理页面加载完成");

    // 简单的过滤功能
    document.querySelector('.btn-filter').addEventListener('click', function() {
        alert('订单搜索功能开发中...');
    });

    // 订单操作按钮
    document.querySelectorAll('.action-btn.view').forEach(btn => {
        btn.addEventListener('click', function() {
            alert('订单详情功能开发中...');
        });
    });

    document.querySelectorAll('.action-btn.delete').forEach(btn => {
        btn.addEventListener('click', function() {
            if (confirm('确定要删除这个订单吗？')) {
                alert('订单删除功能开发中...');
            }
        });
    });
</script>
</body>
</html>