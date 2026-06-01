<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/checkout-v2.css" />

<main class="mb-checkout-page">
    <div id="breadcrumb" class="section">
        <div class="container">
            <ul class="breadcrumb-tree">
                <li><a href="${ctx}/home">Trang chủ</a></li>
                <li><a href="${ctx}/cart">Giỏ hàng</a></li>
                <li class="active">Thanh toán</li>
            </ul>
        </div>
    </div>

    <section class="mb-page-hero">
        <div class="container">
            <span class="mb-kicker">Checkout</span>
            <h1>Thanh toán</h1>
            <p>Kiểm tra lại thông tin giao hàng và tóm tắt đơn trước khi xác nhận.</p>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <c:set var="checkoutTotal" value="0" />
            <c:set var="checkoutQty" value="0" />
            <c:forEach items="${carts}" var="cart">
                <c:set var="checkoutLine" value="${cart.displayUnitPrice * cart.quantity}" />
                <c:set var="checkoutTotal" value="${checkoutTotal + checkoutLine}" />
                <c:set var="checkoutQty" value="${checkoutQty + cart.quantity}" />
            </c:forEach>

            <c:if test="${empty carts}">
                <div class="mb-checkout-success">
                    <h2>Giỏ hàng đang trống</h2>
                    <p>Thêm sản phẩm vào giỏ hàng trước khi thanh toán.</p>
                    <a href="${ctx}/product" class="mb-btn-primary">Tiếp tục mua sắm</a>
                </div>
            </c:if>

            <c:if test="${not empty carts}">
                <div class="mb-checkout-layout">
                    <div class="mb-checkout-main">
                        <div class="mb-checkout-head">
                            <h2>Thông tin giao hàng</h2>
                            <p>${checkoutQty} sản phẩm trong đơn hàng</p>
                        </div>

                        <form action="${ctx}/checkout" method="post" class="mb-checkout-form">
                            <div class="mb-field">
                                <label for="checkoutName">Họ tên người nhận</label>
                                <input id="checkoutName" class="input" name="fullname" value="${account.fullname}" required/>
                            </div>
                            <div class="mb-field">
                                <label for="checkoutPhone">Số điện thoại</label>
                                <input id="checkoutPhone" class="input" name="phone" value="${account.phone}" required/>
                            </div>
                            <div class="mb-field">
                                <label for="checkoutEmail">Email</label>
                                <input id="checkoutEmail" class="input" name="email" type="email" value="${account.email}" required/>
                            </div>
                            <div class="mb-field">
                                <label for="checkoutAddress">Địa chỉ nhận hàng</label>
                                <input id="checkoutAddress" class="input" name="address" placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành" required/>
                            </div>
                            <div class="mb-field">
                                <label for="checkoutNote">Ghi chú</label>
                                <textarea id="checkoutNote" class="input" name="note" rows="4" placeholder="Ghi chú size, thời gian nhận hàng hoặc yêu cầu khác"></textarea>
                            </div>

                            <div class="mb-checkout-payment">
                                <label><input type="radio" name="paymentMethod" value="cod" checked/> Thanh toán khi nhận hàng</label>
                                <label><input type="radio" name="paymentMethod" value="bank"/> Chuyển khoản</label>
                            </div>

                            <div class="mb-checkout-actions">
                                <button type="submit" class="mb-checkout-submit">Xác nhận đơn hàng</button>
                                <a href="${ctx}/cart" class="mb-checkout-back">Quay lại giỏ hàng</a>
                            </div>
                        </form>
                    </div>

                    <aside class="mb-checkout-summary-panel">
                        <h3>Tóm tắt đơn</h3>
                        <c:forEach items="${carts}" var="cart">
                            <c:set var="lineTotal" value="${cart.displayUnitPrice * cart.quantity}" />
                            <div class="mb-checkout-line">
                                <img class="mb-img" src="${imgUrl.resolve(cart.mainImg, ctx)}" alt="${cart.productName}" onerror="mbImgOnError(this)"/>
                                <div class="mb-checkout-line-info">
                                    <h4>${cart.productName}</h4>
                                    <p class="mb-checkout-line-meta">
                                        SL: ${cart.quantity}
                                        <c:if test="${not empty cart.colorName}"> · ${cart.colorName}</c:if>
                                        <c:if test="${not empty cart.sizeLabel}"> · Size ${cart.sizeLabel}</c:if>
                                    </p>
                                </div>
                                <strong class="mb-checkout-line-price">${currency.currencyFormat(lineTotal)}</strong>
                            </div>
                        </c:forEach>

                        <div class="mb-checkout-totals">
                            <div class="row-line">
                                <span>Tạm tính</span>
                                <strong>${currency.currencyFormat(checkoutTotal)}</strong>
                            </div>
                            <div class="row-line">
                                <span>Giao hàng</span>
                                <strong>Miễn phí</strong>
                            </div>
                            <div class="row-line grand">
                                <span>Tổng cộng</span>
                                <strong>${currency.currencyFormat(checkoutTotal)}</strong>
                            </div>
                        </div>
                    </aside>
                </div>
            </c:if>
        </div>
    </section>
</main>

<%@include file="./components/footer.jsp" %>
