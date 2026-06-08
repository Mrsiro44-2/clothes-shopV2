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
}
