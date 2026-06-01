<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>

<main class="mb-account-page">
    <div id="breadcrumb" class="section">
        <div class="container">
            <ul class="breadcrumb-tree">
                <li><a href="${ctx}/home">Trang chủ</a></li>
                <li class="active">Tài khoản</li>
            </ul>
        </div>
    </div>

    <section class="mb-page-hero">
        <div class="container">
            <span class="mb-kicker">Profile</span>
            <h1>Tài khoản của tôi</h1>
            <p>Cập nhật thông tin liên hệ và bảo mật tài khoản của bạn.</p>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <div class="mb-account-layout">
                <nav class="mb-account-nav" aria-label="Tài khoản">
                    <span class="active"><i class="fa fa-user-o"></i> Thông tin cá nhân</span>
                    <a href="${ctx}/wishlist"><i class="fa fa-heart-o"></i> Yêu thích</a>
                    <a href="${ctx}/cart"><i class="fa fa-shopping-bag"></i> Giỏ hàng</a>
                    <a href="${ctx}/logout"><i class="fa fa-sign-out"></i> Đăng xuất</a>
                </nav>

                <div class="mb-account-panel">
                    <h2>Thông tin cá nhân</h2>
                    <form id="accountProfileForm" action="${ctx}/account" method="post" class="mb-account-form" novalidate>
                        <div class="mb-account-field mb-account-field--full">
                            <label for="accFullname">Họ tên</label>
                            <input id="accFullname" class="form-control input" name="fullname" required value="${account.fullname}"/>
                        </div>
                        <div class="mb-account-field">
                            <label for="accEmail">Email</label>
                            <input id="accEmail" class="form-control input" name="email" type="email" required value="${account.email}"/>
                        </div>
                        <div class="mb-account-field">
                            <label for="accPhone">Số điện thoại</label>
                            <input id="accPhone" class="form-control input" name="phone" required
                                   value="${account.phone != null ? account.phone : ''}"
                                   placeholder="VD: 0912345678"/>
                        </div>
                        <div class="mb-account-field">
                            <label for="accPassword">Mật khẩu mới</label>
                            <input id="accPassword" class="form-control input" name="password" type="password" minlength="6" autocomplete="new-password" placeholder="Để trống nếu không đổi"/>
                        </div>
                        <div class="mb-account-field">
                            <label for="accConfirmPassword">Xác nhận mật khẩu mới</label>
                            <input id="accConfirmPassword" class="form-control input" name="confirmPassword" type="password" minlength="6" autocomplete="new-password"/>
                        </div>
                        <div class="mb-account-field mb-account-field--full">
                            <button type="submit" class="mb-btn mb-btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (typeof MbSwal !== 'undefined') {
            MbSwal.initAccountProfileForm('accountProfileForm', 'Tài khoản');
        }
    });
</script>

<%@include file="./components/footer.jsp" %>
