<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="Chi tiết đơn hàng #${order.ID}" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <a href="${ctx}/admin/orders" class="btn btn-outline-secondary btn-sm mb-2">
                        ← Quay lại
                    </a>
                    <h2 class="page-title">Đơn hàng #${order.ID}</h2>
                </div>
            </div>
        </div>

        <jsp:include page="../components/flash.jsp"/>

        <div class="row row-cards">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Sản phẩm đã mua</h3>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-vcenter card-table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Biến thể</th>
                                    <th>Đơn giá</th>
                                    <th>Số lượng</th>
                                    <th>Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${details}" var="d">
                                    <tr>
                                        <td>
                                            <div class="d-flex py-1 align-items-center">
                                                <span class="avatar me-2" style="background-image: url('${d.imgProduct}')"></span>
                                                <div class="flex-fill">
                                                    <div class="font-weight-medium">${d.nameProduct}</div>
                                                    <div class="text-muted"><small>SKU: ${d.skuSnapshot}</small></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:if test="${not empty d.colorLabelSnapshot}">Màu: ${d.colorLabelSnapshot}</c:if>
                                            <c:if test="${not empty d.sizeLabelSnapshot}"><br>Size: ${d.sizeLabelSnapshot}</c:if>
                                        </td>
                                        <td><fmt:formatNumber value="${d.priceProduct}" type="currency" currencySymbol="₫"/></td>
                                        <td>x${d.numberOfProduct}</td>
                                        <td><strong><fmt:formatNumber value="${d.priceProduct * d.numberOfProduct}" type="currency" currencySymbol="₫"/></strong></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="card mt-3">
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Tạm tính:</span>
                            <span class="font-weight-medium"><fmt:formatNumber value="${order.subtotal}" type="currency" currencySymbol="₫"/></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>
                                Giảm giá (Voucher)
                                <c:if test="${not empty order.voucherCodeSnapshot}">
                                    <c:set var="displayVoucher" value="${fn:replace(fn:replace(order.voucherCodeSnapshot, 'PUB_', ''), 'PRI_', '')}" />
                                    <span class="badge bg-green-lt ms-1" style="font-weight: 600;">${displayVoucher}</span>
                                </c:if>:
                            </span>
                            <span class="text-danger font-weight-medium">-<fmt:formatNumber value="${order.discountAmount}" type="currency" currencySymbol="₫"/></span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between font-weight-bold" style="font-size: 1.25rem;">
                            <span>Tổng tiền:</span>
                            <span class="text-primary"><fmt:formatNumber value="${order.total}" type="currency" currencySymbol="₫"/></span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Cập nhật trạng thái</h3>
                    </div>
                    <div class="card-body">
                        <form action="${ctx}/admin/orders/update-status/${order.ID}" method="post">
                            <div class="mb-3">
                                <label class="form-label">Trạng thái đơn hàng</label>
                                <select name="status" class="form-select" ${order.status == 2 || order.status == 3 ? 'disabled' : ''}>
                                    <option value="0" ${order.status == 0 ? 'selected' : ''}>Chờ xử lý</option>
                                    <option value="4" ${order.status == 4 ? 'selected' : ''}>Đã thanh toán</option>
                                    <option value="5" ${order.status == 5 ? 'selected' : ''}>Đã chuẩn bị hàng</option>
                                    <option value="1" ${order.status == 1 ? 'selected' : ''}>Đang giao</option>
                                    <option value="3" ${order.status == 3 ? 'selected' : ''}>Hoàn thành</option>
                                    <option value="2" ${order.status == 2 ? 'selected' : ''}>Đã huỷ</option>
                                </select>
                            </div>
                            <c:if test="${order.status != 2 && order.status != 3}">
                                <button type="submit" class="btn btn-primary w-100">Cập nhật</button>
                            </c:if>
                            <c:if test="${order.status == 2 || order.status == 3}">
                                <div class="alert alert-info mt-2 mb-0">Đơn hàng đã chốt trạng thái, không thể thay đổi.</div>
                            </c:if>
                        </form>
                    </div>
                </div>

                <div class="card mt-3">
                    <div class="card-header">
                        <h3 class="card-title">Thông tin giao hàng</h3>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <span class="text-muted d-block mb-1 small text-uppercase font-weight-medium">Khách hàng</span>
                            <span class="font-weight-medium text-dark" style="font-size: 0.95rem;">${order.customerName}</span>
                        </div>
                        <div class="mb-3">
                            <span class="text-muted d-block mb-1 small text-uppercase font-weight-medium">Số điện thoại</span>
                            <span class="font-weight-medium text-dark" style="font-size: 0.95rem;">${order.phone}</span>
                        </div>
                        <div class="mb-3">
                            <span class="text-muted d-block mb-1 small text-uppercase font-weight-medium">Email</span>
                            <span class="text-dark text-break" style="font-size: 0.95rem;">${order.email}</span>
                        </div>
                        <div class="mb-3">
                            <span class="text-muted d-block mb-1 small text-uppercase font-weight-medium">Địa chỉ giao hàng</span>
                            <span class="text-dark d-block font-weight-medium" style="font-size: 0.95rem;">${order.detailAddress}</span>
                            <span class="text-muted small">${order.address}</span>
                        </div>
                        <div class="mb-3">
                            <span class="text-muted d-block mb-1 small text-uppercase font-weight-medium">Ngày đặt</span>
                            <span class="text-dark" style="font-size: 0.95rem;"><fmt:formatDate value="${order.dateOrder}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                        <c:if test="${not empty order.voucherCodeSnapshot}">
                            <c:set var="displayVoucher" value="${fn:replace(fn:replace(order.voucherCodeSnapshot, 'PUB_', ''), 'PRI_', '')}" />
                            <div class="mb-3">
                                <span class="text-muted d-block mb-1 small text-uppercase font-weight-medium">Voucher áp dụng</span>
                                <span class="badge bg-green-lt font-weight-bold" style="font-size: 0.85rem; padding: 4px 8px;">${displayVoucher}</span>
                            </div>
                        </c:if>
                        <div class="mb-0">
                            <span class="text-muted d-block mb-1 small text-uppercase font-weight-medium">Thanh toán</span>
                            <div>
                                <c:choose>
                                    <c:when test="${order.payment == 1}">
                                        <span class="badge bg-green-lt" style="font-size: 0.85rem; padding: 4px 8px;">PayOS</span>
                                        <div class="small text-muted mt-1">Mã GD: ${order.transactionCode}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-orange-lt" style="font-size: 0.85rem; padding: 4px 8px;">Thanh toán khi nhận hàng (COD)</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
