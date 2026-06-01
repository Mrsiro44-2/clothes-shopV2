<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/blog-v2.css" />

<c:choose>
    <c:when test="${not empty post.coverImg}">
        <c:set var="coverSrc" value="${imgUrl.resolve(post.coverImg, ctx)}"/>
    </c:when>
    <c:otherwise>
        <c:set var="coverSrc" value="${blogDefaultCover}"/>
    </c:otherwise>
</c:choose>

<main class="mb-blog-detail-page">
    <div id="breadcrumb" class="section">
        <div class="container">
            <ul class="breadcrumb-tree">
                <li><a href="${ctx}/home">Trang chủ</a></li>
                <li><a href="${ctx}/blog">Blog</a></li>
                <li class="active">${post.title}</li>
            </ul>
        </div>
    </div>

    <section class="section">
        <div class="container">
            <header class="mb-blog-detail-hero">
                <span class="mb-kicker">${not empty post.categoryName ? post.categoryName : 'Editorial'}</span>
                <h1>${post.title}</h1>
                <div class="mb-blog-detail-meta">
                    <span>${not empty post.authorName ? post.authorName : 'Admin'}</span>
                    <c:if test="${not empty post.publishedAt}">
                        <span><fmt:formatDate value="${post.publishedAt}" pattern="dd MMM, yyyy" /></span>
                    </c:if>
                    <span>${post.viewCount} lượt xem</span>
                    <span>
                        <c:choose>
                            <c:when test="${not empty post.readingMinutes and post.readingMinutes > 0}">
                                ${post.readingMinutes} phút đọc
                            </c:when>
                            <c:otherwise>5 phút đọc</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </header>

            <div class="mb-blog-detail-cover">
                <img src="${coverSrc}" alt="${post.title}" onerror="this.style.display='none'"/>
            </div>

            <article class="mb-blog-article">
                <c:if test="${not empty post.excerpt}">
                    <p><strong>${post.excerpt}</strong></p>
                </c:if>
                ${post.contentHtml}
            </article>
        </div>
    </section>
</main>

<%@include file="./components/footer.jsp" %>
