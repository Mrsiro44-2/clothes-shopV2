package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import Model.Account;
import Utils.AccountProfileValidator;
import Utils.ServletPaths;
import Utils.SwalFlash;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

@WebServlet(name = "AccountUserController", urlPatterns = {"/account", "/change-password", "/logout"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AccountUserController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        if (path.contains("/logout")) {
            request.getSession().invalidate();
            ServletPaths.redirect(request, response, "/home");
            return;
        }
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        if (username == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }
        AccountDAO accountDao = new AccountDAO();
        Account account = accountDao.getAccountByUsername(username);
      
        if (path.contains("/change-password")) {
            request.setAttribute("account", account);
            request.getRequestDispatcher("/user/change-password.jsp").forward(request, response);
            return;
        }

        request.setAttribute("account", account);
        request.getRequestDispatcher("/user/account.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getRequestURI();
        AuthUser auth = new AuthUser();
        String username = auth.isLoginUser(request, response);
        if (username == null) {
            ServletPaths.redirect(request, response, "/login");
            return;
        }
        AccountDAO accountDao = new AccountDAO();
        Account account = accountDao.getAccountByUsername(username);

        if (path.contains("/change-password")) {
            updatePasswordOnly(request, response, account, accountDao);
        } else if (path.contains("/account")) {
            updateProfileInfoOnly(request, response, account, accountDao);
        }
    }

    private void updateProfileInfoOnly(HttpServletRequest request, HttpServletResponse response,
            Account account, AccountDAO accountDao) throws IOException, ServletException {
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        String err = AccountProfileValidator.validate(fullname, email, phone, null, null);
        if (err != null) {
            SwalFlash.error(request, "Tài khoản", err);
            request.setAttribute("account", account);
            request.getRequestDispatcher("/user/account.jsp").forward(request, response);
            return;
        }

        String emailNorm = AccountProfileValidator.normalizeEmail(email);
        if (accountDao.isEmailTakenByOther(account.getID(), emailNorm)) {
            SwalFlash.error(request, "Tài khoản", "Email đã được sử dụng bởi tài khoản khác.");
            request.setAttribute("account", account);
            request.getRequestDispatcher("/user/account.jsp").forward(request, response);
            return;
        }

        String avatarUrl = account.getAvatar();
        try {
            Part filePart = request.getPart("avatarFile");
            if (filePart != null && filePart.getSize() > 0) {
                Utils.Upload uploader = new Utils.Upload();
                String uploadPath = request.getServletContext().getRealPath("/uploads");
                String fileName = uploader.uploadImg(filePart, uploadPath);
                if (fileName != null) {
                    avatarUrl = request.getContextPath() + "/uploads/" + fileName;
                }
            }
        } catch (Exception e) {
            System.out.println("No file upload: " + e);
        }

        account.setFullname(fullname.trim());
        account.setPhone(AccountProfileValidator.normalizePhone(phone));
        account.setEmail(emailNorm);
        account.setAvatar(avatarUrl);

        int r = accountDao.updatePersonalUser(account);
        if (r > 0) {
            SwalFlash.successSession(request.getSession(), "Tài khoản", "Cập nhật thông tin thành công.");
        } else {
            SwalFlash.errorSession(request.getSession(), "Tài khoản", "Cập nhật thất bại.");
        }
        ServletPaths.redirect(request, response, "/account");
    }

    private void updatePasswordOnly(HttpServletRequest request, HttpServletResponse response,
            Account account, AccountDAO accountDao) throws IOException, ServletException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().length() < 6 ||
            !newPassword.equals(confirmPassword)) {
            SwalFlash.error(request, "Đổi mật khẩu", "Thông tin mật khẩu không hợp lệ hoặc không khớp.");
            request.setAttribute("account", account);
            request.getRequestDispatcher("/user/change-password.jsp").forward(request, response);
            return;
        }

        String currentHashed = Utils.MD5Hashing.encodeForStorage(currentPassword.trim());
        if (!currentHashed.equals(account.getPassword())) {
            SwalFlash.error(request, "Đổi mật khẩu", "Mật khẩu hiện tại không đúng.");
            request.setAttribute("account", account);
            request.getRequestDispatcher("/user/change-password.jsp").forward(request, response);
            return;
        }

        int r = accountDao.updatePassword(newPassword.trim(), account.getID());
        if (r > 0) {
            SwalFlash.successSession(request.getSession(), "Đổi mật khẩu", "Đổi mật khẩu thành công.");
        } else {
            SwalFlash.errorSession(request.getSession(), "Đổi mật khẩu", "Đổi mật khẩu thất bại.");
        }
        ServletPaths.redirect(request, response, "/change-password");
    }
}
