<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${pageTitle}" scope="request"/>
<jsp:include page="/admin/components/header.jsp" />

<!-- Page header -->
<div class="page-header d-print-none">
    <div class="container-xl">
        <div class="row g-2 align-items-center">
            <div class="col">
                <h2 class="page-title">
                    Quản lý danh mục Blog
                </h2>
            </div>
            <!-- Page title actions -->
            <div class="col-auto ms-auto d-print-none">
                <div class="btn-list">
                    <a href="${pageContext.request.contextPath}/admin/blog-categories/add" class="btn btn-primary d-none d-sm-inline-block">
                        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 5l0 14" /><path d="M5 12l14 0" /></svg>
                        Thêm mới
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Page body -->
<div class="page-body">
    <div class="container-xl">
        
        <jsp:include page="/admin/components/flash.jsp" />

        <div class="row row-deck row-cards">
            <div class="col-12">
                <div class="card">
                    <div class="table-responsive">
                        <table class="table card-table table-vcenter text-nowrap datatable">
                            <thead>
                                <tr>
                                    <th class="w-1">ID</th>
                                    <th>Ảnh Cover</th>
                                    <th>Tên danh mục</th>
                                    <th>Đường dẫn (Slug)</th>
                                    <th>Thứ tự</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${categories}" var="c">
                                    <tr>
                                        <td><span class="text-muted">${c.ID}</span></td>
                                        <td>
                                            <c:if test="${not empty c.coverImg}">
                                                <img src="${pageContext.request.contextPath}/uploads/blog/${c.coverImg}" style="height: 40px; border-radius: 4px; object-fit: cover; width: 60px;">
                                            </c:if>
                                        </td>
                                        <td><strong>${c.name}</strong></td>
                                        <td>${c.slug}</td>
                                        <td>${c.sortOrder}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.status == 1}">
                                                    <span class="badge bg-success me-1"></span> Hoạt động
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger me-1"></span> Ẩn
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/blog-categories/edit/${c.ID}" class="btn btn-sm btn-outline-primary me-1">Sửa</a>
                                            <a href="javascript:void(0)" class="btn btn-sm btn-outline-danger" onclick="confirmDelete('${pageContext.request.contextPath}/admin/blog-categories/delete/${c.ID}')">Xóa</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function confirmDelete(url) {
    if(confirm('Bạn có chắc chắn muốn xóa danh mục này? Mọi bài viết thuộc danh mục này sẽ mất liên kết.')) {
        window.location.href = url;
    }
}
</script>

<jsp:include page="/admin/components/footer.jsp" />
