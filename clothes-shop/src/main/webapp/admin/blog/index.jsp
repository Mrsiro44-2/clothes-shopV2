<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${pageTitle}" scope="request"/>
<jsp:include page="/admin/components/header.jsp" />

<div class="page-header d-print-none">
    <div class="container-xl">
        <div class="row g-2 align-items-center">
            <div class="col">
                <h2 class="page-title">
                    Quản lý bài viết Blog
                </h2>
            </div>
            <div class="col-auto ms-auto d-print-none">
                <div class="btn-list">
                    <a href="${pageContext.request.contextPath}/admin/blogs/add" class="btn btn-primary d-none d-sm-inline-block">
                        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 5l0 14" /><path d="M5 12l14 0" /></svg>
                        Thêm bài viết mới
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="page-body">
    <div class="container-xl">
        
        <jsp:include page="/admin/components/flash.jsp" />

        <div class="row row-deck row-cards">
            <div class="col-12">
                <div class="card">
                    <jsp:include page="/admin/components/filter.jsp" />
                    <div class="table-responsive">
                        <table class="table card-table table-vcenter text-nowrap datatable">
                            <thead>
                                <tr>
                                    <th class="w-1">STT</th>
                                    <th>ID</th>
                                    <th>Ảnh Cover</th>
                                    <th>Tiêu đề</th>
                                    <th>Danh mục</th>
                                    <th>Tác giả</th>
                                    <th>Lượt xem</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${posts}" var="p" varStatus="loop">
                                    <tr>
                                        <td>${(currentPage - 1) * limit + loop.index + 1}</td>
                                        <td><span class="text-muted">${p.ID}</span></td>
                                        <td>
                                            <c:if test="${not empty p.coverImg}">
                                                <img src="${pageContext.request.contextPath}/uploads/blog/${p.coverImg}" style="height: 40px; border-radius: 4px; object-fit: cover; width: 60px;">
                                            </c:if>
                                        </td>
                                        <td class="text-wrap" style="max-width: 300px;">
                                            <strong>${p.title}</strong>
                                            <c:if test="${p.featured}">
                                                <span class="badge bg-yellow text-yellow-fg ms-1">Nổi bật</span>
                                            </c:if>
                                        </td>
                                        <td>${not empty p.categoryName ? p.categoryName : '<span class="text-muted">Chưa phân loại</span>'}</td>
                                        <td>${p.authorName}</td>
                                        <td>${p.viewCount}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.status == 1}">
                                                    <span class="badge bg-success me-1"></span> Đã xuất bản
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning me-1"></span> Bản nháp
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/blogs/detail/${p.ID}" class="btn btn-sm btn-outline-info me-1">Chi tiết</a>
                                            <a href="${pageContext.request.contextPath}/admin/blogs/edit/${p.ID}" class="btn btn-sm btn-outline-primary me-1">Sửa</a>
                                            <a href="javascript:void(0)" class="btn btn-sm btn-outline-danger" onclick="confirmDelete('${pageContext.request.contextPath}/admin/blogs/delete/${p.ID}')">Xóa</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty posts}">
                                    <tr>
                                        <td colspan="9" class="text-center text-muted py-4">Chưa có bài viết nào</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    <jsp:include page="/admin/components/pagination.jsp" />
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function confirmDelete(url) {
    if(confirm('Bạn có chắc chắn muốn xóa bài viết này không? Hành động này không thể hoàn tác.')) {
        window.location.href = url;
    }
}
</script>

<jsp:include page="/admin/components/footer.jsp" />
