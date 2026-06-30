package DAO;

import DBConnection.DBConnection;
import Model.BlogComment;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class BlogCommentDAO {

    public List<BlogComment> getAll(int limit, int offset, Integer blogPostId, String keyword, Integer accountId, Integer status) {
        List<BlogComment> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogComment WHERE 1=1 ";
        if (blogPostId != null && blogPostId > 0) {
            sql += "AND blogPostID = ? ";
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "AND body LIKE ? ";
        }
        if (accountId != null && accountId > 0) {
            sql += "AND accountID = ? ";
        }
        if (status != null && status != -1) {
            sql += "AND status = ? ";
        }
        sql += "ORDER BY datePost DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            int pIndex = 1;
            if (blogPostId != null && blogPostId > 0) {
                st.setInt(pIndex++, blogPostId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(pIndex++, "%" + keyword.trim() + "%");
            }
            if (accountId != null && accountId > 0) {
                st.setInt(pIndex++, accountId);
            }
            if (status != null && status != -1) {
                st.setInt(pIndex++, status);
            }
            st.setInt(pIndex++, offset);
            st.setInt(pIndex++, limit);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(extractFromResultSet(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("BlogCommentDAO getAll: " + e);
        }
        return list;
    }

    public List<BlogComment> getByBlogPostID(int blogPostID) {
        List<BlogComment> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogComment WHERE blogPostID = ? ORDER BY datePost DESC";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, blogPostID);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(extractFromResultSet(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("BlogCommentDAO getByBlogPostID: " + e);
        }
        return list;
    }

    public List<BlogComment> getActiveByBlogPostID(int blogPostID) {
        List<BlogComment> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogComment WHERE blogPostID = ? AND status = 1 ORDER BY datePost DESC";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, blogPostID);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(extractFromResultSet(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("BlogCommentDAO getActiveByBlogPostID: " + e);
        }
        return list;
    }

    public int countAll(Integer blogPostId, String keyword, Integer accountId, Integer status) {
        String sql = "SELECT COUNT(*) FROM BlogComment WHERE 1=1 ";
        if (blogPostId != null && blogPostId > 0) {
            sql += " AND blogPostID = ?";
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND body LIKE ?";
        }
        if (accountId != null && accountId > 0) {
            sql += " AND accountID = ?";
        }
        if (status != null && status != -1) {
            sql += " AND status = ?";
        }
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            int pIndex = 1;
            if (blogPostId != null && blogPostId > 0) {
                st.setInt(pIndex++, blogPostId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(pIndex++, "%" + keyword.trim() + "%");
            }
            if (accountId != null && accountId > 0) {
                st.setInt(pIndex++, accountId);
            }
            if (status != null && status != -1) {
                st.setInt(pIndex++, status);
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("BlogCommentDAO countAll: " + e);
        }
        return 0;
    }

    public BlogComment getByID(int id) {
        String sql = "SELECT * FROM BlogComment WHERE ID = ?";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return extractFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("BlogCommentDAO getByID: " + e);
        }
        return null;
    }

    public int insert(BlogComment comment) {
        String sql = "INSERT INTO BlogComment (blogPostID, accountID, guestName, guestEmail, body, status, parentCommentID, datePost) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, comment.getBlogPostID());
            if (comment.getAccountID() != null) st.setInt(2, comment.getAccountID());
            else st.setNull(2, Types.INTEGER);
            st.setString(3, comment.getGuestName());
            st.setString(4, comment.getGuestEmail());
            st.setString(5, comment.getBody());
            st.setInt(6, comment.getStatus());
            if (comment.getParentCommentID() != null) st.setInt(7, comment.getParentCommentID());
            else st.setNull(7, Types.INTEGER);
            st.setTimestamp(8, comment.getDatePost());
            
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("BlogCommentDAO insert: " + e);
        }
        return 0;
    }

    public int updateStatus(int id, int status) {
        String sql = "UPDATE BlogComment SET status = ?, dateUpdate = GETDATE() WHERE ID = ?";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, status);
            st.setInt(2, id);
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("BlogCommentDAO updateStatus: " + e);
        }
        return 0;
    }

    public int delete(int id) {
        String sql = "{CALL sp_DeleteBlogComment(?, NULL)}";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareCall(sql)) {
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("BlogCommentDAO delete (SP): " + e);
        }
        return 0;
    }

    public int updateByUser(int id, int accountId, String body) {
        String sql = "UPDATE BlogComment SET body = ?, dateUpdate = GETDATE() WHERE ID = ? AND accountID = ?";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, body);
            st.setInt(2, id);
            st.setInt(3, accountId);
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("BlogCommentDAO updateByUser: " + e);
        }
        return 0;
    }

    public int deleteByUser(int id, int accountId) {
        String sql = "{CALL sp_DeleteBlogComment(?, ?)}";
        try (Connection conn = DBConnection.connect();
             PreparedStatement st = conn.prepareCall(sql)) {
            st.setInt(1, id);
            st.setInt(2, accountId);
            return st.executeUpdate();
        } catch (Exception e) {
            System.out.println("BlogCommentDAO deleteByUser (SP): " + e);
        }
        return 0;
    }

    private BlogComment extractFromResultSet(ResultSet rs) throws Exception {
        BlogComment c = new BlogComment();
        c.setID(rs.getInt("ID"));
        c.setBlogPostID(rs.getInt("blogPostID"));
        int accId = rs.getInt("accountID");
        c.setAccountID(rs.wasNull() ? null : accId);
        c.setGuestName(rs.getString("guestName"));
        c.setGuestEmail(rs.getString("guestEmail"));
        c.setBody(rs.getString("body"));
        c.setStatus(rs.getInt("status"));
        int parentId = rs.getInt("parentCommentID");
        c.setParentCommentID(rs.wasNull() ? null : parentId);
        c.setDatePost(rs.getTimestamp("datePost"));
        c.setDateUpdate(rs.getTimestamp("dateUpdate"));
        return c;
    }
}
