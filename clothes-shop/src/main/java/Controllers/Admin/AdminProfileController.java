package Controllers.Admin;

import DAO.AccountDAO;
import Model.Account;
import Utils.ServletPaths;
import Utils.Upload;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;

@WebServlet(name = "AdminProfileController", urlPatterns = {"/admin/profile"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminProfileController extends HttpServlet {

    private AccountDAO accountDao;

    @Override
    public void init() throws ServletException {
        accountDao = new AccountDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer myId = (Integer) request.getSession().getAttribute("adminAccountId");
        if (myId == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        Account acc = accountDao.getAccountById(myId);
        request.setAttribute("account", acc);
        request.setAttribute("pageTitle", "Hồ sơ cá nhân");
        request.getRequestDispatcher("/admin/user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Integer myId = (Integer) request.getSession().getAttribute("adminAccountId");
        if (myId == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        
        Account acc = accountDao.getAccountById(myId);
        
        String avatarUrl = acc.getAvatar();
        try {
            Part filePart = request.getPart("avatarFile");
            if (filePart != null && filePart.getSize() > 0) {
                Upload uploader = new Upload();
                String uploadPath = request.getServletContext().getRealPath("/uploads");
                String fileName = uploader.uploadImg(filePart, uploadPath);
                if (fileName != null) {
                    avatarUrl = request.getContextPath() + "/uploads/" + fileName;
                }
            }
        } catch (Exception e) {
            System.out.println("No file upload: " + e);
        }

        StringBuilder errors = new StringBuilder();
        if (fullname == null || fullname.trim().isEmpty()) errors.append("Họ tên không được để trống. ");
        if (email == null || email.trim().isEmpty()) errors.append("Email không được để trống. ");
        else if (!email.trim().matches("^[\\w.+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) errors.append("Email không hợp lệ. ");
        
        if (accountDao.isEmailTakenByOther(myId, email.trim())) {
            errors.append("Email đã được sử dụng bởi người khác. ");
        }

        if (password != null && !password.trim().isEmpty() && password.length() < 6) {
            errors.append("Mật khẩu mới phải tối thiểu 6 ký tự. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            request.setAttribute("account", acc);
            request.setAttribute("pageTitle", "Hồ sơ cá nhân");
            request.getRequestDispatcher("/admin/user/profile.jsp").forward(request, response);
            return;
        }

        acc.setFullname(fullname.trim());
        acc.setEmail(email.trim());
        acc.setPhone(phone != null ? phone.trim() : "");
        acc.setAvatar(avatarUrl);
        
        accountDao.updatePersonalUser(acc);
        
        if (password != null && !password.trim().isEmpty()) {
            accountDao.updatePassword(password, myId);
        }
        
        // Update session
        request.getSession().setAttribute("adminFullname", acc.getFullname());
        request.getSession().setAttribute("adminAvatar", acc.getAvatar());
        
        request.getSession().setAttribute("adminFlash", "Đã cập nhật hồ sơ thành công.");
        request.getSession().setAttribute("adminFlashType", "success");
        response.sendRedirect(request.getContextPath() + "/admin/profile");
    }
}
