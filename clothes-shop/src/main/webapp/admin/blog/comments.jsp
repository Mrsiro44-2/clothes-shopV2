<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="Quản lý Bình luận Blog" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">
        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Quản lý Bình luận Blog</h2>
                </div>
            </div>
            
            <form method="GET" action="${ctx}/admin/blog-comments" class="mt-3" id="filterForm">
                <input type="hidden" name="status" value="${currentStatus != null ? currentStatus : -1}" id="statusInput">
                
                <div class="row gx-2">
                    <div class="col-md-3 mb-2">
                        <select name="blogPostId" class="form-select select2-search" onchange="this.form.submit()">
                            <option value="">-- Tất cả Bài viết --</option>
                            <c:forEach items="${blogPosts}" var="p">
                                <option value="${p.ID}" ${currentBlogPostId == p.ID ? 'selected' : ''}>
                                    #${p.ID} - ${p.title}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <select name="accountId" class="form-select select2-search" onchange="this.form.submit()">
                            <option value="">-- Tất cả Người dùng --</option>
                            <c:forEach items="${accounts}" var="a">
                                <option value="${a.ID}" ${currentAccountId == a.ID ? 'selected' : ''}>
                                    ${a.fullname} (@${a.username})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm nội dung..." value="${keyword}">
                    </div>
                    <div class="col-md-2 mb-2">
                        <select name="limit" class="form-select" onchange="this.form.submit()">
                            <option value="15" ${limit == 15 ? 'selected' : ''}>15 dòng</option>
                            <option value="20" ${limit == 20 ? 'selected' : ''}>20 dòng</option>
                            <option value="50" ${limit == 50 ? 'selected' : ''}>50 dòng</option>
                        </select>
                    </div>
                    <div class="col-md-1 mb-2">
                        <button type="submit" class="btn btn-primary w-100">Lọc</button>
                    </div>
                </div>
            </form>
        </div>

        <jsp:include page="../components/flash.jsp"/>
               <ul class="nav nav-tabs mb-3" data-bs-toggle="tabs">
                    <li class="nav-item">
                        <a href="javascript:void(0)" class="nav-link ${currentStatus == -1 ? 'active' : ''}" onclick="document.getElementById('statusInput').value='-1'; document.getElementById('filterForm').submit();">Tất cả</a>
                    </li>
                    <li class="nav-item">
                        <a href="javascript:void(0)" class="nav-link ${currentStatus == 1 ? 'active' : ''}" onclick="document.getElementById('statusInput').value='1'; document.getElementById('filterForm').submit();">Đã duyệt</a>
                    </li>
                    <li class="nav-item">
                        <a href="javascript:void(0)" class="nav-link ${currentStatus == 0 ? 'active' : ''}" onclick="document.getElementById('statusInput').value='0'; document.getElementById('filterForm').submit();">Đã ẩn</a>
                    </li>
                </ul>
        <div class="card">
            <div class="table-responsive">
                <table class="table table-vcenter card-table table-striped">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Người đăng</th>
                            <th>Bài viết ID</th>
                            <th>Nội dung</th>
                            <th>Ngày đăng</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${comments}" var="comment" varStatus="loop">
                            <jsp:useBean id="accDao" class="DAO.AccountDAO"/>
                            <jsp:useBean id="postDao" class="DAO.BlogPostDAO"/>
                            <c:set var="acc" value="${comment.accountID != null ? accDao.getAccountById(comment.accountID) : null}" />
                            <c:set var="post" value="${postDao.findById(comment.blogPostID)}" />
                            
                            <tr>
                                <td>${(currentPage - 1) * limit + loop.index + 1}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty acc}">
                                            <strong>${acc.fullname}</strong><br>
                                            <small class="text-muted">${acc.email}</small>
                                        </c:when>
                                        <c:otherwise>
                                            <strong>${comment.guestName}</strong> (Khách)<br>
                                            <small class="text-muted">${comment.guestEmail}</small>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/blogs/detail/${comment.blogPostID}" target="_blank" title="${post.title}">
                                        Bài viết #${comment.blogPostID}
                                    </a>
                                </td>
                                <td>
                                    <c:if test="${not empty comment.parentCommentID and comment.parentCommentID > 0}">
                                        <div style="font-size: 11px; color: #6b7280; margin-bottom: 4px;">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round" style="width: 12px; height: 12px;"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M9 11l-4 4l4 4m-4 -4h11a4 4 0 0 0 0 -8h-1" /></svg>
                                            Trả lời cho #${comment.parentCommentID}
                                        </div>
                                    </c:if>
                                    <div class="text-wrap" style="max-width: 300px;">
                                        ${comment.body}
                                    </div>
                                </td>
                                <td>
                                    <fmt:formatDate value="${comment.datePost}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${comment.status == 1}">
                                            <span class="badge bg-success-lt">Đã duyệt</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning-lt">Đang chờ/Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${comment.status != 1}">
                                        <a href="${ctx}/admin/blog-comments/approve/${comment.ID}" class="btn btn-sm btn-outline-success me-1">Duyệt</a>
                                    </c:if>
                                    <c:if test="${comment.status == 1}">
                                        <a href="${ctx}/admin/blog-comments/hide/${comment.ID}" class="btn btn-sm btn-outline-warning me-1">Ẩn</a>
                                    </c:if>
                                    <a href="${ctx}/admin/blog-comments/delete/${comment.ID}" class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn chắc chắn muốn xoá bình luận này?')">Xoá</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty comments}">
                            <tr><td colspan="7" class="text-center text-muted py-4">Chưa có bình luận nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <c:if test="${totalPages > 1}">
                <div class="card-footer d-flex align-items-center">
                    <ul class="pagination m-0 ms-auto">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage - 1}&blogPostId=${currentBlogPostId}&accountId=${currentAccountId}&status=${currentStatus}&keyword=${keyword}&limit=${limit}" tabindex="-1">Trước</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&blogPostId=${currentBlogPostId}&accountId=${currentAccountId}&status=${currentStatus}&keyword=${keyword}&limit=${limit}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}&blogPostId=${currentBlogPostId}&accountId=${currentAccountId}&status=${currentStatus}&keyword=${keyword}&limit=${limit}">Sau</a>
                        </li>
                    </ul>
                </div>
            </c:if>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
