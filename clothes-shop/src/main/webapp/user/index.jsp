<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="./components/header.jsp" %>
<c:if test="${empty homeBanners}">
    <jsp:useBean id="appImagesFallback" class="Utils.AppImages"/>
    <c:set var="homeBanners" value="${appImagesFallback.homeBannerList}"/>
</c:if>
<jsp:useBean id="sale" class="Utils.Sale"></jsp:useBean>

<main class="mb-home-page">
    <section class="section mb-home-hero-section">
        <div class="container">
            <div class="mb-home-hero">
                <aside class="mb-home-categories">
                    <span class="mb-kicker">Danh mục</span>
                    <h3>Khám phá nhanh</h3>
                    <div class="mb-category-list">
                        <c:forEach items="${categories}" var="cate">
                            <a class="mb-category-link" href="${ctx}/product/?type=category&amp;id=${cate.ID}">
                                <span>${cate.name}</span>
                                <i class="fa fa-angle-right"></i>
                            </a>
                        </c:forEach>
                    </div>
                </aside>

                <div id="carousel-example-generic" class="carousel slide mb-hero-carousel" data-ride="carousel">
                    <ol class="carousel-indicators">
                        <c:forEach items="${homeBanners}" var="banner" varStatus="i">
                            <li data-target="#carousel-example-generic"
                                data-slide-to="${i.index}"
                                class="${i.index == 0 ? 'active' : ''}"></li>
                        </c:forEach>
                    </ol>

                    <div class="carousel-inner" role="listbox">
                        <c:forEach items="${homeBanners}" var="bannerUrl" varStatus="i">
                            <div class="item ${i.index == 0 ? 'active' : ''}">
                                <img src="${bannerUrl}" alt="Bộ sưu tập ${i.index + 1}" class="mb-img" onerror="mbImgOnError(this)"/>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="mb-hero-copy">
                        <span class="mb-kicker">New season</span>
                        <h1>Nâng cấp tủ đồ hằng ngày</h1>
                        <p>Những thiết kế dễ mặc, dễ phối và đủ chỉn chu cho công sở, cafe cuối tuần hay một buổi dạo phố.</p>
                        <a class="mb-btn mb-btn-primary" href="${ctx}/product">
                            Xem bộ sưu tập <i class="fa fa-arrow-right"></i>
                        </a>
                    </div>

                    <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev" aria-label="Trước">
                        <i class="fa fa-chevron-left" aria-hidden="true"></i>
                    </a>
                    <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next" aria-label="Sau">
                        <i class="fa fa-chevron-right" aria-hidden="true"></i>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <section class="section mb-product-shelf">
        <div class="container">
            <div class="mb-section-heading">
                <div>
                    <span class="mb-kicker">Hôm nay</span>
                    <h2>Ưu đãi nổi bật</h2>
                    <p>Các sản phẩm đang có mức giá tốt, được chọn để bạn mua nhanh mà vẫn giữ phong cách.</p>
                </div>
                <div id="slick-nav-deal" class="products-slick-nav"></div>
            </div>

            <div class="products-tabs">
                <div class="tab-pane fade in active">
                    <div class="products-slick" data-nav="#slick-nav-deal">
                        <c:forEach items="${productsDeal}" var="productDeal">
                            <c:set var="cardProduct" value="${productDeal}" scope="request"/>
                            <c:set var="cardPathUrl" value="${ctx}" scope="request"/>
                            <jsp:include page="components/product-card.jsp"/>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="text-center">
                <a href="${ctx}/product" class="mb-btn mb-btn-ghost">Xem tất cả sản phẩm</a>
            </div>
        </div>
    </section>

    <section class="section mb-product-shelf--soft">
        <div class="container">
            <div class="mb-section-heading">
                <div>
                    <span class="mb-kicker">Thương hiệu</span>
                    <h2>Brand đang được quan tâm</h2>
                    <p>Lọc nhanh theo thương hiệu để tìm đúng chất liệu, phom dáng và phong cách bạn thích.</p>
                </div>
            </div>

            <div class="mb-brand-grid">
                <c:forEach items="${brands}" var="br">
                    <a class="mb-brand-tile" href="${ctx}/product?type=brand&amp;id=${br.ID}">
                        <img class="mb-img" src="${imgUrl.resolve(br.img, ctx)}" alt="${br.name}" onerror="mbImgOnError(this)"/>
                        <span>${br.name}</span>
                    </a>
                </c:forEach>
            </div>
        </div>
    </section>

    <section class="section mb-product-shelf">
        <div class="container">
            <div class="mb-section-heading">
                <div>
                    <span class="mb-kicker">Tháng này</span>
                    <h2>Sản phẩm bán chạy</h2>
                    <p>Những món đang được khách hàng chọn nhiều nhất, phù hợp để bắt đầu nếu bạn chưa biết mua gì.</p>
                </div>
                <div>
                    <a href="${ctx}/product" class="mb-btn mb-btn-primary">Xem tất cả</a>
                    <div id="slick-nav-feature" class="products-slick-nav"></div>
                </div>
            </div>

            <div class="products-tabs">
                <div class="tab-pane active">
                    <div class="products-slick" data-nav="#slick-nav-feature">
                        <c:forEach items="${productsFeature}" var="productFeature">
                            <c:set var="cardProduct" value="${productFeature}" scope="request"/>
                            <c:set var="cardPathUrl" value="${ctx}" scope="request"/>
                            <jsp:include page="components/product-card.jsp"/>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <div class="mb-hotdeal-modern">
                <div class="mb-hotdeal-content">
                    <span class="mb-kicker">Limited offer</span>
                    <h2>Ưu đãi tuần này</h2>
                    <p>Cập nhật các item mới nhất với mức giảm đến 50% cho một số sản phẩm được chọn.</p>
                    <a class="mb-btn mb-btn-primary" href="${ctx}/product">Mua ngay</a>
                </div>
            </div>
        </div>
    </section>

    <section class="section mb-product-shelf">
        <div class="container">
            <div class="mb-section-heading">
                <div>
                    <span class="mb-kicker">Khám phá</span>
                    <h2>Sản phẩm mới trong cửa hàng</h2>
                    <p>Danh sách sản phẩm mới và cơ bản để bạn phối đồ theo nhu cầu mỗi ngày.</p>
                </div>
                <div id="slick-nav-normal" class="products-slick-nav"></div>
            </div>

            <div class="products-tabs">
                <div class="tab-pane fade in active">
                    <div class="products-slick" data-nav="#slick-nav-normal">
                        <c:forEach items="${productsNormal}" var="productNormal">
                            <c:set var="cardProduct" value="${productNormal}" scope="request"/>
                            <c:set var="cardPathUrl" value="${ctx}" scope="request"/>
                            <jsp:include page="components/product-card.jsp"/>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="text-center">
                <a href="${ctx}/product" class="mb-btn mb-btn-ghost">Xem cửa hàng</a>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <div class="mb-service-band">
                <div class="mb-service-item">
                    <div class="mb-service-icon"><i class="fa fa-truck"></i></div>
                    <h4>Giao hàng nhanh</h4>
                    <p>Miễn phí giao hàng cho đơn từ 500.000đ.</p>
                </div>
                <div class="mb-service-item">
                    <div class="mb-service-icon"><i class="fa fa-headphones"></i></div>
                    <h4>Hỗ trợ tận tâm</h4>
                    <p>Tư vấn chọn size và xử lý đơn hàng rõ ràng.</p>
                </div>
                <div class="mb-service-item">
                    <div class="mb-service-icon"><i class="fa fa-shield"></i></div>
                    <h4>Đổi trả linh hoạt</h4>
                    <p>Đổi trả trong 7 ngày với sản phẩm đủ điều kiện.</p>
                </div>
            </div>
        </div>
    </section>
</main>

<%@include file="./components/footer.jsp" %>
