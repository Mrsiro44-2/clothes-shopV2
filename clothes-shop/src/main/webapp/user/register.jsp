<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<div class="section">
    <div class="container">
        <div class="row" style="margin-bottom: 80px; margin-top: 30px">
            <div class="col-md-6">
                <img src="./user/img/signUp.png" alt="Đăng ký Clothing shop" style="width: 100%" />
            </div>
            <form action="${ctx}/register" method="post" id="registerForm">
                <div class="col-md-6" style="padding: 100px">
                    <h2>Tạo tài khoản</h2>
                    <p>Điền thông tin bên dưới để đăng ký</p>
                    <div style="width: 400px; margin-bottom: 20px; margin-top: 20px">
                        <input class="input" type="text" name="fullname" placeholder="Họ và tên" value="${formFullname != null ? formFullname : ''}" />
                    </div>
                    <div style="width: 400px; margin-bottom: 20px">
                        <input class="input" type="text" name="username" placeholder="Tên đăng nhập" value="${formUsername != null ? formUsername : ''}" />
                    </div>
                    <div style="width: 400px; margin-bottom: 20px">
                        <input class="input" type="text" name="email" placeholder="Email" value="${formEmail != null ? formEmail : ''}" />
                    </div>
                    <div style="width: 400px; margin-bottom: 20px">
                        <input class="input" type="text" name="phone" placeholder="Số điện thoại" value="${formPhone != null ? formPhone : ''}" pattern="(0|84)[3|5|7|8|9][0-9]{8}" title="Vui lòng nhập số điện thoại hợp lệ (VD: 0912345678)" maxlength="11" required />
                    </div>
                    <div style="width: 400px; margin-bottom: 20px">
                        <div class="mb-password-toggle-wrapper">
                            <input class="input" type="password" name="password" placeholder="Mật khẩu" />
                            <button type="button" class="mb-password-toggle-btn" aria-label="Hiện mật khẩu">
                                <i class="fa fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div style="width: 400px; margin-bottom: 20px">
                        <div class="mb-password-toggle-wrapper">
                            <input class="input form-control" type="password" id="confirmPassword" name="confirmPassword"
                                   placeholder="Nhập lại mật khẩu" minlength="6" required autocomplete="new-password" style="width:100%"/>
                            <button type="button" class="mb-password-toggle-btn" aria-label="Hiện mật khẩu">
                                <i class="fa fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    <div style="margin-top: 40px">
                        <button
                            class="primary-btn"
                            name="register"
                            style="width: 400px; margin-bottom: 20px;"
                            >
                            Đăng ký
                        </button>
                    </div>
                    <div>
                        <c:if test="${not empty messageFailRegister}">
                            <script>
                                document.addEventListener('DOMContentLoaded', function() {
                                    if (typeof Swal !== 'undefined') {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Thông báo',
                                            text: '${messageFailRegister}',
                                            confirmButtonColor: '#DB4444'
                                        });
                                    }
                                });
                            </script>
                        </c:if>
                    </div>
                    <div class="text-center">
                        <p>Đã có tài khoản? <a href="${ctx}/login">Đăng nhập</a></p>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
