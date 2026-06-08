/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package DAO;

import DBConnection.DBConnection;
import Model.Category;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author HP
 */
public class CategoryDAO {
private Connection conn;

    public CategoryDAO() {
        try {
            conn = DBConnection.connect();
        } catch (Exception e) {
            conn = null;
        }
    }
//  user
    public List<Category> getCategoryInHome() {
        String sql = "select top 5 c.* from Category as c where c.status = 1";
        List<Category> categories = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                categories.add(this.getCategory(result));
            }
        } catch (SQLException er) {

        }
        return categories;
    }
    
    public List<Category> getCategoryActive() {
        String sql = "select c.* from Category as c where c.status = 1";
        List<Category> categories = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                categories.add(this.getCategory(result));
            }
        } catch (SQLException er) {

        }
        return categories;
    }
    
    public Category getCategoryActiveByID(int id) {
        String sql = "select c.* from Category as c where c.status = 1 and id=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return this.getCategory(result);
            }
        } catch (SQLException er) {
            System.out.println("Get category active by id: " + er);
        }
        return null;
    }
//  admin

    public List<Category> allCategory() {
        String sql = "select * from Category order by id desc";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            List<Category> categories = new ArrayList<>();
            while (result.next()) {
                categories.add(this.getCategory(result));
            }
            return categories;
        } catch (SQLException er) {

        }
        return null;
    }

    public int getNumberProductByCategory(int id) {
        String sql = "select count(id) as numberProduct from Product where categoryID =?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return result.getInt("numberProduct");
            }
            return 0;
        } catch (SQLException e) {
             System.out.println("Get number product by category: "  + e);
        }
        return 0;
    }

    public List<Category> getCategoryByStatus(int status) {
        String sql = "select * from Category  where status=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, status);
            ResultSet result = st.executeQuery();
            List<Category> categories = new ArrayList<>();
            while (result.next()) {
                categories.add(this.getCategory(result));
            }
            return categories;
        } catch (SQLException er) {

        }
        return null;
    }

    public Category getCategoryByID(int id) {
        String sql = "SELECT c.*, sg.name AS sizeGroupName FROM Category c LEFT JOIN SizeGroup sg ON c.sizeGroupID = sg.ID WHERE c.id = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return this.getCategory(result);
            }
        } catch (SQLException er) {
        }
        return null;
    }

    private Category getCategory(ResultSet result) {
        try {
            int ID = result.getInt("ID");
            String name = result.getString("name");
            Timestamp datePost = result.getTimestamp("datePost");
            Timestamp dateUpdate = result.getTimestamp("dateUpdate");
            int status = result.getInt("status");
            int sizeGroupID = 0;
            String sizeGroupName = null;
            try {
                sizeGroupID = result.getInt("sizeGroupID");
                try { sizeGroupName = result.getString("sizeGroupName"); } catch (SQLException ignore) {}
            } catch (SQLException ignored) {
            }
            Category c = new Category(ID, name, datePost, dateUpdate, status, sizeGroupID);
            c.setSizeGroupName(sizeGroupName);
            return c;
        } catch (SQLException e) {
            System.out.println("Get category: " + e);
        }
        return null;
    }

    public int insert(Category c) {
        int result = 0;
        String sql = "INSERT INTO Category (name, datePost, status, sizeGroupID) VALUES(?, ?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, c.getName());
            st.setTimestamp(2, c.getDatePost());
            st.setInt(3, c.getStatus());
            int sg = c.getSizeGroupID();
            if (sg <= 0) {
                sg = resolveDefaultSizeGroupId();
            }
            st.setInt(4, sg);
            result = st.executeUpdate();
        } catch (SQLException e) {

        }
        return result;
    }

    public int update(Category c) {
        int result = 0;
        String sql = "update Category set name=?, dateUpdate=?, status=?, sizeGroupID=? where ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, c.getName());
            st.setTimestamp(2, c.getDateUpdate());
            st.setInt(3, c.getStatus());
            int sg = c.getSizeGroupID();
            if (sg <= 0) {
                sg = resolveDefaultSizeGroupId();
            }
            st.setInt(4, sg);
            st.setInt(5, c.getID());
            result = st.executeUpdate();
        } catch (SQLException e) {

        }
        return result;
    }

    private int resolveDefaultSizeGroupId() {
        String sql = "SELECT TOP 1 ID FROM SizeGroup WHERE code = N'CLOTHING' AND status = 1";
        try (PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("CategoryDAO.resolveDefaultSizeGroupId: " + e);
        }
        return 1;
    }

    public int delete(int id) {
        int result = 0;
        String sql = "delete from Category where ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            result = st.executeUpdate();
        } catch (SQLException er) {

        }
        return result;
    }

    public int count(String search, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM Category WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND name LIKE ?";
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql += " AND status = ?";
        }
        try {
            java.sql.PreparedStatement st = conn.prepareStatement(sql);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                st.setString(paramIndex++, "%" + search.trim() + "%");
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                st.setInt(paramIndex++, Integer.parseInt(statusFilter));
            }
            java.sql.ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (java.sql.SQLException e) {
            System.out.println("CategoryDAO count: " + e);
        }
        return 0;
    }

    public java.util.List<Model.Category> getPaginated(String search, String statusFilter, String sort, int page, int limit) {
        java.util.List<Model.Category> list = new java.util.ArrayList<>();
        String sql = "SELECT c.*, sg.name AS sizeGroupName FROM Category c LEFT JOIN SizeGroup sg ON c.sizeGroupID = sg.ID WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND c.name LIKE ?";
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql += " AND c.status = ?";
        }
        
        if ("oldest".equals(sort)) {
            sql += " ORDER BY c.id ASC";
        } else {
            sql += " ORDER BY c.id DESC";
        }
        
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try {
            java.sql.PreparedStatement st = conn.prepareStatement(sql);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                st.setString(paramIndex++, "%" + search.trim() + "%");
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                st.setInt(paramIndex++, Integer.parseInt(statusFilter));
            }
            
            st.setInt(paramIndex++, (page - 1) * limit);
            st.setInt(paramIndex++, limit);
            
            java.sql.ResultSet result = st.executeQuery();
            while (result.next()) {
                list.add(this.getCategory(result));
            }
        } catch (java.sql.SQLException e) {
            System.out.println("CategoryDAO getPaginated: " + e);
        }
        return list;
    }
}
