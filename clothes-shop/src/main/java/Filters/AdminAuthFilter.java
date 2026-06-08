package Filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AdminAuthFilter", urlPatterns = {"/admin/*"})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String ctx = request.getContextPath();
        String uri = request.getRequestURI();
        String relative = uri.substring(ctx.length());

        // /admin hoặc /admin/ → redirect sang /admin/dashboard
        if (relative.equals("/admin") || relative.equals("/admin/")) {
            if (session != null && session.getAttribute("adminUser") != null) {
                response.sendRedirect(ctx + "/admin/dashboard");
            } else {
                response.sendRedirect(ctx + "/admin/login");
            }
            return;
        }

        // Cho phép trang login đi qua
        if (relative.equals("/admin/login") || relative.equals("/admin/login/")) {
            chain.doFilter(req, res);
            return;
        }

        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("adminUser") == null) {
            response.sendRedirect(ctx + "/admin/login");
            return;
        }

        String role = (String) session.getAttribute("adminRole");

        // Staff không được truy cập quản lý tài khoản
        if ("staff".equalsIgnoreCase(role) && relative.startsWith("/admin/accounts")) {
            response.sendRedirect(ctx + "/admin/dashboard");
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
    }
}
