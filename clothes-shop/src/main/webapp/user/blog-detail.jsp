<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/blog-v2.css" />
<script>
function mbBlogImgOnError(img) {
    if (!img || img.dataset.mbFb === '1') return;
    img.dataset.mbFb = '1';
    var fb = '${blogDefaultCover}';
    if (fb && img.src !== fb) {
        img.src = fb;
    } else {
        img.style.display = 'none';
    }
}
</script>

<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li><a href="${ctx}/blog">Blog</a></li>
            <li class="active">${post.title}</li>
        </ul>
    </div>
</div>

<div class="mb-blog-detail-container">
    <div class="container">
        <div class="row">
            <!-- Cột chính: Nội dung bài viết và bình luận -->
            <div class="col-md-9">
                <article class="mb-blog-detail-card">
                    <div class="mb-blog-detail__header">
                        <c:if test="${not empty post.categoryName}">
                            <span class="mb-blog-detail__cat">${post.categoryName}</span>
                        </c:if>
                        <h1 class="mb-blog-detail__title">${post.title}</h1>
                        <div class="mb-blog-detail__meta">
                            <span>
                                <i class="fa fa-calendar"></i>
                                <c:choose>
                                    <c:when test="${not empty post.publishedAt}">
                                        <fmt:formatDate value="${post.publishedAt}" pattern="dd MMM, yyyy" />
                                    </c:when>
                                    <c:otherwise>Chưa xuất bản</c:otherwise>
                                </c:choose>
                            </span>
                            <span>
                                <i class="fa fa-user"></i>
                                Bởi <strong style="color:#111">${not empty post.authorName ? post.authorName : 'Admin'}</strong>
                            </span>
                            <span>
                                <i class="fa fa-eye"></i>
                                ${post.viewCount} lượt xem
                            </span>
                            <span>
                                <i class="fa fa-clock-o"></i>
                                <c:choose>
                                    <c:when test="${not empty post.readingMinutes and post.readingMinutes > 0}">
                                        ${post.readingMinutes} phút đọc
                                    </c:when>
                                    <c:otherwise>5 phút đọc</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <!-- Cover Image -->
                    <c:choose>
                        <c:when test="${not empty post.coverImg}">
                            <c:set var="coverSrc" value="${imgUrl.resolve(fn:startsWith(post.coverImg, 'http') ? post.coverImg : '/uploads/blog/'.concat(post.coverImg), ctx)}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="coverSrc" value="${blogDefaultCover}"/>
                        </c:otherwise>
                    </c:choose>
                    <img src="${coverSrc}" alt="${post.title}" class="mb-blog-detail__cover" onerror="mbBlogImgOnError(this)"/>

                    <!-- HTML Content -->
                    <div class="mb-blog-detail__content">
                        ${post.contentHtml}
                    </div>

                    <!-- Tags -->
                    <c:if test="${not empty post.tags}">
                        <div class="mb-blog-detail__tags" style="margin: 20px 0; padding-top: 20px; border-top: 1px solid #eee;">
                            <span style="font-weight: 600; margin-right: 10px;">Thẻ (Tags):</span>
                            <c:forEach items="${post.tags}" var="t">
                                <a href="${ctx}/blog?tag=${t.slug}" style="display:inline-block; font-size:13px; color:#206bc4; background:#e6f2ff; padding:4px 10px; border-radius:4px; text-decoration:none; margin-right:8px; margin-bottom:8px;">#${t.name}</a>
                            </c:forEach>
                        </div>
                    </c:if>

                    <!-- Share Block -->
                    <div class="mb-blog-share-box">
                        <h4 class="mb-blog-share__title"><i class="fa fa-share-alt"></i> Chia sẻ bài viết này:</h4>
                        <div class="mb-blog-share__buttons">
                            <!-- Facebook -->
                            <a id="share-facebook" target="_blank" href="#" class="mb-share-btn mb-share-btn--facebook" title="Chia sẻ Facebook">
                                <i class="fa fa-facebook"></i>
                            </a>
                            <!-- Twitter / X -->
                            <a id="share-twitter" target="_blank" href="#" class="mb-share-btn mb-share-btn--twitter" title="Chia sẻ Twitter (X)">
                                <i class="fa fa-twitter"></i>
                            </a>
                            <!-- Telegram -->
                            <a id="share-telegram" target="_blank" href="#" class="mb-share-btn mb-share-btn--telegram" title="Chia sẻ Telegram">
                                <i class="fa fa-paper-plane"></i>
                            </a>
                            <!-- Copy URL -->
                            <button id="copy-link-btn" class="mb-share-btn mb-share-btn--copy" title="Sao chép liên kết">
                                <i class="fa fa-clone"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Comments Section -->
                    <div class="mb-blog-comments-section">
                        <h3 class="mb-blog-comments__title">
                            Bình luận (${fn:length(comments)})
                        </h3>

                        <!-- Comment form -->
                        <div class="mb-comment-form-box" style="margin-bottom: 40px;">
                            <h4>Để lại bình luận</h4>
                            <form action="${ctx}/blog/comment" method="post">
                                <input type="hidden" name="blogPostId" value="${post.ID}" />
                                
                                <c:set var="sessionUser" value="${getDao.getAccount(sessionScope.usernameUser)}" />
                                <c:choose>
                                    <c:when test="${not empty sessionUser}">
                                        <p style="font-size:13px;color:#4b5563;margin-bottom:12px">
                                            Đăng bình luận với tư cách: <strong style="color:#111">${sessionUser.fullname}</strong>
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mb-comment-form-row">
                                            <div class="mb-comment-form-group">
                                                <label for="guestName">Họ tên của bạn *</label>
                                                <input type="text" id="guestName" name="guestName" placeholder="Nguyễn Văn A" required maxlength="100"/>
                                            </div>
                                            <div class="mb-comment-form-group">
                                                <label for="guestEmail">Email liên hệ *</label>
                                                <input type="email" id="guestEmail" name="guestEmail" placeholder="email@example.com" required maxlength="100"/>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="mb-comment-form-group" style="margin-bottom:20px">
                                    <label for="commentBody">Nội dung bình luận *</label>
                                    <textarea id="commentBody" name="body" rows="4" placeholder="Nhập bình luận của bạn tại đây..." required></textarea>
                                </div>
                                <button type="submit" class="mb-comment-submit-btn">Gửi bình luận</button>
                            </form>
                        </div>
                        
                        <ul class="mb-comments-list">
                            <c:set var="sessionUser" value="${getDao.getAccount(sessionScope.usernameUser)}" />
                            <c:forEach items="${comments}" var="c">
                                <li class="mb-comment-item">
                                    <div class="mb-comment-avatar">
                                        <c:choose>
                                            <c:when test="${not empty c.accountID}">
                                                <jsp:useBean id="commentAccDao" class="DAO.AccountDAO" />
                                                <c:set var="commentAcc" value="${commentAccDao.getAccountById(c.accountID)}" />
                                                <c:choose>
                                                    <c:when test="${not empty commentAcc.avatar}">
                                                        <img src="${imgUrl.resolve(commentAcc.avatar, ctx)}" alt="" onerror="this.style.display='none'"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:substring(c.guestName, 0, 1)}
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                ${fn:substring(c.guestName, 0, 1)}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mb-comment-body" style="width: 100%;">
                                        <div class="mb-comment-header" style="display: flex; justify-content: space-between; align-items: flex-start;">
                                            <div>
                                                <h5 class="mb-comment-author">${c.guestName}</h5>
                                                <span class="mb-comment-date">
                                                    <fmt:formatDate value="${c.datePost}" pattern="dd/MM/yyyy HH:mm" />
                                                </span>
                                            </div>
                                            <c:if test="${not empty sessionUser and sessionUser.ID == c.accountID}">
                                                <div class="dropdown" style="position: relative;">
                                                    <button class="dropdown-toggle" style="background:none;border:none;cursor:pointer;color:#6b7280;padding:0 5px;" data-toggle="dropdown" aria-expanded="false"><i class="fa fa-ellipsis-v"></i></button>
                                                    <ul class="dropdown-menu dropdown-menu-right" style="min-width: 120px;">
                                                        <li><a href="javascript:void(0)" onclick="editComment(${c.ID}, ${post.ID}, this)" data-body="${fn:escapeXml(c.body)}"><i class="fa fa-pencil" style="margin-right: 8px;"></i> Chỉnh sửa</a></li>
                                                        <li><a href="javascript:void(0)" onclick="deleteComment(${c.ID}, ${post.ID})"><i class="fa fa-trash" style="margin-right: 8px; color: #dc3545;"></i> <span style="color: #dc3545;">Xóa</span></a></li>
                                                    </ul>
                                                </div>
                                            </c:if>
                                        </div>
                                        <p class="mb-comment-text">${c.body}</p>
                                        <div style="margin-top: 8px;">
                                            <button type="button" style="background: none; border: none; color: #206bc4; font-size: 13px; font-weight: 500; cursor: pointer; padding: 0;" onclick="document.getElementById('reply-form-${c.ID}').style.display = 'block'">Phản hồi</button>
                                        </div>
                                        
                                        <!-- Reply form hidden by default -->
                                        <div id="reply-form-${c.ID}" style="display: none; margin-top: 15px; padding: 15px; background: #f8fafc; border-radius: 6px; border: 1px solid #e2e8f0;">
                                            <h5 style="margin-top: 0; margin-bottom: 12px; font-size: 14px;">Trả lời bình luận của ${c.guestName}</h5>
                                            <form action="${ctx}/blog/comment" method="post">
                                                <input type="hidden" name="blogPostId" value="${post.ID}" />
                                                <input type="hidden" name="parentCommentId" value="${c.ID}" />
                                                <c:if test="${empty sessionUser}">
                                                    <div class="mb-comment-form-row" style="margin-bottom: 12px;">
                                                        <div class="mb-comment-form-group">
                                                            <input type="text" name="guestName" placeholder="Họ tên của bạn *" required maxlength="100" style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 4px;"/>
                                                        </div>
                                                        <div class="mb-comment-form-group">
                                                            <input type="email" name="guestEmail" placeholder="Email liên hệ *" required maxlength="100" style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 4px;"/>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <textarea name="body" rows="2" placeholder="Nhập câu trả lời..." required style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 4px; margin-bottom: 12px; resize: vertical;"></textarea>
                                                <div>
                                                    <button type="submit" class="mb-comment-submit-btn" style="padding: 6px 14px; font-size: 13px;">Gửi phản hồi</button>
                                                    <button type="button" style="background: none; border: none; color: #6b7280; font-size: 13px; margin-left: 10px; cursor: pointer;" onclick="document.getElementById('reply-form-${c.ID}').style.display = 'none'">Hủy</button>
                                                </div>
                                            </form>
                                        </div>

                                        <!-- Render Replies -->
                                        <c:if test="${not empty c.replies}">
                                            <ul style="list-style: none; padding-left: 0; margin-top: 20px;">
                                                <c:forEach items="${c.replies}" var="rc">
                                                    <li class="mb-comment-item" style="border-top: 1px solid #e2e8f0; padding-top: 15px; margin-top: 15px; background: transparent;">
                                                        <div class="mb-comment-avatar" style="width: 36px; height: 36px; line-height: 36px; font-size: 16px;">
                                                            <c:choose>
                                                                <c:when test="${not empty rc.accountID}">
                                                                    <c:set var="rcommentAcc" value="${commentAccDao.getAccountById(rc.accountID)}" />
                                                                    <c:choose>
                                                                        <c:when test="${not empty rcommentAcc.avatar}">
                                                                            <img src="${imgUrl.resolve(rcommentAcc.avatar, ctx)}" alt="" onerror="this.style.display='none'"/>
                                                                        </c:when>
                                                                        <c:otherwise>${fn:substring(rc.guestName, 0, 1)}</c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:otherwise>${fn:substring(rc.guestName, 0, 1)}</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="mb-comment-body">
                                                            <div class="mb-comment-header" style="display: flex; justify-content: space-between; align-items: flex-start;">
                                                                <div>
                                                                    <h5 class="mb-comment-author">${rc.guestName} <span style="font-weight:400; color:#6b7280; font-size:12px; margin-left:5px">đã trả lời</span></h5>
                                                                    <span class="mb-comment-date"><fmt:formatDate value="${rc.datePost}" pattern="dd/MM/yyyy HH:mm" /></span>
                                                                </div>
                                                                <c:if test="${not empty sessionUser and sessionUser.ID == rc.accountID}">
                                                                    <div class="dropdown" style="position: relative;">
                                                                        <button class="dropdown-toggle" style="background:none;border:none;cursor:pointer;color:#6b7280;padding:0 5px;" data-toggle="dropdown" aria-expanded="false"><i class="fa fa-ellipsis-v"></i></button>
                                                                        <ul class="dropdown-menu dropdown-menu-right" style="min-width: 120px;">
                                                                            <li><a href="javascript:void(0)" onclick="editComment(${rc.ID}, ${post.ID}, this)" data-body="${fn:escapeXml(rc.body)}"><i class="fa fa-pencil" style="margin-right: 8px;"></i> Chỉnh sửa</a></li>
                                                                            <li><a href="javascript:void(0)" onclick="deleteComment(${rc.ID}, ${post.ID})"><i class="fa fa-trash" style="margin-right: 8px; color: #dc3545;"></i> <span style="color: #dc3545;">Xóa</span></a></li>
                                                                        </ul>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            <p class="mb-comment-text">${rc.body}</p>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:if>
                                    </div>
                                </li>
                            </c:forEach>
                            <c:if test="${empty comments}">
                                <li style="color:#6b7280;font-size:14px;padding:12px 0">Chưa có bình luận nào cho bài viết này. Hãy là người đầu tiên để lại ý kiến!</li>
                            </c:if>
                        </ul>
                    </div>
                </article>
            </div>

            <!-- Cột phụ bên phải: Banner, Tìm kiếm nhanh hoặc liên kết nhanh -->
            <div class="col-md-3">
                <div class="aside">
                    <div class="aside-title"><h4>Tìm kiếm bài viết</h4></div>
                    <form method="get" action="${ctx}/blog" class="mb-blog-search" style="margin-bottom:30px">
                        <input type="text" name="q" placeholder="Nhập từ khóa..." style="padding:10px; border:1px solid #e4e7ed; border-radius:6px; flex:1"/>
                        <button type="submit" style="padding:10px 14px; background:var(--mb-primary, #DB4444); color:#fff; border:none; border-radius:6px"><i class="fa fa-search"></i></button>
                    </form>
                </div>

                <div class="aside">
                    <div class="aside-title"><h4>Bài viết liên quan</h4></div>
                    <div class="mb-blog-aside-related">
                        <c:forEach items="${relatedPosts}" var="rp">
                            <c:choose>
                                <c:when test="${not empty rp.coverImg}">
                                    <c:set var="rpCover" value="${imgUrl.resolve(fn:startsWith(rp.coverImg, 'http') ? rp.coverImg : '/uploads/blog/'.concat(rp.coverImg), ctx)}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="rpCover" value="${blogDefaultCover}"/>
                                </c:otherwise>
                            </c:choose>
                            <div class="product-widget" style="margin-bottom:16px">
                                <div class="product-img">
                                    <img src="${rpCover}" alt="${rp.title}" onerror="mbBlogImgOnError(this)"/>
                                </div>
                                <div class="product-body">
                                    <p class="product-category" style="margin:0; font-size:11px; text-transform:uppercase">${rp.categoryName}</p>
                                    <h3 class="product-name" style="font-size:13px; line-height:1.3; font-weight:700">
                                        <a href="${ctx}/blog/detail/${rp.slug}">${rp.title}</a>
                                    </h3>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty relatedPosts}">
                            <p style="color:#6b7280; font-size:13px">Không tìm thấy bài viết liên quan.</p>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Section bài viết liên quan hiển thị dạng Grid lớn ở dưới -->
        <c:if test="${not empty relatedPosts}">
            <div class="mb-blog-related">
                <h3 class="mb-blog-related__head">Xem các bài viết khác</h3>
                <div class="row" style="margin-top:20px">
                    <c:forEach items="${relatedPosts}" var="rp">
                        <c:choose>
                            <c:when test="${not empty rp.coverImg}">
                                <c:set var="rpCover" value="${imgUrl.resolve(fn:startsWith(rp.coverImg, 'http') ? rp.coverImg : '/uploads/blog/'.concat(rp.coverImg), ctx)}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="rpCover" value="${blogDefaultCover}"/>
                            </c:otherwise>
                        </c:choose>
                        <div class="col-md-4 col-sm-6">
                            <article class="mb-blog-card" style="box-shadow: 0 4px 16px rgba(0,0,0,0.05)">
                                <a href="${ctx}/blog/detail/${rp.slug}" class="mb-blog-card__img-wrap">
                                    <img src="${rpCover}" alt="${rp.title}" onerror="mbBlogImgOnError(this)" class="mb-blog-img"/>
                                </a>
                                <div class="mb-blog-card__body">
                                    <h3 class="mb-blog-card__title" style="font-size:15px">
                                        <a href="${ctx}/blog/detail/${rp.slug}">${rp.title}</a>
                                    </h3>
                                    <div class="mb-blog-card__meta">
                                        <c:if test="${not empty rp.publishedAt}">
                                            <fmt:formatDate value="${rp.publishedAt}" pattern="dd MMM, yyyy" />
                                        </c:if>
                                        <span class="mb-blog-card__read-time" style="margin-left:0">
                                            <c:choose>
                                                <c:when test="${not empty rp.readingMinutes and rp.readingMinutes > 0}">
                                                    ${rp.readingMinutes} phút đọc
                                                </c:when>
                                                <c:otherwise>5 phút đọc</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <p class="mb-blog-card__excerpt" style="font-size:13px">${rp.excerpt}</p>
                                    <a href="${ctx}/blog/detail/${rp.slug}" class="mb-blog-card__more">Đọc thêm →</a>
                                </div>
                            </article>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    var shareUrl = encodeURIComponent(window.location.href);
    var shareTitle = encodeURIComponent("${post.title}");

    // Setup social share links dynamically
    var fbBtn = document.getElementById("share-facebook");
    if (fbBtn) {
        fbBtn.href = "https://www.facebook.com/sharer/sharer.php?u=" + shareUrl;
    }
    
    var twBtn = document.getElementById("share-twitter");
    if (twBtn) {
        twBtn.href = "https://twitter.com/intent/tweet?url=" + shareUrl + "&text=" + shareTitle;
    }
    
    var tgBtn = document.getElementById("share-telegram");
    if (tgBtn) {
        tgBtn.href = "https://t.me/share/url?url=" + shareUrl + "&text=" + shareTitle;
    }

    // Copy URL Link Clipboard handling
    var copyBtn = document.getElementById("copy-link-btn");
    if (copyBtn) {
        copyBtn.addEventListener("click", function () {
            navigator.clipboard.writeText(window.location.href).then(function () {
                copyBtn.classList.add("success");
                var originalHtml = copyBtn.innerHTML;
                copyBtn.innerHTML = '<i class="fa fa-check"></i>';
                setTimeout(function () {
                    copyBtn.classList.remove("success");
                    copyBtn.innerHTML = originalHtml;
                }, 2000);
            }).catch(function (err) {
                console.error('Could not copy text: ', err);
            });
        });
    }
});
</script>

