package Controllers.User;

import DAO.AccountDAO;
import DAO.PasswordResetTokenDAO;
import Model.PasswordResetToken;
import Utils.ServletPaths;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "VerifyRegisterOtpController", urlPatterns = {"/verify-register-otp"})
public class VerifyRegisterOtpController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("register_email") == null) {
            ServletPaths.redirect(request, response, "/register");
            return;
        }
        request.getRequestDispatcher("/user/verify-register-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("register_email");
        Integer accountId = (Integer) session.getAttribute("register_accountId");

        if (email == null || accountId == null) {
            ServletPaths.redirect(request, response, "/register");
            return;
        }

        String otp = request.getParameter("otp");
        if (otp == null || otp.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mã OTP.");
            request.getRequestDispatcher("/user/verify-register-otp.jsp").forward(request, response);
            return;
        }

        PasswordResetTokenDAO tokenDao = new PasswordResetTokenDAO();
        PasswordResetToken token = tokenDao.getValidToken(otp.trim());

        if (token != null && token.getAccountId() == accountId) {
            // Valid OTP
            tokenDao.deleteToken(token.getId());
            
            // Activate account
            AccountDAO adao = new AccountDAO();
            adao.updateStatus(accountId, Utils.UserStatus.ACTIVE);
            
            // Clear session variables
            session.removeAttribute("register_email");
            session.removeAttribute("register_accountId");
            
            // Set success message for login page
            session.setAttribute("messageSuccessRegister", "Xác thực thành công! Bạn có thể đăng nhập ngay bây giờ.");
            ServletPaths.redirect(request, response, "/login");
        } else {
            request.setAttribute("error", "Mã OTP không hợp lệ hoặc đã hết hạn.");
            request.getRequestDispatcher("/user/verify-register-otp.jsp").forward(request, response);
        }
    }
}
