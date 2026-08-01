package DAO;

import Model.ColorOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ColorOptionDAO {

    private final Connection conn;

    public ColorOptionDAO() {
        conn = DBConnection.DBConnection.connect();
    }

    public List<ColorOption> listActive() {
        List<ColorOption> list = new ArrayList<>();
        String sql = "SELECT ID, name, hexCode, sortOrder, status FROM ColorOption WHERE status = 1 ORDER BY sortOrder, ID";
        try ( PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            System.out.println("ColorOptionDAO.listActive: " + e);
        }
        return list;
    }

    public ColorOption findById(int id) {
        String sql = "SELECT ID, name, hexCode, sortOrder, status FROM ColorOption WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("ColorOptionDAO.findById: " + e);
        }
        return null;
    }
    
    public ColorOption getById(int id) {
        return findById(id);
    }
    
    public List<ColorOption> getAll() {
        List<ColorOption> list = new ArrayList<>();
        String sql = "SELECT ID, name, hexCode, sortOrder, status FROM ColorOption ORDER BY sortOrder, ID DESC";
        try ( PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            System.out.println("ColorOptionDAO.getAll: " + e);
        }
        return list;
    }

    public int insert(ColorOption c) {
        String sql = "INSERT INTO ColorOption (name, hexCode, sortOrder, status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, c.getName());
            st.setString(2, c.getHexCode());
            st.setInt(3, c.getSortOrder());
            st.setInt(4, c.getStatus());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("ColorOptionDAO.insert: " + e);
        }
        return 0;
    }

    public int update(ColorOption c) {
        String sql = "UPDATE ColorOption SET name=?, hexCode=?, sortOrder=?, status=? WHERE ID=?";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, c.getName());
            st.setString(2, c.getHexCode());
            st.setInt(3, c.getSortOrder());
            st.setInt(4, c.getStatus());
            st.setInt(5, c.getID());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("ColorOptionDAO.update: " + e);
        }
        return 0;
    }

    public int delete(int id) {
        String sql = "DELETE FROM ColorOption WHERE ID=?";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("ColorOptionDAO.delete: " + e);
        }
        return 0;
    }

    private ColorOption map(ResultSet rs) throws SQLException {
        ColorOption c = new ColorOption(
                rs.getInt("ID"),
                rs.getString("name"),
                rs.getString("hexCode"),
                rs.getInt("sortOrder"),
                rs.getInt("status")
        );
        try {
            c.setProductCount(rs.getInt("productCount"));
        } catch (SQLException e) {
        }
        return c;
    }

    public int count(String search, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM ColorOption WHERE 1=1";
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
            System.out.println("ColorOptionDAO count: " + e);
        }
        return 0;
    }

    public java.util.List<Model.ColorOption> getPaginated(String search, String statusFilter, String sort, int page, int limit) {
        java.util.List<Model.ColorOption> list = new java.util.ArrayList<>();
        String sql = "SELECT c.*, (SELECT COUNT(DISTINCT productID) FROM ProductVariant WHERE colorOptionID = c.ID AND status = 1) AS productCount FROM ColorOption c WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND name LIKE ?";
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
                list.add(this.map(result));
            }
        } catch (java.sql.SQLException e) {
            System.out.println("ColorOptionDAO getPaginated: " + e);
        }
        return list;
    }
}