<script>
function deleteComment(commentId, postId) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: 'Xác nhận xóa?',
            text: "Bình luận sẽ bị xoá vĩnh viễn và không thể hoàn tác!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Xóa bình luận',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                submitCommentAction('delete', commentId, postId, '');
            }
        });
    } else {
        if (confirm("Bạn có chắc chắn muốn xóa bình luận này?")) {
            submitCommentAction('delete', commentId, postId, '');
        }
    }
}

function editComment(commentId, postId, el) {
    var oldBody = el.getAttribute('data-body');
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: 'Chỉnh sửa bình luận',
            input: 'textarea',
            inputValue: oldBody,
            inputAttributes: {
                'aria-label': 'Nhập nội dung mới'
            },
            showCancelButton: true,
            confirmButtonColor: '#DB4444',
            confirmButtonText: 'Lưu thay đổi',
            cancelButtonText: 'Hủy',
            inputValidator: (value) => {
                if (!value || value.trim().length === 0) {
                    return 'Nội dung không được để trống!'
                }
            }
        }).then((result) => {
            if (result.isConfirmed) {
                submitCommentAction('edit', commentId, postId, result.value);
            }
        });
    } else {
        var newBody = prompt("Chỉnh sửa bình luận:", oldBody);
        if (newBody !== null && newBody.trim().length > 0) {
            submitCommentAction('edit', commentId, postId, newBody);
        }
    }
}

function submitCommentAction(action, commentId, postId, body) {
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = '${ctx}/blog/comment';
    
    var inputAction = document.createElement('input');
    inputAction.type = 'hidden';
    inputAction.name = 'action';
    inputAction.value = action;
    form.appendChild(inputAction);
    
    var inputId = document.createElement('input');
    inputId.type = 'hidden';
    inputId.name = 'commentId';
    inputId.value = commentId;
    form.appendChild(inputId);
    
    var inputPost = document.createElement('input');
    inputPost.type = 'hidden';
    inputPost.name = 'blogPostId';
    inputPost.value = postId;
    form.appendChild(inputPost);
    
    if (action === 'edit') {
        var inputBody = document.createElement('input');
        inputBody.type = 'hidden';
        inputBody.name = 'body';
        inputBody.value = body;
        form.appendChild(inputBody);
    }
    
    document.body.appendChild(form);
    form.submit();
}
</script>

<%@include file="./components/footer.jsp" %>
