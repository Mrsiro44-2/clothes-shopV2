<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="Utils.AppConfig"%>
<%@include file="./components/header.jsp" %>
<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
            <li><a href="${pageContext.request.contextPath}/account">Tài khoản</a></li>
            <li class="active">Sổ địa chỉ</li>
        </ul>
    </div>
</div>

<style>
    /* ... (Copy layout styles from account.jsp) ... */
    .profile-dashboard { margin-bottom: 80px; margin-top: 20px; }
    .profile-sidebar { background: #fff; border-radius: 12px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.05); padding: 30px 24px; text-align: center; border: 1px solid #f0f2f5; margin-bottom: 30px; }
    .profile-nav { list-style: none; padding: 0; margin: 0; text-align: left; }
    .profile-nav-item { margin-bottom: 8px; }
    .profile-nav-link { display: flex; align-items: center; padding: 12px 16px; color: #4a5568; font-size: 14px; font-weight: 500; border-radius: 8px; transition: all 0.2s ease; text-decoration: none; }
    .profile-nav-link i { font-size: 16px; margin-right: 12px; width: 20px; text-align: center; color: #8d99ae; }
    .profile-nav-link:hover { background-color: #fce8e8; color: var(--mb-primary, #DB4444); text-decoration: none; }
    .profile-nav-item.active .profile-nav-link { background-color: var(--mb-primary, #DB4444); color: #fff; font-weight: 600; }
    .profile-nav-item.active .profile-nav-link i { color: #fff; }

    .profile-panel { background: #fff; border-radius: 12px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.05); padding: 35px; border: 1px solid #f0f2f5; }
    .panel-header { border-bottom: 1px solid #f0f2f5; padding-bottom: 20px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; }
    .panel-title { font-size: 22px; font-weight: 700; color: #2b2d42; margin: 0 0 6px 0; }
    
    .btn-add { background-color: var(--mb-primary, #DB4444); color: #fff; font-size: 14px; font-weight: 600; padding: 10px 20px; border-radius: 6px; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; transition: 0.2s; }
    .btn-add:hover { background-color: #c41e3a; }
    
    .address-card { border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; margin-bottom: 15px; position: relative; }
    .address-card.default-address { border-color: var(--mb-primary, #DB4444); box-shadow: 0 0 0 1px rgba(219,68,68,0.2); }
    .address-header { display: flex; justify-content: space-between; margin-bottom: 10px; }
    .address-name { font-weight: 700; font-size: 16px; color: #111; display: flex; align-items: center; gap: 10px; }
    .badge-default { background: var(--mb-primary, #DB4444); color: white; font-size: 11px; padding: 2px 8px; border-radius: 4px; font-weight: 600; }
    .address-phone { color: #666; font-size: 14px; }
    .address-text { color: #444; font-size: 14px; line-height: 1.5; margin: 5px 0 0; }
    
    .address-actions { position: absolute; right: 20px; bottom: 20px; display: flex; gap: 10px; }
    .btn-outline { background: transparent; border: 1px solid #ddd; padding: 6px 12px; border-radius: 4px; font-size: 13px; color: #555; cursor: pointer; transition: 0.2s; }
    .btn-outline:hover { border-color: var(--mb-primary, #DB4444); color: var(--mb-primary, #DB4444); }
    
    /* Modal Styles */
    .mb-modal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; }
    .mb-modal.active { display: flex; }
    .mb-modal-content { background: #fff; width: 100%; max-width: 500px; border-radius: 12px; padding: 25px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); }
    .mb-modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
    .mb-modal-title { font-size: 18px; font-weight: 700; margin: 0; }
    .mb-modal-close { background: none; border: none; font-size: 24px; cursor: pointer; color: #888; }
    
    .mb-field { margin-bottom: 15px; }
    .mb-field label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px; color: #444; }
    .mb-field .input { width: 100%; height: 42px; border: 1px solid #ddd; border-radius: 6px; padding: 0 12px; }
    .mb-address-selects { display: flex; gap: 15px; }
    .mb-address-selects .select-col { flex: 1; }
</style>

<div class="section profile-dashboard">
    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <div class="profile-sidebar">
                    <div class="profile-info-name" style="font-size: 24px; margin-bottom: 20px;">Tài khoản</div>
                    <ul class="profile-nav">
                        <li class="profile-nav-item">
                            <a href="${pageContext.request.contextPath}/account" class="profile-nav-link">
                                <i class="fa fa-user"></i> <span>Thông tin cá nhân</span>
                            </a>
                        </li>
                        <li class="profile-nav-item active">
                            <a href="${pageContext.request.contextPath}/user/addresses" class="profile-nav-link">
                                <i class="fa fa-map-marker"></i> <span>Sổ địa chỉ</span>
                            </a>
                        </li>
                        <li class="profile-nav-item">
                            <a href="${pageContext.request.contextPath}/orders" class="profile-nav-link">
                                <i class="fa fa-shopping-bag"></i> <span>Đơn hàng của tôi</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="profile-panel">
                    <div class="panel-header">
                        <div>
                            <h1 class="panel-title">Địa chỉ của tôi</h1>
                            <p class="panel-subtitle">Quản lý thông tin giao hàng</p>
                        </div>
                        <button class="btn-add" onclick="openAddressModal()">
                            <i class="fa fa-plus"></i> Thêm địa chỉ mới
                        </button>
                    </div>
                    
                    <div class="address-list">
                        <c:if test="${empty addresses}">
                            <div style="text-align:center; padding: 40px 0; color: #888;">
                                <i class="fa fa-map-marker" style="font-size: 40px; margin-bottom: 10px; color: #ddd;"></i>
                                <p>Bạn chưa có địa chỉ nào được lưu.</p>
                            </div>
                        </c:if>
                        
                        <c:forEach items="${addresses}" var="addr">
                            <div class="address-card ${addr.isDefault ? 'default-address' : ''}">
                                <div class="address-header">
                                    <div class="address-name">
                                        ${addr.fullName} | <span class="address-phone">${addr.phone}</span>
                                        <c:if test="${addr.isDefault}">
                                            <span class="badge-default">Mặc định</span>
                                        </c:if>
                                    </div>
                                        <a href="javascript:void(0)" onclick="editAddress(${addr.id}, '${addr.fullName}', '${addr.phone}', '${addr.address}', '${addr.detailAddress}', ${addr.isDefault})" style="color:#0056b3;">Cập nhật</a>
                                        <c:if test="${!addr.isDefault}">
                                            <form action="${ctx}/user/addresses/delete" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa địa chỉ này?');">
                                                <input type="hidden" name="id" value="${addr.id}"/>
                                                <button type="submit" style="border:none;background:none;color:#d10024;padding:0;cursor:pointer;">Xóa</button>
                                            </form>
                                        </c:if>
                                </div>
                                <p class="address-text">
                                    ${addr.detailAddress}<br>
                                    ${addr.address}
                                </p>
                                <c:if test="${!addr.isDefault}">
                                    <div class="address-actions">
                                        <form action="${ctx}/user/addresses/default" method="post">
                                            <input type="hidden" name="id" value="${addr.id}"/>
                                            <button type="submit" class="btn-outline">Thiết lập mặc định</button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Thêm/Sửa Địa chỉ -->
<div id="addressModal" class="mb-modal">
    <div class="mb-modal-content">
        <div class="mb-modal-header">
            <h3 class="mb-modal-title" id="modalTitle">Thêm địa chỉ mới</h3>
            <button class="mb-modal-close" onclick="closeAddressModal()">&times;</button>
        </div>
        <form id="addressForm" action="${ctx}/user/addresses/add" method="post">
            <input type="hidden" name="id" id="addr_id" value="0"/>
            <c:if test="${not empty param.redirect}">
                <input type="hidden" name="redirect" value="${param.redirect}"/>
            </c:if>
            <div class="mb-field">
                <label>Họ và tên</label>
                <input type="text" class="input" name="fullName" id="addr_fullName" required placeholder="Họ và tên"/>
            </div>
            <div class="mb-field">
                <label>Số điện thoại</label>
                <input type="text" class="input" name="phone" id="addr_phone" required placeholder="Số điện thoại" pattern="(0|84)[3|5|7|8|9][0-9]{8}" title="Vui lòng nhập số điện thoại hợp lệ (VD: 0912345678)" maxlength="11"/>
            </div>
            
            <input type="hidden" name="wardCode" id="addr_wardCode" required/>
            <input type="hidden" name="districtId" id="addr_districtId" required/>
            <input type="hidden" name="address" id="addr_fullLocation" required/>

            <div class="mb-address-selects">
                <div class="select-col">
                    <label>Tỉnh / Thành phố</label>
                    <select id="mb-province" class="input" required>
                        <option value="">Chọn Tỉnh/TP</option>
                    </select>
                </div>
                <div class="select-col">
                    <label>Quận / Huyện</label>
                    <select id="mb-district" class="input" required disabled>
                        <option value="">Chọn Quận/Huyện</option>
                    </select>
                </div>
            </div>
            <div class="mb-address-selects" style="margin-top: 15px;">
                <div class="select-col">
                    <label>Phường / Xã</label>
                    <select id="mb-ward" class="input" required disabled>
                        <option value="">Chọn Phường/Xã</option>
                    </select>
                </div>
            </div>

            <div class="mb-field">
                <label>Địa chỉ cụ thể</label>
                <input type="text" class="input" name="detailAddress" id="addr_detail" required placeholder="Số nhà, tên đường..."/>
            </div>
            
            <div class="mb-field" style="display:flex; align-items:center; gap:8px;">
                <input type="checkbox" name="isDefault" id="addr_isDefault" value="1" style="width:16px;height:16px;"/>
                <label for="addr_isDefault" style="margin:0; font-weight:normal;">Đặt làm địa chỉ mặc định</label>
            </div>
            
            <button type="submit" class="btn-add" style="width:100%; justify-content:center; margin-top: 10px; height: 42px;">Hoàn thành</button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script>
    const GHN_TOKEN = '<%= AppConfig.GHN_TOKEN %>';
    var provinceSelect = document.getElementById("mb-province");
    var districtSelect = document.getElementById("mb-district");
    var wardSelect = document.getElementById("mb-ward");
    var fullAddressInput = document.getElementById("addr_fullLocation");
    var districtIdInput = document.getElementById("addr_districtId");
    var wardCodeInput = document.getElementById("addr_wardCode");

    function fetchProvinces() {
        return axios.get('https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/province', {
            headers: { 'Token': GHN_TOKEN }
        }).then(res => {
            provinceSelect.innerHTML = '<option value="">Chọn Tỉnh/TP</option>';
            res.data.data.forEach(p => {
                if (!p.ProvinceName.toLowerCase().includes('test')) {
                    var opt = document.createElement("option");
                    opt.value = p.ProvinceID;
                    opt.text = p.ProvinceName;
                    provinceSelect.add(opt);
                }
            });
        });
    }

    provinceSelect.addEventListener("change", function () {
        districtSelect.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
        wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
        districtSelect.disabled = true;
        wardSelect.disabled = true;
        districtIdInput.value = '';
        wardCodeInput.value = '';
        
        var pCode = this.value;
        if (!pCode) { buildAddress(); return; }

        axios.get('https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/district?province_id=' + pCode, {
            headers: { 'Token': GHN_TOKEN }
        }).then(res => {
            res.data.data.forEach(d => {
                if (!d.DistrictName.toLowerCase().includes('test')) {
                    var opt = document.createElement("option");
                    opt.value = d.DistrictID;
                    opt.text = d.DistrictName;
                    districtSelect.add(opt);
                }
            });
            districtSelect.disabled = false;
        });
        buildAddress();
    });

    districtSelect.addEventListener("change", function () {
        wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
        wardSelect.disabled = true;
        wardCodeInput.value = '';
        
        var dCode = this.value;
        if (!dCode) { buildAddress(); return; }

        districtIdInput.value = dCode;

        axios.get('https://dev-online-gateway.ghn.vn/shiip/public-api/master-data/ward?district_id=' + dCode, {
            headers: { 'Token': GHN_TOKEN }
        }).then(res => {
            res.data.data.forEach(w => {
                if (!w.WardName.toLowerCase().includes('test')) {
                    var opt = document.createElement("option");
                    opt.value = w.WardCode;
                    opt.text = w.WardName;
                    wardSelect.add(opt);
                }
            });
            wardSelect.disabled = false;
        });
        buildAddress();
    });

    wardSelect.addEventListener("change", function() {
        wardCodeInput.value = this.value;
        buildAddress();
    });

    function buildAddress() {
        var pText = provinceSelect.selectedIndex > 0 ? provinceSelect.options[provinceSelect.selectedIndex].text : "";
        var dText = districtSelect.selectedIndex > 0 ? districtSelect.options[districtSelect.selectedIndex].text : "";
        var wText = wardSelect.selectedIndex > 0 ? wardSelect.options[wardSelect.selectedIndex].text : "";
        
        var parts = [];
        if (wText) parts.push(wText);
        if (dText) parts.push(dText);
        if (pText) parts.push(pText);
        
        fullAddressInput.value = parts.join(", ");
    }

    // Modal Logic
    function openAddressModal() {
        document.getElementById('addressForm').action = '${ctx}/user/addresses/add';
        document.getElementById('modalTitle').innerText = 'Thêm địa chỉ mới';
        document.getElementById('addr_id').value = '0';
        document.getElementById('addressForm').reset();
        districtSelect.disabled = true;
        wardSelect.disabled = true;
        document.getElementById('addressModal').classList.add('active');
    }

    function closeAddressModal() {
        document.getElementById('addressModal').classList.remove('active');
    }

    function editAddress(id, fullName, phone, address, detailAddress, isDefault) {
        document.getElementById('addressForm').action = '${ctx}/user/addresses/edit';
        document.getElementById('modalTitle').innerText = 'Cập nhật địa chỉ';
        document.getElementById('addr_id').value = id;
        document.getElementById('addr_fullName').value = fullName;
        document.getElementById('addr_phone').value = phone;
        document.getElementById('addr_detail').value = detailAddress;
        document.getElementById('addr_isDefault').checked = isDefault;
        
        // Load API and try to match (Simplified for edit: we just let them re-select if they want to change province)
        fetchProvinces().then(() => {
            // NOTE: Auto-selecting province/ward from string requires complex reverse mapping.
            // For now, if they edit, they either keep the hidden value or re-select to change.
            var opt = document.createElement("option");
            opt.value = "KEEP";
            opt.textContent = "-- Giữ nguyên: " + address + " --";
            opt.selected = true;
            provinceSelect.insertBefore(opt, provinceSelect.firstChild);
        });

        document.getElementById('addressModal').classList.add('active');
    }

    function closeAddressModal() {
        document.getElementById('addressModal').classList.remove('active');
    }

    document.addEventListener("DOMContentLoaded", function() {
        fetchProvinces();
        <c:if test="${not empty param.redirect}">
            openAddressModal();
        </c:if>
    });
</script>

<%@include file="./components/footer.jsp" %>
