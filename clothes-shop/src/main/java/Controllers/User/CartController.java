/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import DAO.CartDAO;
import DAO.ProductVariantDAO;
import Model.Account;
import Model.Cart;
import Model.ProductVariant;
import Model.Voucher;
import DAO.VoucherDAO;
import Utils.ServletPaths;
import jakarta.servlet.http.HttpSession;
import Utils.Validation;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Enumeration;
import java.util.List;

@WebServlet(name = "CartController", urlPatterns = {"/cart/*"})
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        AccountDAO accountDao = new AccountDAO();
        CartDAO cartDao = new CartDAO();
        String path = request.getRequestURI();
        if (ServletPaths.relativeEquals(request, "/cart")) {
            if (username != null) {
                Account account = accountDao.getAccountByUsername(username);
                List<Cart> carts = cartDao.getAllCart(account.getID());
                request.setAttribute("carts", carts);
                request.getRequestDispatcher("./user/cart.jsp").forward(request, response);
            } else {
                ServletPaths.redirect(request, response, "/login");
            }
        } else if (path.contains("/cart/add")) {
            this.addToCart(request, response);
        } else if (path.contains("/cart/remove")) {
            this.removeFromCart(request, response);
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            AuthUser auth = new AuthUser();
            String username = auth.isLoginUser(request, response);
            if (username != null) {
                CartDAO cartDao = new CartDAO();
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                int result = cartDao.deleteCartItem(cartId);
                recalculateVoucher(request);
                ServletPaths.redirect(request, response, "/cart?act=remove-cart&status=" + result);
            } else {
                ServletPaths.redirect(request, response, "/login");
            }
        } catch (Exception e) {
            System.out.println("removeFromCart: " + e);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Validation validate = new Validation();
            AuthUser auth = new AuthUser();
            String username = auth.isLoginUser(request, response);
            if (username == null) {
                ServletPaths.redirect(request, response, "/login");
                return;
            }
            CartDAO cartDao = new CartDAO();
            ProductVariantDAO variantDao = new ProductVariantDAO();
            AccountDAO accountDao = new AccountDAO();
            Account account = accountDao.getAccountByUsername(username);
            int accountId = account.getID();
            int quantity = validate.getInt(request.getParameter("quantity"));
            if (quantity <= 0) {
                quantity = 1;
            }
            int variantId = validate.getInt(request.getParameter("productVariantID"));
            if (variantId <= 0) {
                int productId = validate.getInt(request.getParameter("productID"));
                if (productId > 0) {
                    ProductVariant fallback = variantDao.findDefaultOrFirst(productId);
                    if (fallback != null) {
                        variantId = fallback.getID();
                    }
                }
            }
            String path = request.getParameter("pathUrl");
            if (validate.isBlank(path)) {
                path = ServletPaths.url(request, "/");
            }
            if (variantId <= 0) {
                response.sendRedirect(path + "?act=add-cart&status=0");
                return;
            }
            ProductVariant pv = variantDao.findById(variantId);
            int result = 0;
            if (pv == null || pv.getStatus() != 1) {
                result = 0;
            } else {
                Cart exist = cartDao.getByAccountAndVariant(accountId, variantId);
                if (exist != null) {
                    int newQty = exist.getQuantity() + quantity;
                    if (newQty > pv.getQuantity()) {
                        result = 2;
                    } else {
                        exist.setQuantity(newQty);
                        result = cartDao.updateToCart(exist) > 0 ? 1 : 0;
                    }
                } else {
                    if (quantity > pv.getQuantity()) {
                        result = 2;
                    } else {
                        Cart c = new Cart(0, accountId, quantity, variantId);
                        result = cartDao.addToCart(c) > 0 ? 1 : 0;
                    }
                }
            }
            response.sendRedirect(path + "?act=add-cart&status=" + result);
        } catch (Exception e) {
            System.out.println("addToCart: " + e);
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Validation validate = new Validation();
            AuthUser auth = new AuthUser();
            String username = auth.isLoginUser(request, response);
            if (username == null) {
                ServletPaths.redirect(request, response, "/login");
                return;
            }
            CartDAO cartDao = new CartDAO();
            ProductVariantDAO variantDao = new ProductVariantDAO();
            AccountDAO accountDao = new AccountDAO();
            Account account = accountDao.getAccountByUsername(username);
            int accountId = account.getID();
            Enumeration<String> parameterNames = request.getParameterNames();
            int result = 1;
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                if (paramName.startsWith("qty_v_")) {
                    int variantId = validate.getInt(paramName.substring("qty_v_".length()));
                    int quantity = validate.getInt(request.getParameter(paramName));
                    ProductVariant pv = variantDao.findById(variantId);
                    Cart cartExist = cartDao.getByAccountAndVariant(accountId, variantId);
                    if (pv != null && cartExist != null) {
                        quantity = validate.clampQty(quantity, pv.getQuantity());
                        cartExist.setQuantity(quantity);
                        cartDao.updateToCart(cartExist);
                    }
                }
            }
            recalculateVoucher(request);
            ServletPaths.redirect(request, response, "/cart?act=update-cart&status=" + result);
        } catch (Exception e) {
            System.out.println("updateCart: " + e);
        }
    }

    private void recalculateVoucher(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String voucherCode = (String) session.getAttribute("appliedVoucherCode");
        if (voucherCode != null) {
            AuthUser auth = new AuthUser();
            String username = auth.isLoginUser(request, null);
            if (username != null) {
                AccountDAO accountDao = new AccountDAO();
                Account account = accountDao.getAccountByUsername(username);
                CartDAO cartDao = new CartDAO();
                List<Cart> carts = cartDao.getAllCart(account.getID());
                float subtotal = 0;
                for (Cart c : carts) {
                    subtotal += c.getDisplayUnitPrice() * c.getQuantity();
                }
                
                VoucherDAO voucherDao = new VoucherDAO();
                Voucher v = voucherDao.getVoucherByCode(voucherCode);
                boolean valid = true;
                if (v == null || v.getStatus() != 1) {
                    valid = false;
                } else {
                    java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
                    if (today.before(v.getStart()) || today.after(v.getEnd())) {
                        valid = false;
                    }
                    if (v.getUsageLimit() != null && v.getUsed() >= v.getUsageLimit()) {
                        valid = false;
                    }
                    if (subtotal < v.getMinOrderAmount()) {
                        valid = false;
                    }
                }

                if (valid) {
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
                    session.setAttribute("discount", discount);
                    session.setAttribute("newTotal", subtotal - discount);
                    session.setAttribute("couponStatus", "applied");
                } else {
                    session.removeAttribute("appliedVoucherId");
                    session.removeAttribute("appliedVoucherCode");
                    session.removeAttribute("discount");
                    session.removeAttribute("newTotal");
                    session.setAttribute("couponStatus", "invalid");
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getParameter("add-to-cart") != null) {
            this.addToCart(request, response);
        } else if (request.getParameter("btn-update-cart") != null) {
            this.updateCart(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Cart";
    }
}
