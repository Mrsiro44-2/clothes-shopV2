<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${empty ctx}"><c:set var="ctx" value="${pageContext.request.contextPath}"/></c:if>

<%@include file="./components/header.jsp" %>

<!-- BREADCRUMB -->
<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${ctx}/home">Trang chủ</a></li>
            <li class="active">Chính sách đổi trả</li>
        </ul>
    </div>
</div>
<!-- /BREADCRUMB -->

<!-- SECTION -->
<div class="section" style="padding-bottom:64px">
    <div class="container">
        <h2 class="title">Chính sách Đổi trả & Giao hàng</h2>
        <div style="margin-top:20px;line-height:1.8;max-width:800px; color: #333;">
            <h4 style="margin-top: 30px; margin-bottom: 15px;">1. Quy định Đổi/Trả hàng</h4>
            <p>
                Tại <strong>Clothing shop</strong>, chúng tôi luôn mong muốn mang đến cho bạn những sản phẩm chất lượng nhất. Nếu bạn không hoàn toàn hài lòng với đơn hàng của mình, bạn có thể yêu cầu đổi hoặc trả hàng trong vòng <strong>30 ngày</strong> kể từ ngày nhận hàng.
            </p>
            <ul style="list-style-type: disc; margin-left: 20px; margin-bottom: 20px;">
                <li>Sản phẩm phải còn nguyên vẹn, chưa qua sử dụng, chưa qua giặt ủi và không có mùi lạ.</li>
                <li>Sản phẩm còn đầy đủ tem mác, hộp và phụ kiện đi kèm (nếu có).</li>
                <li>Các sản phẩm đồ lót, đồ bơi, hoặc sản phẩm nằm trong chương trình sale đặc biệt sẽ không được áp dụng chính sách đổi trả.</li>
            </ul>

            <h4 style="margin-top: 30px; margin-bottom: 15px;">2. Quy trình thực hiện</h4>
            <ol style="list-style-type: decimal; margin-left: 20px; margin-bottom: 20px;">
                <li><strong>Liên hệ hỗ trợ:</strong> Quý khách vui lòng liên hệ với bộ phận CSKH qua email hoặc Hotline để cung cấp thông tin mã đơn hàng và lý do cần đổi/trả.</li>
                <li><strong>Đóng gói:</strong> Đóng gói sản phẩm cẩn thận, dán kèm hóa đơn mua hàng gốc.</li>
                <li><strong>Gửi hàng:</strong> Gửi bưu kiện về địa chỉ kho của chúng tôi theo hướng dẫn của nhân viên CSKH.</li>
                <li><strong>Hoàn tiền/Đổi sản phẩm:</strong> Sau khi nhận và kiểm tra tình trạng hàng hóa, chúng tôi sẽ tiến hành gửi lại sản phẩm mới hoặc hoàn tiền cho quý khách trong vòng 3-5 ngày làm việc.</li>
            </ol>

            <h4 style="margin-top: 30px; margin-bottom: 15px;">3. Chi phí vận chuyển</h4>
            <p>
                - Trong trường hợp sản phẩm bị lỗi do nhà sản xuất hoặc giao sai mẫu mã, <strong>Clothing shop</strong> sẽ chịu hoàn toàn phí vận chuyển hai chiều.<br>
                - Nếu quý khách muốn đổi trả do thay đổi ý định (đổi size, đổi màu, không ưng ý...), quý khách vui lòng tự thanh toán phí chuyển phát về cho chúng tôi.
            </p>

            <h4 style="margin-top: 30px; margin-bottom: 15px;">4. Hỗ trợ khách hàng</h4>
            <p>Nếu bạn có bất kỳ thắc mắc nào, đừng ngần ngại liên hệ:</p>
            <ul style="list-style-type: none; margin-bottom: 20px;">
                <li><i class="fa fa-phone" style="width: 20px;"></i> Hotline: <strong>1900 1234</strong></li>
                <li><i class="fa fa-envelope" style="width: 20px;"></i> Email: <strong>hotro@clothesshop.vn</strong></li>
            </ul>
        </div>
    </div>
</div>
<!-- /SECTION -->

<%@include file="./components/footer.jsp" %>
