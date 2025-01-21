<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Quill CSS -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">

<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/teach/teachPage.css" rel="stylesheet">
<link href="/resources/css/course/courseQnAView.css" rel="stylesheet">
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
			document.bbsForm.courseCode.value = ${course.courseCode};
			document.bbsForm.teacherId.value = "${teacher.userId}";
			document.bbsForm.action = "/teach/teachQna";
			document.bbsForm.submit();
		});
	});
	
	function fn_teachMove(url) {
 		document.teacherTypeForm.classCode.value = ${classCode};
 		document.teacherTypeForm.teacherId.value = "${teacher.userId }";
		document.teacherTypeForm.action = "/teach/" + url;
		document.teacherTypeForm.submit(); 
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
						<li onclick="fn_teachMove('teachNotice')">공지사항</li>
						<li class="active" onclick="fn_teachMove('teachQna')">학습Q&A</li>
						<li onclick="fn_teachMove('teachReview')">수강후기</li>
					</ul>

					<div class="content">

								<%@ include file="/WEB-INF/views/include/course/courseQnAViewIn.jsp"%>
		
								<button class="btn-list" id="btnList">목록</button>
							</div>
		
						</div>
					</section>



		</div>

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
		<input type="hidden" name="classCode" value="${classCode }">
		<input type="hidden" name="courseCode" value="${course.courseCode }">
		<input type="hidden" name="teacherId" value="${teacher.userId }">
	</form>
	
</body>
</html>
