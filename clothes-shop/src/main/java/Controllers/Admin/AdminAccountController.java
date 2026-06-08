package Controllers.Admin;

import DAO.AccountDAO;
import DAO.RoleDAO;
import Model.Account;
import Utils.MD5Hashing;
import Utils.ServletPaths;
import Utils.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "AdminAccountController", urlPatterns = {"/admin/accounts/*"})
public class AdminAccountController extends HttpServlet {

    private AccountDAO accountDao;
    private Validation validate;

    @Override
    public void init() throws ServletException {
        accountDao = new AccountDAO();
        validate = new Validation();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/accounts") || relative.equals("/admin/accounts/")) {
                        String q = request.getParameter("q");
            String status = request.getParameter("status");
            String sort = request.getParameter("sort");
            int page = 1;
            if (request.getParameter("page") != null) {
                try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}
            }
            int limit = 10;
            if (request.getParameter("limit") != null) {
                try { limit = Integer.parseInt(request.getParameter("limit")); } catch (Exception e) {}
            }
            int totalRows = accountDao.count(q, status);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.Account> accounts = accountDao.getPaginated(q, status, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("sort", sort);
            request.setAttribute("accounts", accounts);
            request.setAttribute("pageTitle", "Quản lý tài khoản");
            request.getRequestDispatcher("/admin/user/index.jsp").forward(request, response);

        } else if (relative.equals("/admin/accounts/add")) {
            RoleDAO roleDao = new RoleDAO();
            request.setAttribute("roles", roleDao.getRole());
            request.setAttribute("pageTitle", "Thêm tài khoản");
            request.getRequestDispatcher("/admin/user/form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/accounts/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/accounts/edit");
            if (id <= 0) { response.sendRedirect(request.getContextPath() + "/admin/accounts"); return; }
            Account acc = accountDao.getAccountById(id);
            if (acc == null) { response.sendRedirect(request.getContextPath() + "/admin/accounts"); return; }
            RoleDAO roleDao = new RoleDAO();
            request.setAttribute("account", acc);
            request.setAttribute("roles", roleDao.getRole());
            request.setAttribute("pageTitle", "Sửa tài khoản");
            request.getRequestDispatcher("/admin/user/form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/accounts/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/accounts/delete");
            if (id > 0) {
                // Không cho xoá chính mình
                Integer myId = (Integer) request.getSession().getAttribute("adminAccountId");
                if (myId != null && myId == id) {
                    request.getSession().setAttribute("adminFlash", "Bạn không thể xoá tài khoản của chính mình.");
                    request.getSession().setAttribute("adminFlashType", "danger");
                } else {
                    accountDao.delete(id);
                    request.getSession().setAttribute("adminFlash", "Đã xoá tài khoản thành công.");
                    request.getSession().setAttribute("adminFlashType", "success");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/accounts");

        } else if (relative.startsWith("/admin/accounts/toggle-lock/")) {
            int id = ServletPaths.idAfter(request, "/admin/accounts/toggle-lock");
            if (id > 0) {
                Integer myId = (Integer) request.getSession().getAttribute("adminAccountId");
                if (myId != null && myId == id) {
                    request.getSession().setAttribute("adminFlash", "Bạn không thể khoá tài khoản của chính mình.");
                    request.getSession().setAttribute("adminFlashType", "danger");
                } else {
                    Account acc = accountDao.getAccountById(id);
                    if (acc != null) {
                        int newStatus = acc.getStatus() == 1 ? 0 : 1;
                        accountDao.updateStatus(id, newStatus);
                        request.getSession().setAttribute("adminFlash", "Đã " + (newStatus == 1 ? "mở khoá" : "khoá") + " tài khoản thành công.");
                        request.getSession().setAttribute("adminFlashType", "success");
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/accounts");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        int role = validate.getInt(request.getParameter("role"));
        int status = validate.getInt(request.getParameter("status"));

        // Validate
        StringBuilder errors = new StringBuilder();
        if (fullname == null || fullname.trim().isEmpty()) errors.append("Há» tên không được để trống. ");
        if (email == null || email.trim().isEmpty()) errors.append("Email không được để trống. ");
        else if (!email.trim().matches("^[\\w.+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) errors.append("Email không hợp lệ. ");
        if (username == null || username.trim().isEmpty()) errors.append("Tên đăng nhập không được để trống. ");
        if (role <= 0) errors.append("Vai trò không hợp lệ. ");
        if (status != 0 && status != 1) errors.append("Trạng thái không hợp lệ. ");

        boolean isAdd = relative.equals("/admin/accounts/add");
        if (isAdd && (password == null || password.trim().isEmpty())) {
            errors.append("Mật khẩu không được để trống. ");
        }
        if (isAdd && password != null && password.length() < 6) {
            errors.append("Mật khẩu phải tối thiểu 6 ký tự. ");
        }

        if (isAdd) {
            Account existing = accountDao.isExistAccount(username.trim(), email.trim());
            if (existing != null) {
                errors.append("Tên đăng nhập hoặc email đã tồn tại. ");
            }
        }

        if (errors.length() > 0) {
            RoleDAO roleDao = new RoleDAO();
            request.setAttribute("roles", roleDao.getRole());
            request.setAttribute("error", errors.toString().trim());
            request.setAttribute("inputFullname", fullname);
            request.setAttribute("inputEmail", email);
            request.setAttribute("inputPhone", phone);
            request.setAttribute("inputUsername", username);
            request.setAttribute("inputRole", role);
            request.setAttribute("inputStatus", status);
            if (!isAdd) {
                int id = ServletPaths.idAfter(request, "/admin/accounts/edit");
                Account acc = accountDao.getAccountById(id);
                request.setAttribute("account", acc);
                request.setAttribute("pageTitle", "Sửa tài khoản");
            } else {
                request.setAttribute("pageTitle", "Thêm tài khoản");
            }
            request.getRequestDispatcher("/admin/user/form.jsp").forward(request, response);
            return;
        }

        if (isAdd) {
            Account a = new Account();
            a.setFullname(fullname.trim());
            a.setEmail(email.trim());
            a.setPhone(phone != null ? phone.trim() : "");
            a.setUsername(username.trim());
            a.setPassword(password);
            a.setRole(role);
            a.setStatus(status);
            a.setDate(new Timestamp(System.currentTimeMillis()));
            accountDao.insert(a);
            request.getSession().setAttribute("adminFlash", "Đã thêm tài khoản \"" + username.trim() + "\" thành công.");
            request.getSession().setAttribute("adminFlashType", "success");
        } else if (relative.startsWith("/admin/accounts/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/accounts/edit");
            Account a = accountDao.getAccountById(id);
            if (a != null) {
                a.setFullname(fullname.trim());
                a.setEmail(email.trim());
                a.setPhone(phone != null ? phone.trim() : "");
                a.setUsername(username.trim());
                // Chỉ cập nhật password nếu được nhập mới
                if (password != null && !password.trim().isEmpty()) {
                    a.setPassword(password);
                    accountDao.update(a);
                } else {
                    // Không đổi password → dùng updatePersonal (không hash lại)
                    a.setRole(role);
                    a.setStatus(status);
                    String sql = "update Account set fullname=?, email=?, phone=?, username=?, role=?, status=? where ID=?";
                    try {
                        java.sql.Connection conn = DBConnection.DBConnection.connect();
                        java.sql.PreparedStatement st = conn.prepareStatement(sql);
                        st.setString(1, a.getFullname());
                        st.setString(2, a.getEmail());
                        st.setString(3, a.getPhone());
                        st.setString(4, a.getUsername());
                        st.setInt(5, role);
                        st.setInt(6, status);
                        st.setInt(7, a.getID());
                        st.executeUpdate();
                        conn.close();
                    } catch (Exception e) {
                        System.out.println("AdminAccountController update: " + e);
                    }
                }
                request.getSession().setAttribute("adminFlash", "Đã cập nhật tài khoản thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/accounts");
    }
}
