package Controllers.Admin;

import DAO.BlogTagDAO;
import Model.BlogTag;
import Utils.ServletPaths;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminBlogTagController", urlPatterns = {"/admin/blog-tags", "/admin/blog-tags/*"})
public class AdminBlogTagController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        BlogTagDAO dao = new BlogTagDAO();

        if (relative.equals("/admin/blog-tags")) {
            List<BlogTag> tags = dao.getAllTags();
            request.setAttribute("tags", tags);
            request.setAttribute("pageTitle", "Quản lý Thẻ (Tags)");
            request.getRequestDispatcher("/admin/blog/tags.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/blog-tags/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/blog-tags/delete");
            if (id > 0) {
                dao.deleteTag(id);
                request.getSession().setAttribute("adminFlash", "Đã xóa thẻ bài viết thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
            response.sendRedirect(request.getContextPath() + "/admin/blog-tags");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/blog-tags");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);
        BlogTagDAO dao = new BlogTagDAO();

        if (relative.equals("/admin/blog-tags/update")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String slug = request.getParameter("slug");
                
                if (name != null && !name.trim().isEmpty() && slug != null && !slug.trim().isEmpty()) {
                    BlogTag t = new BlogTag(id, name.trim(), slug.trim());
                    if (dao.updateTag(t)) {
                        request.getSession().setAttribute("adminFlash", "Cập nhật Thẻ thành công.");
                        request.getSession().setAttribute("adminFlashType", "success");
                    } else {
                        request.getSession().setAttribute("adminFlash", "Cập nhật thất bại. (Slug có thể bị trùng)");
                        request.getSession().setAttribute("adminFlashType", "danger");
                    }
                }
            } catch (Exception e) {
                 request.getSession().setAttribute("adminFlash", "Dữ liệu không hợp lệ.");
                 request.getSession().setAttribute("adminFlashType", "danger");
            }
            response.sendRedirect(request.getContextPath() + "/admin/blog-tags");
        }
    }
}
