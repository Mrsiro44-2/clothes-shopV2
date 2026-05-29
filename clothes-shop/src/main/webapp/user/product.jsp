<%-- 
    Document   : product
    Created on : May 18, 2024, 11:46:13 PM
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="sale" class="Utils.Sale"></jsp:useBean>
<jsp:useBean id="pagination" class="Utils.Pagination"></jsp:useBean>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/mb-shop-search.css" />
<!-- /HEADER -->
<!-- BREADCRUMB -->
<div id="breadcrumb" class="section">
    <!-- container -->
    <div class="container">
        <!-- row -->
        <div class="row">
            <div class="col-md-12">
                <ul class="breadcrumb-tree">
                    <li><a href="${ctx}/home">Trang chủ</a></li>
                    <li><a href="${ctx}/product">Cửa hàng</a></li>
                    ${getDao.getNavigation(key, ctx)}
                    <li class="active">(${sizeProduct} kết quả)</li>
                </ul>
            </div>
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</div>
<!-- /BREADCRUMB -->

<!-- SECTION -->
<div class="section">
    <!-- container -->
    <div class="container">
        <!-- row -->
        <div class="row">
            <!-- ASIDE -->
            <div id="aside" class="col-md-3">
                <!-- aside Widget -->
                <div class="aside">
                    <h3 class="aside-title">Danh mục</h3>
                    <div class="checkbox-filter">
                        <c:forEach items="${categories}" var="cate">
                            <c:set var="productCate" value="${getDao.getNumberOfProductByCategory(cate.ID)}" />
                            <c:if test="${productCate > 0}">
                                <div class="input-checkbox-1">
                                    <input type="checkbox" class="category-filter" name="category" value="${cate.ID}"
                                           ${idCategory != null && idCategory == cate.ID ? "checked" : ""}/>
                                    <label for="category-1">
                                        <span></span>
                                        ${cate.name}
                                        <small>(${productCate})</small>
                                    </label>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
                <!-- /aside Widget -->

                <!-- aside Widget -->
                <div class="aside">
                    <h3 class="aside-title">Giá</h3>
                    <div class="price-filter">
                        <div id="price-slider"></div>
                        <div class="input-number price-min">
                            <input id="price-min" class="input-from-price" type="number" />
                            <span class="qty-up">+</span>
                            <span class="qty-down">-</span>
                        </div>
                        <span>-</span>
                        <div class="input-number price-max">
                            <input id="price-max" class="input-to-price" type="number" />
                            <span class="qty-up">+</span>
                            <span class="qty-down">-</span>
                        </div>
                    </div>
                </div>
                <!-- /aside Widget -->

                <!-- aside Widget -->
                <div class="aside">
                    <h3 class="aside-title">Thương hiệu</h3>
                    <div class="checkbox-filter">
                        <c:forEach items="${brands}" var="brand">
                            <c:set var="brandCate" value="${getDao.getNumberProductByBrand(brand.ID)}" />
                            <c:if test="${brandCate > 0}">
                                <div class="input-checkbox-1">
                                    <input type="checkbox" class="brand-filter" name="brand" value="${brand.ID}"
                                           ${idBrand != null && idBrand == brand.ID ? "checked" : ""}/>
                                    <label for="category-1">
                                        <span></span>
                                        ${brand.name}
                                        <small>(${brandCate})</small>
                                    </label>
                                </div>
                            </c:if>
                        </c:forEach>
                        <div class="input-checkbox">
                            <h3 class="aside-title">Sắp xếp</h3>
                            <select class="input-select sort-filter">
                                <option value="0">Giá tăng dần</option>
                                <option value="1">Giá giảm dần</option>
                            </select>
                        </div>
                        <div class="input-checkbox">
                            <button onclick="filterProduct('.render-product')" class="btn btn-primary" type="submit" name="btn-filter">Lọc</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- STORE -->
            <div id="store" class="col-md-9">
                <jsp:include page="components/shop-search.jsp"/>
                <c:set var="pageSize" value="${empty pageSize ? 9 : pageSize}"/>
                <c:if test="${empty products}">
                    <jsp:include page="components/shop-empty.jsp"/>
                </c:if>
                <c:if test="${not empty products}">
                <!-- store products -->
                <div class="row render-product">
                    <c:forEach items="${products}" var="pro" varStatus="status">
                        <div class="col-md-4 col-xs-6">
                            <c:set var="cardProduct" value="${pro}" scope="request"/>
                            <c:set var="cardPathUrl" value="${ctx}/product" scope="request"/>
                            <jsp:include page="components/product-card.jsp"/>
                        </div>
                        <!-- clearfix for responsive layout -->
                        <c:if test="${(status.index + 1) % 3 == 0}">
                            <div class="clearfix visible-md visible-lg"></div>
                        </c:if>
                        <c:if test="${(status.index + 1) % 2 == 0}">
                            <div class="clearfix visible-sm visible-xs"></div>
                        </c:if>
                    </c:forEach>
                    <!-- /product -->
                </div>
                <!-- /store products -->

                <!-- store bottom filter -->
                ${pagination.generatePagination(page, pagination.totalPages(sizeProduct, pageSize), urlPage, key)}
                <!-- /store bottom filter -->
                </c:if>
            </div>
            <!-- /STORE -->
        </div>
        <!-- /row -->
    </div>
    <!-- /container -->
</div>
<!-- /SECTION -->

<!-- FOOTER -->
<script src="./user/js/filter.js"></script>
<%@include file="./components/footer.jsp" %>

