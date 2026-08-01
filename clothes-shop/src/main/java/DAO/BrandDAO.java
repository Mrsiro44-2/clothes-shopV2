/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBConnection.DBConnection;
import Model.Brand;
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
public class BrandDAO {

    private Connection conn;

    public BrandDAO() {
        try {
            conn = DBConnection.connect();
        } catch (Exception e) {
            conn = null;
        }
    }

//  user
    public List<Brand> getTopBrand() {
        String sql = "SELECT TOP 6 b.*, ISNULL(SUM(bd.numberOfProduct), 0) AS total_sold "
                + "FROM Brand b "
                + "INNER JOIN Product p ON p.brandID = b.ID AND p.status = 1 "
                + "LEFT JOIN ProductVariant v ON v.productID = p.ID "
                + "LEFT JOIN BillDetail bd ON bd.productVariantID = v.ID "
                + "LEFT JOIN Bill bl ON bl.id = bd.billID AND bl.status NOT IN (0, 2, 4) "
                + "WHERE b.status = 1 "
                + "GROUP BY b.ID, b.name, b.img, b.status, b.datePost, b.dateUpdate "
                + "ORDER BY total_sold DESC";
        List<Brand> brands = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                brands.add(this.getBrand(result));
            }
        } catch (SQLException er) {
            System.out.println("Get top brand: " + er);
        }
        return brands;
    }
    
    public boolean isExistName(String name, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Brand WHERE LOWER(name) = LOWER(?) AND ID != ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, name.trim());
            st.setInt(2, excludeId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("BrandDAO.isExistName: " + e);
        }
        return false;
    }
    
    public List<Brand> getBrandActive() {
        String sql = "SELECT b.*, ISNULL(SUM(bd.numberOfProduct), 0) AS total_sold "
                + "FROM Brand b "
                + "INNER JOIN Product p ON p.brandID = b.ID AND p.status = 1 "
                + "LEFT JOIN ProductVariant v ON v.productID = p.ID "
                + "LEFT JOIN BillDetail bd ON bd.productVariantID = v.ID "
                + "LEFT JOIN Bill bl ON bl.id = bd.billID AND bl.status NOT IN (0, 2, 4) "
                + "WHERE b.status = 1 "
                + "GROUP BY b.ID, b.name, b.img, b.status, b.datePost, b.dateUpdate "
                + "ORDER BY total_sold DESC";
        List<Brand> brands = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                brands.add(this.getBrand(result));
            }
            return brands;
        } catch (SQLException er) {
            System.out.println("Get top brand: " + er);
        }
        return brands;
    }
    
    public Brand getBrandActiveByID(int id) {
        String sql = "select c.* from Brand as c where c.status = 1 and id=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return this.getBrand(result);
            }
        } catch (SQLException er) {
            System.out.println("Get brand active by id: " + er);
        }
        return null;
    }
        
// end user

    public List<Brand> allBrand() {
        String sql = "select * from Brand order by id desc";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            List<Brand> brands = new ArrayList<>();
            while (result.next()) {
                brands.add(this.getBrand(result));
            }
            return brands;
        } catch (SQLException er) {

        }
        return null;
    }

    public List<Brand> getBrandByStatus(int status) {
        String sql = "select * from Brand where status=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, status);
            ResultSet result = st.executeQuery();
            List<Brand> producers = new ArrayList<>();
            while (result.next()) {
                producers.add(this.getBrand(result));
            }
            return producers;
        } catch (SQLException er) {
            System.out.println("Get producer by status: " + er);
        }
        return null;
    }

    public int getNumberProductByBrand(int id) {
        String sql = "select count(id) as numberProduct from Product where brandID =?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return result.getInt("numberProduct");
            }
            return 0;
        } catch (SQLException e) {
            System.out.println("Get number product by brand: " + e);
        }
        return 0;
    }

    public Brand getBrandByID(int id) {
        String sql = "select * from Brand where id = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return this.getBrand(result);
            }
        } catch (SQLException e) {
            System.out.println("Get producer by id: " + e);
        }
        return null;
    }

    private Brand getBrand(ResultSet result) {
        try {
            int ID = result.getInt("ID");
            String name = result.getString("name");
            String img = result.getString("img");
            Timestamp datePost = result.getTimestamp("datePost");
            Timestamp dateUpdate = result.getTimestamp("dateUpdate");
            int status = result.getInt("status");
            Brand c = new Brand(ID, name, img, datePost, dateUpdate, status);
            return c;
        } catch (SQLException e) {
            System.out.println("Get producer: " + e);
        }
        return null;
    }

    public int insert(Brand c) {

        int result = 0;
        String sql = "INSERT INTO Brand (name, img, datePost, status) VALUES(?, ?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, c.getName());
            st.setString(2, c.getImg());
            st.setTimestamp(3, c.getDatePost());
            st.setInt(4, c.getStatus());
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Add  new producer: " + e);
        }
        return result;
    }

    public int update(Brand c) {
        int result = 0;
        String sql = "update Brand set name=?, img=?, dateUpdate=?, status=? where ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, c.getName());
            st.setString(2, c.getImg());
            st.setTimestamp(3, c.getDateUpdate());
            st.setInt(4, c.getStatus());
            st.setInt(5, c.getID());
            result = st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Update producer: " + e);
        }
        return result;
    }

    public int delete(int id) {
        int result = 0;
        String sql = "delete from Brand where id=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            result = st.executeUpdate();
        } catch (SQLException er) {

        }
        return result;
    }

    public int count(String search, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM Brand WHERE 1=1";
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
            System.out.println("BrandDAO count: " + e);
        }
        return 0;
    }

    public java.util.List<Model.Brand> getPaginated(String search, String statusFilter, String sort, int page, int limit) {
        java.util.List<Model.Brand> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Brand WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND name LIKE ?";
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql += " AND status = ?";
        }
        
        if ("oldest".equals(sort)) {
            sql += " ORDER BY id ASC";
        } else {
            sql += " ORDER BY id DESC";
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
                list.add(this.getBrand(result));
            }
        } catch (java.sql.SQLException e) {
            System.out.println("BrandDAO getPaginated: " + e);
        }
        return list;
    }
}