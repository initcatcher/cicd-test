<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../layout/header.jsp" />

<div class="mb-3">
    <h2>${board.title}</h2>
    <div class="d-flex justify-content-between small text-muted mb-3">
        <div>
            <span>작성자: ${board.author}</span>
        </div>
        <div>
            <span>작성일: ${board.formattedCreatedDateTime}</span> |
            <span>조회수: ${board.viewCount}</span>
        </div>
    </div>
    <hr>
</div>

<div class="card mb-4">
    <div class="card-body">
        <p class="card-text" style="min-height: 200px;">${board.content}</p>
    </div>
</div>

<div class="d-flex justify-content-between">
    <div>
        <a href="/board/list" class="btn btn-secondary">목록</a>
    </div>
    <div>
        <a href="/board/edit/${board.id}" class="btn btn-primary me-2">수정</a>
        <a href="/board/delete/${board.id}" class="btn btn-danger"
           onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" /> 