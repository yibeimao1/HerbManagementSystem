<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>系统错误 - 中药材销售系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
        }
        .error-container { text-align: center; padding: 40px; }
        .error-code { font-size: 120px; font-weight: bold; margin-bottom: 20px; }
        .error-message { font-size: 24px; margin-bottom: 30px; }
        .actions { display: flex; gap: 15px; justify-content: center; }
        .btn {
            padding: 12px 24px;
            background: rgba(255,255,255,0.2);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            border: 1px solid rgba(255,255,255,0.3);
            transition: background 0.3s;
        }
        .btn:hover { background: rgba(255,255,255,0.3); }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-code">
        <%= response.getStatus() %>
    </div>
    <div class="error-message">
        <%
            if (response.getStatus() == 404) {
                out.print("页面未找到");
            } else if (response.getStatus() == 500) {
                out.print("服务器内部错误");
            } else {
                out.print("系统发生错误");
            }
        %>
    </div>
    <div class="actions">
        <a href="javascript:history.back()" class="btn">返回上一页</a>
        <a href="login.jsp" class="btn">返回首页</a>
    </div>
</div>
</body>
</html>