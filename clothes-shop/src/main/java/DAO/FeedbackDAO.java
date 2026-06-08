/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBConnection.DBConnection;
import Model.Feedback;
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
public class FeedbackDAO {

    private Connection conn;

    public FeedbackDAO() {
        try {
            conn = DBConnection.connect();
        } catch (Exception e) {
//            handle error here
            conn = null;
        }
    }

    public List<Feedback> allFeedbackByProduct(int idProduct) {
        String sql = "select * from feedback where productId=? order by id desc";
        List<Feedback> feebacks = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, idProduct);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                feebacks.add(this.getFeedback(result));
            }
        } catch (SQLException er) {
            System.out.println("Get all feedback: " + er);
        }
        return feebacks;
    }

    public List<Feedback> allFeedbackActiveByProduct(int idProduct) {
        String sql = "select * from feedback where productId=? and status=1 order by id desc";
        List<Feedback> feebacks = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, idProduct);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                feebacks.add(this.getFeedback(result));
            }
        } catch (SQLException er) {
            System.out.println("Get active feedback: " + er);
        }
        return feebacks;
    }

    public boolean hasUserReviewedProduct(int userId, int productId) {
        String sql = "SELECT 1 FROM feedback WHERE userId = ? AND productId = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, userId);
            st.setInt(2, productId);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("hasUserReviewedProduct: " + e);
        }
        return false;
    }

    public int insert(Feedback f) {
        String sql = "INSERT INTO feedback (userId, productId, comment, star, status, datePost) VALUES (?,?,?,?,?,?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, f.getUserID());
            st.setInt(2, f.getProductID());
            st.setString(3, f.getFeedback());
            st.setInt(4, f.getStar());
            st.setInt(5, f.getStatus());
            st.setTimestamp(6, f.getDatePost());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("FeedbackDAO.insert: " + e);
        }
        return 0;
    }

    public int updateUserFeedback(int userId, int productId, int star, String comment) {
        String sql = "UPDATE feedback SET star = ?, comment = ?, dateUpdate = GETDATE() WHERE userId = ? AND productId = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, star);
            st.setString(2, comment);
            st.setInt(3, userId);
            st.setInt(4, productId);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateUserFeedback: " + e);
        }
        return 0;
    }

    public List<Feedback> findByUser(int userId) {
        String sql = "SELECT f.*, p.name AS productName, p.mainImg AS productImg FROM feedback f "
                + "JOIN Product p ON p.ID = f.productId WHERE f.userId = ? ORDER BY f.id DESC";
        List<Feedback> list = new ArrayList<>();
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Feedback fb = getFeedback(rs);
                if (fb != null) {
                    fb.setProductName(rs.getString("productName"));
                    fb.setProductImg(rs.getString("productImg"));
                    list.add(fb);
                }
            }
        } catch (SQLException e) {
            System.out.println("findByUser: " + e);
        }
        return list;
    }

    public List<Feedback> getAll(int limit, int offset, Integer productId, String keyword) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, p.name AS productName FROM feedback f "
                   + "JOIN Product p ON p.ID = f.productId WHERE 1=1 ";
        if (productId != null && productId > 0) {
            sql += "AND f.productId = ? ";
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "AND f.comment LIKE ? ";
        }
        sql += "ORDER BY f.id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            int pIndex = 1;
            if (productId != null && productId > 0) {
                st.setInt(pIndex++, productId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(pIndex++, "%" + keyword.trim() + "%");
            }
            st.setInt(pIndex++, offset);
            st.setInt(pIndex++, limit);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Feedback fb = getFeedback(rs);
                if (fb != null) {
                    fb.setProductName(rs.getString("productName"));
                    list.add(fb);
                }
            }
        } catch (Exception e) {
            System.out.println("FeedbackDAO getAll: " + e);
        }
        return list;
    }

    public int countAll(Integer productId, String keyword) {
        String sql = "SELECT COUNT(*) FROM feedback WHERE 1=1 ";
        if (productId != null && productId > 0) {
            sql += " AND productId = ?";
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND comment LIKE ?";
        }
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            int pIndex = 1;
            if (productId != null && productId > 0) {
                st.setInt(pIndex++, productId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(pIndex++, "%" + keyword.trim() + "%");
            }
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.out.println("FeedbackDAO countAll: " + e);
        }
        return 0;
    }

    public int updateStatus(int id, int status) {
        String sql = "UPDATE feedback SET status = ?, dateUpdate = GETDATE() WHERE id = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, status);
            st.setInt(2, id);
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("FeedbackDAO updateStatus: " + e);
        }
        return 0;
    }

    public int delete(int id) {
        String sql = "DELETE FROM feedback WHERE id = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("FeedbackDAO delete: " + e);
        }
        return 0;
    }

    public Feedback getFeedback(ResultSet result) {
        try {
            int id = result.getInt("id");
            int userId = result.getInt("userId");
            int productId = result.getInt("productId");
            String comment = result.getString("comment");
            int status = result.getInt("status");
            int star = result.getInt("star");
            Timestamp datePost = result.getTimestamp("datePost");
            Timestamp dateUpdate = result.getTimestamp("dateUpdate");
            Feedback f = new Feedback(id, userId, productId, comment, star, status, datePost, dateUpdate);
            return f;
        } catch (Exception e) {
            System.out.println("Get feedback: " + e);
        }
        return null;
    }
}
