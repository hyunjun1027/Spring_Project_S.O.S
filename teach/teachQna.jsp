<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/teach/teachNotice.css" rel="stylesheet">
<link href="/resources/css/teach/teachQnA.css" rel="stylesheet">
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
				document.bbsForm.searchType.value = $("#_searchType").val();
				document.bbsForm.searchValue.value = $("#_searchValue").val();
				document.bbsForm.curPage.value = "1";
				document.bbsForm.teacherId.value = "${teacher.userId }";
				document.bbsForm.action = "/teach/teachQna";
				document.bbsForm.submit();
		   });
	});
	
	function fn_view(brdSeq, courseCode) {
		document.bbsForm.brdSeq.value = brdSeq;
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.teacherId.value = "${teacher.userId }";
		document.bbsForm.courseCode.value = courseCode;
		document.bbsForm.action = "/teach/teachQnAView";
		document.bbsForm.submit();
	}

	function fn_teachMove(url) {
 		document.teacherTypeForm.classCode.value = ${classCode};
 		document.teacherTypeForm.teacherId.value = "${teacher.userId }";
		document.teacherTypeForm.action = "/teach/" + url;
		document.teacherTypeForm.submit(); 
	}
	
	function fn_list(curPage) {
		document.bbsForm.brdSeq.value = "";
		document.bbsForm.curPage.value = curPage;
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.teacherId.value = "${teacher.userId}";
		document.bbsForm.action = "/teach/teachQna";
		document.bbsForm.submit();
	}

	function fn_subjectType(index) {
 		document.teacherTypeForm.classCode.value = index;
		document.teacherTypeForm.action = "/teach/teachList";
		document.teacherTypeForm.submit(); 
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
						<li onclick="fn_teachMove('teachPage')">HOME</li>
						<li onclick="fn_teachMove('teachCourse')">강좌목록</li>
						<li onclick="fn_teachMove('teachNotice')">공지사항</li>
						<li class="active" onclick="fn_teachMove('teachQna')">학습Q&A</li>
						<li onclick="fn_teachMove('teachReview')">수강후기</li>
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
							<div>게시글 <span>${totalCount}개</span></div>
								<table class="notice-table">
									<thead>
										<tr>
											<th style="width: 10%;">번호</th>
											<th style="width: 25%;">강좌명</th>
											<th style="width: 30%;">제목</th>
											<th style="width: 15%">작성자</th>
											<th style="width: 10%;">등록일</th>
											<th style="width: 10%;">조회수</th>
										</tr>
									</thead>
									<tbody>
								
<c:if test="${!empty list }">
<c:set var="brdSeq" value="${index + 1}"/>
   <c:forEach var="qna" items="${list }" varStatus="status">

	         <c:choose>
	            <%-- 답글 --%>
	            <c:when test="${qna.brdParent gt 0}">
	                  <tr class="reply-write">
	                     <td></td>
	                     <td></td>
	                     <td>
	                        <!-- 답글 아이콘 --> 
	                        <span class="reply-icon"> <img src="/resources/img/reply.png">
	                     </span> 
	                     <a href="javascript:void(0)" onclick="fn_view(${qna.brdSeq}, ${qna.courseCode })" style="color: black;">
	                     	<b>${qna.brdTitle }</b>
	                     </a>
	                     </td>
	                     <td>${qna.userName } 선생님</td>
	                     <td>${qna.regDate }</td>
	                     <td>${qna.brdReadCnt }</td>
	                  </tr>
	            </c:when>
	            
	            <c:otherwise>
	            <c:set var="brdSeq" value="${brdSeq - 1}" />
	                  <tr>
	                     <td>${brdSeq }</td>
	                     <td>${qna.courseName }</td>
	                     <td>
	                      <a href="javascript:void(0)" onclick="fn_view(${qna.brdSeq}, ${qna.courseCode })" style="color: black;">
	                     	<b>${qna.brdTitle }</b>
	                     </a>
	                     </td>
	                     <td>${qna.userName }</td>
	                     <td>${qna.regDate }</td>
	                     <td>${qna.brdReadCnt }</td>
	                  </tr>
	            </c:otherwise>
	            
	         </c:choose>      


   </c:forEach>
</c:if>

<c:if test="${empty list }">
				<tr>
					<td colspan="6">해당하는 게시글이 존재하지 않습니다.</td>
				</tr>
</c:if>


									<!-- Add more rows as needed -->
								</tbody>
							</table>
						</div>
					</div>
					
      <!--  페이징 버튼 -->
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
			</div>
		</div>
	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

	<form name="bbsForm" id="bbsForm" method="post">
   		<input type="hidden" name="brdSeq" value="${brdSeq }">
   		<input type="hidden" name="searchType" id="searchType" value="${searchType }">
   		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue }">
   		<input type="hidden" name="curPage" id="curPage" value="${curPage }">
		<input type="hidden" name="classCode" value="${classCode }">
		<input type="hidden" name="courseCode" value="${course.courseCode }">
		<input type="hidden" name="teacherId" value="${teacher.userId }">
   		<input type="hidden" name="myBrdChk" id="myBrdChk" value="">
	</form>
	
	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="${classCode }">
		<input type="hidden" name="courseCode" value="${course.courseCode }">
		<input type="hidden" name="teacherId" value="${teacher.userId }">
	</form> 
	
</body>
</html>
