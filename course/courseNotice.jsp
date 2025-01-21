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
<link href="/resources/css/course/courseNotice.css" rel="stylesheet">

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
			document.bbsForm.action = "/course/courseNotice";
			document.bbsForm.submit();
	   });
		
		
	});
	
	// 글쓰기 버튼
	function fn_write() {
	    document.bbsForm.brdSeq = "";
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.courseCode.value = ${course.courseCode};
	    document.bbsForm.action = "/course/courseNoticeWrite";
	    document.bbsForm.submit();
	}
	
	function fn_list(curPage) {
		document.bbsForm.brdSeq.value = "";
		document.bbsForm.curPage.value = curPage;
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.courseCode.value = ${course.courseCode};
		document.bbsForm.action = "/course/courseNotice";
		document.bbsForm.submit();
	}	
	
	// 글보기
	function fn_view(brdSeq) {
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.courseCode.value = ${course.courseCode};
		document.bbsForm.brdSeq.value = brdSeq;
		document.bbsForm.action = "/course/courseNoticeView"
		document.bbsForm.submit();
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
			<li class="active" onclick="fn_pageMove('courseNotice')">공지사항</li>
			<li onclick="fn_pageMove('courseQnA')">학습Q&A</li>
			<li onclick="fn_pageMove('courseReview')">수강후기</li>
		</ul>

		<div class="content">

			<div class="search-container">
				<div class="search-bar-sub">
					<select name="search-sort" name="_searchType" id="_searchType" >
			            <option value="1" <c:if test='${searchType eq "1"}'> selected </c:if> >작성자</option>
			            <option value="2" <c:if test='${searchType eq "2"}'> selected </c:if> >제목</option>
			            <option value="3" <c:if test='${searchType eq "3"}'> selected </c:if> >내용</option>
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


			<div class="lecture-list-container">
				<table class="notice-table">
					<thead>
						<tr>
							<th style="width: 10%;">번호</th>
							<th style="width: 40%;">제목</th>
							<th style="width: 20%">작성자</th>
							<th style="width: 20%;">등록일</th>
							<th style="width: 10%;">조회수</th>
						</tr>
					</thead>
					<tbody>
					
<c:if test="${!empty list }">		
<c:set var="brdSeq" value="${paging.startNum + 1}"/>
	<c:forEach var="notice" items="${list }" varStatus="status">
	<c:set var="brdSeq" value="${brdSeq - 1}" />
						<tr>
							<td>${brdSeq }</td>
							<td>
							 <a href="javascript:void(0)" onclick="fn_view(${notice.brdSeq})">
							${notice.brdTitle }
							</a>
							</td>
							<td>${notice.userName } 선생님</td>
							<td>${notice.regDate }</td>
							<td>${notice.brdReadCnt }</td>
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
		
		

<!--  강사만 글쓰기 가능 -->
<c:if test="${isTeacher eq 'Y' }">    
        <div class="freeWrite-container">
            <button class="free-write-button" onclick="fn_write()">글쓰기</button>
         </div>
   </c:if>    
		
		
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
	</form>
	
	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>
	
	
	
</body>
</html>
