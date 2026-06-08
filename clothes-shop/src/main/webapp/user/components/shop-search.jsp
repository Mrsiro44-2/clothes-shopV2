<%-- Thanh tìm kiếm — dùng trên trang Cửa hàng / Kết quả tìm kiếm --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${empty ctx}"><c:set var="ctx" value="${pageContext.request.contextPath}"/></c:if>
<div class="mb-shop-search-wrap">
    <form class="mb-shop-search" action="${ctx}/product" method="get">
        <input class="input" type="text" name="keyword" id="shop-search"
               placeholder="Tìm sản phẩm bạn cần..."
               value="${not empty keyword ? keyword : ''}"/>
               
        <c:if test="${not empty selectedCategories}">
            <c:forEach var="catId" items="${selectedCategories}">
                <input type="hidden" name="category" value="${catId}"/>
            </c:forEach>
        </c:if>
        
        <c:if test="${not empty selectedBrands}">
            <c:forEach var="brandId" items="${selectedBrands}">
                <input type="hidden" name="brand" value="${brandId}"/>
            </c:forEach>
        </c:if>
        
        <c:if test="${not empty minPrice}">
            <input type="hidden" name="minPrice" value="${minPrice}"/>
        </c:if>
        <c:if test="${not empty maxPrice}">
            <input type="hidden" name="maxPrice" value="${maxPrice}"/>
        </c:if>
        <c:if test="${not empty sort}">
            <input type="hidden" name="sort" value="${sort}"/>
        </c:if>

        <button type="submit" class="mb-shop-search-btn">
            <i class="fa fa-search"></i> Tìm kiếm
        </button>
    </form>
</div>
