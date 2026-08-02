<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="Quản lý danh mục" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Quản lý danh mục</h2>
                </div>
                <div class="col-auto">
                    <a href="${ctx}/admin/categories/add" class="btn btn-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="12" y1="5" x2="12" y2="19"/>
                            <line x1="5" y1="12" x2="19" y2="12"/>
                        </svg>
                        Thêm danh mục
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
                            <th>Tên danh mục</th>
                            <th>Nhóm kích cỡ</th>
                            <th>Số sản phẩm</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${categories}" var="cat" varStatus="loop">
                            <jsp:useBean id="catDao" class="DAO.CategoryDAO"/>
                            <tr>
                                <td>${(currentPage - 1) * limit + loop.index + 1}</td>
                                <td><strong>${cat.name}</strong></td>
                                <td>${not empty cat.sizeGroupName ? cat.sizeGroupName : '<span class="text-muted">Mặc định</span>'}</td>
                                <td>${catDao.getNumberProductByCategory(cat.ID)}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cat.status == 1}">
                                            <span class="badge bg-success-lt">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-lt">Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${cat.datePost}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/categories/edit/${cat.ID}" class="btn btn-sm btn-outline-primary me-1">Sửa</a>
                                    <a href="${ctx}/admin/categories/delete/${cat.ID}" class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn chắc chắn muốn xoá danh mục này?')">Xoá</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty categories}">
                            <tr><td colspan="7" class="text-center text-muted py-4">Chưa có danh mục nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <jsp:include page="../components/pagination.jsp"/>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
