<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.herb.model.Herb" %>
<%
    Herb herb = (Herb) request.getAttribute("herb");
%>
<html>
<head>
    <title><%= herb != null ? herb.getName() + " - 药材详情" : "药材详情" %></title>
    <style>
        /* 保持所有样式不变 */
        body { font-family: Arial; margin: 20px; max-width: 800px; background: #f5f5f5; }
        .container { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; margin-bottom: 30px; }
        .detail-section { margin-bottom: 30px; padding: 20px; background-color: #f9f9f9; border-radius: 5px; border-left: 5px solid #3498db; }
        .detail-item { margin-bottom: 15px; padding: 10px; border-bottom: 1px solid #eee; }
        .detail-label { display: inline-block; width: 150px; font-weight: bold; color: #2c3e50; vertical-align: top; }
        .detail-value { display: inline-block; width: calc(100% - 160px); color: #34495e; line-height: 1.6; }
        .detail-title { font-size: 18px; font-weight: bold; color: #2c3e50; margin-bottom: 15px; padding-bottom: 5px; border-bottom: 2px solid #eee; }
        .text-content { white-space: pre-wrap; line-height: 1.8; background-color: #fff; padding: 10px; border-radius: 3px; border: 1px solid #eee; }
        .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .price-stock { display: flex; gap: 30px; margin-top: 10px; }
        .price-box, .stock-box { background: #e8f4fc; padding: 15px; border-radius: 5px; text-align: center; flex: 1; }
        .price-amount { font-size: 24px; font-weight: bold; color: #e74c3c; }
        .stock-amount { font-size: 24px; font-weight: bold; color: #27ae60; }
        .unit { font-size: 14px; color: #7f8c8d; margin-top: 5px; }
        .timestamp { font-size: 12px; color: #95a5a6; margin-top: 5px; }
        .action-buttons { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; text-align: center; }
        button { padding: 10px 25px; margin: 0 10px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: bold; }
        .btn-edit { background-color: #3498db; color: white; }
        .btn-delete { background-color: #e74c3c; color: white; }
        .btn-back { background-color: #95a5a6; color: white; }
        .not-available { color: #95a5a6; font-style: italic; }
        .back-link { margin-bottom: 20px; }
    </style>
</head>
<body>
<div class="container">
    <div class="back-link">
        <button class="btn-back" onclick="window.location.href='herb-list.jsp'">← 返回药材列表</button>
    </div>

    <% if (herb != null) { %>
    <h1><%= herb.getName() %> - 药材详情</h1>

    <!-- 基本信息 -->
    <div class="detail-section">
        <div class="detail-title">基本信息</div>
        <div class="info-grid">
            <div class="detail-item">
                <span class="detail-label">药材ID：</span>
                <span class="detail-value"><%= herb.getId() %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">药材编号：</span>
                <span class="detail-value">
                    <%= herb.getCode() != null ? herb.getCode() : "<span class='not-available'>无编号</span>" %>
                </span>
            </div>
            <div class="detail-item">
                <span class="detail-label">药材名称：</span>
                <span class="detail-value"><%= herb.getName() %></span>
            </div>
            <div class="detail-item">
                <span class="detail-label">别名：</span>
                <span class="detail-value">
                    <%= herb.getAlias() != null && !herb.getAlias().isEmpty() ? herb.getAlias() : "<span class='not-available'>暂无别名</span>" %>
                </span>
            </div>
        </div>
    </div>

    <!-- 价格和库存 -->
    <div class="detail-section">
        <div class="detail-title">价格与库存</div>
        <div class="price-stock">
            <div class="price-box">
                <div>单价</div>
                <div class="price-amount">¥<%= herb.getPrice() != null ? herb.getPrice() : "0.00" %></div>
                <div class="unit">元/单位</div>
            </div>
            <div class="stock-box">
                <div>库存数量</div>
                <div class="stock-amount"><%= herb.getStock() != null ? herb.getStock() : 0 %></div>
                <div class="unit">件</div>
            </div>
        </div>
    </div>

    <!-- 来源信息 -->
    <% if (herb.getSource() != null && !herb.getSource().isEmpty()) { %>
    <div class="detail-section">
        <div class="detail-title">来源信息</div>
        <div class="detail-item">
            <div class="detail-value text-content">
                <%= herb.getSource() %>
            </div>
        </div>
    </div>
    <% } %>

    <!-- 生长环境 -->
    <% if (herb.getGrowthEnvironment() != null && !herb.getGrowthEnvironment().isEmpty()) { %>
    <div class="detail-section">
        <div class="detail-title">生长环境</div>
        <div class="detail-item">
            <div class="detail-value text-content">
                <%= herb.getGrowthEnvironment() %>
            </div>
        </div>
    </div>
    <% } %>

    <!-- 性味 -->
    <% if (herb.getPropertyTaste() != null && !herb.getPropertyTaste().isEmpty()) { %>
    <div class="detail-section">
        <div class="detail-title">性味</div>
        <div class="detail-item">
            <div class="detail-value text-content">
                <%= herb.getPropertyTaste() %>
            </div>
        </div>
    </div>
    <% } %>

    <!-- 主治功能 -->
    <% if (herb.getMainFunction() != null && !herb.getMainFunction().isEmpty()) { %>
    <div class="detail-section">
        <div class="detail-title">主治功能</div>
        <div class="detail-item">
            <div class="detail-value text-content">
                <%= herb.getMainFunction() %>
            </div>
        </div>
    </div>
    <% } %>

    <!-- 用法用量 -->
    <% if (herb.getUsageDosage() != null && !herb.getUsageDosage().isEmpty()) { %>
    <div class="detail-section">
        <div class="detail-title">用法用量</div>
        <div class="detail-item">
            <div class="detail-value text-content">
                <%= herb.getUsageDosage() %>
            </div>
        </div>
    </div>
    <% } %>

    <!-- 时间信息（已修改，不调用不存在的方法） -->
    <div class="detail-section">
        <div class="detail-title">时间信息</div>
        <div class="info-grid">
            <div class="detail-item">
                <span class="detail-label">创建时间：</span>
                <span class="detail-value timestamp">
                    <span class='not-available'>未记录</span>
                </span>
            </div>
            <div class="detail-item">
                <span class="detail-label">最后更新：</span>
                <span class="detail-value timestamp">
                    <span class='not-available'>未记录</span>
                </span>
            </div>
        </div>
    </div>

    <!-- 操作按钮 -->
    <div class="action-buttons">
        <button class="btn-edit" onclick="window.location.href='herb-edit.jsp?id=<%= herb.getId() %>'">修改信息</button>
        <button class="btn-delete" onclick="if(confirm('确定要删除这个药材吗？')) { deleteHerb(<%= herb.getId() %>); }">删除药材</button>
    </div>
    <% } else { %>
    <div style="text-align: center; padding: 50px;">
        <h2 style="color: #e74c3c;">药材不存在或已被删除</h2>
        <p>您要查看的药材可能已被删除或ID不正确。</p>
        <button class="btn-back" onclick="window.location.href='herb-list.jsp'" style="margin-top: 20px;">
            ← 返回药材列表
        </button>
    </div>
    <% } %>
</div>

<script>
    // 删除药材函数
    function deleteHerb(id) {
        fetch('deleteHerb', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'id=' + id
        })
            .then(response => response.json())
            .then(data => {
                if (data.code === 200) {
                    alert('删除成功！');
                    window.location.href = 'herb-list.jsp';
                } else {
                    alert('删除失败：' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('删除失败，请检查网络连接');
            });
    }

    // 快捷键支持
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            window.location.href = 'herb-list.jsp';
        }
        if (e.key === 'e' || e.key === 'E') {
            <% if (herb != null) { %>
            window.location.href = 'herb-edit.jsp?id=<%= herb.getId() %>';
            <% } %>
        }
    });
</script>
</body>
</html>