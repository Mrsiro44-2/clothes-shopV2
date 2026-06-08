<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@include file="./components/header.jsp" %>

<link type="text/css" rel="stylesheet" href="./user/css/checkout-v2.css" />

<div id="breadcrumb" class="section">

    <div class="container">

        <ul class="breadcrumb-tree">

            <li><a href="${ctx}/home">Trang chủ</a></li>

            <li><a href="${ctx}/cart">Giỏ hàng</a></li>

            <li class="active">Thanh toán</li>

        </ul>

    </div>

</div>

<div class="section mb-checkout-page">

    <div class="container">

        <div class="mb-checkout-layout">

            <div class="mb-checkout-main">

                <div class="mb-checkout-head">

                    <h2>Thanh toán</h2>

                    <p>Điền thông tin giao hàng và chọn phương thức thanh toán</p>

                </div>

                <form class="mb-checkout-form" action="${ctx}/checkout" method="post">

                    <c:if test="${not empty sessionScope.checkoutError}">
                        <div class="alert alert-danger" style="margin-bottom: 20px; color: #721c24; background-color: #f8d7da; border-color: #f5c6cb; padding: 12px 20px; border-radius: 4px;">
                            ${sessionScope.checkoutError}
                        </div>
                        <c:remove var="checkoutError" scope="session"/>
                    </c:if>

                    <div class="mb-field">

                        <label>Họ tên người nhận</label>

                        <input class="input" name="customerName" required value="${account.fullname}"/>

                    </div>

                    <div class="mb-field">

                        <label>Số điện thoại</label>

                        <input class="input" name="phone" required value="${account.phone != null ? account.phone : ''}"/>

                    </div>

                    <div class="mb-field">

                        <label>Email</label>

                        <input class="input" name="email" type="email" required value="${account.email}"/>

                    </div>

                    <div class="mb-field mb-address-selects">
                        <div class="address-select-row">
                            <div class="select-col">
                                <label>Tỉnh / Thành phố</label>
                                <select id="mb-province" class="input" required>
                                    <option value="">Chọn Tỉnh/Thành phố</option>
                                </select>
                            </div>
                            <div class="select-col">
                                <label>Phường / Xã</label>
                                <select id="mb-ward" class="input" required disabled>
                                    <option value="">Chọn Phường/Xã</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="mb-field">
                        <label>Địa chỉ chi tiết (Số nhà, tên đường...)</label>
                        <input type="text" id="mb-street" class="input" placeholder="Ví dụ: 123 Đường Nguyễn Trãi..." required />
                        <input type="hidden" name="address" id="mb-full-address" required />
                    </div>

                    <div class="mb-field">
                        <label>Ghi chú (tùy chọn)</label>
                        <input class="input" name="detailAddress" placeholder="Giao giờ hành chính, gọi trước khi giao..."/>
                    </div>

                    <div class="mb-checkout-payment">
                        <label style="display:block;margin-bottom:12px;font-weight:700;font-size:14px;color:#111">
                            Phương thức thanh toán
                        </label>
                        
                        <div class="payment-options-grid">
                            <label class="payment-method-card active">
                                <input type="radio" name="paymentMethod" value="cod" checked style="display:none;"/>
                                <div class="payment-icon">
                                    <i class="fa fa-truck"></i>
                                </div>
                                <div class="payment-details">
                                    <span class="payment-title">Thanh toán khi nhận hàng (COD)</span>
                                    <span class="payment-desc">Thanh toán bằng tiền mặt khi giao hàng</span>
                                </div>
                                <div class="payment-checked">
                                    <i class="fa fa-check-circle"></i>
                                </div>
                            </label>

                            <label class="payment-method-card">
                                <input type="radio" name="paymentMethod" value="payos" style="display:none;"/>
                                <div class="payment-icon">
                                    <i class="fa fa-qrcode"></i>
                                </div>
                                <div class="payment-details">
                                    <span class="payment-title">PayOS (Chuyển khoản QR Code)</span>
                                    <span class="payment-desc">Thanh toán bằng ứng dụng ngân hàng quét mã QR (Miễn phí)</span>
                                </div>
                                <div class="payment-checked">
                                    <i class="fa fa-check-circle"></i>
                                </div>
                            </label>
                        </div>
                    </div>

                    <div class="mb-checkout-actions">
                        <button type="submit" class="mb-checkout-submit">Đặt hàng</button>
                        <a href="${ctx}/cart" class="mb-checkout-back">← Quay lại giỏ hàng</a>
                    </div>

                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            var API = "https://provinces.open-api.vn/api/v2";
                            var provinceSelect = document.getElementById("mb-province");
                            var wardSelect = document.getElementById("mb-ward");
                            var streetInput = document.getElementById("mb-street");
                            var fullAddressInput = document.getElementById("mb-full-address");

                            // 1. Load tỉnh/thành phố
                            fetch(API + "/p/")
                                .then(function(res) { return res.json(); })
                                .then(function(list) {
                                    list.forEach(function(p) {
                                        var opt = document.createElement("option");
                                        opt.value = p.code;
                                        opt.textContent = p.name;
                                        provinceSelect.appendChild(opt);
                                    });
                                })
                                .catch(function(err) { console.error("Lỗi tải tỉnh:", err); });

                            // 2. Chọn tỉnh → load phường/xã (API v2: wards nằm trực tiếp dưới province)
                            provinceSelect.addEventListener("change", function () {
                                wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                                wardSelect.disabled = true;

                                var pCode = this.value;
                                if (!pCode) { buildAddress(); return; }

                                fetch(API + "/p/" + pCode + "?depth=2")
                                    .then(function(res) { return res.json(); })
                                    .then(function(data) {
                                        var wards = data.wards || [];
                                        if (wards.length > 0) {
                                            wards.forEach(function(w) {
                                                var opt = document.createElement("option");
                                                opt.value = w.code;
                                                opt.textContent = w.name;
                                                wardSelect.appendChild(opt);
                                            });
                                            wardSelect.disabled = false;
                                        }
                                        buildAddress();
                                    })
                                    .catch(function(err) { console.error("Lỗi tải phường/xã:", err); });
                            });

                            wardSelect.addEventListener("change", buildAddress);
                            streetInput.addEventListener("input", buildAddress);

                            // Ghép địa chỉ: Số nhà, Phường/Xã, Tỉnh/Thành phố
                            function buildAddress() {
                                var pText = provinceSelect.selectedIndex > 0 ? provinceSelect.options[provinceSelect.selectedIndex].text : "";
                                var wText = wardSelect.selectedIndex > 0 ? wardSelect.options[wardSelect.selectedIndex].text : "";
                                var street = streetInput.value.trim();
                                var parts = [];
                                if (street) parts.push(street);
                                if (wText) parts.push(wText);
                                if (pText) parts.push(pText);
                                fullAddressInput.value = parts.join(", ");
                            }

                            // Payment toggle
                            document.querySelectorAll('.payment-method-card').forEach(function(card) {
                                card.addEventListener('click', function() {
                                    document.querySelectorAll('.payment-method-card').forEach(function(c) {
                                        c.classList.remove('active');
                                    });
                                    this.classList.add('active');
                                    var radio = this.querySelector('input[type="radio"]');
                                    if (radio) radio.checked = true;
                                });
                            });
                        });
                    </script>

                </form>

            </div>

            <div class="mb-checkout-summary-panel">

                <h3>Đơn hàng của bạn</h3>

                <c:forEach items="${carts}" var="line">

                    <div class="mb-checkout-line">

                        <img class="mb-img" src="${imgUrl.resolve(line.mainImg, ctx)}" alt="${line.productName}" onerror="mbImgOnError(this)"/>

                        <div class="mb-checkout-line-info">

                            <h4>${line.productName}</h4>

                            <p class="mb-checkout-line-meta">

                                SL: ${line.quantity}

                                <c:if test="${not empty line.colorName}"> · Màu: ${line.colorName}</c:if>

                                <c:if test="${not empty line.sizeLabel}"> · Size: ${line.sizeLabel}</c:if>

                            </p>

                        </div>

                        <div class="mb-checkout-line-price">

                            ${currency.currencyFormat(line.displayUnitPrice * line.quantity)}

                        </div>

                    </div>

                </c:forEach>

                <div class="mb-checkout-totals">

                    <div class="row-line">

                        <span>Tạm tính</span>

                        <strong>${currency.currencyFormat(subtotal)}</strong>

                    </div>

                    <!-- Voucher input on checkout page -->
                    <c:set var="displayVoucherCode" value="${fn:replace(fn:replace(voucherCode, 'PUB_', ''), 'PRI_', '')}" />
                    <div class="mb-cart-promo" style="margin: 12px 0; padding: 12px 0; border-top: 1px dashed #e5e7eb; border-bottom: 1px dashed #e5e7eb;">
                        <label style="font-size:12px;font-weight:600;color:#555;text-transform:uppercase;margin-bottom:8px;display:block;">Mã giảm giá</label>
                        <form action="${ctx}/voucher?from=checkout" method="post" class="mb-cart-promo-row" style="display:flex;gap:8px;">
                            <input type="hidden" name="from" value="checkout"/>
                            <input type="text" name="couponCode" placeholder="Nhập mã voucher" value="${not empty displayVoucherCode ? displayVoucherCode : ''}"
                                   style="flex:1;padding:8px 12px;border:1px solid #ddd;border-radius:6px;font-size:13px;outline:none;"/>
                            <button type="submit" style="padding:8px 16px;background:var(--mb-primary, #DB4444);color:#fff;border:none;border-radius:6px;font-size:13px;font-weight:600;cursor:pointer;white-space:nowrap;">ÁP DỤNG</button>
                        </form>
                        <c:if test="${sessionScope.couponStatus == 'invalid'}">
                            <p style="color:#d10024;font-size:12px;margin-top:6px">Mã không hợp lệ hoặc đã bị vô hiệu hóa.</p>
                        </c:if>
                        <c:if test="${sessionScope.couponStatus == 'expired'}">
                            <p style="color:#d10024;font-size:12px;margin-top:6px">Mã đã hết hạn hoặc hết số lượng sử dụng.</p>
                        </c:if>
                        <c:if test="${sessionScope.couponStatus == 'already_used'}">
                            <p style="color:#d10024;font-size:12px;margin-top:6px">Bạn đã sử dụng mã này rồi.</p>
                        </c:if>
                        <c:if test="${sessionScope.couponStatus == 'min_order'}">
                            <p style="color:#d10024;font-size:12px;margin-top:6px">Đơn hàng tối thiểu phải từ ${currency.currencyFormat(sessionScope.couponMinAmount)} để áp dụng.</p>
                        </c:if>
                        <c:if test="${sessionScope.couponStatus == 'applied'}">
                            <p style="color:#2e7d32;font-size:12px;margin-top:6px">Đã áp dụng mã giảm giá thành công!</p>
                        </c:if>
                    </div>

                    <div class="row-line">
                        <span>Giảm giá
                            <c:if test="${not empty displayVoucherCode}"> (${displayVoucherCode})</c:if>
                        </span>
                        <strong>−${currency.currencyFormat(discount)}</strong>
                    </div>

                    <c:if test="${not empty displayVoucherCode}">
                        <div style="text-align: left; margin-top: -5px; margin-bottom: 10px;">
                            <div class="mb-voucher-tag" style="display: inline-flex; align-items: center; background-color: #e8f5e9; border: 1px solid #c8e6c9; color: #2e7d32; padding: 4px 10px; border-radius: 4px; font-weight: 500; font-size: 12px; gap: 6px;">
                                <i class="fa fa-ticket"></i>
                                <span>Mã: <strong>${displayVoucherCode}</strong></span>
                                <a href="${ctx}/voucher?from=checkout" title="Bỏ mã giảm giá" style="color: #c62828; text-decoration: none; font-weight: bold; margin-left: 2px; font-size: 13px; cursor: pointer; line-height: 1;">&times;</a>
                            </div>
                        </div>
                    </c:if>

                    <div class="row-line grand">

                        <span>Tổng thanh toán</span>

                        <span>${currency.currencyFormat(total)}</span>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

<%@include file="./components/footer.jsp" %>

