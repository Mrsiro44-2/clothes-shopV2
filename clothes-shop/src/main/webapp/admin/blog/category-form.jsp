<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="isEdit" value="${not empty category}"/>
<c:set var="formAction" value="${pageContext.request.contextPath}/admin/blog-categories/${isEdit ? 'edit/'.concat(category.ID) : 'add'}"/>

<c:set var="pageTitle" value="${pageTitle}" scope="request"/>
<jsp:include page="/admin/components/header.jsp" />

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
                    <a href="${pageContext.request.contextPath}/admin/blog-categories" class="btn btn-secondary">Hủy</a>
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
                    <div class="card">
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label required">Tên danh mục</label>
                                <input type="text" class="form-control" name="name" id="name" placeholder="Ví dụ: Tin tức thời trang" required
                                       value="<c:out value='${isEdit ? category.name : inputName}'/>">
                            </div>
                            <div class="mb-3">
                                <label class="form-label required">Đường dẫn (Slug)</label>
                                <input type="text" class="form-control" name="slug" id="slug" placeholder="Ví dụ: tin-tuc-thoi-trang" required
                                       value="<c:out value='${isEdit ? category.slug : inputSlug}'/>">
                                <small class="form-hint">Đường dẫn URL sẽ hiển thị trên thanh địa chỉ.</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea class="form-control" name="description" rows="4"><c:out value='${isEdit ? category.description : inputDescription}'/></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card mb-3">
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">Ảnh Cover</label>
                                <input type="file" class="form-control" name="coverImg" accept="image/*">
                                <c:if test="${isEdit && not empty category.coverImg}">
                                    <div class="mt-2">
                                        <img src="${pageContext.request.contextPath}/uploads/blog/${category.coverImg}" style="max-width: 100%; border-radius: 4px;">
                                    </div>
                                </c:if>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Thứ tự hiển thị</label>
                                <input type="number" class="form-control" name="sortOrder" value="${isEdit ? category.sortOrder : (not empty inputSortOrder ? inputSortOrder : 0)}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-select">
                                    <c:set var="statusVal" value="${isEdit ? category.status : (not empty inputStatus ? inputStatus : 1)}"/>
                                    <option value="1" ${statusVal == 1 ? 'selected' : ''}>Hoạt động</option>
                                    <option value="0" ${statusVal == 0 ? 'selected' : ''}>Ẩn</option>
                                </select>
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

<script>
    // Auto generate slug from title
    document.getElementById('name').addEventListener('keyup', function() {
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
        
        // Only auto-fill if slug is empty or it's adding new
        <c:if test="${not isEdit}">
        document.getElementById('slug').value = slug;
        </c:if>
    });
</script>

<jsp:include page="/admin/components/footer.jsp" />
