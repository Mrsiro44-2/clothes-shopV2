package Controllers.User;

import Authentication.AuthUser;
import DAO.AccountDAO;
import DAO.RoleDAO;
import Model.Account;
import Utils.SwalFlash;
import Utils.ServletPaths;
import Utils.Validation;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    private static final int ROLE_USER_FALLBACK = 3;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthUser auth = new AuthUser();
        if (auth.isLoginUser(request, response) != null) {
            ServletPaths.redirect(request, response, "/");
        } else {
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (request.getParameter("register") == null) {
            ServletPaths.redirect(request, response, "/register");
            return;
        }

        Validation v = new Validation();
        String username = trim(request.getParameter("username"));
        String email = trim(request.getParameter("email"));
        String fullname = trim(request.getParameter("fullname"));
        String phone = trim(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String err = Utils.AccountProfileValidator.validate(fullname, email, phone, password, confirmPassword);
        if (v.isBlank(username)) {
            err = "Tên đăng nhập không được để trống.";
        } else if (username.length() < 3) {
            err = "Tên đăng nhập tối thiểu 3 ký tự.";
        }

        if (err != null) {
            SwalFlash.error(request, "Đăng ký thất bại", err);
            forwardRegister(request, response, username, email, fullname, phone);
            return;
        }

        String emailNorm = Utils.AccountProfileValidator.normalizeEmail(email);
        String phoneNorm = Utils.AccountProfileValidator.normalizePhone(phone);

        AccountDAO adao = new AccountDAO();
        Account accountCheck = adao.isExistAccount(username, emailNorm);
        if (accountCheck != null) {
            SwalFlash.error(request, "Đăng ký thất bại", "Tên đăng nhập hoặc email đã tồn tại.");
            forwardRegister(request, response, username, emailNorm, fullname, phoneNorm);
            return;
        }

        RoleDAO roleDao = new RoleDAO();
        int roleUser = roleDao.getRoleIdByName("user");
        if (roleUser <= 0) {
            roleUser = ROLE_USER_FALLBACK;
        }

        Timestamp dateCreate = Timestamp.valueOf(LocalDateTime.now());
        Account account = new Account(0, username, password, emailNorm, phoneNorm, 1, fullname, dateCreate, roleUser, null);
        int result = adao.insert(account);
        HttpSession session = request.getSession();
        if (result > 0) {
            session.setAttribute("messageSuccessRegister", "Bạn có thể đăng nhập ngay bây giờ.");
            ServletPaths.redirect(request, response, "/login");
        } else {
            SwalFlash.error(request, "Đăng ký thất bại", "Không thể tạo tài khoản. Vui lòng thử lại.");
            forwardRegister(request, response, username, email, fullname, phone);
        }
    }

    private void forwardRegister(HttpServletRequest request, HttpServletResponse response,
            String username, String email, String fullname, String phone)
            throws ServletException, IOException {
        request.setAttribute("formUsername", username);
        request.setAttribute("formEmail", email);
        request.setAttribute("formFullname", fullname);
        request.setAttribute("formPhone", phone);
        request.getRequestDispatcher("/user/register.jsp").forward(request, response);
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
