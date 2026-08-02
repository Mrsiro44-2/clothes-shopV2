package Controllers.Admin;

import DAO.ColorOptionDAO;
import Model.ColorOption;
import Utils.ServletPaths;
import Utils.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminColorController", urlPatterns = {"/admin/colors/*"})
public class AdminColorController extends HttpServlet {

    private ColorOptionDAO colorDao;

    @Override
    public void init() throws ServletException {
        colorDao = new ColorOptionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            listColors(request, response);
        } else if (pathInfo.equals("/add")) {
            showAddForm(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            showEditForm(request, response);
        } else if (pathInfo.startsWith("/delete/")) {
            deleteColor(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.equals("/add")) {
            addColor(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/edit/")) {
            editColor(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listColors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
            int totalRows = colorDao.count(q, status);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.ColorOption> colors = colorDao.getPaginated(q, status, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("sort", sort);
        request.setAttribute("colors", colors);
        request.setAttribute("pageTitle", "Quản lý Màu sắc");
        request.getRequestDispatcher("/admin/catalog/colors.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("isEdit", false);
        request.setAttribute("pageTitle", "Thêm Màu sắc");
        request.getRequestDispatcher("/admin/catalog/color-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        ColorOption color = colorDao.getById(id);
        if (color != null) {
            request.setAttribute("color", color);
            request.setAttribute("isEdit", true);
            request.setAttribute("pageTitle", "Sửa Màu sắc");
            request.getRequestDispatcher("/admin/catalog/color-form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/colors");
        }
    }

    private void addColor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Validation validate = new Validation();
        
        String name = request.getParameter("name");
        String hexCode = request.getParameter("hexCode");
        int sortOrder = validate.getInt(request.getParameter("sortOrder"));
        int status = validate.getInt(request.getParameter("status"));

        if (validate.isBlank(name)) {
            request.setAttribute("error", "Vui lòng nhập tên màu");
            request.setAttribute("inputName", name);
            request.setAttribute("inputStatus", status);
            request.setAttribute("isEdit", false);
            request.setAttribute("pageTitle", "Thêm Màu sắc");
            request.getRequestDispatcher("/admin/catalog/color-form.jsp").forward(request, response);
            return;
        }
        
        if (colorDao.isExistName(name.trim(), 0)) {
            request.setAttribute("error", "Tên màu sắc này đã tồn tại.");
            request.setAttribute("inputName", name);
            request.setAttribute("inputStatus", status);
            request.setAttribute("isEdit", false);
            request.setAttribute("pageTitle", "Thêm Màu sắc");
            request.getRequestDispatcher("/admin/catalog/color-form.jsp").forward(request, response);
            return;
        }

        ColorOption c = new ColorOption(0, name, hexCode, sortOrder, status);
        if (colorDao.insert(c) > 0) {
            request.getSession().setAttribute("adminFlash", "Thêm màu thành công");
            request.getSession().setAttribute("adminFlashType", "success");
            response.sendRedirect(request.getContextPath() + "/admin/colors");
        } else {
            request.getSession().setAttribute("adminFlash", "Có lỗi xảy ra");
            request.getSession().setAttribute("adminFlashType", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/colors/add");
        }
    }

    private void editColor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        Validation validate = new Validation();
        
        String name = request.getParameter("name");
        String hexCode = request.getParameter("hexCode");
        int sortOrder = validate.getInt(request.getParameter("sortOrder"));
        int status = validate.getInt(request.getParameter("status"));

        if (validate.isBlank(name)) {
            request.setAttribute("error", "Vui lòng nhập tên màu");
            ColorOption color = colorDao.getById(id);
            request.setAttribute("color", color);
            request.setAttribute("isEdit", true);
            request.setAttribute("pageTitle", "Sửa Màu sắc");
            request.getRequestDispatcher("/admin/catalog/color-form.jsp").forward(request, response);
            return;
        }
        
        if (colorDao.isExistName(name.trim(), id)) {
            request.setAttribute("error", "Tên màu sắc này đã tồn tại.");
            ColorOption color = colorDao.getById(id);
            request.setAttribute("color", color);
            request.setAttribute("isEdit", true);
            request.setAttribute("pageTitle", "Sửa Màu sắc");
            request.getRequestDispatcher("/admin/catalog/color-form.jsp").forward(request, response);
            return;
        }

        ColorOption c = new ColorOption(id, name, hexCode, sortOrder, status);
        if (colorDao.update(c) > 0) {
            request.getSession().setAttribute("adminFlash", "Cập nhật thành công");
            request.getSession().setAttribute("adminFlashType", "success");
        } else {
            request.getSession().setAttribute("adminFlash", "Cập nhật thất bại");
            request.getSession().setAttribute("adminFlashType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/admin/colors");
    }

    private void deleteColor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        if (colorDao.delete(id) > 0) {
            request.getSession().setAttribute("adminFlash", "Xoá thành công");
            request.getSession().setAttribute("adminFlashType", "success");
        } else {
            request.getSession().setAttribute("adminFlash", "Xoá thất bại (Có thể màu sắc đã được sử dụng)");
            request.getSession().setAttribute("adminFlashType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/admin/colors");
    }
}
