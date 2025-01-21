<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/board/noticeList.css" rel="stylesheet">
<style>
.header {
	background-color: #CF99C7;
}
</style>
<script>

	$(document).ready(function() {
		$("#btnSearch").on("click", function() {
		
		 document.bbsForm.brdSeq.value = "";
		 document.bbsForm.searchType.value = $("#_searchType").val();
		 document.bbsForm.searchValue.value = $("#_searchValue").val();
		 document.bbsForm.curPage.value = "1";
		 document.bbsForm.action = "/board/noticeList";
		 document.bbsForm.submit();
		 
		 
		});
	});


	$(function() {
		$("#navmenu>ul>li:nth-child(3)>a").addClass("active");
	});

	/* 글 상세보기 */
	function fn_view(brdSeq) {
        document.bbsForm.brdSeq.value = brdSeq;
        document.bbsForm.action = "/board/noticeView";
        document.bbsForm.submit();
	}

	/* 글작성 */
	function fn_write(boardType){

	   document.bbsForm.brdSeq.value = "";
	   document.bbsForm.action = "/board/noticeWrite";
	   document.bbsForm.submit();
	
	}
	
	/* 리스트 */
	function fn_listview(curPage) {
		document.bbsForm.curPage.value = curPage;
		document.bbsForm.brdSeq.value = "";
		document.bbsForm.action = "/board/noticeList";
		document.bbsForm.submit();
	}
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<section class="notice-section">
		<div class="notice-content">
			<div class="notice-text">
				<h1 class="mainTitle">Notice</h1>
				<p class="mainContent">공지사항</p>
			</div>
			<div class="notice-image">
				<img src="/resources/img/notice1.png" alt="Clover Image">
				<!--  <img src="/resources/img/notice2.png" alt="Clover Image"> -->
			</div>
		</div>
	</section>

	<section class="content-section">
		<div class="sidebar">
			<div class="exam-date" id="d-day-display">
				2026 수능 <span class="days"></span>
			</div>
			<ul class="menu">
				<li><a href="/board/noticeList" class="highlight">공지사항</a></li>
				<li><a href="/board/qnaList">문의사항</a></li>
				<li><a href="/board/freeList">자유게시판</a><br></li>
				<li><a href="/board/faqList">자주 묻는 질문</a></li>
			</ul>
		</div>
		<div class="table-container">
			<h2 class="subTitle">공지사항</h2>
			<table>
				<thead>
					<tr>
						<th style="width: 15%;">번호</th>
						<th style="width: 50%;">제목</th>
						<th style="width: 20%;">등록일</th>
						<th style="width: 15%;">조회수</th>
					</tr>
				</thead>
		<tbody>
		    <!-- 필독 공지사항 -->
	        <c:if test='${!empty mustList}'>
				<c:set var="count" value="0"/>
				<c:forEach var="noticeBoard" items="${mustList}">
				    <c:if test="${empty noticeBoard.delDate}">
				        <c:if test="${count lt 3}">
				            <tr style="background-color: #f9f9f9; cursor: pointer;" onclick="fn_view(${noticeBoard.brdSeq})">
				                <td><div class="circle">필독</div></td>
				                <td>${noticeBoard.brdTitle}</td>
				                <td>${noticeBoard.modDate}</td>
				                <td>${noticeBoard.brdReadCnt}</td>
				            </tr>
				            <c:set var="count" value="${count + 1}"/>
				        </c:if>
				    </c:if>
				</c:forEach>
	        </c:if>
		    
		    <!-- 일반 공지사항 -->
		    <c:if test='${!empty list}'>
		    <c:set var="brdSeq" value="${paging.startNum + 1}"/>
		        <c:forEach var="noticeBoard" items="${list}" varStatus="status">
		        <c:set var="brdSeq" value="${brdSeq - 1}" /> 
		        <c:if test="${empty noticeBoard.delDate}">
		            <tr onclick="fn_view(${noticeBoard.brdSeq})" style="cursor: pointer">
		                <td>${brdSeq}</td>
		                <td>${noticeBoard.brdTitle}</td>
		                <td>${noticeBoard.modDate}</td>
		                <td>${noticeBoard.brdReadCnt}</td>
		            </tr>
		            </c:if>
		        </c:forEach>
		    </c:if>

		    <!-- 공지글이 없을 경우 -->
		    <c:if test='${empty list && empty mustList}'>
		        <tr>
		            <td colspan="5">작성된 공지글이 없습니다.</td>
		        </tr>
		    </c:if>
		</tbody>



			</table>
			<c:if test="${admin.rating == 'A'}">
				<div class="freeWrite-container">
					<button class="free-write-button" onclick="fn_write()">글쓰기</button>
				</div>
			</c:if>



			<div class="pagination">
				<c:if test="${!empty paging}">

					<c:if test="${paging.prevBlockPage gt 0}">
						<button class="pagination-button" href="#" onclick="fn_listview(${paging.prevBlockPage})">&laquo;</button>
					</c:if>


					<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
						<c:choose>
							<c:when test="${i eq curPage}">
								<span class="pagination-number active">${i}</span>
							</c:when>
							<c:otherwise>
								<span class="pagination-number"><a class="page-link" href="#" onclick="fn_listview(${i})">${i}</a></span>
							</c:otherwise>
						</c:choose>
						<c:if test="${i lt paging.endPage}">
							<span class="pagination-separator">|</span>
						</c:if>
					</c:forEach>


					<c:if test="${paging.nextBlockPage gt 0}">
						<button class="pagination-button" href="#" onclick="fn_listview(${paging.nextBlockPage})">&raquo;</button>
					</c:if>

				</c:if>
			</div>





			<div class="search-container">
				<select class="form-select" id="_searchType">
					<option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>제목</option>
					<option value="2" <c:if test='${searchType eq "2"}'>selected</c:if>>내용</option>
				</select>
				<div class="input-select">
					<input type="text" class="form-control" id="_searchValue" placeholder="검색할 단어를 입력하세요." value="${searchValue}" aria-label="Recipient's username" aria-describedby="button-addon2">
					<button type="button" id="btnSearch" style="cursor: pointer">
						<img alt="검색 버튼" src="/resources/img/search.png" style="height: 22px;">
					</button>
				</div>
			</div>
		</div>
	</section>
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
	
    <form name="bbsForm" id="bbsForm" method="POST">
  		
   	  	 <input type="hidden" name="brdSeq" value="">
   		 <input type="hidden" name="searchType" value="${searchType}">
   		 <input type="hidden" name="searchValue" value="${searchValue}">
   		 <input type="hidden" name="curPage" value="${curPage}">
   		
    </form>
	
</body>
</html>
