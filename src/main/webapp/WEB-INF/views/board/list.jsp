<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../layout/header.jsp" />

<div class="row mb-3">
    <div class="col">
        <h2>게시판 목록</h2>
    </div>
    <div class="col-auto">
        <a href="/board/write" class="btn btn-primary">글쓰기</a>
    </div>
</div>

<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead class="table-dark">
            <tr>
                <th scope="col" width="10%">#</th>
                <th scope="col" width="50%">제목</th>
                <th scope="col" width="15%">작성자</th>
                <th scope="col" width="15%">작성일</th>
                <th scope="col" width="10%">조회수</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="board" items="${boards}">
                <tr>
                    <td>${board.id}</td>
                    <td><a href="/board/view/${board.id}" class="text-decoration-none">${board.title}</a></td>
                    <td>${board.author}</td>
                    <td>${board.formattedCreatedDate}</td>
                    <td>${board.viewCount}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty boards}">
                <tr>
                    <td colspan="5" class="text-center">등록된 게시글이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<jsp:include page="../layout/footer.jsp" /> 