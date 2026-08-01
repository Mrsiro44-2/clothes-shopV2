package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import DAO.BillDAO;
import DAO.FeedbackDAO;
import DAO.ProductVariantDAO;
import Model.Account;
import Model.Bill;
import Model.BillDetail;
import Model.Feedback;
import Model.ReviewableProduct;
import Utils.ServletPaths;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "OrdersController", urlPatterns = {"/orders", "/orders/detail", "/orders/cancel", "/orders/review"})
public class OrdersController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        if (username == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }

        AccountDAO accountDao = new AccountDAO();
        Account account = accountDao.getAccountByUsername(username);
        String path = request.getRequestURI();

        BillDAO billDao = new BillDAO();

        if (path.contains("/orders/detail")) {
            String idStr = request.getParameter("id");
            int orderId = 0;
            try {
                orderId = Integer.parseInt(idStr);
            } catch (Exception e) {}

            if (orderId <= 0) {
                ServletPaths.redirect(request, response, "/orders");
                return;
            }

            Bill order = billDao.getBillById(orderId);
            if (order == null || order.getCustomerID() != account.getID()) {
                ServletPaths.redirect(request, response, "/orders");
                return;
            }

            List<BillDetail> details = billDao.getBillDetails(orderId);
            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.getRequestDispatcher("/user/orderDetail.jsp").forward(request, response);
            return;

        } else if (path.contains("/orders/cancel")) {
            // Cancel moved to POST
            ServletPaths.redirect(request, response, "/orders");
            return;
        }

        // Default: GET /orders list
        String tab = request.getParameter("tab");
        if (tab == null || tab.trim().isEmpty()) {
            tab = "all";
        }

        if ("reviews".equals(tab)) {
            FeedbackDAO feedbackDao = new FeedbackDAO();
            List<Feedback> myReviews = feedbackDao.findByUser(account.getID());
            
            // Get all reviewable products (bought in completed orders, and not reviewed yet)
            List<ReviewableProduct> reviewableProducts = new ArrayList<>();
            // Retrieve status 3 = Completed orders
            List<Bill> completedBills = billDao.getPaginated(null, Utils.OrderStatus.COMPLETED + "", String.valueOf(account.getID()), "newest", 1, 100);
            for (Bill b : completedBills) {
                List<BillDetail> details = billDao.getBillDetails(b.getID());
                for (BillDetail d : details) {
                    boolean alreadyReviewed = feedbackDao.hasUserReviewedProduct(account.getID(), d.getProductID());
                    if (!alreadyReviewed) {
                        boolean duplicate = false;
                        for (ReviewableProduct rp : reviewableProducts) {
                            if (rp.getProductId() == d.getProductID() && rp.getBillId() == b.getID()) {
                                duplicate = true;
                                break;
                            }
                        }
                        if (!duplicate) {
                            ReviewableProduct rp = new ReviewableProduct();
                            rp.setProductId(d.getProductID());
                            rp.setProductName(d.getNameProduct());
                            rp.setBillId(b.getID());
                            rp.setImgProduct(d.getImgProduct());
                            reviewableProducts.add(rp);
                        }
                    }
                }
            }

            request.setAttribute("myReviews", myReviews);
            request.setAttribute("reviewableProducts", reviewableProducts);
        } else {
            String statusFilter = null;
            if ("cancelled".equals(tab)) {
                statusFilter = "2,7"; 
            }
            List<Bill> orders = billDao.getPaginated(null, statusFilter, String.valueOf(account.getID()), "newest", 1, 100);
            request.setAttribute("orders", orders);
        }

        request.setAttribute("tab", tab);
        request.getRequestDispatcher("/user/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        if (username == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        AccountDAO accountDao = new AccountDAO();
        Account account = accountDao.getAccountByUsername(username);
        String path = request.getRequestURI();

        if (path.contains("/orders/review")) {
            String productIdStr = request.getParameter("productId");
            String starStr = request.getParameter("star");
            String comment = request.getParameter("comment");

            int productId = 0;
            int star = 5;
            try {
                productId = Integer.parseInt(productIdStr);
                star = Integer.parseInt(starStr);
            } catch (Exception e) {}

            if (productId > 0 && comment != null && !comment.trim().isEmpty()) {
                FeedbackDAO feedbackDao = new FeedbackDAO();
                // Check eligibility: user has completed order for this product and has not reviewed it
                BillDAO billDao = new BillDAO();
                List<Bill> completedBills = billDao.getPaginated(null, "3", String.valueOf(account.getID()), "newest", 1, 100);
                boolean eligible = false;
                for (Bill b : completedBills) {
                    List<BillDetail> details = billDao.getBillDetails(b.getID());
                    for (BillDetail d : details) {
                        if (d.getProductID() == productId) {
                            eligible = true;
                            break;
                        }
                    }
                    if (eligible) break;
                }

                boolean alreadyReviewed = feedbackDao.hasUserReviewedProduct(account.getID(), productId);
                if (eligible) {
                    if (alreadyReviewed) {
                        feedbackDao.updateUserFeedback(account.getID(), productId, star, comment.trim());
                        request.getSession().setAttribute("orderFlash", "Cập nhật đánh giá sản phẩm thành công.");
                        request.getSession().setAttribute("orderFlashType", "success");
                    } else {
                        Feedback f = new Feedback();
                        f.setUserID(account.getID());
                        f.setProductID(productId);
                        f.setFeedback(comment.trim());
                        f.setStar(star);
                        f.setStatus(1); // 1 = Active/Approved
                        f.setDatePost(new Timestamp(System.currentTimeMillis()));
                        feedbackDao.insert(f);
                        request.getSession().setAttribute("orderFlash", "Đánh giá sản phẩm thành công.");
                        request.getSession().setAttribute("orderFlashType", "success");
                    }
                } else {
                    request.getSession().setAttribute("orderFlash", "Bạn không đủ điều kiện đánh giá sản phẩm này.");
                    request.getSession().setAttribute("orderFlashType", "danger");
                }
            }
            ServletPaths.redirect(request, response, "/orders?tab=reviews");
        } else if (path.contains("/orders/cancel")) {
            String idStr = request.getParameter("id");
            String cancelReason = request.getParameter("cancelReason");
            if ("Lý do khác".equals(cancelReason)) {
                String otherReason = request.getParameter("cancelReasonOther");
                if (otherReason != null && !otherReason.trim().isEmpty()) {
                    cancelReason = "Lý do khác: " + otherReason.trim();
                }
            }
            if (cancelReason == null || cancelReason.trim().isEmpty()) {
                cancelReason = "Lý do khác";
            }
            int orderId = 0;
            try {
                orderId = Integer.parseInt(idStr);
            } catch (Exception e) {}

            if (orderId > 0) {
                BillDAO billDao = new BillDAO();
                Bill order = billDao.getBillById(orderId);
                if (order != null && order.getCustomerID() == account.getID() && order.getStatus() == 0) {
                    boolean updated = billDao.updateStatusWithReason(orderId, Utils.OrderStatus.CANCELLED, cancelReason.trim());
                    if (updated) {
                        request.getSession().setAttribute("orderFlash", "Đã hủy đơn hàng #" + orderId + " thành công.");
                        request.getSession().setAttribute("orderFlashType", "success");
                    } else {
                        request.getSession().setAttribute("orderFlash", "Hủy đơn hàng thất bại.");
                        request.getSession().setAttribute("orderFlashType", "danger");
                    }
                }
            }
            ServletPaths.redirect(request, response, "/orders?tab=cancelled");
        }
    }
}
