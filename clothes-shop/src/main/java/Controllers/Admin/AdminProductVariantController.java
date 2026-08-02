package Controllers.Admin;

import DAO.ProductVariantDAO;
import Model.ProductVariant;
import Utils.Upload;
import Utils.ServletPaths;
import Utils.Validation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;

@WebServlet(name = "AdminProductVariantController", urlPatterns = {"/admin/product-variants/*"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminProductVariantController extends HttpServlet {

    private ProductVariantDAO variantDao;

    @Override
    public void init() throws ServletException {
        variantDao = new ProductVariantDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.equals("/add")) {
            addVariant(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/edit/")) {
            editVariant(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.startsWith("/delete/")) {
            deleteVariant(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/hard-delete/")) {
            hardDeleteVariant(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void addVariant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Validation validate = new Validation();
        
        int productID = validate.getInt(request.getParameter("productID"));
        int sizeOptionID = validate.getInt(request.getParameter("sizeOptionID"));
        int colorOptionID = validate.getInt(request.getParameter("colorOptionID"));
        String sku = request.getParameter("sku");
        String barcode = request.getParameter("barcode");
        float oldPrice = Float.parseFloat(request.getParameter("oldPrice") != null && !request.getParameter("oldPrice").isEmpty() ? request.getParameter("oldPrice") : "0");
        float newPrice = Float.parseFloat(request.getParameter("newPrice") != null && !request.getParameter("newPrice").isEmpty() ? request.getParameter("newPrice") : "0");
        int quantity = validate.getInt(request.getParameter("quantity"));
        int status = validate.getInt(request.getParameter("status"));
        boolean isDefault = request.getParameter("isDefault") != null;

        String variantImg = request.getParameter("variantImgUrl");
        try {
            Part filePart = request.getPart("variantImgFile");
            if (filePart != null && filePart.getSize() > 0) {
                Upload uploader = new Upload();
                String uploadPath = request.getServletContext().getRealPath("/uploads");
                String fileName = uploader.uploadImg(filePart, uploadPath);
                if (fileName != null) {
                    variantImg = request.getContextPath() + "/uploads/" + fileName;
                }
            }
        } catch (Exception e) {
            System.out.println("No file upload: " + e);
        }

        if (validate.isBlank(sku)) {
            request.getSession().setAttribute("error", "Vui lòng nhập SKU");
            response.sendRedirect(request.getContextPath() + "/admin/products/edit/" + productID);
            return;
        }

        if (variantDao.isExist(productID, sizeOptionID, colorOptionID, -1)) {
            request.getSession().setAttribute("error", "Lỗi: Kích cỡ và Màu sắc này đã tồn tại trong sản phẩm.");
            response.sendRedirect(request.getContextPath() + "/admin/products/edit/" + productID);
            return;
        }

        ProductVariant v = new ProductVariant();
        v.setProductID(productID);
        v.setSizeOptionID(sizeOptionID);
        v.setColorOptionID(colorOptionID);
        v.setSku(sku);
        v.setBarcode(barcode);
        v.setOldPrice(oldPrice);
        v.setNewPrice(newPrice);
        v.setQuantity(quantity);
        v.setVariantImg(variantImg);
        v.setStatus(status);
        v.setDefault(isDefault);

        if (variantDao.insert(v) > 0) {
            request.getSession().setAttribute("success", "Đã thêm biến thể mới");
        } else {
            request.getSession().setAttribute("error", "Thêm thất bại (kiểm tra lại SKU có thể bị trùng)");
        }
        response.sendRedirect(request.getContextPath() + "/admin/products/edit/" + productID);
    }

    private void editVariant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        Validation validate = new Validation();
        
        int productID = validate.getInt(request.getParameter("productID"));
        int sizeOptionID = validate.getInt(request.getParameter("sizeOptionID"));
        int colorOptionID = validate.getInt(request.getParameter("colorOptionID"));
        String sku = request.getParameter("sku");
        String barcode = request.getParameter("barcode");
        float oldPrice = Float.parseFloat(request.getParameter("oldPrice") != null && !request.getParameter("oldPrice").isEmpty() ? request.getParameter("oldPrice") : "0");
        float newPrice = Float.parseFloat(request.getParameter("newPrice") != null && !request.getParameter("newPrice").isEmpty() ? request.getParameter("newPrice") : "0");
        int quantity = validate.getInt(request.getParameter("quantity"));
        int status = validate.getInt(request.getParameter("status"));
        boolean isDefault = request.getParameter("isDefault") != null;

        String variantImg = request.getParameter("variantImgUrl");
        try {
            Part filePart = request.getPart("variantImgFile");
            if (filePart != null && filePart.getSize() > 0) {
                Upload uploader = new Upload();
                String uploadPath = request.getServletContext().getRealPath("/uploads");
                String fileName = uploader.uploadImg(filePart, uploadPath);
                if (fileName != null) {
                    variantImg = request.getContextPath() + "/uploads/" + fileName;
                }
            }
        } catch (Exception e) {
            System.out.println("No file upload: " + e);
        }

        if (variantDao.isExist(productID, sizeOptionID, colorOptionID, id)) {
            request.getSession().setAttribute("error", "Lỗi: Kích cỡ và Màu sắc này đã tồn tại trong sản phẩm.");
            response.sendRedirect(request.getContextPath() + "/admin/products/edit/" + productID);
            return;
        }

        ProductVariant v = new ProductVariant();
        v.setID(id);
        v.setProductID(productID);
        v.setSizeOptionID(sizeOptionID);
        v.setColorOptionID(colorOptionID);
        v.setSku(sku);
        v.setBarcode(barcode);
        v.setOldPrice(oldPrice);
        v.setNewPrice(newPrice);
        v.setQuantity(quantity);
        if (variantImg == null || variantImg.isEmpty()) {
            ProductVariant old = variantDao.findById(id);
            if (old != null) v.setVariantImg(old.getVariantImg());
        } else {
            v.setVariantImg(variantImg);
        }
        v.setStatus(status);
        v.setDefault(isDefault);

        if (variantDao.update(v) > 0) {
            request.getSession().setAttribute("success", "Đã cập nhật biến thể");
        } else {
            request.getSession().setAttribute("error", "Cập nhật thất bại (kiểm tra lại SKU)");
        }
        response.sendRedirect(request.getContextPath() + "/admin/products/edit/" + productID);
    }

    private void deleteVariant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Mặc dù ProductVariantDAO chưa có delete, ta có thể đánh dấu status = 0 (xoá mềm)
        // Hoặc implement delete
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        String productIdStr = request.getParameter("productID");
        
        ProductVariant v = variantDao.findById(id);
        if (v != null) {
            int newStatus = v.getStatus() == 1 ? 0 : 1;
            v.setStatus(newStatus);
            variantDao.update(v);
            request.getSession().setAttribute("success", newStatus == 0 ? "Đã khoá biến thể" : "Đã mở khoá biến thể");
        }

        if (productIdStr != null && !productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products/edit/" + productIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    private void hardDeleteVariant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        String productIdStr = request.getParameter("productID");
        
        if (variantDao.hasOrders(id)) {
            request.getSession().setAttribute("adminFlash", "Không thể xoá biến thể này vì đã có đơn hàng.");
            request.getSession().setAttribute("adminFlashType", "danger");
        } else {
            String error = variantDao.delete(id);
            if (error == null) {
                request.getSession().setAttribute("adminFlash", "Đã xoá biến thể vĩnh viễn.");
                request.getSession().setAttribute("adminFlashType", "success");
            } else {
                request.getSession().setAttribute("adminFlash", error);
                request.getSession().setAttribute("adminFlashType", "danger");
            }
        }

        if (productIdStr != null && !productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products/edit/" + productIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
}
