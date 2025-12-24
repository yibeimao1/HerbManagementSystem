<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String orderId = (String) request.getAttribute("orderId");
    if (orderId == null) {
        response.sendRedirect("mall.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>订单提交成功 - 中药材销售系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .success-container {
            background: white;
            border-radius: 15px;
            padding: 50px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 600px;
            width: 90%;
        }

        .success-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
            border-radius: 50%;
            margin: 0 auto 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: white;
            animation: bounce 1s ease;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
            40% {transform: translateY(-20px);}
            60% {transform: translateY(-10px);}
        }

        h1 {
            color: #2d3748;
            margin-bottom: 15px;
            font-size: 32px;
        }

        .subtitle {
            color: #718096;
            font-size: 18px;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .order-info {
            background: #f7fafc;
            border-radius: 10px;
            padding: 25px;
            margin: 30px 0;
            text-align: left;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e2e8f0;
        }

        .info-row:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }

        .info-label {
            color: #718096;
            font-weight: 500;
        }

        .info-value {
            color: #2d3748;
            font-weight: 600;
        }

        .order-id {
            font-size: 24px;
            color: #667eea;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .next-steps {
            margin: 30px 0;
            text-align: left;
        }

        .next-steps h3 {
            color: #4a5568;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .steps-list {
            list-style: none;
        }

        .steps-list li {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
            color: #718096;
        }

        .steps-list li:before {
            content: "✓";
            display: inline-block;
            width: 24px;
            height: 24px;
            background: #c6f6d5;
            color: #38a169;
            border-radius: 50%;
            text-align: center;
            line-height: 24px;
            margin-right: 12px;
            font-weight: bold;
        }

        .actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
        }

        .btn {
            padding: 14px 30px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            font-size: 16px;
            transition: all 0.3s;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #edf2f7;
            color: #4a5568;
            border: 1px solid #e2e8f0;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
        }

        .tip {
            margin-top: 25px;
            color: #a0aec0;
            font-size: 14px;
            line-height: 1.5;
        }
    </style>
</head>
<body>
<div class="success-container">
    <div class="success-icon">✓</div>

    <h1>订单提交成功！</h1>
    <p class="subtitle">
        感谢您的购买，订单已成功提交并进入处理流程。<br>
        我们会在24小时内为您安排发货。
    </p>

    <div class="order-info">
        <div class="info-row">
            <span class="info-label">订单编号：</span>
            <span class="info-value order-id"><%= orderId %></span>
        </div>
        <div class="info-row">
            <span class="info-label">下单时间：</span>
            <span class="info-value">
                    <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %>
                </span>
        </div>
        <div class="info-row">
            <span class="info-label">订单状态：</span>
            <span class="info-value" style="color: #48bb78;">已确认，等待发货</span>
        </div>
    </div>

    <div class="next-steps">
        <h3>接下来您可以：</h3>
        <ul class="steps-list">
            <li>在用户中心查看订单状态</li>
            <li>保持电话畅通等待配送联系</li>
            <li>有问题可联系客服：400-123-4567</li>
        </ul>
    </div>

    <div class="actions">
        <a href="user.jsp" class="btn btn-primary">查看我的订单</a>
        <a href="mall.jsp" class="btn btn-secondary">继续购物</a>
    </div>

    <p class="tip">
        温馨提示：您可以在"用户中心 → 我的订单"中查看订单详情和物流信息。<br>
        预计1-3个工作日送达，具体时间以物流为准。
    </p>
</div>
</body>
</html>