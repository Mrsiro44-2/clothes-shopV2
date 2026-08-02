package DAO;

import Model.BlogCategory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BlogCategoryDAO {

    private final Connection conn;

    public BlogCategoryDAO() {
        conn = DBConnection.DBConnection.connect();
    }

    public List<BlogCategory> listActive() {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogCategory WHERE status = 1 ORDER BY sortOrder, ID";
        try ( PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                BlogCategory c = new BlogCategory();
                c.setID(rs.getInt("ID"));
                c.setName(rs.getString("name"));
                c.setSlug(rs.getString("slug"));
                c.setDescription(rs.getString("description"));
                c.setCoverImg(rs.getString("coverImg"));
                c.setSortOrder(rs.getInt("sortOrder"));
                c.setStatus(rs.getInt("status"));
                c.setDatePost(rs.getTimestamp("datePost"));
                c.setDateUpdate(rs.getTimestamp("dateUpdate"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("BlogCategoryDAO.listActive: " + e);
        }
        return list;
    }
    public List<BlogCategory> listAll() {
        List<BlogCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogCategory ORDER BY sortOrder, ID DESC";
        try ( PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            System.out.println("BlogCategoryDAO.listAll: " + e);
        }
        return list;
    }

    public List<BlogCategory> listAllPaginated(String keyword, int status, int offset, int limit) {
        List<BlogCategory> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM BlogCategory WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status >= 0) {
            sql.append("AND status = ? ");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR slug LIKE ?) ");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        sql.append("ORDER BY sortOrder, ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
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
            System.out.println("BlogCategoryDAO.listAllPaginated: " + e);
        }
        return list;
    }

    public int countAll(String keyword, int status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM BlogCategory WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (status >= 0) {
            sql.append("AND status = ? ");
            params.add(status);
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR slug LIKE ?) ");
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
            System.out.println("BlogCategoryDAO.countAll: " + e);
        }
        return 0;
    }

    public BlogCategory findById(int id) {
        String sql = "SELECT * FROM BlogCategory WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            System.out.println("BlogCategoryDAO.findById: " + e);
        }
        return null;
    }

    public int insert(BlogCategory c) {
        String sql = "INSERT INTO BlogCategory (name, slug, description, coverImg, sortOrder, status, datePost) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, c.getName());
            st.setString(2, c.getSlug());
            st.setString(3, c.getDescription());
            st.setString(4, c.getCoverImg());
            st.setInt(5, c.getSortOrder());
            st.setInt(6, c.getStatus());
            st.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis()));
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("BlogCategoryDAO.insert: " + e);
        }
        return 0;
    }

    public int update(BlogCategory c) {
        String sql = "UPDATE BlogCategory SET name = ?, slug = ?, description = ?, coverImg = ?, sortOrder = ?, status = ?, dateUpdate = ? WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, c.getName());
            st.setString(2, c.getSlug());
            st.setString(3, c.getDescription());
            st.setString(4, c.getCoverImg());
            st.setInt(5, c.getSortOrder());
            st.setInt(6, c.getStatus());
            st.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis()));
            st.setInt(8, c.getID());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("BlogCategoryDAO.update: " + e);
        }
        return 0;
    }

    public int delete(int id) {
        String sql = "DELETE FROM BlogCategory WHERE ID = ?";
        try ( PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("BlogCategoryDAO.delete: " + e);
        }
        return 0;
    }

    private BlogCategory map(ResultSet rs) throws SQLException {
        BlogCategory c = new BlogCategory();
        c.setID(rs.getInt("ID"));
        c.setName(rs.getString("name"));
        c.setSlug(rs.getString("slug"));
        c.setDescription(rs.getString("description"));
        c.setCoverImg(rs.getString("coverImg"));
        c.setSortOrder(rs.getInt("sortOrder"));
        c.setStatus(rs.getInt("status"));
        c.setDatePost(rs.getTimestamp("datePost"));
        c.setDateUpdate(rs.getTimestamp("dateUpdate"));
        return c;
    }
}
