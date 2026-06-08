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
                <form action="${ctx}/product" method="get">
                <input type="hidden" name="keyword" value="${keyword}">
                
                <!-- aside Widget 1: Danh mục -->
                <div class="aside mb-aside-group">
                    <h3 class="aside-title mb-collapsible active" data-target="#aside-category-content">
                        Danh mục
                        <span class="mb-collapse-icon"><i class="fa fa-minus"></i></span>
                    </h3>
                    <div id="aside-category-content" class="mb-collapse-content">
                        <div class="checkbox-filter">
                            <c:forEach items="${categories}" var="cate">
                                <c:set var="productCate" value="${getDao.getNumberOfProductByCategory(cate.ID)}" />
                                <c:if test="${productCate > 0}">
                                    <div class="input-checkbox-1">
                                        <input type="checkbox" id="category-${cate.ID}" class="category-filter" name="category" value="${cate.ID}"
                                               ${selectedCategories != null && selectedCategories.contains(cate.ID) ? "checked" : ""}/>
                                        <label for="category-${cate.ID}">
                                            <span></span>
                                            ${cate.name}
                                            <small>(${productCate})</small>
                                        </label>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <!-- aside Widget 2: Giá -->
                <div class="aside mb-aside-group">
                    <h3 class="aside-title mb-collapsible active" data-target="#aside-price-content">
                        Giá
                        <span class="mb-collapse-icon"><i class="fa fa-minus"></i></span>
                    </h3>
                    <div id="aside-price-content" class="mb-collapse-content">
                        <div class="price-filter">
                            <div id="price-slider"></div>
                            <div class="input-number price-min">
                                <input id="price-min" class="input-from-price" name="minPrice" type="number" value="${minPrice}" />
                                <span class="qty-up">+</span>
                                <span class="qty-down">-</span>
                            </div>
                            <span class="price-separator">-</span>
                            <div class="input-number price-max">
                                <input id="price-max" class="input-to-price" name="maxPrice" type="number" value="${maxPrice}" />
                                <span class="qty-up">+</span>
                                <span class="qty-down">-</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- aside Widget 3: Thương hiệu -->
                <div class="aside mb-aside-group">
                    <h3 class="aside-title mb-collapsible active" data-target="#aside-brand-content">
                        Thương hiệu
                        <span class="mb-collapse-icon"><i class="fa fa-minus"></i></span>
                    </h3>
                    <div id="aside-brand-content" class="mb-collapse-content">
                        <div class="checkbox-filter">
                            <c:forEach items="${brands}" var="brand">
                                <c:set var="brandCate" value="${getDao.getNumberProductByBrand(brand.ID)}" />
                                <c:if test="${brandCate > 0}">
                                    <div class="input-checkbox-1">
                                        <input type="checkbox" id="brand-${brand.ID}" class="brand-filter" name="brand" value="${brand.ID}"
                                               ${selectedBrands != null && selectedBrands.contains(brand.ID) ? "checked" : ""}/>
                                        <label for="brand-${brand.ID}">
                                            <span></span>
                                            ${brand.name}
                                            <small>(${brandCate})</small>
                                        </label>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- aside Widget 4: Sắp xếp & Lọc -->
                <div class="aside mb-aside-group">
                    <h3 class="aside-title mb-collapsible active" data-target="#aside-sort-content">
                        Sắp xếp
                        <span class="mb-collapse-icon"><i class="fa fa-minus"></i></span>
                    </h3>
                    <div id="aside-sort-content" class="mb-collapse-content">
                        <div class="checkbox-filter" style="padding-top: 5px;">
                            <div class="form-group" style="margin-bottom: 10px;">
                                <select name="sort" class="input-select sort-filter">
                                    <option value="0" ${sort == 0 ? "selected" : ""}>Giá tăng dần</option>
                                    <option value="1" ${sort == 1 ? "selected" : ""}>Giá giảm dần</option>
                                </select>
                            </div>
                            <div style="margin-top: 12px;">
                                <button class="btn-filter-submit" type="submit" name="btn-filter">
                                    <i class="fa fa-filter"></i> Áp dụng Lọc
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                </form>
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

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var collapsibles = document.querySelectorAll('.mb-collapsible');
        collapsibles.forEach(function (el) {
            el.addEventListener('click', function () {
                var targetId = this.getAttribute('data-target');
                var target = document.querySelector(targetId);
                if (!target) return;
                
                var isActive = this.classList.contains('active');
                if (isActive) {
                    this.classList.remove('active');
                    this.querySelector('.mb-collapse-icon i').className = 'fa fa-plus';
                } else {
                    this.classList.add('active');
                    this.querySelector('.mb-collapse-icon i').className = 'fa fa-minus';
                }
            });
        });
    });
</script>

<!-- FOOTER -->
<%@include file="./components/footer.jsp" %>

