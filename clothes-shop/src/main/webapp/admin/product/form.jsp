<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="isEdit" value="${not empty product}"/>
<jsp:useBean id="imgUrl" class="Utils.ImageUrl" scope="application"/>
<c:set var="pageTitle" value="${isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm'}" scope="request"/>
<%@include file="../components/header.jsp"%>

<div class="page-body">
    <div class="container-xl">

        <div class="page-header d-print-none mb-4">
            <div class="row align-items-center">
                <div class="col">
                    <a href="${ctx}/admin/products" class="btn btn-outline-secondary btn-sm mb-2">
                        ← Quay lại
                    </a>
                    <h2 class="page-title">${isEdit ? 'Sửa sản phẩm' : 'Thêm sản phẩm mới'}</h2>
                </div>
            </div>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible" role="alert">
                <div>${error}</div>
                <a class="btn-close" data-bs-dismiss="alert" aria-label="close"></a>
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <div class="card">
            <div class="card-body">
                <form action="${ctx}/admin/products/${isEdit ? 'edit/'.concat(product.ID) : 'add'}" method="post" enctype="multipart/form-data">
                    <div class="row">
                        <div class="col-md-8 mb-3">
                            <label class="form-label required" for="name">Tên sản phẩm</label>
                            <input type="text" class="form-control" id="name" name="name"
                                   value="${isEdit ? product.name : (not empty param.name ? param.name : '')}"
                                   placeholder="Áo sơ mi tay dài..." required maxlength="255"/>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label" for="model">Mã model</label>
                            <input type="text" class="form-control" id="model" name="model"
                                   value="${isEdit ? product.model : (not empty param.model ? param.model : '')}"
                                   placeholder="SM01" maxlength="50"/>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="mainImgFile">Tải lên hình ảnh chính</label>
                            <input type="file" class="form-control" id="mainImgFile" name="mainImgFile" accept="image/*"/>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label" for="mainImgUrl">Hoặc URL Hình ảnh chính</label>
                            <input type="text" class="form-control" id="mainImgUrl" name="mainImgUrl"
                                   value="${isEdit ? product.mainImg : (not empty param.mainImgUrl ? param.mainImgUrl : '')}"
                                   placeholder="https://example.com/image.jpg hoặc đường dẫn tương đối"/>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label" for="description">Mô tả sản phẩm</label>
                        <textarea class="form-control" id="description" name="description" rows="5">${isEdit ? product.description : (not empty param.description ? param.description : '')}</textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label required">Danh mục</label>
                            <select name="categoryID" id="categoryID" class="form-select select2-search" required>
                                <option value="">-- Chọn danh mục --</option>
                                <c:set var="cCat" value="${isEdit ? product.categoryID : (not empty param.categoryID ? param.categoryID : '')}"/>
                                <c:forEach items="${categories}" var="c">
                                    <option value="${c.ID}" data-group-id="${c.sizeGroupID}" ${cCat == c.ID ? 'selected' : ''}>${c.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label required">Thương hiệu</label>
                            <select name="brandID" class="form-select select2-search" required>
                                <option value="">-- Chọn thương hiệu --</option>
                                <c:set var="cBrand" value="${isEdit ? product.brandID : (not empty param.brandID ? param.brandID : '')}"/>
                                <c:forEach items="${brands}" var="b">
                                    <option value="${b.ID}" ${cBrand == b.ID ? 'selected' : ''}>${b.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label required">Nhà sản xuất</label>
                            <select name="producerID" class="form-select select2-search" required>
                                <option value="">-- Chọn nhà sản xuất --</option>
                                <c:set var="cProd" value="${isEdit ? product.producerID : (not empty param.producerID ? param.producerID : '')}"/>
                                <c:forEach items="${producers}" var="p">
                                    <option value="${p.ID}" ${cProd == p.ID ? 'selected' : ''}>${p.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Loại sản phẩm (Độ ưu tiên)</label>
                            <select name="priority" class="form-select">
                                <c:set var="cPriority" value="${isEdit ? product.priority : (not empty param.priority ? param.priority : '1')}"/>
                                <option value="1" ${cPriority == 1 ? 'selected' : ''}>Sản phẩm thường (1)</option>
                                <option value="2" ${cPriority == 2 ? 'selected' : ''}>Sản phẩm Deal (2)</option>
                                <option value="3" ${cPriority == 3 ? 'selected' : ''}>Sản phẩm Nổi bật (3)</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label required">Trạng thái</label>
                            <select name="status" class="form-select" required>
                                <c:set var="cStatus" value="${isEdit ? product.status : (not empty param.status ? param.status : 1)}"/>
                                <option value="1" ${cStatus == 1 ? 'selected' : ''}>Hiển thị</option>
                                <option value="0" ${cStatus == 0 ? 'selected' : ''}>Ẩn</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-footer">
                        <button type="submit" class="btn btn-primary">
                            ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                        </button>
                        <a href="${ctx}/admin/products" class="btn btn-outline-secondary ms-2">Huỷ</a>
                    </div>
                </form>
            </div>
        </div>
        
        <c:if test="${isEdit}">
            <!-- Hình ảnh mô tả -->
            <div class="card mt-4">
                <div class="card-header">
                    <h3 class="card-title">Hình ảnh mô tả (Phụ)</h3>
                </div>
                <div class="card-body">
                    <form action="${ctx}/admin/product-images/add" method="post" enctype="multipart/form-data" class="mb-3">
                        <input type="hidden" name="productID" value="${product.ID}" />
                        <div class="row align-items-end">
                            <div class="col-md-4">
                                <label class="form-label">Tải ảnh lên</label>
                                <input type="file" name="imgFile" class="form-control" accept="image/*" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Hoặc nhập URL</label>
                                <input type="text" name="imgUrl" class="form-control" placeholder="https://..." />
                            </div>
                            <div class="col-md-2" style="display: none">
                                <label class="form-label">Thứ tự</label>
                                <input type="number" name="sortOrder" class="form-control" value="1" />
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100">Thêm ảnh</button>
                            </div>
                        </div>
                    </form>
                    
                    <div class="row row-cards">
                        <c:forEach var="img" items="${images}">
                            <div class="col-sm-6 col-md-4 col-xl-3">
                                <div class="card card-sm">
                                    <div class="d-block"><img src="${imgUrl.resolve(img.imgUrl, ctx)}" class="card-img-top" style="height:150px;object-fit:cover;"></div>
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div>Thứ tự: ${img.sortOrder}</div>
                                            <div class="ms-auto">
                                                <a href="${ctx}/admin/product-images/delete/${img.ID}?productID=${product.ID}" class="text-danger" onclick="return confirm('Xoá ảnh này?')">Xoá</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Biến thể sản phẩm -->
            <div class="card mt-4">
                <div class="card-header">
                    <h3 class="card-title">Biến thể (Kích cỡ & Màu sắc)</h3>
                </div>
                <div class="card-body">
                    <form action="${ctx}/admin/product-variants/add" method="post" enctype="multipart/form-data" class="mb-4 bg-light p-3 border rounded">
                        <input type="hidden" name="productID" value="${product.ID}" />
                        <h5>Thêm biến thể mới</h5>
                        <div class="row">
                            <div class="col-md-3 mb-2">
                                <label class="form-label">Màu sắc</label>
                                <select name="colorOptionID" class="form-select">
                                    <c:forEach var="c" items="${colors}">
                                        <option value="${c.ID}">${c.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3 mb-2">
                                <label class="form-label">Kích cỡ</label>
                                <select name="sizeOptionID" class="form-select size-select">
                                    <c:forEach var="s" items="${sizes}">
                                        <option value="${s.ID}" data-group-id="${s.sizeGroupID}">${s.label}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3 mb-2">
                                <label class="form-label">SKU</label>
                                <input type="text" name="sku" class="form-control" required />
                            </div>
                            <div class="col-md-3 mb-2">
                                <label class="form-label">Barcode</label>
                                <input type="text" name="barcode" class="form-control" />
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-md-2 mb-2">
                                <label class="form-label">Giá cũ</label>
                                <input type="number" name="oldPrice" class="form-control" value="0" />
                            </div>
                            <div class="col-md-2 mb-2">
                                <label class="form-label">Giá mới</label>
                                <input type="number" name="newPrice" class="form-control" value="0" />
                            </div>
                            <div class="col-md-2 mb-2">
                                <label class="form-label">Số lượng</label>
                                <input type="number" name="quantity" class="form-control" value="0" />
                            </div>
                            <div class="col-md-3 mb-2">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-select">
                                    <option value="1">Hiển thị</option>
                                    <option value="0">Ẩn</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-2">
                                <label class="form-label">Tải ảnh lên (Tuỳ chọn)</label>
                                <input type="file" name="variantImgFile" class="form-control" accept="image/*" />
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-md-12 mb-2">
                                <label class="form-label">Hoặc nhập URL ảnh thay thế</label>
                                <input type="text" name="variantImgUrl" class="form-control" placeholder="https://..." />
                            </div>
                        </div>
                        <div class="mt-2 text-end">
                            <button type="submit" class="btn btn-success">Lưu biến thể</button>
                        </div>
                    </form>

                    <div class="table-responsive">
                        <table class="table table-vcenter card-table">
                            <thead>
                                <tr>
                                    <th>Ảnh</th>
                                    <th>SKU</th>
                                    <th>Màu sắc</th>
                                    <th>Kích cỡ</th>
                                    <th>Giá mới</th>
                                    <th>Tồn kho</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="v" items="${variants}">
                                    <tr>
                                        <td>
                                            <c:if test="${not empty v.variantImg}">
                                                <img src="${imgUrl.resolve(v.variantImg, ctx)}" width="40" height="40" style="object-fit:cover" class="rounded">
                                            </c:if>
                                        </td>
                                        <td>${v.sku}</td>
                                        <td>
                                            <c:forEach var="c" items="${colors}">
                                                <c:if test="${c.ID == v.colorOptionID}">${c.name}</c:if>
                                            </c:forEach>
                                        </td>
                                        <td>
                                            <c:forEach var="s" items="${sizes}">
                                                <c:if test="${s.ID == v.sizeOptionID}">${s.label}</c:if>
                                            </c:forEach>
                                        </td>
                                        <td>${v.newPrice} đ</td>
                                        <td>${v.quantity}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${v.status == 1}"><span class="badge bg-green text-white">Đang bán</span></c:when>
                                                <c:otherwise><span class="badge bg-red text-white">Đã ẩn</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#editVariantModal" onclick="populateEditVariantModal('${v.ID}', '${v.sku}', '${v.barcode}', '${v.colorOptionID}', '${v.sizeOptionID}', '${v.oldPrice}', '${v.newPrice}', '${v.quantity}', '${v.status}', '${v.variantImg}')">Sửa</button>
                                            <c:choose>
                                                <c:when test="${v.status == 1}">
                                                    <a href="${ctx}/admin/product-variants/delete/${v.ID}?productID=${product.ID}" class="btn btn-sm btn-danger" onclick="return confirm('Khoá biến thể này?')">Khoá</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${ctx}/admin/product-variants/delete/${v.ID}?productID=${product.ID}" class="btn btn-sm btn-success" onclick="return confirm('Mở khoá biến thể này?')">Mở khoá</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty variants}">
                                    <tr><td colspan="8" class="text-center text-muted">Chưa có biến thể nào</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Edit Variant Modal -->
            <div class="modal modal-blur fade" id="editVariantModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <form id="editVariantForm" method="post" enctype="multipart/form-data" class="modal-content">
                        <input type="hidden" name="productID" value="${product.ID}" />
                        <div class="modal-header">
                            <h5 class="modal-title">Sửa biến thể</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-3 mb-2">
                                    <label class="form-label">Màu sắc</label>
                                    <select name="colorOptionID" id="evColor" class="form-select">
                                        <c:forEach var="c" items="${colors}">
                                            <option value="${c.ID}">${c.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3 mb-2">
                                    <label class="form-label">Kích cỡ</label>
                                    <select name="sizeOptionID" id="evSize" class="form-select size-select">
                                        <c:forEach var="s" items="${sizes}">
                                            <option value="${s.ID}" data-group-id="${s.sizeGroupID}">${s.label}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3 mb-2">
                                    <label class="form-label">SKU</label>
                                    <input type="text" name="sku" id="evSku" class="form-control" required />
                                </div>
                                <div class="col-md-3 mb-2">
                                    <label class="form-label">Barcode</label>
                                    <input type="text" name="barcode" id="evBarcode" class="form-control" />
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-md-2 mb-2">
                                    <label class="form-label">Giá cũ</label>
                                    <input type="number" name="oldPrice" id="evOldPrice" class="form-control" />
                                </div>
                                <div class="col-md-2 mb-2">
                                    <label class="form-label">Giá mới</label>
                                    <input type="number" name="newPrice" id="evNewPrice" class="form-control" />
                                </div>
                                <div class="col-md-2 mb-2">
                                    <label class="form-label">Số lượng</label>
                                    <input type="number" name="quantity" id="evQuantity" class="form-control" />
                                </div>
                                <div class="col-md-3 mb-2">
                                    <label class="form-label">Trạng thái</label>
                                    <select name="status" id="evStatus" class="form-select">
                                        <option value="1">Hiển thị</option>
                                        <option value="0">Ẩn</option>
                                    </select>
                                </div>
                                <div class="col-md-3 mb-2">
                                    <label class="form-label">Tải ảnh lên (Tuỳ chọn)</label>
                                    <input type="file" name="variantImgFile" class="form-control" accept="image/*" />
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-md-12 mb-2">
                                    <label class="form-label">Hoặc nhập URL ảnh thay thế</label>
                                    <input type="text" name="variantImgUrl" id="evImgUrl" class="form-control" placeholder="https://..." />
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function populateEditVariantModal(id, sku, barcode, colorId, sizeId, oldPrice, newPrice, quantity, status, imgUrl) {
                    document.getElementById('editVariantForm').action = '${ctx}/admin/product-variants/edit/' + id;
                    document.getElementById('evSku').value = sku;
                    document.getElementById('evBarcode').value = barcode || '';
                    document.getElementById('evColor').value = colorId || '';
                    document.getElementById('evSize').value = sizeId || '';
                    document.getElementById('evOldPrice').value = oldPrice || 0;
                    document.getElementById('evNewPrice').value = newPrice || 0;
                    document.getElementById('evQuantity').value = quantity || 0;
                    document.getElementById('evStatus').value = status || 1;
                    document.getElementById('evImgUrl').value = imgUrl || '';
                }
            </script>
        </c:if>

    </div>
</div>

<!-- Add TinyMCE -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/tinymce/6.8.3/tinymce.min.js" referrerpolicy="origin"></script>
<script>
    tinymce.init({
        selector: '#description',
        height: 300,
        menubar: false,
        plugins: [
            'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
            'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
            'insertdatetime', 'media', 'table', 'help', 'wordcount'
        ],
        toolbar: 'undo redo | blocks | ' +
            'bold italic backcolor | alignleft aligncenter ' +
            'alignright alignjustify | bullist numlist outdent indent | ' +
            'removeformat | help',
        content_style: 'body { font-family: -apple-system, BlinkMacSystemFont, San Francisco, Segoe UI, Roboto, Helvetica Neue, sans-serif; font-size: 14px; }'
    });

    document.addEventListener('DOMContentLoaded', function() {
        var categorySelect = document.getElementById('categoryID');
        var sizeSelects = document.querySelectorAll('.size-select');

        function filterSizes() {
            var selectedOption = categorySelect.options[categorySelect.selectedIndex];
            var sizeGroupId = selectedOption ? selectedOption.getAttribute('data-group-id') : '';

            sizeSelects.forEach(function(select) {
                // Save current value to restore if possible
                var currentValue = select.value;
                var hasValidOption = false;

                Array.from(select.options).forEach(function(option) {
                    var optionGroupId = option.getAttribute('data-group-id');
                    if (!sizeGroupId || optionGroupId === sizeGroupId) {
                        option.style.display = '';
                        if (option.value === currentValue) hasValidOption = true;
                    } else {
                        option.style.display = 'none';
                    }
                });

                // If current selected option is hidden, reset to first visible option
                if (!hasValidOption && select.options.length > 0) {
                    for (var i = 0; i < select.options.length; i++) {
                        if (select.options[i].style.display !== 'none') {
                            select.value = select.options[i].value;
                            break;
                        }
                    }
                }
            });
        }

        if (categorySelect) {
            // Listen for changes
            categorySelect.addEventListener('change', filterSizes);
            
            // Initial filter on page load (important for edit mode)
            filterSizes();
        }
    });
</script>

<%@include file="../components/footer.jsp"%>
