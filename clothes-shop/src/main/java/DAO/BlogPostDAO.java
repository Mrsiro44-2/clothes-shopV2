package DAO;

import Model.BlogPost;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class BlogPostDAO {

    private final Connection conn;

    public BlogPostDAO() {
        conn = DBConnection.DBConnection.connect();
    }

    private static final String PUBLISHED_SELECT = "SELECT p.*, c.name AS categoryName, a.fullname AS authorName "
            + "FROM BlogPost p "
            + "LEFT JOIN BlogCategory c ON c.ID = p.blogCategoryID AND c.status = 1 "
            + "JOIN [Account] a ON a.ID = p.authorAccountID AND a.status = 1 ";

    private static final String PUBLISHED_WHERE = "WHERE p.status = 1 AND p.publishedAt IS NOT NULL "
            + "AND p.publishedAt <= GETDATE() ";


    public List<BlogPost> searchPublished(String keyword, Integer categoryId, List<String> tagSlugs, int offset, int limit) {
        List<BlogPost> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(PUBLISHED_SELECT);
        sql.append(PUBLISHED_WHERE);
        List<Object> params = new ArrayList<>();
        appendFilters(sql, params, keyword, categoryId, tagSlugs);
        sql.append("ORDER BY p.isFeatured DESC, p.publishedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try ( PreparedStatement st = conn.prepareStatement(sql.toString())) {
            int idx = bindFilters(st, params);
            st.setInt(idx++, Math.max(0, offset));
            st.setInt(idx, Math.max(1, limit));
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.searchPublished: " + e);
        }
        return list;
    }

    public int countPublished(String keyword, Integer categoryId, List<String> tagSlugs) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM BlogPost p "
                + "LEFT JOIN BlogCategory c ON c.ID = p.blogCategoryID AND c.status = 1 JOIN [Account] a ON a.ID = p.authorAccountID AND a.status = 1 ");
        sql.append(PUBLISHED_WHERE);
        List<Object> params = new ArrayList<>();
        appendFilters(sql, params, keyword, categoryId, tagSlugs);
        try ( PreparedStatement st = conn.prepareStatement(sql.toString())) {
            bindFilters(st, params);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.countPublished: " + e);
        }
        return 0;
    }

    private void appendFilters(StringBuilder sql, List<Object> params, String keyword, Integer categoryId, List<String> tagSlugs) {
        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.blogCategoryID = ? ");
            params.add(categoryId);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.title LIKE ? OR p.excerpt LIKE ? OR ISNULL(c.name,'') LIKE ?) ");
            String q = "%" + keyword.trim() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
        }
        if (tagSlugs != null && !tagSlugs.isEmpty()) {
            sql.append("AND p.ID IN (SELECT pt.blogPostID FROM BlogPostTag pt JOIN BlogTag t ON pt.blogTagID = t.ID WHERE t.slug IN (");
            for (int i = 0; i < tagSlugs.size(); i++) {
                sql.append("?");
                if (i < tagSlugs.size() - 1) sql.append(",");
                params.add(tagSlugs.get(i));
            }
            sql.append(")) ");
        }
    }

    private int bindFilters(PreparedStatement st, List<Object> params) throws SQLException {
        int idx = 1;
        for (Object p : params) {
            st.setObject(idx++, p);
        }
        return idx;
    }

    public BlogPost findPublishedBySlug(String slug) {
        String sql = "SELECT p.*, c.name AS categoryName, a.fullname AS authorName "
                + "FROM BlogPost p "
                + "LEFT JOIN BlogCategory c ON c.ID = p.blogCategoryID AND c.status = 1 "
                + "JOIN [Account] a ON a.ID = p.authorAccountID AND a.status = 1 "
                + "WHERE p.slug = ? AND p.status = 1 AND p.publishedAt IS NOT NULL AND p.publishedAt <= GETDATE()";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, slug);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.findPublishedBySlug: " + e);
        }
        return null;
    }

    public void incrementView(int postId) {
        String sql = "UPDATE BlogPost SET viewCount = viewCount + 1 WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, postId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.incrementView: " + e);
        }
    }

    public List<BlogPost> getRelatedPosts(int currentPostID, Integer categoryId, int limit) {
        List<BlogPost> list = new ArrayList<>();
        String sql = PUBLISHED_SELECT + PUBLISHED_WHERE 
                   + "AND p.ID != ? "
                   + (categoryId != null ? "AND p.blogCategoryID = ? " : "")
                   + "ORDER BY p.publishedAt DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            int i = 1;
            st.setInt(i++, currentPostID);
            if (categoryId != null) {
                st.setInt(i++, categoryId);
            }
            st.setInt(i++, limit);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.getRelatedPosts: " + e);
        }
        
        // If list is smaller than limit, fill it up with other published posts
        if (list.size() < limit) {
            String fillSql = PUBLISHED_SELECT + PUBLISHED_WHERE
                           + "AND p.ID != ? "
                           + (categoryId != null ? "AND p.blogCategoryID != ? " : "")
                           + "ORDER BY p.publishedAt DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
            try (PreparedStatement st = conn.prepareStatement(fillSql)) {
                int i = 1;
                st.setInt(i++, currentPostID);
                if (categoryId != null) {
                    st.setInt(i++, categoryId);
                }
                st.setInt(i++, limit - list.size());
                try (ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        list.add(map(rs));
                    }
                }
            } catch (SQLException e) {
                System.out.println("BlogPostDAO.getRelatedPosts fallback: " + e);
            }
        }
        return list;
    }

    /** Admin: toàn bộ bài (nháp + đã đăng). */
    public List<BlogPost> listAllForAdmin() {
        List<BlogPost> list = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS categoryName, a.fullname AS authorName "
                + "FROM BlogPost p "
                + "LEFT JOIN BlogCategory c ON c.ID = p.blogCategoryID "
                + "JOIN [Account] a ON a.ID = p.authorAccountID "
                + "ORDER BY p.ID DESC";
        try ( PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.listAllForAdmin: " + e);
        }
        return list;
    }

    public List<BlogPost> listAllForAdmin(String keyword, int status, int offset, int limit) {
        List<BlogPost> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.name AS categoryName, a.fullname AS authorName "
                + "FROM BlogPost p "
                + "LEFT JOIN BlogCategory c ON c.ID = p.blogCategoryID "
                + "JOIN [Account] a ON a.ID = p.authorAccountID WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status >= 0) {
            sql.append("AND p.status = ? ");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.title LIKE ? OR p.slug LIKE ?) ");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        sql.append("ORDER BY p.ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try ( PreparedStatement st = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object p : params) {
                st.setObject(idx++, p);
            }
            st.setInt(idx++, offset);
            st.setInt(idx, limit);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.listAllForAdmin (paginated): " + e);
        }
        return list;
    }

    public int countAllForAdmin(String keyword, int status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM BlogPost p WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status >= 0) {
            sql.append("AND p.status = ? ");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.title LIKE ? OR p.slug LIKE ?) ");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        try ( PreparedStatement st = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object p : params) {
                st.setObject(idx++, p);
            }
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.countAllForAdmin: " + e);
        }
        return 0;
    }

    public int insert(BlogPost p) {
        String sql = "INSERT INTO BlogPost (blogCategoryID, authorAccountID, title, slug, excerpt, contentHtml, coverImg, status, isFeatured, publishedAt, "
                + "seoTitle, seoDescription, readingMinutes) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try ( PreparedStatement st = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            int i = 1;
            if (p.getBlogCategoryID() != null) {
                st.setInt(i++, p.getBlogCategoryID());
            } else {
                st.setNull(i++, java.sql.Types.INTEGER);
            }
            st.setInt(i++, p.getAuthorAccountID());
            st.setString(i++, p.getTitle());
            st.setString(i++, p.getSlug());
            st.setString(i++, p.getExcerpt());
            st.setString(i++, p.getContentHtml());
            st.setString(i++, p.getCoverImg());
            st.setInt(i++, p.getStatus());
            st.setBoolean(i++, p.isFeatured());
            st.setTimestamp(i++, p.getPublishedAt());
            st.setString(i++, p.getSeoTitle());
            st.setString(i++, p.getSeoDescription());
            if (p.getReadingMinutes() != null) {
                st.setInt(i++, p.getReadingMinutes());
            } else {
                st.setNull(i++, java.sql.Types.SMALLINT);
            }
            if (st.executeUpdate() > 0) {
                try ( ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.insert: " + e);
        }
        return 0;
    }

    public BlogPost findById(int id) {
        String sql = "SELECT p.*, c.name AS categoryName, a.fullname AS authorName "
                + "FROM BlogPost p "
                + "LEFT JOIN BlogCategory c ON c.ID = p.blogCategoryID "
                + "JOIN [Account] a ON a.ID = p.authorAccountID "
                + "WHERE p.ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.findById: " + e);
        }
        return null;
    }

    public int update(BlogPost p) {
        String sql = "UPDATE BlogPost SET blogCategoryID = ?, title = ?, slug = ?, excerpt = ?, contentHtml = ?, coverImg = ?, status = ?, isFeatured = ?, publishedAt = ?, dateUpdated = SYSUTCDATETIME() WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            int i = 1;
            if (p.getBlogCategoryID() != null) {
                st.setInt(i++, p.getBlogCategoryID());
            } else {
                st.setNull(i++, java.sql.Types.INTEGER);
            }
            st.setString(i++, p.getTitle());
            st.setString(i++, p.getSlug());
            st.setString(i++, p.getExcerpt());
            st.setString(i++, p.getContentHtml());
            st.setString(i++, p.getCoverImg());
            st.setInt(i++, p.getStatus());
            st.setBoolean(i++, p.isFeatured());
            st.setTimestamp(i++, p.getPublishedAt());
            st.setInt(i++, p.getID());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.update: " + e);
        }
        return 0;
    }

    public int delete(int id) {
        String sql = "DELETE FROM BlogPost WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("BlogPostDAO.delete: " + e);
        }
        return 0;
    }

    private BlogPost map(ResultSet rs) throws SQLException {
        BlogPost p = new BlogPost();
        p.setID(rs.getInt("ID"));
        int cid = rs.getInt("blogCategoryID");
        if (rs.wasNull()) {
            p.setBlogCategoryID(null);
        } else {
            p.setBlogCategoryID(cid);
        }
        p.setAuthorAccountID(rs.getInt("authorAccountID"));
        p.setTitle(rs.getString("title"));
        p.setSlug(rs.getString("slug"));
        p.setExcerpt(rs.getString("excerpt"));
        p.setContentHtml(rs.getString("contentHtml"));
        p.setCoverImg(rs.getString("coverImg"));
        p.setStatus(rs.getInt("status"));
        p.setFeatured(rs.getBoolean("isFeatured"));
        p.setPublishedAt(rs.getTimestamp("publishedAt"));
        p.setDateCreated(rs.getTimestamp("dateCreated"));
        p.setDateUpdated(rs.getTimestamp("dateUpdated"));
        p.setViewCount(rs.getInt("viewCount"));
        p.setSeoTitle(rs.getString("seoTitle"));
        p.setSeoDescription(rs.getString("seoDescription"));
        int rm = rs.getInt("readingMinutes");
        if (rs.wasNull()) {
            p.setReadingMinutes(null);
        } else {
            p.setReadingMinutes(rm);
        }
        p.setCategoryName(rs.getString("categoryName"));
        p.setAuthorName(rs.getString("authorName"));
        return p;
    }
}
