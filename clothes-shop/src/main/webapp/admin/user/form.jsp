<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="isEdit" value="${not empty account}"/>
<c:set var="pageTitle" value="${isEdit ? 'Sửa tài khoản' : 'Thêm tài khoản'}" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <a href="${ctx}/admin/accounts" class="btn btn-outline-secondary btn-sm mb-2">
                        ← Quay lại
                    </a>
                    <h2 class="page-title">${isEdit ? 'Sửa tài khoản' : 'Thêm tài khoản mới'}</h2>
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
                <form action="${ctx}/admin/accounts/${isEdit ? 'edit/'.concat(account.ID) : 'add'}" method="post">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label required" for="fullname">Họ tên</label>
                            <input type="text" class="form-control" id="fullname" name="fullname"
                                   value="${isEdit ? account.fullname : (not empty inputFullname ? inputFullname : '')}"
                                   placeholder="Nguyễn Văn A" required maxlength="200"/>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label required" for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email"
                                   value="${isEdit ? account.email : (not empty inputEmail ? inputEmail : '')}"
                                   placeholder="example@email.com" required maxlength="200"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label required" for="username">Tên đăng nhập</label>
                            <input type="text" class="form-control" id="username" name="username"
                                   value="${isEdit ? account.username : (not empty inputUsername ? inputUsername : '')}"
                                   placeholder="username" required maxlength="100"/>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="phone">Số điện thoại</label>
                            <input type="text" class="form-control" id="phone" name="phone"
                                   value="${isEdit ? account.phone : (not empty inputPhone ? inputPhone : '')}"
                                   placeholder="0912 345 678" maxlength="50"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label ${isEdit ? '' : 'required'}" for="password">
                                Mật khẩu ${isEdit ? '(để trống nếu không đổi)' : ''}
                            </label>
                            <input type="password" class="form-control" id="password" name="password"
                                   placeholder="••••••" ${isEdit ? '' : 'required'} minlength="6"/>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label required">Vai trò</label>
                            <select name="role" class="form-select" required>
                                <c:set var="currentRole" value="${isEdit ? account.role : (not empty inputRole ? inputRole : 3)}"/>
                              <c:forEach items="${roles}" var="r">
    <option value="${r.ID}" ${currentRole == r.ID ? 'selected' : ''}>
        <c:choose>
            <c:when test="${r.name == 'user'}">
                Customer
            </c:when>
            <c:otherwise>
                ${r.name}
            </c:otherwise>
        </c:choose>
    </option>
</c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label required">Trạng thái</label>
                            <select name="status" class="form-select" required>
                                <c:set var="currentStatus" value="${isEdit ? account.status : (not empty inputStatus ? inputStatus : 1)}"/>
                                <option value="1" ${currentStatus == 1 ? 'selected' : ''}>Hoạt động</option>
                                <option value="0" ${currentStatus == 0 ? 'selected' : ''}>Khoá</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-footer">
                        <button type="submit" class="btn btn-primary">
                            ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                        </button>
                        <a href="${ctx}/admin/accounts" class="btn btn-outline-secondary ms-2">Huỷ</a>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
