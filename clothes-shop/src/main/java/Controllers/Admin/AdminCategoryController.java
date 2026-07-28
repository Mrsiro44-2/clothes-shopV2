package Controllers.Admin;

import DAO.CategoryDAO;
import DAO.SizeGroupDAO;
import Model.Category;
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

@WebServlet(name = "AdminCategoryController", urlPatterns = {"/admin/categories/*"})
public class AdminCategoryController extends HttpServlet {

    private CategoryDAO categoryDao;
    private SizeGroupDAO sizeGroupDao;
    private Validation validate;

    @Override
    public void init() throws ServletException {
        categoryDao = new CategoryDAO();
        sizeGroupDao = new SizeGroupDAO();
        validate = new Validation();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/categories") || relative.equals("/admin/categories/")) {
            // Danh sách
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
            int totalRows = categoryDao.count(q, status);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.Category> categories = categoryDao.getPaginated(q, status, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("sort", sort);
            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", "Quản lý danh mục");
            request.getRequestDispatcher("/admin/catalog/category.jsp").forward(request, response);

        } else if (relative.equals("/admin/categories/add")) {
            request.setAttribute("sizeGroups", sizeGroupDao.allSizeGroup());
            request.setAttribute("pageTitle", "Thêm danh mục");
            request.getRequestDispatcher("/admin/catalog/category-form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/categories/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/categories/edit");
            if (id <= 0) { response.sendRedirect(request.getContextPath() + "/admin/categories"); return; }
            Category cat = categoryDao.getCategoryByID(id);
            if (cat == null) { response.sendRedirect(request.getContextPath() + "/admin/categories"); return; }
            request.setAttribute("category", cat);
            request.setAttribute("sizeGroups", sizeGroupDao.allSizeGroup());
            request.setAttribute("pageTitle", "Sửa danh mục");
            request.getRequestDispatcher("/admin/catalog/category-form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/categories/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/categories/delete");
            if (id > 0) {
                int productCount = categoryDao.getNumberProductByCategory(id);
                if (productCount > 0) {
                    request.getSession().setAttribute("adminFlash", "Không thể xoá danh mục vì còn " + productCount + " sản phẩm thuộc danh mục này.");
                    request.getSession().setAttribute("adminFlashType", "danger");
                } else {
                    categoryDao.delete(id);
                    request.getSession().setAttribute("adminFlash", "Đã xoá danh mục thành công.");
                    request.getSession().setAttribute("adminFlashType", "success");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        String name = request.getParameter("name");
        int status = validate.getInt(request.getParameter("status"));

        // Validate
        StringBuilder errors = new StringBuilder();
        if (name == null || name.trim().isEmpty()) {
            errors.append("Tên danh mục không được để trống. ");
        }
        if (status != 0 && status != 1) {
            errors.append("Trạng thái không hợp lệ. ");
        }
        
        int currentId = -1;
        if (relative.contains("/edit/")) {
            currentId = ServletPaths.idAfter(request, "/admin/categories/edit");
        }
        
        if (name != null && !name.trim().isEmpty()) {
            if (categoryDao.isExistName(name.trim(), currentId)) {
                errors.append("Tên danh mục này đã tồn tại. Vui lòng chọn tên khác. ");
            }
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.setAttribute("sizeGroups", sizeGroupDao.allSizeGroup());
            if (relative.contains("/edit/")) {
                int id = ServletPaths.idAfter(request, "/admin/categories/edit");
                Category cat = categoryDao.getCategoryByID(id);
                request.setAttribute("category", cat);
                request.setAttribute("pageTitle", "Sửa danh mục");
            } else {
                request.setAttribute("pageTitle", "Thêm danh mục");
            }
            request.setAttribute("inputName", name);
            request.setAttribute("inputStatus", status);
            request.getRequestDispatcher("/admin/catalog/category-form.jsp").forward(request, response);
            return;
        }

        if (relative.equals("/admin/categories/add")) {
            Category c = new Category();
            c.setName(name.trim());
            c.setStatus(status);
            int sizeGroupID = 0; try { sizeGroupID = Integer.parseInt(request.getParameter("sizeGroupID")); } catch(Exception e) {}
            c.setSizeGroupID(sizeGroupID);
            c.setDatePost(new Timestamp(System.currentTimeMillis()));
            categoryDao.insert(c);
            request.getSession().setAttribute("adminFlash", "Đã thêm danh mục \"" + name.trim() + "\" thành công.");
            request.getSession().setAttribute("adminFlashType", "success");
        } else if (relative.startsWith("/admin/categories/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/categories/edit");
            Category c = categoryDao.getCategoryByID(id);
            if (c != null) {
                c.setName(name.trim());
                c.setStatus(status);
            int sizeGroupID = 0; try { sizeGroupID = Integer.parseInt(request.getParameter("sizeGroupID")); } catch(Exception e) {}
            c.setSizeGroupID(sizeGroupID);
                c.setDateUpdate(new Timestamp(System.currentTimeMillis()));
                categoryDao.update(c);
                request.getSession().setAttribute("adminFlash", "Đã cập nhật danh mục thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
