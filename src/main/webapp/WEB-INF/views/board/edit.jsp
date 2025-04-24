<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../layout/header.jsp" />

<div class="row mb-3">
    <div class="col">
        <h2>게시글 수정</h2>
    </div>
</div>

<form action="/board/edit" method="post">
    <input type="hidden" name="id" value="${board.id}">
    <div class="mb-3">
        <label for="title" class="form-label">제목</label>
        <input type="text" class="form-control" id="title" name="title" value="${board.title}" required>
    </div>
    <div class="mb-3">
        <label for="author" class="form-label">작성자</label>
        <input type="text" class="form-control" id="author" name="author" value="${board.author}" readonly>
    </div>
    <div class="mb-3">
        <label for="content" class="form-label">내용</label>
        <textarea class="form-control" id="content" name="content" rows="10" required>${board.content}</textarea>
    </div>
    <div class="d-flex justify-content-between">
        <a href="/board/view/${board.id}" class="btn btn-secondary">취소</a>
        <button type="submit" class="btn btn-primary">수정</button>
    </div>
</form>

<jsp:include page="../layout/footer.jsp" /> 