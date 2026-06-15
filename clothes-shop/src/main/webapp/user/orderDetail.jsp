<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="./components/header.jsp" %>

<link type="text/css" rel="stylesheet" href="./user/css/checkout-v2.css" />
<style>
    .mb-order-detail-page {
        padding: 50px 0;
        background-color: #fafbfc;
    }
    .mb-detail-back-btn {
        display: inline-flex;
        align-items: center;
        margin-bottom: 24px;
        color: #64748b;
        font-weight: 500;
        text-decoration: none;
        font-size: 14px;
        transition: color 0.2s;
    }
    .mb-detail-back-btn:hover {
        color: #DB4444;
        text-decoration: none;
    }
    .mb-detail-back-btn i {
        margin-right: 8px;
    }
    
    /* Modern Header Banner */
    .mb-order-header-banner {
        background: #fff;
        border: 1px solid #eaeaea;
        border-radius: 12px;
        padding: 24px 30px;
        margin-bottom: 30px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.02);
    }
    .mb-order-id-label {
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        color: #94a3b8;
        letter-spacing: 1.5px;
        display: block;
        margin-bottom: 4px;
    }
    .mb-order-id-title {
        font-size: 26px;
        font-weight: 700;
        color: #1e293b;
        margin: 0 0 6px 0;
    }
    .mb-order-time-label {
        font-size: 13px;
        color: #64748b;
        margin: 0;
    }
    .mb-order-total-label {
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        color: #94a3b8;
        letter-spacing: 1.5px;
        display: block;
        margin-bottom: 4px;
    }
    .mb-order-total-value {
        font-size: 24px;
        font-weight: 700;
        color: #DB4444;
    }

    /* Modern Stepper */
    .mb-order-stepper-card {
        background: #fff;
        border: 1px solid #eaeaea;
        border-radius: 12px;
        padding: 30px 24px;
        margin-bottom: 30px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.02);
    }
    .mb-order-stepper {
        display: flex;
        justify-content: space-between;
        position: relative;
        padding: 0;
    }
    .mb-order-stepper::before {
        content: "";
        position: absolute;
        top: 24px;
        left: 12.5%;
        right: 12.5%;
        height: 3px;
        background-color: #f1f5f9;
        z-index: 1;
    }
    .mb-order-stepper-line {
        position: absolute;
        top: 24px;
        left: 12.5%;
        height: 3px;
        background-color: #2b2b2b;
        z-index: 2;
        transition: width 0.4s ease;
    }
    .mb-order-stepper.cancelled-state::before {
        left: 25%;
        right: 25%;
    }
    .mb-order-stepper.cancelled-state .mb-order-stepper-line {
        left: 25%;
    }
    .mb-stepper-step {
        display: flex;
        flex-direction: column;
        align-items: center;
        position: relative;
        z-index: 3;
        flex: 1;
    }
    .mb-step-icon {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background-color: #fff;
        border: 3px solid #e2e8f0;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
        color: #94a3b8;
        transition: all 0.3s;
    }
    .mb-step-label {
        margin-top: 12px;
        font-weight: 600;
        font-size: 13px;
        color: #64748b;
        text-align: center;
        transition: color 0.3s;
    }
    .mb-stepper-step.completed .mb-step-icon {
        background-color: #2b2b2b;
        border-color: #2b2b2b;
        color: #fff;
    }
    .mb-stepper-step.completed .mb-step-label {
        color: #2b2b2b;
    }
    .mb-stepper-step.active .mb-step-icon {
        border-color: #2b2b2b;
        color: #2b2b2b;
        background-color: #fff;
        box-shadow: 0 0 0 4px rgba(43,43,43,0.1);
    }
    .mb-stepper-step.active .mb-step-label {
        color: #2b2b2b;
        font-weight: 700;
    }
    .mb-stepper-step.cancelled .mb-step-icon {
        background-color: #ef4444;
        border-color: #ef4444;
        color: #fff;
    }
    .mb-stepper-step.cancelled .mb-step-label {
        color: #ef4444;
        font-weight: 700;
    }

    /* Cards */
    .mb-card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.02);
        margin-bottom: 24px;
        border: 1px solid #eaeaea;
        overflow: hidden;
    }
    .mb-card-header {
        padding: 18px 24px;
        border-bottom: 1px solid #f1f5f9;
        background-color: #fff;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .mb-card-header h3 {
        margin: 0;
        font-size: 16px;
        font-weight: 700;
        color: #1e293b;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .mb-card-header h3 i {
        margin-right: 8px;
        color: #64748b;
    }
    .mb-card-body {
        padding: 24px;
    }

    /* Products list */
    .mb-detail-row {
        display: flex;
        align-items: center;
        padding: 20px 0;
        border-bottom: 1px solid #f1f5f9;
    }
    .mb-detail-row:last-child {
        border-bottom: none;
    }
    .mb-img-container {
        width: 76px;
        height: 76px;
        background-color: #f8fafc;
        border-radius: 8px;
        border: 1px solid #e2e8f0;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #94a3b8;
        font-size: 22px;
        position: relative;
        overflow: hidden;
        margin-right: 18px;
        flex-shrink: 0;
    }
    .mb-img-container img {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        z-index: 2;
    }
    .mb-detail-info {
        flex: 1;
    }
    .mb-detail-info h4 {
        margin: 0 0 4px 0;
        font-size: 15px;
        font-weight: 600;
    }
    .mb-detail-info h4 a {
        color: #1e293b;
        text-decoration: none;
    }
    .mb-detail-info h4 a:hover {
        color: #DB4444;
    }
    .mb-detail-meta {
        font-size: 12px;
        color: #64748b;
        margin: 0;
    }
    .mb-detail-qty {
        font-size: 14px;
        color: #64748b;
        margin: 0 30px;
        min-width: 80px;
        text-align: center;
    }
    .mb-detail-price {
        font-size: 15px;
        font-weight: 700;
        color: #1e293b;
        text-align: right;
        min-width: 120px;
    }

    /* Recipient list with Icons */
    .mb-info-group {
        display: flex;
        margin-bottom: 16px;
        align-items: flex-start;
    }
    .mb-info-group:last-child {
        margin-bottom: 0;
    }
    .mb-info-icon {
        width: 36px;
        height: 36px;
        border-radius: 8px;
        background-color: #f1f5f9;
        color: #64748b;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
        margin-right: 16px;
        flex-shrink: 0;
    }
    .mb-info-content {
        flex: 1;
    }
    .mb-info-label {
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        color: #94a3b8;
        margin-bottom: 2px;
        display: block;
    }
    .mb-info-text {
        font-size: 14px;
        color: #334155;
        font-weight: 500;
        margin: 0;
    }

    /* Billing Summaries */
    .mb-price-line {
        display: flex;
        justify-content: space-between;
        margin-bottom: 12px;
        font-size: 14px;
        color: #475569;
        font-weight: 500;
    }
    .mb-price-line.grand {
        font-size: 20px;
        font-weight: 700;
        color: #DB4444;
        margin-top: 14px;
        padding-top: 14px;
        border-top: 1px dashed #e2e8f0;
    }

    /* Badges */
    .mb-badge {
        display: inline-flex;
        align-items: center;
        padding: 6px 12px;
        font-size: 12px;
        font-weight: 700;
        border-radius: 6px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .mb-badge i {
        margin-right: 6px;
    }
    .mb-badge-pending {
        background-color: #fffbeb;
        color: #b45309;
    }
    .mb-badge-paid {
        background-color: #ccfbf1;
        color: #0f766e;
    }
    .mb-badge-prepared {
        background-color: #f3e8ff;
        color: #6b21a8;
    }
    .mb-badge-delivering {
        background-color: #f0fdf4;
        color: #15803d;
    }
    .mb-badge-completed {
        background-color: #eff6ff;
        color: #1d4ed8;
    }
    .mb-badge-cancelled {
        background-color: #fef2f2;
        color: #b91c1c;
    }
</style>

<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li><a href="${ctx}/orders">Đơn hàng</a></li>
            <li class="active">Chi tiết đơn hàng #${order.ID}</li>
        </ul>
    </div>
</div>

<div class="section mb-order-detail-page">
    <div class="container">
        <a href="${ctx}/orders" class="mb-detail-back-btn"><i class="fa fa-arrow-left"></i> Quay lại danh sách đơn hàng</a>
        
        <!-- Order Header Banner -->
        <div class="mb-order-header-banner">
            <div class="row align-items-center">
                <div class="col-sm-6">
                    <span class="mb-order-id-label">MÃ ĐƠN HÀNG</span>
                    <h2 class="mb-order-id-title">#${order.ID}</h2>
                    <p class="mb-order-time-label">Đặt ngày: <fmt:formatDate value="${order.dateOrder}" pattern="dd/MM/yyyy HH:mm"/></p>
                </div>
                <div class="col-sm-6 text-sm-right text-left" style="margin-top: 15px; margin-top: 0px;">
                    <span class="mb-order-total-label">Tổng thanh toán</span>
                    <div class="mb-order-total-value">${currency.currencyFormat(order.total)}</div>
                </div>
            </div>
        </div>

        <!-- Progress Stepper -->
        <div class="mb-order-stepper-card">
            <div class="mb-order-stepper ${order.status == 2 ? 'cancelled-state' : ''}">
                <c:choose>
                    <c:when test="${order.status == 2}">
                        <!-- Cancelled Stepper -->
                        <div class="mb-order-stepper-line" style="width: 50%; background-color: #ef4444;"></div>
                        <div class="mb-stepper-step completed">
                            <div class="mb-step-icon"><i class="fa fa-shopping-bag"></i></div>
                            <div class="mb-step-label">Đã đặt hàng</div>
                        </div>
                        <div class="mb-stepper-step cancelled">
                            <div class="mb-step-icon"><i class="fa fa-times"></i></div>
                            <div class="mb-step-label">Đã hủy</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Normal Stepper -->
                        <div class="mb-order-stepper-line" style="width: ${order.status == 0 || order.status == 4 ? '0' : (order.status == 5 ? '25%' : (order.status == 1 ? '50%' : '75%'))};"></div>
                        <div class="mb-stepper-step ${(order.status >= 0 && order.status != 2) ? 'completed' : ''} ${order.status == 0 || order.status == 4 ? 'active' : ''}">
                            <div class="mb-step-icon"><i class="fa fa-shopping-bag"></i></div>
                            <div class="mb-step-label">${order.status == 4 ? 'Đã thanh toán' : 'Đã đặt hàng'}</div>
                        </div>
                        <div class="mb-stepper-step ${order.status == 5 || order.status == 1 || order.status == 3 ? 'completed' : ''} ${order.status == 5 ? 'active' : ''}">
                            <div class="mb-step-icon"><i class="fa fa-archive"></i></div>
                            <div class="mb-step-label">Chuẩn bị hàng</div>
                        </div>
                        <div class="mb-stepper-step ${order.status == 1 || order.status == 3 ? 'completed' : ''} ${order.status == 1 ? 'active' : ''}">
                            <div class="mb-step-icon"><i class="fa fa-truck"></i></div>
                            <div class="mb-step-label">Đang giao hàng</div>
                        </div>
                        <div class="mb-stepper-step ${order.status == 3 ? 'completed' : ''} ${order.status == 3 ? 'active' : ''}">
                            <div class="mb-step-icon"><i class="fa fa-check"></i></div>
                            <div class="mb-step-label">Hoàn thành</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="row">
            <!-- Left Side Details -->
            <div class="col-md-8">
                <div class="mb-card">
                    <div class="mb-card-header">
                        <h3><i class="fa fa-list"></i> Sản phẩm đã mua</h3>
                    </div>
                    <div class="mb-card-body" style="padding: 0 24px;">
                        <c:forEach items="${details}" var="d">
                            <div class="mb-detail-row">
                                <div class="mb-img-container">
                                    <i class="fa fa-shopping-bag"></i>
                                    <img class="mb-img" src="${imgUrl.resolve(d.imgProduct, ctx)}" alt="${d.nameProduct}" onerror="mbImgOnError(this)"/>
                                </div>
                                <div class="mb-detail-info">
                                    <h4><a href="${ctx}/product/detail/${d.productID}">${d.nameProduct}</a></h4>
                                    <p class="mb-detail-meta">
                                        SKU: <strong>${d.skuSnapshot}</strong>
                                        <c:if test="${not empty d.colorLabelSnapshot}"> · Màu: ${d.colorLabelSnapshot}</c:if>
                                        <c:if test="${not empty d.sizeLabelSnapshot}"> · Size: ${d.sizeLabelSnapshot}</c:if>
                                    </p>
                                </div>
                                <div class="mb-detail-qty">
                                    Số lượng: <strong>${d.numberOfProduct}</strong>
                                </div>
                                <div class="mb-detail-price">
                                    ${currency.currencyFormat(d.priceProduct * d.numberOfProduct)}
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="mb-card">
                    <div class="mb-card-header">
                        <h3><i class="fa fa-credit-card"></i> Tổng kết chi phí</h3>
                    </div>
                    <div class="mb-card-body">
                        <div class="mb-price-line">
                            <span>Tạm tính</span>
                            <strong>${currency.currencyFormat(order.subtotal)}</strong>
                        </div>
                        <div class="mb-price-line">
                            <span>Giảm giá (Voucher)
                                <c:if test="${not empty order.voucherCodeSnapshot}">
                                    <c:set var="displayVoucher" value="${fn:replace(fn:replace(order.voucherCodeSnapshot, 'PUB_', ''), 'PRI_', '')}" />
                                    <span class="badge" style="background-color:#e8f5e9; color:#2e7d32; font-weight:bold; margin-left: 6px; padding: 3px 8px;">${displayVoucher}</span>
                                </c:if>
                            </span>
                            <strong style="color: #DB4444;">-${currency.currencyFormat(order.discountAmount)}</strong>
                        </div>
                        <div class="mb-price-line grand">
                            <span>Tổng thanh toán</span>
                            <span>${currency.currencyFormat(order.total)}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Side Information Panels -->
            <div class="col-md-4">
                <!-- Order Status / Quick Actions -->
                <div class="mb-card">
                    <div class="mb-card-header">
                        <h3><i class="fa fa-info-circle"></i> Trạng thái đơn hàng</h3>
                    </div>
                    <div class="mb-card-body">
                        <div style="margin-bottom:20px">
                            <c:choose>
                                <c:when test="${order.status == 0}">
                                    <span class="mb-badge mb-badge-pending"><i class="fa fa-clock-o"></i> Chờ xử lý</span>
                                </c:when>
                                <c:when test="${order.status == 4}">
                                    <span class="mb-badge mb-badge-paid"><i class="fa fa-money"></i> Đã thanh toán</span>
                                </c:when>
                                <c:when test="${order.status == 5}">
                                    <span class="mb-badge mb-badge-prepared"><i class="fa fa-archive"></i> Đã chuẩn bị hàng</span>
                                </c:when>
                                <c:when test="${order.status == 1}">
                                    <span class="mb-badge mb-badge-delivering"><i class="fa fa-truck"></i> Đang giao</span>
                                </c:when>
                                <c:when test="${order.status == 2}">
                                    <span class="mb-badge mb-badge-cancelled"><i class="fa fa-times"></i> Đã hủy</span>
                                </c:when>
                                <c:when test="${order.status == 3}">
                                    <span class="mb-badge mb-badge-completed"><i class="fa fa-check"></i> Hoàn thành</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="mb-badge mb-badge-pending"><i class="fa fa-question-circle"></i> Khác</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="mb-info-group">
                            <div class="mb-info-icon"><i class="fa fa-credit-card-alt"></i></div>
                            <div class="mb-info-content">
                                <span class="mb-info-label">Phương thức thanh toán</span>
                                <p class="mb-info-text">
                                    <c:choose>
                                        <c:when test="${order.payment == 1}">
                                            <strong>PayOS (Chuyển khoản QR Code)</strong>
                                            <c:if test="${not empty order.transactionCode}">
                                                <br><small style="color:#64748b; font-weight:normal;">Mã GD: ${order.transactionCode}</small>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            COD (Thanh toán khi nhận hàng)
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>

                        <c:if test="${order.status == 0}">
                            <hr style="margin: 20px 0; border-color: #f1f5f9;">
                            <a href="${ctx}/orders/cancel?id=${order.ID}" class="btn btn-danger w-100" style="background-color: #DB4444; border-color: #DB4444; padding: 10px; font-weight: 600;" onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">Hủy đơn hàng</a>
                        </c:if>
                    </div>
                </div>

                <!-- Recipient Info Panel -->
                <div class="mb-card">
                    <div class="mb-card-header">
                        <h3><i class="fa fa-user"></i> Thông tin giao hàng</h3>
                    </div>
                    <div class="mb-card-body">
                        <!-- Recipient Name -->
                        <div class="mb-info-group">
                            <div class="mb-info-icon"><i class="fa fa-user-o"></i></div>
                            <div class="mb-info-content">
                                <span class="mb-info-label">Người nhận</span>
                                <p class="mb-info-text">${order.customerName}</p>
                            </div>
                        </div>

                        <!-- Phone -->
                        <div class="mb-info-group">
                            <div class="mb-info-icon"><i class="fa fa-phone"></i></div>
                            <div class="mb-info-content">
                                <span class="mb-info-label">Số điện thoại</span>
                                <p class="mb-info-text">${order.phone}</p>
                            </div>
                        </div>

                        <!-- Email -->
                        <div class="mb-info-group">
                            <div class="mb-info-icon"><i class="fa fa-envelope-o"></i></div>
                            <div class="mb-info-content">
                                <span class="mb-info-label">Email</span>
                                <p class="mb-info-text">${order.email}</p>
                            </div>
                        </div>

                        <!-- Address -->
                        <div class="mb-info-group">
                            <div class="mb-info-icon"><i class="fa fa-map-marker"></i></div>
                            <div class="mb-info-content">
                                <span class="mb-info-label">Địa chỉ giao hàng</span>
                                <p class="mb-info-text">${order.address}</p>
                            </div>
                        </div>

                        <!-- Notes -->
                        <c:if test="${not empty order.detailAddress}">
                            <div class="mb-info-group">
                                <div class="mb-info-icon"><i class="fa fa-comment-o"></i></div>
                                <div class="mb-info-content">
                                    <span class="mb-info-label">Ghi chú giao hàng</span>
                                    <p class="mb-info-text">${order.detailAddress}</p>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="./components/footer.jsp" %>
