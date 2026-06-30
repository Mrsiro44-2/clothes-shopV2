package Controllers.Admin;

import DAO.AccountDAO;
import DAO.BillDAO;
import DAO.VoucherDAO;
import Model.Voucher;
import Utils.Email;
import Utils.ServletPaths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@WebServlet(name = "AdminMarketingController", urlPatterns = { "/admin/marketing/*" })
public class AdminMarketingController extends HttpServlet {

    private VoucherDAO voucherDao;
    private AccountDAO accountDao;
    private BillDAO billDao;
    private static final ExecutorService executor = Executors.newFixedThreadPool(2);

    @Override
    public void init() throws ServletException {
        voucherDao = new VoucherDAO();
        accountDao = new AccountDAO();
        billDao = new BillDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/marketing") || relative.equals("/admin/marketing/")) {
            // Get all active and valid vouchers
            List<Voucher> vouchers = voucherDao.getValidVouchers();
            request.setAttribute("vouchers", vouchers);
            request.setAttribute("pageTitle", "Email Marketing");
            request.getRequestDispatcher("/admin/email_marketing/index.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/marketing");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/marketing/send")) {
            String target = request.getParameter("target");
            String manualEmailsStr = request.getParameter("manualEmails");
            String subject = request.getParameter("subject");
            String content = request.getParameter("content");
            String voucherIdStr = request.getParameter("voucherId");

            StringBuilder errors = new StringBuilder();
            if (subject == null || subject.trim().isEmpty()) {
                errors.append("Tiêu đề không được để trống. ");
            }
            if (content == null || content.trim().isEmpty()) {
                errors.append("Nội dung không được để trống. ");
            }

            java.util.Map<String, String> emailMap = new java.util.HashMap<>();
            if ("buyers".equals(target)) {
                emailMap.putAll(billDao.getEmailNameMapOfBuyers());
            } else if ("newbies".equals(target)) {
                emailMap.putAll(accountDao.getEmailNameMapOfNonBuyers());
            } else if ("manual".equals(target)) {
                if (manualEmailsStr != null && !manualEmailsStr.trim().isEmpty()) {
                    String[] emails = manualEmailsStr.split(",");
                    for (String e : emails) {
                        String em = e.trim();
                        if (!em.isEmpty()) {
                            emailMap.put(em, "Quý khách");
                        }
                    }
                }
            }

            if (emailMap.isEmpty()) {
                errors.append("Không có email nhận hợp lệ. ");
            }

            if (errors.length() > 0) {
                request.getSession().setAttribute("adminFlash", errors.toString());
                request.getSession().setAttribute("adminFlashType", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/marketing");
                return;
            }

            // Append voucher
            Voucher v = null;
            if (voucherIdStr != null && !voucherIdStr.isEmpty()) {
                try {
                    int vId = Integer.parseInt(voucherIdStr);
                    if (vId > 0) {
                        v = voucherDao.getVoucherById(vId);
                    }
                } catch (Exception e) {
                }
            }

            final String rawContent = content;
            final String finalSubject = subject;
            final Voucher finalV = v;

            // Send async
            executor.submit(() -> {
                Email mailer = new Email();
                for (java.util.Map.Entry<String, String> entry : emailMap.entrySet()) {
                    String email = entry.getKey();
                    String name = entry.getValue();
                    String personalizedContent = rawContent.replace("[FULL_NAME]", name);
                    String personalizedSubject = finalSubject.replace("[FULL_NAME]", name);
                    String finalHtml = buildEmailHtml(personalizedContent, finalV);
                    mailer.sendEmail(email, personalizedSubject, finalHtml, null);
                    try {
                        Thread.sleep(500);
                    } catch (InterruptedException e) {
                    }
                }
            });

            request.getSession().setAttribute("adminFlash",
                    "Đã bắt đầu gửi " + emailMap.size() + " email vào hàng đợi. Quá trình gửi đang diễn ra ngầm.");
            request.getSession().setAttribute("adminFlashType", "success");
            response.sendRedirect(request.getContextPath() + "/admin/marketing");
        }
    }

    private String buildEmailHtml(String content, Voucher v) {
        StringBuilder sb = new StringBuilder();
        sb.append(Utils.EmailTemplates.getEmailHeader("Thông Báo Từ Clothing Shop"));
        sb.append("<div style='font-size: 15px; line-height: 1.6;'>");
        sb.append(content);
        sb.append("</div>");

        if (v != null) {
            sb.append(
                    "<div style='margin-top: 30px; padding: 20px; border: 2px dashed #DB4444; background-color: #fffaf0; border-radius: 8px; text-align: center;'>");
            sb.append("<h2 style='color: #DB4444; margin-top: 0;'>Mã Giảm Giá Tặng Bạn</h2>");
            sb.append("<p style='font-size: 16px;'>Áp dụng mã dưới đây tại trang thanh toán để được giảm giá:</p>");
            sb.append(
                    "<div style='font-size: 24px; font-weight: bold; background: #DB4444; color: #fff; padding: 10px 20px; display: inline-block; border-radius: 4px; letter-spacing: 2px;'>")
                    .append(v.getCode().replace("PUB_", "").replace("PRI_", "")).append("</div>");
            sb.append("<p style='margin-top: 15px; font-size: 14px; color: #666;'>");
            if (v.getDiscountType() == 1) {
                sb.append("Giảm ").append(v.getValue()).append("%");
                if (v.getMaxDiscount() != null && v.getMaxDiscount() > 0) {
                    sb.append(" (Tối đa ").append(String.format("%,.0f", v.getMaxDiscount())).append("đ)");
                }
            } else {
                sb.append("Giảm ").append(String.format("%,.0f", v.getValue())).append("đ");
            }
            sb.append(" cho đơn từ ").append(String.format("%,.0f", v.getMinOrderAmount())).append("đ");
            if (v.getEnd() != null) {
                sb.append(" | Hạn sử dụng: ").append(new java.text.SimpleDateFormat("dd/MM/yyyy").format(v.getEnd()));
            }
            sb.append("</p></div>");
        }
        sb.append(Utils.EmailTemplates.getEmailFooter());
        return sb.toString();
    }
}
