<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="Utils.AppConfig"%>
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
                                <select name="status" id="statusSelect" class="form-select" ${order.status == 3 || order.status == 7 || (order.status == 2 && order.payment != 1) ? 'disabled' : ''}>
                                    <c:choose>
                                        <c:when test="${order.status == 0}">
                                            <option value="0" selected>Chờ xử lý</option>
                                            <c:if test="${order.payment == 1}">
                                                <option value="4">Đã thanh toán</option>
                                            </c:if>
                                            <c:if test="${order.payment != 1}">
                                                <option value="5">Đã chuẩn bị hàng</option>
                                            </c:if>
                                            <option value="2">Đã huỷ</option>
                                        </c:when>
                                        <c:when test="${order.status == 4}">
                                            <option value="4" selected>Đã thanh toán</option>
                                            <option value="5">Đã chuẩn bị hàng</option>
                                            <option value="2">Đã huỷ</option>
                                        </c:when>
                                        <c:when test="${order.status == 5}">
                                            <option value="5" selected>Đã chuẩn bị hàng</option>
                                            <option value="6">Đã giao ĐVVC</option>
                                            <option value="1">Đang giao</option>
                                            <option value="2">Đã huỷ</option>
                                        </c:when>
                                        <c:when test="${order.status == 6}">
                                            <option value="6" selected>Đã giao ĐVVC</option>
                                            <option value="1">Đang giao</option>
                                            <option value="2">Đã huỷ</option>
                                        </c:when>
                                        <c:when test="${order.status == 1}">
                                            <option value="1" selected>Đang giao</option>
                                            <option value="3">Hoàn thành</option>
                                            <option value="2">Đã huỷ</option>
                                        </c:when>
                                        <c:when test="${order.status == 3}">
                                            <option value="3" selected>Hoàn thành</option>
                                        </c:when>
                                        <c:when test="${order.status == 2}">
                                            <option value="2" selected>Đã huỷ</option>
                                            <c:if test="${order.payment == 1}">
                                                <option value="7">Đã hoàn tiền</option>
                                            </c:if>
                                        </c:when>
                                        <c:when test="${order.status == 7}">
                                            <option value="7" selected>Đã hoàn tiền</option>
                                        </c:when>
                                    </c:choose>
                                </select>
                            </div>

                            <!-- Bắt đầu phần thêm Lý do hủy -->
                            <c:if test="${order.status != 2 && order.status != 7}">
                                <div class="mb-3 mt-3 d-none" id="cancelReasonGroup">
                                    <label class="form-label text-danger font-weight-bold">Lý do hủy đơn hàng <span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="cancelReason" id="cancelReasonInput" rows="2" placeholder="Nhập lý do hủy đơn hàng (Bắt buộc)"></textarea>
                                </div>
                            </c:if>
                            <!-- Kết thúc phần thêm Lý do hủy -->

                            <c:if test="${!(order.status == 3 || order.status == 7 || (order.status == 2 && order.payment != 1))}">
                                <div class="mb-3 mt-3">
                                    <label class="form-check">
                                        <input class="form-check-input" type="checkbox" required name="confirmChange" id="confirmChange">
                                        <span class="form-check-label text-danger" style="font-size: 0.85rem; font-weight: 500;">
                                            Tôi xác nhận thay đổi (Bạn không thể quay lại trạng thái trước đó sau khi xác nhận)
                                        </span>
                                    </label>
                                </div>
                                <button type="submit" class="btn btn-primary w-100">Cập nhật</button>
                            </c:if>
                            <c:if test="${order.status == 3 || order.status == 7 || (order.status == 2 && order.payment != 1)}">
                                <div class="alert alert-info mt-2 mb-0">Đơn hàng đã chốt trạng thái, không thể thay đổi.</div>
                            </c:if>
                        </form>
                        <c:if test="${(order.status == 2 || order.status == 7) && not empty order.cancelReason}">
                            <div class="alert alert-danger mt-3 mb-0">
                                <h4 class="alert-title">Lý do huỷ đơn hàng</h4>
                                <div class="text-secondary">${order.cancelReason}</div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Bắt đầu Thêm phần Giao Hàng Nhanh -->
                <c:if test="${order.status >= 5 && order.status != 7}">
                    <div class="card mt-3">
                        <div class="card-header">
                            <h3 class="card-title">Giao Hàng Nhanh (GHN)</h3>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty order.ghnOrderCode}">
                                    <div class="mb-3">
                                        <span class="text-muted d-block mb-1 small text-uppercase font-weight-medium">Mã vận đơn GHN</span>
                                        <span class="font-weight-medium text-dark" style="font-size: 1.1rem;">${order.ghnOrderCode}</span>
                                    </div>
                                    <button type="button" class="btn btn-success w-100" onclick="printGHNBill('${order.ghnOrderCode}')">
                                        <i class="fa fa-print me-2"></i> In vận đơn A5
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning mb-3">Đơn hàng chưa được đẩy sang hệ thống Giao Hàng Nhanh.</div>
                                    <c:choose>
                                        <c:when test="${not empty order.wardCode and not empty order.districtId}">
                                            <button type="button" class="btn btn-warning w-100" data-bs-toggle="modal" data-bs-target="#modal-ghn-auto">
                                                <i class="fa fa-truck me-2"></i> Xác nhận đẩy đơn sang GHN
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-warning w-100" data-bs-toggle="modal" data-bs-target="#modal-ghn">
                                                <i class="fa fa-truck me-2"></i> Chuyển đơn sang GHN
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>
                <!-- Kết thúc Thêm phần Giao Hàng Nhanh -->

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

