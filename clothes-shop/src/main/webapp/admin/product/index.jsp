<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="imgUrl" class="Utils.ImageUrl" scope="application"/>
<c:set var="pageTitle" value="Quản lý sản phẩm" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Quản lý sản phẩm</h2>
                </div>
                <div class="col-auto">
                    <a href="${ctx}/admin/products/add" class="btn btn-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="12" y1="5" x2="12" y2="19"/>
                            <line x1="5" y1="12" x2="19" y2="12"/>
                        </svg>
                        Thêm sản phẩm
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
                            <th>Sản phẩm</th>
                            <th>Mã model</th>
                            <th>Độ ưu tiên</th>
                            <th>Ngày đăng</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${products}" var="p" varStatus="loop">
                            <tr>
                                <td>
                                    <div class="d-flex py-1 align-items-center">
                                        <span class="avatar me-2" style="background-image: url('${imgUrl.resolve(p.mainImg, ctx)}')"></span>
                                        <div class="flex-fill">
                                            <div class="font-weight-medium">${p.name}</div>
                                            <div class="text-muted"><small>Slug: ${p.slug}</small></div>
                                        </div>
                                    </div>
                                </td>
                                <td class="text-muted">${p.model}</td>
                                <td>${p.priority}</td>
                                <td><fmt:formatDate value="${p.datePost}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.status == 1}">
                                            <span class="badge bg-success-lt">Hiển thị</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-lt">Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/products/detail/${p.ID}" class="btn btn-sm btn-outline-info me-1">Chi tiết</a>
                                    <a href="${ctx}/admin/products/edit/${p.ID}" class="btn btn-sm btn-outline-primary me-1">Sửa</a>
                                    <a href="${ctx}/admin/products/delete/${p.ID}" class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn chắc chắn muốn xoá sản phẩm này? Việc xoá có thể thất bại nếu sản phẩm đã có đơn hàng/biến thể.')">Xoá</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty products}">
                            <tr><td colspan="6" class="text-center text-muted py-4">Chưa có sản phẩm nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <jsp:include page="../components/pagination.jsp"/>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
