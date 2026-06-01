<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:useBean id="currency" class="Utils.CurrencyConverter"></jsp:useBean>
<jsp:useBean id="getDao" class="Utils.GetDAO"></jsp:useBean>
<jsp:useBean id="getCartLib" class="Utils.CartLib"></jsp:useBean>
<jsp:useBean id="wishlistLib" class="Utils.WishlistLib"></jsp:useBean>
<jsp:useBean id="imgUrl" class="Utils.ImageUrl" scope="application"></jsp:useBean>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="navUri" value="${pageContext.request.requestURI}"/>
<c:set var="navRel" value="${fn:replace(navUri, ctx, '')}"/>
<c:if test="${empty navRel}"><c:set var="navRel" value="/"/></c:if>
<c:set var="navHome" value="${navRel == '/' || navRel == '/home' || navRel == '/index.jsp'}"/>
<c:set var="navShop" value="${fn:indexOf(navRel, '/product') == 0 || fn:indexOf(navRel, '/filter') == 0}"/>
<c:set var="navBlog" value="${fn:indexOf(navRel, '/blog') == 0}"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8" />
        <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${ctx}/" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Clothes Shop</title>

        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&amp;display=swap" rel="stylesheet" />

        <link type="text/css" rel="stylesheet" href="./user/css/bootstrap.min.css" />
        <link type="text/css" rel="stylesheet" href="./user/css/slick.css" />
        <link type="text/css" rel="stylesheet" href="./user/css/slick-theme.css" />
        <link type="text/css" rel="stylesheet" href="./user/css/nouislider.min.css" />
        <link rel="stylesheet" href="./user/css/font-awesome.min.css" />
        <link type="text/css" rel="stylesheet" href="./user/css/style.css" />
        <link type="text/css" rel="stylesheet" href="./user/css/mb-theme.css" />
        <link type="text/css" rel="stylesheet" href="./user/css/mb-header-nav.css" />
        <link type="text/css" rel="stylesheet" href="./user/css/product-card-v2.css" />
        <link type="text/css" rel="stylesheet" href="./user/css/mb-modern.css" />
        <%@include file="../../components/image-fallback.jsp" %>
    </head>
    <body>
        <header class="mb-site-header">
            <div id="top-header" class="mb-top-strip">
                <div class="container">
                    <div class="mb-top-strip-inner">
                        <p>Bộ sưu tập mới đã lên kệ · Miễn phí giao hàng cho đơn từ 500.000đ · <a href="${ctx}/product">Mua ngay</a></p>
                        <div class="mb-top-strip__right">
                            <span><i class="fa fa-refresh"></i> Đổi trả 7 ngày</span>
                            <span><i class="fa fa-phone"></i> 1900 1234</span>
                        </div>
                    </div>
                </div>
            </div>

            <div id="header" class="mb-main-header">
                <div class="container">
                    <div class="mb-site-header-inner">
                        <div class="header-logo">
                            <a href="${ctx}/home" class="logo mb-brand">
                                <img src="./user/img/brand-mark.svg" alt="Clothes Shop">
                                <span class="mb-brand-copy">
                                    <span class="mb-brand-name">Clothes Shop</span>
                                    <span class="mb-brand-tagline">Modern essentials</span>
                                </span>
                            </a>
                        </div>

                        <nav id="navigation" class="mb-primary-nav" aria-label="Điều hướng chính">
                            <div id="responsive-nav">
                                <ul class="main-nav nav navbar-nav">
                                    <li class="${navHome ? 'active' : ''}"><a href="${ctx}/home">Trang chủ</a></li>
                                    <li class="${navShop ? 'active' : ''}"><a href="${ctx}/product">Cửa hàng</a></li>
                                    <li class="${navBlog ? 'active' : ''}"><a href="${ctx}/blog">Blog</a></li>
                                </ul>
                            </div>
                        </nav>

                        <div class="header-ctn">
                            <c:set var="userLogin" value="${getDao.getAccount(sessionScope.usernameUser)}" />
                            <c:if test="${userLogin != null}">
                                <c:set var="carts" value="${getCartLib.getAllCart(userLogin.ID)}" />
                            </c:if>
                            <c:set var="cartCount" value="${empty carts ? 0 : carts.size()}"/>

                            <div>
                                <a class="mb-header-action" href="${ctx}/wishlist" title="Yêu thích" aria-label="Yêu thích">
                                    <i class="fa fa-heart-o"></i>
                                    <c:if test="${userLogin != null}">
                                        <span class="qty">${wishlistLib.count(userLogin.ID)}</span>
                                    </c:if>
                                </a>
                            </div>

                            <div class="dropdown">
                                <a class="dropdown-toggle mb-header-action" data-toggle="dropdown" aria-expanded="false" title="Giỏ hàng" aria-label="Giỏ hàng">
                                    <i class="fa fa-shopping-bag"></i>
                                    <span class="qty">${cartCount}</span>
                                </a>
                                <div class="cart-dropdown">
                                    <div class="cart-list">
                                        <c:set var="totalCart" value="0" />
                                        <c:forEach items="${carts}" var="cart">
                                            <c:set var="lineTot" value="${cart.displayUnitPrice * cart.quantity}" />
                                            <c:set var="totalCart" value="${totalCart + lineTot}" />
                                            <div class="product-widget">
                                                <div class="product-img">
                                                    <c:if test="${not empty cart.mainImg}">
                                                        <img class="mb-img" src="${imgUrl.resolve(cart.mainImg, ctx)}" alt="${cart.productName}" onerror="mbImgOnError(this)"/>
                                                    </c:if>
                                                </div>
                                                <div class="product-body">
                                                    <h3 class="product-name">
                                                        <a href="${ctx}/product/detail/${cart.productID}">${cart.productName}</a>
                                                    </h3>
                                                    <p class="mb-cart-meta">
                                                        <c:if test="${not empty cart.colorName}">Màu: ${cart.colorName}</c:if>
                                                        <c:if test="${not empty cart.sizeLabel}"> · Size: ${cart.sizeLabel}</c:if>
                                                    </p>
                                                    <h4 class="product-price">
                                                        <span>${cart.quantity}x</span> ${currency.currencyFormat(lineTot)}
                                                    </h4>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        <c:if test="${cartCount == 0}">
                                            <p class="mb-cart-dropdown-empty">Giỏ hàng của bạn đang trống.</p>
                                        </c:if>
                                    </div>
                                    <c:if test="${cartCount > 0}">
                                        <div class="cart-summary">
                                            <small>${cartCount} sản phẩm đã chọn</small>
                                            <h5>Tạm tính: ${currency.currencyFormat(totalCart)}</h5>
                                        </div>
                                        <div class="cart-btns">
                                            <a href="${ctx}/cart">Xem giỏ</a>
                                            <a href="${ctx}/cart">Thanh toán <i class="fa fa-arrow-right"></i></a>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="dropdown">
                                <c:set var="userLoginRole" value="${sessionScope.usernameRole}" />
                                <c:set var="userLoginUsername" value="${sessionScope.usernameUser}" />
                                <c:choose>
                                    <c:when test="${userLoginUsername != null && userLoginRole != null}">
                                        <a class="dropdown-toggle mb-header-action" data-toggle="dropdown" aria-expanded="false" title="Tài khoản" aria-label="Tài khoản">
                                            <i class="fa fa-user-o"></i>
                                        </a>
                                        <div class="account-dropdown">
                                            <div><a href="${ctx}/account"><i class="fa fa-user-o"></i> Tài khoản</a></div>
                                            <div><a href="${ctx}/wishlist"><i class="fa fa-heart-o"></i> Yêu thích</a></div>
                                            <div><a href="${ctx}/cart"><i class="fa fa-shopping-bag"></i> Giỏ hàng</a></div>
                                            <div><a href="${ctx}/logout"><i class="fa fa-sign-out"></i> Đăng xuất</a></div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="mb-header-action" href="${ctx}/login" title="Đăng nhập" aria-label="Đăng nhập">
                                            <i class="fa fa-user-o"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="menu-toggle">
                                <a class="mb-header-action" href="#" title="Menu" aria-label="Menu">
                                    <i class="fa fa-bars"></i>
                                    <span>Menu</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>
