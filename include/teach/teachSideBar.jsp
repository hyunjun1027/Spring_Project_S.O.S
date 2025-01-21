<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
	function fn_subjectType(index) {
 		document.teacherTypeForm.classCode.value = index;
		document.teacherTypeForm.action = "/teach/teachList";
		document.teacherTypeForm.submit(); 
	}
</script>

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