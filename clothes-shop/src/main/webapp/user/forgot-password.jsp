<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<div class="section">
    <div class="container">
        <div class="row" style="margin-bottom: 80px; margin-top: 30px">
            <div class="col-md-6">
                <img src="./user/img/signUp.png" alt="Quên mật khẩu" style="width: 100%" />
            </div>
            <div class="col-md-6" style="padding: 100px; margin-top: 70px">
                <h2>Quên mật khẩu</h2>
                <p>Nhập email của bạn để nhận mã xác nhận khôi phục</p>
                <form action="${ctx}/forgot-password" method="post">
                    <div style="width: 400px; margin-bottom: 20px; margin-top: 20px">
                        <input
                            class="input"
                            type="email"
                            name="email"
                            placeholder="Địa chỉ Email"
                            required
                            />
                    </div>
                    <div>
                        <div style="margin-top: 40px; margin-bottom: 20px;">
                            <button
                                class="primary-btn"
                                type="submit"
                                >
                                Gửi mã OTP
                            </button>
                        </div>
                        <c:if test="${not empty error}">
                            <script>
                                document.addEventListener('DOMContentLoaded', function() {
                                    if (typeof Swal !== 'undefined') {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Thông báo',
                                            text: '${error}',
                                            confirmButtonColor: '#DB4444'
                                        });
                                    }
                                });
                            </script>
                        </c:if>
                        <div class="text-left">
                            <p>Nhớ mật khẩu? <a href="${ctx}/login" style="color: #db4444;">Đăng nhập</a></p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
