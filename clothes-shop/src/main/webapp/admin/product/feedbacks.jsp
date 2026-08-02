<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="Quản lý Đánh giá" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">
        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Quản lý Đánh giá Sản phẩm</h2>
                </div>
            </div>
            <form method="GET" action="${ctx}/admin/feedbacks" class="mt-3">
                <c:if test="${not empty currentStatus}">
                    <input type="hidden" name="status" value="${currentStatus}">
                </c:if>
                <div class="row gx-2">
                    <div class="col-md-3 mb-2">
                        <select name="customerId" class="form-select select2-search" onchange="this.form.submit()">
                            <option value="">-- Tất cả Khách hàng --</option>
                            <c:forEach items="${customers}" var="c">
                                <option value="${c.ID}" ${currentCustomerId == c.ID ? 'selected' : ''}>
                                    ${c.fullname} (${c.email})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 mb-2">
                        <select name="productId" class="form-select select2-search" onchange="this.form.submit()">
                            <option value="">-- Tất cả Sản phẩm --</option>
                            <c:forEach items="${products}" var="p">
                                <option value="${p.ID}" ${currentProductId == p.ID ? 'selected' : ''}>
                                    #${p.ID} - ${p.name}
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

        <ul class="nav nav-tabs mb-3">
            <li class="nav-item">
                <a class="nav-link ${empty currentStatus ? 'active' : ''}" href="?productId=${currentProductId}&customerId=${currentCustomerId}&keyword=${keyword}&limit=${limit}">Tất cả</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 1 ? 'active' : ''}" href="?status=1&productId=${currentProductId}&customerId=${currentCustomerId}&keyword=${keyword}&limit=${limit}">Đã duyệt</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${currentStatus == 0 ? 'active' : ''}" href="?status=0&productId=${currentProductId}&customerId=${currentCustomerId}&keyword=${keyword}&limit=${limit}">Chưa duyệt</a>
            </li>
        </ul>

        <div class="card">
            <div class="table-responsive">
                <table class="table table-vcenter card-table table-striped">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Khách hàng</th>
                            <th>Sản phẩm</th>
                            <th>Đánh giá</th>
                            <th>Ngày đăng</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${feedbacks}" var="fb" varStatus="loop">
                            <jsp:useBean id="accDao" class="DAO.AccountDAO"/>
                            <c:set var="acc" value="${accDao.getAccountById(fb.userID)}" />
                            
                            <tr>
                                <td>${(currentPage - 1) * limit + loop.index + 1}</td>
                                <td>
                                    <strong>${acc.fullname}</strong><br>
                                    <small class="text-muted">${acc.email}</small>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/products/detail/${fb.productID}" target="_blank" title="Sản phẩm #${fb.productID}">
                                        ${fb.productName}
                                    </a>
                                </td>
                                <td>
                                    <div class="mb-1 text-warning">
                                        <c:forEach begin="1" end="${fb.star}">★</c:forEach>
                                        <c:forEach begin="${fb.star + 1}" end="5">☆</c:forEach>
                                    </div>
                                    <div class="text-wrap" style="max-width: 300px;">
                                        ${fb.feedback}
                                    </div>
                                </td>
                                <td>
                                    <fmt:formatDate value="${fb.datePost}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${fb.status == 1}">
                                            <span class="badge bg-success-lt">Đã duyệt</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning-lt">Đang chờ/Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${fb.status != 1}">
                                        <a href="${ctx}/admin/feedbacks/approve/${fb.ID}" class="btn btn-sm btn-outline-success me-1">Duyệt</a>
                                    </c:if>
                                    <c:if test="${fb.status == 1}">
                                        <a href="${ctx}/admin/feedbacks/hide/${fb.ID}" class="btn btn-sm btn-outline-warning me-1">Ẩn</a>
                                    </c:if>
                                    <a href="${ctx}/admin/feedbacks/delete/${fb.ID}" class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn chắc chắn muốn xoá đánh giá này?')">Xoá</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty feedbacks}">
                            <tr><td colspan="7" class="text-center text-muted py-4">Chưa có đánh giá nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <jsp:include page="../components/pagination.jsp"/>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
