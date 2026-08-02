<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="Quản lý tài khoản" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Quản lý tài khoản</h2>
                </div>
                <div class="col-auto">
                    <a href="${ctx}/admin/accounts/add" class="btn btn-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="12" y1="5" x2="12" y2="19"/>
                            <line x1="5" y1="12" x2="19" y2="12"/>
                        </svg>
                        Thêm tài khoản
                    </a>
                </div>
            </div>
        </div>

        <jsp:include page="../components/flash.jsp"/>

        <div class="card">
            <jsp:include page="../components/filter.jsp"/>
            <div class="table-responsive">
                <table class="table table-vcenter card-table table-striped">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Avatar</th>
                            <th>Họ tên</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${accounts}" var="acc" varStatus="loop">
                            <tr>
                                <td>${(currentPage - 1) * limit + loop.index + 1}</td>
                                <td>
                                    <span class="avatar avatar-sm"
                                          style="background-image: url('${not empty acc.avatar ? acc.avatar : ''}')">
                                        <c:if test="${empty acc.avatar}">
                                            ${fn:substring(acc.fullname, 0, 1)}
                                        </c:if>
                                    </span>
                                </td>
                                <td><strong>${acc.fullname}</strong></td>
                                <td>${acc.username}</td>
                                <td>${acc.email}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${acc.roleName == 'admin'}">
                                            <span class="badge bg-red-lt">Admin</span>
                                        </c:when>
                                        <c:when test="${acc.roleName == 'staff'}">
                                            <span class="badge bg-blue-lt">Staff</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-green-lt">User</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${acc.status == 1}">
                                            <span class="badge bg-success-lt">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-lt">Khoá</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${acc.date}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/accounts/edit/${acc.ID}" class="btn btn-sm btn-outline-primary me-1">Sửa</a>
                                    <c:if test="${acc.roleName == 'user'}">
                                        <a href="${ctx}/admin/accounts/addresses/${acc.ID}" class="btn btn-sm btn-outline-info me-1" title="Sổ địa chỉ">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-map-pin" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round" style="margin: 0; width: 16px; height: 16px;">
                                              <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                              <path d="M9 11a3 3 0 1 0 6 0a3 3 0 0 0 -6 0"></path>
                                              <path d="M17.657 16.657l-4.243 4.243a2 2 0 0 1 -2.827 0l-4.244 -4.243a8 8 0 1 1 11.314 0z"></path>
                                            </svg>
                                        </a>
                                    </c:if>
                                    <c:if test="${acc.ID != sessionScope.adminAccountId}">
                                        <a href="${ctx}/admin/accounts/toggle-lock/${acc.ID}" class="btn btn-sm ${acc.status == 1 ? 'btn-outline-warning' : 'btn-outline-success'} me-1"
                                           onclick="return confirm('Bạn chắc chắn muốn ${acc.status == 1 ? 'khoá' : 'mở khoá'} tài khoản này?')">
                                            ${acc.status == 1 ? 'Khoá' : 'Mở khoá'}
                                        </a>
                                        <a href="${ctx}/admin/accounts/delete/${acc.ID}" class="btn btn-sm btn-outline-danger"
                                           onclick="return confirm('Bạn chắc chắn muốn xoá tài khoản này?')">Xoá</a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty accounts}">
                            <tr><td colspan="9" class="text-center text-muted py-4">Chưa có tài khoản nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <jsp:include page="../components/pagination.jsp"/>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
