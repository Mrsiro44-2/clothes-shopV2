package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import DAO.CartDAO;
import DAO.VoucherDAO;
import Model.Account;
import Model.Cart;
import Model.Voucher;
import Utils.ServletPaths;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "VoucherController", urlPatterns = { "/voucher" })
public class VoucherController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        clearVoucherSession(session);
        session.removeAttribute("couponStatus");

        String from = request.getParameter("from");
        String referer = request.getHeader("Referer");
        if ("checkout".equals(from) || (referer != null && referer.contains("/checkout"))) {
            ServletPaths.redirect(request, response, "/checkout");
        } else {
            ServletPaths.redirect(request, response, "/cart");
        }
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

        HttpSession session = request.getSession();
        String couponCode = request.getParameter("couponCode");

        session.removeAttribute("couponStatus");

        if (couponCode == null || couponCode.trim().isEmpty()) {
            clearVoucherSession(session);
            redirectBack(request, response);
            return;
        }

        couponCode = couponCode.trim();

        AccountDAO accountDao = new AccountDAO();
        CartDAO cartDao = new CartDAO();
        VoucherDAO voucherDao = new VoucherDAO();

        Account account = accountDao.getAccountByUsername(username);
        List<Cart> carts = cartDao.getAllCart(account.getID());

        float subtotal = 0;
        for (Cart c : carts) {
            subtotal += c.getDisplayUnitPrice() * c.getQuantity();
        }

        Voucher v = voucherDao.getVoucherByCode(couponCode);
        if (v == null) {
            v = voucherDao.getVoucherByCode("PUB_" + couponCode);
        }
        if (v == null) {
            v = voucherDao.getVoucherByCode("PRI_" + couponCode);
        }

        if (v == null || v.getStatus() != 1) {
            clearVoucherSession(session);
            session.setAttribute("couponStatus", "invalid");
            redirectBack(request, response);
            return;
        }

        Date today = new Date(System.currentTimeMillis());
        if (today.before(v.getStart()) || today.after(v.getEnd())) {
            clearVoucherSession(session);
            session.setAttribute("couponStatus", "expired");
            redirectBack(request, response);
            return;
        }

        if (v.getUsageLimit() != null && v.getUsed() >= v.getUsageLimit()) {
            clearVoucherSession(session);
            session.setAttribute("couponStatus", "expired");
            redirectBack(request, response);
            return;
        }

        if (voucherDao.hasUserUsedVoucher(v.getId(), account.getID())) {
            clearVoucherSession(session);
            session.setAttribute("couponStatus", "already_used");
            redirectBack(request, response);
            return;
        }

        if (subtotal < v.getMinOrderAmount()) {
            clearVoucherSession(session);
            session.setAttribute("couponStatus", "min_order");
            session.setAttribute("couponMinAmount", v.getMinOrderAmount());
            redirectBack(request, response);
            return;
        }

        float discount = 0;
        if (v.getDiscountType() == 0) {
            discount = v.getValue();
        } else if (v.getDiscountType() == 1) {
            discount = subtotal * (v.getValue() / 100.0f);
            if (v.getMaxDiscount() != null && discount > v.getMaxDiscount()) {
                discount = v.getMaxDiscount();
            }
        }

        if (discount > subtotal) {
            discount = subtotal;
        }

        session.setAttribute("couponStatus", "applied");
        session.setAttribute("appliedVoucherId", v.getId());
        session.setAttribute("appliedVoucherCode", v.getCode());
        session.setAttribute("discount", discount);
        session.setAttribute("newTotal", subtotal - discount);

        redirectBack(request, response);
    }

    private void redirectBack(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String from = request.getParameter("from");
        if ("checkout".equals(from)) {
            ServletPaths.redirect(request, response, "/checkout");
        } else {
            ServletPaths.redirect(request, response, "/cart");
        }
    }

    private void clearVoucherSession(HttpSession session) {
        session.removeAttribute("appliedVoucherId");
        session.removeAttribute("appliedVoucherCode");
        session.removeAttribute("discount");
        session.removeAttribute("newTotal");
        session.removeAttribute("couponMinAmount");
    }
}
