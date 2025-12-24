package com.herb.util;

import java.sql.*;

public class DBUtil {
    // 数据库连接信息 - 根据你的实际情况修改
    private static final String URL = "jdbc:mysql://localhost:3306/herb_management?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false";
    private static final String USER = "root";
    private static final String PASSWORD = "maomaoyu";  // 你的密码

    // 加载数据库驱动
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL驱动加载成功！");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL驱动加载失败！");
            e.printStackTrace();
        }
    }

    // 获取数据库连接
    public static Connection getConnection() {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("数据库连接成功！");
            return conn;
        } catch (SQLException e) {
            System.err.println("数据库连接失败！");
            e.printStackTrace();
            return null;
        }
    }

    // 关闭资源
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
            System.out.println("数据库资源已关闭");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 测试数据库连接
    public static void testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn != null) {
                System.out.println("数据库连接测试成功！");
            } else {
                System.out.println("数据库连接测试失败！");
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}