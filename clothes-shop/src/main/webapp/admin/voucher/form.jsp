<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="isEdit" value="${not empty voucher}"/>
<c:set var="pageTitle" value="${isEdit ? 'Sửa mã giảm giá' : 'Thêm mã giảm giá'}" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <a href="${ctx}/admin/vouchers" class="btn btn-outline-secondary btn-sm mb-2">
                        ← Quay lại
                    </a>
                    <h2 class="page-title">${isEdit ? 'Sửa mã giảm giá' : 'Thêm mã giảm giá mới'}</h2>
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
                <form action="${ctx}/admin/vouchers/${isEdit ? 'edit/'.concat(voucher.id) : 'add'}" method="post">
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label required" for="name">Tên chương trình</label>
                            <input type="text" class="form-control" id="name" name="name"
                                   value="${isEdit ? voucher.name : (not empty param.name ? param.name : '')}"
                                   placeholder="Ví dụ: Lễ hội mua sắm..." required maxlength="255"/>
                        </div>
                        <div class="col-md-4 mb-3">
                            <c:set var="rawCode" value="${isEdit ? voucher.code : (not empty param.code ? param.code : '')}" />
                            <c:set var="displayCode" value="${(rawCode.startsWith('PUB_') || rawCode.startsWith('PRI_')) ? rawCode.substring(4) : rawCode}" />
                            <label class="form-label required" for="code">Mã voucher</label>
                            <input type="text" class="form-control" id="code" name="code"
                                   value="${displayCode}"
                                   placeholder="SUMMER20" required maxlength="50" style="text-transform: uppercase;"/>
                        </div>
                        <div class="col-md-4 mb-3">
                            <c:set var="accessType" value="${rawCode.startsWith('PRI_') ? 'PRI_' : 'PUB_'}" />
                            <label class="form-label required">Quyền truy cập</label>
                            <select name="accessType" class="form-select" required>
                                <option value="PUB_" ${accessType == 'PUB_' ? 'selected' : ''}>Công khai (Thu thập được)</option>
                                <option value="PRI_" ${accessType == 'PRI_' ? 'selected' : ''}>Riêng tư (Ẩn)</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label required">Loại giảm giá</label>
                            <select name="discountType" class="form-select" required>
                                <c:set var="cType" value="${isEdit ? voucher.discountType : (not empty param.discountType ? param.discountType : 0)}"/>
                                <option value="0" ${cType == 0 ? 'selected' : ''}>Giảm cố định (VNĐ)</option>
                                <option value="1" ${cType == 1 ? 'selected' : ''}>Giảm theo %</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label required" for="value">Mức giảm</label>
                            <input type="number" class="form-control" id="value" name="value" min="1" step="any"
                                   value="${isEdit ? voucher.value : (not empty param.value ? param.value : '')}"
                                   required/>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label" for="maxDiscount">Giảm tối đa (VNĐ)</label>
                            <input type="number" class="form-control" id="maxDiscount" name="maxDiscount" min="0" step="any"
                                   value="${isEdit ? voucher.maxDiscount : (not empty param.maxDiscount ? param.maxDiscount : '')}"
                                   placeholder="Bỏ trống nếu không giới hạn"/>
                            <small class="form-hint">Chỉ áp dụng khi giảm theo %.</small>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label required" for="minOrderAmount">Đơn hàng tối thiểu (VNĐ)</label>
                            <input type="number" class="form-control" id="minOrderAmount" name="minOrderAmount" min="0" step="any"
                                   value="${isEdit ? voucher.minOrderAmount : (not empty param.minOrderAmount ? param.minOrderAmount : '0')}"
                                   required/>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="usageLimit">Giới hạn số lần dùng</label>
                            <input type="number" class="form-control" id="usageLimit" name="usageLimit" min="1"
                                   value="${isEdit ? voucher.usageLimit : (not empty param.usageLimit ? param.usageLimit : '')}"
                                   placeholder="Bỏ trống nếu không giới hạn"/>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label required" for="start">Ngày bắt đầu</label>
                            <input type="date" class="form-control" id="start" name="start"
                                   value="${isEdit ? voucher.start : (not empty param.start ? param.start : '')}" required/>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label required" for="end">Ngày kết thúc</label>
                            <input type="date" class="form-control" id="end" name="end"
                                   value="${isEdit ? voucher.end : (not empty param.end ? param.end : '')}" required/>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label required">Trạng thái</label>
                            <select name="status" class="form-select" required>
                                <c:set var="cStatus" value="${isEdit ? voucher.status : (not empty param.status ? param.status : 1)}"/>
                                <option value="1" ${cStatus == 1 ? 'selected' : ''}>Hoạt động</option>
                                <option value="0" ${cStatus == 0 ? 'selected' : ''}>Đã tắt</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-footer">
                        <button type="submit" class="btn btn-primary">
                            ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                        </button>
                        <a href="${ctx}/admin/vouchers" class="btn btn-outline-secondary ms-2">Huỷ</a>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
