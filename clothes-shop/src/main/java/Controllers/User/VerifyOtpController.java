package Controllers.User;

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

@WebServlet(name = "VerifyOtpController", urlPatterns = {"/verify-otp"})
public class VerifyOtpController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("reset_email") == null) {
            ServletPaths.redirect(request, response, "/forgot-password");
            return;
        }
        request.getRequestDispatcher("/user/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("reset_email");
        Integer accountId = (Integer) session.getAttribute("reset_accountId");

        if (email == null || accountId == null) {
            ServletPaths.redirect(request, response, "/forgot-password");
            return;
        }

        String otp = request.getParameter("otp");
        if (otp == null || otp.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mã OTP.");
            request.getRequestDispatcher("/user/verify-otp.jsp").forward(request, response);
            return;
        }

        PasswordResetTokenDAO tokenDao = new PasswordResetTokenDAO();
        PasswordResetToken token = tokenDao.getValidToken(otp.trim());

        if (token != null && token.getAccountId() == accountId) {
            // Valid OTP
            session.setAttribute("verified_reset_accountId", accountId);
            session.setAttribute("verified_tokenId", token.getId());
            ServletPaths.redirect(request, response, "/reset-password");
        } else {
            request.setAttribute("error", "Mã OTP không hợp lệ hoặc đã hết hạn.");
            request.getRequestDispatcher("/user/verify-otp.jsp").forward(request, response);
        }
    }
}
