package com.herb.dao;

import com.herb.model.Herb;
import com.herb.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HerbDAO {

    // 检查药材编号是否存在
    public boolean checkCodeExists(String code, Integer excludeId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql;

            if (excludeId != null) {
                sql = "SELECT COUNT(*) FROM herbs WHERE code = ? AND id != ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, code);
                ps.setInt(2, excludeId);
            } else {
                sql = "SELECT COUNT(*) FROM herbs WHERE code = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, code);
            }

            rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    public boolean checkCodeExists(String code) {
        return checkCodeExists(code, null);
    }

    // 获取所有药材
    public List<Herb> getAllHerbs() {
        List<Herb> herbs = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            System.out.println("=== HerbDAO.getAllHerbs() 开始查询 ===");
            conn = DBUtil.getConnection();
            System.out.println("数据库连接成功");

            // 只查询最基本的字段
            String sql = "SELECT id, name, price, stock FROM herbs ORDER BY id DESC";
            System.out.println("执行SQL: " + sql);

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            int count = 0;
            while (rs.next()) {
                Herb herb = new Herb();
                herb.setId(rs.getInt("id"));
                herb.setName(rs.getString("name"));
                herb.setPrice(rs.getBigDecimal("price"));
                herb.setStock(rs.getInt("stock"));
                herbs.add(herb);
                count++;

                System.out.println("查询到药材 #" + count + ": " +
                        "ID=" + herb.getId() +
                        ", 名称='" + herb.getName() + "'" +
                        ", 价格=" + herb.getPrice() +
                        ", 库存=" + herb.getStock());
            }

            System.out.println("总共查询到 " + count + " 个药材");
            System.out.println("=== HerbDAO.getAllHerbs() 查询结束 ===");

        } catch (SQLException e) {
            System.err.println("数据库查询错误: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return herbs;
    }

    // 根据ID获取药材
    public Herb getHerbById(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Herb herb = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT id, name, price, stock FROM herbs WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                herb = new Herb();
                herb.setId(rs.getInt("id"));
                herb.setName(rs.getString("name"));
                herb.setPrice(rs.getBigDecimal("price"));
                herb.setStock(rs.getInt("stock"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return herb;
    }

    // 添加药材
    public boolean addHerb(Herb herb) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO herbs (name, price, stock) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, herb.getName());
            ps.setBigDecimal(2, herb.getPrice());
            ps.setInt(3, herb.getStock() != null ? herb.getStock() : 0);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    // 更新药材
    public boolean updateHerb(Herb herb) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE herbs SET name = ?, price = ?, stock = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, herb.getName());
            ps.setBigDecimal(2, herb.getPrice());
            ps.setInt(3, herb.getStock() != null ? herb.getStock() : 0);
            ps.setInt(4, herb.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    // 删除药材
    public boolean deleteById(int id) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM herbs WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    // 搜索药材
    public List<Herb> searchByKeyword(String keyword) {
        List<Herb> herbs = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT id, name, price, stock FROM herbs WHERE name LIKE ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");

            rs = ps.executeQuery();

            while (rs.next()) {
                Herb herb = new Herb();
                herb.setId(rs.getInt("id"));
                herb.setName(rs.getString("name"));
                herb.setPrice(rs.getBigDecimal("price"));
                herb.setStock(rs.getInt("stock"));
                herbs.add(herb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return herbs;
    }

    // 更新库存
    public boolean updateStock(int herbId, int quantity) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE herbs SET stock = stock - ? WHERE id = ? AND stock >= ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, herbId);
            ps.setInt(3, quantity);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }
}