<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="pageTitle" value="Chi tiết Mã giảm giá" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">
        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <div class="page-pretitle">Voucher</div>
                    <h2 class="page-title">
                        Mã giảm giá #${voucher.id}
                    </h2>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <a href="${ctx}/admin/vouchers" class="btn btn-outline-secondary">
                        Quay lại
                    </a>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Thông tin Voucher</h3>
                    </div>
                    <div class="card-body">
                        <div class="datagrid">
                            <div class="datagrid-item">
                                <div class="datagrid-title">Tên chương trình</div>
                                <div class="datagrid-content">${voucher.name}</div>
                            </div>
                            <div class="datagrid-item">
                                <div class="datagrid-title">Mã Code</div>
                                <div class="datagrid-content">
                                    <c:set var="rawCode" value="${voucher.code}" />
                                    <c:set var="displayCode" value="${(rawCode.startsWith('PUB_') || rawCode.startsWith('PRI_')) ? rawCode.substring(4) : rawCode}" />
                                    <span class="badge bg-primary-lt">${displayCode}</span>
                                </div>
                            </div>
                            <div class="datagrid-item">
                                <div class="datagrid-title">Loại giảm giá</div>
                                <div class="datagrid-content">
                                    <c:choose>
                                        <c:when test="${voucher.discountType == 1}">Giảm %</c:when>
                                        <c:otherwise>Giảm số tiền cố định</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="datagrid-item">
                                <div class="datagrid-title">Mức giảm</div>
                                <div class="datagrid-content">
                                    <c:choose>
                                        <c:when test="${voucher.discountType == 1}">${voucher.value}% <c:if test="${not empty voucher.maxDiscount}">(Tối đa <fmt:formatNumber value="${voucher.maxDiscount}" pattern="#,###"/>đ)</c:if></c:when>
                                        <c:otherwise><fmt:formatNumber value="${voucher.value}" pattern="#,###"/>đ</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="datagrid-item">
                                <div class="datagrid-title">Đơn tối thiểu</div>
                                <div class="datagrid-content"><fmt:formatNumber value="${voucher.minOrderAmount}" pattern="#,###"/>đ</div>
                            </div>
                            <div class="datagrid-item">
                                <div class="datagrid-title">Đã dùng / Tổng</div>
                                <div class="datagrid-content">
                                    ${voucher.used} / ${empty voucher.usageLimit ? 'Vô hạn' : voucher.usageLimit}
                                </div>
                            </div>
                            <div class="datagrid-item">
                                <div class="datagrid-title">Thời gian</div>
                                <div class="datagrid-content">
                                    Từ <fmt:formatDate value="${voucher.start}" pattern="dd/MM/yyyy"/> 
                                    đến <fmt:formatDate value="${voucher.end}" pattern="dd/MM/yyyy"/>
                                </div>
                            </div>
                            <div class="datagrid-item">
                                <div class="datagrid-title">Trạng thái</div>
                                <div class="datagrid-content">
                                    <c:if test="${voucher.status == 1}"><span class="badge bg-success-lt">Hoạt động</span></c:if>
                                    <c:if test="${voucher.status == 0}"><span class="badge bg-danger-lt">Vô hiệu hóa</span></c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Danh sách đơn hàng áp dụng (${fn:length(bills)})</h3>
                    </div>
                    <div class="table-responsive">
                        <table class="table card-table table-vcenter text-nowrap datatable">
                            <thead>
                                <tr>
                                    <th>Mã Đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày đặt</th>
                                    <th>Tổng tiền</th>
                                    <th>Số tiền giảm</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${bills}" var="b">
                                    <tr>
                                        <td><a href="${ctx}/admin/orders/detail/${b.ID}">#${b.ID}</a></td>
                                        <td>
                                            ${b.customerName}<br>
                                            <small class="text-muted">${b.phone}</small>
                                        </td>
                                        <td><fmt:formatDate value="${b.dateOrder}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td><fmt:formatNumber value="${b.total}" pattern="#,###"/>đ</td>
                                        <td class="text-danger">-<fmt:formatNumber value="${b.discountAmount}" pattern="#,###"/>đ</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${b.status == 0}">
                                                    <span class="badge bg-secondary text-secondary-fg">Chờ xử lý</span>
                                                </c:when>
                                                <c:when test="${b.status == 4}">
                                                    <span class="badge bg-teal text-teal-fg">Đã thanh toán</span>
                                                </c:when>
                                                <c:when test="${b.status == 5}">
                                                    <span class="badge bg-purple text-purple-fg">Đã chuẩn bị hàng</span>
                                                </c:when>
                                                <c:when test="${b.status == 1}">
                                                    <span class="badge bg-blue text-blue-fg">Đang giao</span>
                                                </c:when>
                                                <c:when test="${b.status == 3}">
                                                    <span class="badge bg-green text-green-fg">Hoàn thành</span>
                                                </c:when>
                                                <c:when test="${b.status == 2}">
                                                    <span class="badge bg-red text-red-fg">Đã huỷ</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty bills}">
                                    <tr><td colspan="6" class="text-center text-muted py-4">Chưa có đơn hàng nào áp dụng mã này.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="../components/footer.jsp"%>
