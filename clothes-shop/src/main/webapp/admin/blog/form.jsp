<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="isEdit" value="${not empty post}"/>
<c:set var="formAction" value="${pageContext.request.contextPath}/admin/blogs/${isEdit ? 'edit/'.concat(post.ID) : 'add'}"/>

<c:set var="pageTitle" value="${pageTitle}" scope="request"/>
<jsp:include page="/admin/components/header.jsp" />

<!-- Add TinyMCE -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/tinymce/6.8.3/tinymce.min.js" referrerpolicy="origin"></script>

<div class="page-header d-print-none">
    <div class="container-xl">
        <div class="row g-2 align-items-center">
            <div class="col">
                <h2 class="page-title">
                    ${pageTitle}
                </h2>
            </div>
            <div class="col-auto ms-auto d-print-none">
                <div class="btn-list">
                    <a href="${pageContext.request.contextPath}/admin/blogs" class="btn btn-secondary">Hủy</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="page-body">
    <div class="container-xl">
        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                <h4 class="alert-title">Lỗi</h4>
                <div class="text-secondary">${error}</div>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <form action="${formAction}" method="POST" enctype="multipart/form-data">
            <div class="row row-cards">
                <div class="col-md-8">
                    <div class="card mb-3">
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label required">Tiêu đề bài viết</label>
                                <input type="text" class="form-control" name="title" id="title" placeholder="Nhập tiêu đề..." required
                                       value="<c:out value='${isEdit ? post.title : inputTitle}'/>">
                            </div>
                            <div class="mb-3">
                                <label class="form-label required">Đường dẫn (Slug)</label>
                                <input type="text" class="form-control" name="slug" id="slug" placeholder="duong-dan-bai-viet" required
                                       value="<c:out value='${isEdit ? post.slug : inputSlug}'/>">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Tóm tắt</label>
                                <textarea class="form-control" name="excerpt" rows="3" placeholder="Đoạn mô tả ngắn về bài viết..."><c:out value='${isEdit ? post.excerpt : inputExcerpt}'/></textarea>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card mb-3">
                        <div class="card-body">
                            <h3 class="card-title">Nội dung bài viết</h3>
                            <textarea id="tinymce-editor" name="contentHtml"><c:out value='${isEdit ? post.contentHtml : inputContentHtml}' escapeXml="false"/></textarea>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card mb-3">
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">Danh mục Blog</label>
                                <select name="blogCategoryID" class="form-select">
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:set var="selectedCat" value="${isEdit ? post.blogCategoryID : inputBlogCategoryID}"/>
                                    <c:forEach items="${categories}" var="c">
                                        <option value="${c.ID}" ${selectedCat == c.ID ? 'selected' : ''}>${c.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Ảnh Cover</label>
                                <input type="file" class="form-control" name="coverImg" accept="image/*">
                                <c:if test="${isEdit && not empty post.coverImg}">
                                    <div class="mt-2">
                                        <img src="${pageContext.request.contextPath}/uploads/blog/${post.coverImg}" style="max-width: 100%; border-radius: 4px;">
                                    </div>
                                </c:if>
                            </div>
                            <div class="mb-3">
                                <label class="form-check">
                                    <c:set var="isFeat" value="${isEdit ? post.featured : (inputIsFeatured == 1)}"/>
                                    <input type="checkbox" class="form-check-input" name="isFeatured" value="1" ${isFeat ? 'checked' : ''}>
                                    <span class="form-check-label">Đánh dấu bài viết nổi bật</span>
                                </label>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-select">
                                    <c:set var="statusVal" value="${isEdit ? post.status : (not empty inputStatus ? inputStatus : 0)}"/>
                                    <option value="1" ${statusVal == 1 ? 'selected' : ''}>Xuất bản ngay</option>
                                    <option value="0" ${statusVal == 0 ? 'selected' : ''}>Lưu nháp</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Thẻ bài viết (Tags)</label>
                                <input name="tags" class="form-control" placeholder="Nhập thẻ và nhấn Enter" 
                                       value="<c:forEach items='${post.tags}' var='t'>${t.name},</c:forEach>">
                                <small class="form-hint">Nhập các từ khóa phân cách bằng dấu phẩy hoặc nhấn Enter.</small>
                            </div>
                            <div class="mt-4">
                                <button type="submit" class="btn btn-primary w-100">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M6 4h10l4 4v10a2 2 0 0 1 -2 2h-12a2 2 0 0 1 -2 -2v-12a2 2 0 0 1 2 -2" /><path d="M12 14m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M14 4l0 4l-6 0l0 -4" /></svg>
                                    Lưu lại
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/@yaireo/tagify"></script>
<link href="https://cdn.jsdelivr.net/npm/@yaireo/tagify/dist/tagify.css" rel="stylesheet" type="text/css" />

<script>
    // Initialize Tagify
    var tagsInput = document.querySelector('input[name=tags]');
    var whitelist = ${not empty availableTags ? availableTags : '[]'};
    new Tagify(tagsInput, {
        whitelist: whitelist,
        enforceWhitelist: false,
        dropdown: {
            maxItems: 20,
            classname: "tags-look",
            enabled: 0,
            closeOnSelect: false
        },
        originalInputValueFormat: valuesArr => valuesArr.map(item => item.value).join(','),
        transformTag: tagData => {
            if (typeof tagData.value === 'string' && !tagData.value.startsWith('#')) {
                tagData.value = '#' + tagData.value;
            }
        }
    });

    // Initialize TinyMCE
    tinymce.init({
        selector: '#tinymce-editor',
        height: 500,
        menubar: false,
        plugins: [
            'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
            'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
            'insertdatetime', 'media', 'table', 'help', 'wordcount'
        ],
        toolbar: 'undo redo | blocks | ' +
        'bold italic backcolor | alignleft aligncenter ' +
        'alignright alignjustify | bullist numlist outdent indent | ' +
        'removeformat | help',
        content_style: 'body { font-family: -apple-system, BlinkMacSystemFont, San Francisco, Segoe UI, Roboto, Helvetica Neue, sans-serif; font-size: 14px; }'
    });

    // Auto generate slug from title
    document.getElementById('title').addEventListener('keyup', function() {
        var title = this.value;
        var slug = title.toLowerCase();
        slug = slug.replace(/á|à|ả|ạ|ã|ă|ắ|ằ|ẳ|ẵ|ặ|â|ấ|ầ|ẩ|ẫ|ậ/gi, 'a');
        slug = slug.replace(/é|è|ẻ|ẽ|ẹ|ê|ế|ề|ể|ễ|ệ/gi, 'e');
        slug = slug.replace(/i|í|ì|ỉ|ĩ|ị/gi, 'i');
        slug = slug.replace(/ó|ò|ỏ|õ|ọ|ô|ố|ồ|ổ|ỗ|ộ|ơ|ớ|ờ|ở|ỡ|ợ/gi, 'o');
        slug = slug.replace(/ú|ù|ủ|ũ|ụ|ư|ứ|ừ|ử|ữ|ự/gi, 'u');
        slug = slug.replace(/ý|ỳ|ỷ|ỹ|ỵ/gi, 'y');
        slug = slug.replace(/đ/gi, 'd');
        slug = slug.replace(/\`|\~|\!|\@|\#|\||\$|\%|\^|\&|\*|\(|\)|\+|\=|\,|\.|\/|\?|\>|\<|\'|\"|\:|\;|_/gi, '');
        slug = slug.replace(/ /gi, "-");
        slug = slug.replace(/\-\-\-\-\-/gi, '-');
        slug = slug.replace(/\-\-\-\-/gi, '-');
        slug = slug.replace(/\-\-\-/gi, '-');
        slug = slug.replace(/\-\-/gi, '-');
        slug = '@' + slug + '@';
        slug = slug.replace(/\@\-|\-\@|\@/gi, '');
        
        <c:if test="${not isEdit}">
        document.getElementById('slug').value = slug;
        </c:if>
    });
</script>

<style>
.tagify {
    --tags-border-color: #e6e8eb;
    --tags-hover-border-color: #206bc4;
    --tags-focus-border-color: #206bc4;
    border-radius: 4px;
}
</style>

<jsp:include page="/admin/components/footer.jsp" />
