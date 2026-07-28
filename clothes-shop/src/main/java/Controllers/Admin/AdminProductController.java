package Controllers.Admin;

import DAO.BrandDAO;
import DAO.CategoryDAO;
import DAO.ColorOptionDAO;
import DAO.ImgDescriptionDAO;
import DAO.ProducerDAO;
import DAO.ProductDAO;
import DAO.ProductVariantDAO;
import DAO.SizeOptionDAO;
import Model.Product;
import Utils.ServletPaths;
import Utils.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import Utils.Upload;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.Normalizer;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet(name = "AdminProductController", urlPatterns = {"/admin/products/*"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminProductController extends HttpServlet {

    private ProductDAO productDao;
    private CategoryDAO categoryDao;
    private BrandDAO brandDao;
    private ProducerDAO producerDao;
    private ProductVariantDAO variantDao;
    private ImgDescriptionDAO imgDao;
    private ColorOptionDAO colorDao;
    private SizeOptionDAO sizeDao;
    private Validation validate;

    @Override
    public void init() throws ServletException {
        productDao = new ProductDAO();
        categoryDao = new CategoryDAO();
        brandDao = new BrandDAO();
        producerDao = new ProducerDAO();
        variantDao = new ProductVariantDAO();
        imgDao = new ImgDescriptionDAO();
        colorDao = new ColorOptionDAO();
        sizeDao = new SizeOptionDAO();
        validate = new Validation();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/products") || relative.equals("/admin/products/")) {
            String q = request.getParameter("q");
            String status = request.getParameter("status");
            String categoryFilter = request.getParameter("categoryID");
            String producerFilter = request.getParameter("producerID");
            String brandFilter = request.getParameter("brandID");
            String sort = request.getParameter("sort");
            int page = 1;
            if (request.getParameter("page") != null) {
                try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
            }
            int limit = 10;
            if (request.getParameter("limit") != null) {
                try { limit = Integer.parseInt(request.getParameter("limit")); } catch (Exception e) {}
            }
            int totalRows = productDao.count(q, status, categoryFilter, producerFilter, brandFilter);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.Product> products = productDao.getPaginated(q, status, categoryFilter, producerFilter, brandFilter, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("categoryID", categoryFilter);
            request.setAttribute("producerID", producerFilter);
            request.setAttribute("brandID", brandFilter);
            loadForeignKeys(request);
            request.setAttribute("sort", sort);
            request.setAttribute("products", products);
            request.setAttribute("pageTitle", "Quản lý sản phẩm");
            request.getRequestDispatcher("/admin/product/index.jsp").forward(request, response);

        } else if (relative.equals("/admin/products/add")) {
            loadForeignKeys(request);
            request.setAttribute("pageTitle", "Thêm sản phẩm");
            request.getRequestDispatcher("/admin/product/form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/products/detail/")) {
            int id = ServletPaths.idAfter(request, "/admin/products/detail");
            if (id <= 0) { response.sendRedirect(request.getContextPath() + "/admin/products"); return; }
            Product p = productDao.getProductByID(id);
            if (p == null) { response.sendRedirect(request.getContextPath() + "/admin/products"); return; }
            loadForeignKeys(request);
            request.setAttribute("product", p);
            request.setAttribute("variants", variantDao.findAllByProductId(id));
            request.setAttribute("images", imgDao.getAllImgDescriptionByProduct(id));
            
            DAO.FeedbackDAO fbDao = new DAO.FeedbackDAO();
            request.setAttribute("feedbacks", fbDao.allFeedbackByProduct(id));
            
            request.setAttribute("pageTitle", "Chi tiết sản phẩm");
            request.getRequestDispatcher("/admin/product/detail.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/products/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/products/edit");
            if (id <= 0) { response.sendRedirect(request.getContextPath() + "/admin/products"); return; }
            Product p = productDao.getProductByID(id);
            if (p == null) { response.sendRedirect(request.getContextPath() + "/admin/products"); return; }
            loadForeignKeys(request);
            request.setAttribute("product", p);
            request.setAttribute("variants", variantDao.findAllByProductId(id));
            request.setAttribute("images", imgDao.getAllImgDescriptionByProduct(id));
            request.setAttribute("pageTitle", "Sửa sản phẩm");
            request.getRequestDispatcher("/admin/product/form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/products/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/products/delete");
            if (id > 0) {
                // Sẽ không xoá được nếu còn tồn tại ProductVariant, tuỳ theo khoá ngoại
                int res = productDao.delete(id);
                if (res > 0) {
                    request.getSession().setAttribute("adminFlash", "Đã xoá sản phẩm thành công.");
                    request.getSession().setAttribute("adminFlashType", "success");
                } else {
                    request.getSession().setAttribute("adminFlash", "Không thể xoá sản phẩm này (có thể do vẫn còn biến thể/đơn hàng liên quan).");
                    request.getSession().setAttribute("adminFlashType", "danger");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String mainImg = request.getParameter("mainImgUrl"); // URL nếu người dùng nhập
        try {
            Part filePart = request.getPart("mainImgFile");
            if (filePart != null && filePart.getSize() > 0) {
                Upload uploader = new Upload();
                String uploadPath = request.getServletContext().getRealPath("/uploads");
                String fileName = uploader.uploadImg(filePart, uploadPath);
                if (fileName != null) {
                    mainImg = request.getContextPath() + "/uploads/" + fileName; // Ghi đè bằng ảnh upload
                }
            }
        } catch (Exception e) {
            System.out.println("No file upload: " + e);
        }
        String model = request.getParameter("model");
        int categoryID = validate.getInt(request.getParameter("categoryID"));
        int brandID = validate.getInt(request.getParameter("brandID"));
        int producerID = validate.getInt(request.getParameter("producerID"));
        int priority = validate.getInt(request.getParameter("priority"));
        int status = validate.getInt(request.getParameter("status"));

        StringBuilder errors = new StringBuilder();
        if (name == null || name.trim().isEmpty()) errors.append("Tên sản phẩm không được để trống. ");
        if (categoryID <= 0) errors.append("Vui lòng chọn danh mục. ");
        if (brandID <= 0) errors.append("Vui lòng chọn thương hiệu. ");
        if (producerID <= 0) errors.append("Vui lòng chọn nhà sản xuất. ");

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            loadForeignKeys(request);
            if (relative.contains("/edit/")) {
                int id = ServletPaths.idAfter(request, "/admin/products/edit");
                request.setAttribute("product", productDao.getProductByID(id));
                request.setAttribute("pageTitle", "Sửa sản phẩm");
            } else {
                request.setAttribute("pageTitle", "Thêm sản phẩm");
            }
            request.getRequestDispatcher("/admin/product/form.jsp").forward(request, response);
            return;
        }

        String slug = toSlug(name.trim());

        if (relative.equals("/admin/products/add")) {
            Product p = new Product();
            p.setName(name.trim());
            p.setSlug(slug);
            p.setDescription(description != null ? description.trim() : "");
            p.setMainImg(mainImg != null ? mainImg.trim() : "");
            p.setModel(model != null ? model.trim() : "");
            p.setCategoryID(categoryID);
            p.setBrandID(brandID);
            p.setProducerID(producerID);
            p.setPriority(priority);
            p.setStatus(status);
            p.setDatePost(new Timestamp(System.currentTimeMillis()));
            
            int newId = productDao.insert(p);
            if (newId > 0) {
                request.getSession().setAttribute("adminFlash", "Đã thêm sản phẩm thành công. Bạn có thể thêm biến thể ngay bây giờ.");
                request.getSession().setAttribute("adminFlashType", "success");
                response.sendRedirect(request.getContextPath() + "/admin/products/edit/" + newId);
                return;
            } else {
                request.getSession().setAttribute("adminFlash", "Lỗi thêm sản phẩm.");
                request.getSession().setAttribute("adminFlashType", "danger");
            }
        } else if (relative.startsWith("/admin/products/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/products/edit");
            Product p = productDao.getProductByID(id);
            if (p != null) {
                p.setName(name.trim());
                p.setSlug(slug);
                p.setDescription(description != null ? description.trim() : "");
                if (mainImg != null && !mainImg.trim().isEmpty()) {
                    p.setMainImg(mainImg.trim());
                }
                p.setModel(model != null ? model.trim() : "");
                p.setCategoryID(categoryID);
                p.setBrandID(brandID);
                p.setProducerID(producerID);
                p.setPriority(priority);
                p.setStatus(status);
                p.setDateUpdate(new Timestamp(System.currentTimeMillis()));
                
                int rows = productDao.update(p);
                if (rows > 0) {
                    request.getSession().setAttribute("adminFlash", "Đã cập nhật sản phẩm thành công.");
                    request.getSession().setAttribute("adminFlashType", "success");
                } else {
                    request.getSession().setAttribute("adminFlash", "Lỗi cập nhật sản phẩm.");
                    request.getSession().setAttribute("adminFlashType", "danger");
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void loadForeignKeys(HttpServletRequest request) {
        request.setAttribute("categories", categoryDao.allCategory());
        request.setAttribute("filterCategories", categoryDao.allCategory());
        request.setAttribute("brands", brandDao.allBrand());
        request.setAttribute("filterBrands", brandDao.allBrand());
        request.setAttribute("producers", producerDao.allProducer());
        request.setAttribute("filterProducers", producerDao.allProducer());
        request.setAttribute("colors", colorDao.getAll());
        request.setAttribute("sizes", sizeDao.allSizeOption());
    }

    private String toSlug(String input) {
        if (input == null) return "";
        String temp = Normalizer.normalize(input, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        String slug = pattern.matcher(temp).replaceAll("").toLowerCase();
        slug = slug.replaceAll("[đĐ]", "d");
        slug = slug.replaceAll("[^a-z0-9]+", "-");
        slug = slug.replaceAll("^-+|-+$", "");
        return slug;
    }
}
