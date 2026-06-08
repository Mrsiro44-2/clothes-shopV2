<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="pageTitle" value="Chi tiết Bài viết" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">
        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <div class="page-pretitle">Blog</div>
                    <h2 class="page-title">
                        ${post.title}
                    </h2>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a href="${ctx}/admin/blogs/edit/${post.ID}" class="btn btn-primary d-none d-sm-inline-block">
                            Chỉnh sửa
                        </a>
                        <a href="${ctx}/admin/blogs" class="btn btn-outline-secondary d-none d-sm-inline-block">
                            Quay lại
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="card mb-4">
                    <div class="card-body">
                        <c:if test="${not empty post.coverImg}">
                            <img src="${fn:startsWith(post.coverImg, 'http') || fn:startsWith(post.coverImg, '/') ? post.coverImg : ctx.concat('/uploads/blog/').concat(post.coverImg)}" 
                                 class="w-100 rounded mb-4" alt="${post.title}" style="max-height: 400px; object-fit: cover;">
                        </c:if>
                        <div class="mb-4">
                            <span class="badge bg-blue-lt me-2">${post.categoryName}</span>
                            <span class="text-muted"><fmt:formatDate value="${post.publishedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                            <c:if test="${not empty post.tags}">
                                <div class="mt-2">
                                    <c:forEach items="${post.tags}" var="tag">
                                        <span class="badge bg-secondary-lt me-1">#${tag.name}</span>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                        <c:if test="${not empty post.excerpt}">
                            <p class="lead text-muted fw-bold">
                                ${post.excerpt}
                            </p>
                        </c:if>
                        <div class="markdown">
                            ${post.contentHtml}
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-header">
                        <h3 class="card-title">Bình luận (${fn:length(comments)})</h3>
                    </div>
                    <div class="list-group list-group-flush list-group-hoverable">
                        <c:forEach items="${comments}" var="comment">
                            <jsp:useBean id="accDao" class="DAO.AccountDAO"/>
                            <c:set var="acc" value="${comment.accountID != null ? accDao.getAccountById(comment.accountID) : null}" />
                            
                            <div class="list-group-item">
                                <div class="row align-items-center">
                                    <div class="col-auto">
                                        <span class="avatar">
                                            <c:out value="${fn:substring(acc != null ? acc.fullname : comment.guestName, 0, 1)}"/>
                                        </span>
                                    </div>
                                    <div class="col text-truncate">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <strong class="text-body d-block text-truncate">
                                                ${acc != null ? acc.fullname : comment.guestName}
                                            </strong>
                                            <small class="text-muted"><fmt:formatDate value="${comment.datePost}" pattern="dd/MM/yyyy"/></small>
                                        </div>
                                        <div class="text-muted text-wrap">
                                            ${comment.body}
                                        </div>
                                        <div class="mt-2">
                                            <c:if test="${comment.status == 1}">
                                                <span class="badge bg-success-lt">Đã duyệt</span>
                                            </c:if>
                                            <c:if test="${comment.status != 1}">
                                                <span class="badge bg-warning-lt">Đang chờ</span>
                                            </c:if>
                                            <a href="${ctx}/admin/blog-comments/delete/${comment.ID}" class="text-danger small ms-2" onclick="return confirm('Xoá bình luận này?')">Xoá</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty comments}">
                            <div class="list-group-item text-center text-muted py-4">
                                Chưa có bình luận nào.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="../components/footer.jsp"%>
