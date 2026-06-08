<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="Quản lý thương hiệu" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Quản lý thương hiệu</h2>
                </div>
                <div class="col-auto">
                    <a href="${ctx}/admin/brands/add" class="btn btn-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="12" y1="5" x2="12" y2="19"/>
                            <line x1="5" y1="12" x2="19" y2="12"/>
                        </svg>
                        Thêm thương hiệu
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
                            <th>Logo</th>
                            <th>Tên thương hiệu</th>
                            <th>Số sản phẩm</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${brands}" var="brand" varStatus="loop">
                            <jsp:useBean id="brandDao" class="DAO.BrandDAO"/>
                            <tr>
                                <td>${(currentPage - 1) * limit + loop.index + 1}</td>
                                <td>
                                    <c:if test="${not empty brand.img}">
                                        <c:set var="imgUrl" value="${fn:startsWith(brand.img, 'http') ? brand.img : ctx.concat('/uploads/brand/').concat(brand.img)}" />
                                        <span class="avatar avatar-sm" style="background-image: url('${imgUrl}')"></span>
                                    </c:if>
                                    <c:if test="${empty brand.img}">
                                        <span class="avatar avatar-sm bg-secondary-lt">${fn:substring(brand.name, 0, 1)}</span>
                                    </c:if>
                                </td>
                                <td><strong>${brand.name}</strong></td>
                                <td>${brandDao.getNumberProductByBrand(brand.ID)}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${brand.status == 1}">
                                            <span class="badge bg-success-lt">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-lt">Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${brand.datePost}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/brands/edit/${brand.ID}" class="btn btn-sm btn-outline-primary me-1">Sửa</a>
                                    <a href="${ctx}/admin/brands/delete/${brand.ID}" class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn chắc chắn muốn xoá thương hiệu này?')">Xoá</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty brands}">
                            <tr><td colspan="7" class="text-center text-muted py-4">Chưa có thương hiệu nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
