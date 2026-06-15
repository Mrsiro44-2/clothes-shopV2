package Controllers.User;

import DAO.PasswordResetTokenDAO;
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

@WebServlet(name = "ResendRegisterOtpController", urlPatterns = {"/resend-register-otp"})
public class ResendRegisterOtpController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("register_email");
        Integer accountId = (Integer) session.getAttribute("register_accountId");

        if (email == null || accountId == null) {
            ServletPaths.redirect(request, response, "/register");
            return;
        }

        // Generate new 6-digit OTP
        String otpCode = String.format("%06d", new Random().nextInt(999999));
        Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + 10 * 60 * 1000);

        PasswordResetTokenDAO tokenDao = new PasswordResetTokenDAO();
        boolean inserted = tokenDao.insertToken(accountId, otpCode, expiresAt);

        if (inserted) {
            // Send email async
            new Thread(() -> {
                Email emailSender = new Email();
                String htmlContent = EmailTemplates.getRegisterOtpEmailTemplate(otpCode);
                emailSender.sendEmail(email, "Xác Nhận Đăng Ký Tài Khoản - Clothing Shop", htmlContent, null);
            }).start();
            
            // Set success message for the verify-register-otp page
            request.setAttribute("successMessage", "Mã OTP mới đã được gửi đến email của bạn.");
        } else {
            request.setAttribute("error", "Không thể tạo mã OTP mới. Vui lòng thử lại.");
        }
        
        request.getRequestDispatcher("/user/verify-register-otp.jsp").forward(request, response);
    }
}
