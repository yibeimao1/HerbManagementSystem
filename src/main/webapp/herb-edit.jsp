<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>修改药材信息</title>
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
            border-left: 4px solid #f39c12;
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
            background-color: #f39c12;
            color: white;
        }
        .btn-submit:hover {
            background-color: #d68910;
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
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>修改药材信息</h1>

    <div class="back-link">
        <button class="btn-back" onclick="window.location.href='herb-list.jsp'">← 返回药材列表</button>
    </div>

    <div id="messageBox" class="message-box"></div>

    <div id="loading" class="loading" style="display: block; margin: 50px auto;"></div>

    <form id="editForm" class="hidden">
        <input type="hidden" id="id" name="id">

        <div class="form-group">
            <label for="code">药材编号<span class="required">*</span>:</label><br>
            <input type="text" id="code" name="code" required
                   onblur="checkCodeExists()">
            <span id="codeMsg" class="info"></span>
        </div>

        <div class="form-group">
            <label for="name">药材名称<span class="required">*</span>:</label><br>
            <input type="text" id="name" name="name" required>
        </div>

        <div class="form-group">
            <label for="alias">别名:</label><br>
            <input type="text" id="alias" name="alias">
        </div>

        <div class="form-group">
            <label for="source">来源:</label><br>
            <textarea id="source" name="source"></textarea>
        </div>

        <div class="form-group">
            <label for="growthEnvironment">生长环境:</label><br>
            <textarea id="growthEnvironment" name="growthEnvironment"></textarea>
        </div>

        <div class="form-group">
            <label for="propertyTaste">性味:</label><br>
            <input type="text" id="propertyTaste" name="propertyTaste">
        </div>

        <div class="form-group">
            <label for="mainFunction">主治功能:</label><br>
            <textarea id="mainFunction" name="mainFunction"></textarea>
        </div>

        <div class="form-group">
            <label for="usageDosage">用法用量:</label><br>
            <textarea id="usageDosage" name="usageDosage"></textarea>
        </div>

        <div class="form-group">
            <label for="price">单价:</label><br>
            <input type="text" id="price" name="price">
        </div>

        <div class="form-group">
            <label for="stock">库存:</label><br>
            <input type="text" id="stock" name="stock">
        </div>

        <div class="button-group">
            <button type="button" class="btn-submit" onclick="submitForm()" id="submitBtn">
                更新药材
            </button>
            <button type="button" class="btn-reset" onclick="resetForm()">
                重置修改
            </button>
            <span id="submitMsg" style="margin-left: 20px;"></span>
        </div>
    </form>
</div>

<script>
    // 从URL获取ID参数
    function getUrlParam(name) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(name);
    }

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

    // 加载药材信息
    function loadHerbInfo() {
        const id = getUrlParam('id');
        if (!id) {
            showMessage('缺少药材ID参数', 'error');
            return;
        }

        showMessage('正在加载药材信息...', 'loading');

        fetch('editHerb?id=' + id)
            .then(response => {
                if (!response.ok) {
                    throw new Error('网络响应不正常');
                }
                return response.json();
            })
            .then(data => {
                console.log('药材数据：', data);

                if (data.code === 200 && data.data) {
                    const herb = data.data;
                    populateForm(herb);
                    document.getElementById('loading').style.display = 'none';
                    document.getElementById('editForm').classList.remove('hidden');
                    showMessage('药材信息加载完成', 'success');
                } else {
                    showMessage('加载失败：' + (data.message || '药材不存在'), 'error');
                }
            })
            .catch(error => {
                console.error('加载错误：', error);
                showMessage('加载失败：' + error.message, 'error');
            });
    }

    // 填充表单
    function populateForm(herb) {
        document.getElementById('id').value = herb.id;
        document.getElementById('code').value = herb.code || '';
        document.getElementById('name').value = herb.name || '';
        document.getElementById('alias').value = herb.alias || '';
        document.getElementById('source').value = herb.source || '';
        document.getElementById('growthEnvironment').value = herb.growthEnvironment || '';
        document.getElementById('propertyTaste').value = herb.propertyTaste || '';
        document.getElementById('mainFunction').value = herb.mainFunction || '';
        document.getElementById('usageDosage').value = herb.usageDosage || '';
        document.getElementById('price').value = herb.price || '0.00';
        document.getElementById('stock').value = herb.stock || '0';

        // 设置编号检查提示
        const codeMsg = document.getElementById('codeMsg');
        codeMsg.textContent = '当前编号：' + herb.code;
        codeMsg.className = 'info';
    }

    // 检查编号是否存在
    function checkCodeExists() {
        const code = document.getElementById('code').value.trim();
        const id = document.getElementById('id').value;
        const codeMsg = document.getElementById('codeMsg');

        if (!code) {
            codeMsg.textContent = '请输入药材编号';
            codeMsg.className = 'info';
            return;
        }

        if (code.length < 2) {
            codeMsg.textContent = '编号太短';
            codeMsg.className = 'error';
            return;
        }

        codeMsg.innerHTML = '<span class="loading"></span>检查中...';
        codeMsg.className = 'info';

        fetch('checkCode?code=' + encodeURIComponent(code) + '&id=' + id)
            .then(response => response.json())
            .then(data => {
                if (data.exists) {
                    codeMsg.textContent = '❌ 该编号已被其他药材使用！';
                    codeMsg.className = 'error';
                } else {
                    codeMsg.textContent = '✅ 编号可用';
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
        submitBtn.innerHTML = '<span class="loading"></span>更新中...';

        // 收集表单数据
        const formData = {
            id: document.getElementById('id').value,
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
        showMessage('正在更新数据，请稍候...', 'loading');

        // 发送请求
        fetch('editHerb', {
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
                submitBtn.textContent = '更新药材';

                if (data.code === 200) {
                    showMessage(data.message + '，3秒后自动返回列表页...', 'success');
                    submitMsg.textContent = data.message;
                    submitMsg.style.color = 'green';

                    // 3秒后跳转
                    setTimeout(() => {
                        window.location.href = 'herb-list.jsp';
                    }, 3000);
                } else {
                    showMessage('更新失败：' + data.message, 'error');
                    submitMsg.textContent = '更新失败：' + data.message;
                    submitMsg.style.color = 'red';
                }
            })
            .catch(error => {
                console.error('提交错误：', error);

                // 恢复按钮
                submitBtn.disabled = false;
                submitBtn.textContent = '更新药材';

                showMessage('更新失败：' + error.message, 'error');
                submitMsg.textContent = '更新失败，请检查网络连接';
                submitMsg.style.color = 'red';
            });
    }

    // 重置表单
    function resetForm() {
        if (confirm('确定要重置修改吗？所有修改的内容将被丢弃。')) {
            loadHerbInfo(); // 重新加载原始数据
            showMessage('已重置到原始数据', 'info');
        }
    }

    // 页面加载完成后执行
    document.addEventListener('DOMContentLoaded', function() {
        loadHerbInfo();
    });
</script>
</body>
</html>