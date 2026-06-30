package Controllers.Admin;

import DAO.SizeOptionDAO;
import DAO.SizeGroupDAO;
import Model.SizeOption;
import Utils.ServletPaths;
import Utils.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminSizeOptionController", urlPatterns = {"/admin/sizeoptions/*"})
public class AdminSizeOptionController extends HttpServlet {

    private SizeOptionDAO sizeOptionDao;
    private SizeGroupDAO sizeGroupDao;

    @Override
    public void init() throws ServletException {
        sizeOptionDao = new SizeOptionDAO();
        sizeGroupDao = new SizeGroupDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            listSizeOptions(request, response);
        } else if (pathInfo.equals("/add")) {
            showAddForm(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            showEditForm(request, response);
        } else if (pathInfo.startsWith("/delete/")) {
            deleteSizeOption(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.equals("/add")) {
            addSizeOption(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/edit/")) {
            editSizeOption(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listSizeOptions(HttpServletRequest request, HttpServletResponse response)
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
            int totalRows = sizeOptionDao.count(q, status);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.SizeOption> sizeOptions = sizeOptionDao.getPaginated(q, status, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("sort", sort);
        request.setAttribute("sizeOptions", sizeOptions);
        request.setAttribute("sizeGroups", sizeGroupDao.allSizeGroup());
        request.setAttribute("pageTitle", "Quản lý Tuỳ chọn Kích cỡ");
        request.getRequestDispatcher("/admin/catalog/sizeoptions.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("isEdit", false);
        request.setAttribute("sizeGroups", sizeGroupDao.allSizeGroup());
        request.setAttribute("pageTitle", "Thêm Kích Cỡ");
        request.getRequestDispatcher("/admin/catalog/sizeoption-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        SizeOption sizeOption = sizeOptionDao.getSizeOptionById(id);
        if (sizeOption != null) {
            request.setAttribute("sizeOption", sizeOption);
            request.setAttribute("isEdit", true);
            request.setAttribute("sizeGroups", sizeGroupDao.allSizeGroup());
            request.setAttribute("pageTitle", "Sửa Kích Cỡ");
            request.getRequestDispatcher("/admin/catalog/sizeoption-form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/sizeoptions");
        }
    }

    private void addSizeOption(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Validation validate = new Validation();
        
        String code = request.getParameter("code");
        String label = request.getParameter("label");
        int sortOrder = validate.getInt(request.getParameter("sortOrder"));
        int status = validate.getInt(request.getParameter("status"));
        int sizeGroupID = validate.getInt(request.getParameter("sizeGroupID"));

        String redirectUrl = request.getParameter("redirectUrl");
        if (redirectUrl == null) redirectUrl = request.getContextPath() + "/admin/sizeoptions";

        if (validate.isBlank(label) || validate.isBlank(code)) {
            request.getSession().setAttribute("error", "Vui lòng nhập mã và tên kích cỡ");
            response.sendRedirect(redirectUrl);
            return;
        }

        // Check for duplicates in the same size group
        java.util.List<SizeOption> existings = sizeOptionDao.getByGroupId(sizeGroupID);
        for (SizeOption existing : existings) {
            if (existing.getCode().trim().equalsIgnoreCase(code.trim()) || existing.getLabel().trim().equalsIgnoreCase(label.trim())) {
                request.getSession().setAttribute("error", "Mã hoặc tên kích cỡ đã tồn tại trong nhóm này!");
                response.sendRedirect(redirectUrl);
                return;
            }
        }

        SizeOption s = new SizeOption(0, code, label, sortOrder, status, sizeGroupID);
        if (sizeOptionDao.insert(s) > 0) {
            request.getSession().setAttribute("success", "Thêm thành công");
            response.sendRedirect(redirectUrl);
        } else {
            request.getSession().setAttribute("error", "Có lỗi xảy ra");
            response.sendRedirect(redirectUrl);
        }
    }

    private void editSizeOption(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        Validation validate = new Validation();
        
        String code = request.getParameter("code");
        String label = request.getParameter("label");
        int sortOrder = validate.getInt(request.getParameter("sortOrder"));
        int status = validate.getInt(request.getParameter("status"));
        int sizeGroupID = validate.getInt(request.getParameter("sizeGroupID"));

        String redirectUrl = request.getParameter("redirectUrl");
        if (redirectUrl == null) redirectUrl = request.getContextPath() + "/admin/sizeoptions";

        if (validate.isBlank(label)) {
            request.getSession().setAttribute("error", "Vui lòng nhập tên (label)");
            response.sendRedirect(redirectUrl);
            return;
        }

        SizeOption s = new SizeOption(id, code, label, sortOrder, status, sizeGroupID);
        if (sizeOptionDao.update(s) > 0) {
            request.getSession().setAttribute("success", "Cập nhật thành công");
        } else {
            request.getSession().setAttribute("error", "Cập nhật thất bại");
        }
        response.sendRedirect(redirectUrl);
    }

    private void deleteSizeOption(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        String redirectUrl = request.getParameter("redirectUrl");
        if (redirectUrl == null) redirectUrl = request.getContextPath() + "/admin/sizeoptions";
        if (sizeOptionDao.delete(id) > 0) {
            request.getSession().setAttribute("success", "Xoá thành công");
        } else {
            request.getSession().setAttribute("error", "Xoá thất bại");
        }
        response.sendRedirect(redirectUrl);
    }
}
