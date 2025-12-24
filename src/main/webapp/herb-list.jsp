<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.herb.dao.HerbDAO" %>
<%@ page import="com.herb.model.Herb" %>
<%@ page import="java.util.List" %>
<%
  // 调试信息
  System.out.println("=== herb-list.jsp 开始执行 ===");

  List<Herb> herbs = null;
  String keyword = request.getParameter("keyword");
  String searchMode = "all";

  // 检查是否为直接访问（非AJAX）的情况
  if (keyword != null && !keyword.trim().isEmpty()) {
    // 搜索模式
    searchMode = "search";
    System.out.println("搜索模式，关键词: " + keyword);
    HerbDAO herbDAO = new HerbDAO();
    herbs = herbDAO.searchByKeyword(keyword);
    System.out.println("搜索到 " + (herbs != null ? herbs.size() : 0) + " 个结果");
  } else {
    // 正常显示所有
    searchMode = "all";
    System.out.println("正常显示所有药材");
    HerbDAO herbDAO = new HerbDAO();
    herbs = herbDAO.getAllHerbs();
    System.out.println("总共 " + (herbs != null ? herbs.size() : 0) + " 个药材");
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>药材管理</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      background-color: #f5f5f5;
    }
    .container {
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    h1 {
      color: #2c3e50;
      border-bottom: 2px solid #3498db;
      padding-bottom: 10px;
      margin-bottom: 20px;
    }
    .search-result-title {
      color: #666;
      font-size: 16px;
      margin-bottom: 15px;
      font-style: italic;
    }
    .search-result-title span {
      color: #e74c3c;
      font-weight: bold;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      border: 1px solid #ddd;
      padding: 12px;
      text-align: left;
    }
    th {
      background-color: #3498db;
      color: white;
    }
    tr:nth-child(even) {
      background-color: #f2f2f2;
    }
    .actions a {
      margin-right: 10px;
      text-decoration: none;
      padding: 5px 10px;
      border-radius: 4px;
    }
    .btn-add {
      background-color: #27ae60;
      color: white;
      padding: 10px 20px;
      text-decoration: none;
      border-radius: 5px;
      display: inline-block;
      margin-bottom: 20px;
    }
    .btn-edit {
      background-color: #3498db;
      color: white;
    }
    .btn-delete {
      background-color: #e74c3c;
      color: white;
    }
    .btn-detail {
      background-color: #f39c12;
      color: white;
    }
    .search-box {
      margin-bottom: 20px;
      padding: 15px;
      background: #f8f9fa;
      border-radius: 5px;
      border: 1px solid #e1e5e9;
    }
    .search-box form {
      display: flex;
      gap: 10px;
      align-items: center;
    }
    .search-box input {
      flex: 1;
      padding: 8px 12px;
      border: 2px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }
    .search-box button {
      padding: 8px 20px;
      background: #3498db;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
    }
    .search-box button:hover {
      background: #2980b9;
    }
    .back-link {
      margin-left: 10px;
      color: #3498db;
      text-decoration: none;
      font-size: 14px;
    }
    .back-link:hover {
      text-decoration: underline;
    }
    .no-results {
      text-align: center;
      padding: 40px;
      color: #666;
      font-size: 16px;
    }
    .no-results p {
      margin-bottom: 10px;
    }
    .loading-indicator {
      display: none;
      text-align: center;
      padding: 20px;
      color: #666;
    }
    .loading-indicator .spinner {
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
    .search-options {
      margin-top: 10px;
      font-size: 12px;
      color: #666;
    }
    .ajax-toggle {
      display: inline-flex;
      align-items: center;
      margin-left: 15px;
    }
    .ajax-toggle input {
      margin-right: 5px;
    }
  </style>
</head>
<body>
<div class="container">
  <h1 id="pageTitle">
    <% if (searchMode.equals("search")) { %>
    药材搜索结果：<span style="color: #e74c3c;">"<%= keyword %>"</span>
    <% } else { %>
    药材列表管理
    <% } %>
  </h1>

  <div class="search-box">
    <form id="searchForm" action="search" method="get">
      <input type="text" name="keyword" id="keywordInput" placeholder="搜索药材名称..."
             value="<%= keyword != null ? keyword : "" %>"
             required>
      <button type="button" id="ajaxSearchBtn">搜索</button>
      <button type="submit" id="normalSearchBtn" style="display: none;">传统搜索</button>
      <% if (keyword != null && !keyword.trim().isEmpty()) { %>
      <a href="herb-list.jsp" class="back-link">返回全部列表</a>
      <% } %>
    </form>
    <div class="search-options">
      <label class="ajax-toggle">
        <input type="checkbox" id="ajaxToggle" checked> 启用无刷新搜索
      </label>
      <span id="searchStatus"></span>
    </div>
  </div>

  <div id="loadingIndicator" class="loading-indicator">
    <div class="spinner"></div> 正在搜索中...
  </div>

  <div id="searchResultTitle" class="search-result-title">
    <% if (searchMode.equals("search")) { %>
    搜索到 <span id="resultCount"><%= herbs != null ? herbs.size() : 0 %></span> 个相关药材
    <% } else if (searchMode.equals("all") && herbs != null) { %>
    共有 <span id="resultCount"><%= herbs.size() %></span> 个药材
    <% } %>
  </div>

  <a href="herb-add.jsp" class="btn-add">添加新药材</a>

  <div id="resultsContainer">
    <% if (herbs == null || herbs.isEmpty()) { %>
    <div class="no-results" id="noResults">
      <% if (searchMode.equals("search")) { %>
      <p>没有找到与 "<span style="color: #e74c3c;"><%= keyword %></span>" 相关的药材</p>
      <p>请尝试其他关键词或<a href="herb-add.jsp" style="color: #3498db;">添加新药材</a></p>
      <% } else { %>
      <p>暂无药材数据</p>
      <p>请<a href="herb-add.jsp" style="color: #3498db;">添加新药材</a></p>
      <% } %>
    </div>
    <% } else { %>
    <table id="herbsTable">
      <thead>
      <tr>
        <th>ID</th>
        <th>名称</th>
        <th>价格</th>
        <th>库存</th>
        <th>操作</th>
      </tr>
      </thead>
      <tbody id="tableBody">
      <% for (Herb herb : herbs) { %>
      <tr data-id="<%= herb.getId() %>">
        <td><%= herb.getId() %></td>
        <td><%= herb.getName() != null ? herb.getName() : "" %></td>
        <td>
          <%
            if (herb.getPrice() != null) {
              out.print("¥" + herb.getPrice());
            } else {
              out.print("-");
            }
          %>
        </td>
        <td><%= herb.getStock() != null ? herb.getStock() : 0 %></td>
        <td class="actions">
          <a href="herbDetail?id=<%= herb.getId() %>" class="btn-detail">详情</a>
          <a href="herb-edit.jsp?id=<%= herb.getId() %>" class="btn-edit">编辑</a>
          <a href="javascript:void(0)" onclick="deleteHerb(<%= herb.getId() %>)"
             class="btn-delete">删除</a>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>

<script>
  // 页面加载完成日志
  console.log("药材列表页面加载完成");
  console.log("显示模式: <%= searchMode %>");
  console.log("关键词: '<%= keyword != null ? keyword : "" %>'");
  console.log("药材数量: <%= herbs != null ? herbs.size() : 0 %>");

  // AJAX搜索函数
  function performAjaxSearch(keyword) {
    if (!keyword || keyword.trim() === '') {
      // 如果搜索框为空，跳转到无参数页面显示所有药材
      window.location.href = 'herb-list.jsp';
      return;
    }

    // 显示加载状态
    showLoading(true);

    // 更新URL显示（不刷新页面）
    updateUrl(keyword);

    // 发送AJAX请求
    fetch('search?keyword=' + encodeURIComponent(keyword) + '&requestType=ajax', {
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
            .then(response => {
              if (!response.ok) {
                throw new Error('网络响应不正常');
              }
              return response.json();
            })
            .then(data => {
              console.log('搜索响应:', data);

              // 更新页面标题
              updatePageTitle(keyword);

              // 更新搜索结果数量显示
              updateResultCount(data.count);

              // 更新表格内容
              if (data.herbs && data.herbs.length > 0) {
                updateHerbTable(data.herbs);
              } else if (data.results && data.results.length > 0) {
                // 如果返回的是results格式的数据
                updateResultsTable(data.results);
              } else {
                showNoResults(keyword);
              }

              // 隐藏加载状态
              showLoading(false);
            })
            .catch(error => {
              console.error('搜索错误:', error);
              showLoading(false);

              // 出错时显示错误信息
              const tableBody = document.getElementById('tableBody');
              if (tableBody) {
                tableBody.innerHTML = '<tr><td colspan="5" style="text-align: center; padding: 40px; color: red;">搜索失败：' + error.message + '</td></tr>';
              }

              // 显示错误状态
              document.getElementById('searchStatus').textContent = '搜索失败';
              document.getElementById('searchStatus').style.color = 'red';
            });
  }

  // 更新页面标题
  function updatePageTitle(keyword) {
    const pageTitle = document.getElementById('pageTitle');
    if (pageTitle) {
      pageTitle.innerHTML = '药材搜索结果：<span style="color: #e74c3c;">"' + keyword + '"</span>';
    }
  }

  // 更新结果数量
  function updateResultCount(count) {
    const resultCount = document.getElementById('resultCount');
    const resultTitle = document.getElementById('searchResultTitle');

    if (resultCount) {
      resultCount.textContent = count;
    }

    if (resultTitle) {
      resultTitle.innerHTML = '搜索到 <span>' + count + '</span> 个相关药材';
      resultTitle.style.display = 'block';
    }
  }

  // 更新表格内容（使用herbs数组格式）
  function updateHerbTable(herbs) {
    const tableBody = document.getElementById('tableBody');
    const noResults = document.getElementById('noResults');
    const herbsTable = document.getElementById('herbsTable');

    if (!tableBody) return;

    // 显示表格，隐藏无结果提示
    if (herbsTable) herbsTable.style.display = 'table';
    if (noResults) noResults.style.display = 'none';

    // 生成新的表格行
    let html = '';
    herbs.forEach(herb => {
      html += `
      <tr data-id="${herb.id}">
        <td>${herb.id}</td>
        <td>${herb.name || ''}</td>
        <td>${herb.price ? '¥' + herb.price : '-'}</td>
        <td>${herb.stock || 0}</td>
        <td class="actions">
          <a href="herbDetail?id=${herb.id}" class="btn-detail">详情</a>
          <a href="herb-edit.jsp?id=${herb.id}" class="btn-edit">编辑</a>
          <a href="javascript:void(0)" onclick="deleteHerb(${herb.id})"
             class="btn-delete">删除</a>
        </td>
      </tr>
      `;
    });

    tableBody.innerHTML = html;

    // 显示成功状态
    document.getElementById('searchStatus').textContent = '搜索完成';
    document.getElementById('searchStatus').style.color = 'green';
  }

  // 更新表格内容（使用results数组格式）
  function updateResultsTable(results) {
    const tableBody = document.getElementById('tableBody');
    const noResults = document.getElementById('noResults');
    const herbsTable = document.getElementById('herbsTable');

    if (!tableBody) return;

    // 显示表格，隐藏无结果提示
    if (herbsTable) herbsTable.style.display = 'table';
    if (noResults) noResults.style.display = 'none';

    // 生成新的表格行
    let html = '';
    results.forEach(item => {
      html += `
      <tr data-id="${item.id}">
        <td>${item.id}</td>
        <td>${item.name || ''}</td>
        <td>${item.price ? '¥' + item.price : '-'}</td>
        <td>${item.stock || 0}</td>
        <td class="actions">
          <a href="herbDetail?id=${item.id}" class="btn-detail">详情</a>
          <a href="herb-edit.jsp?id=${item.id}" class="btn-edit">编辑</a>
          <a href="javascript:void(0)" onclick="deleteHerb(${item.id})"
             class="btn-delete">删除</a>
        </td>
      </tr>
      `;
    });

    tableBody.innerHTML = html;

    // 显示成功状态
    document.getElementById('searchStatus').textContent = '搜索完成';
    document.getElementById('searchStatus').style.color = 'green';
  }

  // 显示无结果
  function showNoResults(keyword) {
    const tableBody = document.getElementById('tableBody');
    const noResults = document.getElementById('noResults');
    const herbsTable = document.getElementById('herbsTable');
    const resultsContainer = document.getElementById('resultsContainer');

    if (tableBody) tableBody.innerHTML = '';
    if (herbsTable) herbsTable.style.display = 'none';

    // 创建或更新无结果提示
    if (!noResults) {
      const newNoResults = document.createElement('div');
      newNoResults.id = 'noResults';
      newNoResults.className = 'no-results';
      newNoResults.innerHTML = `
        <p>没有找到与 "<span style="color: #e74c3c;">${keyword}</span>" 相关的药材</p>
        <p>请尝试其他关键词或<a href="herb-add.jsp" style="color: #3498db;">添加新药材</a></p>
      `;
      resultsContainer.appendChild(newNoResults);
    } else {
      noResults.innerHTML = `
        <p>没有找到与 "<span style="color: #e74c3c;">${keyword}</span>" 相关的药材</p>
        <p>请尝试其他关键词或<a href="herb-add.jsp" style="color: #3498db;">添加新药材</a></p>
      `;
      noResults.style.display = 'block';
    }

    // 显示状态
    document.getElementById('searchStatus').textContent = '无结果';
    document.getElementById('searchStatus').style.color = 'orange';
  }

  // 显示/隐藏加载指示器
  function showLoading(show) {
    const loadingIndicator = document.getElementById('loadingIndicator');
    if (loadingIndicator) {
      loadingIndicator.style.display = show ? 'block' : 'none';
    }

    // 更新搜索按钮状态
    const searchBtn = document.getElementById('ajaxSearchBtn');
    if (searchBtn) {
      searchBtn.disabled = show;
      searchBtn.textContent = show ? '搜索中...' : '搜索';
    }

    // 更新状态显示
    if (show) {
      document.getElementById('searchStatus').textContent = '正在搜索...';
      document.getElementById('searchStatus').style.color = '#3498db';
    }
  }

  // 更新URL（不刷新页面）
  function updateUrl(keyword) {
    const newUrl = keyword
            ? 'herb-list.jsp?keyword=' + encodeURIComponent(keyword)
            : 'herb-list.jsp';
    window.history.pushState({keyword: keyword}, '', newUrl);
  }

  // AJAX删除函数
  function deleteHerb(id) {
    if (!confirm('确定要删除这个药材吗？此操作不可恢复！')) {
      return;
    }

    // 显示删除中状态
    const deleteBtn = event?.target || document.querySelector(`a[onclick*="${id}"]`);
    if (deleteBtn) {
      const originalText = deleteBtn.textContent;
      deleteBtn.textContent = '删除中...';
      deleteBtn.disabled = true;
    }

    fetch('deleteHerb', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'id=' + id
    })
            .then(response => response.json())
            .then(data => {
              if (data.code === 200) {
                // 从表格中移除该行
                const row = document.querySelector(`tr[data-id="${id}"]`);
                if (row) {
                  row.style.transition = 'opacity 0.3s';
                  row.style.opacity = '0';
                  setTimeout(() => {
                    row.remove();
                    // 检查是否还有数据
                    checkTableEmpty();
                  }, 300);
                }

                // 更新结果计数
                const resultCount = document.getElementById('resultCount');
                if (resultCount) {
                  const currentCount = parseInt(resultCount.textContent) || 0;
                  resultCount.textContent = Math.max(0, currentCount - 1);
                }

                // 显示成功消息
                alert('删除成功！');
              } else {
                alert('删除失败：' + data.message);
                // 恢复按钮状态
                if (deleteBtn) {
                  deleteBtn.textContent = '删除';
                  deleteBtn.disabled = false;
                }
              }
            })
            .catch(error => {
              console.error('删除错误:', error);
              alert('删除失败，请检查网络连接');
              // 恢复按钮状态
              if (deleteBtn) {
                deleteBtn.textContent = '删除';
                deleteBtn.disabled = false;
              }
            });
  }

  // 检查表格是否为空
  function checkTableEmpty() {
    const tableBody = document.getElementById('tableBody');
    if (tableBody && tableBody.children.length === 0) {
      const currentKeyword = document.getElementById('keywordInput').value;
      showNoResults(currentKeyword);
    }
  }

  // 页面加载完成后初始化
  document.addEventListener('DOMContentLoaded', function() {
    const searchForm = document.getElementById('searchForm');
    const keywordInput = document.getElementById('keywordInput');
    const ajaxSearchBtn = document.getElementById('ajaxSearchBtn');
    const normalSearchBtn = document.getElementById('normalSearchBtn');
    const ajaxToggle = document.getElementById('ajaxToggle');

    // 初始化AJAX切换状态
    const useAjax = localStorage.getItem('useAjaxSearch') !== 'false';
    ajaxToggle.checked = useAjax;
    updateSearchMode(useAjax);

    // AJAX搜索按钮点击事件
    if (ajaxSearchBtn) {
      ajaxSearchBtn.addEventListener('click', function(e) {
        e.preventDefault();
        const keyword = keywordInput.value.trim();
        if (useAjax) {
          performAjaxSearch(keyword);
        } else {
          searchForm.submit();
        }
      });
    }

    // 搜索框回车键支持
    if (keywordInput) {
      keywordInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
          e.preventDefault();
          const keyword = this.value.trim();
          if (useAjax) {
            performAjaxSearch(keyword);
          } else {
            searchForm.submit();
          }
        }
      });
    }

    // AJAX切换事件
    if (ajaxToggle) {
      ajaxToggle.addEventListener('change', function() {
        const useAjax = this.checked;
        localStorage.setItem('useAjaxSearch', useAjax);
        updateSearchMode(useAjax);
      });
    }

    // 浏览器历史记录导航支持
    window.addEventListener('popstate', function(event) {
      const urlParams = new URLSearchParams(window.location.search);
      const keyword = urlParams.get('keyword');
      keywordInput.value = keyword || '';

      if (keyword && useAjax) {
        performAjaxSearch(keyword);
      }
    });
  });

  // 更新搜索模式显示
  function updateSearchMode(useAjax) {
    const ajaxSearchBtn = document.getElementById('ajaxSearchBtn');
    const normalSearchBtn = document.getElementById('normalSearchBtn');
    const searchStatus = document.getElementById('searchStatus');

    if (useAjax) {
      ajaxSearchBtn.textContent = '搜索';
      normalSearchBtn.style.display = 'none';
      if (searchStatus) {
        searchStatus.textContent = '使用无刷新搜索';
        searchStatus.style.color = '#3498db';
      }
    } else {
      ajaxSearchBtn.textContent = 'AJAX搜索';
      normalSearchBtn.style.display = 'inline-block';
      if (searchStatus) {
        searchStatus.textContent = '使用传统搜索';
        searchStatus.style.color = '#666';
      }
    }
  }

  // 搜索框回车键支持（原有功能保留）
  document.querySelector('input[name="keyword"]').addEventListener('keypress', function(e) {
    if (e.key === 'Enter' && !document.getElementById('ajaxToggle').checked) {
      this.form.submit();
    }
  });
</script>
</body>
</html>