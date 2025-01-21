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
<link href="/resources/css/course/courseQnA.css" rel="stylesheet">
<link href="/resources/css/course/courseReview.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<style>
.header {
	background: #b5aaf2;
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(2)>a").addClass("active");
		
	   // 검색
	   $("#btnSearch").on("click", function() {
			document.bbsForm.brdSeq.value = "";
			document.bbsForm.classCode.value = ${classCode};
			document.bbsForm.courseCode.value = ${course.courseCode};
			document.bbsForm.searchType.value = $("#_searchType").val();
			document.bbsForm.searchValue.value = $("#_searchValue").val();
			document.bbsForm.curPage.value = "1";
			document.bbsForm.action = "/course/courseReview";
			document.bbsForm.submit();
	   });
	   
	   // 내가 쓴 글 조회
	   $("#btnMyBrd").on("click", function() {
		   
		    const btn = this; // 현재 버튼 요소
		    let myBrdChk = ""; // myBrdChk 값

		    // 내가 쓴 글 체크가 안 되어 있다면
		    if ("${myBrdChk}" == "N") {
		        myBrdChk = "Y"; // 값 설정
		        btn.classList.remove("my-post-btn");
		        btn.classList.add("my-post-btn-active");
		    } else if ("${myBrdChk}" == "Y") {
		        myBrdChk = "N"; // 값 설정
		        btn.classList.remove("my-post-btn-active");
		        btn.classList.add("my-post-btn");
		    }
		   
 		    document.bbsForm.courseCode.value = 1;
			document.bbsForm.brdSeq.value = "";
			document.bbsForm.curPage.value = "1";
			document.bbsForm.myBrdChk.value = myBrdChk;
			document.bbsForm.classCode.value = ${classCode};
			document.bbsForm.courseCode.value = ${course.courseCode};
			document.bbsForm.action = "/course/courseReview";
			document.bbsForm.submit(); 
	   });
	   
	});
	
	function fn_list(curPage) {
		document.bbsForm.brdSeq.value = "";
		document.bbsForm.curPage.value = curPage;
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.courseCode.value = ${course.courseCode};
		document.bbsForm.action = "/course/courseReview";
		document.bbsForm.submit();
	}	
	
	// 글보기
	function fn_view(brdSeq) {
		document.bbsForm.brdSeq.value = brdSeq;
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.courseCode.value = ${course.courseCode};
		document.bbsForm.action = "/course/courseReviewView"
		document.bbsForm.submit();
	}
	
	// 글쓰기
	function fn_write() {
		if(${totalProgress < 50}) {
            Swal.fire({
                title: "Error",
                text: "수강 후기는 학습 진도율이 50% 이상이신 분만 작성 가능합니다!",
                icon: "error"
            });
            
			return;
		}
		
		$.ajax({
			type: "POST",
			url: "/course/courseReviewWriteCheck",
			data: {
				courseCode: ${course.courseCode}
			},
			datatype: "JSON",
			beforeSend: function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success: function(res) {
				if (res.code == 0) {
				  	document.bbsForm.brdSeq = "";
					document.bbsForm.classCode.value = ${classCode};
					document.bbsForm.courseCode.value = ${course.courseCode};
				  	document.bbsForm.action = "/course/courseReviewWrite";
				  	document.bbsForm.submit();
				}
				else {
		            Swal.fire({
		                title: "Error",
		                text: "후기를 이미 작성했거나 후기를 작성할 수 없습니다.",
		                icon: "error"
		            });
					
				}
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
	            Swal.fire({
	                title: "Error",
	                text: "오류가 발생하였습니다. 다시 시도해주세요.",
	                icon: "error"
	            });
				
			}
		});
	}
	
	
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

			<div class="search-container">
				<div class="search-bar-sub">
					<select name="search-sort" name="_searchType" id="_searchType">
						<option value="1" <c:if test='${searchType eq "1"}'> selected </c:if>>작성자</option>
						<option value="2" <c:if test='${searchType eq "2"}'> selected </c:if>>제목</option>
						<option value="3" <c:if test='${searchType eq "3"}'> selected </c:if>>내용</option>
					</select>
				</div>

				<div class="search-bar">
					<input type="text" name="_searchValue" id="_searchValue" value="${searchValue}" class="search-input" placeholder="검색어를 입력하세요" />
					<button class="search-button" id="btnSearch">
						<svg xmlns="http://www.w3.org/2000/svg" height="24" width="24" fill="#555">
			                <circle cx="11" cy="11" r="7" stroke="#555" stroke-width="2" fill="none"></circle>
			                <line x1="16" y1="16" x2="21" y2="21" stroke="#555" stroke-width="2" />
			            </svg>
					</button>
				</div>
			</div>

			<div class="total-post">
				<div class="total-post-count">
					게시글 <span style="color: red;">${totalCount }개</span>
				</div>
				<div class="my-post">
					<button type="button" id="btnMyBrd" <c:if test="${myBrdChk eq 'Y' }">
						class="my-post-btn-active"
						</c:if> <c:if test="${myBrdChk eq 'N' }">
						class="my-post-btn"
						</c:if>>내가 쓴 글 보기</button>
				</div>
			</div>


			<div class="lecture-list-container">
				<table class="notice-table">
					<thead>
						<tr>
							<th style="width: 35%;">강좌명</th>
							<th style="width: 25%">제목</th>
							<th style="width: 20%;">평가</th>
							<th style="width: 10%;">등록일</th>
							<th style="width: 10%;">조회수</th>
						</tr>
					</thead>
					<tbody>

						<c:if test="${!empty list }">
							<c:forEach var="review" items="${list }" varStatus="status">
								<tr>
									<td>${review.courseName }</td>
									<td><a href="javascript:void(0)" onclick="fn_view(${review.brdSeq})"> ${review.brdTitle } </a></td>

									<td><c:forEach var="i" begin="1" end="5">
											<c:choose>
												<c:when test="${i <= review.brdRating}">
													<i class="fas fa-star"></i>
												</c:when>
												<c:otherwise>
													<i class="far fa-star"></i>
												</c:otherwise>
											</c:choose>

										</c:forEach></td>

									<td>${review.regDate }</td>
									<td>${review.brdReadCnt }</td>
								</tr>
							</c:forEach>
						</c:if>

						<c:if test="${empty list }">
							<tr>
								<td colspan="5">해당하는 게시글이 존재하지 않습니다.</td>
							</tr>
						</c:if>

					</tbody>
				</table>
			</div>
		</div>


		<div class="freeWrite-container">
            <button class="free-write-button" onclick="fn_write()">글쓰기</button>
         </div>	
         
		
		<!--  페이징 버튼 -->

			<div class="pagination">
				<c:if test="${!empty paging}">

					<c:if test="${paging.prevBlockPage gt 0}">
						<button class="pagination-button" href="#" onclick="fn_Page(${paging.prevBlockPage})">&laquo;</button>
					</c:if>


					<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
						<c:choose>
							<c:when test="${i eq curPage}">
								<span class="pagination-number active">${i}</span>
							</c:when>
							<c:otherwise>
								<span class="pagination-number"><a class="page-link" href="#" onclick="fn_Page(${i})">${i}</a></span>
							</c:otherwise>
						</c:choose>
						<c:if test="${i lt paging.endPage}">
							<span class="pagination-separator">|</span>
						</c:if>
					</c:forEach>


					<c:if test="${paging.nextBlockPage gt 0}">
						<button class="pagination-button" href="#" onclick="fn_Page(${paging.nextBlockPage})">&raquo;</button>
					</c:if>

				</c:if>
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
   		<input type="hidden" name="myBrdChk" id="myBrdChk" value="">
	</form>
	
	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>
</body>
</html>
