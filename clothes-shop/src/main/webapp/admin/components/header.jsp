<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="adminRole" value="${sessionScope.adminRole}"/>
<c:set var="adminFullname" value="${sessionScope.adminFullname}"/>
<c:set var="adminAvatar" value="${sessionScope.adminAvatar}"/>
<c:set var="navUri" value="${not empty requestScope['jakarta.servlet.forward.request_uri'] ? requestScope['jakarta.servlet.forward.request_uri'] : pageContext.request.requestURI}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>${not empty pageTitle ? pageTitle : 'Quản trị'} - Clothes Shop Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/core@latest/dist/css/tabler.min.css"/>
    <style>
        .navbar-brand-image { height: 2rem; }
        .page-wrapper { min-height: 100vh; }
    </style>
</head>
<body class="layout-fluid">
    <div class="page">
        <!-- Sidebar -->
        <aside class="navbar navbar-vertical navbar-expand-lg" data-bs-theme="dark">
            <div class="container-fluid">
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#sidebar-menu"
                        aria-controls="sidebar-menu" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <h1 class="navbar-brand navbar-brand-autodark">
                    <a href="${ctx}/admin/dashboard" style="text-decoration:none;color:inherit;">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M15 6v12a3 3 0 1 0 3-3H6a3 3 0 1 0 3 3V6a3 3 0 1 0-3 3h12a3 3 0 1 0-3-3"/>
                        </svg>
                        <span style="margin-left:8px;">Clothes Shop</span>
                    </a>
                </h1>
                <div class="collapse navbar-collapse" id="sidebar-menu">
                    <ul class="navbar-nav pt-lg-3">
                        <!-- Dashboard -->
                        <li class="nav-item">
                            <a class="nav-link ${fn:contains(navUri, '/admin/index.jsp') ? 'active' : ''}" href="${ctx}/admin/dashboard">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                                         stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                                        <polyline points="5 12 3 12 12 3 21 12 19 12"/>
                                        <path d="M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-7"/>
                                        <path d="M9 21v-6a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v6"/>
                                    </svg>
                                </span>
                                <span class="nav-link-title">Dashboard</span>
                            </a>
                        </li>

                        <!-- Attributes -->
                        <c:set var="isAttrActive" value="${fn:contains(navUri, '/admin/sizegroups') || fn:contains(navUri, '/admin/sizeoptions') || fn:contains(navUri, '/admin/colors')}" />
                        <li class="nav-item dropdown ${isAttrActive ? 'active' : ''}">
                            <a class="nav-link dropdown-toggle ${isAttrActive ? 'show active' : ''}" href="#navbar-catalog" data-bs-toggle="dropdown" data-bs-auto-close="false" role="button" aria-expanded="${isAttrActive ? 'true' : 'false'}">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                                        <path d="M4 7h16"/><path d="M4 17h16"/><path d="M7 4v16"/><path d="M17 4v16"/>
                                    </svg>
                                </span>
                                <span class="nav-link-title">Thuộc tính</span>
                            </a>
                            <div class="dropdown-menu ${isAttrActive ? 'show' : ''}">
                                <a class="dropdown-item ${fn:contains(navUri, '/admin/sizegroups') || fn:contains(navUri, '/admin/sizeoptions') ? 'active' : ''}" href="${ctx}/admin/sizegroups">Nhóm kích cỡ</a>
                                <a class="dropdown-item ${fn:contains(navUri, '/admin/colors') ? 'active' : ''}" href="${ctx}/admin/colors">Màu sắc</a>
                            </div>
                        </li>

                        <!-- Danh mục -->
                        <li class="nav-item">
                            <a class="nav-link ${fn:contains(navUri, '/admin/categories') ? 'active' : ''}" href="${ctx}/admin/categories">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                                         stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                                        <path d="M4 4h6v6h-6z"/><path d="M14 4h6v6h-6z"/>
                                        <path d="M4 14h6v6h-6z"/><path d="M14 14h6v6h-6z"/>
                                    </svg>
                                </span>
                                <span class="nav-link-title">Danh mục</span>
                            </a>
                        </li>

                        <!-- Thương hiệu -->
                        <li class="nav-item">
                            <a class="nav-link ${fn:contains(navUri, '/admin/brands') ? 'active' : ''}" href="${ctx}/admin/brands">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                                         stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                                        <path d="M7.5 7.5m-1 0a1 1 0 1 0 2 0a1 1 0 1 0-2 0"/>
                                        <path d="M3 6v5.172a2 2 0 0 0 .586 1.414l7.71 7.71a2.41 2.41 0 0 0 3.408 0l5.592-5.592a2.41 2.41 0 0 0 0-3.408l-7.71-7.71a2 2 0 0 0-1.414-.586h-5.172a3 3 0 0 0-3 3z"/>
                                    </svg>
                                </span>
                                <span class="nav-link-title">Thương hiệu</span>
                            </a>
                        </li>
                        
                        <!-- Nhà sản xuất -->
                        <li class="nav-item">
                            <a class="nav-link ${fn:contains(navUri, '/admin/producers') ? 'active' : ''}" href="${ctx}/admin/producers">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                                         stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                                        <rect x="4" y="4" width="16" height="16" rx="2" />
                                        <line x1="4" y1="12" x2="20" y2="12" />
                                        <line x1="12" y1="4" x2="12" y2="20" />
                                    </svg>
                                </span>
                                <span class="nav-link-title">Nhà sản xuất</span>
                            </a>
                        </li>

                        <!-- Sản phẩm -->
                        <li class="nav-item">
                            <a class="nav-link ${fn:contains(navUri, '/admin/products') ? 'active' : ''}" href="${ctx}/admin/products">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                                         stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                                        <polyline points="12 3 20 7.5 20 16.5 12 21 4 16.5 4 7.5 12 3"/>
                                        <line x1="12" y1="12" x2="20" y2="7.5"/>
                                        <line x1="12" y1="12" x2="12" y2="21"/>
                                        <line x1="12" y1="12" x2="4" y2="7.5"/>
                                    </svg>
                                </span>
                                <span class="nav-link-title">Sản phẩm</span>
                            </a>
                        </li>

                        <!-- Đánh giá -->
                        <li class="nav-item">
                            <a class="nav-link ${fn:contains(navUri, '/admin/feedbacks') ? 'active' : ''}" href="${ctx}/admin/feedbacks">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="icon"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M12 17.75l-6.172 3.245l1.179 -6.873l-5 -4.867l6.9 -1l3.086 -6.253l3.086 6.253l6.9 1l-5 4.867l1.179 6.873z" /></svg>
                                </span>
                                <span class="nav-link-title">Đánh giá</span>
                            </a>
                        </li>

                        <!-- Đơn hàng -->
                        <li class="nav-item">
                            <a class="nav-link ${fn:contains(navUri, '/admin/orders') ? 'active' : ''}" href="${ctx}/admin/orders">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                                         stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                                        <circle cx="6" cy="19" r="2"/><circle cx="17" cy="19" r="2"/>
                                        <path d="M17 17h-11v-14h-2"/><path d="M6 5l14 1l-1 7h-13"/>
                                    </svg>
                                </span>
                                <span class="nav-link-title">Đơn hàng</span>
                            </a>
                        </li>

                        <!-- Voucher -->
                        <li class="nav-item">
                            <a class="nav-link ${fn:contains(navUri, '/admin/vouchers') ? 'active' : ''}" href="${ctx}/admin/vouchers">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                                         stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                                        <path d="M15 5v2"/><path d="M15 11v2"/><path d="M15 17v2"/>
                                        <path d="M5 5h14a2 2 0 0 1 2 2v3a2 2 0 0 0 0 4v3a2 2 0 0 1-2 2h-14a2 2 0 0 1-2-2v-3a2 2 0 0 0 0-4v-3a2 2 0 0 1 2-2"/>
                                    </svg>
                                </span>
                                <span class="nav-link-title">Voucher</span>
                            </a>
                        </li>

                        <!-- Email Marketing -->
                        <li class="nav-item">
                            <a class="nav-link ${fn:contains(navUri, '/admin/marketing') ? 'active' : ''}" href="${ctx}/admin/marketing">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-mail" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                       <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                       <path d="M3 7a2 2 0 0 1 2 -2h14a2 2 0 0 1 2 2v10a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2v-10z"></path>
                                       <path d="M3 7l9 6l9 -6"></path>
                                    </svg>
                                </span>
                                <span class="nav-link-title">Marketing</span>
                            </a>
                        </li>

                        <!-- Quản lý Blog -->
                        <li class="nav-item dropdown ${fn:contains(navUri, '/admin/blog') ? 'active' : ''}">
                            <a class="nav-link dropdown-toggle ${fn:contains(navUri, '/admin/blog') ? 'show active' : ''}" href="#navbar-blog" data-bs-toggle="dropdown" data-bs-auto-close="false" role="button" aria-expanded="${fn:contains(navUri, '/admin/blog') ? 'true' : 'false'}">
                                <span class="nav-link-icon d-md-none d-lg-inline-block">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M16 6h3a1 1 0 0 1 1 1v11a2 2 0 0 1 -4 0v-13a1 1 0 0 0 -1 -1h-10a1 1 0 0 0 -1 1v12a3 3 0 0 0 3 3h11" /><path d="M8 8l4 0" /><path d="M8 12l4 0" /><path d="M8 16l4 0" /></svg>
                                </span>
                                <span class="nav-link-title">
                                    Quản lý Blog
                                </span>
                            </a>
                            <div class="dropdown-menu ${fn:contains(navUri, '/admin/blog') ? 'show' : ''}">
                                <div class="dropdown-menu-columns">
                                    <div class="dropdown-menu-column">
                                        <a class="dropdown-item ${fn:contains(navUri, '/admin/blogs') ? 'active' : ''}" href="${ctx}/admin/blogs">
                                            Bài viết
                                        </a>
                                        <a class="dropdown-item ${fn:contains(navUri, '/admin/blog-categories') ? 'active' : ''}" href="${ctx}/admin/blog-categories">
                                            Danh mục Blog
                                        </a>
                                        <a class="dropdown-item ${fn:contains(navUri, '/admin/blog-tags') ? 'active' : ''}" href="${ctx}/admin/blog-tags">
                                            Thẻ (Tags)
                                        </a>
                                        <a class="dropdown-item ${fn:contains(navUri, '/admin/blog-comments') ? 'active' : ''}" href="${ctx}/admin/blog-comments">
                                            Bình luận
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </li>

                        <!-- Admin-only: Quản lý tài khoản -->
                        <c:if test="${adminRole == 'admin'}">
                        <li class="nav-item">
                            <a class="nav-link ${fn:contains(navUri, '/admin/accounts') ? 'active' : ''}" href="${ctx}/admin/accounts">
                                <span class="nav-link-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                                         stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                        <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                                        <circle cx="9" cy="7" r="4"/><path d="M3 21v-2a4 4 0 0 1 4-4h4a4 4 0 0 1 4 4v2"/>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"/><path d="M21 21v-2a4 4 0 0 0-3-3.85"/>
                                    </svg>
                                </span>
                                <span class="nav-link-title">Tài khoản</span>
                            </a>
                        </li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </aside>
        <!-- /Sidebar -->

        <div class="page-wrapper">
            <!-- Header -->
            <header class="page-header d-print-none">
                <div class="container-xl">
                    <div class="page-header-content d-flex align-items-center">
                        <div class="ms-auto d-flex align-items-center">
                            <div class="nav-item dropdown">
                                <a href="#" class="nav-link d-flex lh-1 text-reset p-0" data-bs-toggle="dropdown"
                                   aria-label="Open user menu">
                                    <span class="avatar avatar-sm"
                                          style="background-image: url('${not empty adminAvatar ? adminAvatar : ''}')">
                                        <c:if test="${empty adminAvatar}">
                                            ${fn:substring(adminFullname, 0, 1)}
                                        </c:if>
                                    </span>
                                    <div class="d-none d-xl-block ps-2">
                                        <div>${adminFullname}</div>
                                        <div class="mt-1 small text-muted">${adminRole == 'admin' ? 'Quản trị viên' : 'Nhân viên'}</div>
                                    </div>
                                </a>
                                <div class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                                    <a href="${ctx}/admin/profile" class="dropdown-item">Hồ sơ cá nhân</a>
                                    <div class="dropdown-divider"></div>
                                    <a href="${ctx}/admin/logout" class="dropdown-item">Đăng xuất</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <!-- /Header -->
