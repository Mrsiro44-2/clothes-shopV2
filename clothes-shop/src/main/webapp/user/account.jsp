<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
            <li class="active">Tài khoản</li>
        </ul>
    </div>
</div>

<style>
    /* Dashboard Layout & Card Styles */
    .profile-dashboard {
        margin-bottom: 80px;
        margin-top: 20px;
    }
    .profile-sidebar {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.05);
        padding: 30px 24px;
        text-align: center;
        border: 1px solid #f0f2f5;
        margin-bottom: 30px;
    }
    .profile-avatar-container {
        position: relative;
        width: 100px;
        height: 100px;
        margin: 0 auto 20px auto;
        cursor: pointer;
        border-radius: 50%;
        overflow: hidden;
    }
    .profile-avatar {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        background: linear-gradient(135deg, var(--mb-primary, #DB4444) 0%, #ff7676 100%);
        color: #fff;
        font-size: 36px;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 15px rgba(219, 68, 68, 0.2);
        text-transform: uppercase;
        position: relative;
        transition: all 0.3s ease;
    }
    .profile-avatar img.profile-img-preview {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
        display: block;
    }
    .profile-avatar-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.55);
        color: #fff;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: opacity 0.3s ease;
        border-radius: 50%;
        font-size: 11px;
        pointer-events: none;
    }
    .profile-avatar-container:hover .profile-avatar-overlay {
        opacity: 1;
    }
    .profile-avatar-overlay i {
        font-size: 18px;
        margin-bottom: 4px;
    }
    .profile-info-name {
        font-size: 18px;
        font-weight: 700;
        color: #2b2d42;
        margin-bottom: 4px;
        word-wrap: break-word;
    }
    .profile-info-role {
        font-size: 13px;
        color: #8d99ae;
        margin-bottom: 24px;
        display: inline-block;
        background: #f8f9fa;
        padding: 3px 12px;
        border-radius: 20px;
        font-weight: 500;
    }
    .profile-nav {
        list-style: none;
        padding: 0;
        margin: 0;
        text-align: left;
    }
    .profile-nav-item {
        margin-bottom: 8px;
    }
    .profile-nav-link {
        display: flex;
        align-items: center;
        padding: 12px 16px;
        color: #4a5568;
        font-size: 14px;
        font-weight: 500;
        border-radius: 8px;
        transition: all 0.2s ease;
        text-decoration: none;
    }
    .profile-nav-link i {
        font-size: 16px;
        margin-right: 12px;
        width: 20px;
        text-align: center;
        color: #8d99ae;
        transition: all 0.2s ease;
    }
    .profile-nav-link:hover {
        background-color: #fce8e8;
        color: var(--mb-primary, #DB4444);
        text-decoration: none;
    }
    .profile-nav-link:hover i {
        color: var(--mb-primary, #DB4444);
    }
    .profile-nav-item.active .profile-nav-link {
        background-color: var(--mb-primary, #DB4444);
        color: #fff;
        font-weight: 600;
    }
    .profile-nav-item.active .profile-nav-link i {
        color: #fff;
    }
    .profile-nav-link.logout-link:hover {
        background-color: #fff0f0;
        color: #d10024;
    }
    .profile-nav-link.logout-link:hover i {
        color: #d10024;
    }

    /* Form Panel Styles */
    .profile-panel {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.05);
        padding: 35px;
        border: 1px solid #f0f2f5;
    }
    .panel-header {
        border-bottom: 1px solid #f0f2f5;
        padding-bottom: 20px;
        margin-bottom: 30px;
    }
    .panel-title {
        font-size: 22px;
        font-weight: 700;
        color: #2b2d42;
        margin: 0 0 6px 0;
    }
    .panel-subtitle {
        font-size: 14px;
        color: #8d99ae;
        margin: 0;
    }
    .form-section-title {
        font-size: 15px;
        font-weight: 700;
        color: #2b2d42;
        margin-top: 30px;
        margin-bottom: 20px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border-left: 3px solid var(--mb-primary, #DB4444);
        padding-left: 10px;
    }
    .profile-form .form-group {
        margin-bottom: 22px;
    }
    .profile-form label {
        font-size: 13px;
        font-weight: 600;
        color: #4a5568;
        margin-bottom: 8px;
        display: block;
    }
    .profile-form .form-control.input {
        height: 46px;
        border-radius: 8px;
        border: 1px solid #e2e8f0;
        padding: 0 16px;
        font-size: 14px;
        color: #2d3748;
        transition: all 0.2s ease;
        background-color: #fff;
        box-shadow: none;
    }
    .profile-form .form-control.input:focus {
        border-color: var(--mb-primary, #DB4444);
        box-shadow: 0 0 0 3px rgba(219, 68, 68, 0.1);
        outline: none;
    }
    .profile-form .btn-submit {
        background-color: var(--mb-primary, #DB4444);
        color: #fff;
        font-size: 15px;
        font-weight: 700;
        padding: 12px 30px;
        border-radius: 8px;
        border: none;
        transition: all 0.2s ease;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(219, 68, 68, 0.15);
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    .profile-form .btn-submit:hover {
        background-color: var(--mb-primary-dark, #c41e3a);
        box-shadow: 0 6px 18px rgba(219, 68, 68, 0.25);
        transform: translateY(-1px);
    }
    .profile-form .btn-submit:active {
        transform: translateY(0);
    }
    .profile-form .btn-submit i {
        font-size: 14px;
    }
</style>

<div class="section profile-dashboard">
    <div class="container">
        <div class="row">
            <!-- Sidebar Column -->
            <div class="col-md-4">
                <div class="profile-sidebar">
                    <div class="profile-avatar-container" id="avatarContainer" title="Click để đổi ảnh đại diện">
                        <div class="profile-avatar">
                            <c:choose>
                                <c:when test="${not empty account.avatar}">
                                    <img src="${imgUrl.resolve(account.avatar, ctx)}" alt="Avatar" class="profile-img-preview" onerror="this.style.display='none'; document.getElementById('avatarFallbackText').style.display='flex';" />
                                    <span id="avatarFallbackText" style="display:none; width: 100%; height: 100%; align-items: center; justify-content: center;">
                                        <c:set var="nameParts" value="${fn:split(account.fullname, ' ')}" />
                                        <c:set var="avatarChar" value="${fn:substring(nameParts[fn:length(nameParts) - 1], 0, 1)}" />
                                        <c:if test="${empty avatarChar}">
                                            <c:set var="avatarChar" value="${fn:substring(account.username, 0, 1)}" />
                                        </c:if>
                                        <c:out value="${avatarChar}"/>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span id="avatarFallbackText" style="display:flex; width: 100%; height: 100%; align-items: center; justify-content: center;">
                                        <c:set var="nameParts" value="${fn:split(account.fullname, ' ')}" />
                                        <c:set var="avatarChar" value="${fn:substring(nameParts[fn:length(nameParts) - 1], 0, 1)}" />
                                        <c:if test="${empty avatarChar}">
                                            <c:set var="avatarChar" value="${fn:substring(account.username, 0, 1)}" />
                                        </c:if>
                                        <c:out value="${avatarChar}"/>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="profile-avatar-overlay">
                            <i class="fa fa-camera"></i>
                            <span>Đổi ảnh</span>
                        </div>
                    </div>
                    <div class="profile-info-name"><c:out value="${account.fullname}"/></div>
                    <div class="profile-info-role">@<c:out value="${account.username}"/></div>
                    
                    <ul class="profile-nav">
                        <li class="profile-nav-item active">
                            <a href="${pageContext.request.contextPath}/account" class="profile-nav-link">
                                <i class="fa fa-user"></i>
                                <span>Thông tin cá nhân</span>
                            </a>
                        </li>
                        <li class="profile-nav-item">
                            <a href="${pageContext.request.contextPath}/orders" class="profile-nav-link">
                                <i class="fa fa-shopping-bag"></i>
                                <span>Đơn hàng của tôi</span>
                            </a>
                        </li>
                        <li class="profile-nav-item">
                            <a href="${pageContext.request.contextPath}/wishlist" class="profile-nav-link">
                                <i class="fa fa-heart"></i>
                                <span>Sản phẩm yêu thích</span>
                            </a>
                        </li>
                        <li class="profile-nav-item">
                            <a href="${pageContext.request.contextPath}/user/addresses" class="profile-nav-link">
                                <i class="fa fa-map-marker"></i>
                                <span>Sổ địa chỉ</span>
                            </a>
                        </li>
                        <li class="profile-nav-item">
                            <a href="${pageContext.request.contextPath}/change-password" class="profile-nav-link">
                                <i class="fa fa-key"></i>
                                <span>Đổi mật khẩu</span>
                            </a>
                        </li>
                        <li class="profile-nav-item" style="margin-top: 15px; border-top: 1px solid #f0f2f5; padding-top: 15px;">
                            <a href="${pageContext.request.contextPath}/logout" class="profile-nav-link logout-link mb-confirm" data-confirm-key="logout">
                                <i class="fa fa-sign-out"></i>
                                <span>Đăng xuất</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            
            <!-- Main Content Form Column -->
            <div class="col-md-8">
                <div class="profile-panel">
                    <div class="panel-header">
                        <h1 class="panel-title">Tài khoản của tôi</h1>
                        <p class="panel-subtitle">Quản lý và cập nhật thông tin cá nhân của bạn</p>
                    </div>
                    
                    <form id="updateInfoForm" class="profile-form" action="${pageContext.request.contextPath}/account?action=updateInfo" method="post" enctype="multipart/form-data" novalidate>
                        <!-- Hidden avatar file input -->
                        <input type="file" id="avatarFileInput" name="avatarFile" accept="image/*" style="display:none;" />
                        <div class="form-section-title">Thông tin cơ bản</div>
                        
                        <div class="form-group">
                            <label for="accFullname">Họ tên <span style="color:red">*</span></label>
                            <input id="accFullname" class="form-control input" name="fullname" required value="${account.fullname}"/>
                        </div>
                        
                        <div class="form-group">
                            <label for="accEmail">Email <span style="color:red">*</span></label>
                            <input id="accEmail" class="form-control input" name="email" type="email" required value="${account.email}"/>
                        </div>
                        
                        <div class="form-group">
                            <label for="accPhone">Số điện thoại <span style="color:red">*</span></label>
                            <input id="accPhone" class="form-control input" name="phone" required
                                   value="${account.phone != null ? account.phone : ''}"
                                   placeholder="VD: 0912345678"/>
                        </div>
                        
                        <div style="margin-top: 30px; margin-bottom: 40px;">
                            <button type="submit" class="btn-submit">
                                <i class="fa fa-save"></i>
                                Cập nhật thông tin
                            </button>
                        </div>
                    </form>


                    
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            if (typeof MbSwal !== 'undefined') {
                                MbSwal.initAccountProfileForm('updateInfoForm', 'Cập nhật thông tin');
                            }
                            
                            // Avatar upload handler
                            var avatarContainer = document.getElementById('avatarContainer');
                            var avatarFileInput = document.getElementById('avatarFileInput');
                            
                            if (avatarContainer && avatarFileInput) {
                                avatarContainer.addEventListener('click', function () {
                                    avatarFileInput.click();
                                });
                                
                                avatarFileInput.addEventListener('change', function () {
                                    var file = this.files[0];
                                    if (file) {
                                        if (file.size > 5 * 1024 * 1024) {
                                            if (typeof MbSwal !== 'undefined') {
                                                MbSwal.error('Tài khoản', 'Ảnh đại diện không được lớn hơn 5MB.');
                                            } else {
                                                alert('Ảnh đại diện không được lớn hơn 5MB.');
                                            }
                                            this.value = '';
                                            return;
                                        }
                                        
                                        var reader = new FileReader();
                                        reader.onload = function (e) {
                                            var avatarDiv = avatarContainer.querySelector('.profile-avatar');
                                            var img = avatarDiv.querySelector('img.profile-img-preview');
                                            
                                            if (!img) {
                                                img = document.createElement('img');
                                                img.className = 'profile-img-preview';
                                                avatarDiv.insertBefore(img, avatarDiv.firstChild);
                                            }
                                            img.src = e.target.result;
                                            img.style.display = 'block';
                                            
                                            var fallbackText = document.getElementById('avatarFallbackText');
                                            if (fallbackText) {
                                                fallbackText.style.display = 'none';
                                            }
                                        };
                                        reader.readAsDataURL(file);
                                    }
                                });
                            }
                        });
                    </script>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="./components/footer.jsp" %>
