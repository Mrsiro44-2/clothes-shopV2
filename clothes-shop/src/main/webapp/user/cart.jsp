<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/cart-v2.css" />

<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li class="active">Giỏ hàng</li>
        </ul>
    </div>
</div>

<div class="section mb-cart-page">
    <div class="container">
        <c:set var="totalCartPage" value="0" />
        <c:set var="totalQty" value="0" />
        <c:forEach items="${carts}" var="cart">
            <c:set var="lineTot" value="${cart.displayUnitPrice * cart.quantity}" />
            <c:set var="totalCartPage" value="${totalCartPage + lineTot}" />
            <c:set var="totalQty" value="${totalQty + cart.quantity}" />
        </c:forEach>

        <div class="mb-cart-layout">
            <div class="mb-cart-main">
                <div class="mb-cart-head">
                    <h2>Giỏ hàng</h2>
                    <span class="mb-cart-count">${carts.size()} sản phẩm · ${totalQty} món</span>
                </div>

                <c:if test="${empty carts}">
                    <div class="mb-cart-empty">
                        <p>Giỏ hàng trống.</p>
                        <a href="${ctx}/product" class="mb-cart-continue">Tiếp tục mua sắm →</a>
                    </div>
                </c:if>

                <c:if test="${not empty carts}">
                    <form action="${ctx}/cart" method="post" id="mbCartForm">
                        <div class="mb-cart-table-head">
                            <span>Sản phẩm</span>
                            <span>Số lượng</span>
                            <span>Đơn giá</span>
                            <span style="text-align:right">Thành tiền</span>
                        </div>

                        <c:forEach items="${carts}" var="cart">
                            <c:set var="unitPrice" value="${cart.displayUnitPrice}" />
                            <c:set var="lineTotal" value="${unitPrice * cart.quantity}" />
                            <div class="mb-cart-row">
                                <div class="mb-cart-product">
                                    <a href="${ctx}/product/detail/${cart.productID}">
                                        <img class="mb-img" src="${imgUrl.resolve(cart.mainImg, ctx)}"
                                             alt="${cart.productName}" onerror="mbImgOnError(this)"/>
                                    </a>
                                    <div class="mb-cart-product-info">
                                        <h4><a href="${ctx}/product/detail/${cart.productID}">${cart.productName}</a></h4>
                                        <p class="mb-cart-variant-meta">
                                            <c:if test="${not empty cart.colorName}">Màu: ${cart.colorName}</c:if>
                                            <c:if test="${not empty cart.sizeLabel}">
                                                <c:if test="${not empty cart.colorName}"> · </c:if>
                                                Size: ${cart.sizeLabel}
                                            </c:if>
                                        </p>
                                        <button type="button" class="mb-cart-remove"
                                                onclick="confirmRemove('${cart.ID}')">Xóa</button>
                                    </div>
                                </div>
                                <div>
                                    <div class="mb-cart-qty">
                                        <button type="button" class="mb-qty-dec">−</button>
                                        <input type="number" class="qty-input" name="qty_v_${cart.productVariantID}"
                                               value="${cart.quantity}" min="1" max="${cart.stockQty}"/>
                                        <button type="button" class="mb-qty-inc">+</button>
                                    </div>
                                </div>
                                <div class="mb-cart-price">${currency.currencyFormat(unitPrice)}</div>
                                <div class="mb-cart-line-total" style="text-align:right">
                                    ${currency.currencyFormat(lineTotal)}
                                </div>
                            </div>
                        </c:forEach>

                        <button type="submit" name="btn-update-cart" class="mb-cart-update-btn">Cập nhật giỏ hàng</button>
                        <a href="${ctx}/product" class="mb-cart-continue">← Tiếp tục mua sắm</a>
                    </form>
                </c:if>
            </div>

            <div class="mb-cart-summary-panel">
                <h3>Tóm tắt đơn</h3>
                <div class="mb-cart-summary-line">
                    <span>SẢN PHẨM (${totalQty})</span>
                    <strong>${currency.currencyFormat(totalCartPage)}</strong>
                </div>
                <div class="mb-cart-summary-line">
                    <span>PHÍ GIAO HÀNG</span>
                    <strong>Miễn phí</strong>
                </div>
                <div class="mb-cart-promo">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                        <label style="margin: 0;">MÃ GIẢM GIÁ</label>
                        <button type="button" onclick="var m = document.getElementById('voucherModal'); if(m) m.classList.add('active'); else alert('Lỗi: Không tìm thấy popup mã giảm giá!');" style="background:none; border:none; color:#DB4444; cursor:pointer; font-size:12px; font-weight:bold; padding:0;">Gợi ý mã giảm giá</button>
                    </div>
                    <form action="${ctx}/voucher" method="post" class="mb-cart-promo-row" id="cartVoucherForm">
                        <input type="text" name="couponCode" id="cartVoucherInput" placeholder="Nhập mã voucher"/>
                        <button type="submit" name="use-voucher">ÁP DỤNG</button>
                    </form>
                    <c:if test="${sessionScope.couponStatus == 'invalid'}">
                        <p style="color:#d10024;font-size:12px;margin-top:8px">Mã không hợp lệ.</p>
                    </c:if>
                    <c:if test="${sessionScope.couponStatus == 'expired'}">
                        <p style="color:#d10024;font-size:12px;margin-top:8px">Mã đã hết hạn hoặc hết số lượng.</p>
                    </c:if>
                    <c:if test="${sessionScope.couponStatus == 'min_order'}">
                        <p style="color:#d10024;font-size:12px;margin-top:8px">Đơn hàng tối thiểu phải từ ${currency.currencyFormat(sessionScope.couponMinAmount)} để áp dụng.</p>
                    </c:if>
                    <c:if test="${sessionScope.couponStatus == 'already_used'}">
                        <p style="color:#d10024;font-size:12px;margin-top:8px">Bạn đã sử dụng mã giảm giá này rồi.</p>
                    </c:if>
                    <c:if test="${sessionScope.couponStatus == 'applied'}">
                        <p style="color:#2e7d32;font-size:12px;margin-top:8px">Đã áp dụng mã giảm giá thành công.</p>
                    </c:if>
                    <c:if test="${not empty sessionScope.appliedVoucherCode}">
                        <c:set var="displayCode" value="${fn:replace(fn:replace(sessionScope.appliedVoucherCode, 'PUB_', ''), 'PRI_', '')}" />
                        <div class="mb-voucher-tag" style="display: inline-flex; align-items: center; background-color: #e8f5e9; border: 1px solid #c8e6c9; color: #2e7d32; padding: 6px 12px; border-radius: 4px; font-weight: 500; font-size: 13px; margin-top: 10px; gap: 8px;">
                            <i class="fa fa-ticket"></i>
                            <span>Mã: <strong>${displayCode}</strong></span>
                            <a href="${ctx}/voucher" title="Bỏ mã giảm giá" style="color: #c62828; text-decoration: none; font-weight: bold; margin-left: 4px; font-size: 14px; cursor: pointer; line-height: 1;">&times;</a>
                        </div>
                    </c:if>
                </div>
                <c:if test="${sessionScope.discount != null && sessionScope.discount > 0}">
                    <div class="mb-cart-summary-line">
                        <span>GIẢM GIÁ</span>
                        <strong>-${currency.currencyFormat(sessionScope.discount)}</strong>
                    </div>
                </c:if>
                <div class="mb-cart-summary-total">
                    <span>TỔNG CỘNG</span>
                    <span>
                        <c:choose>
                            <c:when test="${sessionScope.newTotal != null}">
                                ${currency.currencyFormat(sessionScope.newTotal)}
                            </c:when>
                            <c:otherwise>
                                ${currency.currencyFormat(totalCartPage)}
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <c:if test="${not empty carts}">
                    <a href="${ctx}/checkout" class="mb-cart-checkout">THANH TOÁN</a>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.mb-cart-qty').forEach(function (wrap) {
        var input = wrap.querySelector('input');
        var dec = wrap.querySelector('.mb-qty-dec');
        var inc = wrap.querySelector('.mb-qty-inc');
        if (!input) return;
        dec.addEventListener('click', function () {
            var v = parseInt(input.value, 10) || 1;
            input.value = Math.max(1, v - 1);
        });
        inc.addEventListener('click', function () {
            var v = parseInt(input.value, 10) || 1;
            var max = parseInt(input.max, 10) || 999;
            input.value = Math.min(max, v + 1);
        });
    });

    document.querySelectorAll('.qty-input').forEach(function (input) {
        input.addEventListener('change', function () {
            var min = parseInt(this.min, 10) || 1;
            var max = parseInt(this.max, 10) || 999;
            var value = parseInt(this.value, 10);
            if (isNaN(value) || value < min || value > max) {
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Số lượng',
                        text: 'Số lượng không hợp lệ hoặc vượt tồn kho.',
                        confirmButtonColor: '#D10024'
                    });
                }
                this.value = value < min ? min : (value > max ? max : min);
            }
        });
    });

    function confirmRemove(cartId) {
        Swal.fire({
            title: 'Xóa sản phẩm?',
            text: 'Bạn có chắc muốn xóa khỏi giỏ hàng?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#D10024',
            cancelButtonColor: '#8d99ae',
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy'
        }).then(function (result) {
            if (result.isConfirmed) {
                window.location.href = '${ctx}/cart/remove?cartId=' + cartId;
            }
        });
    }

    (function () {
        var params = new URLSearchParams(window.location.search);
        if (params.get('act') !== 'add-cart') return;
        var st = params.get('status');
        var text = 'Không thể thêm vào giỏ.';
        var icon = 'error';
        if (st === '1') { text = 'Đã thêm vào giỏ hàng.'; icon = 'success'; }
        else if (st === '2') { text = 'Số lượng vượt tồn kho.'; icon = 'warning'; }
        if (typeof Swal !== 'undefined') {
            Swal.fire({ icon: icon, title: 'Giỏ hàng', text: text, confirmButtonColor: '#D10024' });
        }
    })();
