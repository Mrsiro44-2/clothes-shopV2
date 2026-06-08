<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/blog-v2.css" />

<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li class="active">Blog</li>
        </ul>
    </div>
</div>

<div class="section mb-blog-page">
    <div class="container">
        <div class="mb-blog-hero">
            <h1>Blog Clothing shop</h1>
            <p>Kiến thức, mẹo hay và tin tức dành cho mẹ và bé</p>
        </div>

        <form class="mb-blog-toolbar" method="get" action="${ctx}/blog">
            <div class="mb-blog-search">
                <input type="text" name="q" value="${keyword}" placeholder="Tìm bài viết theo tiêu đề, mô tả..."/>
                <button type="submit"><i class="fa fa-search"></i> Tìm kiếm</button>
            </div>
            <div class="mb-blog-filters">
                <label>Danh mục:</label>
                <c:url var="allBlogUrl" value="/blog">
                    <c:if test="${not empty keyword}">
                        <c:param name="q" value="${keyword}"/>
                    </c:if>
                </c:url>
                <a href="${allBlogUrl}" class="mb-blog-chip ${categoryId == 0 ? 'active' : ''}">Tất cả</a>
                <c:forEach items="${categories}" var="cat">
                    <c:url var="catUrl" value="/blog">
                        <c:param name="category" value="${cat.ID}"/>
                        <c:if test="${not empty keyword}">
                            <c:param name="q" value="${keyword}"/>
                        </c:if>
                    </c:url>
                    <a href="${catUrl}" class="mb-blog-chip ${categoryId == cat.ID ? 'active' : ''}">${cat.name}</a>
                </c:forEach>
            </div>
            <div class="mb-blog-filters" style="margin-top: 10px;">
                <label>Thẻ (Tags):</label>
                <c:set var="displayedCount" value="0" />
                <c:forEach items="${allTags}" var="t">
                    <c:set var="tagIsSelected" value="false" />
                    <c:forEach items="${selectedTags}" var="st">
                        <c:if test="${st == t.slug}"><c:set var="tagIsSelected" value="true" /></c:if>
                    </c:forEach>
                    
                    <c:if test="${tagIsSelected or displayedCount < 8}">
                        <label class="mb-blog-chip ${tagIsSelected ? 'active' : ''}" style="cursor:pointer; display:inline-block;">
                            <input type="checkbox" name="tag" value="${t.slug}" ${tagIsSelected ? 'checked' : ''} onchange="this.form.submit()" style="display:none;"/>
                            #${t.name}
                        </label>
                        <c:if test="${not tagIsSelected}">
                            <c:set var="displayedCount" value="${displayedCount + 1}" />
                        </c:if>
                    </c:if>
                </c:forEach>
                
                <c:if test="${fn:length(allTags) > 8}">
                    <button type="button" class="mb-blog-chip" style="background:#f1f5f9; border:1px solid #e2e8f0; color:#475569;" onclick="document.getElementById('mb-tag-modal').style.display='flex'">Xem thêm <i class="fa fa-angle-down"></i></button>
                </c:if>
            </div>
        </form>

        <c:if test="${not empty keyword or categoryId > 0 or not empty selectedTags}">
            <p style="margin:-12px 0 20px;color:#6b7280;font-size:14px">
                Tìm thấy <strong>${totalPosts}</strong> bài viết
                <c:if test="${not empty keyword}"> cho "<em>${keyword}</em>"</c:if>
            </p>
        </c:if>

        <div class="mb-blog-grid">
            <c:forEach items="${posts}" var="p">
                <article class="mb-blog-card">
                    <c:choose>
                        <c:when test="${not empty p.coverImg}">
                            <c:set var="coverSrc" value="${imgUrl.resolve(fn:startsWith(p.coverImg, 'http') ? p.coverImg : '/uploads/blog/'.concat(p.coverImg), ctx)}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="coverSrc" value="${blogDefaultCover}"/>
                        </c:otherwise>
                    </c:choose>
                    <a href="${ctx}/blog/detail/${p.slug}" class="mb-blog-card__img-wrap">
                        <img src="${coverSrc}" alt="${p.title}"
                             data-fallback="${blogDefaultCover}"
                             class="mb-blog-img"
                             onerror="mbBlogImgOnError(this)"/>
                    </a>
                    <div class="mb-blog-card__body">
                        <h3 class="mb-blog-card__title">
                            <a href="${ctx}/blog/detail/${p.slug}">${p.title}</a>
                        </h3>
                        <div class="mb-blog-card__meta">
                            <c:if test="${not empty p.publishedAt}">
                                <fmt:formatDate value="${p.publishedAt}" pattern="dd MMM, yyyy" />
                            </c:if>
                            <span>by <span class="mb-blog-card__author">${not empty p.authorName ? p.authorName : 'Admin'}</span></span>
                            <span class="mb-blog-card__read-time">
                                <c:choose>
                                    <c:when test="${not empty p.readingMinutes and p.readingMinutes > 0}">
                                        ${p.readingMinutes} phút đọc
                                    </c:when>
                                    <c:otherwise>5 phút đọc</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="mb-blog-card__stats">
                            <i class="fa fa-eye"></i> ${p.viewCount} lượt xem
                            <c:if test="${not empty p.categoryName}"> · ${p.categoryName}</c:if>
                        </div>
                        <p class="mb-blog-card__excerpt">
                            <c:choose>
                                <c:when test="${not empty p.excerpt}">${p.excerpt}</c:when>
                                <c:otherwise>${fn:substring(p.title, 0, 120)}...</c:otherwise>
                            </c:choose>
                        </p>
                        <c:if test="${not empty p.tags}">
                            <div class="mb-blog-card__tags" style="margin-bottom:10px;">
                                <c:forEach items="${p.tags}" var="t">
                                    <a href="${ctx}/blog?tag=${t.slug}" style="display:inline-block; font-size:12px; color:#206bc4; background:#e6f2ff; padding:2px 8px; border-radius:4px; text-decoration:none; margin-right:5px;">#${t.name}</a>
                                </c:forEach>
                            </div>
                        </c:if>
                        <a href="${ctx}/blog/detail/${p.slug}" class="mb-blog-card__more">Đọc thêm →</a>
                    </div>
                </article>
            </c:forEach>
            <c:if test="${empty posts}">
                <div class="mb-blog-empty">
                    <p>Chưa có bài viết phù hợp.</p>
                    <a href="${ctx}/blog" class="mb-blog-card__more">Xem tất cả bài viết</a>
                </div>
            </c:if>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="mb-blog-pagination">
                <c:if test="${page > 1}">
                    <c:url var="prevUrl" value="/blog">
                        <c:param name="page" value="${page - 1}"/>
                        <c:if test="${not empty keyword}"><c:param name="q" value="${keyword}"/></c:if>
                        <c:if test="${categoryId > 0}"><c:param name="category" value="${categoryId}"/></c:if>
                    </c:url>
                    <a href="${prevUrl}">&laquo;</a>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="pg">
                    <c:url var="pageUrl" value="/blog">
                        <c:param name="page" value="${pg}"/>
                        <c:if test="${not empty keyword}"><c:param name="q" value="${keyword}"/></c:if>
                        <c:if test="${categoryId > 0}"><c:param name="category" value="${categoryId}"/></c:if>
                    </c:url>
                    <c:choose>
                        <c:when test="${pg == page}"><span class="active">${pg}</span></c:when>
                        <c:otherwise><a href="${pageUrl}">${pg}</a></c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:if test="${page < totalPages}">
                    <c:url var="nextUrl" value="/blog">
                        <c:param name="page" value="${page + 1}"/>
                        <c:if test="${not empty keyword}"><c:param name="q" value="${keyword}"/></c:if>
                        <c:if test="${categoryId > 0}"><c:param name="category" value="${categoryId}"/></c:if>
                    </c:url>
                    <a href="${nextUrl}">&raquo;</a>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<script>
