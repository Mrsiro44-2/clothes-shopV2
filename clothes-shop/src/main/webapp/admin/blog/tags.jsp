<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="pageTitle" value="${pageTitle}" scope="request"/>
<jsp:include page="/admin/components/header.jsp" />

<div class="page-header d-print-none">
    <div class="container-xl">
        <div class="row g-2 align-items-center">
            <div class="col">
                <h2 class="page-title">
                    ${pageTitle}
                </h2>
            </div>
        </div>
    </div>
</div>

<div class="page-body">
    <div class="container-xl">
        
        <c:if test="${not empty sessionScope.adminFlash}">
            <div class="alert alert-${sessionScope.adminFlashType} alert-dismissible" role="alert">
                <div class="d-flex">
                    <div>
                        <svg xmlns="http://www.w3.org/2000/svg" class="icon alert-icon" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                            <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                            <path d="M5 12l5 5l10 -10" />
                        </svg>
                    </div>
                    <div>${sessionScope.adminFlash}</div>
                </div>
                <a class="btn-close" data-bs-dismiss="alert" aria-label="close"></a>
            </div>
            <c:remove var="adminFlash" scope="session"/>
            <c:remove var="adminFlashType" scope="session"/>
        </c:if>

        <div class="card">
            <div class="card-body border-bottom py-3">
                <form method="GET" action="${ctx}/admin/blog-tags">
                    <div class="row gx-2">
                        <div class="col-md-6 mb-2">
                            <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm tên thẻ..." value="${keyword}">
                        </div>
                        <div class="col-md-3 mb-2">
                            <select name="limit" class="form-select" onchange="this.form.submit()">
                                <option value="15" ${limit == 15 ? 'selected' : ''}>15 dòng</option>
                                <option value="20" ${limit == 20 ? 'selected' : ''}>20 dòng</option>
                                <option value="50" ${limit == 50 ? 'selected' : ''}>50 dòng</option>
                            </select>
                        </div>
                        <div class="col-md-3 mb-2">
                            <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="table-responsive">
                <table class="table card-table table-vcenter text-nowrap datatable">
                    <thead>
                        <tr>
                            <th class="w-1">ID</th>
                            <th>Tên Thẻ (Name)</th>
                            <th>Đường dẫn (Slug)</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${tags}" var="t">
                            <tr>
                                <td><span class="text-secondary">${t.id}</span></td>
                                <td>
                                    <strong>${t.name}</strong>
                                </td>
                                <td>
                                    <span class="text-secondary">${t.slug}</span>
                                </td>
                                <td class="text-end">
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modal-edit-${t.id}">Sửa</button>
                                    <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#modal-delete-${t.id}">Xóa</button>
                                </td>
                            </tr>
                            
                            <!-- Modal Sửa -->
                            <div class="modal modal-blur fade" id="modal-edit-${t.id}" tabindex="-1" role="dialog" aria-hidden="true">
                                <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
                                    <div class="modal-content">
                                        <form action="${pageContext.request.contextPath}/admin/blog-tags/update" method="POST">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Sửa thẻ</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <input type="hidden" name="id" value="${t.id}"/>
                                                <div class="mb-3">
                                                    <label class="form-label">Tên thẻ</label>
                                                    <input type="text" class="form-control" name="name" value="${t.name}" required/>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Slug</label>
                                                    <input type="text" class="form-control" name="slug" value="${t.slug}" required/>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-link link-secondary me-auto" data-bs-dismiss="modal">Hủy</button>
                                                <button type="submit" class="btn btn-primary">Lưu</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Modal Xóa -->
                            <div class="modal modal-blur fade" id="modal-delete-${t.id}" tabindex="-1" role="dialog" aria-hidden="true">
                                <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div class="modal-title">Bạn chắc chắn muốn xóa?</div>
                                            <div>Bạn sắp xóa thẻ <strong>${t.name}</strong>. Mọi liên kết từ thẻ này tới bài viết sẽ bị xóa. Thao tác này không thể hoàn tác.</div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-link link-secondary me-auto" data-bs-dismiss="modal">Hủy</button>
                                            <a href="${pageContext.request.contextPath}/admin/blog-tags/delete/${t.id}" class="btn btn-danger">Vâng, xóa nó</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty tags}">
                            <tr><td colspan="4" class="text-center text-secondary py-4">Chưa có thẻ nào được tạo.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <c:if test="${totalPages > 1}">
                <div class="card-footer d-flex align-items-center">
                    <ul class="pagination m-0 ms-auto">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}&limit=${limit}" tabindex="-1">Trước</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&keyword=${keyword}&limit=${limit}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}&limit=${limit}">Sau</a>
                        </li>
                    </ul>
                </div>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="/admin/components/footer.jsp" />
