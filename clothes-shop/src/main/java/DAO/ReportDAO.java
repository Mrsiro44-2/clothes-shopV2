package DAO;

import DBConnection.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    public List<Map<String, Object>> getBestSellingProducts(int limit, String startDate, String endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) bd.productID, bd.nameProduct, bd.imgProduct, SUM(bd.numberOfProduct) as totalSold, SUM(bd.priceProduct * bd.numberOfProduct) as totalRevenue " +
                     "FROM BillDetail bd " +
                     "JOIN Bill b ON bd.billID = b.id " +
                     "WHERE b.status = 3 " +
                     "AND (CAST(b.dateOrder AS DATE) >= CAST(? AS DATE) OR ? IS NULL) " +
                     "AND (CAST(b.dateOrder AS DATE) <= CAST(? AS DATE) OR ? IS NULL) " +
                     "GROUP BY bd.productID, bd.nameProduct, bd.imgProduct " +
                     "ORDER BY totalSold DESC";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, limit);
            st.setString(2, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(3, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(4, endDate != null && !endDate.isEmpty() ? endDate : null);
            st.setString(5, endDate != null && !endDate.isEmpty() ? endDate : null);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("productID", rs.getInt("productID"));
                    map.put("nameProduct", rs.getString("nameProduct"));
                    map.put("imgProduct", rs.getString("imgProduct"));
                    map.put("totalSold", rs.getInt("totalSold"));
                    map.put("totalRevenue", rs.getDouble("totalRevenue"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            System.out.println("ReportDAO getBestSellingProducts: " + e);
        }
        return list;
    }

    public List<Map<String, Object>> getWorstSellingProducts(int limit, String startDate, String endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) bd.productID, bd.nameProduct, bd.imgProduct, SUM(bd.numberOfProduct) as totalSold, SUM(bd.priceProduct * bd.numberOfProduct) as totalRevenue " +
                     "FROM BillDetail bd " +
                     "JOIN Bill b ON bd.billID = b.id " +
                     "WHERE b.status = 3 " +
                     "AND (CAST(b.dateOrder AS DATE) >= CAST(? AS DATE) OR ? IS NULL) " +
                     "AND (CAST(b.dateOrder AS DATE) <= CAST(? AS DATE) OR ? IS NULL) " +
                     "GROUP BY bd.productID, bd.nameProduct, bd.imgProduct " +
                     "ORDER BY totalSold ASC";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, limit);
            st.setString(2, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(3, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(4, endDate != null && !endDate.isEmpty() ? endDate : null);
            st.setString(5, endDate != null && !endDate.isEmpty() ? endDate : null);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("productID", rs.getInt("productID"));
                    map.put("nameProduct", rs.getString("nameProduct"));
                    map.put("imgProduct", rs.getString("imgProduct"));
                    map.put("totalSold", rs.getInt("totalSold"));
                    map.put("totalRevenue", rs.getDouble("totalRevenue"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            System.out.println("ReportDAO getWorstSellingProducts: " + e);
        }
        return list;
    }

    public List<Map<String, Object>> getTopCustomers(int limit, String startDate, String endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) b.customerID, b.customerName, b.email, SUM(b.total) as totalSpent, COUNT(b.id) as totalOrders " +
                     "FROM Bill b " +
                     "WHERE b.status = 3 " +
                     "AND (CAST(b.dateOrder AS DATE) >= CAST(? AS DATE) OR ? IS NULL) " +
                     "AND (CAST(b.dateOrder AS DATE) <= CAST(? AS DATE) OR ? IS NULL) " +
                     "GROUP BY b.customerID, b.customerName, b.email " +
                     "ORDER BY totalSpent DESC";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, limit);
            st.setString(2, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(3, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(4, endDate != null && !endDate.isEmpty() ? endDate : null);
            st.setString(5, endDate != null && !endDate.isEmpty() ? endDate : null);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("customerID", rs.getInt("customerID"));
                    map.put("customerName", rs.getString("customerName"));
                    map.put("email", rs.getString("email"));
                    map.put("totalSpent", rs.getDouble("totalSpent"));
                    map.put("totalOrders", rs.getInt("totalOrders"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            System.out.println("ReportDAO getTopCustomers: " + e);
        }
        return list;
    }

    public Map<String, Object> getRevenueSummary(String startDate, String endDate) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("totalRevenue", 0.0);
        map.put("totalOrders", 0);
        map.put("completedOrders", 0);
        map.put("pendingOrders", 0);
        map.put("cancelledOrders", 0);
        map.put("vouchersUsed", 0);
        map.put("voucherDiscountTotal", 0.0);
        
        String sql = "SELECT status, COUNT(*) as cnt, SUM(total) as rev " +
                     "FROM Bill " +
                     "WHERE (CAST(dateOrder AS DATE) >= CAST(? AS DATE) OR ? IS NULL) " +
                     "AND (CAST(dateOrder AS DATE) <= CAST(? AS DATE) OR ? IS NULL) " +
                     "GROUP BY status";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(2, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(3, endDate != null && !endDate.isEmpty() ? endDate : null);
            st.setString(4, endDate != null && !endDate.isEmpty() ? endDate : null);
            
            try (ResultSet rs = st.executeQuery()) {
                int totalOrders = 0;
                while (rs.next()) {
                    int status = rs.getInt("status");
                    int cnt = rs.getInt("cnt");
                    double rev = rs.getDouble("rev");
                    
                    totalOrders += cnt;
                    
                    if (status == 3) {
                        map.put("completedOrders", cnt);
                        map.put("totalRevenue", rev);
                    } else if (status == 0) {
                        map.put("pendingOrders", cnt);
                    } else if (status == 2) {
                        map.put("cancelledOrders", cnt);
                    }
                }
                map.put("totalOrders", totalOrders);
            }

            // Query Voucher stats
            String sqlVoucher = "SELECT COUNT(*) as usedCount, SUM(discountAmount) as discountSum " +
                                "FROM Bill " +
                                "WHERE status = 3 AND voucherID IS NOT NULL " +
                                "AND (CAST(dateOrder AS DATE) >= CAST(? AS DATE) OR ? IS NULL) " +
                                "AND (CAST(dateOrder AS DATE) <= CAST(? AS DATE) OR ? IS NULL)";
            try (PreparedStatement stV = conn.prepareStatement(sqlVoucher)) {
                stV.setString(1, startDate != null && !startDate.isEmpty() ? startDate : null);
                stV.setString(2, startDate != null && !startDate.isEmpty() ? startDate : null);
                stV.setString(3, endDate != null && !endDate.isEmpty() ? endDate : null);
                stV.setString(4, endDate != null && !endDate.isEmpty() ? endDate : null);
                try (ResultSet rsV = stV.executeQuery()) {
                    if (rsV.next()) {
                        map.put("vouchersUsed", rsV.getInt("usedCount"));
                        map.put("voucherDiscountTotal", rsV.getDouble("discountSum"));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("ReportDAO getRevenueSummary: " + e);
        }
        return map;
    }

    public List<Map<String, Object>> getRevenueOverTime(String startDate, String endDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT CAST(dateOrder AS DATE) as orderDate, SUM(total) as dailyRevenue " +
                     "FROM Bill " +
                     "WHERE status = 3 " +
                     "AND (CAST(dateOrder AS DATE) >= CAST(? AS DATE) OR ? IS NULL) " +
                     "AND (CAST(dateOrder AS DATE) <= CAST(? AS DATE) OR ? IS NULL) " +
                     "GROUP BY CAST(dateOrder AS DATE) " +
                     "ORDER BY orderDate ASC";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(2, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(3, endDate != null && !endDate.isEmpty() ? endDate : null);
            st.setString(4, endDate != null && !endDate.isEmpty() ? endDate : null);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("date", rs.getString("orderDate"));
                    map.put("revenue", rs.getDouble("dailyRevenue"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            System.out.println("ReportDAO getRevenueOverTime: " + e);
        }
        return list;
    }

    public Map<String, Object> getInteractionSummary(String startDate, String endDate) {
        Map<String, Object> map = new LinkedHashMap<>();
        int totalFeedbacks = 0;
        int totalComments = 0;
        double avgStar = 0.0;
        
        String sqlFeedbacks = "SELECT COUNT(*) as cnt, AVG(CAST(star AS FLOAT)) as avgS FROM feedback " +
                              "WHERE (CAST(datePost AS DATE) >= CAST(? AS DATE) OR ? IS NULL) " +
                              "AND (CAST(datePost AS DATE) <= CAST(? AS DATE) OR ? IS NULL)";
        
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sqlFeedbacks)) {
            st.setString(1, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(2, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(3, endDate != null && !endDate.isEmpty() ? endDate : null);
            st.setString(4, endDate != null && !endDate.isEmpty() ? endDate : null);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    totalFeedbacks = rs.getInt("cnt");
                    avgStar = rs.getDouble("avgS");
                }
            }
        } catch (Exception e) {}
        
        String sqlComments = "SELECT COUNT(*) FROM BlogComment " +
                             "WHERE (CAST(datePost AS DATE) >= CAST(? AS DATE) OR ? IS NULL) " +
                             "AND (CAST(datePost AS DATE) <= CAST(? AS DATE) OR ? IS NULL)";
        
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sqlComments)) {
            st.setString(1, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(2, startDate != null && !startDate.isEmpty() ? startDate : null);
            st.setString(3, endDate != null && !endDate.isEmpty() ? endDate : null);
            st.setString(4, endDate != null && !endDate.isEmpty() ? endDate : null);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    totalComments = rs.getInt(1);
                }
            }
        } catch (Exception e) {}
        
        map.put("totalFeedbacks", totalFeedbacks);
        map.put("avgStar", avgStar);
        map.put("totalComments", totalComments);
        return map;
    }
}
