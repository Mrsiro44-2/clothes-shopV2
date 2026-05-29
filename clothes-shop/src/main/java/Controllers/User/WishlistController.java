package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import DAO.ProductVariantDAO;
import DAO.WishlistDAO;
import Model.Account;
import Model.ProductVariant;
import Utils.SwalFlash;
import Utils.ServletPaths;
import Utils.Validation;
import Utils.WishlistLib;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "WishlistController", urlPatterns = {"/wishlist", "/wishlist/add", "/wishlist/remove"})
public class WishlistController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        if (path.contains("/wishlist/remove")) {
            remove(request, response);
            return;
        }
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        if (username == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }
        Account account = new AccountDAO().getAccountByUsername(username);
        request.setAttribute("items", new WishlistDAO().findByAccount(account.getID()));
        request.getRequestDispatcher("/user/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        if (path.contains("/wishlist/add")) {
            add(request, response);
        } else {
            ServletPaths.redirect(request, response, "/wishlist");
        }
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws IOException {
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        String back = request.getParameter("pathUrl");
        if (back == null || back.isEmpty()) {
            back = ServletPaths.url(request, "/wishlist");
        }
        if (username == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }
        Validation v = new Validation();
        int variantId = v.getInt(request.getParameter("productVariantID"));
        if (variantId <= 0) {
            int productId = v.getInt(request.getParameter("productID"));
            if (productId > 0) {
                ProductVariant fallback = new ProductVariantDAO().findDefaultOrFirst(productId);
                if (fallback != null) {
                    variantId = fallback.getID();
                }
            }
        }
        if (variantId <= 0) {
            SwalFlash.errorSession(request.getSession(), "Yêu thích", "Chọn phiên bản sản phẩm.");
            response.sendRedirect(back);
            return;
        }
        ProductVariant pv = new ProductVariantDAO().findById(variantId);
        if (pv == null) {
            SwalFlash.errorSession(request.getSession(), "Yêu thích", "Sản phẩm không tồn tại.");
            response.sendRedirect(back);
            return;
        }
        Account account = new AccountDAO().getAccountByUsername(username);
        int r = new WishlistDAO().add(account.getID(), variantId);
        if (r > 0) {
            SwalFlash.successSession(request.getSession(), "Yêu thích", "Đã thêm vào danh sách yêu thích.");
        } else {
            SwalFlash.errorSession(request.getSession(), "Yêu thích", "Không thể thêm vào yêu thích.");
        }
        WishlistLib.clearRequestCache(request);
        response.sendRedirect(back);
    }

    private void remove(HttpServletRequest request, HttpServletResponse response) throws IOException {
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        if (username == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }
        Validation v = new Validation();
        int id = v.getInt(request.getParameter("id"));
        Account account = new AccountDAO().getAccountByUsername(username);
        new WishlistDAO().remove(account.getID(), id);
        WishlistLib.clearRequestCache(request);
        String back = request.getParameter("pathUrl");
        if (back != null && !back.isEmpty()) {
            response.sendRedirect(back);
        } else {
            ServletPaths.redirect(request, response, "/wishlist");
        }
    }
}
