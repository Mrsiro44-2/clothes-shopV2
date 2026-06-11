package Controllers.Admin;

import DAO.BillDAO;
import Model.Bill;
import Model.BillDetail;
import Utils.ServletPaths;
import Utils.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/admin/orders/*"})
public class AdminOrderController extends HttpServlet {

    private BillDAO billDao;
    private Validation validate;
    private DAO.AccountDAO accountDao;

    @Override
    public void init() throws ServletException {
        billDao = new BillDAO();
        validate = new Validation();
        accountDao = new DAO.AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/orders") || relative.equals("/admin/orders/")) {
            String q = request.getParameter("q");
            String status = request.getParameter("status");
            String sort = request.getParameter("sort");
            String customerID = request.getParameter("customerID");
            int page = 1;
            if (request.getParameter("page") != null) {
                try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
            }
            int limit = 10;
            if (request.getParameter("limit") != null) {
                try { limit = Integer.parseInt(request.getParameter("limit")); } catch (Exception e) {}
            }
            int totalRows = billDao.count(q, status, customerID);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.Bill> orders = billDao.getPaginated(q, status, customerID, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("customerID", customerID);
            request.setAttribute("sort", sort);
            request.setAttribute("orders", orders);
            request.setAttribute("customers", accountDao.allAccountByStaff());
            request.setAttribute("isOrder", true);
            request.setAttribute("pageTitle", "Quản lý đơn hàng");
            request.getRequestDispatcher("/admin/order/index.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/orders/detail/")) {
            int id = ServletPaths.idAfter(request, "/admin/orders/detail");
            if (id <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            Bill order = billDao.getBillById(id);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            List<BillDetail> details = billDao.getBillDetails(id);
            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.setAttribute("pageTitle", "Chi tiết đơn hàng #" + id);
            request.getRequestDispatcher("/admin/order/detail.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        if (relative.startsWith("/admin/orders/update-status/")) {
            int id = ServletPaths.idAfter(request, "/admin/orders/update-status");
            int status = validate.getInt(request.getParameter("status"));

            if (id > 0 && status >= 0 && status <= 5) {
                boolean success = billDao.updateStatus(id, status);
                if (success) {
                    request.getSession().setAttribute("adminFlash", "Đã cập nhật trạng thái đơn hàng #" + id + " thành công.");
                    request.getSession().setAttribute("adminFlashType", "success");
                } else {
                    request.getSession().setAttribute("adminFlash", "Cập nhật trạng thái thất bại.");
                    request.getSession().setAttribute("adminFlashType", "danger");
                }
            } else {
                request.getSession().setAttribute("adminFlash", "Trạng thái không hợp lệ.");
                request.getSession().setAttribute("adminFlashType", "danger");
            }
            response.sendRedirect(request.getContextPath() + "/admin/orders/detail/" + id);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}
