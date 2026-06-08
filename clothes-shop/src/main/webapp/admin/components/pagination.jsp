<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card-footer d-flex align-items-center">
    <p class="m-0 text-muted">Trang <span>${currentPage}</span> trên <span>${totalPages == 0 ? 1 : totalPages}</span></p>
    <ul class="pagination m-0 ms-auto">
        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
            <a class="page-link" href="?page=${currentPage - 1}&limit=${limit}&q=${not empty q ? q : ''}&status=${not empty status ? status : ''}&sort=${not empty sort ? sort : ''}&categoryID=${not empty categoryID ? categoryID : ''}&producerID=${not empty producerID ? producerID : ''}&brandID=${not empty brandID ? brandID : ''}" tabindex="-1" aria-disabled="true">
                <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M15 6l-6 6l6 6" /></svg>
                trước
            </a>
        </li>
        <c:forEach begin="1" end="${totalPages == 0 ? 1 : totalPages}" var="i">
            <li class="page-item ${currentPage == i ? 'active' : ''}"><a class="page-link" href="?page=${i}&limit=${limit}&q=${not empty q ? q : ''}&status=${not empty status ? status : ''}&sort=${not empty sort ? sort : ''}&categoryID=${not empty categoryID ? categoryID : ''}&producerID=${not empty producerID ? producerID : ''}&brandID=${not empty brandID ? brandID : ''}">${i}</a></li>
        </c:forEach>
        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
            <a class="page-link" href="?page=${currentPage + 1}&limit=${limit}&q=${not empty q ? q : ''}&status=${not empty status ? status : ''}&sort=${not empty sort ? sort : ''}&categoryID=${not empty categoryID ? categoryID : ''}&producerID=${not empty producerID ? producerID : ''}&brandID=${not empty brandID ? brandID : ''}">
                sau
                <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M9 6l6 6l-6 6" /></svg>
            </a>
        </li>
    </ul>
</div>
