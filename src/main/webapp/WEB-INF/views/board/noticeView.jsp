<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/navigation.css" rel="stylesheet">


<style>
.header {
	background-color: #CF99C7;
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(3)>a").addClass("active");
	});

	/* 글 수정 */
	function fn_update() {
		document.bbsForm.action = "/board/noticeUpdate";
		document.bbsForm.submit();
	}
	
	
	$(document).ready(function() {
	    // 목록 버튼 클릭 이벤트
	    $("#btnList").on("click", function() {
	         document.bbsForm.action = "/board/noticeList";
	         document.bbsForm.submit();
	    });

	    //삭제 버튼 클릭 이벤트
	    $("#btn-delete").on("click", function(){
			
	    	Swal.fire({
	    		  title: "해당 게시물을 삭제 하시겠습니까?",
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
	 			   url:"/board/noticeDelete",
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
	 							location.href = "/board/noticeList";
	 						 });

	 					   
	 				   }else if(response.code == 400){
	 					   
	 					  Swal.fire({
	 		            		position: "center", 
	 		            		icon: "warning",
	 		            		title: "파라미터 값이 올바르지 않습니다.", 
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
	 							location.href = "/board/noticeList";
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
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<link href="/resources/css/board/noticeView.css" rel="stylesheet">
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
				<li><a href="/board/noticeList" class="highlight">공지사항</a></li>
				<li><a href="/board/qnaList">문의사항</a></li>
				<li><a href="/board/freeList">자유게시판</a><br></li>
				<li><a href="/board/faqList">자주 묻는 질문</a></li>
			</ul>
		</div>
		<div class="table-container">
			<h2 class="subTitle">공지사항 > 공지사항 보기</h2>
			<div class="header-line"></div>
			<section class="board-container">

				<!-- 게시글 정보 -->
				<div class="board-info">
					<h2><c:out value="${boardNotice.brdTitle}" /></h2>
					<div class="post-meta">
						<span>등록일 : ${boardNotice.modDate}</span> <span>조회수 <fmt:formatNumber type="number" maxFractionDigits="3" groupingUsed="true" value="${boardNotice.brdReadCnt}" /></span>
					</div>
				</div>			

				<c:if test="${!empty boardNotice.boardNoticeFile}">
					<!-- 사진 -->
					<c:if test="${boardNotice.boardNoticeFile.fileExt == 'jpg' or boardNotice.boardNoticeFile.fileExt == 'jpeg' or boardNotice.boardNoticeFile.fileExt == 'png' or boardNotice.boardNoticeFile.fileExt == 'gif' or boardNotice.boardNoticeFile.fileExt == 'bmp'}">
						<img src="/resources/upload/${boardNotice.fileName}" style="max-width: 50%; margin-bottom: 20px;">
					</c:if>
					<!-- 동영상 -->
					<c:if test="${boardNotice.boardNoticeFile.fileExt == 'mp4' or boardNotice.boardNoticeFile.fileExt == 'avi' or boardNotice.boardNoticeFile.fileExt == 'mov' or boardNotice.boardNoticeFile.fileExt == 'mkv'}">
					    <video width="80%" height="auto" controls>
					        <source src="/resources/upload/${boardNotice.boardNoticeFile.fileName}" type="video/${boardNotice.boardNoticeFile.fileExt}">
					    </video>
					</c:if>
					<!-- 텍스트 -->
					<c:if test="${boardNotice.boardNoticeFile.fileExt == 'txt' or boardNotice.boardNoticeFile.fileExt == 'csv' or boardNotice.boardNoticeFile.fileExt == 'pdf'}">
					    <a href="/resources/upload/${boardNotice.boardNoticeFile.fileName}" download="${boardNotice.boardNoticeFile.fileOrgName}">
					        다운로드 : ${boardNotice.boardNoticeFile.fileOrgName}
					    	</a>
					</c:if>
				   
				</c:if>

				

				<!-- 게시글 내용 -->
				<div class="board-content">
					<div class="ql-editor">
						<p>${boardNotice.brdContent}</p>
					</div>
				</div>

				<div class="comment-section">
					<!-- 버튼 영역 -->
					<div class="comment-buttons">
					<c:if test="${boardMe eq 'Y'}">
						<button type="button" class="btn-delete" id="btn-delete">삭제</button>
						<button type="button" class="btn-modify" onclick="fn_update()">수정</button>
					</c:if>
						<button type="button"  class="btn-list" id="btnList">목록</button>
					</div>

				</div>
			</section>

			<!-- 이전글, 다음글 추가 -->

			<div class="post-navigation">
				<!-- 이전글 표시 -->
				<c:if test="${not empty prevPost}">
					<div class="prev-post">
						<span>이전글</span>
						<a href="/board/noticeView?brdSeq=${prevPost.brdSeq}">[${prevPost.brdTitle}]</a>
					</div>
				</c:if>
	
				<!-- 다음글 표시 -->
				<c:if test="${not empty nextPost}">
					<div class="next-post">
						<span>다음글</span>
						<a href="/board/noticeView?brdSeq=${nextPost.brdSeq}">[${nextPost.brdTitle}]</a>
					</div>
				</c:if>
			</div>
			
<!-- 			<div class="post-navigation">
				<div class="prev-post">
					<span>이전글</span> <a href="#">[안내] 강좌 일시 판매 종료 안내 (수학 이지영 선생님)</a>
				</div>
				<div class="next-post">
					<span>다음글</span> <a href="#">[공지] 토스 결제 점검 시간 안내</a>
				</div>
			</div> -->


		</div>
	</section>

	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
	
	<form name="bbsForm" id="bbsForm" method="post">
	
		<input type="hidden" name="brdSeq" value="${brdSeq}">
		<input type="hidden" name="searchType" value="${searchType}">
		<input type="hidden" name="searchValue" value="${searchValue}">
		<input type="hidden" name="curPage" value="${curPage}">
	
	</form>	

</body>
</html>