<!-- Modal GHN -->
<div class="modal modal-blur fade" id="modal-ghn" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Xác nhận chuyển đơn sang Giao Hàng Nhanh</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row text-sm mb-3">
                    <div class="col-md-6">
                        <strong><i class="fa fa-store"></i> Người gửi:</strong>
                        <ul class="list-unstyled mt-1 mb-0">
                            <li>Tên: <%= AppConfig.GHN_FROM_NAME %></li>
                            <li>SĐT: <%= AppConfig.GHN_FROM_PHONE %></li>
                            <li>Đ/C: <%= AppConfig.GHN_FROM_ADDRESS %></li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <strong><i class="fa fa-user"></i> Người nhận:</strong>
                        <ul class="list-unstyled mt-1 mb-0">
                            <li>Tên: ${order.customerName}</li>
                            <li>SĐT: ${order.phone}</li>
                            <li>Đ/C: ${order.detailAddress}, ${order.address}</li>
                        </ul>
                    </div>
                </div>
                <div class="row text-sm mb-3">
                    <div class="col-md-6">
                        <strong><i class="fa fa-cog"></i> Cấu hình GHN:</strong>
                        <ul class="list-unstyled mt-1 mb-0">
                            <li>Trả phí vận chuyển: <strong><%= AppConfig.GHN_PAYMENT_TYPE_ID == 1 ? "Shop/Người gửi" : "Khách/Người nhận" %></strong></li>
                            <li>Ghi chú bắt buộc: <%= AppConfig.GHN_REQUIRED_NOTE %></li>
                            <li>Ghi chú: <%= AppConfig.GHN_NOTE %></li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <strong><i class="fa fa-money-bill-wave"></i> Thu hộ (COD):</strong>
                        <div class="mt-1 text-danger font-weight-bold" style="font-size: 1.1rem;">
                            <c:choose>
                                <c:when test="${order.payment == 1}">0đ <small class="text-muted">(Đã thanh toán)</small></c:when>
                                <c:otherwise><fmt:formatNumber value="${order.total}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                <hr class="mt-2 mb-3">
                <div class="alert alert-info">
                    Do đơn vị hành chính mới, hệ thống chưa lưu mã Phường/Xã đúng chuẩn GHN, vui lòng chọn thủ công để tiếp tục. <br/>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="mb-3">
                            <label class="form-label">Tỉnh / Thành phố <span class="text-danger">*</span></label>
                            <select class="form-select" id="ghnProvince" required>
                                <option value="">Chọn Tỉnh/Thành</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="mb-3">
                            <label class="form-label">Quận / Huyện <span class="text-danger">*</span></label>
                            <select class="form-select" id="ghnDistrict" disabled required>
                                <option value="">Chọn Quận/Huyện</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="mb-3">
                            <label class="form-label">Phường / Xã <span class="text-danger">*</span></label>
                            <select class="form-select" id="ghnWard" disabled required>
                                <option value="">Chọn Phường/Xã</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn me-auto" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" id="btnConfirmGHN" onclick="sendToGHN()">Chính thức đẩy lên GHN</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal GHN Auto -->
