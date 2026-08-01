package DAO;

import Model.SizeGroup;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SizeGroupDAO {

    private Connection conn;

    public SizeGroupDAO() {
        try {
            conn = DBConnection.DBConnection.connect();
        } catch (Exception e) {
            System.out.println("Connection fail: " + e);
        }
    }

    public List<SizeGroup> allSizeGroup() {
        List<SizeGroup> list = new ArrayList<>();
        String sql = "SELECT * FROM SizeGroup ORDER BY sortOrder ASC, ID DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(getSizeGroup(rs));
            }
        } catch (Exception e) {
            System.out.println("SizeGroupDAO allSizeGroup: " + e);
        }
        return list;
    }

    public SizeGroup getSizeGroupById(int id) {
        String sql = "SELECT * FROM SizeGroup WHERE ID = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return getSizeGroup(rs);
            }
        } catch (Exception e) {
            System.out.println("SizeGroupDAO getSizeGroupById: " + e);
        }
        return null;
    }
    
    public boolean isExistName(String name, int excludeId) {
        String sql = "SELECT COUNT(*) FROM SizeGroup WHERE LOWER(name) = LOWER(?) AND ID != ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, name.trim());
            st.setInt(2, excludeId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("SizeGroupDAO.isExistName: " + e);
        }
        return false;
    }

    public int insert(SizeGroup s) {
        String sql = "INSERT INTO SizeGroup (code, name, sortOrder, status) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, s.getCode());
            st.setString(2, s.getName());
            st.setInt(3, s.getSortOrder());
            st.setInt(4, s.getStatus());
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("SizeGroupDAO insert: " + e);
        }
        return 0;
    }

    public int update(SizeGroup s) {
        String sql = "UPDATE SizeGroup SET code=?, name=?, sortOrder=?, status=? WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, s.getCode());
            st.setString(2, s.getName());
            st.setInt(3, s.getSortOrder());
            st.setInt(4, s.getStatus());
            st.setInt(5, s.getID());
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("SizeGroupDAO update: " + e);
        }
        return 0;
    }

    public int delete(int id) {
        String sql = "DELETE FROM SizeGroup WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("SizeGroupDAO delete: " + e);
        }
        return 0;
    }

    private SizeGroup getSizeGroup(ResultSet rs) throws SQLException {
        SizeGroup s = new SizeGroup();
        s.setID(rs.getInt("ID"));
        s.setCode(rs.getString("code"));
        s.setName(rs.getString("name"));
        s.setSortOrder(rs.getInt("sortOrder"));
        s.setStatus(rs.getInt("status"));
        try {
            s.setProductCount(rs.getInt("productCount"));
        } catch (SQLException e) {}
        return s;
    }

    public int count(String search, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM SizeGroup WHERE 1=1";
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
            System.out.println("SizeGroupDAO count: " + e);
        }
        return 0;
    }

    public java.util.List<Model.SizeGroup> getPaginated(String search, String statusFilter, String sort, int page, int limit) {
        java.util.List<Model.SizeGroup> list = new java.util.ArrayList<>();
        String sql = "SELECT sg.*, (SELECT COUNT(DISTINCT pv.productID) FROM ProductVariant pv INNER JOIN SizeOption so ON so.ID = pv.sizeOptionID WHERE so.sizeGroupID = sg.ID AND pv.status = 1) AS productCount FROM SizeGroup sg WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND name LIKE ?";
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql += " AND sg.status = ?";
        }
        
        if ("oldest".equals(sort)) {
            sql += " ORDER BY sg.id ASC";
        } else {
            sql += " ORDER BY sg.id DESC";
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
                list.add(this.getSizeGroup(result));
            }
        } catch (java.sql.SQLException e) {
            System.out.println("SizeGroupDAO getPaginated: " + e);
        }
        return list;
    }
}