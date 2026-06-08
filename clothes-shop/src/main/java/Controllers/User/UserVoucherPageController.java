package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import DAO.VoucherDAO;
import Model.Account;
import Model.Voucher;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UserVoucherPageController", urlPatterns = { "/voucher-hub" })
public class UserVoucherPageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        if (username != null) {
            AccountDAO accountDao = new AccountDAO();
            Account account = accountDao.getAccountByUsername(username);
            request.setAttribute("account", account);
        }

        VoucherDAO voucherDao = new VoucherDAO();
        List<Voucher> publicVouchers = voucherDao.getPublicVouchers();

        request.setAttribute("vouchers", publicVouchers);
        request.setAttribute("pageTitle", "Kho Voucher");

        request.getRequestDispatcher("/user/vouchers.jsp").forward(request, response);
    }
}
