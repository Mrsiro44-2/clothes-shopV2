<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${empty ctx}"><c:set var="ctx" value="${pageContext.request.contextPath}"/></c:if>

<footer id="footer">
    <div class="section">
        <div class="container">
            <div class="mb-footer-grid">
                <div class="footer mb-footer-brand">
                    <h2>Clothes Shop</h2>
                    <p>Thời trang hằng ngày được tuyển chọn gọn gàng, dễ phối và phù hợp nhiều nhịp sống.</p>
                    <form class="mb-footer-newsletter">
                        <input type="email" placeholder="Email của bạn" aria-label="Email nhận tin"/>
                        <button type="submit" aria-label="Đăng ký nhận tin"><i class="fa fa-send"></i></button>
                    </form>
                </div>

                <div class="footer">
                    <h3 class="footer-title">Mua sắm</h3>
                    <ul class="footer-links">
                        <li><a href="${ctx}/product">Tất cả sản phẩm</a></li>
                        <li><a href="${ctx}/wishlist">Danh sách yêu thích</a></li>
                        <li><a href="${ctx}/cart">Giỏ hàng</a></li>
                        <li><a href="${ctx}/blog">Blog phong cách</a></li>
                    </ul>
                </div>

                <div class="footer">
                    <h3 class="footer-title">Tài khoản</h3>
                    <ul class="footer-links">
                        <li><a href="${ctx}/account">Thông tin cá nhân</a></li>
                        <li><a href="${ctx}/login">Đăng nhập</a></li>
                        <li><a href="${ctx}/register">Tạo tài khoản</a></li>
                    </ul>
                </div>

                <div class="footer">
                    <h3 class="footer-title">Hỗ trợ</h3>
                    <ul class="footer-links">
                        <li><a href="tel:19001234"><i class="fa fa-phone"></i> 1900 1234</a></li>
                        <li><a href="mailto:hotro@clothesshop.vn"><i class="fa fa-envelope-o"></i> hotro@clothesshop.vn</a></li>
                        <li><a href="#"><i class="fa fa-map-marker"></i> Q.1, TP.HCM</a></li>
                    </ul>
                    <div class="mb-social-links">
                        <a href="#" aria-label="Facebook"><i class="fa fa-facebook"></i></a>
                        <a href="#" aria-label="Instagram"><i class="fa fa-instagram"></i></a>
                        <a href="#" aria-label="Twitter"><i class="fa fa-twitter"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="bottom-footer" class="section">
        <div class="container">
            <div class="mb-footer-bottom">
                <span class="copyright">
                    &copy; <script>document.write(new Date().getFullYear());</script> Clothes Shop. Bảo lưu mọi quyền.
                </span>
                <ul class="footer-payments">
                    <li><a href="#" aria-label="Visa"><i class="fa fa-cc-visa"></i></a></li>
                    <li><a href="#" aria-label="Credit Card"><i class="fa fa-credit-card"></i></a></li>
                    <li><a href="#" aria-label="Paypal"><i class="fa fa-cc-paypal"></i></a></li>
                    <li><a href="#" aria-label="Mastercard"><i class="fa fa-cc-mastercard"></i></a></li>
                </ul>
            </div>
        </div>
    </div>
</footer>

<script src="./user/js/jquery.min.js"></script>
<script src="./user/js/bootstrap.min.js"></script>
<script src="./user/js/slick.min.js"></script>
<script src="./user/js/nouislider.min.js"></script>
<script src="./user/js/jquery.zoom.min.js"></script>
<script src="./user/js/main.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/user/js/mb-swal.js?v=3" charset="UTF-8"></script>

<%@include file="./flash-swal.jsp" %>
<jsp:useBean id="convertActionText" scope="page" class="Utils.ConvertActionText"></jsp:useBean>
<c:set var="type_message" value="${param.status}"/>
<c:set var="action" value="${param.act}"/>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        <c:if test="${type_message != null && type_message == 1}">
        if (typeof MbSwal !== 'undefined') {
            MbSwal.success(null, '<c:out value="${convertActionText.convertActionText(action, type_message)}"/>');
        }
        </c:if>
        <c:if test="${type_message != null && (type_message == 0 || type_message == 2 || type_message == 3)}">
        if (typeof MbSwal !== 'undefined') {
            MbSwal.error(null, '<c:out value="${convertActionText.convertActionText(action, type_message)}"/>');
        }
        </c:if>
    });
</script>
    </body>
</html>
