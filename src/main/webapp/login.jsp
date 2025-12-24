<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // 固定验证码为 1111
  String captcha = "1111";
  session.setAttribute("captcha", captcha);
%>
<!DOCTYPE html>
<html>
<head>
  <title>中药材销售系统 - 登录</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Microsoft YaHei', Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .login-container {
      background: white;
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
      width: 400px;
    }

    .login-header {
      text-align: center;
      margin-bottom: 30px;
    }

    .login-header h1 {
      color: #333;
      font-size: 28px;
      margin-bottom: 10px;
    }

    .login-header p {
      color: #666;
      font-size: 14px;
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
      transition: border-color 0.3s;
    }

    .form-group input:focus {
      border-color: #667eea;
      outline: none;
    }

    .captcha-group {
      display: flex;
      gap: 10px;
    }

    .captcha-group input {
      flex: 1;
    }

    .captcha-img {
      padding: 10px 15px;
      background: #f8f9fa;
      border: 2px solid #e1e5e9;
      border-radius: 8px;
      font-family: monospace;
      font-size: 20px;
      font-weight: bold;
      letter-spacing: 2px;
      color: #333;
      user-select: none;
      cursor: pointer;
      min-width: 80px;
      text-align: center;
    }

    .btn-login {
      width: 100%;
      padding: 14px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: transform 0.2s;
    }

    .btn-login:hover {
      transform: translateY(-2px);
    }

    .error-message {
      background: #fee;
      border: 1px solid #f99;
      color: #c00;
      padding: 12px;
      border-radius: 8px;
      margin-bottom: 20px;
      text-align: center;
    }

    .links {
      text-align: center;
      margin-top: 20px;
      font-size: 14px;
    }

    .links a {
      color: #667eea;
      text-decoration: none;
      margin: 0 10px;
    }

    .links a:hover {
      text-decoration: underline;
    }
  </style>
  <script>
    function refreshCaptcha() {
      // 验证码固定为1111，不需要刷新
      document.getElementById('captchaImg').innerText = '1111';
      document.getElementById('captchaInput').value = '1111';
    }

    function validateForm() {
      var username = document.getElementById('username').value;
      var password = document.getElementById('password').value;
      var captcha = document.getElementById('captchaInput').value;

      if (!username || !password || !captcha) {
        alert('请填写所有字段！');
        return false;
      }

      // 验证码必须是1111
      if (captcha !== '1111') {
        alert('验证码错误！请输入：1111');
        document.getElementById('captchaInput').value = '1111';
        document.getElementById('captchaInput').focus();
        return false;
      }

      return true;
    }

    // 页面加载时自动设置验证码
    document.addEventListener('DOMContentLoaded', function() {
      document.getElementById('captchaImg').innerText = '1111';
      document.getElementById('captchaInput').value = '1111';
    });
  </script>
</head>
<body>
<div class="login-container">
  <div class="login-header">
    <h1>中药材销售系统</h1>
    <p>请登录您的账户</p>
  </div>

  <%-- 错误提示 --%>
  <c:if test="${not empty error}">
    <div class="error-message">${error}</div>
  </c:if>

  <form action="login" method="post" onsubmit="return validateForm()">
    <div class="form-group">
      <label for="username">用户名：</label>
      <input type="text" id="username" name="username"
             placeholder="请输入用户名" value="${param.username}" autocomplete="username">
    </div>

    <div class="form-group">
      <label for="password">密码：</label>
      <input type="password" id="password" name="password"
             placeholder="请输入密码" autocomplete="current-password">
    </div>

    <div class="form-group">
      <label for="captchaInput">验证码：</label>
      <div class="captcha-group">
        <input type="text" id="captchaInput" name="captcha"
               placeholder="请输入验证码" maxlength="4" autocomplete="off">
        <div class="captcha-img" id="captchaImg" onclick="refreshCaptcha()">
          1111
        </div>
      </div>
    </div>

    <button type="submit" class="btn-login">登录</button>
  </form>

  <div class="links">
    <span style="color: #666;">测试账号：</span><br>
    <span>管理员：admin / 123456</span><br>
    <span>用户：user1 / 123456</span>
  </div>
</div>
</body>
</html>