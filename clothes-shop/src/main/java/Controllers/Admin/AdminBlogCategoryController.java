package Controllers.Admin;

import DAO.BlogCategoryDAO;
import Model.BlogCategory;
import Utils.ServletPaths;
import Utils.Upload;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminBlogCategoryController", urlPatterns = {"/admin/blog-categories/*"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminBlogCategoryController extends HttpServlet {

    private BlogCategoryDAO blogCategoryDAO;
    private Upload upload;

    @Override
    public void init() throws ServletException {
        blogCategoryDAO = new BlogCategoryDAO();
        upload = new Upload();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/blog-categories") || relative.equals("/admin/blog-categories/")) {
            List<BlogCategory> categories = blogCategoryDAO.listAll();
            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", "Danh mục Blog");
            request.getRequestDispatcher("/admin/blog/category.jsp").forward(request, response);

        } else if (relative.equals("/admin/blog-categories/add")) {
            request.setAttribute("pageTitle", "Thêm Danh mục Blog");
            request.getRequestDispatcher("/admin/blog/category-form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/blog-categories/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/blog-categories/edit");
            if (id <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin/blog-categories");
                return;
            }
            BlogCategory cat = blogCategoryDAO.findById(id);
            if (cat == null) {
                response.sendRedirect(request.getContextPath() + "/admin/blog-categories");
                return;
            }
            request.setAttribute("category", cat);
            request.setAttribute("pageTitle", "Sửa Danh mục Blog");
            request.getRequestDispatcher("/admin/blog/category-form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/blog-categories/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/blog-categories/delete");
            if (id > 0) {
                blogCategoryDAO.delete(id);
                request.getSession().setAttribute("adminFlash", "Đã xoá danh mục blog thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
            response.sendRedirect(request.getContextPath() + "/admin/blog-categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        String name = request.getParameter("name");
        String slug = request.getParameter("slug");
        String description = request.getParameter("description");
        int sortOrder = 0;
        try { sortOrder = Integer.parseInt(request.getParameter("sortOrder")); } catch (Exception ignored) {}
        int status = 0;
        try { status = Integer.parseInt(request.getParameter("status")); } catch (Exception ignored) {}

        // Upload Cover Image
        jakarta.servlet.http.Part filePart = request.getPart("coverImg");
        String coverImg = null;
        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = request.getServletContext().getRealPath("/uploads/blog");
            coverImg = upload.uploadImg(filePart, uploadPath);
        }

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Tên danh mục không được để trống.");
            request.setAttribute("inputName", name);
            request.setAttribute("inputSlug", slug);
            request.setAttribute("inputDescription", description);
            request.setAttribute("inputSortOrder", sortOrder);
            request.setAttribute("inputStatus", status);

            if (relative.contains("/edit/")) {
                int id = ServletPaths.idAfter(request, "/admin/blog-categories/edit");
                request.setAttribute("category", blogCategoryDAO.findById(id));
                request.setAttribute("pageTitle", "Sửa Danh mục Blog");
            } else {
                request.setAttribute("pageTitle", "Thêm Danh mục Blog");
            }
            request.getRequestDispatcher("/admin/blog/category-form.jsp").forward(request, response);
            return;
        }

        if (relative.equals("/admin/blog-categories/add")) {
            BlogCategory c = new BlogCategory();
            c.setName(name.trim());
            c.setSlug(slug.trim());
            c.setDescription(description);
            c.setCoverImg(coverImg);
            c.setSortOrder(sortOrder);
            c.setStatus(status);

            blogCategoryDAO.insert(c);
            request.getSession().setAttribute("adminFlash", "Đã thêm danh mục blog thành công.");
            request.getSession().setAttribute("adminFlashType", "success");

        } else if (relative.startsWith("/admin/blog-categories/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/blog-categories/edit");
            BlogCategory c = blogCategoryDAO.findById(id);
            if (c != null) {
                c.setName(name.trim());
                c.setSlug(slug.trim());
                c.setDescription(description);
                if (coverImg != null && !coverImg.isEmpty()) {
                    c.setCoverImg(coverImg);
                }
                c.setSortOrder(sortOrder);
                c.setStatus(status);

                blogCategoryDAO.update(c);
                request.getSession().setAttribute("adminFlash", "Đã cập nhật danh mục blog thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/blog-categories");
    }
}
