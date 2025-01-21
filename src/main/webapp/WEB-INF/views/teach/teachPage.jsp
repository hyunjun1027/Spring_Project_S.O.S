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
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
<style>
.header {
	background: #b5aaf2;
}

.fas.fa-star, .far.fa-star {
	font-size: 15px; /* 별 크기 */
	color: gold; /* 꽉 찬 별 색상 */
}

.far.fa-star {
	color: lightgray; /* 빈 별 색상 */
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(2)>a").addClass("active");
	});

	// 강사페이지 메뉴바 이동
	function fn_teachMove(url) {
 		document.teacherTypeForm.classCode.value = ${classCode};
 		document.teacherTypeForm.teacherId.value = "${teacher.userId }";
		document.teacherTypeForm.action = "/teach/" + url;
		document.teacherTypeForm.submit(); 
	}

	// 코스 상세보기 페이지 이동
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
	                if (res.code == 0) {
	                	Swal.fire({
	                		  title: "수강신청하시겠습니까?",
	                		  icon: "warning",
	                		  showCancelButton: true,
	                		  confirmButtonColor: "#3085d6",
	                		  cancelButtonColor: "#d33",
	                		  confirmButtonText: "신청",
	                		cancelButtonText:"취소"
	                		}).then((result) => {
	                		  if (result.isConfirmed) {

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
	                            success: function (res) {
	                                if (res.code == 0) {
	                                    document.teacherTypeForm.classCode.value = ${classCode};
	                                    document.teacherTypeForm.courseCode.value = courseCode;
	                                    document.teacherTypeForm.action = "/course/courseMain";
	                                    document.teacherTypeForm.submit();
	                                } else {
	                                    Swal.fire({
	                                		position: "center", 
	                                		icon: "warning",
	                                		title: response.data, 
	                                		showConfirmButton: false, 
	                                		timer: 1500 
	                                		});

	                                }
	                            },
	                            error: function (xhr, status, error) {
	                            	Swal.fire({
	                            		position: "center", 
	                            		icon: "warning",
	                            		title: "오류 발생...", 
	                            		showConfirmButton: false, 
	                            		timer: 1500 
	                            		});

	                                console.error(error);
	                            }
	                        });
	                	  }
	                });
	                } else if(res.code == 1) {
	                    document.teacherTypeForm.classCode.value = ${classCode};
	                    document.teacherTypeForm.courseCode.value = courseCode;
	                    document.teacherTypeForm.action = "/course/courseMain";
	                    document.teacherTypeForm.submit();
	                } else {
	                	Swal.fire({
	                		position: "center", 
	                		icon: "warning",
	                		title: response.data, 
	                		showConfirmButton: false, 
	                		timer: 1500 
	                		});
	                }
	            },
	            error: function (xhr, status, error) {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: "오류 발생...", 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});

	                console.error(error);
	            }
	        });
	    } else {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "로그인을 먼저 진행해주세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    }
	}

		
	function fn_goReview(brdSeq, courseCode) {
		document.bbsForm.brdSeq.value = brdSeq;
		document.bbsForm.courseCode.value = courseCode;
		document.bbsForm.action = "/teach/teachReviewView";
		document.bbsForm.submit();
	}
	
	//코스 삭제
	function fn_courseDel(courseCode)
	{
		Swal.fire({
			  title: "해당 코스를 삭제하시겠습니까?",
			  icon: "warning",
			  showCancelButton: true,
			  confirmButtonColor: "#3085d6",
			  cancelButtonColor: "#d33",
			  confirmButtonText: "삭제",
			cancelButtonText:"취소"
			}).then((result) => {
			  if (result.isConfirmed) {
			$.ajax({
				type:"POST",
				url:"/teach/courseDelete",
				dataType:"JSON",
				data:{
					courseCode:courseCode
				},
				beforeSend:function(xhr){
					xhr.setRequestHeader("AJAX", "true");
				},
				success:function(response){
					if(response.code == 0)
					{
						Swal.fire({
							position: "center", 
							icon: "success",
							title: "해당 코스 삭제 완료",
							showConfirmButton: false, 
							timer: 1500 
							}).then(function() {
								location.reload();
							});
					}
					else if(response.code == -401)
					{
						Swal.fire({
		            		position: "center", 
		            		icon: "warning",
		            		title: "파라메타 오류", 
		            		showConfirmButton: false, 
		            		timer: 1500 
		            		});
					}
					else if(response.code == -400)
					{
						Swal.fire({
		            		position: "center", 
		            		icon: "warning",
		            		title: "파라메타 오류2", 
		            		showConfirmButton: false, 
		            		timer: 1500 
		            		});

					}
					else if(response.code == -100)
					{
						Swal.fire({
		            		position: "center", 
		            		icon: "warning",
		            		title: "로그인을 먼저 진행해주세요", 
		            		showConfirmButton: false, 
		            		timer: 1500 
		            		});
					}
					else if(response.code == -101)
					{
						Swal.fire({
		            		position: "center", 
		            		icon: "warning",
		            		title: "삭제권한이 없습니다.", 
		            		showConfirmButton: false, 
		            		timer: 1500 
		            		});
					}
					else if(response.code == 40)
					{
						Swal.fire({
		            		position: "center", 
		            		icon: "warning",
		            		title: "코스 없음", 
		            		showConfirmButton: false, 
		            		timer: 1500 
		            		});
					}
				},
				error:function(xhr, status, error)
				{
					icia.common.error(error);
					Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: "코스 삭제 중 중 오류가 발생하였습니다.!", 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});

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
						<li class="active" onclick="fn_teachMove('teachPage')">HOME</li>
						<li onclick="fn_teachMove('teachCourse')">강좌목록</li>
						<li onclick="fn_teachMove('teachNotice')">공지사항</li>
						<li onclick="fn_teachMove('teachQna')">학습Q&A</li>
						<li onclick="fn_teachMove('teachReview')">수강후기</li>
					</ul>

					<div class="content">
						<div class="lecture-list-container">


							<c:if test="${!empty bestList }">
								<div>
									<div class="list-title" style="border: none;">수강후기</div>
									<div>
										<div class="review-box">
											<c:forEach var="best" items="${bestList }" varStatus="status">
												<div class="review-item" onclick="fn_goReview(${best.brdSeq}, ${best.courseCode})">
													<div>BEST</div>
													<div>
														<c:forEach var="i" begin="1" end="5">
															<c:choose>
																<c:when test="${i <= best.brdRating}">
																	<i class="fas fa-star"></i>
																</c:when>
																<c:otherwise>
																	<i class="far fa-star"></i>
																</c:otherwise>
															</c:choose>
														</c:forEach>
													</div>
													<div>${best.brdTitle }</div>
													<div>${best.brdContent }</div>
													<div>${best.userName }${best.regDate }</div>
												</div>
											</c:forEach>
										</div>
									</div>
								</div>
							</c:if>


							<div>
								<c:if test="${!empty teacherListRecent }">
									<div class="list-title">최신 강좌</div>

									<div class="subjectClassList">
									<c:if test="${cookieUserId == teacher.userId}">
										<c:forEach var="teacherListRecent1" items="${teacherListRecent1}" varStatus="status">
											<div class="subjectClassItem">
												<div>
													<img src="/resources/img/subjectCover${classCode }.png" class="profile-photo">
												</div>
												<div>
													<div>
														<span class="teach-subject">[${className }]</span> <span class="teach-name">${teacher.userName }</span> 선생님 🏠
													</div>
													<div class="middle-container">
														<span class="teach-subject-title">${teacherListRecent1.courseName }</span>
													</div>
													<div class="item-bottom">
														<div class="classCnt">강의 수 ${teacherListRecent1.lecCnt }/${teacherListRecent1.lecCnt }강</div>
														<c:if test="${cookieUserId != teacher.userId and account.rating != 'T' }">
															<c:if test="${teacherListRecent1.myCourseChk eq 0}">
																<button type="button" onclick="fn_coursePage(${teacherListRecent1.courseCode})">수강신청</button>
															</c:if>
															<c:if test="${teacherListRecent1.myCourseChk eq 1}">
																<button type="button" onclick="fn_coursePage(${teacherListRecent1.courseCode})" style="background: #cf4848; padding: 5px 35px;">수강 중</button>
															</c:if>
														</c:if>
														<c:if test="${cookieUserId == teacher.userId }">
															<button type="button" id=courseDel name="courseDel" onclick="fn_courseDel(${teacherListRecent1.courseCode})">코스 삭제</button>
														</c:if>
													</div>
												</div>
											</div>
										</c:forEach>
									</c:if>
									
									<c:if test="${cookieUserId != teacher.userId}">
										<c:forEach var="userListRecent" items="${userListRecent}" varStatus="status">
											<div class="subjectClassItem">
												<div>
													<img src="/resources/img/subjectCover${classCode }.png" class="profile-photo">
												</div>
												<div>
													<div>
														<span class="teach-subject">[${className }]</span> <span class="teach-name">${teacher.userName }</span> 선생님 🏠
													</div>
													<div class="middle-container">
														<span class="teach-subject-title">${userListRecent.courseName }</span>
													</div>
													<div class="item-bottom">
														<div class="classCnt">강의 수 ${userListRecent.lecCnt }/${userListRecent.lecCnt }강</div>
														<c:if test="${cookieUserId != teacher.userId and account.rating != 'T' }">
															<c:if test="${userListRecent.myCourseChk eq 0}">
																<button type="button" onclick="fn_coursePage(${userListRecent.courseCode})">수강신청</button>
															</c:if>
															<c:if test="${userListRecent.myCourseChk eq 1}">
																<button type="button" onclick="fn_coursePage(${userListRecent.courseCode})" style="background: #cf4848; padding: 5px 35px;">수강 중</button>
															</c:if>
														</c:if>
														<c:if test="${cookieUserId == teacher.userId }">
															<button type="button" id=courseDel name="courseDel" onclick="fn_courseDel(${userListRecent.courseCode})">코스 삭제</button>
														</c:if>
													</div>
												</div>
											</div>
										</c:forEach>
									
									
									
									
									</c:if>
										
									</div>
								</c:if>
							</div>

							<div>
								<c:if test="${!empty listPopular }">
									<div class="list-title">인기 강좌</div>

									<div class="subjectClassList">
										<c:forEach var="coursePopularList" items="${listPopular}" varStatus="status">
											<div class="subjectClassItem">
												<div>
													<img src="/resources/img/subjectCover${classCode }.png" class="profile-photo">
												</div>
												<div>
													<div>
														<span class="teach-subject">[${className }]</span> <span class="teach-name">${teacher.userName }</span> 선생님 🏠
													</div>
													<div class="middle-container">
														<span class="teach-subject-title">${coursePopularList.courseName }</span>
													</div>
													<div class="item-bottom">
														<div class="classCnt">강의 수 ${coursePopularList.lecCnt }/${coursePopularList.lecCnt }강</div>
														<c:if test="${cookieUserId != teacher.userId and account.rating != 'T' }">
															<c:if test="${coursePopularList.myCourseChk eq 0}">
																<button type="button" onclick="fn_coursePage(${coursePopularList.courseCode})">수강신청</button>
															</c:if>
															<c:if test="${coursePopularList.myCourseChk eq 1}">
																<button type="button" onclick="fn_coursePage(${coursePopularList.courseCode})" style="background: #cf4848; padding: 5px 35px;">수강 중</button>
															</c:if>
														</c:if>
														<c:if test="${cookieUserId == teacher.userId }">
															<button type="button" id=courseDel name="courseDel" onclick="fn_courseDel(${coursePopularList.courseCode})">코스 삭제</button>
														</c:if>
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
			</div>
		</div>
	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="brdSeq" value="">
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
		<input type="hidden" name="curPage" value="">
	</form>
</body>
</html>
