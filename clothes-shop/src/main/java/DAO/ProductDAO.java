/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Product master + giÃƒÆ’Ã‚Â¡/tÃƒÂ¡Ã‚Â»Ã¢â‚¬Å“n tÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¢ng hÃƒÂ¡Ã‚Â»Ã‚Â£p tÃƒÂ¡Ã‚Â»Ã‚Â« ProductVariant (schema v2).
 */
public class ProductDAO {

    private static final String P_SEL = "SELECT p.ID, p.name, p.slug, p.description, p.datePost, p.dateUpdate, p.mainImg, p.status, p.model, p.priority, "
            + "p.categoryID, p.producerID, p.brandID, "
            + "ISNULL(va.aggMinNew, 0) AS newPrice, ISNULL(va.aggMaxOld, 0) AS oldPrice, "
            + "ISNULL(va.aggSumQty, 0) AS quantity, ISNULL(soldAgg.aggSumSold, 0) AS sold ";

    private static final String P_AGG_JOIN = " FROM Product p "
            + "LEFT JOIN (SELECT productID, MIN(newPrice) AS aggMinNew, MAX(oldPrice) AS aggMaxOld, "
            + "SUM(quantity) AS aggSumQty "
            + "FROM ProductVariant WHERE status = 1 GROUP BY productID) va ON va.productID = p.ID "
            + "LEFT JOIN (SELECT pv.productID, SUM(bd.numberOfProduct) AS aggSumSold "
            + "FROM BillDetail bd "
            + "INNER JOIN ProductVariant pv ON pv.ID = bd.productVariantID "
            + "INNER JOIN Bill b ON b.id = bd.billID AND b.status <> 0 "
            + "GROUP BY pv.productID) soldAgg ON soldAgg.productID = p.ID ";

    private Connection conn;

    public ProductDAO() {
        try {
            conn = DBConnection.DBConnection.connect();
        } catch (Exception e) {
            System.out.println("Connection fail: " + e);
        }
    }

