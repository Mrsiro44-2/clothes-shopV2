package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import DAO.CartDAO;
import DAO.BillDAO;
import DAO.ProductVariantDAO;
import DAO.ProductDAO;
import DAO.VoucherDAO;
import Model.Account;
import Model.Cart;
import Model.Bill;
import Model.BillDetail;
import Model.ProductVariant;
import Model.Product;
import Model.Voucher;
import Utils.ServletPaths;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CheckoutController", urlPatterns = { "/checkout", "/checkout/success" })
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

        String path = request.getRequestURI();
        AccountDAO accountDao = new AccountDAO();
        Account account = accountDao.getAccountByUsername(username);

        if (path.contains("/checkout/success")) {
            String idStr = request.getParameter("id");
            int billId = 0;
            try {
                billId = Integer.parseInt(idStr);
            } catch (Exception e) {
            }

            if (billId <= 0) {
                ServletPaths.redirect(request, response, "/home");
                return;
            }

            BillDAO billDao = new BillDAO();
            Bill bill = billDao.getBillById(billId);
            if (bill == null || bill.getCustomerID() != account.getID()) {
                ServletPaths.redirect(request, response, "/home");
                return;
            }

            request.setAttribute("bill", bill);
            request.setAttribute("billId", billId);
            request.getRequestDispatcher("/user/checkoutSuccess.jsp").forward(request, response);
            return;
        }

        // Standard GET /checkout
        CartDAO cartDao = new CartDAO();
        List<Cart> carts = cartDao.getAllCart(account.getID());
        if (carts == null || carts.isEmpty()) {
            ServletPaths.redirect(request, response, "/cart");
            return;
        }

        DAO.ShippingAddressDAO addressDao = new DAO.ShippingAddressDAO();
        List<Model.ShippingAddress> addresses = addressDao.getAddressesByAccountId(account.getID());
        request.setAttribute("addresses", addresses);

        float subtotal = 0;
        for (Cart c : carts) {
            subtotal += c.getDisplayUnitPrice() * c.getQuantity();
        }

        // Re-validate and recalculate voucher discount
        HttpSession session = request.getSession();
        String voucherCode = (String) session.getAttribute("appliedVoucherCode");
        float discount = 0;

        if (voucherCode != null) {
            VoucherDAO voucherDao = new VoucherDAO();
            Voucher v = voucherDao.getVoucherByCode(voucherCode);
            boolean valid = true;
            if (v == null || v.getStatus() != 1) {
                valid = false;
            } else {
                Date today = new Date(System.currentTimeMillis());
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
                session.setAttribute("appliedVoucherId", v.getId());
                session.setAttribute("discount", discount);
                session.setAttribute("newTotal", subtotal - discount);
            } else {
                // Clear stale voucher attributes
                session.removeAttribute("appliedVoucherId");
                session.removeAttribute("appliedVoucherCode");
                session.removeAttribute("discount");
                session.removeAttribute("newTotal");
                session.setAttribute("couponStatus", "invalid");
            }
        }

        request.setAttribute("account", account);
        request.setAttribute("carts", carts);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("discount", discount);
        request.setAttribute("total", subtotal - discount);
        request.setAttribute("voucherCode", session.getAttribute("appliedVoucherCode"));

        VoucherDAO voucherDao = new VoucherDAO();
        request.setAttribute("publicVouchers", voucherDao.getPublicVouchers());

        request.getRequestDispatcher("/user/checkout.jsp").forward(request, response);
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

        CartDAO cartDao = new CartDAO();
        List<Cart> carts = cartDao.getAllCart(account.getID());
        if (carts == null || carts.isEmpty()) {
            ServletPaths.redirect(request, response, "/cart");
            return;
        }

        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String detailAddress = request.getParameter("detailAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        String addressIdStr = request.getParameter("shippingAddressID");
        Integer shippingAddressID = null;

        String wardCode = request.getParameter("wardCode");
        Integer districtId = null;
        String districtStr = request.getParameter("districtId");
        if (districtStr != null && !districtStr.isEmpty()) {
            try {
                districtId = Integer.parseInt(districtStr);
            } catch (Exception e) {
            }
        }

        if (addressIdStr != null && !addressIdStr.isEmpty()) {
            try {
                shippingAddressID = Integer.parseInt(addressIdStr);
            } catch (Exception e) {
            }
        }

        if (shippingAddressID != null && shippingAddressID > 0) {
            DAO.ShippingAddressDAO addrDao = new DAO.ShippingAddressDAO();
            Model.ShippingAddress addr = addrDao.getAddressById(shippingAddressID);
            if (addr != null && addr.getAccountID() == account.getID()) {
                customerName = addr.getFullName();
                phone = addr.getPhone();
                address = addr.getAddress();
                detailAddress = addr.getDetailAddress();
                wardCode = addr.getWardCode();
                districtId = addr.getDistrictId();
            } else {
                shippingAddressID = null;
            }
        }

        if (customerName == null || customerName.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                address == null || address.trim().isEmpty()) {

            request.getSession().setAttribute("checkoutError", "Vui lòng nhập đầy đủ thông tin giao hàng.");
            ServletPaths.redirect(request, response, "/checkout");
            return;
        }

        float subtotal = 0;
        for (Cart c : carts) {
            subtotal += c.getDisplayUnitPrice() * c.getQuantity();
        }

        HttpSession session = request.getSession();
        String voucherCode = (String) session.getAttribute("appliedVoucherCode");
        Integer voucherId = (Integer) session.getAttribute("appliedVoucherId");
        float discount = 0;

        VoucherDAO voucherDao = new VoucherDAO();
        if (voucherCode != null && voucherId != null) {
            Voucher v = voucherDao.getVoucherByCode(voucherCode);
            if (v != null && v.getStatus() == 1) {
                Date today = new Date(System.currentTimeMillis());
                boolean valid = !today.before(v.getStart()) && !today.after(v.getEnd())
                        && (v.getUsageLimit() == null || v.getUsed() < v.getUsageLimit())
                        && subtotal >= v.getMinOrderAmount()
                        && !voucherDao.hasUserUsedVoucher(v.getId(), account.getID());

                if (valid) {
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
                } else {
                    // Voucher no longer valid — clear it
                    voucherId = null;
                    voucherCode = null;
                }
            }
        }

        float total = subtotal - discount;

        Bill bill = new Bill();
        bill.setCustomerID(account.getID());
        bill.setEmail(email.trim());
        bill.setCustomerName(customerName.trim());
        bill.setPhone(phone.trim());
        bill.setAddress(address.trim());
        bill.setDetailAddress(detailAddress != null ? detailAddress.trim() : null);
        bill.setSubtotal(subtotal);
        bill.setDiscountAmount(discount);
        bill.setVoucherID(discount > 0 ? voucherId : null);
        bill.setVoucherCodeSnapshot(discount > 0 ? voucherCode : null);
        bill.setTotal(total);
        bill.setStatus(0); // 0 = Chờ xử lý (Pending)
        bill.setPayment("payos".equals(paymentMethod) ? 1 : 0);
        bill.setShippingAddressID(shippingAddressID);
        bill.setWardCode(wardCode);
        bill.setDistrictId(districtId);
        bill.setDateOrder(new Timestamp(System.currentTimeMillis()));
        bill.setDateUpdate(new Timestamp(System.currentTimeMillis()));
        bill.setTransactionCode("payos".equals(paymentMethod) ? "PAYOS" + System.currentTimeMillis() : null);

        ProductVariantDAO variantDao = new ProductVariantDAO();
        ProductDAO productDao = new ProductDAO();
        List<BillDetail> details = new ArrayList<>();

        for (Cart c : carts) {
            ProductVariant pv = variantDao.findById(c.getProductVariantID());
            Product p = productDao.getProductByID(c.getProductID());

            // Check stock availability
            if (pv == null || pv.getQuantity() < c.getQuantity()) {
                request.getSession().setAttribute("checkoutError",
                        "Sản phẩm " + c.getProductName() + " đã hết hàng hoặc không đủ tồn kho.");
                ServletPaths.redirect(request, response, "/cart");
                return;
            }

            BillDetail detail = new BillDetail();
            detail.setProductVariantID(c.getProductVariantID());
            detail.setProductID(c.getProductID());
            detail.setSkuSnapshot(pv != null && pv.getSku() != null ? pv.getSku() : "N/A");
            detail.setNameProduct(c.getProductName());
            detail.setModelProduct(p != null ? p.getModel() : "");
            detail.setImgProduct(c.getMainImg());
            detail.setSizeLabelSnapshot(c.getSizeLabel());
            detail.setColorLabelSnapshot(c.getColorName());
            detail.setPriceProduct(c.getDisplayUnitPrice());
            detail.setNumberOfProduct(c.getQuantity());
            details.add(detail);
        }

        BillDAO billDao = new BillDAO();
        int newBillId = billDao.createOrder(bill, details);

        if (newBillId > 0) {
            bill.setID(newBillId);

            if (!"payos".equals(paymentMethod)) {
                final String customerEmail = bill.getEmail();
                final Bill finalBill = bill;
                final List<BillDetail> finalDetails = new ArrayList<>(details);
                new Thread(() -> {
                    Utils.Email emailSender = new Utils.Email();
                    String htmlContent = Utils.EmailTemplates.getOrderConfirmationTemplate(finalBill, finalDetails);
                    emailSender.sendEmail(customerEmail, "Xác Nhận Đơn Hàng #" + newBillId + " - Clothing Shop",
                            htmlContent, null);
                }).start();
            }

            session.removeAttribute("appliedVoucherId");
            session.removeAttribute("appliedVoucherCode");
            session.removeAttribute("discount");
            session.removeAttribute("newTotal");
            session.removeAttribute("couponStatus");

            if ("payos".equals(paymentMethod)) {
                try {
                    String checkoutUrl = Utils.PayOSUtils.createPaymentLink(newBillId, (int) total,
                            "Thanh toan don " + newBillId);
                    response.sendRedirect(checkoutUrl);
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    request.getSession().setAttribute("checkoutError", "Lỗi khởi tạo PayOS: " + e.getMessage());
                    ServletPaths.redirect(request, response, "/checkout");
                    return;
                }
            }

            ServletPaths.redirect(request, response, "/checkout/success?id=" + newBillId);
        } else if (newBillId == -1) {
            request.getSession().setAttribute("checkoutError", "Mã giảm giá bạn chọn đã hết lượt sử dụng trong tích tắc. Vui lòng thử lại!");
            ServletPaths.redirect(request, response, "/checkout");
        } else {
            request.getSession().setAttribute("checkoutError", "Có lỗi xảy ra khi tạo đơn hàng. Vui lòng thử lại.");
            ServletPaths.redirect(request, response, "/checkout");
        }
    }
}
