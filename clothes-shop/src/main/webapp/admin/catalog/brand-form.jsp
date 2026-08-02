<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="isEdit" value="${not empty brand}"/>
<c:set var="pageTitle" value="${isEdit ? 'Sửa thương hiệu' : 'Thêm thương hiệu'}" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <a href="${ctx}/admin/brands" class="btn btn-outline-secondary btn-sm mb-2">
                        ← Quay lại
                    </a>
                    <h2 class="page-title">${isEdit ? 'Sửa thương hiệu' : 'Thêm thương hiệu mới'}</h2>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible" role="alert">
                <div>${error}</div>
                <a class="btn-close" data-bs-dismiss="alert" aria-label="close"></a>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <div class="card">
            <div class="card-body">
                <form action="${ctx}/admin/brands/${isEdit ? 'edit/'.concat(brand.ID) : 'add'}" method="post" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label required" for="name">Tên thương hiệu</label>
                        <input type="text" class="form-control" id="name" name="name" required
                               value="${isEdit ? brand.name : (not empty inputName ? inputName : '')}"
                               placeholder="Nhập tên thương hiệu..."/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="img">Ảnh Logo (Tải lên từ máy)</label>
                        <input type="file" class="form-control" id="img" name="img" accept="image/*" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="imgUrl">Hoặc nhập URL ảnh Logo</label>
                        <input type="text" class="form-control" id="imgUrl" name="imgUrl" 
                               value="${not empty inputImgUrl ? inputImgUrl : (isEdit && brand.img != null && brand.img.startsWith('http') ? brand.img : '')}" 
                               placeholder="https://example.com/logo.png" />
                        <small class="form-hint">Hệ thống sẽ ưu tiên ảnh tải lên từ máy tính nếu bạn nhập cả hai.
                            <c:if test="${isEdit && not empty brand.img}">
                                <br/>Đang có ảnh: 
                                <c:choose>
                                    <c:when test="${brand.img.startsWith('http')}">
                                        <a href="${brand.img}" target="_blank">Xem ảnh gốc</a>
                                    </c:when>
                                    <c:otherwise>
                                        <strong>${brand.img}</strong>
                                    </c:otherwise>
                                </c:choose>
                                . Nếu không chọn file mới hoặc nhập URL mới, ảnh cũ sẽ được giữ nguyên.
                            </c:if>
                        </small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label required">Trạng thái</label>
                        <select name="status" class="form-select" required>
                            <c:set var="currentStatus" value="${isEdit ? brand.status : (not empty inputStatus ? inputStatus : 1)}"/>
                            <option value="1" ${currentStatus == 1 ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${currentStatus == 0 ? 'selected' : ''}>Ẩn</option>
                        </select>
                    </div>
                    <div class="form-footer">
                        <button type="submit" class="btn btn-primary">
                            ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                        </button>
                        <a href="${ctx}/admin/brands" class="btn btn-outline-secondary ms-2">Huỷ</a>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