<div class="modal modal-blur fade" id="modal-ghn-auto" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Xem trước cấu hình đẩy đơn GHN</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row text-sm mb-3">
                    <div class="col-md-6">
                        <strong><i class="fa fa-store"></i> Người gửi:</strong>
                        <ul class="list-unstyled mt-1 mb-0">
                            <li>Tên: <%= AppConfig.GHN_FROM_NAME %></li>
                            <li>SĐT: <%= AppConfig.GHN_FROM_PHONE %></li>
                            <li>Đ/C: <%= AppConfig.GHN_FROM_ADDRESS %></li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <strong><i class="fa fa-user"></i> Người nhận:</strong>
                        <ul class="list-unstyled mt-1 mb-0">
                            <li>Tên: ${order.customerName}</li>
                            <li>SĐT: ${order.phone}</li>
                            <li>Đ/C: ${order.detailAddress}, ${order.address}</li>
                        </ul>
                    </div>
                </div>
                <div class="row text-sm mb-0">
                    <div class="col-md-6">
                        <strong><i class="fa fa-cog"></i> Cấu hình GHN:</strong>
                        <ul class="list-unstyled mt-1 mb-0">
                            <li>Trả phí vận chuyển: <strong><%= AppConfig.GHN_PAYMENT_TYPE_ID == 1 ? "Shop/Người gửi" : "Khách/Người nhận" %></strong></li>
                            <li>Ghi chú bắt buộc: <%= AppConfig.GHN_REQUIRED_NOTE %></li>
                            <li>Ghi chú: <%= AppConfig.GHN_NOTE %></li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <strong><i class="fa fa-money-bill-wave"></i> Thu hộ (COD):</strong>
                        <div class="mt-1 text-danger font-weight-bold" style="font-size: 1.1rem;">
                            <c:choose>
                                <c:when test="${order.payment == 1}">0đ <small class="text-muted">(Đã thanh toán)</small></c:when>
                                <c:otherwise><fmt:formatNumber value="${order.total}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn me-auto" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" id="btnAutoGHN" onclick="sendToGHNAuto('${order.districtId}', '${order.wardCode}')">Chính thức đẩy lên GHN</button>
            </div>
        </div>
    </div>
</div>

