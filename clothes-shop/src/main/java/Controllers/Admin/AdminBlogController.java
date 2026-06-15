package Controllers.Admin;

import DAO.BlogCategoryDAO;
import DAO.BlogPostDAO;
import Model.BlogCategory;
import Model.BlogPost;
import Utils.ServletPaths;
import Utils.Upload;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "AdminBlogController", urlPatterns = {"/admin/blogs/*"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AdminBlogController extends HttpServlet {

    private BlogPostDAO blogPostDAO;
    private BlogCategoryDAO blogCategoryDAO;
    private Upload upload;

    @Override
    public void init() throws ServletException {
        blogPostDAO = new BlogPostDAO();
        blogCategoryDAO = new BlogCategoryDAO();
        upload = new Upload();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String relative = ServletPaths.relative(request);

        if (relative.equals("/admin/blogs") || relative.equals("/admin/blogs/")) {
            List<BlogPost> posts = blogPostDAO.listAllForAdmin();
            request.setAttribute("posts", posts);
            request.setAttribute("pageTitle", "Quản lý bài viết");
            request.getRequestDispatcher("/admin/blog/index.jsp").forward(request, response);

        } else if (relative.equals("/admin/blogs/add")) {
            List<BlogCategory> categories = blogCategoryDAO.listActive();
            request.setAttribute("categories", categories);
            
            // Fetch all tags for autocomplete
            List<Model.BlogTag> allTags = new DAO.BlogTagDAO().getAllTags();
            StringBuilder tagsJson = new StringBuilder("[");
            for (int i = 0; i < allTags.size(); i++) {
                tagsJson.append("\"#").append(allTags.get(i).getName().replace("\"", "\\\"")).append("\"");
                if (i < allTags.size() - 1) tagsJson.append(",");
            }
            tagsJson.append("]");
            request.setAttribute("availableTags", tagsJson.toString());
            
            request.setAttribute("pageTitle", "Thêm bài viết mới");
            request.getRequestDispatcher("/admin/blog/form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/blogs/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/blogs/edit");
            if (id <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin/blogs");
                return;
            }
            BlogPost post = blogPostDAO.findById(id);
            if (post == null) {
                response.sendRedirect(request.getContextPath() + "/admin/blogs");
                return;
            }
            post.setTags(new DAO.BlogTagDAO().getTagsByPostId(id));
            List<BlogCategory> categories = blogCategoryDAO.listActive();
            request.setAttribute("categories", categories);
            request.setAttribute("post", post);
            
            // Fetch all tags for autocomplete
            List<Model.BlogTag> allTags = new DAO.BlogTagDAO().getAllTags();
            StringBuilder tagsJson = new StringBuilder("[");
            for (int i = 0; i < allTags.size(); i++) {
                tagsJson.append("\"#").append(allTags.get(i).getName().replace("\"", "\\\"")).append("\"");
                if (i < allTags.size() - 1) tagsJson.append(",");
            }
            tagsJson.append("]");
            request.setAttribute("availableTags", tagsJson.toString());
            
            request.setAttribute("pageTitle", "Chỉnh sửa bài viết");
            request.getRequestDispatcher("/admin/blog/form.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/blogs/detail/")) {
            int id = ServletPaths.idAfter(request, "/admin/blogs/detail");
            if (id <= 0) {
                response.sendRedirect(request.getContextPath() + "/admin/blogs");
                return;
            }
            BlogPost post = blogPostDAO.findById(id);
            if (post == null) {
                response.sendRedirect(request.getContextPath() + "/admin/blogs");
                return;
            }
            post.setTags(new DAO.BlogTagDAO().getTagsByPostId(id));
            request.setAttribute("post", post);
            
            DAO.BlogCommentDAO cDao = new DAO.BlogCommentDAO();
            request.setAttribute("comments", cDao.getByBlogPostID(id));
            
            request.setAttribute("pageTitle", "Chi tiết bài viết");
            request.getRequestDispatcher("/admin/blog/detail.jsp").forward(request, response);

        } else if (relative.startsWith("/admin/blogs/delete/")) {
            int id = ServletPaths.idAfter(request, "/admin/blogs/delete");
            if (id > 0) {
                blogPostDAO.delete(id); // Ensure delete exists in BlogPostDAO
                request.getSession().setAttribute("adminFlash", "Đã xoá bài viết thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
            response.sendRedirect(request.getContextPath() + "/admin/blogs");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String relative = ServletPaths.relative(request);

        String title = request.getParameter("title");
        String slug = request.getParameter("slug");
        String excerpt = request.getParameter("excerpt");
        String contentHtml = request.getParameter("contentHtml");
        
        Integer blogCategoryID = null;
        try { 
            int cid = Integer.parseInt(request.getParameter("blogCategoryID"));
            if (cid > 0) blogCategoryID = cid;
        } catch (Exception ignored) {}
        
        int status = 0;
        try { status = Integer.parseInt(request.getParameter("status")); } catch (Exception ignored) {}
        
        boolean isFeatured = false;
        if (request.getParameter("isFeatured") != null) {
            isFeatured = true;
        }

        // Upload Cover Image
        jakarta.servlet.http.Part filePart = request.getPart("coverImg");
        String coverImg = null;
        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = request.getServletContext().getRealPath("/uploads/blog");
            coverImg = upload.uploadImg(filePart, uploadPath);
        }

        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Tiêu đề bài viết không được để trống.");
            request.setAttribute("categories", blogCategoryDAO.listActive());
            
            // Pass back inputs
            request.setAttribute("inputTitle", title);
            request.setAttribute("inputSlug", slug);
            request.setAttribute("inputExcerpt", excerpt);
            request.setAttribute("inputContentHtml", contentHtml);
            request.setAttribute("inputBlogCategoryID", blogCategoryID);
            request.setAttribute("inputStatus", status);
            request.setAttribute("inputIsFeatured", isFeatured);

            // Fetch all tags for autocomplete
            List<Model.BlogTag> allTags = new DAO.BlogTagDAO().getAllTags();
            StringBuilder tagsJson = new StringBuilder("[");
            for (int i = 0; i < allTags.size(); i++) {
                tagsJson.append("\"#").append(allTags.get(i).getName().replace("\"", "\\\"")).append("\"");
                if (i < allTags.size() - 1) tagsJson.append(",");
            }
            tagsJson.append("]");
            request.setAttribute("availableTags", tagsJson.toString());

            if (relative.contains("/edit/")) {
                int id = ServletPaths.idAfter(request, "/admin/blogs/edit");
                request.setAttribute("post", blogPostDAO.findById(id));
                request.setAttribute("pageTitle", "Sửa bài viết");
            } else {
                request.setAttribute("pageTitle", "Thêm bài viết mới");
            }
            request.getRequestDispatcher("/admin/blog/form.jsp").forward(request, response);
            return;
        }

        if (relative.equals("/admin/blogs/add")) {
            BlogPost p = new BlogPost();
            p.setTitle(title.trim());
            p.setSlug(slug.trim());
            p.setExcerpt(excerpt);
            p.setContentHtml(contentHtml);
            p.setBlogCategoryID(blogCategoryID);
            p.setCoverImg(coverImg);
            p.setStatus(status);
            p.setFeatured(isFeatured);
            
            // Get Author Account ID from Session
            Object adminIdObj = request.getSession().getAttribute("adminAccountId");
            if (adminIdObj != null) {
                p.setAuthorAccountID((Integer) adminIdObj);
            } else {
                p.setAuthorAccountID(1); // fallback
            }
            
            if (status == 1) {
                p.setPublishedAt(new Timestamp(System.currentTimeMillis()));
            }

            int newId = blogPostDAO.insert(p);
            if (newId > 0) {
                processTags(request.getParameter("tags"), newId);
            }
            request.getSession().setAttribute("adminFlash", "Đã thêm bài viết thành công.");
            request.getSession().setAttribute("adminFlashType", "success");

        } else if (relative.startsWith("/admin/blogs/edit/")) {
            int id = ServletPaths.idAfter(request, "/admin/blogs/edit");
            BlogPost p = blogPostDAO.findById(id);
            if (p != null) {
                p.setTitle(title.trim());
                p.setSlug(slug.trim());
                p.setExcerpt(excerpt);
                p.setContentHtml(contentHtml);
                p.setBlogCategoryID(blogCategoryID);
                p.setFeatured(isFeatured);
                
                if (coverImg != null && !coverImg.isEmpty()) {
                    p.setCoverImg(coverImg);
                }
                
                // If publishing for the first time
                if (status == 1 && p.getStatus() == 0 && p.getPublishedAt() == null) {
                    p.setPublishedAt(new Timestamp(System.currentTimeMillis()));
                }
                p.setStatus(status);

                blogPostDAO.update(p);
                processTags(request.getParameter("tags"), p.getID());
                
                request.getSession().setAttribute("adminFlash", "Đã cập nhật bài viết thành công.");
                request.getSession().setAttribute("adminFlashType", "success");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/blogs");
    }

    private void processTags(String tagsStr, int postId) {
        List<Integer> tagIds = new java.util.ArrayList<>();
        if (tagsStr != null && !tagsStr.trim().isEmpty()) {
            DAO.BlogTagDAO tagDao = new DAO.BlogTagDAO();
            String[] parts = tagsStr.split(",");
            for (String part : parts) {
                String tagName = part.trim();
                // If it starts with # because of Tagify, remove it to store clean name
                if (tagName.startsWith("#")) {
                    tagName = tagName.substring(1).trim();
                }
                if (!tagName.isEmpty()) {
                    Model.BlogTag tag = tagDao.getOrCreateTag(tagName);
                    if (tag != null && tag.getId() > 0) {
                        if (!tagIds.contains(tag.getId())) {
                            tagIds.add(tag.getId());
                        }
                    }
                }
            }
            tagDao.updatePostTags(postId, tagIds);
        } else {
            new DAO.BlogTagDAO().updatePostTags(postId, new java.util.ArrayList<>());
        }
    }
}
