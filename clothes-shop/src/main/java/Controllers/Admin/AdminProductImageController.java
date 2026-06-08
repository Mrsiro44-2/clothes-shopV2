package Controllers.Admin;

import DAO.ImgDescriptionDAO;
import Model.ImgDescription;
import Utils.Upload;
import Utils.ServletPaths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;

@WebServlet(name = "AdminProductImageController", urlPatterns = {"/admin/product-images/*"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminProductImageController extends HttpServlet {

    private ImgDescriptionDAO imgDao;

    @Override
    public void init() throws ServletException {
        imgDao = new ImgDescriptionDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.equals("/add")) {
            addImage(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.startsWith("/delete/")) {
            deleteImage(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void addImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int productId = Integer.parseInt(request.getParameter("productID"));
        int sortOrder = Integer.parseInt(request.getParameter("sortOrder"));

        String imgUrl = request.getParameter("imgUrl");
        try {
            Part filePart = request.getPart("imgFile");
            if (filePart != null && filePart.getSize() > 0) {
                Upload uploader = new Upload();
                String uploadPath = request.getServletContext().getRealPath("/uploads");
                String fileName = uploader.uploadImg(filePart, uploadPath);
                if (fileName != null) {
                    imgUrl = request.getContextPath() + "/uploads/" + fileName;
                }
            }
        } catch (Exception e) {
            System.out.println("No file upload: " + e);
        }

        if (imgUrl != null && !imgUrl.isEmpty()) {
            ImgDescription img = new ImgDescription(0, imgUrl, productId, sortOrder);
            imgDao.insert(img);
            request.getSession().setAttribute("success", "Đã thêm hình ảnh");
        } else {
            request.getSession().setAttribute("error", "Vui lòng chọn ảnh hoặc nhập URL");
        }
        response.sendRedirect(request.getContextPath() + "/admin/products/edit/" + productId);
    }

    private void deleteImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ServletPaths.getIdFromPath(request.getPathInfo());
        String productIdStr = request.getParameter("productID");
        if (imgDao.delete(id) > 0) {
            request.getSession().setAttribute("success", "Đã xoá hình ảnh");
        } else {
            request.getSession().setAttribute("error", "Xoá thất bại");
        }
        
        if (productIdStr != null && !productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products/edit/" + productIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
}
