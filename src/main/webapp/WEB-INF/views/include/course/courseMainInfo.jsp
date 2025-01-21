<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script>
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

	// 강사 페이지 메뉴 이동
	function fn_pageMove(url) {
		document.teacherTypeForm.teacherId.value = "${teacher.userId }";
		document.teacherTypeForm.classCode.value = ${classCode };
		document.teacherTypeForm.courseCode.value = ${course.courseCode };
		document.teacherTypeForm.action = "/course/" + url;
		document.teacherTypeForm.submit(); 
	}
	
</script>

<style>
.sidebar .menu .highlight {
    color: var(--accent-color);
    border: none;
}
</style>

<section class="notice-section">
	<div class="notice-content">
		<div class="notice-text">
			<h1 class="mainTitle">Course</h1>
			<p class="mainContent">코스</p>
		</div>
		<div class="notice-image">
			<img src="/resources/img/Duck.png" alt="Duck Image">
		</div>
	</div>
</section>

<section class="content-section">
	<div class="sidebar">
		<div class="exam-date" id="d-day-display">
			2026 수능 <span class="days"></span>
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
		<div class="teach-container">

			<div class="lecture-card">

				<div class="lecture-content">
					<p class="subject" onclick="fn_teachMove('${teacher.userId}')" style="cursor: pointer; width: 200px;">
						<b>[${className }]</b> ${teacher.userName } 선생님<span class="home-icon">🏠</span>
					</p>
					<c:if test="${fn:length(course.courseName) > 27}">
						<div class="marquee-wrapper">
							<h2 class="lecture-title"><span>${course.courseName}</span></h2>
							<h2 class="lecture-title"><span>${course.courseName}</span></h2>
						</div>
					</c:if>
					<c:if test="${fn:length(course.courseName) <= 27}">
						<h2 class="lecture-title">${course.courseName }</h2>
					</c:if>
					<p class="progress-title">
						<b>학습 진도율</b>
					</p>
					<div class="progress-info">
						<table>
							<tr>
								<td><span class="dot total"></span><b>총 강의</b></td>
								<td><span class="progress-value total-count">${course.lecCnt }</span><span class="weak-emph">강</span></td>
							</tr>
							<tr>
								<td><span class="dot my-progress"></span><b>나의 학습 진도율</b></td>
								<td><span class="progress-value my-progress-count">${finishLecCnt }</span> <span class="weak-emph">/${course.lecCnt }강</span> <span class="weak-emph-percent">(${totalProgress }% 달성)</span></td>
							</tr>
						</table>
					</div>
				</div>

				<div class="lecture-image">
					<img src="/resources/images/teacher/${teacher.userId }.png" alt="강사 사진" />
				</div>
			</div>
		</div>