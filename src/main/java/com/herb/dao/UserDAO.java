package com.herb.dao;

import com.herb.model.User;
import com.herb.util.DBUtil;

import java.sql.*;
import java.util.Date;

public class UserDAO {

    // 根据用户名查找用户
    public User findByUsername(String username) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        User user = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT id, username, password, email, phone, role, last_login, created_time " +
                    "FROM users WHERE username = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setLastLogin(rs.getTimestamp("last_login"));
                user.setCreatedTime(rs.getTimestamp("created_time"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return user;
    }

    // 更新最后登录时间
    public boolean updateLastLogin(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE users SET last_login = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    // 验证用户名和密码
    public User authenticate(String username, String password) {
        User user = findByUsername(username);
        if (user != null && password.equals(user.getPassword())) {
            // 更新最后登录时间
            updateLastLogin(user.getId());
            return user;
        }
        return null;
    }

    // 检查用户名是否存在
    public boolean usernameExists(String username) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return false;
    }
}