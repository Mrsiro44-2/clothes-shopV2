<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="isEdit" value="${not empty color}"/>
<c:set var="pageTitle" value="${isEdit ? 'Sửa Màu sắc' : 'Thêm Màu sắc'}" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <a href="${ctx}/admin/colors" class="btn btn-outline-secondary btn-sm mb-2">
                        ← Quay lại
                    </a>
                    <h2 class="page-title">${isEdit ? 'Sửa Màu sắc' : 'Thêm Màu sắc mới'}</h2>
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
                <form action="${ctx}/admin/colors/${isEdit ? 'edit/'.concat(color.ID) : 'add'}" method="post">
                    <div class="mb-3">
                        <label class="form-label required" for="name">Tên Màu sắc</label>
                        <input type="text" class="form-control" id="name" name="name"
                               value="${isEdit ? color.name : (not empty inputName ? inputName : '')}"
                               placeholder="Nhập tên Màu sắc" required maxlength="200"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label required" for="hexCode">Mã Hex (Màu sắc)</label>
                        <div class="d-flex align-items-center gap-2">
                            <input type="color" class="form-control form-control-color" id="colorPicker" 
                                   value="${isEdit && not empty color.hexCode ? color.hexCode : '#000000'}" title="Chọn màu" style="width: 50px; height: 38px; padding: 0.2rem;">
                            <input type="text" class="form-control" id="hexCode" name="hexCode"
                                   value="${isEdit && not empty color.hexCode ? color.hexCode : '#000000'}"
                                   placeholder="#000000" required maxlength="7" pattern="^#+([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$" style="width: 150px;"/>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label required">Trạng thái</label>
                        <select name="status" class="form-select" required>
                            <c:set var="currentStatus" value="${isEdit ? color.status : (not empty inputStatus ? inputStatus : 1)}"/>
                            <option value="1" ${currentStatus == 1 ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${currentStatus == 0 ? 'selected' : ''}>Ẩn</option>
                        </select>
                    </div>
                    <div class="form-footer">
                        <button type="submit" class="btn btn-primary">
                            ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                        </button>
                        <a href="${ctx}/admin/colors" class="btn btn-outline-secondary ms-2">Huỷ</a>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const colorPicker = document.getElementById('colorPicker');
        const hexCode = document.getElementById('hexCode');

        if(colorPicker && hexCode) {
            colorPicker.addEventListener('input', function() {
                hexCode.value = this.value.toUpperCase();
            });

            hexCode.addEventListener('input', function() {
                let val = this.value;
                if (val && val.match(/^#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/)) {
                    // Convert 3-char hex to 6-char hex for color picker if needed, but color picker supports 6-char
                    if(val.length === 4) {
                        val = '#' + val[1]+val[1] + val[2]+val[2] + val[3]+val[3];
                    }
                    colorPicker.value = val;
                }
            });
        }
    });
</script>

<%@include file="../components/footer.jsp"%>
