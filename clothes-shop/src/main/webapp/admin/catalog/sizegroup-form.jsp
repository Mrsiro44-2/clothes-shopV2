<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <c:set var="isEdit" value="${not empty sizeGroup}" />
        <c:set var="pageTitle" value="${isEdit ? 'Sửa Nhóm kích cỡ' : 'Thêm Nhóm kích cỡ'}" scope="request" />
        <%@include file="../components/header.jsp" %>

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
                        <c:remove var="error" scope="session" />
                    </c:if>

                    <div class="card">
                        <div class="card-body">
                            <form action="${ctx}/admin/sizegroups/${isEdit ? 'edit/'.concat(sizeGroup.ID) : 'add'}"
                                method="post">
                                <div class="mb-3">
                                    <label class="form-label required" for="code">Mã Nhóm</label>
                                    <input type="text" class="form-control" id="code" name="code"
                                        value="${isEdit ? sizeGroup.code : (not empty inputCode ? inputCode : '')}"
                                        placeholder="Nhập mã Nhóm" required maxlength="100" />
                                </div>
                                <div class="mb-3">
                                    <label class="form-label required" for="name">Tên Nhóm kích cỡ</label>
                                    <input type="text" class="form-control" id="name" name="name"
                                        value="${isEdit ? sizeGroup.name : (not empty inputName ? inputName : '')}"
                                        placeholder="Nhập tên Nhóm kích cỡ" required maxlength="200" />
                                </div>
                                <div class="mb-3" style="display: none">
                                    <label class="form-label" for="sortOrder">Thứ tự hiển thị</label>
                                    <input type="number" class="form-control" id="sortOrder" name="sortOrder"
                                        value="${isEdit ? sizeGroup.sortOrder : (not empty inputSortOrder ? inputSortOrder : 0)}"
                                        placeholder="Nhập thứ tự" />
                                </div>
                                <div class="mb-3">
                                    <label class="form-label required">Trạng thái</label>
                                    <select name="status" class="form-select" required>
                                        <c:set var="currentStatus"
                                            value="${isEdit ? sizeGroup.status : (not empty inputStatus ? inputStatus : 1)}" />
                                        <option value="1" ${currentStatus==1 ? 'selected' : '' }>Hoạt động</option>
                                        <option value="0" ${currentStatus==0 ? 'selected' : '' }>Ẩn</option>
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

                <c:if test="${isEdit}">
                    <div class="container-xl mt-4">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h3 class="card-title">Các kích cỡ thuộc nhóm này</h3>
                            </div>
                            <div class="card-body">
                                <!-- Add new size option form -->
                                <form action="${ctx}/admin/sizeoptions/add" method="post"
                                    class="row gx-3 gy-2 align-items-center mb-4">
                                    <input type="hidden" name="sizeGroupID" value="${sizeGroup.ID}" />
                                    <input type="hidden" name="status" value="1" />
                                    <input type="hidden" name="sortOrder" value="0" />
                                    <input type="hidden" name="redirectUrl"
                                        value="${ctx}/admin/sizegroups/edit/${sizeGroup.ID}" />

                                    <div class="col-sm-3">
                                        <input type="text" class="form-control" name="code"
                                            placeholder="Mã kích cỡ (VD: S)" required maxlength="50" />
                                    </div>
                                    <div class="col-sm-5">
                                        <input type="text" class="form-control" name="label"
                                            placeholder="Tên kích cỡ (VD: Size S)" required maxlength="100" />
                                    </div>
                                    <div class="col-sm-4">
                                        <button type="submit" class="btn btn-success w-100">Thêm kích cỡ mới</button>
                                    </div>
                                </form>

                                <div class="table-responsive">
                                    <table class="table table-vcenter card-table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Mã</th>
                                                <th>Tên hiển thị</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${sizeOptions}" var="sz">
                                                <tr>
                                                    <td>
                                                        <form action="${ctx}/admin/sizeoptions/edit/${sz.ID}"
                                                            method="post" class="d-flex gap-2">
                                                            <input type="hidden" name="sizeGroupID"
                                                                value="${sizeGroup.ID}" />
                                                            <input type="hidden" name="status" value="${sz.status}" />
                                                            <input type="hidden" name="sortOrder"
                                                                value="${sz.sortOrder}" />
                                                            <input type="hidden" name="redirectUrl"
                                                                value="${ctx}/admin/sizegroups/edit/${sizeGroup.ID}" />
                                                            <input type="text" class="form-control form-control-sm"
                                                                name="code" value="${sz.code}" required
                                                                style="max-width: 100px;" />
                                                            <input type="text" class="form-control form-control-sm"
                                                                name="label" value="${sz.label}" required />
                                                            <button type="submit"
                                                                class="btn btn-sm btn-outline-primary">Lưu</button>
                                                        </form>
                                                    </td>
                                                    <td></td> <!-- merged above -->
                                                    <td>
                                                        <form action="${ctx}/admin/sizeoptions/delete/${sz.ID}"
                                                            method="get" class="d-inline"
                                                            onsubmit="return confirm('Bạn chắc chắn muốn xoá kích cỡ này?');">
                                                            <input type="hidden" name="redirectUrl"
                                                                value="${ctx}/admin/sizegroups/edit/${sizeGroup.ID}" />
                                                            <button type="submit"
                                                                class="btn btn-sm btn-outline-danger">Xoá</button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty sizeOptions}">
                                                <tr>
                                                    <td colspan="3" class="text-center text-muted py-3">Chưa có kích cỡ
                                                        nào.</td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>

            <%@include file="../components/footer.jsp" %>