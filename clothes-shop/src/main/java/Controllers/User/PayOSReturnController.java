package Controllers.User;

import DAO.BillDAO;
import Model.Bill;
import Model.BillDetail;
import Utils.ServletPaths;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "PayOSReturnController", urlPatterns = { "/payos/return" })
public class PayOSReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String idStr = request.getParameter("id");
        String cancel = request.getParameter("cancel");
        String status = request.getParameter("status");
        String orderCode = request.getParameter("orderCode");

        if (orderCode == null || orderCode.trim().isEmpty()) {
            ServletPaths.redirect(request, response, "/home");
            return;
        }

        int billId = 0;
        try {
            billId = Integer.parseInt(orderCode);
        } catch (NumberFormatException e) {
            ServletPaths.redirect(request, response, "/home");
            return;
        }

        BillDAO billDao = new BillDAO();
        Bill bill = billDao.getBillById(billId);

        if (bill == null) {
            ServletPaths.redirect(request, response, "/home");
            return;
        }

        if ("true".equals(cancel) || "CANCELLED".equals(status)) {
            if (bill.getStatus() == 0) {
                billDao.updateStatus(billId, Utils.OrderStatus.CANCELLED);
            }
            request.getSession().setAttribute("checkoutError",
                    "Thanh toán qua PayOS bị hủy hoặc thất bại. Vui lòng thử lại.");
            ServletPaths.redirect(request, response, "/cart");
            return;
        }

        if ("00".equals(code) || "PAID".equals(status)) {
            if (bill.getStatus() == 0) {
                billDao.updateStatus(billId, Utils.OrderStatus.PAID);

                final Bill finalBill = bill;
                new Thread(() -> {
                    try {
                        List<BillDetail> details = billDao.getBillDetails(finalBill.getID());
                        Utils.Email emailSender = new Utils.Email();
                        String htmlContent = Utils.EmailTemplates.getOrderConfirmationTemplate(finalBill, details);
                        emailSender.sendEmail(finalBill.getEmail(),
                                "Xác Nhận Đơn Hàng #" + finalBill.getID() + " - Đã Thanh Toán PayOS", htmlContent,
                                null);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }).start();
            }
            ServletPaths.redirect(request, response, "/checkout/success?id=" + billId);
        } else {
            if (bill.getStatus() == 0) {
                billDao.updateStatus(billId, Utils.OrderStatus.CANCELLED);
            }
            request.getSession().setAttribute("checkoutError", "Thanh toán qua PayOS thất bại. Vui lòng thử lại.");
            ServletPaths.redirect(request, response, "/cart");
        }
    }
}
