package Controllers.Admin;

import DAO.VoucherDAO;
import Model.Voucher;
import Utils.ServletPaths;
import Utils.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminVoucherController", urlPatterns = {"/admin/vouchers/*"})
public class AdminVoucherController extends HttpServlet {

    private VoucherDAO voucherDao;
    private Validation validate;

    @Override
    public void init() throws ServletException {
        voucherDao = new VoucherDAO();
        validate = new Validation();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/vouchers") || relative.equals("/admin/vouchers/")) {
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
            int totalRows = voucherDao.count(q, status);
            int totalPages = (int) Math.ceil((double) totalRows / limit);
            java.util.List<Model.Voucher> vouchers = voucherDao.getPaginated(q, status, sort, page, limit);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("limit", limit);
            request.setAttribute("q", q);
            request.setAttribute("status", status);
            request.setAttribute("sort", sort);
            request.setAttribute("vouchers", vouchers);
            request.setAttribute("pageTitle", "Quản lý mã giảm giá");
            request.getRequestDispatcher("/admin/voucher/index.jsp").forward(request, response);

        } else if (relative.equals("/admin/vouchers/add")) {
            request.setAttribute("pageTitle", "Thêm mã giảm giá");
            request.getRequestDispatcher("/admin/voucher/form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/vouchers/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/vouchers/edit");
            if (id <= 0) { response.sendRedirect(request.getContextPath() + "/admin/vouchers"); return; }
            Voucher v = voucherDao.getVoucherById(id);
            if (v == null) { response.sendRedirect(request.getContextPath() + "/admin/vouchers"); return; }
            request.setAttribute("voucher", v);
            request.setAttribute("pageTitle", "Sửa mã giảm giá");
            request.getRequestDispatcher("/admin/voucher/form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/vouchers/detail/")) {
            int id = ServletPaths.idAfter(request, "/admin/vouchers/detail");
            if (id <= 0) { response.sendRedirect(request.getContextPath() + "/admin/vouchers"); return; }
            Voucher v = voucherDao.getVoucherById(id);
            if (v == null) { response.sendRedirect(request.getContextPath() + "/admin/vouchers"); return; }
            
            DAO.BillDAO billDao = new DAO.BillDAO();
            java.util.List<Model.Bill> bills = billDao.getBillsByVoucherId(id);
            
            request.setAttribute("voucher", v);
            request.setAttribute("bills", bills);
            request.setAttribute("pageTitle", "Chi tiết mã giảm giá");
            request.getRequestDispatcher("/admin/voucher/detail.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/vouchers/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/vouchers/delete");
            if (id > 0) {
                int count = voucherDao.getNumberOrderUsed(id);
                if (count > 0) {
                    request.getSession().setAttribute("adminFlash", "Không thể xoá vì mã giảm giá này đã được sử dụng trong " + count + " đơn hàng.");
                    request.getSession().setAttribute("adminFlashType", "danger");
                } else {
                    voucherDao.delete(id);
                    request.getSession().setAttribute("adminFlash", "Đã xoá mã giảm giá thành công.");
                    request.getSession().setAttribute("adminFlashType", "success");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/vouchers");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        String name = request.getParameter("name");
        String code = request.getParameter("code");
        String accessType = request.getParameter("accessType");
        if (accessType != null && !accessType.isEmpty() && code != null) {
            code = accessType + code.trim();
        }
        int discountType = validate.getInt(request.getParameter("discountType"));
        float value = validate.getFloat(request.getParameter("value"));
        float minOrderAmount = validate.getFloat(request.getParameter("minOrderAmount"));
        
        String maxDiscountStr = request.getParameter("maxDiscount");
        Float maxDiscount = (maxDiscountStr != null && !maxDiscountStr.trim().isEmpty()) ? Float.parseFloat(maxDiscountStr) : null;
        
        String usageLimitStr = request.getParameter("usageLimit");
        Integer usageLimit = (usageLimitStr != null && !usageLimitStr.trim().isEmpty()) ? Integer.parseInt(usageLimitStr) : null;
        
        String startStr = request.getParameter("start");
        String endStr = request.getParameter("end");
        Date start = (startStr != null && !startStr.isEmpty()) ? Date.valueOf(startStr) : null;
        Date end = (endStr != null && !endStr.isEmpty()) ? Date.valueOf(endStr) : null;
        
        int status = validate.getInt(request.getParameter("status"));

        StringBuilder errors = new StringBuilder();
        if (name == null || name.trim().isEmpty()) errors.append("Tên voucher không được để trống. ");
        if (code == null || code.trim().isEmpty()) errors.append("Mã voucher không được để trống. ");
        if (value <= 0) errors.append("Giá trị giảm phải lớn hơn 0. ");
        if (discountType == 1 && value > 100) errors.append("Giảm theo % không được vượt quá 100%. ");
        java.time.LocalDate todayDate = java.time.LocalDate.now();
        if (start == null || end == null) {
            errors.append("Vui lòng chọn ngày bắt đầu và kết thúc. ");
        } else {
            java.time.LocalDate startDate = start.toLocalDate();
            java.time.LocalDate endDate = end.toLocalDate();
            
            if (endDate.isBefore(startDate)) {
                errors.append("Ngày kết thúc phải sau ngày bắt đầu. ");
            }
            if (relative.equals("/admin/vouchers/add") && startDate.isBefore(todayDate)) {
                errors.append("Ngày bắt đầu không được chọn trong quá khứ. ");
            }
            if (endDate.isBefore(todayDate)) {
                errors.append("Ngày kết thúc không được chọn trong quá khứ. ");
            }
        }
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString().trim());
            if (relative.contains("/edit/")) {
                int id = ServletPaths.idAfter(request, "/admin/vouchers/edit");
                request.setAttribute("voucher", voucherDao.getVoucherById(id));
                request.setAttribute("pageTitle", "Sửa mã giảm giá");
            } else {
                request.setAttribute("pageTitle", "Thêm mã giảm giá");
            }
            request.getRequestDispatcher("/admin/voucher/form.jsp").forward(request, response);
            return;
        }

        if (relative.equals("/admin/vouchers/add")) {
            Voucher v = new Voucher();
            v.setName(name.trim());
            v.setCode(code.trim().toUpperCase());
            v.setDiscountType(discountType);
            v.setValue(value);
            v.setMinOrderAmount(minOrderAmount);
            v.setMaxDiscount(maxDiscount);
            v.setUsageLimit(usageLimit);
            v.setUsed(0);
            v.setStart(start);
            v.setEnd(end);
            v.setStatus(status);
            
            if (voucherDao.insert(v)) {
                request.getSession().setAttribute("adminFlash", "Đã thêm voucher thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            } else {
                request.getSession().setAttribute("adminFlash", "Mã voucher có thể đã tồn tại.");
                request.getSession().setAttribute("adminFlashType", "danger");
            }
        } else if (relative.startsWith("/admin/vouchers/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/vouchers/edit");
            Voucher v = voucherDao.getVoucherById(id);
            if (v != null) {
                v.setName(name.trim());
                v.setCode(code.trim().toUpperCase());
                v.setDiscountType(discountType);
                v.setValue(value);
                v.setMinOrderAmount(minOrderAmount);
                v.setMaxDiscount(maxDiscount);
                v.setUsageLimit(usageLimit);
                v.setStart(start);
                v.setEnd(end);
                v.setStatus(status);
                if (voucherDao.update(v)) {
                    request.getSession().setAttribute("adminFlash", "Đã cập nhật voucher thành công.");
                    request.getSession().setAttribute("adminFlashType", "success");
                } else {
                    request.getSession().setAttribute("adminFlash", "Có lỗi xảy ra khi cập nhật.");
                    request.getSession().setAttribute("adminFlashType", "danger");
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/vouchers");
    }
}
