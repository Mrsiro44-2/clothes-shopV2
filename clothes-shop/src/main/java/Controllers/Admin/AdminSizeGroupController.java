package Controllers.Admin;

import DAO.SizeGroupDAO;
import Model.SizeGroup;
import Utils.ServletPaths;
import Utils.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminSizeGroupController", urlPatterns = {"/admin/sizegroups/*"})
public class AdminSizeGroupController extends HttpServlet {

    private SizeGroupDAO sizeGroupDao;
    private DAO.SizeOptionDAO sizeOptionDao;

    @Override
    public void init() throws ServletException {
        sizeGroupDao = new SizeGroupDAO();
        sizeOptionDao = new DAO.SizeOptionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            listSizeGroups(request, response);
        } else if (pathInfo.equals("/add")) {
            showAddForm(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            showEditForm(request, response);
        } else if (pathInfo.startsWith("/delete/")) {
            deleteSizeGroup(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.equals("/add")) {
            addSizeGroup(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/edit/")) {
            editSizeGroup(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listSizeGroups(HttpServletRequest request, HttpServletResponse response)
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
            int totalRows = sizeGroupDao.count(q, status);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.SizeGroup> sizeGroups = sizeGroupDao.getPaginated(q, status, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("sort", sort);
        request.setAttribute("sizeGroups", sizeGroups);
        
        // Fetch sizes for each group
        java.util.Map<Integer, java.util.List<Model.SizeOption>> sizeOptionsMap = new java.util.HashMap<>();
        for (Model.SizeGroup sg : sizeGroups) {
            sizeOptionsMap.put(sg.getID(), sizeOptionDao.getByGroupId(sg.getID()));
        }
        request.setAttribute("sizeOptionsMap", sizeOptionsMap);
        
        request.setAttribute("pageTitle", "Quản lý Nhóm Kích Cỡ");
        request.getRequestDispatcher("/admin/catalog/sizegroups.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("isEdit", false);
        request.setAttribute("pageTitle", "Thêm Nhóm Kích Cỡ");
        request.getRequestDispatcher("/admin/catalog/sizegroup-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        Model.SizeGroup sizeGroup = sizeGroupDao.getSizeGroupById(id);
        if (sizeGroup != null) {
            java.util.List<Model.SizeOption> sizeOptions = sizeOptionDao.getByGroupId(id);
            request.setAttribute("sizeOptions", sizeOptions);
            request.setAttribute("sizeGroup", sizeGroup);
            request.setAttribute("isEdit", true);
            request.setAttribute("pageTitle", "Sửa Nhóm Kích Cỡ");
            request.getRequestDispatcher("/admin/catalog/sizegroup-form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/sizegroups");
        }
    }

    private void addSizeGroup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Validation validate = new Validation();
        
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        int sortOrder = validate.getInt(request.getParameter("sortOrder"));
        int status = validate.getInt(request.getParameter("status"));

        if (validate.isBlank(code) || validate.isBlank(name)) {
            request.getSession().setAttribute("adminFlash", "Vui lòng nhập đủ thông tin");
            request.getSession().setAttribute("adminFlashType", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/sizegroups/add");
            return;
        }

        if (sizeGroupDao.isExistName(name, 0)) {
            request.getSession().setAttribute("adminFlash", "Tên nhóm kích cỡ này đã tồn tại. Vui lòng chọn tên khác.");
            request.getSession().setAttribute("adminFlashType", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/sizegroups/add");
            return;
        }

        SizeGroup sg = new SizeGroup(0, code, name, sortOrder, status);
        if (sizeGroupDao.insert(sg) > 0) {
            request.getSession().setAttribute("adminFlash", "Thêm nhóm kích cỡ thành công");
            request.getSession().setAttribute("adminFlashType", "success");
            response.sendRedirect(request.getContextPath() + "/admin/sizegroups");
        } else {
            request.getSession().setAttribute("adminFlash", "Có lỗi xảy ra");
            request.getSession().setAttribute("adminFlashType", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/sizegroups/add");
        }
    }

    private void editSizeGroup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        Validation validate = new Validation();
        
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        int sortOrder = validate.getInt(request.getParameter("sortOrder"));
        int status = validate.getInt(request.getParameter("status"));

        if (validate.isBlank(code) || validate.isBlank(name)) {
            request.getSession().setAttribute("adminFlash", "Vui lòng nhập đủ thông tin");
            request.getSession().setAttribute("adminFlashType", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/sizegroups/edit/" + id);
            return;
        }

        if (sizeGroupDao.isExistName(name, id)) {
            request.getSession().setAttribute("adminFlash", "Tên nhóm kích cỡ này đã tồn tại. Vui lòng chọn tên khác.");
            request.getSession().setAttribute("adminFlashType", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/sizegroups/edit/" + id);
            return;
        }

        SizeGroup sg = new SizeGroup(id, code, name, sortOrder, status);
        if (sizeGroupDao.update(sg) > 0) {
            request.getSession().setAttribute("adminFlash", "Cập nhật thành công");
            request.getSession().setAttribute("adminFlashType", "success");
        } else {
            request.getSession().setAttribute("adminFlash", "Cập nhật thất bại");
            request.getSession().setAttribute("adminFlashType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/admin/sizegroups");
    }

    private void deleteSizeGroup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        if (sizeGroupDao.delete(id) > 0) {
            request.getSession().setAttribute("adminFlash", "Xoá thành công");
            request.getSession().setAttribute("adminFlashType", "success");
        } else {
            request.getSession().setAttribute("adminFlash", "Xoá thất bại (có thể nhóm này đang được sử dụng)");
            request.getSession().setAttribute("adminFlashType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/admin/sizegroups");
    }
}
