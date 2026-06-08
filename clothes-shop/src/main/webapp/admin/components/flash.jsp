<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${not empty sessionScope.adminFlash}">
    <div class="alert alert-${sessionScope.adminFlashType} alert-dismissible" role="alert">
        <div class="d-flex">
            <div>${sessionScope.adminFlash}</div>
        </div>
        <a class="btn-close" data-bs-dismiss="alert" aria-label="close"></a>
    </div>
    <c:remove var="adminFlash" scope="session"/>
    <c:remove var="adminFlashType" scope="session"/>
</c:if>
