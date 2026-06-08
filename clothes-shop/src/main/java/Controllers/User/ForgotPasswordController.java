package Controllers.User;

import DAO.AccountDAO;
import DAO.PasswordResetTokenDAO;
import Model.Account;
import Utils.Email;
import Utils.EmailTemplates;
import Utils.ServletPaths;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/user/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email.");
            request.getRequestDispatcher("/user/forgot-password.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDao = new AccountDAO();
        Account account = accountDao.getActiveUserByEmail(email);

        if (account == null) {
            // Do not reveal that the email doesn't exist to prevent enumeration. Just show success or generic message.
            // But for better UX in this context, we can tell them if it's not found.
            request.setAttribute("error", "Không tìm thấy tài khoản hợp lệ nào với email này.");
            request.getRequestDispatcher("/user/forgot-password.jsp").forward(request, response);
            return;
        }

        // Generate 6-digit OTP
        String otpCode = String.format("%06d", new Random().nextInt(999999));
        
        // Expiry time (10 minutes)
        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + 10 * 60 * 1000);

        PasswordResetTokenDAO tokenDao = new PasswordResetTokenDAO();
        boolean inserted = tokenDao.insertToken(account.getID(), otpCode, expiresAt);

        if (inserted) {
            // Send email async
            final String customerEmail = account.getEmail();
            new Thread(() -> {
                Email emailSender = new Email();
                String htmlContent = EmailTemplates.getOtpEmailTemplate(otpCode);
                emailSender.sendEmail(customerEmail, "Mã Xác Nhận Khôi Phục Mật Khẩu - Clothing Shop", htmlContent, null);
            }).start();

            HttpSession session = request.getSession();
            session.setAttribute("reset_email", customerEmail);
            session.setAttribute("reset_accountId", account.getID());
            
            ServletPaths.redirect(request, response, "/verify-otp");
        } else {
            request.setAttribute("error", "Đã xảy ra lỗi, vui lòng thử lại sau.");
            request.getRequestDispatcher("/user/forgot-password.jsp").forward(request, response);
        }
    }
}
