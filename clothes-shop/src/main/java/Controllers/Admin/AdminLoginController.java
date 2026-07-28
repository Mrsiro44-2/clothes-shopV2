package Controllers.Admin;

import DAO.AccountDAO;
import Model.Account;
import Utils.MD5Hashing;
import Utils.ServletPaths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AdminLoginController", urlPatterns = { "/admin/login", "/admin/logout" })
public class AdminLoginController extends HttpServlet {

    private AccountDAO accountDao;

    @Override
    public void init() throws ServletException {
        accountDao = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.startsWith("/admin/logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("adminUser");
                session.removeAttribute("adminRole");
                session.removeAttribute("adminFullname");
                session.removeAttribute("adminAvatar");
            }
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        // Nếu đã đăng nhập rồi thì chuyển về dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.");
            request.setAttribute("inputUsername", username);
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        username = username.trim();
        Account account = accountDao.login(username);

        if (account == null) {
            request.setAttribute("error", "Tên đăng nhập không tồn tại hoặc tài khoản đã bị khoá.");
            request.setAttribute("inputUsername", username);
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu
        if (!MD5Hashing.matches(password, account.getPassword())) {
            request.setAttribute("error", "Mật khẩu không chính xác.");
            request.setAttribute("inputUsername", username);
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        String roleName = account.getRoleName();
        if (!"admin".equalsIgnoreCase(roleName) && !"staff".equalsIgnoreCase(roleName)) {
            request.setAttribute("error", "Tài khoản của bạn không có quyền truy cập trang quản trị.");
            request.setAttribute("inputUsername", username);
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }

        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("adminUser", account.getUsername());
        session.setAttribute("adminRole", roleName.toLowerCase());
        session.setAttribute("adminFullname", account.getFullname());
        session.setAttribute("adminAvatar", account.getAvatar());
        session.setAttribute("adminAccountId", account.getID());

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
