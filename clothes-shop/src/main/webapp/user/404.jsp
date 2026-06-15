<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li class="active">Lỗi 404</li>
        </ul>
    </div>
</div>
<div class="section" style="padding-bottom:100px; padding-top:60px;">
    <div class="container">
        <div class="row">
            <div class="col-md-12 text-center">
                <h1 style="font-size: 100px; font-weight: 700; color: #D10024; margin-bottom: 20px;">404</h1>
                <h2 class="title" style="margin-bottom: 20px;">Rất tiếc! Không tìm thấy trang</h2>
                <p style="font-size: 16px; margin-bottom: 40px; color: #666;">
                    Trang bạn đang tìm kiếm có thể đã bị xóa, đổi tên hoặc tạm thời không thể truy cập.
                </p>
                <a href="${ctx}/home" class="primary-btn" style="display:inline-block">Quay lại trang chủ</a>
            </div>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
