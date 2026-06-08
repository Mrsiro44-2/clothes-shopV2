package Controllers.User;

import DAO.AccountDAO;
import DAO.PasswordResetTokenDAO;
import Utils.ServletPaths;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ResetPasswordController", urlPatterns = {"/reset-password"})
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("verified_reset_accountId") == null) {
            ServletPaths.redirect(request, response, "/forgot-password");
            return;
        }
        request.getRequestDispatcher("/user/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("verified_reset_accountId");
        Integer tokenId = (Integer) session.getAttribute("verified_tokenId");

        if (accountId == null || tokenId == null) {
            ServletPaths.redirect(request, response, "/forgot-password");
            return;
        }

        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.trim().length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/user/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/user/reset-password.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDao = new AccountDAO();
        int r = accountDao.updatePassword(newPassword.trim(), accountId);
        
        if (r > 0) {
            // Mark token as used
            PasswordResetTokenDAO tokenDao = new PasswordResetTokenDAO();
            tokenDao.markTokenAsUsed(tokenId);
            
            // Clear session
            session.removeAttribute("reset_email");
            session.removeAttribute("reset_accountId");
            session.removeAttribute("verified_reset_accountId");
            session.removeAttribute("verified_tokenId");
            
            request.getSession().setAttribute("swalMessage", "Đổi mật khẩu thành công. Vui lòng đăng nhập lại.");
            request.getSession().setAttribute("swalIcon", "success");
            request.getSession().setAttribute("swalTitle", "Thành công");
            ServletPaths.redirect(request, response, "/login");
        } else {
            request.setAttribute("error", "Đã xảy ra lỗi, vui lòng thử lại sau.");
            request.getRequestDispatcher("/user/reset-password.jsp").forward(request, response);
        }
    }
}
