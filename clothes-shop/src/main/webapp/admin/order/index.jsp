<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="Quản lý đơn hàng" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Quản lý đơn hàng</h2>
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
                            <th>Mã ĐH</th>
                            <th>Khách hàng</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
                            <th>Thanh toán</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${orders}" var="o" varStatus="loop">
                            <tr>
                                <td><strong>#${o.ID}</strong></td>
                                <td>
                                    <div class="font-weight-medium">${o.customerName}</div>
                                    <div class="text-muted"><small>${o.phone}</small></div>
                                </td>
                                <td><fmt:formatDate value="${o.dateOrder}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><fmt:formatNumber value="${o.total}" type="currency" currencySymbol="₫"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${o.payment == 1}">
                                            <span class="badge bg-blue-lt">PayOS</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-orange-lt">COD</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${o.status == 0}">
                                            <span class="badge bg-yellow text-yellow-fg">Chờ xử lý</span>
                                        </c:when>
                                        <c:when test="${o.status == 4}">
                                            <span class="badge bg-teal text-teal-fg">Đã thanh toán</span>
                                        </c:when>
                                        <c:when test="${o.status == 8}">
                                            <span class="badge bg-cyan text-cyan-fg">Đã duyệt</span>
                                        </c:when>
                                        <c:when test="${o.status == 5}">
                                            <span class="badge bg-purple text-purple-fg">Đã chuẩn bị hàng</span>
                                        </c:when>
                                        <c:when test="${o.status == 6}">
                                            <span class="badge bg-indigo text-indigo-fg">Đã giao ĐVVC</span>
                                        </c:when>
                                        <c:when test="${o.status == 1}">
                                            <span class="badge bg-blue text-blue-fg">Đang giao</span>
                                        </c:when>
                                        <c:when test="${o.status == 3}">
                                            <span class="badge bg-green text-green-fg">Hoàn thành</span>
                                        </c:when>
                                        <c:when test="${o.status == 2}">
                                            <span class="badge bg-red text-red-fg">Đã huỷ</span>
                                            <c:if test="${not empty o.cancelReason}">
                                                <div class="small text-muted mt-1" style="max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${o.cancelReason}">Lý do: ${o.cancelReason}</div>
                                            </c:if>
                                        </c:when>
                                        <c:when test="${o.status == 7}">
                                            <span class="badge bg-pink text-pink-fg">Đã hoàn tiền</span>
                                            <c:if test="${not empty o.cancelReason}">
                                                <div class="small text-muted mt-1" style="max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${o.cancelReason}">Lý do: ${o.cancelReason}</div>
                                            </c:if>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/orders/detail/${o.ID}" class="btn btn-sm btn-outline-primary">Chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty orders}">
                            <tr><td colspan="7" class="text-center text-muted py-4">Chưa có đơn hàng nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <jsp:include page="../components/pagination.jsp"/>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
