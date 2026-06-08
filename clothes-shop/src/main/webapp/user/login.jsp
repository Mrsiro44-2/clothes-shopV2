<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<!-- SECTION -->
<div class="section">
    <div class="container">
        <div class="row" style="margin-bottom: 80px; margin-top: 30px">
            <div class="col-md-6">
                <img src="./user/img/signUp.png" alt="Đăng nhập Clothing shop" style="width: 100%" />
            </div>
            <div class="col-md-6" style="padding: 100px; margin-top: 70px">
                <h2>Đăng nhập</h2>
                <p>Nhập thông tin tài khoản của bạn</p>
                <form action="${ctx}/login" method="post">
                    <div style="width: 400px; margin-bottom: 20px; margin-top: 20px">
                        <input
                            class="input"
                            type="text"
                            name="username"
                            placeholder="Tên đăng nhập"
                            />
                    </div>
                    <div style="width: 400px">
                        <div class="mb-password-toggle-wrapper">
                            <input
                                class="input"
                                type="password"
                                name="password"
                                placeholder="Mật khẩu"
                                />
                            <button type="button" class="mb-password-toggle-btn" aria-label="Hiện mật khẩu">
                                <i class="fa fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div>
                        <div
                            style="
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-top: 40px;
                            "
                            >
                            <button
                                class="primary-btn"
                                name="submitLogin"
                                style="margin-bottom: 20px;"
                                >
                                Đăng nhập
                            </button>
                            <a href="${ctx}/forgot-password">Quên mật khẩu?</a>
                        </div>
                        <c:if test="${not empty messageUserAuth}">
                            <script>
                                document.addEventListener('DOMContentLoaded', function() {
                                    if (typeof Swal !== 'undefined') {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Thông báo',
                                            text: '${messageUserAuth}',
                                            confirmButtonColor: '#DB4444'
                                        });
                                    }
                                });
                            </script>
                        </c:if>
                        <div class="text-center">
                            <p>Chưa có tài khoản? <a href="${ctx}/register">Đăng ký ngay</a></p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
