package DAO;

import Model.SizeOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SizeOptionDAO {

    private Connection conn;

    public SizeOptionDAO() {
        try {
            conn = DBConnection.DBConnection.connect();
        } catch (Exception e) {
            System.out.println("Connection fail: " + e);
        }
    }

    public List<SizeOption> getByGroupId(int groupId) {
        List<SizeOption> list = new ArrayList<>();
        String sql = "SELECT * FROM SizeOption WHERE sizeGroupID = ? ORDER BY sortOrder ASC, ID DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, groupId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(getSizeOption(rs));
            }
        } catch (Exception e) {
            System.out.println("SizeOptionDAO getByGroupId: " + e);
        }
        return list;
    }

    public List<SizeOption> allSizeOption() {
        List<SizeOption> list = new ArrayList<>();
        String sql = "SELECT * FROM SizeOption ORDER BY sizeGroupID ASC, sortOrder ASC, ID DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(getSizeOption(rs));
            }
        } catch (Exception e) {
            System.out.println("SizeOptionDAO allSizeOption: " + e);
        }
        return list;
    }

    public SizeOption getSizeOptionById(int id) {
        String sql = "SELECT * FROM SizeOption WHERE ID = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return getSizeOption(rs);
            }
        } catch (Exception e) {
            System.out.println("SizeOptionDAO getSizeOptionById: " + e);
        }
        return null;
    }

    public int insert(SizeOption s) {
        String sql = "INSERT INTO SizeOption (code, label, sortOrder, status, sizeGroupID) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, s.getCode());
            st.setString(2, s.getLabel());
            st.setInt(3, s.getSortOrder());
            st.setInt(4, s.getStatus());
            st.setInt(5, s.getSizeGroupID());
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("SizeOptionDAO insert: " + e);
        }
        return 0;
    }

    public int update(SizeOption s) {
        String sql = "UPDATE SizeOption SET code=?, label=?, sortOrder=?, status=?, sizeGroupID=? WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, s.getCode());
            st.setString(2, s.getLabel());
            st.setInt(3, s.getSortOrder());
            st.setInt(4, s.getStatus());
            st.setInt(5, s.getSizeGroupID());
            st.setInt(6, s.getID());
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("SizeOptionDAO update: " + e);
        }
        return 0;
    }

    public int delete(int id) {
        String sql = "DELETE FROM SizeOption WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("SizeOptionDAO delete: " + e);
        }
        return 0;
    }

    private SizeOption getSizeOption(ResultSet rs) throws SQLException {
        SizeOption s = new SizeOption();
        s.setID(rs.getInt("ID"));
        s.setCode(rs.getString("code"));
        s.setLabel(rs.getString("label"));
        s.setSortOrder(rs.getInt("sortOrder"));
        s.setStatus(rs.getInt("status"));
        s.setSizeGroupID(rs.getInt("sizeGroupID"));
        return s;
    }

    public int count(String search, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM SizeOption WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND label LIKE ?";
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
            System.out.println("SizeOptionDAO count: " + e);
        }
        return 0;
    }

    public java.util.List<Model.SizeOption> getPaginated(String search, String statusFilter, String sort, int page, int limit) {
        java.util.List<Model.SizeOption> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM SizeOption WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND label LIKE ?";
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
                list.add(this.getSizeOption(result));
            }
        } catch (java.sql.SQLException e) {
            System.out.println("SizeOptionDAO getPaginated: " + e);
        }
        return list;
    }
}