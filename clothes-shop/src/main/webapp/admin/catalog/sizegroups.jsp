<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="Quản lý Nhóm kích cỡ" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">
        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Quản lý Nhóm kích cỡ</h2>
                </div>
                <div class="col-auto">
                    <a href="${ctx}/admin/sizegroups/add" class="btn btn-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="12" y1="5" x2="12" y2="19"/>
                            <line x1="5" y1="12" x2="19" y2="12"/>
                        </svg>
                        Thêm Nhóm kích cỡ
                    </a>
                </div>
            </div>
        </div>

        <jsp:include page="../components/flash.jsp"/>

        <div class="card">
            <jsp:include page="../components/filter.jsp"/>
            <div class="table-responsive">
                <table class="table table-vcenter card-table table-striped">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Mã nhóm</th>
                            <th>Tên Nhóm kích cỡ</th>
                            <th>Các kích cỡ</th>
                            <th>Số sản phẩm</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${sizeGroups}" var="cat" varStatus="loop">
                            <tr>
                                <td>${(currentPage - 1) * limit + loop.index + 1}</td>
                                <td>${cat.code}</td>
                                <td><strong>${cat.name}</strong></td>
                                <td>
                                    <c:set var="sizes" value="${sizeOptionsMap[cat.ID]}" />
                                    <c:choose>
                                        <c:when test="${empty sizes}">
                                            <span class="text-muted">Chưa có size</span>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="d-flex flex-wrap gap-1">
                                                <c:forEach items="${sizes}" var="sz">
                                                    <span class="badge bg-blue-lt">${sz.label}</span>
                                                </c:forEach>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span class="badge bg-purple-lt">${cat.productCount}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cat.status == 1}">
                                            <span class="badge bg-success-lt text-white">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-lt text-white">Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/sizegroups/edit/${cat.ID}" class="btn btn-sm btn-outline-primary me-1">Sửa / Thêm Size</a>
                                    <a href="${ctx}/admin/sizegroups/delete/${cat.ID}" class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn chắc chắn muốn xoá nhóm kích cỡ này?')">Xoá</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty sizeGroups}">
                            <tr><td colspan="7" class="text-center text-muted py-4">Chưa có Nhóm kích cỡ nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <jsp:include page="../components/pagination.jsp"/>
        </div>
    </div>
</div>
<%@include file="../components/footer.jsp"%>
