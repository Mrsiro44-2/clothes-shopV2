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

                    <input type="hidden" name="email" value="${account.email}" />

                    <c:choose>
                        <c:when test="${not empty addresses}">
                            <!-- Đã có sổ địa chỉ -->
                            <c:set var="selectedAddr" value="${addresses[0]}"/>
                            <c:forEach items="${addresses}" var="a">
                                <c:if test="${a.isDefault}"><c:set var="selectedAddr" value="${a}"/></c:if>
                            </c:forEach>
                            
                            <div class="mb-checkout-address-box" style="border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; margin-bottom: 25px;">
                                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 12px;">
                                    <h3 style="font-size: 16px; margin: 0;"><i class="fa fa-map-marker" style="color:#DB4444; margin-right: 8px;"></i>Địa chỉ nhận hàng</h3>
                                    <button type="button" onclick="openCheckoutAddressModal()" style="background:none; border:none; color:#0056b3; font-weight:600; cursor:pointer;">Thay đổi</button>
                                </div>
                                <div id="selected-address-display">
                                    <div style="font-weight:700; font-size:15px; margin-bottom:6px;">
                                        <span id="disp-name">${selectedAddr.fullName}</span> | <span id="disp-phone">${selectedAddr.phone}</span>
                                    </div>
                                    <div style="color:#555; font-size:14px;">
                                        <span id="disp-detail">${selectedAddr.detailAddress}</span><br>
                                        <span id="disp-address">${selectedAddr.address}</span>
                                    </div>
                                </div>
                                <input type="hidden" name="shippingAddressID" id="input-shippingAddressID" value="${selectedAddr.id}" />
                            </div>

                            <!-- Modal chọn địa chỉ (giấu đi mặc định) -->
                            <div id="checkoutAddressModal" class="mb-modal">
                                <div class="mb-modal-content" style="max-width: 600px;">
                                    <div class="mb-modal-header">
                                        <h3 class="mb-modal-title">Địa chỉ của tôi</h3>
                                        <button type="button" class="mb-modal-close" onclick="closeCheckoutAddressModal()">&times;</button>
                                    </div>
                                    <div style="max-height: 400px; overflow-y: auto; padding-right: 10px;">
                                        <c:forEach items="${addresses}" var="a">
                                            <div class="address-card" style="margin-bottom: 15px; padding: 15px; border: 1px solid #ddd; border-radius: 6px; cursor: pointer; display: flex; gap: 15px;" onclick="selectCheckoutAddress(${a.id}, '${a.fullName}', '${a.phone}', '${a.detailAddress}', '${a.address}')">
                                                <input type="radio" name="addr_sel" value="${a.id}" ${a.id == selectedAddr.id ? 'checked' : ''} style="margin-top: 4px;" />
                                                <div>
                                                    <div style="font-weight:bold;">${a.fullName} | ${a.phone} <c:if test="${a.isDefault}"><span class="badge-default" style="margin-left:8px;">Mặc định</span></c:if></div>
                                                    <div style="color:#555; font-size:13px; margin-top:4px;">${a.detailAddress}<br>${a.address}</div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <div style="margin-top: 20px; text-align: center;">
                                        <a href="${ctx}/user/addresses?redirect=${ctx}/checkout" style="color: var(--mb-primary, #DB4444); font-weight: 600; text-decoration: none;">+ Thêm địa chỉ mới</a>
                                    </div>
                                </div>
                            </div>
                            
                            <style>
                                .mb-modal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; }
                                .mb-modal.active { display: flex; }
                                .mb-modal-content { background: #fff; width: 100%; border-radius: 12px; padding: 25px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); }
                                .mb-modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
                                .mb-modal-title { font-size: 18px; font-weight: 700; margin: 0; }
                                .mb-modal-close { background: none; border: none; font-size: 24px; cursor: pointer; color: #888; }
                                .badge-default { background: var(--mb-primary, #DB4444); color: white; font-size: 11px; padding: 2px 8px; border-radius: 4px; }
                            </style>
                            <script>
                                function openCheckoutAddressModal() { document.getElementById('checkoutAddressModal').classList.add('active'); }
                                function closeCheckoutAddressModal() { document.getElementById('checkoutAddressModal').classList.remove('active'); }
                                function selectCheckoutAddress(id, name, phone, detail, address) {
                                    document.getElementById('input-shippingAddressID').value = id;
                                    document.getElementById('disp-name').innerText = name;
                                    document.getElementById('disp-phone').innerText = phone;
                                    document.getElementById('disp-detail').innerText = detail;
                                    document.getElementById('disp-address').innerText = address;
                                    closeCheckoutAddressModal();
                                    
                                    // Also update the radio buttons UI manually if they clicked the div
                                    var radios = document.getElementsByName('addr_sel');
                                    for(var i=0; i<radios.length; i++){
                                        if(radios[i].value == id) radios[i].checked = true;
                                    }
                                }
                            </script>
                        </c:when>
                        <c:otherwise>
                            <!-- Chưa có sổ địa chỉ -->
                            <div class="mb-checkout-address-box" style="border: 1px dashed #cbd5e1; border-radius: 8px; padding: 40px 20px; margin-bottom: 25px; text-align: center; background: #f8fafc;">
                                <i class="fa fa-map-marker" style="font-size: 40px; color: #cbd5e1; margin-bottom: 15px; display: block;"></i>
                                <h3 style="font-size: 16px; margin-bottom: 8px; color: #334155;">Bạn chưa có địa chỉ giao hàng</h3>
                                <p style="font-size: 14px; color: #64748b; margin-bottom: 20px;">Vui lòng thiết lập địa chỉ để tiếp tục đặt hàng</p>
                                <a href="${ctx}/user/addresses?redirect=${ctx}/checkout" class="btn-add" style="text-decoration: none; display: inline-flex; background: var(--mb-primary, #DB4444); color: white; padding: 10px 20px; border-radius: 6px; font-weight: 600; font-size: 14px;"><i class="fa fa-plus" style="margin-right: 6px;"></i> Thêm địa chỉ mới</a>
                            </div>
                        </c:otherwise>
                    </c:choose>

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
                        <c:choose>
                            <c:when test="${not empty addresses}">
                                <button type="submit" class="mb-checkout-submit">Đặt hàng</button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="mb-checkout-submit" style="background:#cbd5e1; cursor:not-allowed;" onclick="alert('Vui lòng thêm địa chỉ giao hàng trước khi đặt hàng.')">Đặt hàng</button>
                            </c:otherwise>
                        </c:choose>
                        <a href="${ctx}/cart" class="mb-checkout-back">← Quay lại giỏ hàng</a>
                    </div>

                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            var API = "https://provinces.open-api.vn/api/v2";
                            var provinceSelect = document.getElementById("mb-province");
                            var wardSelect = document.getElementById("mb-ward");
                            var streetInput = document.getElementById("mb-street");
                            var fullAddressInput = document.getElementById("mb-full-address");

                            <c:if test="${empty addresses}">
                            // Vô hiệu hóa submit form nếu chưa có địa chỉ
                            document.querySelector('.mb-checkout-form').addEventListener('submit', function(e) {
                                e.preventDefault();
                                alert('Vui lòng thêm địa chỉ giao hàng trước khi đặt hàng.');
                            });
                            </c:if>

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

