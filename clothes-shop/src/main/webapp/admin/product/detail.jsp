<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:useBean id="imgUrl" class="Utils.ImageUrl" scope="application"/>
<c:set var="pageTitle" value="Chi tiết Sản phẩm" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">
        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <div class="page-pretitle">Sản phẩm #${product.ID}</div>
                    <h2 class="page-title">
                        ${product.name}
                    </h2>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a href="${ctx}/admin/products/edit/${product.ID}" class="btn btn-primary d-none d-sm-inline-block">
                            Chỉnh sửa
                        </a>
                        <a href="${ctx}/admin/products" class="btn btn-outline-secondary d-none d-sm-inline-block">
                            Quay lại
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Cột trái: Thông tin và mô tả -->
            <div class="col-lg-8">
                <div class="card mb-4">
                    <div class="card-header">
                        <h3 class="card-title">Thông tin cơ bản</h3>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-4 text-muted">Mã sản phẩm (Model):</div>
                            <div class="col-8"><strong>${product.model}</strong></div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-4 text-muted">Giá bán:</div>
                            <div class="col-8 text-primary"><strong><fmt:formatNumber value="${product.newPrice}" type="currency" currencyCode="VND" maxFractionDigits="0"/></strong></div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-4 text-muted">Trạng thái:</div>
                            <div class="col-8">
                                <c:choose>
                                    <c:when test="${product.status == 1}"><span class="badge bg-success-lt">Hiển thị</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary-lt">Ẩn</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header">
                        <h3 class="card-title">Mô tả sản phẩm</h3>
                    </div>
                    <div class="card-body">
                        <div class="markdown">
                            ${product.description}
                        </div>
                    </div>
                </div>
                
                <div class="card mb-4">
                    <div class="card-header">
                        <h3 class="card-title">Đánh giá của khách hàng (${fn:length(feedbacks)})</h3>
                    </div>
                    <div class="list-group list-group-flush list-group-hoverable">
                        <c:forEach items="${feedbacks}" var="fb">
                            <jsp:useBean id="accDao" class="DAO.AccountDAO"/>
                            <c:set var="acc" value="${accDao.getAccountById(fb.userID)}" />
                            
                            <div class="list-group-item">
                                <div class="row align-items-center">
                                    <div class="col-auto">
                                        <span class="avatar">
                                            <c:out value="${fn:substring(acc.fullname, 0, 1)}"/>
                                        </span>
                                    </div>
                                    <div class="col text-truncate">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <strong class="text-body d-block text-truncate">
                                                ${acc.fullname}
                                            </strong>
                                            <small class="text-muted"><fmt:formatDate value="${fb.datePost}" pattern="dd/MM/yyyy"/></small>
                                        </div>
                                        <div class="text-warning mb-1">
                                            <c:forEach begin="1" end="${fb.star}">★</c:forEach>
                                            <c:forEach begin="${fb.star + 1}" end="5">☆</c:forEach>
                                        </div>
                                        <div class="text-muted text-wrap">
                                            ${fb.feedback}
                                        </div>
                                        <div class="mt-2">
                                            <c:if test="${fb.status == 1}">
                                                <span class="badge bg-success-lt">Đã duyệt</span>
                                            </c:if>
                                            <c:if test="${fb.status != 1}">
                                                <span class="badge bg-warning-lt">Đang chờ</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty feedbacks}">
                            <div class="list-group-item text-center text-muted py-4">
                                Sản phẩm chưa có đánh giá.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <!-- Cột phải: Ảnh đại diện, Gallery và Biến thể -->
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-header">
                        <h3 class="card-title">Ảnh đại diện</h3>
                    </div>
                    <div class="card-body text-center">
                        <c:if test="${not empty product.mainImg}">
                            <img src="${imgUrl.resolve(product.mainImg, ctx)}" 
                                 class="w-100 rounded" alt="${product.name}" style="max-height: 300px; object-fit: cover;">
                        </c:if>
                    </div>
                </div>
                
                <c:if test="${not empty images}">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h3 class="card-title">Thư viện ảnh (${fn:length(images)})</h3>
                        </div>
                        <div class="card-body">
                            <div class="row g-2">
                                <c:forEach items="${images}" var="img">
                                    <div class="col-4">
                                        <img src="${imgUrl.resolve(img.imgUrl, ctx)}" 
                                             class="rounded w-100" style="aspect-ratio: 1; object-fit: cover;">
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </c:if>

                <div class="card mb-4">
                    <div class="card-header">
                        <h3 class="card-title">Biến thể (${fn:length(variants)})</h3>
                    </div>
                    <div class="list-group list-group-flush">
                        <c:forEach items="${variants}" var="v">
                            <div class="list-group-item d-flex align-items-center">
                                <div class="me-3">
                                    <span class="badge bg-blue-lt">SKU: ${v.sku}</span>
                                </div>
                                <div class="flex-fill">
                                    <c:forEach items="${colors}" var="c">
                                        <c:if test="${c.ID == v.colorOptionID}">
                                            <span style="display: inline-block; width: 14px; height: 14px; border-radius: 50%; background-color: ${c.hexCode != null ? c.hexCode : '#000'}; border: 1px solid #ccc; vertical-align: middle;"></span>
                                            <span class="ms-1 align-middle">${c.name}</span>
                                        </c:if>
                                    </c:forEach>
                                    <c:forEach items="${sizes}" var="s">
                                        <c:if test="${s.ID == v.sizeOptionID}">
                                            <span class="badge bg-secondary-lt ms-1">${s.label}</span>
                                        </c:if>
                                    </c:forEach>
                                </div>
                                <div>
                                    <span class="badge ${v.quantity > 0 ? 'bg-success text-white' : 'bg-danger text-white'}">${v.quantity} kho</span>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty variants}">
                            <div class="list-group-item text-center text-muted">Không có biến thể nào</div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="../components/footer.jsp"%>
