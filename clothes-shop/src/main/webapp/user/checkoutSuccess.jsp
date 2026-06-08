<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@include file="./components/header.jsp" %>

<link type="text/css" rel="stylesheet" href="./user/css/checkout-v2.css" />

<div class="section mb-checkout-page">

    <div class="container">

        <div class="mb-checkout-success">

            <i class="fa fa-check-circle" style="font-size:48px;color:#DB4444;margin-bottom:16px"></i>

            <h2>Đặt hàng thành công!</h2>

            <p>Mã đơn hàng: <strong>#${billId}</strong></p>

            <c:if test="${not empty bill}">

                <p>Tổng thanh toán: <strong>${currency.currencyFormat(bill.total)}</strong></p>

                <p>Phương thức:

                    <c:choose>

                        <c:when test="${bill.payment == 1}">PayOS</c:when>

                        <c:otherwise>Thanh toán khi nhận hàng (COD)</c:otherwise>

                    </c:choose>

                </p>

            </c:if>

            <div style="margin-top:24px">

                <a href="${ctx}/orders" class="mb-btn-primary">Xem đơn hàng</a>

                <a href="${ctx}/home" class="mb-btn-outline">Tiếp tục mua sắm</a>

            </div>

        </div>

    </div>

</div>

<%@include file="./components/footer.jsp" %>

