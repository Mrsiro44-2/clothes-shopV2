package DAO;

import Model.Bill;
import Model.BillDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {
    private Connection conn;

    public BillDAO() {
        try {
            conn = DBConnection.DBConnection.connect();
        } catch (Exception e) {
            System.out.println("Connection fail: " + e);
        }
    }

    public List<Bill> allBill() {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT * FROM Bill ORDER BY dateOrder DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Bill b = new Bill();
                b.setID(rs.getInt("id"));
                b.setCustomerID(rs.getInt("customerID"));
                b.setEmail(rs.getString("email"));
                b.setCustomerName(rs.getString("customerName"));
                b.setPhone(rs.getString("phone"));
                b.setAddress(rs.getString("address"));
                b.setDetailAddress(rs.getString("detailAddress"));
                b.setSubtotal(rs.getFloat("subtotal"));
                b.setDiscountAmount(rs.getFloat("discountAmount"));
                b.setVoucherID(rs.getObject("voucherID") != null ? rs.getInt("voucherID") : null);
                b.setVoucherCodeSnapshot(rs.getString("voucherCodeSnapshot"));
                b.setTotal(rs.getFloat("total"));
                b.setStatus(rs.getInt("status"));
                b.setPayment(rs.getInt("payment"));
                b.setDateOrder(rs.getTimestamp("dateOrder"));
                b.setDateUpdate(rs.getTimestamp("dateUpdate"));
                b.setTransactionCode(rs.getString("transactionCode"));
                list.add(b);
            }
        } catch (Exception e) {
            System.out.println("BillDAO allBill: " + e);
        }
        return list;
    }

    public Bill getBillById(int id) {
        String sql = "SELECT * FROM Bill WHERE id = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Bill b = new Bill();
                b.setID(rs.getInt("id"));
                b.setCustomerID(rs.getInt("customerID"));
                b.setEmail(rs.getString("email"));
                b.setCustomerName(rs.getString("customerName"));
                b.setPhone(rs.getString("phone"));
                b.setAddress(rs.getString("address"));
                b.setDetailAddress(rs.getString("detailAddress"));
                b.setSubtotal(rs.getFloat("subtotal"));
                b.setDiscountAmount(rs.getFloat("discountAmount"));
                b.setVoucherID(rs.getObject("voucherID") != null ? rs.getInt("voucherID") : null);
                b.setVoucherCodeSnapshot(rs.getString("voucherCodeSnapshot"));
                b.setTotal(rs.getFloat("total"));
                b.setStatus(rs.getInt("status"));
                b.setPayment(rs.getInt("payment"));
                b.setDateOrder(rs.getTimestamp("dateOrder"));
                b.setDateUpdate(rs.getTimestamp("dateUpdate"));
                b.setTransactionCode(rs.getString("transactionCode"));
                return b;
            }
        } catch (Exception e) {
            System.out.println("BillDAO getBillById: " + e);
        }
        return null;
    }

    public List<BillDetail> getBillDetails(int billId) {
        List<BillDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM BillDetail WHERE billID = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, billId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                BillDetail bd = new BillDetail();
                bd.setID(rs.getInt("ID"));
                bd.setBillID(rs.getInt("billID"));
                bd.setProductVariantID(rs.getObject("productVariantID") != null ? rs.getInt("productVariantID") : null);
                bd.setProductID(rs.getInt("productID"));
                bd.setSkuSnapshot(rs.getString("skuSnapshot"));
                bd.setNameProduct(rs.getString("nameProduct"));
                bd.setModelProduct(rs.getString("modelProduct"));
                bd.setImgProduct(rs.getString("imgProduct"));
                bd.setSizeLabelSnapshot(rs.getString("sizeLabelSnapshot"));
                bd.setColorLabelSnapshot(rs.getString("colorLabelSnapshot"));
                bd.setPriceProduct(rs.getFloat("priceProduct"));
                bd.setNumberOfProduct(rs.getInt("numberOfProduct"));
                list.add(bd);
            }
        } catch (Exception e) {
            System.out.println("BillDAO getBillDetails: " + e);
        }
        return list;
    }

    public boolean updateStatus(int id, int status) {
        String sql = "UPDATE Bill SET status = ?, dateUpdate = ? WHERE id = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, status);
            st.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            st.setInt(3, id);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            System.out.println("BillDAO updateStatus: " + e);
        }
        return false;
    }

    public java.util.Map<String, String> getEmailNameMapOfBuyers() {
        java.util.Map<String, String> map = new java.util.HashMap<>();
        String sql = "SELECT email, customerName FROM Bill WHERE email IS NOT NULL AND email <> '' AND status IN (1,2,3,4,5)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                String e = rs.getString("email").trim();
                String n = rs.getString("customerName");
                if (n == null || n.trim().isEmpty()) n = "Quý khách";
                if (!map.containsKey(e)) {
                    map.put(e, n);
                }
            }
        } catch (SQLException e) {
            System.out.println("BillDAO getEmailNameMapOfBuyers: " + e);
        }
        return map;
    }

    public List<Bill> getBillsByVoucherId(int voucherId) {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT * FROM Bill WHERE voucherID = ? ORDER BY dateOrder DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, voucherId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Bill b = new Bill();
                b.setID(rs.getInt("id"));
                b.setCustomerID(rs.getInt("customerID"));
                b.setEmail(rs.getString("email"));
                b.setCustomerName(rs.getString("customerName"));
                b.setPhone(rs.getString("phone"));
                b.setAddress(rs.getString("address"));
                b.setDetailAddress(rs.getString("detailAddress"));
                b.setSubtotal(rs.getFloat("subtotal"));
                b.setDiscountAmount(rs.getFloat("discountAmount"));
                b.setVoucherID(rs.getObject("voucherID") != null ? rs.getInt("voucherID") : null);
                b.setVoucherCodeSnapshot(rs.getString("voucherCodeSnapshot"));
                b.setTotal(rs.getFloat("total"));
                b.setStatus(rs.getInt("status"));
                b.setPayment(rs.getInt("payment"));
                b.setDateOrder(rs.getTimestamp("dateOrder"));
                b.setDateUpdate(rs.getTimestamp("dateUpdate"));
                b.setTransactionCode(rs.getString("transactionCode"));
                list.add(b);
            }
        } catch (Exception e) {
            System.out.println("BillDAO getBillsByVoucherId: " + e);
        }
        return list;
    }

    public int count(String search, String statusFilter, String customerFilter) {
        String sql = "SELECT COUNT(*) FROM Bill WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (customerName LIKE ? OR phone LIKE ? OR email LIKE ? OR transactionCode LIKE ?)";
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql += " AND status = ?";
        }
        if (customerFilter != null && !customerFilter.trim().isEmpty()) {
            sql += " AND customerID = ?";
        }
        try {
            java.sql.PreparedStatement st = conn.prepareStatement(sql);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                st.setString(paramIndex++, likeSearch);
                st.setString(paramIndex++, likeSearch);
                st.setString(paramIndex++, likeSearch);
                st.setString(paramIndex++, likeSearch);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                st.setInt(paramIndex++, Integer.parseInt(statusFilter));
            }
            if (customerFilter != null && !customerFilter.trim().isEmpty()) {
                st.setInt(paramIndex++, Integer.parseInt(customerFilter));
            }
            java.sql.ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (java.sql.SQLException e) {
            System.out.println("BillDAO count: " + e);
        }
        return 0;
    }

    public java.util.List<Model.Bill> getPaginated(String search, String statusFilter, String customerFilter, String sort, int page, int limit) {
        java.util.List<Model.Bill> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Bill WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (customerName LIKE ? OR phone LIKE ? OR email LIKE ? OR transactionCode LIKE ?)";
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql += " AND status = ?";
        }
        if (customerFilter != null && !customerFilter.trim().isEmpty()) {
            sql += " AND customerID = ?";
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
                String likeSearch = "%" + search.trim() + "%";
                st.setString(paramIndex++, likeSearch);
                st.setString(paramIndex++, likeSearch);
                st.setString(paramIndex++, likeSearch);
                st.setString(paramIndex++, likeSearch);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                st.setInt(paramIndex++, Integer.parseInt(statusFilter));
            }
            if (customerFilter != null && !customerFilter.trim().isEmpty()) {
                st.setInt(paramIndex++, Integer.parseInt(customerFilter));
            }
            
            st.setInt(paramIndex++, (page - 1) * limit);
            st.setInt(paramIndex++, limit);
            
            java.sql.ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Model.Bill b = new Model.Bill();
                b.setID(rs.getInt("id"));
                b.setCustomerID(rs.getInt("customerID"));
                b.setEmail(rs.getString("email"));
                b.setCustomerName(rs.getString("customerName"));
                b.setPhone(rs.getString("phone"));
                b.setAddress(rs.getString("address"));
                b.setDetailAddress(rs.getString("detailAddress"));
                b.setSubtotal(rs.getFloat("subtotal"));
                b.setDiscountAmount(rs.getFloat("discountAmount"));
                b.setVoucherID(rs.getObject("voucherID") != null ? rs.getInt("voucherID") : null);
                b.setVoucherCodeSnapshot(rs.getString("voucherCodeSnapshot"));
                b.setTotal(rs.getFloat("total"));
                b.setStatus(rs.getInt("status"));
                b.setPayment(rs.getInt("payment"));
                b.setDateOrder(rs.getTimestamp("dateOrder"));
                b.setDateUpdate(rs.getTimestamp("dateUpdate"));
                b.setTransactionCode(rs.getString("transactionCode"));
                list.add(b);
            }
        } catch (java.sql.SQLException e) {
            System.out.println("BillDAO getPaginated: " + e);
        }
        return list;
    }

    public int createOrder(Bill bill, List<BillDetail> details) {
        int billId = 0;
        boolean originalAutoCommit = true;
        try {
            originalAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            String sqlBill = "INSERT INTO Bill (customerID, email, customerName, phone, address, detailAddress, subtotal, discountAmount, voucherID, voucherCodeSnapshot, total, status, payment, dateOrder, dateUpdate, transactionCode) "
                           + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psBill = conn.prepareStatement(sqlBill, PreparedStatement.RETURN_GENERATED_KEYS);
            psBill.setInt(1, bill.getCustomerID());
            psBill.setString(2, bill.getEmail());
            psBill.setString(3, bill.getCustomerName());
            psBill.setString(4, bill.getPhone());
            psBill.setString(5, bill.getAddress());
            if (bill.getDetailAddress() != null) psBill.setString(6, bill.getDetailAddress()); else psBill.setNull(6, java.sql.Types.VARCHAR);
            psBill.setFloat(7, bill.getSubtotal());
            psBill.setFloat(8, bill.getDiscountAmount());
            if (bill.getVoucherID() != null) psBill.setInt(9, bill.getVoucherID()); else psBill.setNull(9, java.sql.Types.INTEGER);
            if (bill.getVoucherCodeSnapshot() != null) psBill.setString(10, bill.getVoucherCodeSnapshot()); else psBill.setNull(10, java.sql.Types.VARCHAR);
            psBill.setFloat(11, bill.getTotal());
            psBill.setInt(12, bill.getStatus());
            psBill.setInt(13, bill.getPayment());
            psBill.setTimestamp(14, bill.getDateOrder());
            if (bill.getDateUpdate() != null) psBill.setTimestamp(15, bill.getDateUpdate()); else psBill.setNull(15, java.sql.Types.TIMESTAMP);
            if (bill.getTransactionCode() != null) psBill.setString(16, bill.getTransactionCode()); else psBill.setNull(16, java.sql.Types.VARCHAR);

            int affectedRows = psBill.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rsKeys = psBill.getGeneratedKeys();
                if (rsKeys.next()) {
                    billId = rsKeys.getInt(1);
                }
            }

            if (billId <= 0) {
                throw new SQLException("Creating bill failed, no ID obtained.");
            }

            String sqlDetail = "INSERT INTO BillDetail (billID, productVariantID, productID, skuSnapshot, nameProduct, modelProduct, imgProduct, sizeLabelSnapshot, colorLabelSnapshot, priceProduct, numberOfProduct) "
                             + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
            for (BillDetail d : details) {
                psDetail.setInt(1, billId);
                if (d.getProductVariantID() != null) psDetail.setInt(2, d.getProductVariantID()); else psDetail.setNull(2, java.sql.Types.INTEGER);
                psDetail.setInt(3, d.getProductID());
                psDetail.setString(4, d.getSkuSnapshot());
                psDetail.setString(5, d.getNameProduct());
                if (d.getModelProduct() != null) psDetail.setString(6, d.getModelProduct()); else psDetail.setNull(6, java.sql.Types.VARCHAR);
                if (d.getImgProduct() != null) psDetail.setString(7, d.getImgProduct()); else psDetail.setNull(7, java.sql.Types.VARCHAR);
                psDetail.setString(8, d.getSizeLabelSnapshot());
                psDetail.setString(9, d.getColorLabelSnapshot());
                psDetail.setFloat(10, d.getPriceProduct());
                psDetail.setInt(11, d.getNumberOfProduct());
                psDetail.executeUpdate();
            }

            String sqlStock = "UPDATE ProductVariant SET quantity = quantity - ? WHERE ID = ?";
            PreparedStatement psStock = conn.prepareStatement(sqlStock);
            for (BillDetail d : details) {
                if (d.getProductVariantID() != null) {
                    psStock.setInt(1, d.getNumberOfProduct());
                    psStock.setInt(2, d.getProductVariantID());
                    psStock.executeUpdate();
                }
            }

            if (bill.getVoucherID() != null) {
                String sqlVoucher = "UPDATE Voucher SET used = used + 1 WHERE ID = ?";
                PreparedStatement psVoucher = conn.prepareStatement(sqlVoucher);
                psVoucher.setInt(1, bill.getVoucherID());
                psVoucher.executeUpdate();
            }

            String sqlCart = "DELETE FROM Cart WHERE accountID = ?";
            PreparedStatement psCart = conn.prepareStatement(sqlCart);
            psCart.setInt(1, bill.getCustomerID());
            psCart.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            System.out.println("BillDAO createOrder rollback due to: " + e);
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                System.out.println("Rollback fail: " + ex);
            }
            billId = 0;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(originalAutoCommit);
                }
            } catch (SQLException ex) {
                System.out.println("Reset autocommit fail: " + ex);
            }
        }
        return billId;
    }
}