</script>

<c:if test="${not empty sessionScope.checkoutError}">
    <script>
        if (typeof Swal !== 'undefined') {
            Swal.fire({
                icon: 'error',
                title: 'Thanh toán không thành công',
                text: '${sessionScope.checkoutError}',
                confirmButtonColor: '#D10024'
            });
        }
    </script>
    <c:remove var="checkoutError" scope="session"/>
</c:if>

<!-- Modal Voucher -->
<div id="voucherModal" class="mb-modal">
    <div class="mb-modal-content" style="max-width: 450px;">
        <div class="mb-modal-header">
            <h3 class="mb-modal-title">Chọn mã giảm giá</h3>
            <button type="button" class="mb-modal-close" onclick="var m = document.getElementById('voucherModal'); if(m) m.classList.remove('active');">&times;</button>
        </div>
        <div style="max-height: 400px; overflow-y: auto; padding: 10px 0;">
            <c:if test="${empty publicVouchers}">
                <p style="text-align:center; color:#666; font-size:14px;">Hiện chưa có mã giảm giá nào.</p>
            </c:if>
            <c:forEach items="${publicVouchers}" var="v">
                <c:set var="displayVoucher" value="${fn:replace(fn:replace(v.code, 'PUB_', ''), 'PRI_', '')}" />
                <div style="border: 1px solid #e5e7eb; border-radius: 8px; padding: 12px; margin-bottom: 12px; cursor: pointer; transition: all 0.2s;" onmouseover="this.style.borderColor='#DB4444'" onmouseout="this.style.borderColor='#e5e7eb'" onclick="applyVoucher('${displayVoucher}')">
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <strong style="color:#DB4444; font-size:16px;">${displayVoucher}</strong>
                        <span style="font-size:12px; color:#555;">HSD: <strong>${v.end}</strong></span>
                    </div>
                    <div style="font-size:13px; color:#333; margin-top:6px;">
                        Giảm ${v.discountType == 0 ? currency.currencyFormat(v.value) : v.value.toString().concat('%')} 
                        đơn tối thiểu ${currency.currencyFormat(v.minOrderAmount)}
                        <c:if test="${v.discountType == 1 && v.maxDiscount != null && v.maxDiscount > 0}">
                            (Tối đa ${currency.currencyFormat(v.maxDiscount)})
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    function openVoucherModal() {
        document.getElementById('voucherModal').classList.add('active');
    }
    function closeVoucherModal() {
        document.getElementById('voucherModal').classList.remove('active');
    }
    function applyVoucher(code) {
        document.getElementById('cartVoucherInput').value = code;
        document.getElementById('cartVoucherForm').submit();
    }
</script>
<%@include file="./components/footer.jsp" %>