function mbBlogImgOnError(img) {
    if (!img || img.dataset.mbFb === '1') return;
    var fb = img.getAttribute('data-fallback');
    if (fb && img.src !== fb) {
        img.dataset.mbFb = '1';
        img.src = fb;
        return;
    }
    img.style.display = 'none';
}
</script>

<!-- Tag Modal -->
<div id="mb-tag-modal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
    <div style="background:#fff; width:90%; max-width:500px; border-radius:8px; padding:20px; box-shadow:0 10px 25px rgba(0,0,0,0.1); position:relative; max-height:80vh; display:flex; flex-direction:column;">
        <button type="button" onclick="document.getElementById('mb-tag-modal').style.display='none'" style="position:absolute; top:15px; right:15px; background:none; border:none; font-size:20px; cursor:pointer; color:#6b7280;">&times;</button>
        <h3 style="margin-top:0; margin-bottom:15px; font-size:18px;">Chọn thẻ để lọc bài viết</h3>
        <input type="text" id="mb-tag-search" placeholder="Tìm kiếm thẻ..." style="width:100%; padding:10px 12px; border:1px solid #e5e7eb; border-radius:6px; margin-bottom:15px; font-family:inherit;" onkeyup="mbFilterTags()"/>
        <div id="mb-tag-list" style="overflow-y:auto; flex:1;">
            <form id="mb-tag-modal-form" action="${ctx}/blog" method="get" style="display:flex; flex-wrap:wrap; gap:8px; margin:0;">
                <c:if test="${not empty keyword}"><input type="hidden" name="q" value="${keyword}"/></c:if>
                <c:if test="${categoryId > 0}"><input type="hidden" name="category" value="${categoryId}"/></c:if>
                <!-- Include tags that are currently selected even if they don't match the current loop (though allTags has all tags, but we must pass other selected tags not in allTags? No, allTags covers all). -->
                <c:forEach items="${allTags}" var="t">
                    <c:set var="tagIsSelected" value="false" />
                    <c:forEach items="${selectedTags}" var="st">
                        <c:if test="${st == t.slug}"><c:set var="tagIsSelected" value="true" /></c:if>
                    </c:forEach>
                    <label class="mb-blog-chip ${tagIsSelected ? 'active' : ''}" style="cursor:pointer; display:inline-block; margin:0;" data-name="${fn:toLowerCase(t.name)}">
                        <input type="checkbox" name="tag" value="${t.slug}" ${tagIsSelected ? 'checked' : ''} onchange="this.form.submit()" style="display:none;"/>
                        #${t.name}
                    </label>
                </c:forEach>
            </form>
        </div>
    </div>
</div>

<script>
function mbFilterTags() {
    var input = document.getElementById('mb-tag-search').value.toLowerCase();
    var form = document.getElementById('mb-tag-modal-form');
    var labels = form.getElementsByTagName('label');
    for (var i = 0; i < labels.length; i++) {
        var name = labels[i].getAttribute('data-name') || "";
        if (name.indexOf(input) > -1) {
            labels[i].style.display = 'inline-block';
        } else {
            labels[i].style.display = 'none';
        }
    }
}
</script>

<%@include file="./components/footer.jsp" %>
