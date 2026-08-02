<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="Quản lý mã giảm giá" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Quản lý mã giảm giá</h2>
                </div>
                <div class="col-auto">
                    <a href="${ctx}/admin/vouchers/add" class="btn btn-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24"
                             stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path stroke="none" d="M0 0h24v24H0z" fill="none"/><line x1="12" y1="5" x2="12" y2="19"/>
                            <line x1="5" y1="12" x2="19" y2="12"/>
                        </svg>
                        Thêm mã giảm giá
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
                            <th>Mã</th>
                            <th>Tên chương trình</th>
                            <th>Mức giảm</th>
                            <th>Điều kiện</th>
                            <th>Đã dùng</th>
                            <th>Thời gian áp dụng</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${vouchers}" var="v" varStatus="loop">
                            <tr>
                                <td>
                                    <c:set var="rawCode" value="${v.code}" />
                                    <c:set var="displayCode" value="${(rawCode.startsWith('PUB_') || rawCode.startsWith('PRI_')) ? rawCode.substring(4) : rawCode}" />
                                    <span class="badge bg-primary-lt">${displayCode}</span>
                                    <c:if test="${rawCode.startsWith('PUB_')}">
                                        <span class="badge bg-info-lt ms-1" style="font-size:10px; border:1px solid #17a2b8; color:#17a2b8; background:transparent">Công khai</span>
                                    </c:if>
                                    <c:if test="${rawCode.startsWith('PRI_')}">
                                        <span class="badge bg-secondary-lt ms-1" style="font-size:10px; border:1px solid #6c757d; color:#6c757d; background:transparent">Riêng tư</span>
                                    </c:if>
                                </td>
                                <td><strong>${v.name}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.discountType == 1}">
                                            ${v.value}%
                                            <c:if test="${not empty v.maxDiscount}">
                                                <br><small class="text-muted">(Tối đa <fmt:formatNumber value="${v.maxDiscount}" type="currency" currencySymbol="₫"/>)</small>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${v.value}" type="currency" currencySymbol="₫"/>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>Từ <fmt:formatNumber value="${v.minOrderAmount}" type="currency" currencySymbol="₫"/></td>
                                <td>
                                    ${v.used} <c:if test="${not empty v.usageLimit}">/ ${v.usageLimit}</c:if>
                                </td>
                                <td>
                                    <small>
                                        <fmt:formatDate value="${v.start}" pattern="dd/MM/yyyy"/> - 
                                        <fmt:formatDate value="${v.end}" pattern="dd/MM/yyyy"/>
                                    </small>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.status == 1}">
                                            <jsp:useBean id="now" class="java.util.Date"/>
                                            <fmt:formatDate value="${v.end}" pattern="yyyyMMdd" var="endFmt"/>
                                            <fmt:formatDate value="${now}" pattern="yyyyMMdd" var="nowFmt"/>
                                            <c:choose>
                                                <c:when test="${endFmt < nowFmt}"><span class="badge bg-red-lt">Hết hạn</span></c:when>
                                                <c:when test="${not empty v.usageLimit && v.used >= v.usageLimit}"><span class="badge bg-orange-lt">Hết lượt</span></c:when>
                                                <c:otherwise><span class="badge bg-success-lt">Hoạt động</span></c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary-lt">Đã tắt</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${ctx}/admin/vouchers/detail/${v.id}" class="btn btn-sm btn-outline-info me-1">Chi tiết</a>
                                    <a href="${ctx}/admin/vouchers/edit/${v.id}" class="btn btn-sm btn-outline-primary me-1">Sửa</a>
                                    <a href="${ctx}/admin/vouchers/delete/${v.id}" class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn chắc chắn muốn xoá mã này?')">Xoá</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty vouchers}">
                            <tr><td colspan="8" class="text-center text-muted py-4">Chưa có mã giảm giá nào.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <jsp:include page="../components/pagination.jsp"/>
        </div>

    </div>
</div>

<%@include file="../components/footer.jsp"%>
