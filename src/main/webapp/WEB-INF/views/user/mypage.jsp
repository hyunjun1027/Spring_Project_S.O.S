<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<!-- mypage CSS File -->
<link href="/resources/css/mypage/mypage.css" rel="stylesheet">

<link href="/resources/css/mypage/mypageMain.css" rel="stylesheet">

<script>
	function fn_mypageList(classCode) {
		document.bbsForm.curPage.value = "1";
		document.bbsForm.classCode.value = classCode;
		document.bbsForm.action = "/user/mypage";
		document.bbsForm.submit();
	}
	
	// 코스 상세보기 이동
	function fn_coursePage(courseCode) {
        document.bbsForm.classCode.value = ${classCode};
        document.bbsForm.courseCode.value = courseCode;
        document.bbsForm.action = "/course/courseMain";
        document.bbsForm.submit();
	}
	
	// 강사 페이지 이동
	function fn_teachMove(teacherId) {
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.teacherId.value = teacherId;
		document.bbsForm.action = "/teach/teachPage";
		document.bbsForm.submit(); 
	}
	
	//코스 상세보기
	function showCourseBtn(value) {
		document.bbsForm.courseCode.value = value;
		document.bbsForm.action = "/course/courseMain";
		document.bbsForm.submit();
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer">
			<div class="contentTopContainer">
				<div class="title-div">
					<h2 class="first-title">
						🧑‍🏫${account.userName }님
						<c:if test="${user.rating == 'U' }">
							오늘도 열공하세요
						</c:if>
						<c:if test="${user.rating == 'T' }">
							오늘도 수고 많으십니다
						</c:if>
					</h2>
				</div>
				<div class="myCourseContainer">
					<c:if test="${user.rating == 'U' }">
						<div>
							<h3>수강 중인 코스</h3>
							<div>
								<h3>
									<span>${myCourseIngCnt }</span>&nbsp;건
								</h3>
							</div>
							<span>현재 수강 건수</span>
						</div>
						<div>
							<h3>수강 완료 코스</h3>
							<div>
								<h3>
									<span>${myCourseFinCnt }</span>&nbsp;건
								</h3>
							</div>
							<span>2024년 완강 건수</span>
						</div>
					</c:if>
					<c:if test="${user.rating == 'T' }">
						<div>
							<h3>등록된 코스</h3>
							<div>
								<h3>
									<span>${myCourseCnt }</span>&nbsp;건
								</h3>
							</div>
							<span>현재 등록된 코스 건수</span>
						</div>
						<div>
							<h3>등록된 강의</h3>
							<div>
								<h3>
									<span>${myLectureCnt }</span>&nbsp;건
								</h3>
							</div>
							<span>현재 등록된 강의 건수</span>
						</div>
					</c:if>
				</div>
			</div>
			<div class="contentBottomContainer">
				<div class="title-div">
					<h2 class="first-title second-title">
						<c:if test="${user.rating == 'U' }">
							최근 수강한 강좌
						</c:if>
						<c:if test="${user.rating == 'T' }">
							최근 등록한 코스
						</c:if>
					</h2>
				</div>
				<div class="myRecentContainer">
					<c:if test="${user.rating == 'U' }">
						<div class="subjectList">
							<nav id="navmenu" class="navmenu">
								<ul>
									<li><a href="#" class="${classCode == 1 ? 'highlight' : ''}" onclick="fn_mypageList(1)" style="font-size: 19px; font-weight: 550;">국어</a></li>
									<li><a href="#" class="${classCode == 2 ? 'highlight' : ''}" onclick="fn_mypageList(2)" style="font-size: 19px; font-weight: 550;">영어</a></li>
									<li><a href="#" class="${classCode == 3 ? 'highlight' : ''}" onclick="fn_mypageList(3)" style="font-size: 19px; font-weight: 550;">수학</a></li>
									<li><a href="#" class="${classCode == 4 ? 'highlight' : ''}" onclick="fn_mypageList(4)" style="font-size: 19px; font-weight: 550;">사회</a></li>
									<li><a href="#" class="${classCode == 5 ? 'highlight' : ''}" onclick="fn_mypageList(5)" style="font-size: 19px; font-weight: 550;">과학</a></li>
								</ul>
							</nav>
						</div>

						<div class="subjectClassList">
							<c:forEach var="course" items="${course}" varStatus="status">
								<div class="subjectClassItem">
									<div>
										<img src="/resources/images/teacher/${course.userId }.png" class="teacher-photo">
									</div>
									<div>
										<div onclick="fn_teachMove('${course.userId}')" style="cursor: pointer; width: 200px;">
											<span class="teach-subject">[${className }]</span> <span class="teach-name">${course.userName }</span> 선생님 🏠
										</div>
										<div class="middle-container">
											<span class="teach-subject-title" onclick="fn_coursePage(${course.courseCode})" style="cursor: pointer;">${course.courseName }</span>
										</div>
										<div>
											나의 학습 진도율<span style="margin-left: 100px; margin-right: 10px;">${course.finLecCnt }/${course.lecCnt }강</span><span class="my-ing">[${course.progress }% 달성]</span>
										</div>
									</div>
								</div>
							</c:forEach>
						</div>
					</c:if>
					<c:if test="${user.rating == 'T' }">
						<div class="subjectClassList">
							<c:forEach var="courseRecentList" items="${teacherListRecent}" varStatus="status">
								<div class="subjectClassItem" onclick="showCourseBtn('${courseRecentList.courseCode}')">
									<div>
										<img src="/resources/img/subjectCover${teacherClassCode }.png" class="profile-photo2">
									</div>
									<div>
										<div>
											<span class="teach-subject">
												<c:if test="${teacherClassCode == '1'}">
													[국어]
												</c:if>
												<c:if test="${teacherClassCode == '2'}">
													[영어]
												</c:if>
												<c:if test="${teacherClassCode == '3'}">
													[수학]
												</c:if>
												<c:if test="${teacherClassCode == '4'}">
													[사회]
												</c:if>
												<c:if test="${teacherClassCode == '5'}">
													[과학]
												</c:if>
											</span>
										</div>
										<div class="middle-container">
											<span class="teach-subject-title">${courseRecentList.courseName }</span>
										</div>
										<div class="item-bottom">
											<div class="classCnt">강의 수 ${courseRecentList.lecCnt }/${courseRecentList.lecCnt }강</div>
										</div>
									</div>
								</div>
							</c:forEach>
						</div>
					</c:if>
				</div>
			</div>
		</div>
	</div>

	<form id="bbsForm" name="bbsForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="searchType" value="${searchType}">
		<input type="hidden" name="searchValue" value="${searchValue}">
		<input type="hidden" name="curPage" value="${curPage}" />
		<input type="hidden" name="courseCode" value="${courseCode}">
		<input type="hidden" name="teacherId" value="">
	</form>
</body>
</html>