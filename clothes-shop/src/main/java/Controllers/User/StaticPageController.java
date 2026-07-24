package Controllers.User;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Trang tĩnh: Liên hệ, Giới thiệu.
 */
@WebServlet(name = "StaticPageController", urlPatterns = {"/contact", "/about", "/return-policy"})
public class StaticPageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/contact".equals(path)) {
            request.getRequestDispatcher("/user/contact.jsp").forward(request, response);
        } else if ("/return-policy".equals(path)) {
            request.getRequestDispatcher("/user/return-policy.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/user/about.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/contact".equals(path)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String content = request.getParameter("content");
            
            if (name != null && !name.trim().isEmpty() && email != null && !email.trim().isEmpty() && content != null && !content.trim().isEmpty()) {
                Utils.Email emailUtil = new Utils.Email();
                
                // 1. Gửi email xác nhận cho khách hàng
                String userSubject = "Xác nhận liên hệ từ Clothing Shop";
                String userBody = "<p>Chào <b>" + name + "</b>,</p>"
                                + "<p>Chúng tôi đã nhận được tin nhắn liên hệ của bạn với nội dung:</p>"
                                + "<p><i>" + content + "</i></p>"
                                + "<p>Chúng tôi sẽ phản hồi bạn trong thời gian sớm nhất.</p>"
                                + "<p>Trân trọng,<br>Clothing Shop</p>";
                emailUtil.sendEmail(email, userSubject, userBody, Utils.AppConfig.ADMIN_EMAIL);
                
                // 2. Gửi email thông báo cho admin
                String adminSubject = "Có liên hệ mới từ khách hàng: " + name;
                String adminBody = "<p>Có một liên hệ mới từ khách hàng, thông tin chi tiết:</p>"
                                 + "<ul>"
                                 + "<li><b>Họ tên:</b> " + name + "</li>"
                                 + "<li><b>Email:</b> " + email + "</li>"
                                 + "<li><b>Nội dung:</b> " + content + "</li>"
                                 + "</ul>"
                                 + "<p>Vui lòng phản hồi khách hàng sớm nhất.</p>";
                emailUtil.sendEmail(Utils.AppConfig.ADMIN_EMAIL, adminSubject, adminBody, email);
                
                request.setAttribute("message", "Gửi tin nhắn liên hệ thành công!");
            } else {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            }
            request.getRequestDispatcher("/user/contact.jsp").forward(request, response);
        }
    }
}
