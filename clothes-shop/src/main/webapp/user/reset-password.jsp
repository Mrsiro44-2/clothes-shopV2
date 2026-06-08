<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<div class="section">
    <div class="container">
        <div class="row" style="margin-bottom: 80px; margin-top: 30px">
            <div class="col-md-6">
                <img src="./user/img/signUp.png" alt="Đặt lại mật khẩu" style="width: 100%" />
            </div>
            <div class="col-md-6" style="padding: 100px; margin-top: 70px">
                <h2>Đặt lại mật khẩu</h2>
                <p>Nhập mật khẩu mới của bạn (ít nhất 6 ký tự)</p>
                <form action="${ctx}/reset-password" method="post">
                    <div style="width: 400px; margin-bottom: 20px; margin-top: 20px">
                        <div class="mb-password-toggle-wrapper">
                            <input
                                class="input"
                                type="password"
                                name="password"
                                placeholder="Mật khẩu mới"
                                required
                                minlength="6"
                                />
                            <button type="button" class="mb-password-toggle-btn" aria-label="Hiện mật khẩu">
                                <i class="fa fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div style="width: 400px; margin-bottom: 20px;">
                        <div class="mb-password-toggle-wrapper">
                            <input
                                class="input"
                                type="password"
                                name="confirmPassword"
                                placeholder="Xác nhận mật khẩu mới"
                                required
                                minlength="6"
                                />
                            <button type="button" class="mb-password-toggle-btn" aria-label="Hiện mật khẩu">
                                <i class="fa fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div>
                        <div style="margin-top: 40px; margin-bottom: 20px;">
                            <button
                                class="primary-btn"
                                type="submit"
                                >
                                Lưu mật khẩu mới
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
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
