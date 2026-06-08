package Controllers.Admin;

import DAO.AccountDAO;
import DAO.FeedbackDAO;
import DAO.ProductDAO;
import Model.Feedback;
import Utils.ServletPaths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminFeedbackController", urlPatterns = {"/admin/feedbacks/*"})
public class AdminFeedbackController extends HttpServlet {

    private FeedbackDAO feedbackDao;
    private AccountDAO accDao;
    private ProductDAO productDao;

    @Override
    public void init() throws ServletException {
        feedbackDao = new FeedbackDAO();
        accDao = new AccountDAO();
        productDao = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.startsWith("/admin/feedbacks/approve/")) {
            int id = ServletPaths.idAfter(request, "/admin/feedbacks/approve");
            if (id > 0) {
                feedbackDao.updateStatus(id, 1);
                request.getSession().setAttribute("adminFlash", "Đã duyệt đánh giá thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
            response.sendRedirect(request.getContextPath() + "/admin/feedbacks");
            return;
        }

        if (relative.startsWith("/admin/feedbacks/hide/")) {
            int id = ServletPaths.idAfter(request, "/admin/feedbacks/hide");
            if (id > 0) {
                feedbackDao.updateStatus(id, 0); // 0 or another status for hidden
                request.getSession().setAttribute("adminFlash", "Đã ẩn đánh giá.");
                request.getSession().setAttribute("adminFlashType", "warning");
            }
            response.sendRedirect(request.getContextPath() + "/admin/feedbacks");
            return;
        }

        if (relative.startsWith("/admin/feedbacks/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/feedbacks/delete");
            if (id > 0) {
                feedbackDao.delete(id);
                request.getSession().setAttribute("adminFlash", "Đã xoá đánh giá.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
            response.sendRedirect(request.getContextPath() + "/admin/feedbacks");
            return;
        }

        // List feedbacks
        int page = 1;
        int limit = 15;
        Integer productId = null;
        String keyword = request.getParameter("keyword");
        
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            if (request.getParameter("limit") != null) {
                limit = Integer.parseInt(request.getParameter("limit"));
            }
            if (request.getParameter("productId") != null && !request.getParameter("productId").isEmpty()) {
                productId = Integer.parseInt(request.getParameter("productId"));
            }
        } catch (NumberFormatException e) {}

        int offset = (page - 1) * limit;
        int total = feedbackDao.countAll(productId, keyword);
        int totalPages = (int) Math.ceil((double) total / limit);

        List<Feedback> feedbacks = feedbackDao.getAll(limit, offset, productId, keyword);

        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("limit", limit);
        request.setAttribute("currentProductId", productId);
        request.setAttribute("keyword", keyword);
        request.setAttribute("products", productDao.getAll());

        request.getRequestDispatcher("/admin/product/feedbacks.jsp").forward(request, response);
    }
}
