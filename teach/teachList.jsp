<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/teach/teachList.css" rel="stylesheet">
<style>
.header {
	background: #b5aaf2;
}
</style>
<script>
   $(function() {
      $("#navmenu>ul>li:nth-child(2)>a").addClass("active");
   });

   function fn_teachMove(teacherId) {
       document.teacherTypeForm.classCode.value = ${classCode};
       document.teacherTypeForm.teacherId.value = teacherId;
      document.teacherTypeForm.action = "/teach/teachPage";
      document.teacherTypeForm.submit(); 
   }
   
   function fn_subjectType(index) {
       document.teacherTypeForm.classCode.value = index;
      document.teacherTypeForm.action = "/teach/teachList";
      document.teacherTypeForm.submit();
   }
   
   // 최신 공지 페이지 이동
   function fn_noticeRec(brdSeq, teacherId, courseCode) {
      document.bbsForm.brdSeq.value = brdSeq;
      document.bbsForm.classCode.value = ${classCode};
      document.bbsForm.courseCode.value = courseCode;
      document.bbsForm.teacherId.value = teacherId;
      document.bbsForm.action = "/teach/teachNoticeView";
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
		<div class="sidebar">
			<div class="exam-date" id="d-day-display">
				2026 수능 <span class="days">D-287</span>
			</div>
			<ul class="menu">
				<li><a href="javascript:void(0)" onclick="fn_subjectType(1)" <c:if test="${classCode eq 1}"> class="highlight" </c:if>>국어</a></li>
				<li><a href="javascript:void(0)" onclick="fn_subjectType(2)" <c:if test="${classCode eq 2}"> class="highlight" </c:if>>영어</a></li>
				<li><a href="javascript:void(0)" onclick="fn_subjectType(3)" <c:if test="${classCode eq 3}"> class="highlight" </c:if>>수학</a></li>
				<li><a href="javascript:void(0)" onclick="fn_subjectType(4)" <c:if test="${classCode eq 4}"> class="highlight" </c:if>>사회</a></li>
				<li><a href="javascript:void(0)" onclick="fn_subjectType(5)" <c:if test="${classCode eq 5}"> class="highlight" </c:if>>과학</a></li>
			</ul>
		</div>
		<div class="table-container">

			<c:if test="${!empty noticeRec }">
				<h2 class="subTitle">새소식</h2>
				<table class="notice-table">
					<thead>
						<tr>
							<th style="width: 10%;"></th>
							<th style="width: 15%;"></th>
							<th style="width: 75%;"></th>
						</tr>
					</thead>
					<tbody>


						<c:forEach var="notice" items="${noticeRec }" varStatus="status">
							<tr>
								<td><div class="new-notice">공지</div></td>
								<td>${notice.userName }선생님</td>

								<td><a style="color: black;" href="javascript:void(0)" onclick="fn_noticeRec(${notice.brdSeq}, '${notice.userId}', ${notice.courseCode })"> ${notice.brdTitle } </a></td>

							</tr>
						</c:forEach>


					</tbody>
				</table>
			</c:if>

			<!--  과목별로  분류해서 처리 -->
			<div class="teach-container">

				<div class="teach-kind-cnt">
					${className } 선생님 :&nbsp; <span>${totalCount}명</span>
				</div>
				<div class="teach-box">

					<c:if test="${!empty teacherList }">

						<c:forEach var="teacher" items="${teacherList }" varStatus="status">

							<div class="teach-item" onclick="fn_teachMove('${teacher.userId}')">
								<div>
									<span>${teacher.userIntro } </span>
								</div>
								<h4>
									${teacher.userName }<br>선생님
								</h4>

								<img src="/resources/images/teacher/${teacher.userId }.png" alt="teacher Image">

							</div>

						</c:forEach>
					</c:if>
				</div>
			</div>


		</div>
	</section>

	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>


	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="brdSeq" value="">
		<input type="hidden" name="searchType" id="searchType" value="${searchType }">
		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue }">
		<input type="hidden" name="curPage" id="curPage" value="${curPage }">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>


</body>
</html>
