package Model;

import java.sql.Timestamp;

public class BlogComment {
    private int ID;
    private int blogPostID;
    private Integer accountID;
    private String guestName;
    private String guestEmail;
    private String body;
    private int status;
    private Integer parentCommentID;
    private Timestamp datePost;
    private Timestamp dateUpdate;

    public BlogComment() {
    }

    public BlogComment(int ID, int blogPostID, Integer accountID, String guestName, String guestEmail, String body, int status, Integer parentCommentID, Timestamp datePost, Timestamp dateUpdate) {
        this.ID = ID;
        this.blogPostID = blogPostID;
        this.accountID = accountID;
        this.guestName = guestName;
        this.guestEmail = guestEmail;
        this.body = body;
        this.status = status;
        this.parentCommentID = parentCommentID;
        this.datePost = datePost;
        this.dateUpdate = dateUpdate;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getBlogPostID() {
        return blogPostID;
    }

    public void setBlogPostID(int blogPostID) {
        this.blogPostID = blogPostID;
    }

    public Integer getAccountID() {
        return accountID;
    }

    public void setAccountID(Integer accountID) {
        this.accountID = accountID;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getGuestEmail() {
        return guestEmail;
    }

    public void setGuestEmail(String guestEmail) {
        this.guestEmail = guestEmail;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Integer getParentCommentID() {
        return parentCommentID;
    }

    public void setParentCommentID(Integer parentCommentID) {
        this.parentCommentID = parentCommentID;
    }

    public Timestamp getDatePost() {
        return datePost;
    }

    public void setDatePost(Timestamp datePost) {
        this.datePost = datePost;
    }

    public Timestamp getDateUpdate() {
        return dateUpdate;
    }

    public void setDateUpdate(Timestamp dateUpdate) {
        this.dateUpdate = dateUpdate;
    }
    
    private java.util.List<BlogComment> replies = new java.util.ArrayList<>();

    public java.util.List<BlogComment> getReplies() {
        return replies;
    }

    public void setReplies(java.util.List<BlogComment> replies) {
        this.replies = replies;
    }
}
