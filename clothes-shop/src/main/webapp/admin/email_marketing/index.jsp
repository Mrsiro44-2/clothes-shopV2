<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="pageTitle" value="Email Marketing" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">
        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        Chiến dịch Email Marketing
                    </h2>
                </div>
            </div>
        </div>

        <jsp:include page="../components/flash.jsp"/>

        <div class="row row-cards">
            <div class="col-12">
                <form action="${ctx}/admin/marketing/send" method="post" class="card">
                    <div class="card-body">
                        <div class="mb-4">
                            <label class="form-label required">Đối tượng nhận Email</label>
                            <div class="form-selectgroup form-selectgroup-boxes d-flex flex-column">
                                <label class="form-selectgroup-item flex-fill">
                                    <input type="radio" name="target" value="buyers" class="form-selectgroup-input" checked>
                                    <div class="form-selectgroup-label d-flex align-items-center p-3">
                                        <div class="me-3">
                                            <span class="form-selectgroup-check"></span>
                                        </div>
                                        <div>
                                            <strong>Khách hàng đã mua hàng</strong>
                                            <div class="text-muted">Gửi cho tất cả những người từng thanh toán thành công</div>
                                        </div>
                                    </div>
                                </label>
                                <label class="form-selectgroup-item flex-fill mt-2">
                                    <input type="radio" name="target" value="newbies" class="form-selectgroup-input">
                                    <div class="form-selectgroup-label d-flex align-items-center p-3">
                                        <div class="me-3">
                                            <span class="form-selectgroup-check"></span>
                                        </div>
                                        <div>
                                            <strong>Khách hàng mới (Chưa mua)</strong>
                                            <div class="text-muted">Gửi cho những người đã tạo tài khoản nhưng chưa có đơn hàng</div>
                                        </div>
                                    </div>
                                </label>
                                <label class="form-selectgroup-item flex-fill mt-2">
                                    <input type="radio" name="target" value="manual" class="form-selectgroup-input" id="manualRadio">
                                    <div class="form-selectgroup-label d-flex align-items-center p-3">
                                        <div class="me-3">
                                            <span class="form-selectgroup-check"></span>
                                        </div>
                                        <div>
                                            <strong>Nhập tay danh sách Email</strong>
                                            <div class="text-muted">Chỉ định cụ thể những email nhận được chiến dịch này</div>
                                        </div>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div class="mb-4" id="manualEmailsDiv" style="display: none;">
                            <label class="form-label">Danh sách Email (cách nhau bởi dấu phẩy)</label>
                            <textarea class="form-control" name="manualEmails" rows="2" placeholder="vd: a@gmail.com, b@gmail.com"></textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Chọn Mẫu Email (Tùy chọn)</label>
                            <select class="form-select" id="templateSelector">
                                <option value="">-- Tự viết nội dung --</option>
                                <option value="sale">Mẫu: Thông báo Khuyến Mãi Lớn</option>
                                <option value="welcome">Mẫu: Chào mừng khách hàng mới</option>
                                <option value="care">Mẫu: Tri ân khách hàng cũ</option>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label required">Tiêu đề (Subject)</label>
                            <input type="text" class="form-control" name="subject" id="emailSubject" required placeholder="Nhập tiêu đề email">
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Đính kèm Voucher (Tùy chọn)</label>
                            <select class="form-select select2" name="voucherId">
                                <option value="">-- Không đính kèm --</option>
                                <c:forEach items="${vouchers}" var="v">
                                    <c:if test="${v.status == 1}">
                                        <c:set var="rawCode" value="${v.code}" />
                                        <c:set var="displayCode" value="${(rawCode.startsWith('PUB_') || rawCode.startsWith('PRI_')) ? rawCode.substring(4) : rawCode}" />
                                        <option value="${v.id}">
                                            ${displayCode} - 
                                            <c:if test="${v.discountType == 1}">Giảm ${v.value}%</c:if>
                                            <c:if test="${v.discountType == 2}">Giảm <fmt:formatNumber value="${v.value}" pattern="#,###"/>đ</c:if>
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                            <small class="form-hint">Mã giảm giá sẽ được trình bày đẹp mắt ở phần cuối nội dung email.</small>
                        </div>

                        <div class="mb-4">
                            <label class="form-label required">Nội dung Email</label>
                            <textarea id="tinymce-editor" name="content"></textarea>
                        </div>

                    </div>
                    <div class="card-footer d-flex justify-content-between">
                        <button type="button" class="btn btn-outline-info" onclick="previewEmail()">
                            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-eye" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                <path d="M10 12a2 2 0 1 0 4 0a2 2 0 0 0 -4 0"></path>
                                <path d="M21 12c-2.4 4 -5.4 6 -9 6c-3.6 0 -6.6 -2 -9 -6c2.4 -4 5.4 -6 9 -6c3.6 0 6.6 2 9 6"></path>
                            </svg>
                            Xem trước Email
                        </button>
                        <button type="submit" class="btn btn-primary" onclick="return confirm('Xác nhận gửi email hàng loạt? Quá trình sẽ diễn ra dưới nền.')">
                            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-send" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                               <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                               <path d="M10 14l11 -11"></path>
                               <path d="M21 3l-6.5 18a.55 .55 0 0 1 -1 0l-3.5 -7l-7 -3.5a.55 .55 0 0 1 0 -1l18 -6.5"></path>
                            </svg>
                            Gửi Chiến Dịch Ngay
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Preview -->
<div class="modal modal-blur fade" id="previewModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Xem trước Email</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" style="background: #f4f6fa; padding: 30px;">
                <div style="max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                    <div style="background: #206bc4; padding: 20px; text-align: center; color: white;">
                        <h2 style="margin: 0; font-size: 24px;">Clothes Shop</h2>
                    </div>
                    <div style="padding: 30px;" id="previewContent">
                        <!-- Content goes here -->
                    </div>
                    <div id="previewVoucher" style="display: none; margin: 0 30px 30px 30px; padding: 20px; border: 2px dashed #206bc4; border-radius: 8px; text-align: center; background: #f0f6ff;">
                        <h3 style="margin-top: 0; color: #206bc4;">Mã Giảm Giá Dành Cho Bạn</h3>
                        <div style="font-size: 24px; font-weight: bold; background: #206bc4; color: white; display: inline-block; padding: 10px 20px; border-radius: 4px; letter-spacing: 2px; margin-bottom: 10px;" id="previewVoucherCode">CODE</div>
                        <p style="margin: 0; font-size: 16px; font-weight: bold;" id="previewVoucherDesc">Giảm 0</p>
                    </div>
                    <div style="background: #f8f9fa; padding: 15px; text-align: center; font-size: 12px; color: #6c757d; border-top: 1px solid #e9ecef;">
                        Đây là email tự động từ hệ thống Clothes Shop.<br>
                        Vui lòng không trả lời email này.
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/tinymce/6.8.3/tinymce.min.js" referrerpolicy="origin"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Toggle manual emails input
        const radios = document.querySelectorAll('input[name="target"]');
        const manualDiv = document.getElementById('manualEmailsDiv');
        const manualInput = document.querySelector('textarea[name="manualEmails"]');

        radios.forEach(radio => {
            radio.addEventListener('change', function() {
                if (document.getElementById('manualRadio').checked) {
                    manualDiv.style.display = 'block';
                    manualInput.required = true;
                } else {
                    manualDiv.style.display = 'none';
                    manualInput.required = false;
                }
            });
        });

        // Templates data
        const templates = {
            sale: {
                subject: "Cơ hội săn Sale Khủng chỉ có hôm nay! Giảm giá cực mạnh \uD83D\uDD25",
                content: "<h2>Xin chào [FULL_NAME],</h2><p>Đừng bỏ lỡ cơ hội mua sắm các sản phẩm thời trang hot nhất với mức giá giảm cực sốc trong chương trình Khuyến Mãi Đặc Biệt của chúng tôi.</p><p>Hàng ngàn mặt hàng đang chờ đón bạn. Nhanh tay truy cập cửa hàng ngay trước khi hết hàng!</p><p>Trân trọng,<br>Đội ngũ Clothes Shop</p>"
            },
            welcome: {
                subject: "Chào mừng [FULL_NAME] gia nhập gia đình Clothes Shop \uD83C\uDF89",
                content: "<h2>Xin chào người bạn mới [FULL_NAME],</h2><p>Rất vui vì bạn đã đăng ký tài khoản tại Clothes Shop. Chúng tôi cam kết mang đến cho bạn những trải nghiệm mua sắm thời trang tuyệt vời nhất.</p><p>Hãy bắt đầu khám phá các bộ sưu tập mới nhất của chúng tôi ngay hôm nay!</p><p>Trân trọng,<br>Đội ngũ Clothes Shop</p>"
            },
            care: {
                subject: "Clothes Shop nhớ bạn! Tặng [FULL_NAME] món quà nhỏ \uD83C\uDF81",
                content: "<h2>Xin chào [FULL_NAME],</h2><p>Đã lâu rồi chúng ta không gặp nhau. Clothes Shop vừa cập nhật thêm rất nhiều mẫu mã mới phù hợp với phong cách của bạn.</p><p>Đừng quên ghé thăm cửa hàng để xem có gì mới nhé. Cảm ơn bạn vì đã luôn ủng hộ chúng tôi trong suốt thời gian qua.</p><p>Trân trọng,<br>Đội ngũ Clothes Shop</p>"
            }
        };

        const templateSelector = document.getElementById('templateSelector');
        const emailSubject = document.getElementById('emailSubject');

        templateSelector.addEventListener('change', function() {
            const val = this.value;
            if (val && templates[val]) {
                emailSubject.value = templates[val].subject;
                if (window.tinymce && tinymce.get('tinymce-editor')) {
                    tinymce.get('tinymce-editor').setContent(templates[val].content);
                }
            } else {
                emailSubject.value = "";
                if (window.tinymce && tinymce.get('tinymce-editor')) {
                    tinymce.get('tinymce-editor').setContent("");
                }
            }
        });

        // Initialize TinyMCE
        if (window.tinymce) {
            tinymce.init({
                selector: '#tinymce-editor',
                height: 400,
                menubar: false,
                plugins: [
                    'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                    'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                    'insertdatetime', 'media', 'table', 'help', 'wordcount'
                ],
                toolbar: 'undo redo | formatselect | ' +
                    'bold italic backcolor | alignleft aligncenter ' +
                    'alignright alignjustify | bullist numlist outdent indent | ' +
                    'removeformat | help',
                content_style: 'body { font-family:-apple-system,BlinkMacSystemFont,San Francisco,Segoe UI,Roboto,Helvetica Neue,sans-serif; font-size:14px }'
            });
        }
    });

    function previewEmail() {
        if (!window.tinymce || !tinymce.get('tinymce-editor')) {
            alert('Trình soạn thảo chưa tải xong!');
            return;
        }

        let content = tinymce.get('tinymce-editor').getContent();
        if (!content.trim()) {
            alert('Vui lòng nhập nội dung email trước khi xem trước!');
            return;
        }

        // Thay thế thử [FULL_NAME] bằng một tên mẫu để Preview
        content = content.replace(/\[FULL_NAME\]/g, "Nguyễn Văn A");

        // Set content
        document.getElementById('previewContent').innerHTML = content;

        // Check voucher
        const voucherSelect = document.querySelector('select[name="voucherId"]');
        const voucherOption = voucherSelect.options[voucherSelect.selectedIndex];
        const previewVoucher = document.getElementById('previewVoucher');

        if (voucherSelect.value) {
            // "CODE - Giảm 20%"
            const text = voucherOption.text.trim();
            const parts = text.split(' - ');
            document.getElementById('previewVoucherCode').textContent = parts[0];
            document.getElementById('previewVoucherDesc').textContent = parts[1] || 'Mã giảm giá đặc biệt';
            previewVoucher.style.display = 'block';
        } else {
            previewVoucher.style.display = 'none';
        }

        // Show Modal bằng Native JS (bỏ qua bootstrap.Modal lỗi)
        const modal = document.getElementById('previewModal');
        modal.classList.add('show');
        modal.style.display = 'block';
        modal.removeAttribute('aria-hidden');
        modal.setAttribute('aria-modal', 'true');
        modal.setAttribute('role', 'dialog');
        
        if (!document.querySelector('.modal-backdrop')) {
            const backdrop = document.createElement('div');
            backdrop.className = 'modal-backdrop fade show';
            document.body.appendChild(backdrop);
        }
        document.body.classList.add('modal-open');
    }
    
    // Close modal
    document.addEventListener("click", function(e) {
        if (e.target.hasAttribute("data-bs-dismiss") || e.target.id === "previewModal") {
            const modal = document.getElementById('previewModal');
            modal.classList.remove('show');
            modal.style.display = 'none';
            modal.setAttribute('aria-hidden', 'true');
            modal.removeAttribute('aria-modal');
            modal.removeAttribute('role');
            
            const backdrop = document.querySelector('.modal-backdrop');
            if (backdrop) backdrop.remove();
            document.body.classList.remove('modal-open');
        }
    });
</script>

<%@include file="../components/footer.jsp"%>
