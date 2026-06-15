package Controllers.Admin;

import DAO.AccountDAO;
import DAO.BlogCommentDAO;
import DAO.BlogPostDAO;
import Model.Account;
import Model.BlogComment;
import Model.BlogPost;
import Utils.ServletPaths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminBlogCommentController", urlPatterns = {"/admin/blog-comments/*"})
public class AdminBlogCommentController extends HttpServlet {

    private BlogCommentDAO commentDao;
    private BlogPostDAO postDao;
    private AccountDAO accDao;

    @Override
    public void init() throws ServletException {
        commentDao = new BlogCommentDAO();
        postDao = new BlogPostDAO();
        accDao = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.startsWith("/admin/blog-comments/approve/")) {
            int id = ServletPaths.idAfter(request, "/admin/blog-comments/approve");
            if (id > 0) {
                commentDao.updateStatus(id, 1);
                request.getSession().setAttribute("adminFlash", "Đã duyệt bình luận thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
            response.sendRedirect(request.getContextPath() + "/admin/blog-comments");
            return;
        }

        if (relative.startsWith("/admin/blog-comments/hide/")) {
            int id = ServletPaths.idAfter(request, "/admin/blog-comments/hide");
            if (id > 0) {
                commentDao.updateStatus(id, 0); // 0 or another status for hidden
                request.getSession().setAttribute("adminFlash", "Đã ẩn bình luận.");
                request.getSession().setAttribute("adminFlashType", "warning");
            }
            response.sendRedirect(request.getContextPath() + "/admin/blog-comments");
            return;
        }

        if (relative.startsWith("/admin/blog-comments/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/blog-comments/delete");
            if (id > 0) {
                commentDao.delete(id);
                request.getSession().setAttribute("adminFlash", "Đã xoá bình luận.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
            response.sendRedirect(request.getContextPath() + "/admin/blog-comments");
            return;
        }

        // List comments
        int page = 1;
        int limit = 15;
        Integer blogPostId = null;
        Integer accountId = null;
        Integer status = -1; // -1 for all
        String keyword = request.getParameter("keyword");
        
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            if (request.getParameter("limit") != null) {
                limit = Integer.parseInt(request.getParameter("limit"));
            }
            if (request.getParameter("blogPostId") != null && !request.getParameter("blogPostId").isEmpty()) {
                blogPostId = Integer.parseInt(request.getParameter("blogPostId"));
            }
            if (request.getParameter("accountId") != null && !request.getParameter("accountId").isEmpty()) {
                accountId = Integer.parseInt(request.getParameter("accountId"));
            }
            if (request.getParameter("status") != null && !request.getParameter("status").isEmpty()) {
                status = Integer.parseInt(request.getParameter("status"));
            }
        } catch (NumberFormatException e) {}

        int offset = (page - 1) * limit;
        int total = commentDao.countAll(blogPostId, keyword, accountId, status);
        int totalPages = (int) Math.ceil((double) total / limit);

        List<BlogComment> comments = commentDao.getAll(limit, offset, blogPostId, keyword, accountId, status);

        request.setAttribute("comments", comments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("limit", limit);
        request.setAttribute("currentBlogPostId", blogPostId);
        request.setAttribute("currentAccountId", accountId);
        request.setAttribute("currentStatus", status);
        request.setAttribute("keyword", keyword);
        
        DAO.BlogPostDAO bpDao = new DAO.BlogPostDAO();
        request.setAttribute("blogPosts", bpDao.listAllForAdmin());
        
        request.setAttribute("accounts", accDao.allAccountByStaff());

        request.getRequestDispatcher("/admin/blog/comments.jsp").forward(request, response);
    }
}
