<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>添加新药材</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            max-width: 800px;
            background-color: #f5f5f5;
        }
        h1 {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        .container {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .back-link {
            margin-bottom: 20px;
        }
        .back-link a {
            text-decoration: none;
            color: #3498db;
            font-weight: bold;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
        .form-group {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 5px;
            border-left: 4px solid #3498db;
        }
        label {
            display: inline-block;
            width: 140px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        input[type="text"], textarea {
            width: 400px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        input[type="text"]:focus, textarea:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }
        textarea {
            height: 80px;
            resize: vertical;
            font-family: Arial, sans-serif;
        }
        .required {
            color: #e74c3c;
            font-weight: bold;
        }
        .error {
            color: #e74c3c;
            font-size: 13px;
            margin-left: 10px;
            display: inline-block;
        }
        .success {
            color: #27ae60;
            font-size: 14px;
            font-weight: bold;
        }
        .info {
            color: #3498db;
            font-size: 13px;
            margin-left: 10px;
        }
        button {
            padding: 10px 25px;
            margin-right: 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .btn-submit {
            background-color: #2ecc71;
            color: white;
        }
        .btn-submit:hover {
            background-color: #27ae60;
        }
        .btn-reset {
            background-color: #e74c3c;
            color: white;
        }
        .btn-reset:hover {
            background-color: #c0392b;
        }
        .btn-back {
            background-color: #95a5a6;
            color: white;
        }
        .btn-back:hover {
            background-color: #7f8c8d;
        }
        .button-group {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .message-box {
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
            display: none;
        }
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 10px;
            vertical-align: middle;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<div class="container">
    <h1>添加新药材</h1>

    <div class="back-link">
        <button class="btn-back" onclick="window.location.href='herb-list.jsp'">← 返回药材列表</button>
    </div>

    <div id="messageBox" class="message-box"></div>

    <form id="addForm">
        <div class="form-group">
            <label for="code">药材编号<span class="required">*</span>:</label><br>
            <input type="text" id="code" name="code" required
                   placeholder="如：ZY001"
                   onblur="checkCodeExists()">
            <span id="codeMsg" class="info">请输入唯一的药材编号</span>
        </div>

        <div class="form-group">
            <label for="name">药材名称<span class="required">*</span>:</label><br>
            <input type="text" id="name" name="name" required
                   placeholder="如：人参">
        </div>

        <div class="form-group">
            <label for="alias">别名:</label><br>
            <input type="text" id="alias" name="alias"
                   placeholder="如：山参、园参">
        </div>

        <div class="form-group">
            <label for="source">来源:</label><br>
            <textarea id="source" name="source"
                      placeholder="如：为五加科植物人参的干燥根"></textarea>
        </div>

        <div class="form-group">
            <label for="growthEnvironment">生长环境:</label><br>
            <textarea id="growthEnvironment" name="growthEnvironment"
                      placeholder="如：东北地区，落叶阔叶林或针叶阔叶混交林下"></textarea>
        </div>

        <div class="form-group">
            <label for="propertyTaste">性味:</label><br>
            <input type="text" id="propertyTaste" name="propertyTaste"
                   placeholder="如：甘、微苦，微温">
        </div>

        <div class="form-group">
            <label for="mainFunction">主治功能:</label><br>
            <textarea id="mainFunction" name="mainFunction"
                      placeholder="如：大补元气，复脉固脱，补脾益肺，生津养血，安神益智"></textarea>
        </div>

        <div class="form-group">
            <label for="usageDosage">用法用量:</label><br>
            <textarea id="usageDosage" name="usageDosage"
                      placeholder="如：煎服，3-9g；挽救虚脱可用15-30g"></textarea>
        </div>

        <div class="form-group">
            <label for="price">单价:</label><br>
            <input type="text" id="price" name="price"
                   placeholder="如：299.00"
                   value="0.00">
        </div>

        <div class="form-group">
            <label for="stock">库存:</label><br>
            <input type="text" id="stock" name="stock"
                   placeholder="如：50"
                   value="0">
        </div>

        <div class="button-group">
            <button type="button" class="btn-submit" onclick="submitForm()" id="submitBtn">
                添加药材
            </button>
            <button type="button" class="btn-reset" onclick="resetForm()">
                重置表单
            </button>
            <span id="submitMsg" style="margin-left: 20px;"></span>
        </div>
    </form>
</div>

<script>
    // 显示消息
    function showMessage(message, type) {
        const messageBox = document.getElementById('messageBox');
        messageBox.textContent = message;
        messageBox.style.display = 'block';
        messageBox.style.backgroundColor = type === 'error' ? '#f8d7da' :
            type === 'success' ? '#d4edda' : '#d1ecf1';
        messageBox.style.color = type === 'error' ? '#721c24' :
            type === 'success' ? '#155724' : '#0c5460';
        messageBox.style.border = type === 'error' ? '1px solid #f5c6cb' :
            type === 'success' ? '1px solid #c3e6cb' : '#bee5eb';

        // 5秒后自动隐藏
        if (type !== 'loading') {
            setTimeout(() => {
                messageBox.style.display = 'none';
            }, 5000);
        }
    }

    // 检查编号是否存在
    function checkCodeExists() {
        const code = document.getElementById('code').value.trim();
        const codeMsg = document.getElementById('codeMsg');

        if (!code) {
            codeMsg.textContent = '请输入药材编号';
            codeMsg.className = 'info';
            return;
        }

        // 简单的格式验证
        if (code.length < 2) {
            codeMsg.textContent = '编号太短';
            codeMsg.className = 'error';
            return;
        }

        codeMsg.innerHTML = '<span class="loading"></span>检查中...';
        codeMsg.className = 'info';

        fetch('checkCode?code=' + encodeURIComponent(code))
            .then(response => response.json())
            .then(data => {
                if (data.exists) {
                    codeMsg.textContent = '❌ 该编号已存在！';
                    codeMsg.className = 'error';
                } else {
                    codeMsg.textContent = '✅ 该编号可用';
                    codeMsg.className = 'success';
                }
            })
            .catch(error => {
                console.error('检查编号错误:', error);
                codeMsg.textContent = '⚠️ 检查失败，请重试';
                codeMsg.className = 'error';
            });
    }

    // 提交表单
    function submitForm() {
        const code = document.getElementById('code').value.trim();
        const name = document.getElementById('name').value.trim();
        const submitBtn = document.getElementById('submitBtn');
        const submitMsg = document.getElementById('submitMsg');

        // 验证必填项
        if (!code) {
            showMessage('请输入药材编号', 'error');
            document.getElementById('code').focus();
            return;
        }
        if (!name) {
            showMessage('请输入药材名称', 'error');
            document.getElementById('name').focus();
            return;
        }

        // 禁用提交按钮，防止重复提交
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="loading"></span>提交中...';

        // 收集表单数据
        const formData = {
            code: code,
            name: name,
            alias: document.getElementById('alias').value.trim(),
            source: document.getElementById('source').value.trim(),
            growthEnvironment: document.getElementById('growthEnvironment').value.trim(),
            propertyTaste: document.getElementById('propertyTaste').value.trim(),
            mainFunction: document.getElementById('mainFunction').value.trim(),
            usageDosage: document.getElementById('usageDosage').value.trim(),
            price: document.getElementById('price').value.trim() || '0.00',
            stock: document.getElementById('stock').value.trim() || '0'
        };

        // 转换为URL编码格式
        const params = new URLSearchParams();
        for (const key in formData) {
            params.append(key, formData[key]);
        }

        console.log('提交数据：', params.toString());
        showMessage('正在提交数据，请稍候...', 'loading');

        // 发送请求
        fetch('addHerb', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString()
        })
            .then(response => {
                console.log('响应状态：', response.status);
                if (!response.ok) {
                    throw new Error('网络响应不正常');
                }
                return response.json();
            })
            .then(data => {
                console.log('响应数据：', data);

                // 恢复按钮
                submitBtn.disabled = false;
                submitBtn.textContent = '添加药材';

                if (data.code === 200) {
                    showMessage(data.message + '，3秒后自动返回列表页...', 'success');
                    submitMsg.textContent = data.message;
                    submitMsg.style.color = 'green';

                    // 3秒后跳转
                    setTimeout(() => {
                        window.location.href = 'herb-list.jsp';
                    }, 3000);
                } else {
                    showMessage('添加失败：' + data.message, 'error');
                    submitMsg.textContent = '添加失败：' + data.message;
                    submitMsg.style.color = 'red';
                }
            })
            .catch(error => {
                console.error('提交错误：', error);

                // 恢复按钮
                submitBtn.disabled = false;
                submitBtn.textContent = '添加药材';

                showMessage('提交失败：' + error.message, 'error');
                submitMsg.textContent = '提交失败，请检查网络连接';
                submitMsg.style.color = 'red';
            });
    }

    // 重置表单
    function resetForm() {
        if (confirm('确定要重置表单吗？所有填写的内容将被清空。')) {
            document.getElementById('addForm').reset();
            document.getElementById('codeMsg').textContent = '请输入唯一的药材编号';
            document.getElementById('codeMsg').className = 'info';
            document.getElementById('submitMsg').textContent = '';
            document.getElementById('messageBox').style.display = 'none';
            showMessage('表单已重置', 'info');
        }
    }

    // 输入框键盘事件支持
    document.addEventListener('DOMContentLoaded', function() {
        const codeInput = document.getElementById('code');
        const nameInput = document.getElementById('name');

        // 按Enter键跳到下一个字段
        codeInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                nameInput.focus();
            }
        });

        // 表单提交快捷键
        document.addEventListener('keydown', function(e) {
            // Ctrl + Enter 提交表单
            if (e.ctrlKey && e.key === 'Enter') {
                e.preventDefault();
                submitForm();
            }
            // Esc 重置表单
            if (e.key === 'Escape') {
                resetForm();
            }
        });
    });
</script>
</body>
</html>