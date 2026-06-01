package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import DAO.CartDAO;
import Model.Account;
import Model.Cart;
import Utils.ServletPaths;
import Utils.SwalFlash;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        if (username == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }

        Account account = new AccountDAO().getAccountByUsername(username);
        if (account == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }

        List<Cart> carts = new CartDAO().getAllCart(account.getID());
        request.setAttribute("account", account);
        request.setAttribute("carts", carts);
        request.getRequestDispatcher("/user/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SwalFlash.errorSession(request.getSession(), "Thanh toán", "Backend tạo đơn chưa được cấu hình.");
        ServletPaths.redirect(request, response, "/checkout");
    }
}
