<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/course/allCourse.css" rel="stylesheet">
<style>
.header {
   background: #e8c8c3;
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(1)>a").addClass("active");
	});

	function fn_subjectType(index) {
		document.teacherTypeForm.classCode.value = index;
		document.teacherTypeForm.action = "/course/allCourse";
		document.teacherTypeForm.submit();
	}
	
	/* 페이징 */
	function fn_list(curPage) {
	   document.teacherTypeForm.curPage.value = curPage;
	   document.teacherTypeForm.classCode.value = ${classCode};
	   document.teacherTypeForm.action = "/course/allCourse";
	   document.teacherTypeForm.submit();
	}
	
	// 코스 상세보기 이동
	function fn_coursePage(courseCode) {
	    if ("${account}" != null && "${account}" != "") {
	    	$.ajax({
	            type: "POST",
	            url: "/course/myCourseSelect",
	            data: {
	                userId: '${account.userId}',
	                courseCode: courseCode
	            },
	            dataType: "JSON",
	            beforeSend: function (xhr) {
	                xhr.setRequestHeader("AJAX", "true");
	            },
	            success: function (res) {
	                if (res.code == 0) 
	                {
	                	
	                	Swal.fire({
	                        title: "수강신청하시겠습니까?",
	                        icon: "question",
	                        showCancelButton: true,
	                        confirmButtonColor: "#3085d6",
	                        cancelButtonColor: "#d33",
	                        confirmButtonText: "확인",
	                        cancelButtonText: "돌아가기"
	                    }).then((result) => {
	                        if (result.isConfirmed) {
	                            // AJAX 요청
	                        $.ajax({
	                            type: "POST",
	                            url: "/course/myCourseInsert",
	                            data: {
	                                userId: '${account.userId}',
	                                courseCode: courseCode
	                            },
	                            dataType: "JSON",
	                            beforeSend: function (xhr) {
	                                xhr.setRequestHeader("AJAX", "true");
	                            },
                    		    success: function(res) {
                    		        if (res.code === 0) 
                    		        {
	                                    document.teacherTypeForm.classCode.value = ${classCode};
	                                    document.teacherTypeForm.courseCode.value = courseCode;
	                                    document.teacherTypeForm.action = "/course/courseMain";
	                                    document.teacherTypeForm.submit();
                    		        } 
                    		        else 
                    		        {
                                        Swal.fire({
                                            title: "Error!",
                                            text: "오류가 발생하였습니다. 다시 시도해주세요.",
                                            icon: "error"
                                        });
                    		            
                    		        }
                    		    },
                    		    error: function(xhr, status, error) {
                                    Swal.fire({
                                        title: "Error!",
                                        text: "삭제 중 오류가 발생했습니다2",
                                        icon: "error"
                                    });
                    		    }
                    		});
                        }
                    });
                	

	                	
	                } 
	                else if(res.code == 1) {
	                    document.teacherTypeForm.classCode.value = ${classCode};
	                    document.teacherTypeForm.courseCode.value = courseCode;
	                    document.teacherTypeForm.action = "/course/courseMain";
	                    document.teacherTypeForm.submit();
	                } 
	                else {
                        Swal.fire({
                            title: "Error!",
                            text: "오류가 발생하였습니다. 다시 시도해주세요.",
                            icon: "error"
                        });
	                }
	            },
	            error: function (xhr, status, error) {
                    Swal.fire({
                        title: "Error!",
                        text: "오류가 발생하였습니다. 다시 시도해주세요.",
                        icon: "error"
                    });
	                console.error(error);
	            }
	        });
	    } else {
            Swal.fire({
                title: "Error!",
                text: "로그인을 먼저 진행해주세요",
                icon: "error"
            });
	    }
	}
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>


	<section class="notice-section">
		<div class="notice-content">
			<div class="notice-text">
				<h1 class="mainTitle">ALL COURSE</h1>
				<p class="mainContent">모든 강좌</p>
			</div>
			<div class="notice-image">
				<img src="/resources/img/Duck.png" alt="Duck Image">
			</div>
		</div>
	</section>


	<section class="content-section">
		<div class="sidebar">
			<div class="exam-date" id="d-day-display">
				2026 수능 <span class="days">D</span>
			</div>
			<ul class="menu">
				<li><a href="javascript:void(0)" onclick="fn_subjectType(1)" <c:if test="${classCode eq 1}"> class="highlight" </c:if>>국어</a></li>
				<li><a href="javascript:void(0)" onclick="fn_subjectType(2)" <c:if test="${classCode eq 2}"> class="highlight" </c:if>>영어</a></li>
				<li><a href="javascript:void(0)" onclick="fn_subjectType(3)" <c:if test="${classCode eq 3}"> class="highlight" </c:if>>수학</a></li>
				<li><a href="javascript:void(0)" onclick="fn_subjectType(4)" <c:if test="${classCode eq 4}"> class="highlight" </c:if>>사회</a></li>
				<li><a href="javascript:void(0)" onclick="fn_subjectType(5)" <c:if test="${classCode eq 5}"> class="highlight" </c:if>>과학</a></li>
			</ul>
		</div>

		<div class="course-page">

			<div class="lecture-page">
				<h2 class="page-title">전강좌 수강권 강좌신청</h2>
				<div class="lecture-container">
					<!-- 요즘 HOT 인기 강의 -->
					<div class="lecture-column">

						<div class="column-title-div">
							<h3 class="column-title">요즘 HOT 인기 강의, TOP 5 🔥</h3>
						</div>

						<ul class="lecture-list">

							<c:if test="${!empty listPopular }">
								<c:forEach var="popularList" items="${listPopular}" varStatus="status">
									<c:set var="i" value="${i+1 }" />
									<div class="lecture-list-info">
										<li><span class="rank">${i }</span> <img src="/resources/images/teacher/${popularList.userId }.png" alt="강사" class="teacher-image">
											<div class="lecture-info">

												<div class="subject-div">
													<div class="subject-name-div">	
														<span class="subject-name">${popularList.className }</span>
													</div>

													<span class="teacher-name">${popularList.userName } 선생님</span><br>
												</div>

												<span class="lecture-title" style="cursor: pointer;" onclick="fn_coursePage(${popularList.courseCode})">${popularList.courseName }</span>
											</div></li>
									</div>
								</c:forEach>
							</c:if>

						</ul>
					</div>

					<!-- 리얼후기 주간 리뷰 좋은 강의 -->
					<div class="lecture-column">

						<div class="column-title-div">
							<h3 class="column-title">리얼후기! 주간 리뷰 좋은 강의 TOP 5 🔥</h3>
						</div>

						<ul class="lecture-list">

							<c:if test="${!empty listReview }">
								<c:forEach var="reviewList" items="${listReview}" varStatus="status">
									<c:set var="j" value="${j+1 }" />
									<div class="lecture-list-info">
										<li><span class="rank">${j }</span> <img src="/resources/images/teacher/${reviewList.userId }.png" alt="강사" class="teacher-image">
											<div class="lecture-info">

												<div class="subject-div">
													<div class="subject-name-div">
														<span class="subject-name">${reviewList.className }</span>
													</div>

													<span class="teacher-name">${reviewList.userName } 선생님</span><br>
												</div>

												<span class="lecture-title" style="cursor: pointer;" onclick="fn_coursePage(${reviewList.courseCode})">${reviewList.courseName }</span>
											</div></li>
									</div>
								</c:forEach>
							</c:if>

						</ul>
					</div>

				</div>
			</div>


			<div class="all-lecture-view">
				<div class="all-lecture-div">
					<h3 class="column-title-all">전체 강좌 > ${className } 전체</h3>
				</div>

				<c:if test="${!empty list }">
					<c:forEach var="allCourse" items="${list}" varStatus="status">
						<div class="lecture-course-div">
							<span>${allCourse.userName } 선생님</span> <span class="course-name">${allCourse.courseName } (${allCourse.lecCnt }강)</span>
							<button class="apply-button" onclick="fn_coursePage(${allCourse.courseCode})">강좌신청</button>
						</div>
					</c:forEach>
				</c:if>
			</div>

	
		
			<div class="pagination">
				<c:if test="${!empty paging}">

					<c:if test="${paging.prevBlockPage gt 0}">
						<button class="pagination-button" href="#" onclick="fn_list(${paging.prevBlockPage})">&laquo;</button>
					</c:if>


					<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
						<c:choose>
							<c:when test="${i eq curPage}">
								<span class="pagination-number active">${i}</span>
							</c:when>
							<c:otherwise>
								<span class="pagination-number"><a class="page-link" href="#" onclick="fn_list(${i})">${i}</a></span>
							</c:otherwise>
						</c:choose>
						<c:if test="${i lt paging.endPage}">
							<span class="pagination-separator">|</span>
						</c:if>
					</c:forEach>


					<c:if test="${paging.nextBlockPage gt 0}">
						<button class="pagination-button" href="#" onclick="fn_list(${paging.nextBlockPage})">&raquo;</button>
					</c:if>

				</c:if>
			</div>
		
		
		
		
		
		
		
		</div>
	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
		<input type="hidden" name="curPage" value="">
	</form>
</body>
</html>
