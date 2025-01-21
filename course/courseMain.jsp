<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/course/courseMain.css" rel="stylesheet">
<style>
.header {
	background: #b5aaf2;
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(2)>a").addClass("active");
	});

	// 강사 페이지 메뉴 이동
	function fn_pageMove(url) {
		document.teacherTypeForm.teacherId.value = "${teacher.userId }";
		document.teacherTypeForm.classCode.value = ${classCode };
		document.teacherTypeForm.courseCode.value = ${course.courseCode };
		document.teacherTypeForm.action = "/course/" + url;
		document.teacherTypeForm.submit(); 
	}

	function fn_bookView() {
		const modal = document.getElementById("bookModal");
		modal.style.display = "block"; // 모달 표시
	}

	function closeModal() {
		const modal = document.getElementById("bookModal");
		modal.style.display = "none"; // 모달 닫기
	}

	// ESC 키로 모달 닫기
	window.addEventListener("keydown", function(event) {
		if (event.key === "Escape") {
			closeModal();
		}
	});

	// 배경 클릭으로 모달 닫기
	window.addEventListener("click", function(event) {
		const modal = document.getElementById("bookModal");
		if (event.target === modal) {
			closeModal();
		}
	});

	//교재 상세보기
	function fn_view(bookSeq)
	{
		document.teacherTypeForm.classCode.value = ${classCode};
		document.teacherTypeForm.bookSeq.value = bookSeq;
		document.teacherTypeForm.action = "/book/bookDetail";
		document.teacherTypeForm.submit();
	}
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<%@ include file="/WEB-INF/views/include/course/courseMainInfo.jsp"%>

	<div class="course-page">
		<ul class="tab-menu">
			<li class="active" onclick="fn_pageMove('courseMain')">강좌소개</li>
			<li onclick="fn_pageMove('courseList')">강의목록</li>
			<li onclick="fn_pageMove('courseNotice')">공지사항</li>
			<li onclick="fn_pageMove('courseQnA')">학습Q&A</li>
			<li onclick="fn_pageMove('courseReview')">수강후기</li>
		</ul>

		<!-- Modal Structure -->
		<div id="bookModal" class="modal">
			<div class="modal-content2">
				<span class="close-btn" onclick="closeModal()">&times;</span>
				<h3 style="color: black; font-weight: bold">SOS 교재 안내</h3>
				<div class="book-container">
					<img src="/resources/images/book/${book.bookSeq }.jpg" alt="교재 이미지" class="book-image">
					<div class="book-details">
						<h3 style="font-weight: bold">
							<a href="#"  onclick="fn_view(${book.bookSeq})">${book.bookTitle }</a>
						</h3>
						<div class="book-table-div">
							<table class="book-table">
								<tr>
									<td><b>영역</b></td>
									<td>${className }</td>
									<td>&nbsp;&nbsp;&nbsp;</td>
									<td><b>종이책 정가</b></td>
									<td>${book.bookPrice }원</td>
								</tr>
								<tr>
									<td><b>출판사</b></td>
									<td>${book.bookPublisher }</td>
									<td></td>
									<td><b>종이책 판매가</b></td>
									<td style="color: red; font-size: 22px; font-weight: bold">${book.bookPayPrice }원</td>
								</tr>
								<tr>
									<td><b>발행일</b></td>
									<td>${book.issueDate }</td>
									<td></td>
									<td></td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="content">
			<div class="description-section">
				<h3 class="section-title">강좌설명</h3>
				<pre class="description">${course.courseDetail }</pre>
			</div>

			<div class="lecture-info">
				<h3 class="section-title">강좌정보</h3>
				<table class="course-info">
					<tr>
						<td><span class="icon">📖</span> 과목</td>
						<td>${className }</td>
					</tr>
					<tr>
						<td><span class="icon">😊</span> 학년</td>
						<td>고3</td>
					</tr>
					<tr>
						<td><span class="icon">📚</span> 교재</td>
						<td><a href="javascript:void(0)" onclick="fn_bookView()">${book.bookTitle }</a></td>
					</tr>
					<tr>
						<td><span class="icon">⭐</span> 평균별점</td>
						<td class="rating">★★★★★</td>
					</tr>
					<tr>
						<td><span class="icon">🎥</span> 제작 강수</td>
						<td>${course.lecCnt }</td>
					</tr>
				</table>
			</div>
		</div>
	</div>


	</div>

	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
	
	
	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
		<input type="hidden" name="bookSeq" value="${book.bookSeq}">
	</form> 
</body>
</html>
