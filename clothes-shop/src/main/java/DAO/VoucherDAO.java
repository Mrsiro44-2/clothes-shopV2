package DAO;

import Model.Voucher;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    private Connection conn;

    public VoucherDAO() {
        try {
            conn = DBConnection.DBConnection.connect();
        } catch (Exception e) {
            System.out.println("Connection fail: " + e);
        }
    }


    public List<Voucher> getPublicVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Voucher WHERE code LIKE 'PUB_%' AND status = 1 AND [end] >= CAST(GETDATE() AS DATE) ORDER BY ID DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(getVoucher(rs));
            }
        } catch (Exception e) {
            System.out.println("VoucherDAO getPublicVouchers: " + e);
        }
        return list;
    }

    public List<Voucher> getValidVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Voucher WHERE status = 1 AND [end] >= CAST(GETDATE() AS DATE) ORDER BY ID DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(getVoucher(rs));
            }
        } catch (Exception e) {
            System.out.println("VoucherDAO getValidVouchers: " + e);
        }
        return list;
    }

    public Voucher getVoucherById(int id) {
        String sql = "SELECT * FROM Voucher WHERE ID = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return getVoucher(rs);
            }
        } catch (Exception e) {
            System.out.println("VoucherDAO getVoucherById: " + e);
        }
        return null;
    }

    public boolean insert(Voucher v) {
        String sql = "INSERT INTO Voucher (name, code, discountType, value, minOrderAmount, maxDiscount, usageLimit, used, start, [end], status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, v.getName());
            st.setString(2, v.getCode());
            st.setInt(3, v.getDiscountType());
            st.setFloat(4, v.getValue());
            st.setFloat(5, v.getMinOrderAmount());
            if (v.getMaxDiscount() != null) st.setFloat(6, v.getMaxDiscount()); else st.setNull(6, java.sql.Types.FLOAT);
            if (v.getUsageLimit() != null) st.setInt(7, v.getUsageLimit()); else st.setNull(7, java.sql.Types.INTEGER);
            st.setInt(8, v.getUsed());
            st.setDate(9, v.getStart());
            st.setDate(10, v.getEnd());
            st.setInt(11, v.getStatus());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("VoucherDAO insert: " + e);
        }
        return false;
    }

    public boolean update(Voucher v) {
        String sql = "UPDATE Voucher SET name=?, code=?, discountType=?, value=?, minOrderAmount=?, maxDiscount=?, usageLimit=?, start=?, [end]=?, status=? WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, v.getName());
            st.setString(2, v.getCode());
            st.setInt(3, v.getDiscountType());
            st.setFloat(4, v.getValue());
            st.setFloat(5, v.getMinOrderAmount());
            if (v.getMaxDiscount() != null) st.setFloat(6, v.getMaxDiscount()); else st.setNull(6, java.sql.Types.FLOAT);
            if (v.getUsageLimit() != null) st.setInt(7, v.getUsageLimit()); else st.setNull(7, java.sql.Types.INTEGER);
            st.setDate(8, v.getStart());
            st.setDate(9, v.getEnd());
            st.setInt(10, v.getStatus());
            st.setInt(11, v.getId());
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("VoucherDAO update: " + e);
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Voucher WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("VoucherDAO delete: " + e);
        }
        return false;
    }
    
    public int getNumberOrderUsed(int voucherId) {
        String sql = "SELECT COUNT(*) FROM Bill WHERE voucherID = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, voucherId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("VoucherDAO getNumberOrderUsed: " + e);
        }
        return 0;
    }

    private Voucher getVoucher(ResultSet rs) throws Exception {
        Voucher v = new Voucher();
        v.setId(rs.getInt("ID"));
        v.setName(rs.getString("name"));
        v.setCode(rs.getString("code"));
        v.setDiscountType(rs.getInt("discountType"));
        v.setValue(rs.getFloat("value"));
        v.setMinOrderAmount(rs.getFloat("minOrderAmount"));
        v.setMaxDiscount(rs.getObject("maxDiscount") != null ? rs.getFloat("maxDiscount") : null);
        v.setUsageLimit(rs.getObject("usageLimit") != null ? rs.getInt("usageLimit") : null);
        v.setUsed(rs.getInt("used"));
        v.setStart(rs.getDate("start"));
        v.setEnd(rs.getDate("end"));
        v.setStatus(rs.getInt("status"));
        return v;
    }

    public int count(String search, String statusFilter) {
        String sql = "SELECT COUNT(*) FROM Voucher WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND code LIKE ?";
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
            System.out.println("VoucherDAO count: " + e);
        }
        return 0;
    }

    public java.util.List<Model.Voucher> getPaginated(String search, String statusFilter, String sort, int page, int limit) {
        java.util.List<Model.Voucher> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Voucher WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND code LIKE ?";
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
                list.add(this.getVoucher(result));
            }
        } catch (Exception e) {
            System.out.println("VoucherDAO getPaginated: " + e);
        }
        return list;
    }

    public Voucher getVoucherByCode(String code) {
        String sql = "SELECT * FROM Voucher WHERE code = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, code);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return getVoucher(rs);
            }
        } catch (Exception e) {
            System.out.println("VoucherDAO getVoucherByCode: " + e);
        }
        return null;
    }

    public boolean incrementUsed(int id) {
        String sql = "UPDATE Voucher SET used = used + 1 WHERE ID = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("VoucherDAO incrementUsed: " + e);
        }
        return false;
    }

    /**
     * Kiểm tra user đã sử dụng voucher này chưa (qua bảng Bill).
     */
    public boolean hasUserUsedVoucher(int voucherId, int userId) {
        String sql = "SELECT COUNT(*) FROM Bill WHERE voucherID = ? AND customerID = ? AND status != 2";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, voucherId);
            st.setInt(2, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("VoucherDAO hasUserUsedVoucher: " + e);
        }
        return false;
    }
}