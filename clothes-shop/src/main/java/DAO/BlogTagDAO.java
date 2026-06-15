package DAO;

import DBConnection.DBConnection;
import Model.BlogTag;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BlogTagDAO {
    private static final Logger LOG = Logger.getLogger(BlogTagDAO.class.getName());

    public BlogTag getTagBySlug(String slug) {
        String sql = "SELECT * FROM BlogTag WHERE slug = ?";
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new BlogTag(rs.getInt("ID"), rs.getString("name"), rs.getString("slug"));
                }
            }
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "getTagBySlug", ex);
        }
        return null;
    }

    public BlogTag getOrCreateTag(String name) {
        String slug = toSlug(name);
        BlogTag existing = getTagBySlug(slug);
        if (existing != null) {
            return existing;
        }

        String sql = "INSERT INTO BlogTag (name, slug) VALUES (?, ?)";
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name.trim());
            ps.setString(2, slug);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return new BlogTag(rs.getInt(1), name.trim(), slug);
                    }
                }
            }
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "getOrCreateTag", ex);
        }
        return null;
    }

    public void updatePostTags(int postId, List<Integer> tagIds) {
        String deleteSql = "DELETE FROM BlogPostTag WHERE blogPostID = ?";
        String insertSql = "INSERT INTO BlogPostTag (blogPostID, blogTagID) VALUES (?, ?)";

        try (Connection conn = DBConnection.connect()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psDel = conn.prepareStatement(deleteSql)) {
                psDel.setInt(1, postId);
                psDel.executeUpdate();
            }

            if (tagIds != null && !tagIds.isEmpty()) {
                try (PreparedStatement psIns = conn.prepareStatement(insertSql)) {
                    for (Integer tagId : tagIds) {
                        psIns.setInt(1, postId);
                        psIns.setInt(2, tagId);
                        psIns.addBatch();
                    }
                    psIns.executeBatch();
                }
            }
            conn.commit();
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "updatePostTags", ex);
        }
    }

    public List<BlogTag> getTagsByPostId(int postId) {
        List<BlogTag> list = new ArrayList<>();
        String sql = "SELECT t.* FROM BlogTag t JOIN BlogPostTag pt ON t.ID = pt.blogTagID WHERE pt.blogPostID = ?";
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new BlogTag(rs.getInt("ID"), rs.getString("name"), rs.getString("slug")));
                }
            }
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "getTagsByPostId", ex);
        }
        return list;
    }

    public List<BlogTag> getAllTags() {
        List<BlogTag> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogTag ORDER BY name ASC";
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new BlogTag(rs.getInt("ID"), rs.getString("name"), rs.getString("slug")));
            }
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "getAllTags", ex);
        }
        return list;
    }

    public int countAllTags(String keyword) {
        String sql = "SELECT COUNT(*) FROM BlogTag WHERE 1=1 ";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "AND name LIKE ? ";
        }
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(1, "%" + keyword.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "countAllTags", ex);
        }
        return 0;
    }

    public List<BlogTag> getAllTagsPaginated(int limit, int offset, String keyword) {
        List<BlogTag> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogTag WHERE 1=1 ";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "AND name LIKE ? ";
        }
        sql += "ORDER BY name ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int pIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(pIndex++, "%" + keyword.trim() + "%");
            }
            ps.setInt(pIndex++, offset);
            ps.setInt(pIndex++, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new BlogTag(rs.getInt("ID"), rs.getString("name"), rs.getString("slug")));
                }
            }
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "getAllTagsPaginated", ex);
        }
        return list;
    }

    public boolean updateTag(BlogTag tag) {
        String sql = "UPDATE BlogTag SET name = ?, slug = ? WHERE ID = ?";
        try (Connection conn = DBConnection.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tag.getName());
            ps.setString(2, tag.getSlug());
            ps.setInt(3, tag.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "updateTag", ex);
        }
        return false;
    }

    public boolean deleteTag(int id) {
        String sqlDeleteLinks = "DELETE FROM BlogPostTag WHERE blogTagID = ?";
        String sqlDeleteTag = "DELETE FROM BlogTag WHERE ID = ?";
        try (Connection conn = DBConnection.connect()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psDelLinks = conn.prepareStatement(sqlDeleteLinks);
                 PreparedStatement psDelTag = conn.prepareStatement(sqlDeleteTag)) {
                psDelLinks.setInt(1, id);
                psDelLinks.executeUpdate();

                psDelTag.setInt(1, id);
                int affected = psDelTag.executeUpdate();
                conn.commit();
                return affected > 0;
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (Exception ex) {
            LOG.log(Level.SEVERE, "deleteTag", ex);
        }
        return false;
    }

    public static String toSlug(String input) {
        if (input == null || input.isEmpty()) return "";
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        String slug = normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        slug = slug.toLowerCase();
        slug = slug.replaceAll("[^a-z0-9]+", "-");
        slug = slug.replaceAll("^-|-$", "");
        return slug;
    }
}
