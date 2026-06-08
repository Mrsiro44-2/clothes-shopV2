package Controllers.Admin;

import DAO.BrandDAO;
import Model.Brand;
import Utils.ServletPaths;
import Utils.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import jakarta.servlet.annotation.MultipartConfig;
import Utils.Upload;

@WebServlet(name = "AdminBrandController", urlPatterns = {"/admin/brands/*"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AdminBrandController extends HttpServlet {

    private BrandDAO brandDao;
    private Validation validate;

    @Override
    public void init() throws ServletException {
        brandDao = new BrandDAO();
        validate = new Validation();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/brands") || relative.equals("/admin/brands/")) {
                        String q = request.getParameter("q");
            String status = request.getParameter("status");
            String sort = request.getParameter("sort");
            int page = 1;
            if (request.getParameter("page") != null) {
                try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
            }
            int limit = 10;
            if (request.getParameter("limit") != null) {
                try { limit = Integer.parseInt(request.getParameter("limit")); } catch (Exception e) {}
            }
            int totalRows = brandDao.count(q, status);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.Brand> brands = brandDao.getPaginated(q, status, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("sort", sort);
            request.setAttribute("brands", brands);
            request.setAttribute("pageTitle", "Quản lý thương hiệu");
            request.getRequestDispatcher("/admin/catalog/brand.jsp").forward(request, response);

        } else if (relative.equals("/admin/brands/add")) {
            request.setAttribute("pageTitle", "Thêm thương hiệu");
            request.getRequestDispatcher("/admin/catalog/brand-form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/brands/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/brands/edit");
            if (id <= 0) { response.sendRedirect(request.getContextPath() + "/admin/brands"); return; }
            Brand brand = brandDao.getBrandByID(id);
            if (brand == null) { response.sendRedirect(request.getContextPath() + "/admin/brands"); return; }
            request.setAttribute("brand", brand);
            request.setAttribute("pageTitle", "Sửa thương hiệu");
            request.getRequestDispatcher("/admin/catalog/brand-form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/brands/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/brands/delete");
            if (id > 0) {
                int productCount = brandDao.getNumberProductByBrand(id);
                if (productCount > 0) {
                    request.getSession().setAttribute("adminFlash", "Không thể xoá thương hiệu vì còn " + productCount + " sản phẩm thuộc thương hiệu này.");
                    request.getSession().setAttribute("adminFlashType", "danger");
                } else {
                    brandDao.delete(id);
                    request.getSession().setAttribute("adminFlash", "Đã xoá thương hiệu thành công.");
                    request.getSession().setAttribute("adminFlashType", "success");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/brands");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        String name = request.getParameter("name");
        int status = validate.getInt(request.getParameter("status"));

        Upload upload = new Upload();
        jakarta.servlet.http.Part filePart = request.getPart("img");
        String img = null;
        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = request.getServletContext().getRealPath("") + "uploads" + java.io.File.separator + "brand";
            img = upload.uploadImg(filePart, uploadPath);
        }

        // Validate
        StringBuilder errors = new StringBuilder();
        if (name == null || name.trim().isEmpty()) {
            errors.append("Tên thương hiệu không được để trống. ");
        }
        if (status != 0 && status != 1) {
            errors.append("Trạng thái không hợp lệ. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            if (relative.contains("/edit/")) {
                int id = ServletPaths.idAfter(request, "/admin/brands/edit");
                Brand brand = brandDao.getBrandByID(id);
                request.setAttribute("brand", brand);
                request.setAttribute("pageTitle", "Sửa thương hiệu");
            } else {
                request.setAttribute("pageTitle", "Thêm thương hiệu");
            }
            request.setAttribute("inputName", name);
            request.setAttribute("inputImg", img);
            request.setAttribute("inputStatus", status);
            request.getRequestDispatcher("/admin/catalog/brand-form.jsp").forward(request, response);
            return;
        }

        if (relative.equals("/admin/brands/add")) {
            Brand b = new Brand();
            b.setName(name.trim());
            b.setImg(img != null ? img.trim() : "");
            b.setStatus(status);
            b.setDatePost(new Timestamp(System.currentTimeMillis()));
            brandDao.insert(b);
            request.getSession().setAttribute("adminFlash", "Đã thêm thương hiệu \"" + name.trim() + "\" thành công.");
            request.getSession().setAttribute("adminFlashType", "success");
        } else if (relative.startsWith("/admin/brands/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/brands/edit");
            Brand b = brandDao.getBrandByID(id);
            if (b != null) {
                b.setName(name.trim());
                b.setImg(img != null ? img.trim() : b.getImg());
                b.setStatus(status);
                b.setDateUpdate(new Timestamp(System.currentTimeMillis()));
                brandDao.update(b);
                request.getSession().setAttribute("adminFlash", "Đã cập nhật thương hiệu thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/brands");
    }
}
