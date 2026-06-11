<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="isEdit" value="${not empty sizeGroup}"/>
<c:set var="pageTitle" value="${isEdit ? 'Sửa Nhóm kích cỡ' : 'Thêm Nhóm kích cỡ'}" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <a href="${ctx}/admin/sizegroups" class="btn btn-outline-secondary btn-sm mb-2">
                        ← Quay lại
                    </a>
                    <h2 class="page-title">${isEdit ? 'Sửa Nhóm kích cỡ' : 'Thêm Nhóm kích cỡ mới'}</h2>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible" role="alert">
                <div>${error}</div>
                <a class="btn-close" data-bs-dismiss="alert" aria-label="close"></a>
            </div>
        </c:if>

        <div class="card">
            <div class="card-body">
                <form action="${ctx}/admin/sizegroups/${isEdit ? 'edit/'.concat(sizeGroup.ID) : 'add'}" method="post">
                    <div class="mb-3">
                        <label class="form-label required" for="code">Mã Nhóm</label>
                        <input type="text" class="form-control" id="code" name="code"
                               value="${isEdit ? sizeGroup.code : (not empty inputCode ? inputCode : '')}"
                               placeholder="Nhập mã Nhóm" required maxlength="100"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label required" for="name">Tên Nhóm kích cỡ</label>
                        <input type="text" class="form-control" id="name" name="name"
                               value="${isEdit ? sizeGroup.name : (not empty inputName ? inputName : '')}"
                               placeholder="Nhập tên Nhóm kích cỡ" required maxlength="200"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="sortOrder">Thứ tự hiển thị</label>
                        <input type="number" class="form-control" id="sortOrder" name="sortOrder"
                               value="${isEdit ? sizeGroup.sortOrder : (not empty inputSortOrder ? inputSortOrder : 0)}"
                               placeholder="Nhập thứ tự" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label required">Trạng thái</label>
                        <select name="status" class="form-select" required>
                            <c:set var="currentStatus" value="${isEdit ? sizeGroup.status : (not empty inputStatus ? inputStatus : 1)}"/>
                            <option value="1" ${currentStatus == 1 ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${currentStatus == 0 ? 'selected' : ''}>Ẩn</option>
                        </select>
                    </div>
                    <div class="form-footer">
                        <button type="submit" class="btn btn-primary">
                            ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                        </button>
                        <a href="${ctx}/admin/sizegroups" class="btn btn-outline-secondary ms-2">Huỷ</a>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