<%@include file="../components/footer.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    const GHN_TOKEN = '<%= AppConfig.GHN_TOKEN %>';
    
    document.addEventListener("DOMContentLoaded", function() {
        const statusSelect = document.getElementById('statusSelect');
        const cancelReasonGroup = document.getElementById('cancelReasonGroup');
        const cancelReasonInput = document.getElementById('cancelReasonInput');

        if(statusSelect && cancelReasonGroup && cancelReasonInput) {
            statusSelect.addEventListener('change', function() {
                if(this.value == '2') {
                    cancelReasonGroup.classList.remove('d-none');
                    cancelReasonInput.setAttribute('required', 'required');
                } else {
                    cancelReasonGroup.classList.add('d-none');
                    cancelReasonInput.removeAttribute('required');
                }
            });
            statusSelect.dispatchEvent(new Event('change'));
        }

        // --- Logic Load GHN ---
        const ghnProvince = document.getElementById('ghnProvince');
        const ghnDistrict = document.getElementById('ghnDistrict');
        const ghnWard = document.getElementById('ghnWard');

        if (ghnProvince) {
            axios.get('https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/province', {
                headers: { 'Token': GHN_TOKEN }
            }).then(res => {
                let data = res.data.data;
                data.forEach(item => {
                    if (!item.ProvinceName.toLowerCase().includes('test')) {
                        let option = document.createElement('option');
                        option.value = item.ProvinceID;
                        option.text = item.ProvinceName;
                        ghnProvince.add(option);
                    }
                });
            });

            ghnProvince.addEventListener('change', function() {
                ghnDistrict.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
                ghnWard.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                ghnDistrict.disabled = true;
                ghnWard.disabled = true;

                if (this.value) {
                    axios.get('https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/district?province_id=' + this.value, {
                        headers: { 'Token': GHN_TOKEN }
                    }).then(res => {
                        let data = res.data.data;
                        data.forEach(item => {
                            if (!item.DistrictName.toLowerCase().includes('test')) {
                                let option = document.createElement('option');
                                option.value = item.DistrictID;
                                option.text = item.DistrictName;
                                ghnDistrict.add(option);
                            }
                        });
                        ghnDistrict.disabled = false;
                    });
                }
            });

            ghnDistrict.addEventListener('change', function() {
                ghnWard.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                ghnWard.disabled = true;

                if (this.value) {
                    axios.get('https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/ward?district_id=' + this.value, {
                        headers: { 'Token': GHN_TOKEN }
                    }).then(res => {
                        let data = res.data.data;
                        data.forEach(item => {
                            if (!item.WardName.toLowerCase().includes('test')) {
                                let option = document.createElement('option');
                                option.value = item.WardCode;
                                option.text = item.WardName;
                                ghnWard.add(option);
                            }
                        });
                        ghnWard.disabled = false;
                    });
                }
            });
        }
    });

    function sendToGHN() {
        const toWardCode = document.getElementById('ghnWard').value;
        const toDistrictId = document.getElementById('ghnDistrict').value;
        const btnConfirm = document.getElementById('btnConfirmGHN');

        if (!toWardCode || !toDistrictId) {
            alert('Vui lòng chọn đầy đủ Tỉnh/Thành, Quận/Huyện, Phường/Xã');
            return;
        }

        btnConfirm.disabled = true;
        btnConfirm.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang xử lý...';

        axios.post('${ctx}/admin/orders/sendtoghn', {
            orderId: ${order.ID},
            to_ward_code: toWardCode,
            to_district_id: toDistrictId
        }, {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            transformRequest: [function (data) {
                return Object.keys(data).map(key => encodeURIComponent(key) + '=' + encodeURIComponent(data[key])).join('&');
            }]
        })
        .then(res => {
            if (res.data.status === 'success') {
                alert('Đã chuyển đơn sang GHN thành công!');
                window.location.reload();
            } else {
                alert('Lỗi: ' + res.data.message);
                btnConfirm.disabled = false;
                btnConfirm.innerHTML = 'Xác nhận đẩy đơn';
            }
        })
        .catch(err => {
            alert('Lỗi khi gọi API: ' + err);
            btnConfirm.disabled = false;
            btnConfirm.innerHTML = 'Xác nhận đẩy đơn';
        });
    }

    function sendToGHNAuto(toDistrictId, toWardCode) {
        const btnConfirm = document.getElementById('btnAutoGHN');
        btnConfirm.disabled = true;
        btnConfirm.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang xử lý...';

        axios.post('${ctx}/admin/orders/sendtoghn', {
            orderId: ${order.ID},
            to_ward_code: toWardCode,
            to_district_id: toDistrictId
        }, {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            transformRequest: [function (data) {
                return Object.keys(data).map(key => encodeURIComponent(key) + '=' + encodeURIComponent(data[key])).join('&');
            }]
        })
        .then(res => {
            if (res.data.status === 'success') {
                alert('Đã chuyển đơn sang GHN thành công!');
                window.location.reload();
            } else {
                alert('Lỗi: ' + res.data.message);
                btnConfirm.disabled = false;
                btnConfirm.innerHTML = '<i class="fa fa-truck me-2"></i> Xác nhận đẩy đơn sang GHN';
            }
        })
        .catch(err => {
            alert('Lỗi khi gọi API: ' + err);
            btnConfirm.disabled = false;
            btnConfirm.innerHTML = '<i class="fa fa-truck me-2"></i> Xác nhận đẩy đơn sang GHN';
        });
    }

    function printGHNBill(orderCode) {
        axios.get('${ctx}/admin/orders/get-ghn-bill?orderCode=' + orderCode)
        .then(res => {
            if (res.data.success) {
                window.open(res.data.invoiceUrl, '_blank');
            } else {
                alert('Lỗi: ' + res.data.message);
            }
        })
        .catch(err => {
            alert('Lỗi khi lấy hóa đơn: ' + err);
        });
    }
</script>
