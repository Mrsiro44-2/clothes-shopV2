<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="sale" class="Utils.Sale"></jsp:useBean>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/wishlist-v2.css" />

<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li class="active">Yêu thích</li>
        </ul>
    </div>
</div>

<div class="section mb-wishlist-page">
    <div class="container">
        <div class="mb-wishlist-head">
            <h2>Danh sách yêu thích</h2>
            <p>
                <c:choose>
                    <c:when test="${not empty items}">${items.size()} sản phẩm đã lưu</c:when>
                    <c:otherwise>Chưa có sản phẩm trong danh sách yêu thích</c:otherwise>
                </c:choose>
            </p>
        </div>

        <c:if test="${empty items}">
            <div class="mb-wishlist-empty">
                <img src="./user/img/no-product-found.png" alt="Danh sách trống" onerror="this.style.display='none'"/>
                <h3>Chưa có sản phẩm yêu thích</h3>
                <p>Nhấn biểu tượng trái tim trên sản phẩm để lưu vào đây.</p>
                <a href="${ctx}/product" class="mb-shop-empty-btn">Khám phá cửa hàng</a>
            </div>
        </c:if>

        <c:if test="${not empty items}">
            <div class="row mb-wishlist-grid render-product">
                <c:forEach items="${items}" var="w" varStatus="status">
                    <div class="col-md-4 col-xs-6">
                        <c:set var="wishlistItem" value="${w}" scope="request"/>
                        <jsp:include page="components/wishlist-item-card.jsp"/>
                    </div>
                    <c:if test="${(status.index + 1) % 3 == 0}">
                        <div class="clearfix visible-md visible-lg"></div>
                    </c:if>
                    <c:if test="${(status.index + 1) % 2 == 0}">
                        <div class="clearfix visible-sm visible-xs"></div>
                    </c:if>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>

<%@include file="./components/footer.jsp" %>
