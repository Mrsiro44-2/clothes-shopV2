<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@include file="./components/header.jsp" %>
<div id="breadcrumb" class="section">
    <div class="container">
        <ul class="breadcrumb-tree">
            <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
            <li class="active">Đơn hàng</li>
        </ul>
    </div>
</div>
<style>
    .orders-tabs {
        display: flex;
        gap: 8px;
        margin: 20px 0;
        list-style: none;
        padding: 0;
    }
    .orders-tabs li a {
        display: block;
        padding: 8px 20px;
        border-radius: 20px;
        background: #f1f5f9;
        color: #475569;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s;
    }
    .orders-tabs li a:hover {
        background: #e2e8f0;
    }
    .orders-tabs li.active a {
        background: var(--mb-primary, #DB4444);
        color: #ffffff !important;
    }
    .orders-card {
        background: #ffffff;
        border: 1px solid #f0f2f5;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.02);
        padding: 24px;
        overflow-x: auto;
        margin-bottom: 30px;
    }
    .status-tag {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 11px;
        font-weight: 700;
        text-align: center;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .status-pending { background-color: #fef3c7; color: #b45309; }
    .status-paid { background-color: #ccfbf1; color: #0f766e; }
    .status-prepared { background-color: #f3e8ff; color: #6b21a8; }
    .status-delivered-courier { background-color: #e0e7ff; color: #4338ca; }
    .status-shipping { background-color: #dbeafe; color: #1d4ed8; }
    .status-cancelled { background-color: #fee2e2; color: #b91c1c; }
    .status-refunded { background-color: #fce7f3; color: #be185d; }
    .status-completed { background-color: #d1fae5; color: #047857; }
    
    .payment-tag {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 6px;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .payment-vnpay { background-color: #e0f2fe; color: #0369a1; }
    .payment-cod { background-color: #f1f5f9; color: #475569; }

    .btn-order-action {
        display: inline-block;
        padding: 6px 14px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 700;
        text-decoration: none;
        background: #ffffff;
        color: #475569;
        border: 1px solid #cbd5e1;
        transition: all 0.2s;
        cursor: pointer;
    }
    .btn-order-action:hover {
        background: #f8fafc;
        color: #1e293b;
        border-color: #94a3b8;
        text-decoration: none;
    }
    .btn-order-action.cancel {
        background: #fee2e2;
        color: #b91c1c;
        border-color: #fca5a5;
        margin-left: 6px;
    }
    .btn-order-action.cancel:hover {
        background: #fecaca;
        color: #991b1b;
        border-color: #f87171;
    }
    /* Modal Styles */
    .mb-modal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; }
    .mb-modal.active { display: flex; }
    .mb-modal-content { background: #fff; width: 100%; max-width: 450px; border-radius: 12px; padding: 25px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); }
    .mb-modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
    .mb-modal-title { font-size: 18px; font-weight: 700; margin: 0; }
    .mb-modal-close { background: none; border: none; font-size: 24px; cursor: pointer; color: #888; }
    .mb-field { margin-bottom: 15px; }
    .mb-field label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px; color: #444; }
    .mb-field select { width: 100%; height: 42px; border: 1px solid #ddd; border-radius: 6px; padding: 0 12px; }
    .btn-submit { background-color: var(--mb-primary, #DB4444); color: #fff; border: none; padding: 12px; border-radius: 6px; width: 100%; font-weight: 600; cursor: pointer; }
    .btn-submit:hover { background-color: #c41e3a; }
</style>

<div class="section">
    <div class="container">
        <h2 class="title">Đơn hàng của tôi</h2>
        <ul class="orders-tabs">
            <li class="${tab == 'all' || empty tab ? 'active' : ''}"><a href="${pageContext.request.contextPath}/orders?tab=all">Tất cả</a></li>
            <li class="${tab == 'cancelled' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/orders?tab=cancelled">Đã hủy</a></li>
            <li class="${tab == 'reviews' ? 'active' : ''}"><a href="${pageContext.request.contextPath}/orders?tab=reviews">Đánh giá</a></li>
        </ul>
        <c:if test="${tab != 'reviews'}">
            <c:choose>
                <c:when test="${empty orders}">
                    <p style="color: #8d99ae; font-size: 15px; margin: 20px 0;">Không có đơn hàng.</p>
                </c:when>
                <c:otherwise>
                    <div class="orders-card">
                        <table class="table table-striped table-hover" style="border: none; margin: 0; background: #fff;">
                            <thead style="background-color: #f8fafc; border-bottom: 2px solid #eaeaea;">
                                <tr>
                                    <th style="padding: 15px 12px; font-weight:700; color:#475569; border: none;">Mã đơn</th>
                                    <th style="padding: 15px 12px; font-weight:700; color:#475569; border: none;">Ngày đặt</th>
                                    <th style="padding: 15px 12px; font-weight:700; color:#475569; border: none;">Người nhận</th>
                                    <th style="padding: 15px 12px; font-weight:700; color:#475569; border: none;">Địa chỉ giao hàng</th>
                                    <th style="padding: 15px 12px; font-weight:700; color:#475569; border: none;">Thanh toán</th>
                                    <th style="padding: 15px 12px; font-weight:700; color:#475569; border: none;">Tổng tiền</th>
                                    <th style="padding: 15px 12px; font-weight:700; color:#475569; border: none;">Trạng thái</th>
                                    <th style="padding: 15px 12px; font-weight:700; color:#475569; text-align: center; border: none;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orders}" var="o">
                                    <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;">
                                        <td style="padding: 15px 12px; font-weight: 700; color: #1e293b; border: none;">#${o.ID}</td>
                                        <td style="padding: 15px 12px; color: #475569; border: none;"><fmt:formatDate value="${o.dateOrder}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td style="padding: 15px 12px; font-weight: 600; color: #334155; border: none;">${o.customerName}</td>
                                        <td style="padding: 15px 12px; color: #64748b; font-size: 13px; max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; border: none;" title="${o.address}">${o.address}</td>
                                        <td style="padding: 15px 12px; font-weight: 500; color: #475569; border: none;">
                                            <c:choose>
                                                <c:when test="${o.payment == 1}">
                                                    <span class="payment-tag payment-vnpay">PayOS</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="payment-tag payment-cod">COD</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="padding: 15px 12px; font-weight: 700; color: #DB4444; border: none;">${currency.currencyFormat(o.total)}</td>
                                        <td style="padding: 15px 12px; border: none;">
                                            <c:choose>
                                                <c:when test="${o.status == 0}">
                                                    <span class="status-tag status-pending">Chờ xử lý</span>
                                                </c:when>
                                                <c:when test="${o.status == 4}">
                                                    <span class="status-tag status-paid">Đã thanh toán</span>
                                                </c:when>
                                                <c:when test="${o.status == 8}">
                                                    <span class="status-tag" style="background-color: #0dcaf0; color: #fff;">Đã duyệt</span>
                                                </c:when>
                                                <c:when test="${o.status == 5}">
                                                    <span class="status-tag status-prepared">Đã chuẩn bị hàng</span>
                                                </c:when>
                                                <c:when test="${o.status == 6}">
                                                    <span class="status-tag status-delivered-courier">Đã giao ĐVVC</span>
                                                </c:when>
                                                <c:when test="${o.status == 1}">
                                                    <span class="status-tag status-shipping">Đang giao</span>
                                                </c:when>
                                                <c:when test="${o.status == 2}">
                                                    <span class="status-tag status-cancelled">Đã hủy</span>
                                                    <c:if test="${not empty o.cancelReason}">
                                                        <div style="font-size: 12px; color: #991b1b; margin-top: 5px;">Lý do: ${o.cancelReason}</div>
                                                    </c:if>
                                                </c:when>
                                                <c:when test="${o.status == 7}">
                                                    <span class="status-tag status-refunded">Đã hoàn tiền</span>
                                                    <c:if test="${not empty o.cancelReason}">
                                                        <div style="font-size: 12px; color: #991b1b; margin-top: 5px;">Lý do: ${o.cancelReason}</div>
                                                    </c:if>
                                                </c:when>
                                                <c:when test="${o.status == 3}">
                                                    <span class="status-tag status-completed">Hoàn thành</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-tag">Khác</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="padding: 15px 12px; text-align: center; white-space: nowrap; border: none;">
                                            <a href="${ctx}/orders/detail?id=${o.ID}" class="btn-order-action">Chi tiết</a>
                                            <c:if test="${o.status == 0}">
                                                <a href="javascript:void(0)" onclick="openCancelModal('${o.ID}')" class="btn-order-action cancel">Hủy</a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>
        <c:if test="${tab == 'reviews'}">
            <!-- Review Section Custom Styling -->
            <style>
                .review-section-title {
                    font-size: 18px;
                    font-weight: 700;
                    color: #1e293b;
                    margin-top: 30px;
                    margin-bottom: 15px;
                    border-bottom: 2px solid #f1f5f9;
                    padding-bottom: 8px;
                }
                .review-card {
                    background: #fff;
                    border: 1px solid #eaeaea;
                    border-radius: 12px;
                    padding: 20px;
                    margin-bottom: 20px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.02);
                    display: flex;
                    flex-direction: column;
                    transition: transform 0.2s, box-shadow 0.2s;
                }
                .review-card:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 16px rgba(0,0,0,0.04);
                }
                .review-product-info {
                    display: flex;
                    align-items: center;
                    margin-bottom: 15px;
                }
                .review-product-img {
                    width: 70px;
                    height: 70px;
                    object-fit: cover;
                    border-radius: 8px;
                    border: 1px solid #e2e8f0;
                    margin-right: 15px;
                    flex-shrink: 0;
                    background: #f8fafc;
                }
                .review-product-details {
                    flex-grow: 1;
                }
                .review-product-name {
                    font-size: 15px;
                    font-weight: 600;
                    color: #1e293b;
                    margin: 0 0 4px 0;
                }
                .review-meta {
                    font-size: 12px;
                    color: #64748b;
                    margin: 0;
                }
                .review-stars-static {
                    color: #FFD700;
                    font-size: 16px;
                    margin-bottom: 8px;
                    display: inline-block;
                }
                .review-feedback-text {
                    font-size: 14px;
                    color: #334155;
                    margin: 0;
                    line-height: 1.5;
                    background: #f8fafc;
                    padding: 12px 16px;
                    border-radius: 8px;
                    border-left: 3px solid #cbd5e1;
                }
                
                /* Interactive Star Rating Selector */
                .star-rating-selector {
                    display: inline-flex;
                    margin-bottom: 12px;
                    gap: 6px;
                }
                .star-rating-selector .star-icon {
                    font-size: 26px;
                    cursor: pointer;
                    color: #e2e8f0;
                    transition: color 0.15s ease, transform 0.1s ease;
                }
                .star-rating-selector .star-icon:hover {
                    transform: scale(1.15);
                }
                .star-rating-selector .star-icon.selected {
                    color: #FFD700;
                }
                .review-edit-btn {
                    background: #f1f5f9;
                    border: none;
                    color: #475569;
                    padding: 6px 12px;
                    font-size: 13px;
                    font-weight: 600;
                    border-radius: 6px;
                    cursor: pointer;
                    transition: all 0.2s;
                    margin-top: 10px;
                    align-self: flex-start;
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                }
                .review-edit-btn:hover {
                    background: #e2e8f0;
                    color: #1e293b;
                }
                .edit-review-form-container {
                    display: none;
                    margin-top: 15px;
                    padding-top: 15px;
                    border-top: 1px dashed #e2e8f0;
                }
                
                /* Form fields styling */
                .review-comment-textarea {
                    border-radius: 8px;
                    border: 1px solid #cbd5e1;
                    padding: 12px;
                    font-size: 14px;
                    width: 100%;
                    resize: vertical;
                    transition: border-color 0.2s;
                    margin-bottom: 10px;
                }
                .review-comment-textarea:focus {
                    border-color: #DB4444;
                    outline: none;
                }
                .review-submit-btn {
                    background-color: #DB4444;
                    color: #fff;
                    border: none;
                    font-weight: 600;
                    padding: 8px 18px;
                    border-radius: 6px;
                    cursor: pointer;
                    transition: background-color 0.2s;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                }
                .review-submit-btn:hover {
                    background-color: #b91c1c;
                }
            </style>

            <div class="review-section-title">Đánh giá của bạn</div>
            <c:if test="${empty myReviews}">
                <p style="color:#8d99ae; font-size:15px; margin: 20px 0;">Bạn chưa đánh giá sản phẩm nào.</p>
            </c:if>
            <c:forEach items="${myReviews}" var="r">
                <div class="review-card">
                    <div class="review-product-info">
                        <img class="review-product-img" src="${imgUrl.resolve(getDao.getProduct(r.productID).mainImg, ctx)}" onerror="this.src='${ctx}/user/img/default-product.png'; this.onerror=null;" alt="${r.productName}"/>
                        <div class="review-product-details">
                            <h4 class="review-product-name">${r.productName}</h4>
                            <p class="review-meta">Đánh giá vào: <fmt:formatDate value="${r.datePost}" pattern="dd/MM/yyyy HH:mm"/></p>
                        </div>
                    </div>
                    <div>
                        <div class="review-stars-static">
                            <c:forEach begin="1" end="${r.star}">★</c:forEach>
                            <c:forEach begin="1" end="${5 - r.star}">☆</c:forEach>
                        </div>
                        <p class="review-feedback-text">${r.feedback}</p>
                    </div>
                    <button class="review-edit-btn" onclick="toggleEditForm(${r.ID})">
                        <i class="fa fa-pencil"></i> Chỉnh sửa đánh giá
                    </button>
                    
                    <div id="edit-form-${r.ID}" class="edit-review-form-container">
                        <form action="${ctx}/orders/review" method="post">
                            <input type="hidden" name="productId" value="${r.productID}"/>
                            <div class="form-group" style="margin-bottom: 12px;">
                                <label style="font-weight: 600; margin-bottom: 4px; display: block; color: #475569;">Số sao đánh giá:</label>
                                <div class="star-rating-selector" data-target-input="edit-star-${r.ID}">
                                    <i class="fa fa-star star-icon" data-value="1"></i>
                                    <i class="fa fa-star star-icon" data-value="2"></i>
                                    <i class="fa fa-star star-icon" data-value="3"></i>
                                    <i class="fa fa-star star-icon" data-value="4"></i>
                                    <i class="fa fa-star star-icon" data-value="5"></i>
                                </div>
                                <input type="hidden" name="star" id="edit-star-${r.ID}" value="${r.star}"/>
                            </div>
                            <div class="form-group" style="margin-bottom: 12px;">
                                <label style="font-weight: 600; margin-bottom: 4px; display: block; color: #475569;">Nhận xét của bạn:</label>
                                <textarea name="comment" class="review-comment-textarea" rows="3" required placeholder="Chia sẻ cảm nhận của bạn về sản phẩm...">${r.feedback}</textarea>
                            </div>
                            <div style="display: flex; gap: 10px;">
                                <button type="submit" class="review-submit-btn">Cập nhật đánh giá</button>
                                <button type="button" class="btn btn-default" onclick="toggleEditForm(${r.ID})" style="border-radius:6px; font-weight:600; padding: 8px 18px;">Hủy</button>
                            </div>
                        </form>
                    </div>
                </div>
            </c:forEach>

            <div class="review-section-title" style="margin-top: 40px;">Chờ đánh giá</div>
            <c:if test="${empty reviewableProducts}">
                <p style="color:#8d99ae; font-size:15px; margin: 20px 0;">Không có sản phẩm nào đang chờ đánh giá.</p>
            </c:if>
            <c:forEach items="${reviewableProducts}" var="rp" varStatus="vs">
                <div class="review-card">
                    <div class="review-product-info">
                        <img class="review-product-img" src="${imgUrl.resolve(getDao.getProduct(rp.productId).mainImg, ctx)}" onerror="this.src='${ctx}/user/img/default-product.png'; this.onerror=null;" alt="${rp.productName}"/>
                        <div class="review-product-details">
                            <h4 class="review-product-name">${rp.productName}</h4>
                            <p class="review-meta">Đơn hàng: <strong>#${rp.billId}</strong></p>
                        </div>
                    </div>
                    <form action="${ctx}/orders/review" method="post">
                        <input type="hidden" name="productId" value="${rp.productId}"/>
                        <div class="form-group" style="margin-bottom: 12px;">
                            <label style="font-weight: 600; margin-bottom: 4px; display: block; color: #475569;">Chọn số sao:</label>
                            <div class="star-rating-selector" data-target-input="new-star-${vs.index}">
                                <i class="fa fa-star star-icon" data-value="1"></i>
                                <i class="fa fa-star star-icon" data-value="2"></i>
                                <i class="fa fa-star star-icon" data-value="3"></i>
                                <i class="fa fa-star star-icon" data-value="4"></i>
                                <i class="fa fa-star star-icon" data-value="5"></i>
                            </div>
                            <input type="hidden" name="star" id="new-star-${vs.index}" value="5"/>
                        </div>
                        <div class="form-group" style="margin-bottom: 12px;">
                            <label style="font-weight: 600; margin-bottom: 4px; display: block; color: #475569;">Nhận xét của bạn:</label>
                            <textarea name="comment" class="review-comment-textarea" rows="3" placeholder="Chia sẻ cảm nhận của bạn về sản phẩm..." required></textarea>
                        </div>
                        <button type="submit" class="review-submit-btn">Gửi đánh giá</button>
                    </form>
                </div>
            </c:forEach>
        </c:if>
    </div>
</div>

<!-- Modal Hủy Đơn -->
<div id="cancelModal" class="mb-modal">
    <div class="mb-modal-content">
        <div class="mb-modal-header">
            <h3 class="mb-modal-title">Lý do hủy đơn hàng</h3>
            <button class="mb-modal-close" onclick="closeCancelModal()">&times;</button>
        </div>
        <form id="cancelForm" action="${pageContext.request.contextPath}/orders/cancel" method="post">
            <input type="hidden" name="id" id="cancel_order_id" value=""/>
            <div class="mb-field">
                <label>Vui lòng chọn lý do hủy:</label>
                <select name="cancelReason" required onchange="toggleCancelReasonOther(this)">
                    <option value="">-- Chọn lý do --</option>
                    <option value="Tôi muốn cập nhật địa chỉ/sđt nhận hàng">Tôi muốn cập nhật địa chỉ/sđt nhận hàng</option>
                    <option value="Tôi muốn thêm/thay đổi mã giảm giá">Tôi muốn thêm/thay đổi mã giảm giá</option>
                    <option value="Tôi muốn thay đổi sản phẩm (Kích thước, màu sắc, số lượng,...)">Tôi muốn thay đổi sản phẩm (Kích thước, màu sắc, số lượng,...)</option>
                    <option value="Thủ tục thanh toán rắc rối">Thủ tục thanh toán rắc rối</option>
                    <option value="Tôi tìm thấy chỗ khác rẻ hơn">Tôi tìm thấy chỗ khác rẻ hơn</option>
                    <option value="Tôi không có nhu cầu mua nữa">Tôi không có nhu cầu mua nữa</option>
                    <option value="Lý do khác">Lý do khác</option>
                </select>
                <textarea name="cancelReasonOther" id="cancelReasonOther" class="input" placeholder="Nhập lý do khác..." style="display:none; margin-top: 10px; width: 100%; padding: 10px; resize: vertical;" rows="3" maxlength="200"></textarea>
            </div>
            <button type="submit" class="btn-submit">Xác nhận hủy</button>
        </form>
    </div>
</div>

<script>
    function toggleEditForm(id) {
        var form = document.getElementById('edit-form-' + id);
        if (form.style.display === 'block') {
            form.style.display = 'none';
        } else {
            form.style.display = 'block';
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        document.querySelectorAll('.star-rating-selector').forEach(function(container) {
            var stars = container.querySelectorAll('.star-icon');
            var inputId = container.getAttribute('data-target-input');
            var input = document.getElementById(inputId);
            var initialValue = parseInt(input.value) || 5;

            // Set initial state
            updateStars(stars, initialValue);

            stars.forEach(function(star) {
                star.addEventListener('mouseover', function() {
                    var value = parseInt(this.getAttribute('data-value'));
                    updateStars(stars, value);
                });

                star.addEventListener('mouseout', function() {
                    var value = parseInt(input.value) || 5;
                    updateStars(stars, value);
                });

                star.addEventListener('click', function() {
                    var value = parseInt(this.getAttribute('data-value'));
                    input.value = value;
                    updateStars(stars, value);
                });
            });
        });

        function updateStars(stars, value) {
            stars.forEach(function(star) {
                var starVal = parseInt(star.getAttribute('data-value'));
                if (starVal <= value) {
                    star.classList.add('selected');
                    star.classList.remove('fa-star-o');
                    star.classList.add('fa-star');
                } else {
                    star.classList.remove('selected');
                    star.classList.remove('fa-star');
                    star.classList.add('fa-star-o');
                }
            });
        }
    });

    function openCancelModal(id) {
        document.getElementById('cancel_order_id').value = id;
        document.getElementById('cancelModal').classList.add('active');
        document.getElementById('cancelForm').reset();
        document.getElementById('cancelReasonOther').style.display = 'none';
        document.getElementById('cancelReasonOther').required = false;
    }
    function closeCancelModal() {
        document.getElementById('cancelModal').classList.remove('active');
    }
    function toggleCancelReasonOther(selectElem) {
        var otherInput = document.getElementById('cancelReasonOther');
        if (selectElem.value === 'Lý do khác') {
            otherInput.style.display = 'block';
            otherInput.required = true;
        } else {
            otherInput.style.display = 'none';
            otherInput.required = false;
            otherInput.value = '';
        }
    }
</script>

<c:if test="${not empty sessionScope.orderFlash}">
    <script>
        Swal.fire({
            icon: '${sessionScope.orderFlashType == "success" ? "success" : "error"}',
            title: 'Đơn hàng',
            text: '${sessionScope.orderFlash}',
            confirmButtonColor: '#D10024'
        });
    </script>
    <c:remove var="orderFlash" scope="session"/>
    <c:remove var="orderFlashType" scope="session"/>
</c:if>

<%@include file="./components/footer.jsp" %>

