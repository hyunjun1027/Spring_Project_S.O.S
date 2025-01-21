<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/teach/teachPage.css" rel="stylesheet">
<link href="/resources/css/course/courseNoticeView.css" rel="stylesheet">
<style>
.header {
	background: #b5aaf2;
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(2)>a").addClass("active");
		
		// 목록 버튼 클릭시
		$("#btnList").on("click", function() {
			document.bbsForm.classCode.value = ${classCode};
/* 			document.bbsForm.courseCode.value = ${course.courseCode}; */
			document.bbsForm.teacherId.value = "${teacher.userId}";
			document.bbsForm.action = "/teach/teachNotice";
			document.bbsForm.submit();
		});
	});
	
	function fn_teachMove(url) {
 		document.teacherTypeForm.classCode.value = ${classCode};
 		document.teacherTypeForm.teacherId.value = "${teacher.userId }";
		document.teacherTypeForm.action = "/teach/" + url;
		document.teacherTypeForm.submit(); 
	}
	
	//수정 버튼 클릭시
	function fn_update() {
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.courseCode.value = ${course.courseCode};
		document.bbsForm.action = "/course/courseNoticeUpdate";
		document.bbsForm.submit();
	}
	
	// 삭제 버튼 클릭시
	function fn_delete() {
		Swal.fire({
			  title: "게시글을 삭제하시겠습니까?",
			  icon: "warning",
			  showCancelButton: true,
			  confirmButtonColor: "#3085d6",
			  cancelButtonColor: "#d33",
			  confirmButtonText: "삭제",
			cancelButtonText:"취소"
			}).then((result) => {
			  if (result.isConfirmed) {

			   $.ajax({
					type : "POST",
					url : "/course/courseNoticeDelete",
					data : {
						brdSeq : ${brdSeq}
					},
					dataType : "JSON",
					beforeSend : function(xhr) {
						xhr.setRequestHeader("AJAX", "true");	
					},
					success : function (response) {
						if (response.code == 0) {
							Swal.fire({
			            		position: "center", 
			            		icon: "success",
			            		title: "게시글이 삭제되었습니다.", 
			            		showConfirmButton: false, 
			            		timer: 1500 
			            		});

							document.bbsForm.classCode.value = ${classCode};
							document.bbsForm.courseCode.value = ${course.courseCode};
							document.bbsForm.action = "/teach/teachNotice";
							document.bbsForm.submit();
						}
						else {
							Swal.fire({
			            		position: "center", 
			            		icon: "warning",
			            		title: "게시글 삭제 중 오류가 발생하였습니다.", 
			            		showConfirmButton: false, 
			            		timer: 1500 
			            		});

						}
					},
					error : function (xhr, status, error) {
						icia.common.error(error);
					}
			   });
			
		}
	  });
	}


</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	
	<section class="notice-section">
		<div class="notice-content">
			<div class="notice-text">
				<h1 class="mainTitle">Teacher</h1>
				<p class="mainContent">선생님</p>
			</div>
			<div class="notice-image">
				<img src="/resources/img/teach_heart.png" alt="Duck Image">
			</div>
		</div>
	</section>

	<section class="content-section">
		<%@ include file="/WEB-INF/views/include/teach/teachSideBar.jsp"%>
		<div class="table-container">
			<div class="teach-container">
				<%@ include file="/WEB-INF/views/include/teach/teachContainer.jsp"%>
			</div>

			<div class="">
				<div class="course-page">
					<ul class="tab-menu">
						<li onclick="fn_teachMove('teachPage')">HOME</li>
						<li onclick="fn_teachMove('teachCourse')">강좌목록</li>
						<li class="active" onclick="fn_teachMove('teachNotice')">공지사항</li>
						<li onclick="fn_teachMove('teachQna')">학습Q&A</li>
						<li onclick="fn_teachMove('teachReview')">수강후기</li>
					</ul>

					<div class="content">
					
							<div class="board-container">
								
								<%@ include file="/WEB-INF/views/include/course/courseNoticeViewIn.jsp"%>
		
									<div class="comment-section">
										<!-- 버튼 영역 -->
										<div class="comment-buttons">
										
											<c:if test="${boardMe eq 'Y' }">
												<button class="btn-delete" onclick="fn_delete()">삭제</button>
												<button class="btn-modify" onclick="fn_update()">수정</button>
											</c:if>
											
											<button class="btn-list" id="btnList">목록</button>
										</div>
					
									</div>
							</div>
		
						</div>
						</div>
		
<%-- 					<!-- 이전글, 다음글 추가 -->
					<div class="post-navigation">
						<c:if test="${!empty nextList }">
							<div class="next-post">
								<span>다음글</span> 
								<a href="/teach/teachNoticeView?brdSeq=${prevList.brdSeq}&courseCode=${course.courseCode}&classCode=${classCode}">
								${nextList.brdTitle }</a>
							</div>
						</c:if>
						
						<c:if test="${!empty prevList }">
							<div class="prev-post">
								<span>이전글</span> 
								<a href="/teach/teachNoticeView?brdSeq=${prevList.brdSeq}&courseCode=${course.courseCode}&classCode=${classCode}">
								${prevList.brdTitle }</a>
							</div>
						</c:if>
					</div> --%>


		</div>

		</div>
					
					
					</div>
					
					
					
				</div>	
			</div>
		</div>
	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
	
	<form name="bbsForm" id="bbsForm" method="post">
   		<input type="hidden" name="brdSeq" value="${brdSeq }">
   		<input type="hidden" name="searchType" id="searchType" value="${searchType }">
   		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue }">
   		<input type="hidden" name="curPage" id="curPage" value="${curPage }">
		<input type="hidden" name="classCode" value="${classCode }">
		<input type="hidden" name="courseCode" value="${course.courseCode }">
		<input type="hidden" name="teacherId" value="${teacher.userId }">
	</form>
	
	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>
	
</body>
</html>
