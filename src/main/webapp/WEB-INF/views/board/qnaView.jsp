<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<link href="/resources/css/board/qnaView.css" rel="stylesheet">
<style>
.header {
	background-color: #539ED8;
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(3)>a").addClass("active");
	});
	
	function fn_commWrite(){
		document.bbsForm.action = "/board/qnaCommWrite";
		document.bbsForm.submit();
	}
	
	/* 글 수정 */
	function fn_update() {
		document.bbsForm.action = "/board/qnaUpdate";
		document.bbsForm.submit();
	}
	
	/* 답변 수정 */
	function fn_commUpdate(){
		document.bbsForm.action = "/board/qnaCommUpdate";
		document.bbsForm.submit();
	}
	
	
	$(document).ready(function() {
	    // 목록 버튼 클릭 이벤트
	    $("#btnList").on("click", function() {
	         document.bbsForm.action = "/board/qnaList";
	         document.bbsForm.submit();
	    });

	    //삭제 버튼 클릭 이벤트
	    $("#btn-delete").on("click", function(){
			
	    	Swal.fire({
	    		  title: "Are you sure?",
	    		  icon: "warning",
	    		  showCancelButton: true,
	    		  confirmButtonColor: "#3085d6",
	    		  cancelButtonColor: "#d33",
	    		  confirmButtonText: "삭제",
	    		cancelButtonText:"취소"
	    		}).then((result) => {
	    		  if (result.isConfirmed) {
	 		   
			 		  var brdSeq = "${brdSeq}";
			 		   
			 		   $.ajax({
			 			   
			 			   type:"POST",
			 			   url:"/board/qnaDelete",
			 			   data:{
			 				  brdSeq: brdSeq
			 			   },
			 			   datatype:"JSON",
			 			   beforeSend:function(xhr){
			 				   xhr.setRequestHeader("AJAX", "true");
			 			   },
			 			   success:function(response){
			 				   
			 				   if(response.code == 0){
			 					   
			 					  Swal.fire({
			 						 position: "center", 
			 						 icon: "success",
			 						 title: "게시물이 삭제 되었습니다.",
			 						 showConfirmButton: false, 
			 						 timer: 1500 
			 						 }).then(function() {
			 							location.href = "/board/qnaList";
			 						 });
			 					   
			 				   }else if(response.code == 400){
			 					   
			 					  Swal.fire({
			 		            		position: "center", 
			 		            		icon: "warning",
			 		            		title: "파라미터 값이 올바르지 않습니다.", 
			 		            		showConfirmButton: false, 
			 		            		timer: 1500 
			 		            		});

			 					   
			 				   }else if(response.code == 403){
			 					   
			 					  Swal.fire({
			 		            		position: "center", 
			 		            		icon: "warning",
			 		            		title: "본인이 게시한 게시글만 삭제가 가능합니다.", 
			 		            		showConfirmButton: false, 
			 		            		timer: 1500 
			 		            		});

			 					   
			 				   }else if(response.code == 404){
			 					   
			 					  Swal.fire({
			 						 position: "center", 
			 						 icon: "warning",
			 						 title: "해당 게시물을 찾을 수 없습니다.",
			 						 showConfirmButton: false, 
			 						 timer: 1500 
			 						 }).then(function() {
			 							location.href = "/board/qnaList";
			 						 });

			 				   }else if(response.code == -999){
			 					   
			 					  Swal.fire({
			 		            		position: "center", 
			 		            		icon: "warning",
			 		            		title: "답변 게시물이 존재하여 삭제할 수 없습니다.", 
			 		            		showConfirmButton: false, 
			 		            		timer: 1500 
			 		            		});

			 					   
			 				   }else{
			 					  Swal.fire({
			 		            		position: "center", 
			 		            		icon: "warning",
			 		            		title: "게시물 삭제중 오류가 발생하였습니다.", 
			 		            		showConfirmButton: false, 
			 		            		timer: 1500 
			 		            		});

			 				   }
			 				   
			 			   },
			 			   error:function(xhr, status, error){
			 				   icia.common.error(error);
			 			   }
			 		   });
	    		  	}
	    	});
	 	   
	    });
	    
	});
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<section class="notice-section">
		<div class="notice-content"></div>
	</section>
	<section class="content-section">
		<div class="sidebar">
			<div class="exam-date" id="d-day-display">
				2026 수능 <span class="days"></span>
			</div>
			<ul class="menu">
				<li><a href="/board/noticeList">공지사항</a></li>
				<li><a href="/board/qnaList" class="highlight">문의사항</a></li>
				<li><a href="/board/freeList">자유게시판</a><br></li>
				<li><a href="/board/faqList">자주 묻는 질문</a></li>
			</ul>
		</div>

		<div class="table-container">
			<h2 class="subTitle">문의사항 > 문의글 보기</h2>
			<div class="header-line"></div>

		<section class="board-container">
		    <section class="question-answer">
		        <!-- 질문 내용 -->
		        <div class="question-section">
		            <h3>질문 내용</h3>
		            <hr class="divider">
		            <div class="question-header">
		                <div class="question-info">
		                    <strong><c:out value="${mainPost.brdTitle}" /></strong>
		                    <div class="meta">작성자:
		                    <span>
			                    ${mainPost.userName}(
	                           <c:choose>
								        <c:when test="${fn:length(mainPost.userId) gt 10}">
								        <c:out value="${fn:substring(mainPost.userId, 0, 9)}...">
								        </c:out></c:when>
								        <c:otherwise>
								        <c:out value="${mainPost.userId}">
								        </c:out></c:otherwise>
								</c:choose>
	                           )
		                    </span> | 등록일: <span>${mainPost.modDate}</span> | 조회수: ${mainPost.brdReadCnt}</div>
		                </div>
		            </div>
		
		            <!-- 게시글 첨부파일 -->
		            <c:if test="${not empty mainPost.boardQnaFile}">
		                <!-- 사진 -->
		                <c:if test="${mainPost.boardQnaFile.fileExt == 'jpg' or mainPost.boardQnaFile.fileExt == 'jpeg' or mainPost.boardQnaFile.fileExt == 'png' or mainPost.boardQnaFile.fileExt == 'gif' or mainPost.boardQnaFile.fileExt == 'bmp'}">
		                    <img src="/resources/upload/${mainPost.boardQnaFile.fileName}" style="max-width: 50%; margin-top: 20px; margin-bottom: 20px;">
		                </c:if>
		                <!-- 동영상 -->
		                <c:if test="${mainPost.boardQnaFile.fileExt == 'mp4' or mainPost.boardQnaFile.fileExt == 'avi' or mainPost.boardQnaFile.fileExt == 'mov' or mainPost.boardQnaFile.fileExt == 'mkv'}">
		                    <video width="80%" height="auto" controls>
		                        <source src="/resources/upload/${mainPost.boardQnaFile.fileName}" type="video/${mainPost.boardQnaFile.fileExt}">
		                    </video>
		                </c:if>
		                <!-- 텍스트 -->
		                <c:if test="${mainPost.boardQnaFile.fileExt == 'txt' or mainPost.boardQnaFile.fileExt == 'csv' or mainPost.boardQnaFile.fileExt == 'pdf'}">
		                    <a href="/resources/upload/${mainPost.boardQnaFile.fileName}" download="${mainPost.boardQnaFile.fileOrgName}">
		                        다운로드: ${mainPost.boardQnaFile.fileOrgName}
		                    </a>
		                </c:if>
		            </c:if>
		
		            <div class="question-content">
		            	<div class="ql-editor">
		                	<p>${mainPost.brdContent}</p>
		                </div>
		            </div>
		        </div>
		
		        <c:if test="${replyPost.brdParent eq brdSeq}">
		            <!-- 답변 내용 -->
		            <div class="answer-section">
		                <h3>답변 내용</h3>
		                <hr class="divider">
		                <div class="answer-header">
		                    <div class="question-info">
		                        <strong>${replyPost.brdTitle}</strong>
		                        <div class="meta">작성자: ${replyPost.userId} | 등록일: ${replyPost.modDate}</div>
		                    </div>
		                </div>
		
		                <!-- 답글 첨부파일 -->
		                    <!-- 사진 -->
		                    <c:if test="${replyPost.boardCommQnaFile.fileExt == 'jpg' or replyPost.boardCommQnaFile.fileExt == 'jpeg' or replyPost.boardCommQnaFile.fileExt == 'png' or replyPost.boardCommQnaFile.fileExt == 'gif' or replyPost.boardCommQnaFile.fileExt == 'bmp'}">
		                        <img src="/resources/upload/${replyPost.fileName}" style="max-width: 50%; margin-top: 20px; margin-bottom: 20px;">
		                    </c:if>
		                    <!-- 동영상 -->
		                    <c:if test="${replyPost.boardCommQnaFile.fileExt == 'mp4' or replyPost.boardCommQnaFile.fileExt == 'avi' or replyPost.boardCommQnaFile.fileExt == 'mov' or replyPost.boardCommQnaFile.fileExt == 'mkv'}">
		                        <video width="80%" height="auto" controls>
		                            <source src="/resources/upload/${replyPost.fileName}" type="video/${replyPost.boardCommQnaFile.fileExt}">
		                        </video>
		                    </c:if>
		                    <!-- 텍스트 -->
		                    <c:if test="${replyPost.boardCommQnaFile.fileExt == 'txt' or replyPost.boardCommQnaFile.fileExt == 'csv' or replyPost.boardCommQnaFile.fileExt == 'pdf'}">
		                        <a href="/resources/upload/${replyPost.fileName}" download="${replyPost.boardCommQnaFile.fileOrgName}">
		                            다운로드: ${replyPost.boardCommQnaFile.fileOrgName}
		                        </a>
		                    </c:if>
		                
			            <div class="question-content">
			            	<div class="board-content">
			                	<p>${replyPost.brdContent}</p>
			                </div>
			            </div>
		            </div>
		        </c:if>

					<hr class="divider-bottom">
					<div class="comment-section">
						<!-- 버튼 영역 -->
						<div class="comment-buttons">
 							<c:if test="${user.rating eq 'A'}">
								<!-- <button type="button" class="btn-delete" id="btn-commDelete">삭제</button> -->
								<c:if test="${boardMe eq 'Y' or user.rating eq 'A' and mainPost.brdSeq eq replyPost.brdParent}">
									<button type="button" class="btn-modify" onclick="fn_commUpdate()">답변수정</button>
								</c:if>
								<c:if test="${mainPost.brdSeq ne replyPost.brdParent}">
									<button type="button" class="btn-comment" onclick="fn_commWrite()">답변</button>
								</c:if>
 							</c:if>
 							
							<c:if test="${boardMe eq 'Y'}">
								<button type="button" class="btn-delete" id="btn-delete">삭제</button>
								<button type="button" class="btn-modify" onclick="fn_update()">수정</button>
							</c:if>
							<button type="button"  class="btn-list" id="btnList">목록</button>
						</div>
	
					</div>
				</section>

			</section>


		</div>
	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

	<form id="bbsForm" name=bbsForm method="post">
		<input type="hidden" name="brdSeq" value="${brdSeq}">
		<input type="hidden" name="brdParent" value="${brdParent}">
		<input type="hidden" name="searchType" value="${searchType}"> 
		<input type="hidden" name="searchValue" value="${searchValue}"> 
		<input type="hidden" name="curPage" value="${curPage}">
	</form>
	
</body>
</html>