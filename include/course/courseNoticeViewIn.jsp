<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

		<!-- 게시글 정보 -->
		<div class="board-info">
		
			<h2>${notice.brdTitle}</h2>
			<div class="post-meta">
				<span>등록일 : ${notice.regDate }</span>
				<span>조회수 ${notice.brdReadCnt }</span>
			</div>
		</div>
		
		<!-- 게시글 내용 -->
		<div class="board-content">
			<div class="ql-editor">
			<p>
				${notice.brdContent }					
			</p>
			</div>
		</div>
		
		
		<!-- 댓글 -->
		<div class="comment-section">
			<!-- 버튼 영역 -->
			<div class="comment-buttons">
			

						