<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="isEdit" value="${not empty sizeOption}"/>
<c:set var="pageTitle" value="${isEdit ? 'Sửa Kích cỡ' : 'Thêm Kích cỡ'}" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <a href="${ctx}/admin/sizeoptions" class="btn btn-outline-secondary btn-sm mb-2">
                        ← Quay lại
                    </a>
                    <h2 class="page-title">${isEdit ? 'Sửa Kích cỡ' : 'Thêm Kích cỡ mới'}</h2>
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
                <form action="${ctx}/admin/sizeoptions/${isEdit ? 'edit/'.concat(sizeOption.ID) : 'add'}" method="post">
                    <div class="mb-3">
                        <label class="form-label required" for="code">Mã Kích cỡ</label>
                        <input type="text" class="form-control" id="code" name="code"
                               value="${isEdit ? sizeOption.code : (not empty inputCode ? inputCode : '')}"
                               placeholder="Nhập mã Kích cỡ" required maxlength="100"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label required" for="label">Tên Kích cỡ</label>
                        <input type="text" class="form-control" id="label" name="label"
                               value="${isEdit ? sizeOption.label : (not empty inputlabel ? inputlabel : '')}"
                               placeholder="Nhập tên Kích cỡ" required maxlength="200"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label required">Nhóm kích cỡ</label>
                        <select name="sizeGroupID" class="form-select" required>
                            <option value="">-- Chọn nhóm kích cỡ --</option>
                            <c:forEach items="${sizeGroups}" var="sg">
                                <option value="${sg.ID}" ${isEdit && sizeOption.sizeGroupID == sg.ID ? 'selected' : ''}>${sg.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label" for="sortOrder">Thứ tự hiển thị</label>
                        <input type="number" class="form-control" id="sortOrder" name="sortOrder"
                               value="${isEdit ? sizeOption.sortOrder : (not empty inputSortOrder ? inputSortOrder : 0)}"
                               placeholder="Nhập thứ tự" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label required">Trạng thái</label>
                        <select name="status" class="form-select" required>
                            <c:set var="currentStatus" value="${isEdit ? sizeOption.status : (not empty inputStatus ? inputStatus : 1)}"/>
                            <option value="1" ${currentStatus == 1 ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${currentStatus == 0 ? 'selected' : ''}>Ẩn</option>
                        </select>
                    </div>
                    <div class="form-footer">
                        <button type="submit" class="btn btn-primary">
                            ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                        </button>
                        <a href="${ctx}/admin/sizeoptions" class="btn btn-outline-secondary ms-2">Huỷ</a>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
