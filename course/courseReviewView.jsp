<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<!-- 이 CSS 가장 우선순위 높게 해야 에디터 안에 적용한 CSS들 제대로 뜹니다!!!!!!!!!!! -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">

<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/course/courseMain.css" rel="stylesheet">
<link href="/resources/css/course/courseReviewView.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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

.table-container {
	margin-left: 0px;
}

</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(2)>a").addClass("active");
		
		// 목록 버튼 클릭시
		$("#btnList").on("click", function() {
			document.bbsForm.classCode.value = ${classCode};
			document.bbsForm.courseCode.value = ${course.courseCode};
			document.bbsForm.action = "/course/courseReview";
			document.bbsForm.submit();
		});
	});
	


</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<%@ include file="/WEB-INF/views/include/course/courseMainInfo.jsp"%>

	<div class="course-page">
		<ul class="tab-menu">
			<li onclick="fn_pageMove('courseMain')">강좌소개</li>
			<li onclick="fn_pageMove('courseList')">강의목록</li>
			<li onclick="fn_pageMove('courseNotice')">공지사항</li>
			<li onclick="fn_pageMove('courseQnA')">학습Q&A</li>
			<li class="active" onclick="fn_pageMove('courseReview')">수강후기</li>
		</ul>


		<div class="content">

		<div class="table-container" style="width: 100%;">

			<%@ include file="/WEB-INF/views/include/course/courseReviewIn.jsp"%>

						<button class="btn-list" id="btnList">목록</button>
					</div>


				</div>
			</section>
		</div>

		</div>
	</div>


	</div>

	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
	
	<form name="bbsForm" id="bbsForm" method="post">
   		<input type="hidden" name="brdSeq" id="brdSeq" value="${brdSeq }">
   		<input type="hidden" name="searchType" id="searchType" value="${searchType }">
   		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue }">
   		<input type="hidden" name="curPage" id="curPage" value="${curPage }">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>
	
	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>
	
</body>
</html>
