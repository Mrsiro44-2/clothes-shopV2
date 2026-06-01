<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="sale" class="Utils.Sale"></jsp:useBean>
<jsp:useBean id="pagination" class="Utils.Pagination"></jsp:useBean>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/mb-shop-search.css" />

<main class="mb-shop-page">
    <div id="breadcrumb" class="section">
        <div class="container">
            <ul class="breadcrumb-tree">
                <li><a href="${ctx}/home">Trang chủ</a></li>
                <li><a href="${ctx}/product">Cửa hàng</a></li>
                <li class="active">Tìm kiếm: ${key} (${sizeProduct} kết quả)</li>
            </ul>
        </div>
    </div>

    <section class="mb-page-hero">
        <div class="container">
            <span class="mb-kicker">Search</span>
            <h1>Kết quả tìm kiếm</h1>
            <p>Đang hiển thị sản phẩm phù hợp với từ khóa “${key}”. Bạn có thể đổi từ khóa hoặc lọc lại theo nhu cầu.</p>
        </div>
    </section>

    <section class="section mb-shop-section">
        <div class="container">
            <div class="mb-shop-layout">
                <aside id="aside" class="mb-shop-filter-panel">
                    <div class="mb-shop-filter-head">
                        <h2>Bộ lọc</h2>
                        <i class="fa fa-sliders"></i>
                    </div>

                    <div class="aside">
                        <h3 class="aside-title">Danh mục</h3>
                        <div class="checkbox-filter">
                            <c:forEach items="${categories}" var="cate">
                                <c:set var="productCate" value="${getDao.getNumberOfProductByCategory(cate.ID)}" />
                                <c:if test="${productCate > 0}">
                                    <div class="input-checkbox">
                                        <input type="checkbox" class="category" name="category" value="${cate.ID}"/>
                                        <label>
                                            ${cate.name}
                                            <small>(${productCate})</small>
                                        </label>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="aside">
                        <h3 class="aside-title">Khoảng giá</h3>
                        <div class="price-filter">
                            <div id="price-slider"></div>
                            <div class="input-number price-min">
                                <input id="price-min" type="number" aria-label="Giá thấp nhất" />
                                <span class="qty-up">+</span>
                                <span class="qty-down">-</span>
                            </div>
                            <span>-</span>
                            <div class="input-number price-max">
                                <input id="price-max" type="number" aria-label="Giá cao nhất" />
                                <span class="qty-up">+</span>
                                <span class="qty-down">-</span>
                            </div>
                        </div>
                    </div>

                    <div class="aside">
                        <h3 class="aside-title">Thương hiệu</h3>
                        <div class="checkbox-filter">
                            <c:forEach items="${brands}" var="brand">
                                <c:set var="brandCate" value="${getDao.getNumberProductByBrand(brand.ID)}" />
                                <c:if test="${brandCate > 0}">
                                    <div class="input-checkbox">
                                        <input type="checkbox" class="brand" name="brand" value="${brand.ID}"/>
                                        <label>
                                            ${brand.name}
                                            <small>(${brandCate})</small>
                                        </label>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="aside">
                        <h3 class="aside-title">Sắp xếp</h3>
                        <select class="input-select">
                            <option value="0">Phổ biến</option>
                            <option value="1">Mới nhất</option>
                        </select>
                        <button class="mb-btn mb-btn-primary mb-filter-button" type="button">
                            <i class="fa fa-filter"></i> Áp dụng
                        </button>
                    </div>
                </aside>

                <section id="store" class="mb-shop-results">
                    <div class="mb-shop-results-head">
                        <div>
                            <span class="mb-kicker">Kết quả</span>
                            <h2>Sản phẩm tìm thấy</h2>
                        </div>
                        <span class="mb-result-count">${sizeProduct} sản phẩm</span>
                    </div>

                    <jsp:include page="components/shop-search.jsp"/>
                    <c:set var="pageSize" value="${empty pageSize ? 9 : pageSize}"/>

                    <c:if test="${empty products or searchEmpty}">
                        <c:set var="emptyTitle" value="Không tìm thấy sản phẩm phù hợp" scope="request"/>
                        <c:set var="emptyMessage" value="Không có kết quả cho &quot;${keyword}&quot;. Thử từ khóa khác hoặc duyệt cửa hàng." scope="request"/>
                        <jsp:include page="components/shop-empty.jsp"/>
                    </c:if>

                    <c:if test="${not empty products}">
                        <div class="mb-product-grid render-product">
                            <c:forEach items="${products}" var="pro">
                                <div class="mb-product-grid__item">
                                    <c:set var="cardProduct" value="${pro}" scope="request"/>
                                    <c:set var="cardPathUrl" value="${ctx}/product/search" scope="request"/>
                                    <jsp:include page="components/product-card.jsp"/>
                                </div>
                            </c:forEach>
                        </div>
                        ${pagination.generatePagination(page, pagination.totalPages(sizeProduct, pageSize), "product/search", keyword)}
                    </c:if>
                </section>
            </div>
        </div>
    </section>
</main>

<%@include file="./components/footer.jsp" %>
