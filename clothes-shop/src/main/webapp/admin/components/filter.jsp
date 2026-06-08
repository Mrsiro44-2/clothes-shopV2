<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card-header">
    <form action="" method="get" class="d-flex w-100 gap-2 align-items-center flex-wrap">
        <input type="text" name="q" value="${q}" class="form-control w-25" placeholder="Tìm kiếm...">
        
        <c:if test="${not empty filterCategories}">
            <select name="categoryID" class="form-select w-auto">
                <option value="">Tất cả danh mục</option>
                <c:forEach items="${filterCategories}" var="c">
                    <option value="${c.ID}" ${categoryID == c.ID ? 'selected' : ''}>${c.name}</option>
                </c:forEach>
            </select>
        </c:if>
        
        <c:if test="${not empty filterProducers}">
            <select name="producerID" class="form-select w-auto">
                <option value="">Tất cả Nhà SX</option>
                <c:forEach items="${filterProducers}" var="p">
                    <option value="${p.ID}" ${producerID == p.ID ? 'selected' : ''}>${p.name}</option>
                </c:forEach>
            </select>
        </c:if>
        
        <c:if test="${not empty filterBrands}">
            <select name="brandID" class="form-select w-auto">
                <option value="">Tất cả Thương hiệu</option>
                <c:forEach items="${filterBrands}" var="b">
                    <option value="${b.ID}" ${brandID == b.ID ? 'selected' : ''}>${b.name}</option>
                </c:forEach>
            </select>
        </c:if>

        <c:choose>
            <c:when test="${not empty isOrder}">
                <c:if test="${not empty customers}">
                    <select name="customerID" class="form-select w-auto" style="min-width: 200px;">
                        <option value="">Tất cả khách hàng</option>
                        <c:forEach items="${customers}" var="cus">
                            <option value="${cus.ID}" ${customerID == cus.ID ? 'selected' : ''}>${cus.fullname} (${cus.username})</option>
                        </c:forEach>
                    </select>
                </c:if>
                <select name="status" class="form-select w-auto">
                    <option value="">Tất cả trạng thái</option>
                    <option value="0" ${status == '0' ? 'selected' : ''}>Chờ xử lý</option>
                    <option value="1" ${status == '1' ? 'selected' : ''}>Đang giao</option>
                    <option value="3" ${status == '3' ? 'selected' : ''}>Hoàn thành</option>
                    <option value="2" ${status == '2' ? 'selected' : ''}>Đã huỷ</option>
                </select>
            </c:when>
            <c:otherwise>
                <select name="status" class="form-select w-auto">
                    <option value="">Tất cả trạng thái</option>
                    <option value="1" ${status == '1' ? 'selected' : ''}>Hoạt động / Thành công</option>
                    <option value="0" ${status == '0' ? 'selected' : ''}>Ẩn / Huỷ</option>
                </select>
            </c:otherwise>
        </c:choose>
        <select name="sort" class="form-select w-auto">
            <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
            <option value="oldest" ${sort == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
        </select>
        <select name="limit" class="form-select w-auto">
            <option value="10" ${limit == 10 ? 'selected' : ''}>10 dòng</option>
            <option value="20" ${limit == 20 ? 'selected' : ''}>20 dòng</option>
            <option value="50" ${limit == 50 ? 'selected' : ''}>50 dòng</option>
        </select>
        <button type="submit" class="btn btn-primary">Áp dụng</button>
        <a href="?" class="btn btn-light">Xoá</a>
    </form>
</div>
