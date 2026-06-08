<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/vouchers.css" />

<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li class="active">Kho Voucher</li>
        </ul>
    </div>
</div>

<div class="section mb-voucher-hub">
    <div class="container">
        <div class="mb-voucher-hub-header">
            <h2>Mã Giảm Giá Dành Cho Bạn</h2>
            <p>Sưu tầm các mã giảm giá hấp dẫn để sử dụng khi thanh toán.</p>
        </div>

        <c:choose>
            <c:when test="${empty vouchers}">
                <div class="mb-empty-state">
                    <i class="fa fa-ticket"></i>
                    <p>Hiện tại chưa có mã giảm giá công khai nào.<br/>Bạn hãy quay lại sau nhé!</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="mb-voucher-grid">
                    <jsp:useBean id="now" class="java.util.Date"/>
                    <c:forEach items="${vouchers}" var="v">
                        <c:set var="isExpired" value="${v.status == 0 || v.end < now || (not empty v.usageLimit && v.used >= v.usageLimit)}" />
                        <c:set var="rawCode" value="${v.code}" />
                        <c:set var="displayCode" value="${(rawCode.startsWith('PUB_')) ? rawCode.substring(4) : rawCode}" />
                        
                        <div class="mb-voucher-ticket ${isExpired ? 'expired' : ''}">
                            <div class="mb-voucher-left">
                                <c:choose>
                                    <c:when test="${v.discountType == 1}">
                                        <i class="fa fa-percent"></i>
                                        <span>Giảm<br/>${v.value}%</span>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fa fa-money"></i>
                                        <span>Giảm<br/>${v.value / 1000}K</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="mb-voucher-right">
                                <div>
                                    <h4 class="mb-voucher-title">${v.name}</h4>
                                    <p class="mb-voucher-cond">Đơn tối thiểu <fmt:formatNumber value="${v.minOrderAmount}" type="currency" currencySymbol="₫"/></p>
                                    <c:if test="${v.discountType == 1 && not empty v.maxDiscount}">
                                        <p class="mb-voucher-cond">Giảm tối đa <fmt:formatNumber value="${v.maxDiscount}" type="currency" currencySymbol="₫"/></p>
                                    </c:if>
                                </div>
                                <div class="mb-voucher-bottom">
                                    <p class="mb-voucher-exp">
                                        <c:choose>
                                            <c:when test="${v.status == 0}">Đã vô hiệu hóa</c:when>
                                            <c:when test="${v.end < now}">Hết hạn</c:when>
                                            <c:when test="${not empty v.usageLimit && v.used >= v.usageLimit}">Hết lượt sử dụng</c:when>
                                            <c:otherwise>HSD: <fmt:formatDate value="${v.end}" pattern="dd/MM/yyyy"/></c:otherwise>
                                        </c:choose>
                                    </p>
                                    <c:if test="${!isExpired}">
                                        <div class="mb-voucher-code" onclick="copyVoucherCode('${displayCode}')">
                                            ${displayCode}
                                            <i class="fa fa-copy"></i>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div id="toast">Đã sao chép mã giảm giá!</div>

<script>
function copyVoucherCode(code) {
    if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(code).then(showToast);
    } else {
        var textArea = document.createElement("textarea");
        textArea.value = code;
        textArea.style.position = "fixed";
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        try {
            document.execCommand('copy');
            showToast();
        } catch (err) {
            console.error('Không thể copy', err);
        }
        document.body.removeChild(textArea);
    }
}

function showToast() {
    var x = document.getElementById("toast");
    x.className = "show";
    setTimeout(function(){ x.className = x.className.replace("show", ""); }, 3000);
}
</script>

<%@include file="./components/footer.jsp" %>
