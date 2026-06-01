<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>

<main class="mb-auth-page">
    <section class="section">
        <div class="container">
            <div class="mb-auth-shell">
                <div class="mb-auth-visual">
                    <img src="./user/img/signUp.png" alt="Đăng nhập Clothes Shop"/>
                    <div class="mb-auth-visual-copy">
                        <span class="mb-kicker">Welcome back</span>
                        <h2>Quay lại với tủ đồ của bạn</h2>
                        <p>Theo dõi sản phẩm yêu thích, giỏ hàng và các lựa chọn đã lưu.</p>
                    </div>
                </div>

                <div class="mb-auth-panel">
                    <span class="mb-kicker">Tài khoản</span>
                    <h1>Đăng nhập</h1>
                    <p>Nhập thông tin tài khoản để tiếp tục mua sắm.</p>

                    <form action="${ctx}/login" method="post" class="mb-auth-form">
                        <div class="mb-auth-field">
                            <label for="loginUsername">Tên đăng nhập</label>
                            <input id="loginUsername" class="input" type="text" name="username" placeholder="VD: nguyenvana"/>
                        </div>
                        <div class="mb-auth-field">
                            <label for="loginPassword">Mật khẩu</label>
                            <input id="loginPassword" class="input" type="password" name="password" placeholder="Nhập mật khẩu"/>
                        </div>

                        <div class="mb-auth-meta">
                            <button class="mb-btn mb-btn-primary" name="submitLogin" type="submit">
                                Đăng nhập <i class="fa fa-arrow-right"></i>
                            </button>
                            <a href="${ctx}/forgot-password">Quên mật khẩu?</a>
                        </div>

                        <c:if test="${not empty messageUserAuth}">
                            <p class="mb-form-message">${messageUserAuth}</p>
                        </c:if>
                    </form>

                    <p class="mb-auth-switch">Chưa có tài khoản? <a href="${ctx}/register">Đăng ký ngay</a></p>
                </div>
            </div>
        </div>
    </section>
</main>

<%@include file="./components/footer.jsp" %>
