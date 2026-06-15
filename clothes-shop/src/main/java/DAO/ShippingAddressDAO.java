package DAO;

import DBConnection.DBConnection;
import Model.ShippingAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ShippingAddressDAO {

    public List<ShippingAddress> getAddressesByAccountId(int accountId) {
        List<ShippingAddress> list = new ArrayList<>();
        String sql = "SELECT * FROM ShippingAddress WHERE accountID = ? ORDER BY isDefault DESC, createdAt DESC";
        try (Connection conn = DBConnection.connect(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, accountId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    ShippingAddress a = new ShippingAddress();
                    a.setId(rs.getInt("id"));
                    a.setAccountID(rs.getInt("accountID"));
                    a.setFullName(rs.getString("fullName"));
                    a.setPhone(rs.getString("phone"));
                    a.setAddress(rs.getString("address"));
                    a.setDetailAddress(rs.getString("detailAddress"));
                    a.setIsDefault(rs.getBoolean("isDefault"));
                    a.setCreatedAt(rs.getTimestamp("createdAt"));
                    list.add(a);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ShippingAddress getAddressById(int id) {
        String sql = "SELECT * FROM ShippingAddress WHERE id = ?";
        try (Connection conn = DBConnection.connect(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    ShippingAddress a = new ShippingAddress();
                    a.setId(rs.getInt("id"));
                    a.setAccountID(rs.getInt("accountID"));
                    a.setFullName(rs.getString("fullName"));
                    a.setPhone(rs.getString("phone"));
                    a.setAddress(rs.getString("address"));
                    a.setDetailAddress(rs.getString("detailAddress"));
                    a.setIsDefault(rs.getBoolean("isDefault"));
                    a.setCreatedAt(rs.getTimestamp("createdAt"));
                    return a;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(ShippingAddress address) {
        if (address.isIsDefault()) {
            clearDefault(address.getAccountID());
        }
        String sql = "INSERT INTO ShippingAddress (accountID, fullName, phone, address, detailAddress, isDefault) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.connect(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, address.getAccountID());
            st.setString(2, address.getFullName());
            st.setString(3, address.getPhone());
            st.setString(4, address.getAddress());
            st.setString(5, address.getDetailAddress());
            st.setBoolean(6, address.isIsDefault());
            int affected = st.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(ShippingAddress address) {
        if (address.isIsDefault()) {
            clearDefault(address.getAccountID());
        }
        String sql = "UPDATE ShippingAddress SET fullName = ?, phone = ?, address = ?, detailAddress = ?, isDefault = ? WHERE id = ? AND accountID = ?";
        try (Connection conn = DBConnection.connect(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, address.getFullName());
            st.setString(2, address.getPhone());
            st.setString(3, address.getAddress());
            st.setString(4, address.getDetailAddress());
            st.setBoolean(5, address.isIsDefault());
            st.setInt(6, address.getId());
            st.setInt(7, address.getAccountID()); // Ensures they only update their own
            int affected = st.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id, int accountId) {
        String sql = "DELETE FROM ShippingAddress WHERE id = ? AND accountID = ?";
        try (Connection conn = DBConnection.connect(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            st.setInt(2, accountId); // Ensures they only delete their own
            int affected = st.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void clearDefault(int accountId) {
        String sql = "UPDATE ShippingAddress SET isDefault = 0 WHERE accountID = ?";
        try (Connection conn = DBConnection.connect(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, accountId);
            st.executeUpdate();
        } catch (Exception e) {}
    }

    public boolean setDefault(int id, int accountId) {
        Connection conn = null;
        try {
            conn = DBConnection.connect();
            conn.setAutoCommit(false);
            
            // Clear default for all user's addresses
            String sql1 = "UPDATE ShippingAddress SET isDefault = 0 WHERE accountID = ?";
            try (PreparedStatement st1 = conn.prepareStatement(sql1)) {
                st1.setInt(1, accountId);
                st1.executeUpdate();
            }
            
            // Set default for specific address
            String sql2 = "UPDATE ShippingAddress SET isDefault = 1 WHERE id = ? AND accountID = ?";
            try (PreparedStatement st2 = conn.prepareStatement(sql2)) {
                st2.setInt(1, id);
                st2.setInt(2, accountId);
                st2.executeUpdate();
            }
            
            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (Exception ex) {}
            }
        }
    }
}
