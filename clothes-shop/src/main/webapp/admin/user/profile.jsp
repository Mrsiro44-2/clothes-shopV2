<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="Hồ sơ cá nhân" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Hồ sơ cá nhân</h2>
                </div>
            </div>
        </div>

        <jsp:include page="../components/flash.jsp"/>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible" role="alert">
                <div>${error}</div>
                <a class="btn-close" data-bs-dismiss="alert" aria-label="close"></a>
            </div>
        </c:if>

        <div class="card">
            <div class="card-body">
                <form action="${ctx}/admin/profile" method="post" enctype="multipart/form-data">
                    <div class="row">
                        <div class="col-md-3 text-center mb-3">
                            <span class="avatar avatar-xl mb-3" style="background-image: url('${not empty account.avatar ? account.avatar : ''}'); width: 150px; height: 150px;">
                                <c:if test="${empty account.avatar}">
                                    ${fn:substring(account.fullname, 0, 1)}
                                </c:if>
                            </span>
                            <div class="mt-2">
                                <label class="form-label" for="avatarFile">Đổi ảnh đại diện</label>
                                <input type="file" class="form-control" id="avatarFile" name="avatarFile" accept="image/*"/>
                            </div>
                        </div>
                        <div class="col-md-9">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required" for="fullname">Họ tên</label>
                                    <input type="text" class="form-control" id="fullname" name="fullname"
                                           value="${account.fullname}" required maxlength="200"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label required" for="email">Email</label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="${account.email}" required maxlength="200"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Tên đăng nhập</label>
                                    <input type="text" class="form-control" value="${account.username}" readonly disabled/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label" for="phone">Số điện thoại</label>
                                    <input type="text" class="form-control" id="phone" name="phone"
                                           value="${account.phone}" maxlength="50"/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label" for="password">Mật khẩu mới (để trống nếu không đổi)</label>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="••••••" minlength="6"/>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Vai trò</label>
                                    <input type="text" class="form-control" value="${account.roleName == 'admin' ? 'Quản trị viên' : 'Nhân viên'}" readonly disabled/>
                                </div>
                            </div>
                            <div class="form-footer">
                                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
