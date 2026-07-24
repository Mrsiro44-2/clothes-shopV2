<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<link type="text/css" rel="stylesheet" href="./user/css/checkout-v2.css" />
<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li class="active">Liên hệ</li>
        </ul>
    </div>
</div>
<div class="section" style="padding-bottom:64px">
    <div class="container">
        <h2 class="title">Liên hệ</h2>
        <div class="row" style="margin-top:24px">
            <div class="col-md-6">
                <p><strong>Clothing shop</strong> — cửa hàng thời trang uy tín.</p>
                <ul class="list-unstyled" style="line-height:2;margin-top:20px">
                    <li><i class="fa fa-map-marker"></i> 123 Đường ABC, Quận 1, TP.HCM</li>
                    <li><i class="fa fa-phone"></i> 1900 1234</li>
                    <li><i class="fa fa-envelope-o"></i> hotro@momandbaby.vn</li>
                    <li><i class="fa fa-clock-o"></i> 8:00 – 21:00 (T2–CN)</li>
                </ul>
            </div>
            <div class="col-md-6">
                <form class="mb-checkout-form" action="${ctx}/contact" method="POST">
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">${message}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <div class="mb-field">
                        <label>Họ tên</label>
                        <input class="input" type="text" name="name" placeholder="Nhập họ tên" required/>
                    </div>
                    <div class="mb-field">
                        <label>Email</label>
                        <input class="input" type="email" name="email" placeholder="email@example.com" required/>
                    </div>
                    <div class="mb-field">
                        <label>Nội dung</label>
                        <textarea class="input" name="content" rows="4" placeholder="Tin nhắn của bạn..." required></textarea>
                    </div>
                    <button type="submit" class="mb-checkout-submit">Gửi tin nhắn</button>
                </form>
            </div>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
