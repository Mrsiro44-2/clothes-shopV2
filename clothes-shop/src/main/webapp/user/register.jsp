<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>

<main class="mb-auth-page">
    <section class="section">
        <div class="container">
            <div class="mb-auth-shell">
                <div class="mb-auth-visual">
                    <img src="./user/img/signUp.png" alt="Đăng ký Clothes Shop"/>
                    <div class="mb-auth-visual-copy">
                        <span class="mb-kicker">Join us</span>
                        <h2>Tạo tài khoản mua sắm gọn hơn</h2>
                        <p>Lưu wishlist, quản lý giỏ hàng và nhận các cập nhật phù hợp với bạn.</p>
                    </div>
                </div>

                <div class="mb-auth-panel">
                    <span class="mb-kicker">Tài khoản</span>
                    <h1>Tạo tài khoản</h1>
                    <p>Điền thông tin bên dưới để bắt đầu.</p>

                    <form action="${ctx}/register" method="post" class="mb-auth-form">
                        <div class="mb-auth-field">
                            <label for="registerFullname">Họ và tên</label>
                            <input id="registerFullname" class="input" type="text" name="fullname" placeholder="Nguyễn Văn A"/>
                        </div>
                        <div class="mb-auth-field">
                            <label for="registerUsername">Tên đăng nhập</label>
                            <input id="registerUsername" class="input" type="text" name="username" placeholder="nguyenvana"/>
                        </div>
                        <div class="mb-auth-field">
                            <label for="registerEmail">Email</label>
                            <input id="registerEmail" class="input" type="text" name="email" placeholder="email@example.com"/>
                        </div>
                        <div class="mb-auth-field">
                            <label for="registerPhone">Số điện thoại</label>
                            <input id="registerPhone" class="input" type="text" name="phone" placeholder="0912345678"/>
                        </div>
                        <div class="mb-auth-field">
                            <label for="registerPassword">Mật khẩu</label>
                            <input id="registerPassword" class="input" type="password" name="password" placeholder="Tối thiểu 6 ký tự"/>
                        </div>
                        <div class="mb-auth-field">
                            <label for="confirmPassword">Nhập lại mật khẩu</label>
                            <input id="confirmPassword" class="input" type="password" name="confirmPassword"
                                   placeholder="Nhập lại mật khẩu" minlength="6" required autocomplete="new-password"/>
                        </div>

                        <button class="mb-btn mb-btn-primary" name="register" type="submit">
                            Đăng ký <i class="fa fa-arrow-right"></i>
                        </button>

                        <c:if test="${not empty messageFailRegister}">
                            <p class="mb-form-message">${messageFailRegister}</p>
                        </c:if>
                    </form>

                    <p class="mb-auth-switch">Đã có tài khoản? <a href="${ctx}/login">Đăng nhập</a></p>
                </div>
            </div>
        </div>
    </section>
</main>

<%@include file="./components/footer.jsp" %>