    public List<Product> filterProduct(int[] idCategory, int[] idBrand, float from, float to, int time) {
        List<Product> products = new ArrayList<>();
        String sql = P_SEL + P_AGG_JOIN
                + "JOIN Category AS c ON c.ID = p.categoryID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID "
                + "JOIN Brand AS br ON br.ID = p.brandID "
                + "WHERE p.status = 1 AND pr.status = 1 AND c.status = 1 AND br.status = 1 ";
        int i = 0;
        for (int id : idCategory) {
            if (idCategory.length - 1 == 0) {
                sql += " AND p.categoryID = ? ";
                break;
            } else if (i == 0) {
                sql += "AND (p.categoryID = ? ";
            } else if (i == idCategory.length - 1) {
                sql += "OR p.categoryID = ? ) ";
            } else {
                sql += "OR p.categoryID = ? ";
            }
            i++;
        }
        for (int id : idBrand) {
            if (idBrand.length - 1 == 0) {
                sql += " AND p.brandID = ? ";
                break;
            } else if (i == 0) {
                sql += "AND (p.brandID = ? ";
            } else if (i == idBrand.length - 1) {
                sql += "OR p.brandID = ? ) ";
            } else {
                sql += "OR p.brandID = ? ";
            }
            i++;
        }
        sql += "AND ((ISNULL(va.aggMinNew, 0) >= ? AND ISNULL(va.aggMinNew, 0) <= ?) "
                + "OR (ISNULL(va.aggMaxOld, 0) >= ? AND ISNULL(va.aggMaxOld, 0) <= ?)) ";
        if (time == 0) {
            sql += "ORDER BY p.ID ASC";
        } else {
            sql += "ORDER BY p.ID DESC";
        }
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            int index = 1;
            for (int id : idCategory) {
                st.setInt(index++, id);
            }
            for (int id : idBrand) {
                st.setInt(index++, id);
            }
            st.setFloat(index++, from);
            st.setFloat(index++, to);
            st.setFloat(index++, from);
            st.setFloat(index++, to);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                products.add(this.getProduct(result));
            }
        } catch (SQLException e) {
            System.out.println("filterProduct: " + e);
        }
        return products;
    }

    public List<Product> getProductByPriority(int status) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT TOP 7 " + P_SEL.replace("SELECT ", "") + P_AGG_JOIN
                + "JOIN Category AS c ON c.ID = p.categoryID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID "
                + "JOIN Brand AS br ON br.ID = p.brandID "
                + "WHERE p.status = 1 AND p.priority = ? AND pr.status = 1 AND c.status = 1 AND br.status = 1 "
                + "ORDER BY p.ID DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, status);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                products.add(this.getProduct(result));
            }
        } catch (SQLException e) {
            System.out.println("Get priority product: " + e);
        }
        return products;
    }

    public List<Product> getProductsCategoryByPage(String slugCategory, int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        String sql = P_SEL + P_AGG_JOIN
                + "JOIN Category AS c ON c.ID = p.categoryID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID "
                + "WHERE c.slug = ? AND p.status = 1 AND pr.status = 1 AND c.status = 1 ORDER BY p.ID DESC "
                + "OFFSET ? ROWS FETCH FIRST ? ROWS ONLY";
        int offset = (page - 1) * pageSize;
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, slugCategory);
            st.setInt(2, offset);
            st.setInt(3, pageSize);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                products.add(this.getProduct(result));
            }
        } catch (SQLException e) {
            System.out.println("get product category page: " + e);
        }
        return products;
    }

    public List<Product> getProductsByPage(int page, int pageSize, String type, int... id) {
        List<Product> products = new ArrayList<>();
        String sql = P_SEL + P_AGG_JOIN
                + "JOIN Category AS c ON c.ID = p.categoryID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID WHERE p.status = 1 AND ";
        if (type.equals("category")) {
            sql += "p.categoryID = ? AND ";
        } else if (type.equals("brand")) {
            sql += "p.brandID = ? AND ";
        }
        sql += "pr.status = 1 AND c.status = 1 ORDER BY p.ID DESC OFFSET ? ROWS FETCH FIRST ? ROWS ONLY";
        int offset = (page - 1) * pageSize;
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            int i = 1;
            if (type.equals("category")) {
                st.setInt(i++, id[0]);
            } else if (type.equals("brand")) {
                st.setInt(i++, id[0]);
            }
            st.setInt(i++, offset);
            st.setInt(i++, pageSize);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                products.add(this.getProduct(result));
            }
        } catch (SQLException e) {
            System.out.println("get product page: " + e);
        }
        return products;
    }

    public List<Product> getAllProductActive(String type, int... id) {
        List<Product> products = new ArrayList<>();
        String sql = P_SEL + P_AGG_JOIN
                + "JOIN Category AS c ON c.ID = p.categoryID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID "
                + "JOIN Brand AS br ON br.ID = p.brandID "
                + "WHERE p.status = 1 AND br.status = 1 AND pr.status = 1 AND c.status = 1 ";
        if (type.equals("category")) {
            sql += " AND c.ID = ?";
        } else if (type.equals("brand")) {
            sql += " AND br.ID = ?";
        }
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            int i = 1;
            if (type.equals("category")) {
                st.setInt(i++, id[0]);
            } else if (type.equals("brand")) {
                st.setInt(i++, id[0]);
            }
            ResultSet result = st.executeQuery();
            while (result.next()) {
                products.add(this.getProduct(result));
            }
        } catch (SQLException e) {
            System.out.println("Get all product: " + e);
        }
        return products;
    }

    public List<Product> seachProduct(String keyword) {
        List<Product> products = new ArrayList<>();
        String sql = P_SEL + P_AGG_JOIN
                + "JOIN Category AS c ON c.ID = p.categoryID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID "
                + "WHERE p.status = 1 AND pr.status = 1 AND c.status = 1 AND p.name LIKE ? ORDER BY p.ID DESC ";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            ResultSet result = st.executeQuery();
            while (result.next()) {
                products.add(this.getProduct(result));
            }
        } catch (SQLException e) {
            System.out.println("searchProduct: " + e);
        }
        return products;
    }

    public List<Product> seachProduct(String keyword, int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        String sql = P_SEL + P_AGG_JOIN
                + "JOIN Category AS c ON c.ID = p.categoryID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID "
                + "WHERE p.status = 1 AND pr.status = 1 AND c.status = 1 AND p.name LIKE ? ORDER BY p.ID DESC "
                + "OFFSET ? ROWS FETCH FIRST ? ROWS ONLY";
        int offset = (page - 1) * pageSize;
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            st.setInt(2, offset);
            st.setInt(3, pageSize);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                products.add(this.getProduct(result));
            }
        } catch (SQLException e) {
            System.out.println("Get search product: " + e);
        }
        return products;
    }

    public List<Product> getAllProductActiveRelative(Product p) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT TOP 4 " + P_SEL.replace("SELECT ", "") + P_AGG_JOIN
                + "JOIN Category AS c ON c.ID = p.categoryID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID "
                + "JOIN Brand AS br ON br.ID = p.brandID "
                + "WHERE p.status = 1 AND br.status = 1 AND pr.status = 1 AND c.status = 1 "
                + "AND p.ID != ? AND (p.categoryID = ? OR p.brandID = ? OR p.producerID = ?) ORDER BY p.ID DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            int i = 1;
            st.setInt(i++, p.getID());
            st.setInt(i++, p.getCategoryID());
            st.setInt(i++, p.getBrandID());
            st.setInt(i++, p.getProducerID());
            ResultSet result = st.executeQuery();
            while (result.next()) {
                products.add(this.getProduct(result));
            }
        } catch (SQLException e) {
            System.out.println("get all product relative: " + e);
        }
        return products;
    }

    public Product statusIsActive(int id) {
        String sql = P_SEL + P_AGG_JOIN
                + "JOIN Producer AS pr ON p.producerID = pr.ID "
                + "JOIN Category AS Ca ON p.categoryID = Ca.ID "
                + "JOIN Brand AS br ON br.ID = p.brandID "
                + "WHERE p.ID = ? AND p.status = 1 AND pr.status = 1 AND Ca.status = 1 AND br.status = 1";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return this.getProduct(result);
            }
        } catch (SQLException e) {
            System.out.println("Product item: " + e);
        }
        return null;
    }

    public List<Product> getAll() {
        List<Product> products = new ArrayList<>();
        String sql = P_SEL + P_AGG_JOIN
                + "JOIN Category AS c ON p.categoryID = c.ID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID "
                + "JOIN Brand AS br ON br.ID = p.brandID "
                + "ORDER BY p.ID DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                products.add(this.getProduct(rs));
            }
        } catch (Exception e) {
            System.out.println("Get product: " + e);
        }
        return products;
    }

    public Product getProductByID(int id) {
        String sql = P_SEL + P_AGG_JOIN + "WHERE p.ID = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet result = st.executeQuery();
            if (result.next()) {
                return this.getProduct(result);
            }
        } catch (SQLException e) {
            System.out.println("Get product by id: " + e);
        }
        return null;
    }

    public List<Product> getTopFiveProduct() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT TOP 5 " + P_SEL.replace("SELECT ", "") + P_AGG_JOIN
                + "WHERE ISNULL(soldAgg.aggSumSold, 0) > 0 ORDER BY ISNULL(soldAgg.aggSumSold, 0) DESC";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet result = st.executeQuery();
            while (result.next()) {
                products.add(this.getProduct(result));
            }
        } catch (SQLException e) {
            System.out.println("getTopFiveProduct: " + e);
        }
        return products;
    }

    public Product getProduct(ResultSet rs) {
        try {
            int ID = rs.getInt("ID");
            String name = rs.getString("name");
            String slug = rs.getString("slug");
            float oldPrice = rs.getFloat("oldPrice");
            float newPrice = rs.getFloat("newPrice");
            String description = rs.getString("description");
            Timestamp datePost = rs.getTimestamp("datePost");
            Timestamp dateUpdate = rs.getTimestamp("dateUpdate");
            String mainImg = rs.getString("mainImg");
            int status = rs.getInt("status");
            int quantity = rs.getInt("quantity");
            int sold = rs.getInt("sold");
            String model = rs.getString("model");
            int priority = rs.getInt("priority");
            int categoryID = rs.getInt("categoryID");
            int producerID = rs.getInt("producerID");
            int brandID = rs.getInt("brandID");
            return new Product(ID, name, slug, oldPrice, newPrice, description, datePost, dateUpdate, mainImg, status, quantity, sold, model, priority, categoryID, producerID, brandID);
        } catch (Exception e) {
            System.out.println("Get product: " + e);
        }
        return null;
    }

    public List<Product> searchAndFilterProducts(String keyword, String[] categoryIds, String[] brandIds, float minPrice, float maxPrice, int sort, int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder(P_SEL + P_AGG_JOIN
                + "JOIN Category AS c ON c.ID = p.categoryID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID "
                + "JOIN Brand AS br ON br.ID = p.brandID "
                + "WHERE p.status = 1 AND pr.status = 1 AND c.status = 1 AND br.status = 1 ");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND p.name LIKE ? ");
        }
        
        if (categoryIds != null && categoryIds.length > 0) {
            sql.append("AND p.categoryID IN (");
            for (int i = 0; i < categoryIds.length; i++) {
                sql.append("?");
                if (i < categoryIds.length - 1) sql.append(",");
            }
            sql.append(") ");
        }
        
        if (brandIds != null && brandIds.length > 0) {
            sql.append("AND p.brandID IN (");
            for (int i = 0; i < brandIds.length; i++) {
                sql.append("?");
                if (i < brandIds.length - 1) sql.append(",");
            }
            sql.append(") ");
        }
        
        if (maxPrice > 0 && maxPrice >= minPrice) {
            sql.append("AND (ISNULL(va.aggMinNew, 0) BETWEEN ? AND ?) ");
        }
        
        if (sort == 1) {
            sql.append("ORDER BY ISNULL(va.aggMinNew, 0) DESC, p.ID DESC ");
        } else if (sort == 0) {
            sql.append("ORDER BY ISNULL(va.aggMinNew, 0) ASC, p.ID DESC ");
        } else {
            sql.append("ORDER BY p.ID DESC ");
        }
        
        sql.append("OFFSET ? ROWS FETCH FIRST ? ROWS ONLY");
        
        try {
            PreparedStatement st = conn.prepareStatement(sql.toString());
            int index = 1;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(index++, "%" + keyword.trim() + "%");
            }
            
            if (categoryIds != null && categoryIds.length > 0) {
                for (String id : categoryIds) {
                    st.setInt(index++, Integer.parseInt(id));
                }
            }
            
            if (brandIds != null && brandIds.length > 0) {
                for (String id : brandIds) {
                    st.setInt(index++, Integer.parseInt(id));
                }
            }
            
            if (maxPrice > 0 && maxPrice >= minPrice) {
                st.setFloat(index++, minPrice);
                st.setFloat(index++, maxPrice);
            }
            
            int offset = (page - 1) * pageSize;
            st.setInt(index++, offset);
            st.setInt(index++, pageSize);
            
            ResultSet result = st.executeQuery();
            while (result.next()) {
                products.add(this.getProduct(result));
            }
        } catch (Exception e) {
            System.out.println("searchAndFilterProducts: " + e);
        }
        return products;
    }

    public int countSearchAndFilterProducts(String keyword, String[] categoryIds, String[] brandIds, float minPrice, float maxPrice) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(p.ID) " + P_AGG_JOIN
                + "JOIN Category AS c ON c.ID = p.categoryID "
                + "JOIN Producer AS pr ON pr.ID = p.producerID "
                + "JOIN Brand AS br ON br.ID = p.brandID "
                + "WHERE p.status = 1 AND pr.status = 1 AND c.status = 1 AND br.status = 1 ");
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND p.name LIKE ? ");
        }
        
        if (categoryIds != null && categoryIds.length > 0) {
            sql.append("AND p.categoryID IN (");
            for (int i = 0; i < categoryIds.length; i++) {
                sql.append("?");
                if (i < categoryIds.length - 1) sql.append(",");
            }
            sql.append(") ");
        }
        
        if (brandIds != null && brandIds.length > 0) {
            sql.append("AND p.brandID IN (");
            for (int i = 0; i < brandIds.length; i++) {
                sql.append("?");
                if (i < brandIds.length - 1) sql.append(",");
            }
            sql.append(") ");
        }
        
        if (maxPrice > 0 && maxPrice >= minPrice) {
            sql.append("AND (ISNULL(va.aggMinNew, 0) BETWEEN ? AND ?) ");
        }
        
        try {
            PreparedStatement st = conn.prepareStatement(sql.toString());
            int index = 1;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                st.setString(index++, "%" + keyword.trim() + "%");
            }
            
            if (categoryIds != null && categoryIds.length > 0) {
                for (String id : categoryIds) {
                    st.setInt(index++, Integer.parseInt(id));
                }
            }
            
            if (brandIds != null && brandIds.length > 0) {
                for (String id : brandIds) {
                    st.setInt(index++, Integer.parseInt(id));
                }
            }
            
            if (maxPrice > 0 && maxPrice >= minPrice) {
                st.setFloat(index++, minPrice);
                st.setFloat(index++, maxPrice);
            }
            
            ResultSet result = st.executeQuery();
            if (result.next()) {
                count = result.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countSearchAndFilterProducts: " + e);
        }
        return count;
    }

    public int insert(Product p) {
        String sql = "INSERT INTO Product (name, slug, description, datePost, mainImg, status, model, priority, categoryID, producerID, brandID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            int i = 1;
            st.setString(i++, p.getName());
            st.setString(i++, p.getSlug());
            st.setString(i++, p.getDescription());
            st.setTimestamp(i++, p.getDatePost());
            st.setString(i++, p.getMainImg());
            st.setInt(i++, p.getStatus());
            st.setString(i++, p.getModel());
            st.setInt(i++, p.getPriority());
            st.setInt(i++, p.getCategoryID());
            st.setInt(i++, p.getProducerID());
            st.setInt(i++, p.getBrandID());
            int result = st.executeUpdate();
            if (result > 0) {
                try ( ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Add product: " + e);
        }
        return 0;
    }

    public int update(Product p) {
        String sql = "UPDATE Product SET name = ?, slug = ?, description = ?, dateUpdate = ?, mainImg = ?, status = ?, model = ?, priority = ?, categoryID = ?, producerID = ?, brandID = ? WHERE ID = ?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            int i = 1;
            st.setString(i++, p.getName());
            st.setString(i++, p.getSlug());
            st.setString(i++, p.getDescription());
            st.setTimestamp(i++, p.getDateUpdate());
            st.setString(i++, p.getMainImg());
            st.setInt(i++, p.getStatus());
            st.setString(i++, p.getModel());
            st.setInt(i++, p.getPriority());
            st.setInt(i++, p.getCategoryID());
            st.setInt(i++, p.getProducerID());
            st.setInt(i++, p.getBrandID());
            st.setInt(i++, p.getID());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Update product: " + e);
        }
        return 0;
    }

    public int delete(int id) {
        try {
            PreparedStatement st = conn.prepareStatement("DELETE FROM Product WHERE ID = ?");
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Delete product: " + e);
        }
        return 0;
    }

    public int count(String search, String statusFilter, String categoryFilter, String producerFilter, String brandFilter) {
        String sql = "SELECT COUNT(*) FROM Product p WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (p.name LIKE ? OR p.model LIKE ?)";
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) { sql += " AND p.status = ?"; } if (categoryFilter != null && !categoryFilter.trim().isEmpty()) { sql += " AND p.categoryID = ?"; } if (producerFilter != null && !producerFilter.trim().isEmpty()) { sql += " AND p.producerID = ?"; } if (brandFilter != null && !brandFilter.trim().isEmpty()) { sql += " AND p.brandID = ?"; }
        try {
            java.sql.PreparedStatement st = conn.prepareStatement(sql);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                st.setString(paramIndex++, likeSearch);
                st.setString(paramIndex++, likeSearch);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) { st.setInt(paramIndex++, Integer.parseInt(statusFilter)); } if (categoryFilter != null && !categoryFilter.trim().isEmpty()) { st.setInt(paramIndex++, Integer.parseInt(categoryFilter)); } if (producerFilter != null && !producerFilter.trim().isEmpty()) { st.setInt(paramIndex++, Integer.parseInt(producerFilter)); } if (brandFilter != null && !brandFilter.trim().isEmpty()) { st.setInt(paramIndex++, Integer.parseInt(brandFilter)); }
            java.sql.ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (java.sql.SQLException e) {
            System.out.println("ProductDAO count: " + e);
        }
        return 0;
    }

    public java.util.List<Model.Product> getPaginated(String search, String statusFilter, String categoryFilter, String producerFilter, String brandFilter, String sort, int page, int limit) {
        java.util.List<Model.Product> list = new java.util.ArrayList<>();
        String sql = P_SEL + P_AGG_JOIN + "WHERE 1=1";
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND (p.name LIKE ? OR p.model LIKE ?)";
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) { sql += " AND p.status = ?"; } if (categoryFilter != null && !categoryFilter.trim().isEmpty()) { sql += " AND p.categoryID = ?"; } if (producerFilter != null && !producerFilter.trim().isEmpty()) { sql += " AND p.producerID = ?"; } if (brandFilter != null && !brandFilter.trim().isEmpty()) { sql += " AND p.brandID = ?"; }
        
        if ("oldest".equals(sort)) {
            sql += " ORDER BY p.ID ASC";
        } else {
            sql += " ORDER BY p.ID DESC";
        }
        
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try {
            java.sql.PreparedStatement st = conn.prepareStatement(sql);
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String likeSearch = "%" + search.trim() + "%";
                st.setString(paramIndex++, likeSearch);
                st.setString(paramIndex++, likeSearch);
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) { st.setInt(paramIndex++, Integer.parseInt(statusFilter)); } if (categoryFilter != null && !categoryFilter.trim().isEmpty()) { st.setInt(paramIndex++, Integer.parseInt(categoryFilter)); } if (producerFilter != null && !producerFilter.trim().isEmpty()) { st.setInt(paramIndex++, Integer.parseInt(producerFilter)); } if (brandFilter != null && !brandFilter.trim().isEmpty()) { st.setInt(paramIndex++, Integer.parseInt(brandFilter)); }
            
            st.setInt(paramIndex++, (page - 1) * limit);
            st.setInt(paramIndex++, limit);
            
            java.sql.ResultSet result = st.executeQuery();
            while (result.next()) {
                list.add(this.getProduct(result));
            }
        } catch (java.sql.SQLException e) {
            System.out.println("ProductDAO getPaginated: " + e);
        }
        return list;
    }
}