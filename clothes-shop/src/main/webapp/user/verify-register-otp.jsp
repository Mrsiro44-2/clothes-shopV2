<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="./components/header.jsp" %>
<div class="section">
    <div class="container">
        <div class="row" style="margin-bottom: 80px; margin-top: 30px">
            <div class="col-md-6">
                <img src="./user/img/signUp.png" alt="Xác thực OTP Đăng ký" style="width: 100%" />
            </div>
            <div class="col-md-6" style="padding: 100px; margin-top: 70px">
                <h2>Xác thực Đăng ký</h2>
                <p>Nhập mã OTP 6 số đã được gửi tới email đăng ký của bạn. Mã sẽ hết hạn sau 10 phút.</p>
                <form action="${ctx}/verify-register-otp" method="post">
                    <div style="width: 400px; margin-bottom: 20px; margin-top: 20px">
                        <div class="otp-container" style="display: flex; justify-content: space-between;">
                            <input type="text" class="input otp-box" maxlength="1" style="width: 50px; height: 60px; font-size: 24px; text-align: center; border-radius: 8px; border: 1px solid #e4e7ed;" autofocus>
                            <input type="text" class="input otp-box" maxlength="1" style="width: 50px; height: 60px; font-size: 24px; text-align: center; border-radius: 8px; border: 1px solid #e4e7ed;">
                            <input type="text" class="input otp-box" maxlength="1" style="width: 50px; height: 60px; font-size: 24px; text-align: center; border-radius: 8px; border: 1px solid #e4e7ed;">
                            <input type="text" class="input otp-box" maxlength="1" style="width: 50px; height: 60px; font-size: 24px; text-align: center; border-radius: 8px; border: 1px solid #e4e7ed;">
                            <input type="text" class="input otp-box" maxlength="1" style="width: 50px; height: 60px; font-size: 24px; text-align: center; border-radius: 8px; border: 1px solid #e4e7ed;">
                            <input type="text" class="input otp-box" maxlength="1" style="width: 50px; height: 60px; font-size: 24px; text-align: center; border-radius: 8px; border: 1px solid #e4e7ed;">
                        </div>
                        <input type="hidden" name="otp" id="finalOtp" required>
                    </div>

                    <script>
                        document.addEventListener('DOMContentLoaded', function() {
                            const otpBoxes = document.querySelectorAll('.otp-box');
                            const finalOtpInput = document.getElementById('finalOtp');

                            otpBoxes.forEach((box, index) => {
                                box.addEventListener('input', function(e) {
                                    if (e.target.value.length === 1 && index < otpBoxes.length - 1) {
                                        otpBoxes[index + 1].focus();
                                    }
                                    updateFinalOtp();
                                });

                                box.addEventListener('keydown', function(e) {
                                    if (e.key === 'Backspace' && e.target.value.length === 0 && index > 0) {
                                        otpBoxes[index - 1].focus();
                                    }
                                    if (e.key === 'ArrowLeft' && index > 0) {
                                        otpBoxes[index - 1].focus();
                                    }
                                    if (e.key === 'ArrowRight' && index < otpBoxes.length - 1) {
                                        otpBoxes[index + 1].focus();
                                    }
                                });
                                
                                box.addEventListener('paste', function(e) {
                                    e.preventDefault();
                                    const pasteData = (e.clipboardData || window.clipboardData).getData('text');
                                    if (pasteData.length > 0) {
                                        const chars = pasteData.replace(/[^0-9]/g, '').split('');
                                        let curr = index;
                                        for(let i = 0; i < chars.length && curr < otpBoxes.length; i++) {
                                            otpBoxes[curr].value = chars[i];
                                            curr++;
                                        }
                                        if (curr < otpBoxes.length) {
                                            otpBoxes[curr].focus();
                                        } else {
                                            otpBoxes[otpBoxes.length - 1].focus();
                                        }
                                        updateFinalOtp();
                                    }
                                });
                                
                                box.addEventListener('focus', function() {
                                    this.style.borderColor = '#DB4444';
                                    this.style.boxShadow = '0 0 5px rgba(219,68,68,0.5)';
                                });
                                
                                box.addEventListener('blur', function() {
                                    this.style.borderColor = '#e4e7ed';
                                    this.style.boxShadow = 'none';
                                });
                            });

                            function updateFinalOtp() {
                                let otpVal = '';
                                otpBoxes.forEach(b => otpVal += b.value);
                                finalOtpInput.value = otpVal;
                            }
                            
                            const form = document.querySelector('form[action="${ctx}/verify-register-otp"]');
                            if (form) {
                                form.addEventListener('submit', function(e) {
                                    updateFinalOtp();
                                    if (finalOtpInput.value.length !== 6) {
                                        e.preventDefault();
                                        if (typeof Swal !== 'undefined') {
                                            Swal.fire({
                                                icon: 'warning',
                                                title: 'Thông báo',
                                                text: 'Vui lòng nhập đủ 6 mã xác nhận',
                                                confirmButtonColor: '#DB4444'
                                            });
                                        } else {
                                            alert('Vui lòng nhập đủ 6 mã xác nhận');
                                        }
                                    }
                                });
                            }
                        });
                    </script>
                    <div>
                        <div style="margin-top: 40px; margin-bottom: 20px;">
                            <button
                                class="primary-btn"
                                type="submit"
                                >
                                Xác thực OTP
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
                        <c:if test="${not empty successMessage}">
                            <script>
                                document.addEventListener('DOMContentLoaded', function() {
                                    if (typeof Swal !== 'undefined') {
                                        Swal.fire({
                                            icon: 'success',
                                            title: 'Thành công',
                                            text: '${successMessage}',
                                            confirmButtonColor: '#DB4444'
                                        });
                                    }
                                });
                            </script>
                        </c:if>
                        <div class="text-left">
                            <p>Không nhận được hoặc hết hạn? <a href="${ctx}/resend-register-otp" style="color: #db4444;">Gửi lại OTP</a></p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@include file="./components/footer.jsp" %>
