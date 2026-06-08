<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="pageTitle" value="Bảng điều khiển" scope="request"/>
<%@include file="components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">
        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">Bảng điều khiển</h2>
                </div>
            </div>
        </div>

        <jsp:include page="components/flash.jsp"/>

        <div class="card mb-4">
            <div class="card-body">
                <form action="${ctx}/admin/dashboard" method="GET" class="row gx-3 gy-2 align-items-center">
                    <div class="col-sm-3">
                        <label class="form-label">Từ ngày</label>
                        <input type="date" class="form-control" name="startDate" value="${startDate}">
                    </div>
                    <div class="col-sm-3">
                        <label class="form-label">Đến ngày</label>
                        <input type="date" class="form-control" name="endDate" value="${endDate}">
                    </div>
                    <div class="col-sm-2">
                        <label class="form-label">Top hiển thị</label>
                        <select class="form-select" name="topLimit">
                            <option value="5" ${topLimit == 5 ? 'selected' : ''}>Top 5</option>
                            <option value="10" ${topLimit == 10 ? 'selected' : ''}>Top 10</option>
                            <option value="20" ${topLimit == 20 ? 'selected' : ''}>Top 20</option>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" class="btn btn-primary w-100">Lọc dữ liệu</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="row row-deck row-cards mb-4">
            <div class="col-sm-6 col-lg-3">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="subheader">Tổng doanh thu</div>
                        </div>
                        <div class="h1 mb-0 mt-2 text-success">
                            <fmt:formatNumber value="${summary.totalRevenue}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="subheader">Tổng đơn hàng</div>
                        </div>
                        <div class="h1 mb-0 mt-2">${summary.totalOrders}</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="subheader">Đơn hoàn thành</div>
                        </div>
                        <div class="h1 mb-0 mt-2 text-success">${summary.completedOrders}</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="subheader">Đơn chờ xử lý</div>
                        </div>
                        <div class="h1 mb-0 mt-2 text-warning">${summary.pendingOrders}</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row row-cards mb-4">
            <!-- Tương tác -->
            <div class="col-sm-6 col-lg-4">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="subheader">Số Đánh giá Sản phẩm</div>
                        </div>
                        <div class="h1 mb-0 mt-2 text-info">${interactions.totalFeedbacks}</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-4">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="subheader">Trung bình sao Đánh giá</div>
                        </div>
                        <div class="h1 mb-0 mt-2 text-warning"><fmt:formatNumber value="${interactions.avgStar}" maxFractionDigits="1"/> / 5.0 ★</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-4">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="subheader">Bình luận Blog mới</div>
                        </div>
                        <div class="h1 mb-0 mt-2 text-indigo">${interactions.totalComments}</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Thống kê Voucher -->
        <div class="row row-cards mb-4">
            <div class="col-sm-6 col-lg-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="subheader text-azure">Số lượt dùng Voucher</div>
                        </div>
                        <div class="h1 mb-0 mt-2 text-azure">${summary.vouchersUsed} lượt</div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-6">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="subheader text-azure">Tổng chi phí Voucher</div>
                        </div>
                        <div class="h1 mb-0 mt-2 text-azure">
                            <fmt:formatNumber value="${summary.voucherDiscountTotal}" type="currency" currencyCode="VND" maxFractionDigits="0"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Biểu đồ -->
        <div class="row row-cards mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Biểu đồ doanh thu</h3>
                    </div>
                    <div class="card-body">
                        <div id="chart-revenue" style="height: 300px;"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row row-cards">
            <!-- Sản phẩm bán chạy -->
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Sản phẩm bán chạy nhất</h3>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-vcenter card-table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Đã bán</th>
                                    <th>Doanh thu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${bestSelling}" var="p">
                                    <tr>
                                        <td>
                                            <div class="d-flex py-1 align-items-center">
                                                <span class="avatar me-2" style="background-image: url('${fn:startsWith(p.imgProduct, 'http') ? p.imgProduct : ctx.concat('/uploads/product/').concat(p.imgProduct)}')"></span>
                                                <div class="flex-fill">
                                                    <div class="font-weight-medium">${p.nameProduct}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${p.totalSold}</td>
                                        <td><fmt:formatNumber value="${p.totalRevenue}" type="currency" currencyCode="VND" maxFractionDigits="0"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Sản phẩm bán chậm -->
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Sản phẩm bán chậm nhất</h3>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-vcenter card-table">
                            <thead>
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th>Đã bán</th>
                                    <th>Doanh thu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${worstSelling}" var="p">
                                    <tr>
                                        <td>
                                            <div class="d-flex py-1 align-items-center">
                                                <span class="avatar me-2" style="background-image: url('${fn:startsWith(p.imgProduct, 'http') ? p.imgProduct : ctx.concat('/uploads/product/').concat(p.imgProduct)}')"></span>
                                                <div class="flex-fill">
                                                    <div class="font-weight-medium">${p.nameProduct}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${p.totalSold}</td>
                                        <td><fmt:formatNumber value="${p.totalRevenue}" type="currency" currencyCode="VND" maxFractionDigits="0"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Khách hàng chi tiêu nhiều -->
            <div class="col-12 mt-4">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Khách hàng chi tiêu nhiều nhất</h3>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-vcenter card-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Khách hàng</th>
                                    <th>Email</th>
                                    <th>Số đơn hàng</th>
                                    <th>Tổng chi tiêu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${topCustomers}" var="c" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td><strong>${c.customerName}</strong></td>
                                        <td>${c.email}</td>
                                        <td>${c.totalOrders}</td>
                                        <td><fmt:formatNumber value="${c.totalSpent}" type="currency" currencyCode="VND" maxFractionDigits="0"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var options = {
            chart: {
                type: 'line',
                height: 300,
                toolbar: { show: false }
            },
            series: [{
                name: 'Doanh thu',
                data: ${chartRevenues}
            }],
            xaxis: {
                categories: ${chartDates},
            },
            stroke: {
                curve: 'smooth',
                width: 3
            },
            colors: ['#206bc4'],
            dataLabels: {
                enabled: false
            },
            tooltip: {
                y: {
                    formatter: function (val) {
                        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val);
                    }
                }
            }
        }
        var chart = new ApexCharts(document.querySelector("#chart-revenue"), options);
        chart.render();
    });
</script>

<%@include file="components/footer.jsp"%>
