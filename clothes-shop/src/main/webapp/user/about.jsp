<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li class="active">Giới thiệu</li>
        </ul>
    </div>
</div>
<div class="section" style="padding-bottom:64px">
    <div class="container">
        <h2 class="title">Giới thiệu Clothing shop</h2>
        <p style="margin-top:20px;line-height:1.8;max-width:800px">
            Clothing shop là điểm đến tin cậy cho các bà mẹ và bé yêu — quần áo, phụ kiện và sản phẩm chăm sóc
            được chọn lọc kỹ, giao hàng nhanh và hỗ trợ tận tâm.
        </p>
        <p style="line-height:1.8;max-width:800px">
            Chúng tôi cam kết chất lượng, giá minh bạch và trải nghiệm mua sắm thân thiện trên mọi thiết bị.
        </p>
        <a href="${ctx}/product" class="primary-btn" style="margin-top:24px;display:inline-block">Khám phá cửa hàng</a>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
