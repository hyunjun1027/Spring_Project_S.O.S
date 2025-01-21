<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>

if (${nextBrdSeq} != 0) {
	brdSeq = ${nextBrdSeq};	
}
else {
	brdSeq = ${brdSeq};
}

//수정 버튼 클릭시
function fn_update() {
	document.bbsForm.brdSeq.value = brdSeq;
	document.bbsForm.classCode.value = ${classCode};
	document.bbsForm.courseCode.value = ${course.courseCode};
	document.bbsForm.action = "/course/courseQnAUpdate";
	document.bbsForm.submit();
}

// 삭제 버튼 클릭시
function fn_delete() {
	if (confirm("게시글을 삭제하시겠습니까?")) {
		
		   $.ajax({
				type : "POST",
				url : "/course/courseQnADelete",
				data : {
					brdSeq : brdSeq
				},
				dataType : "JSON",
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");	
				},
				success : function (response) {
					if (response.code == 0) {
						alert("게시글이 삭제되었습니다.");
						document.bbsForm.classCode.value = ${classCode};
						document.bbsForm.courseCode.value = ${course.courseCode};
						document.bbsForm.action = "/course/courseQnA";
						document.bbsForm.submit();
					}
					else {
						alert("게시글 삭제 중 오류가 발생하였습니다.");
					}
				},
				error : function (xhr, status, error) {
					icia.common.error(error);
				}
		   });
		
	}
}

// 답글 버튼 클릭시
function fn_reply() {
	document.bbsForm.brdSeq.value = ${brdSeq};
	document.bbsForm.classCode.value = ${classCode};
	document.bbsForm.courseCode.value = ${course.courseCode};
	document.bbsForm.action = "/course/courseQnAWrite";
	document.bbsForm.submit();
}

</script>


<style>
.header {
	background: #b5aaf2;
}

.ql-editor {
	color: black;
	white-space: normal; /* pre-wrap 속성 덮어쓰기 */
	min-height: 250px;
}

.ql-editor p:empty,
.ql-editor div:empty {
    display: none; /* 빈 태그 숨기기 */
}

.board-content {
	padding: 0px;
}
</style>

			<div class="board-info-div">

<c:if test="${!empty list }">			
	<c:forEach var="qna" items="${list }" varStatus="status">	
				<section class="board-container">
	
					<!-- 게시글 정보 -->
					<div class="board-info">
						<p>
							<c:if test="${qna.rating eq 'U' }">
								<strong style="color: #0ea537;">질문</strong>
							</c:if>
							<c:if test="${qna.rating eq 'T' }">
								<strong style="color: #4a81bb;">답변</strong>
							</c:if>
						</p>
						<h2>${qna.brdTitle }</h2>
						<div class="post-meta">
							<span>${qna.userName }
							<c:if test="${qna.rating eq 'T' }">
							 선생님
							</c:if>
							</span> 
							<span>${qna.userEmail }</span>
							<span>${qna.regDate }</span>
							<span>조회수 ${qna.brdReadCnt }</span> 
							
							<c:if test="${!empty qna.courseListFile }">
								<a href="/course/courseListFiledownload?brdSeq=${qna.courseListFile.brdSeq }" style="color: #000">[첨부파일]</a>
							</c:if>
							
						</div>
					</div>
	
					<!-- 게시글 내용 -->
					<div class="board-content">
						<div class="ql-editor">
							<p>${qna.brdContent }</p>
						</div>
					</div> 
					
<%-- 				<div class="ql-editor">
				    <c:out value="${qna.brdContent}" escapeXml="false"/>
				    ${qna.brdContent }
				</div>   --%>
	
				</section>
	</c:forEach>
</c:if>


	
<div class="comment-section">
	<!-- 버튼 영역 -->
	<div class="comment-buttons">
	
		
		<c:if test="${isTeacher eq 'Y' && isReply eq 'N'}">
			<button class="btn-reply" onclick="fn_reply()">답글</button>
		</c:if>
		
		<c:if test="${boardMe eq 'Y' }">
			<button class="btn-delete" onclick="fn_delete()">삭제</button>
			<button class="btn-modify" onclick="fn_update()">수정</button>
		</c:if>
		
