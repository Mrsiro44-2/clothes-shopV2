package Controllers.Admin;

import DAO.ProducerDAO;
import Model.Producer;
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

@WebServlet(name = "AdminProducerController", urlPatterns = {"/admin/producers/*"})
public class AdminProducerController extends HttpServlet {

    private ProducerDAO producerDao;
    private Validation validate;

    @Override
    public void init() throws ServletException {
        producerDao = new ProducerDAO();
        validate = new Validation();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/producers") || relative.equals("/admin/producers/")) {
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
            int totalRows = producerDao.count(q, status);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.Producer> producers = producerDao.getPaginated(q, status, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("sort", sort);
            request.setAttribute("producers", producers);
            request.setAttribute("pageTitle", "Quản lý nhà sản xuất");
            request.getRequestDispatcher("/admin/catalog/producer.jsp").forward(request, response);

        } else if (relative.equals("/admin/producers/add")) {
            request.setAttribute("pageTitle", "Thêm nhà sản xuất");
            request.getRequestDispatcher("/admin/catalog/producer-form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/producers/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/producers/edit");
            if (id <= 0) { response.sendRedirect(request.getContextPath() + "/admin/producers"); return; }
            Producer producer = producerDao.getProducerByID(id);
            if (producer == null) { response.sendRedirect(request.getContextPath() + "/admin/producers"); return; }
            request.setAttribute("producer", producer);
            request.setAttribute("pageTitle", "Sửa nhà sản xuất");
            request.getRequestDispatcher("/admin/catalog/producer-form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/producers/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/producers/delete");
            if (id > 0) {
                int productCount = producerDao.getNumberProductByProducer(id);
                if (productCount > 0) {
                    request.getSession().setAttribute("adminFlash", "Không thể xoá nhà sản xuất vì còn " + productCount + " sản phẩm thuộc nhà sản xuất này.");
                    request.getSession().setAttribute("adminFlashType", "danger");
                } else {
                    producerDao.delete(id);
                    request.getSession().setAttribute("adminFlash", "Đã xoá nhà sản xuất thành công.");
                    request.getSession().setAttribute("adminFlashType", "success");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/producers");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        String name = request.getParameter("name");
        int status = validate.getInt(request.getParameter("status"));

        // Validate
        StringBuilder errors = new StringBuilder();
        if (name == null || name.trim().isEmpty()) {
            errors.append("Tên nhà sản xuất không được để trống. ");
        } else {
            int idCheck = 0;
            if (relative.contains("/edit/")) {
                idCheck = ServletPaths.idAfter(request, "/admin/producers/edit");
            }
            if (producerDao.isExistName(name.trim(), idCheck)) {
                errors.append("Tên nhà sản xuất đã tồn tại. ");
            }
        }
        if (status != 0 && status != 1) {
            errors.append("Trạng thái không hợp lệ. ");
        }

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            if (relative.contains("/edit/")) {
                int id = ServletPaths.idAfter(request, "/admin/producers/edit");
                Producer producer = producerDao.getProducerByID(id);
                request.setAttribute("producer", producer);
                request.setAttribute("pageTitle", "Sửa nhà sản xuất");
            } else {
                request.setAttribute("pageTitle", "Thêm nhà sản xuất");
            }
            request.setAttribute("inputName", name);
            request.setAttribute("inputStatus", status);
            request.getRequestDispatcher("/admin/catalog/producer-form.jsp").forward(request, response);
            return;
        }

        if (relative.equals("/admin/producers/add")) {
            Producer p = new Producer();
            p.setName(name.trim());
            p.setStatus(status);
            p.setDatePost(new Timestamp(System.currentTimeMillis()));
            producerDao.insert(p);
            request.getSession().setAttribute("adminFlash", "Đã thêm nhà sản xuất \"" + name.trim() + "\" thành công.");
            request.getSession().setAttribute("adminFlashType", "success");
        } else if (relative.startsWith("/admin/producers/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/producers/edit");
            Producer p = producerDao.getProducerByID(id);
            if (p != null) {
                p.setName(name.trim());
                p.setStatus(status);
                p.setDateUpdate(new Timestamp(System.currentTimeMillis()));
                producerDao.update(p);
                request.getSession().setAttribute("adminFlash", "Đã cập nhật nhà sản xuất thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/producers");
    }
}
