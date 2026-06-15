<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="${pageTitle}" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">${pageTitle}</h2>
                </div>
                <div class="col-auto">
                    <a href="${ctx}/admin/accounts" class="btn btn-secondary">
                        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="5" y1="12" x2="19" y2="12"/>
                            <line x1="5" y1="12" x2="11" y2="18"/>
                            <line x1="5" y1="12" x2="11" y2="6"/>
                        </svg>
                        Trở về
                    </a>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="table-responsive">
                <table class="table table-vcenter card-table table-striped">
                    <thead>
                        <tr>
                            <th>Họ tên nhận</th>
                            <th>Số điện thoại</th>
                            <th>Địa chỉ chi tiết</th>
                            <th>Xã/Huyện/Tỉnh</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${addresses}" var="address">
                            <tr>
                                <td><strong>${address.fullName}</strong></td>
                                <td>${address.phone}</td>
                                <td>${address.detailAddress}</td>
                                <td>${address.address}</td>
                                <td>
                                    <fmt:formatDate value="${address.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <c:if test="${address.isDefault}">
                                        <span class="badge bg-green-lt">Mặc định</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty addresses}">
                            <tr><td colspan="6" class="text-center text-muted py-4">Khách hàng chưa có địa chỉ nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
