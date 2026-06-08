package Controllers.User;

import DAO.BlogCategoryDAO;
import DAO.BlogPostDAO;
import DAO.BlogCommentDAO;
import Model.BlogCategory;
import Model.BlogPost;
import Model.BlogComment;
import Utils.AppImages;
import Utils.ServletPaths;
import Utils.Validation;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BlogUserController", urlPatterns = {"/blog", "/blog/*"})
public class BlogUserController extends HttpServlet {

    private static final int PAGE_SIZE = 9;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BlogPostDAO dao = new BlogPostDAO();
        Validation v = new Validation();
        if (ServletPaths.relativeStartsWith(request, "/blog/detail/")) {
            String slug = ServletPaths.segmentAfter(request, "/blog/detail/");
            BlogPost post = dao.findPublishedBySlug(slug);
            if (post == null) {
                ServletPaths.redirect(request, response, "/404");
                return;
            }
            dao.incrementView(post.getID());
            
            DAO.BlogTagDAO tagDao = new DAO.BlogTagDAO();
            post.setTags(tagDao.getTagsByPostId(post.getID()));
            
            BlogCommentDAO commentDao = new BlogCommentDAO();
            List<BlogComment> allComments = commentDao.getActiveByBlogPostID(post.getID());
            List<BlogComment> parentComments = new java.util.ArrayList<>();
            java.util.Map<Integer, BlogComment> commentMap = new java.util.HashMap<>();
            for (BlogComment c : allComments) {
                commentMap.put(c.getID(), c);
                if (c.getParentCommentID() == null || c.getParentCommentID() <= 0) {
                    parentComments.add(c);
                }
            }
            for (BlogComment c : allComments) {
                if (c.getParentCommentID() != null && c.getParentCommentID() > 0) {
                    BlogComment parent = commentMap.get(c.getParentCommentID());
                    if (parent != null) {
                        parent.getReplies().add(0, c);
                    } else {
                        parentComments.add(c);
                    }
                }
            }
            
            List<BlogPost> relatedPosts = dao.getRelatedPosts(post.getID(), post.getBlogCategoryID(), 3);
            
            request.setAttribute("post", post);
            request.setAttribute("comments", parentComments);
            request.setAttribute("relatedPosts", relatedPosts);
            request.setAttribute("blogDefaultCover", AppImages.BLOG_DEFAULT_COVER);
            request.getRequestDispatcher("/user/blog-detail.jsp").forward(request, response);
            return;
        }

        int page = v.getInt(request.getParameter("page"));
        if (page <= 0) {
            page = 1;
        }
        String keyword = request.getParameter("q");
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }
        Integer categoryId = null;
        int catParam = v.getInt(request.getParameter("category"));
        if (catParam > 0) {
            categoryId = catParam;
        }

        String[] tagsParam = request.getParameterValues("tag");
        List<String> tagSlugs = null;
        if (tagsParam != null && tagsParam.length > 0) {
            tagSlugs = java.util.Arrays.asList(tagsParam);
        }

        int total = dao.countPublished(keyword, categoryId, tagSlugs);
        int totalPages = (int) Math.ceil(Math.max(total, 1) / (double) PAGE_SIZE);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        int offset = (page - 1) * PAGE_SIZE;
        List<BlogPost> posts = dao.searchPublished(keyword, categoryId, tagSlugs, offset, PAGE_SIZE);
        
        DAO.BlogTagDAO tagDao = new DAO.BlogTagDAO();
        for (BlogPost p : posts) {
            p.setTags(tagDao.getTagsByPostId(p.getID()));
        }
        
        List<BlogCategory> categories = new BlogCategoryDAO().listActive();
        List<Model.BlogTag> allTags = tagDao.getAllTags();
        
        request.setAttribute("posts", posts);
        request.setAttribute("categories", categories);
        request.setAttribute("allTags", allTags);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalPosts", total);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("categoryId", categoryId != null ? categoryId : 0);
        request.setAttribute("selectedTags", tagSlugs);
        request.setAttribute("blogDefaultCover", AppImages.BLOG_DEFAULT_COVER);
        request.getRequestDispatcher("/user/blog.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = ServletPaths.relative(request);
        if (path.startsWith("/blog/comment")) {
            BlogPostDAO postDao = new BlogPostDAO();
            BlogCommentDAO commentDao = new BlogCommentDAO();
            Validation val = new Validation();
            
            int blogPostId = val.getInt(request.getParameter("blogPostId"));
            String action = request.getParameter("action");
            if (action == null) action = "create";
            
            BlogPost post = postDao.findById(blogPostId);
            if (post == null) {
                response.sendRedirect(request.getContextPath() + "/blog");
                return;
            }
            
            String usernameUser = (String) request.getSession().getAttribute("usernameUser");
            Model.Account loggedInAcc = null;
            if (usernameUser != null) {
                DAO.AccountDAO accDao = new DAO.AccountDAO();
                loggedInAcc = accDao.getAccountByUsername(usernameUser);
            }
            
            if ("delete".equals(action)) {
                int commentId = val.getInt(request.getParameter("commentId"));
                if (loggedInAcc != null && commentId > 0) {
                    int rows = commentDao.deleteByUser(commentId, loggedInAcc.getID());
                    if (rows > 0) {
                        request.getSession().setAttribute("swalMessage", "Đã xóa bình luận thành công!");
                        request.getSession().setAttribute("swalIcon", "success");
                        request.getSession().setAttribute("swalTitle", "Thành công");
                    }
                }
                response.sendRedirect(request.getContextPath() + "/blog/detail/" + post.getSlug());
                return;
            }
            
            String body = request.getParameter("body");
            if (body == null || body.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/blog/detail/" + post.getSlug());
                return;
            }
            
            if ("edit".equals(action)) {
                int commentId = val.getInt(request.getParameter("commentId"));
                if (loggedInAcc != null && commentId > 0) {
                    int rows = commentDao.updateByUser(commentId, loggedInAcc.getID(), body.trim());
                    if (rows > 0) {
                        request.getSession().setAttribute("swalMessage", "Chỉnh sửa bình luận thành công!");
                        request.getSession().setAttribute("swalIcon", "success");
                        request.getSession().setAttribute("swalTitle", "Thành công");
                    }
                }
                response.sendRedirect(request.getContextPath() + "/blog/detail/" + post.getSlug());
                return;
            }
            
            // Default: create
            int parentCommentId = val.getInt(request.getParameter("parentCommentId"));
            String guestName = request.getParameter("guestName");
            String guestEmail = request.getParameter("guestEmail");
            
            BlogComment comment = new BlogComment();
            comment.setBlogPostID(blogPostId);
            if (parentCommentId > 0) {
                comment.setParentCommentID(parentCommentId);
            }
            comment.setBody(body.trim());
            comment.setStatus(1); // Approved by default for immediate display
            comment.setDatePost(new java.sql.Timestamp(System.currentTimeMillis()));
            
            if (loggedInAcc != null) {
                comment.setAccountID(loggedInAcc.getID());
                comment.setGuestName(loggedInAcc.getFullname());
                comment.setGuestEmail(loggedInAcc.getEmail());
            } else {
                comment.setGuestName(guestName != null && !guestName.trim().isEmpty() ? guestName.trim() : "Khách");
                comment.setGuestEmail(guestEmail != null ? guestEmail.trim() : "");
            }
            
            commentDao.insert(comment);
            
            request.getSession().setAttribute("swalMessage", "Bình luận của bạn đã được gửi thành công!");
            request.getSession().setAttribute("swalIcon", "success");
            request.getSession().setAttribute("swalTitle", "Thành công");
            
            response.sendRedirect(request.getContextPath() + "/blog/detail/" + post.getSlug());
        }
    }
}
